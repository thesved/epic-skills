#!/usr/bin/env bash
# tts-wait.sh - Gemini TTS with EXACT pauses, prosody preserved.
#
# Sends the FULL text to Gemini in one shot (so context, intonation, and
# rhythm are unbroken), but rewrites every [wait N sec] tag to a uniform
# [wait 10 sec] marker. Gemini caps wait silences at ~3.8 s, so every marker
# produces a clearly-detectable silence. We then run ffmpeg `silencedetect`
# on the result, find those silences, and splice in the exact requested
# durations.
#
# Usage:
#   tts-wait.sh --out out.wav --text 'Breathe in. [wait 8 sec] And out.'
#   tts-wait.sh --voice Gacrux --out out.wav --file script.txt
#   echo 'A line. [wait 12 sec] Next line.' | tts-wait.sh --out out.wav
#
# Accepted wait syntaxes (case-insensitive, integer or decimal seconds):
#   [wait 5 sec]  [wait 5sec]  [wait 5 seconds]  [wait 5s]  [wait 5]
#
# Flags:
#   --voice NAME        Gemini prebuilt voice (default: Kore)
#   --out PATH          output WAV (required)
#   --text STR          inline script
#   --file PATH         script from file
#   --model ID          override TTS model
#   --silence-db DB     silence threshold for detection (default: -40dB)
#   --silence-min SEC   min silence duration to count as marker (default: 2.0)
#   --keep-tmp          keep tmp dir for debugging
#
# Requires: curl, jq, ffmpeg, ffprobe, python3, bc, and an API key in keychain
# under service "gemini-api-key" for account $USER.

set -euo pipefail

VOICE="Kore"
OUT=""
TEXT=""
FILE=""
MODEL="gemini-3.1-flash-tts-preview"
MARKER_TAG="[wait 10 sec]"
SILENCE_DB="-40dB"
SILENCE_MIN="2.0"
KEEP_TMP=0

usage() { sed -n '2,33p' "$0" | sed 's/^# \{0,1\}//'; exit 1; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --voice)        VOICE="$2"; shift 2 ;;
    --out)          OUT="$2"; shift 2 ;;
    --text)         TEXT="$2"; shift 2 ;;
    --file)         FILE="$2"; shift 2 ;;
    --model)        MODEL="$2"; shift 2 ;;
    --silence-db)   SILENCE_DB="$2"; shift 2 ;;
    --silence-min)  SILENCE_MIN="$2"; shift 2 ;;
    --keep-tmp)     KEEP_TMP=1; shift ;;
    -h|--help)      usage ;;
    *) echo "unknown arg: $1" >&2; usage ;;
  esac
done

[[ -z "$OUT" ]] && { echo "--out required" >&2; exit 2; }

if [[ -n "$FILE" ]]; then
  TEXT="$(cat "$FILE")"
elif [[ -z "$TEXT" ]]; then
  if [[ ! -t 0 ]]; then
    TEXT="$(cat)"
  else
    echo "provide --text, --file, or pipe text on stdin" >&2
    exit 2
  fi
fi

for bin in curl jq ffmpeg ffprobe python3 bc; do
  command -v "$bin" >/dev/null || { echo "$bin not installed" >&2; exit 3; }
done

KEY=$(security find-generic-password -a "$USER" -s "gemini-api-key" -w 2>/dev/null || true)
[[ -z "$KEY" ]] && { echo "gemini-api-key not in keychain" >&2; exit 4; }

TMP=$(mktemp -d -t tts-wait)
trap '[[ $KEEP_TMP -eq 0 ]] && rm -rf "$TMP"' EXIT

# --- Step 1: parse out waits.
# Leading + trailing waits don't survive TTS reliably (Gemini drops them when
# there's no surrounding speech), so split into leading/inner/trailing and
# only round-trip the inner ones through TTS + marker + silencedetect.
python3 - "$TEXT" "$MARKER_TAG" > "$TMP/parsed.json" <<'PY'
import re, sys, json
text, marker = sys.argv[1], sys.argv[2]
wait_pat = re.compile(r'\[\s*wait\s+(\d+(?:\.\d+)?)\s*(?:s|sec|secs|second|seconds)?\s*\]', re.IGNORECASE)
# Walk all waits; classify by whether non-whitespace speech exists before/after.
matches = list(wait_pat.finditer(text))
leading, trailing, inner = [], [], []
inner_spans = []
# Determine leading: contiguous waits at the start with only whitespace before each.
i = 0
cursor = 0
while i < len(matches):
    m = matches[i]
    pre = text[cursor:m.start()]
    if pre.strip() == "":
        leading.append(float(m.group(1)))
        cursor = m.end()
        i += 1
    else:
        break
# Determine trailing: contiguous waits at the end with only whitespace after each.
j = len(matches) - 1
tail_cursor = len(text)
trailing_rev = []
while j >= i:
    m = matches[j]
    post = text[m.end():tail_cursor]
    if post.strip() == "":
        trailing_rev.append(float(m.group(1)))
        tail_cursor = m.start()
        j -= 1
    else:
        break
trailing = list(reversed(trailing_rev))
# Inner = remaining matches between i and j inclusive.
inner_matches = matches[i:j+1]
for m in inner_matches:
    inner.append(float(m.group(1)))
# Build rewritten text: from cursor (after leading) to tail_cursor (before trailing),
# replacing each inner wait with the marker.
body = text[cursor:tail_cursor]
def repl(m):
    return marker
rewritten = wait_pat.sub(repl, body).strip()
print(json.dumps({
    "leading": leading,
    "inner": inner,
    "trailing": trailing,
    "rewritten": rewritten
}))
PY

REWRITTEN=$(jq -r '.rewritten' "$TMP/parsed.json")
LEADING=()
while IFS= read -r _d; do [[ -n "$_d" ]] && LEADING+=("$_d"); done < <(jq -r '.leading[]' "$TMP/parsed.json")
DURATIONS=()
while IFS= read -r _d; do [[ -n "$_d" ]] && DURATIONS+=("$_d"); done < <(jq -r '.inner[]' "$TMP/parsed.json")
TRAILING=()
while IFS= read -r _d; do [[ -n "$_d" ]] && TRAILING+=("$_d"); done < <(jq -r '.trailing[]' "$TMP/parsed.json")
NUM_WAITS=${#DURATIONS[@]}
NUM_LEADING=${#LEADING[@]}
NUM_TRAILING=${#TRAILING[@]}

# --- Step 2: single TTS call with full context.
RAW="$TMP/raw.wav"
curl -s -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent?key=$KEY" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg t "$REWRITTEN" --arg v "$VOICE" '{
    contents:[{parts:[{text:$t}]}],
    generationConfig:{
      responseModalities:["AUDIO"],
      speechConfig:{voiceConfig:{prebuiltVoiceConfig:{voiceName:$v}}}
    }
  }')" > "$TMP/resp.json"

REASON=$(jq -r '.candidates[0].finishReason // "n/a"' "$TMP/resp.json")
if [[ "$REASON" != "STOP" ]]; then
  echo "TTS failed (finishReason=$REASON)" >&2
  jq -r '.error.message // empty' "$TMP/resp.json" >&2
  exit 5
fi

jq -r '.candidates[0].content.parts[0].inlineData.data' "$TMP/resp.json" \
| base64 -d \
| ffmpeg -nostdin -y -f s16le -ar 24000 -ac 1 -i pipe:0 "$RAW" 2>/dev/null

# helper: ensure float has leading digit
fnum() { printf '%.6f' "$1"; }

# helper: emit a silent WAV of N seconds, append path to a concat file
emit_silence() {
  local secs="$1" path="$2" listfile="$3"
  ffmpeg -nostdin -y -f lavfi -i "anullsrc=r=24000:cl=mono" -t "$(fnum "$secs")" -c:a pcm_s16le "$path" 2>/dev/null
  printf "file '%s'\n" "$path" >> "$listfile"
}

> "$TMP/concat.txt"

# Leading silences first
li=0
for d in "${LEADING[@]:-}"; do
  [[ -z "$d" ]] && continue
  emit_silence "$d" "$TMP/lead_$(printf '%03d' $li).wav" "$TMP/concat.txt"
  li=$((li+1))
done

# Short-circuit: no inner waits → just the raw TTS in the middle.
if [[ $NUM_WAITS -eq 0 ]]; then
  printf "file '%s'\n" "$RAW" >> "$TMP/concat.txt"
  # then trailing
  ti=0
  for d in "${TRAILING[@]:-}"; do
    [[ -z "$d" ]] && continue
    emit_silence "$d" "$TMP/trail_$(printf '%03d' $ti).wav" "$TMP/concat.txt"
    ti=$((ti+1))
  done
  ffmpeg -nostdin -y -f concat -safe 0 -i "$TMP/concat.txt" -c:a pcm_s16le -ar 24000 -ac 1 "$OUT" 2>/dev/null
  DUR=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$OUT")
  echo "wrote $OUT (${DUR}s, 0 inner / $NUM_LEADING lead / $NUM_TRAILING trail waits, voice=$VOICE)"
  exit 0
fi

# --- Step 3: detect silences.
ffmpeg -nostdin -i "$RAW" -af "silencedetect=noise=${SILENCE_DB}:d=${SILENCE_MIN}" -f null - 2> "$TMP/silences.log"

python3 - "$TMP/silences.log" > "$TMP/silences.tsv" <<'PY'
import re, sys
log = open(sys.argv[1]).read()
# silencedetect emits paired "silence_start: X" then "silence_end: Y | silence_duration: Z".
# Walk the log in order, pairing them.
starts, ends = [], []
for line in log.splitlines():
    m1 = re.search(r'silence_start:\s+([0-9.]+)', line)
    m2 = re.search(r'silence_end:\s+([0-9.]+)\s*\|\s*silence_duration:\s+([0-9.]+)', line)
    if m1:
        starts.append(float(m1.group(1)))
    elif m2:
        ends.append((float(m2.group(1)), float(m2.group(2))))
for i, s in enumerate(starts):
    if i < len(ends):
        e, d = ends[i]
        print(f"{s}\t{e}\t{d}")
PY

DETECTED=$(wc -l < "$TMP/silences.tsv" | tr -d ' ')

if [[ "$DETECTED" -ne "$NUM_WAITS" ]]; then
  echo "WARNING: requested $NUM_WAITS waits, detected $DETECTED silences ≥ ${SILENCE_MIN}s at ${SILENCE_DB}." >&2
  echo "  Likely causes: adjacent waits collapsed by the model, or threshold mistuned." >&2
  echo "  Adjust with --silence-db / --silence-min. Log: $TMP/silences.log" >&2
fi

# --- Step 4: splice. Walk raw audio, replacing each detected silence with the
# requested duration, in order. Extra detected silences keep their natural
# duration; extra requested durations are ignored.
> "$TMP/concat.txt"
RAW_DUR=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$RAW")

i=0
PREV_END=0
while IFS=$'\t' read -r S_START S_END S_DUR <&3; do
  # speech chunk before this silence
  if [[ $(echo "$S_START > $PREV_END" | bc -l) -eq 1 ]]; then
    spk="$TMP/spk_$(printf '%03d' $i).wav"
    DUR_SPK=$(fnum "$(echo "$S_START - $PREV_END" | bc -l)")
    ffmpeg -nostdin -y -ss "$(fnum "$PREV_END")" -t "$DUR_SPK" -i "$RAW" -c:a pcm_s16le "$spk" 2>/dev/null
    printf "file '%s'\n" "$spk" >> "$TMP/concat.txt"
  fi
  # replacement silence (or natural duration if we ran out of requested durations)
  if [[ $i -lt $NUM_WAITS ]]; then
    REQ_DUR="${DURATIONS[$i]}"
  else
    REQ_DUR="$S_DUR"
  fi
  emit_silence "$REQ_DUR" "$TMP/sil_$(printf '%03d' $i).wav" "$TMP/concat.txt"
  PREV_END="$S_END"
  i=$((i+1))
done 3< "$TMP/silences.tsv"

# trailing speech (the speech AFTER the last inner silence)
if [[ $(echo "$RAW_DUR > $PREV_END" | bc -l) -eq 1 ]]; then
  spk="$TMP/spk_tail.wav"
  DUR_SPK=$(fnum "$(echo "$RAW_DUR - $PREV_END" | bc -l)")
  ffmpeg -nostdin -y -ss "$(fnum "$PREV_END")" -t "$DUR_SPK" -i "$RAW" -c:a pcm_s16le "$spk" 2>/dev/null
  printf "file '%s'\n" "$spk" >> "$TMP/concat.txt"
fi

# Trailing silences (from [wait N sec] tags at the end of the script)
ti=0
for d in "${TRAILING[@]:-}"; do
  [[ -z "$d" ]] && continue
  emit_silence "$d" "$TMP/trail_$(printf '%03d' $ti).wav" "$TMP/concat.txt"
  ti=$((ti+1))
done

ffmpeg -nostdin -y -f concat -safe 0 -i "$TMP/concat.txt" -c:a pcm_s16le -ar 24000 -ac 1 "$OUT" 2>/dev/null

FINAL_DUR=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$OUT")
echo "wrote $OUT (${FINAL_DUR}s, $NUM_WAITS inner / $NUM_LEADING lead / $NUM_TRAILING trail waits, $DETECTED inner detected, voice=$VOICE)"
[[ $KEEP_TMP -eq 1 ]] && echo "tmp kept: $TMP"
exit 0
