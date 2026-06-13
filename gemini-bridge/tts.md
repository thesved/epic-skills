# Gemini TTS - spoken audio generation

Full reference for the `tts` mode. The main [SKILL.md](SKILL.md) has a short entry that points here.

Model: `gemini-3.1-flash-tts-preview` (Gemini 3.1 Flash TTS, public preview as of May 2026 - re-verify model ID at https://ai.google.dev/gemini-api/docs/models since preview IDs change).

**What it does**: text → spoken audio. 70+ languages, 30 prebuilt voices, up to 2 speakers per call, inline audio tags for emotion/delivery (`[whispers]`, `[excited]`, etc.). Auto-watermarked with SynthID.

**What it doesn't do**: streaming, voice cloning, audio-in (transcription - use `video` mode or Whisper for that), long-form narration (quality drifts past a few minutes - chunk long scripts).

---

## Prerequisite - API key in keychain

TTS requires `GEMINI_API_KEY` (the OAuth/personal-login tier does NOT include TTS - same constraint as image gen). One-time setup (key from https://aistudio.google.com/apikey):

```bash
security add-generic-password -a "$USER" -s "gemini-api-key" -w "PASTE-KEY-HERE"
```

The Gemini CLI also does NOT drive TTS endpoints - hit the REST API with `curl`, same pattern as image gen.

---

## Audio format

Response MIME: `audio/l16; rate=24000; channels=1` - raw signed 16-bit little-endian PCM at 24 kHz mono.

Saving options:

- **WAV via ffmpeg** (most reliable, ffmpeg on most dev machines): wrap PCM in WAV header (`-f s16le -ar 24000 -ac 1`).
- **WAV via pure-shell**: prepend a 44-byte WAV header (see "No-ffmpeg fallback" below).
- **MP3**: pipe ffmpeg to `-codec:a libmp3lame -b:a 128k file.mp3`.
- **Play directly on macOS**: `afplay file.wav` after conversion (afplay won't play raw PCM).

---

## Single-speaker - copy-paste pattern

```bash
KEY=$(security find-generic-password -a "$USER" -s "gemini-api-key" -w 2>/dev/null)
TEXT="Say cheerfully: have a wonderful day!"
VOICE="Kore"        # see voice list below
OUT="/tmp/speech.wav"

curl -s -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-tts-preview:generateContent?key=$KEY" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg t "$TEXT" --arg v "$VOICE" '{
    contents:[{parts:[{text:$t}]}],
    generationConfig:{
      responseModalities:["AUDIO"],
      speechConfig:{voiceConfig:{prebuiltVoiceConfig:{voiceName:$v}}}
    }
  }')" \
| jq -r '.candidates[0].content.parts[0].inlineData.data' \
| base64 -d \
| ffmpeg -y -f s16le -ar 24000 -ac 1 -i pipe:0 "$OUT" 2>/dev/null

file "$OUT"   # → RIFF ... WAVE audio, Microsoft PCM, 16 bit, mono 24000 Hz
```

For prompts with quotes/newlines, use `jq -n --arg t "$TEXT" …` (above) - avoids shell-escape pain.

---

## Multi-speaker (up to 2 speakers)

Prefix each line with the speaker label. Assign a voice per speaker in `multiSpeakerVoiceConfig`.

```bash
KEY=$(security find-generic-password -a "$USER" -s "gemini-api-key" -w 2>/dev/null)
PROMPT='TTS the following conversation between Joe and Jane:
Joe: How is it going today Jane?
Jane: Not too bad, how about you?'

curl -s -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-tts-preview:generateContent?key=$KEY" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg p "$PROMPT" '{
    contents:[{parts:[{text:$p}]}],
    generationConfig:{
      responseModalities:["AUDIO"],
      speechConfig:{
        multiSpeakerVoiceConfig:{
          speakerVoiceConfigs:[
            {speaker:"Joe",  voiceConfig:{prebuiltVoiceConfig:{voiceName:"Kore"}}},
            {speaker:"Jane", voiceConfig:{prebuiltVoiceConfig:{voiceName:"Puck"}}}
          ]
        }
      }
    }
  }')" \
| jq -r '.candidates[0].content.parts[0].inlineData.data' \
| base64 -d \
| ffmpeg -y -f s16le -ar 24000 -ac 1 -i pipe:0 /tmp/dialog.wav 2>/dev/null
```

Speaker labels in the text MUST match the `speaker` field in the config. Max 2 speakers.

---

## Inline audio tags (steer delivery mid-sentence)

Drop tags into the text in square brackets - Gemini reads them as direction, not narration.

**Important - bracket tags accept arbitrary natural-language descriptors.** Google's docs explicitly say: *"There is no exhaustive list on what tags do and don't work."* Treat the list below as a starter set of confirmed-working tags, not an enum. Composite descriptors work too: `[sarcastically, one painfully slow word at a time]`, `[deep and loud shouting]`, `[like dracula]`.

**Emotion / mood**: `[amazed]` `[crying]` `[curious]` `[excited]` `[sighs]` `[gasp]` `[giggles]` `[laughs]` `[mischievously]` `[panicked]` `[sarcastic]` `[serious]` `[shouting]` `[tired]` `[trembling]` `[whispers]`

**Pacing** (confirmed on Cloud TTS Gemini docs): `[slow]` `[fast]` `[very slow]` `[very slowly]` `[very fast]` `[extremely fast]` `[short pause]` `[medium pause]` `[long pause]`

**Style** (LiveKit + community-validated - these reportedly produce **stronger** prosody than literal emotion tags): `[warmly]` `[thoughtfully]` `[gently]` `[cheerfully]` `[soft laugh]` `[asmr]`

**Non-speech**: `[cough]` `[uhm]` `[sigh]` `[laughing]`

**Format / register** (community-reported, less reliable - test first): `[newscast]` `[documentary]` `[conversational]` `[formal]` `[emphasis]`

**Examples:**

```
[whispers] Don't tell anyone. [excited] But this is huge!

[gently] Notice your breath. [long pause] And again.

[deep, resonant, slow] Welcome back to the practice.
```

**Prose prefix vs. inline tags.** You can describe delivery in prose at the start ("Speak in a deep, resonant, low register, like a meditation guide. Tempo is incredibly slow and liquid. Words bleed into each other.") - Gemini follows it. Combine prose prefix (sets overall delivery) with inline tags (steer specific moments) for fine control. **Avoid negative or flatness instructions** like "monotone", "no rush", "flat" - community testing reports they actively degrade output. Use positive descriptors only ("slow", "deep", "warm", "deliberate").

---

## Pauses - `[wait X sec]`

For deliberate silences (meditations, dramatic beats, instructional gaps), use `[wait X sec]` inline. Measured on Gacrux, May 2026:

| Tag | Actual pause inserted |
|---|---|
| `[wait 2 sec]` | ~1.0 s |
| `[wait 5 sec]` | ~3.5 s |
| `[wait 10 sec]` | ~3.8 s (capped) |

Caveats:
1. **Pauses come out ~50-70% of what you ask for.** Over-ask: write `[wait 5 sec]` to get ~3 s.
2. **Hard ceiling around 4 s per tag.** `[wait 10 sec]` produces no more silence than `[wait 5 sec]`.

For **exact** pauses (and pauses longer than ~4 s) use the wrapper script `tts-wait.sh` next to this file. It:

1. Rewrites every `[wait N sec]` in the input to a uniform `[wait 10 sec]` marker (Gemini's cap, ~3.8 s - easy to find).
2. Sends the **full text in one TTS call**, so prosody, intonation, and context are preserved (no chunk seams).
3. Runs `ffmpeg silencedetect` on the output, finds each marker silence, and splices in the exact requested duration.
4. Strips **leading** and **trailing** `[wait]` tags before the TTS call (Gemini drops them when there's no surrounding speech) and appends/prepends them as pure silence post-hoc.

Usage:

```bash
~/.claude/skills/gemini-bridge/tts-wait.sh \
  --voice Gacrux \
  --out /tmp/out.wav \
  --text 'Breathe in. [wait 8 sec] Breathe out. [wait 8 sec] Notice your pulse. [wait 12 sec]'
```

Flags: `--voice`, `--out` (required), `--text` / `--file` / stdin, `--silence-db` (default `-40dB`), `--silence-min` (default `2.0`), `--keep-tmp`.

**Critical - silence threshold and word-cut artifacts.** The wrapper splices source audio at the detected silence boundary. If `--silence-db` is too loud (i.e. -30dB or -40dB), `silencedetect` catches the **trailing decay of words** as silence, and the splice cuts off the word's tail - producing audible chops before each long pause. Validated by sweeping a real meditation:

| Threshold | Silences detected ≥1s |
|---|---|
| -30dB | 27 (over-detects word decay) |
| -40dB | 23 (still catches some word tails) |
| -50dB | 19 |
| -60dB | 17 ← plateau (true silence only) |
| -70dB / -80dB | 17 (identical to -60dB) |

The flat plateau from -60dB down proves **Gemini TTS produces near-digital silence between phrases (hard zeros, no gradual fade).** So the right default for clean audio is `-60dB` - below that adds nothing, above that risks cutting word tails. **For meditation, somatic practice, or any script with long `[wait]` pauses, always use `--silence-db -60dB --silence-min 1.5`.** The default of -40dB is left in the script for legacy compatibility but produces audible cuts on quieter voices like Aoede.

Tuning when the script warns "requested N waits, detected M silences":
- **Too few detected** → lower `--silence-min` (try `1.0`) - model under-paused at some spots. Do NOT raise `--silence-db` toward -30dB to catch more - that's the cut-word trap.
- **Too many detected** → the wrapper picks silences in time order; extras keep their natural duration. Usually fine. If a specific extra is causing problems, raise `--silence-min`.
- Inspect `silences.log` in the tmp dir with `--keep-tmp`.

Limitation: adjacent waits (e.g. `[wait 5 sec][wait 5 sec]`) inside the body collapse into one silence in the TTS output - count mismatch will warn. Combine into a single `[wait 10 sec]` instead.

Ellipses (`……`) and paragraph breaks produce much shorter pauses (~0.3-0.8 s) - fine for natural rhythm, not enough for "let the listener actually do the practice."

---

## All 30 prebuilt voices

Pick by ear - there's no canonical "this voice = this style." Try 3-4 for any project.

```
Zephyr   Puck       Charon       Kore        Fenrir
Leda     Orus       Aoede        Callirrhoe  Autonoe
Enceladus Iapetus   Umbriel      Algieba     Despina
Erinome  Algenib    Rasalgethi   Laomedeia   Achernar
Alnilam  Schedar    Gacrux       Pulcherrima Achird
Zubenelgenubi Vindemiatrix Sadachbia Sadaltager Sulafat
```

Rough starting picks (based on community impressions, validate yourself):
- **Warm/friendly**: Kore, Aoede, Leda
- **Crisp/clear narrator**: Puck, Charon, Iapetus
- **Deep/serious**: Orus, Enceladus, Fenrir
- **Soft/quiet**: Despina, Achird, Sulafat

---

## Languages

70+ supported. Just write the text in the target language - no language flag needed. Confirmed working: en, es, fr, de, ja, cmn (Mandarin), ko, hi, ar, pt, ru, it, nl, pl, tr, hu, ro, sv, da, fi, no, cs, el, he, th, vi, id, ms, uk, bg, hr, sk, sl, lt, lv, et, ca, eu, gl, sr, mk, sq, mt, is, ga, cy, af, sw, zu, am, az, bn, bs, fa, fil, gu, hy, ka, kk, km, kn, lo, mn, mr, ms, my, ne, pa, si, sd, ta, te, ur, uz.

For non-English projects, also feed the text through `gemini write` mode first so the script reads naturally - TTS pronounces what's written, it doesn't fix awkward translations.

---

## No-ffmpeg fallback (pure shell WAV wrap)

If ffmpeg isn't available, prepend a WAV header manually (works for output ≤ 4 GB):

```bash
pcm_to_wav() {
  local pcm="$1" wav="$2"
  local size=$(stat -f%z "$pcm" 2>/dev/null || stat -c%s "$pcm")
  local riff=$((size + 36))
  python3 -c "
import struct, sys
size = $size
with open('$wav','wb') as f:
    f.write(b'RIFF' + struct.pack('<I', size+36) + b'WAVEfmt ')
    f.write(struct.pack('<IHHIIHH', 16, 1, 1, 24000, 48000, 2, 16))
    f.write(b'data' + struct.pack('<I', size))
    f.write(open('$pcm','rb').read())
"
}
# usage: pcm_to_wav /tmp/out.pcm /tmp/out.wav
```

---

## `generationConfig.speechConfig` - what's exposed

On the **Gemini API** endpoint (`generativelanguage.googleapis.com`, what this skill uses), only two fields exist:
- `voiceConfig.prebuiltVoiceConfig.voiceName` - single speaker
- `multiSpeakerVoiceConfig` - up to 2 speakers

That's it. `speakingRate`, `pitch`, `volumeGainDb`, `sampleRateHertz` are **NOT exposed** on the Gemini API. Output is always 24 kHz mono PCM. To slow speech: post-process with `ffmpeg -filter:a "atempo=0.85"` (preserves pitch). To change volume: `ffmpeg -filter:a "volume=1.5"`. To deepen pitch: `ffmpeg -filter:a "asetrate=20400,aresample=24000"` (drops pitch ~15%; experiment).

**If you need real per-utterance speed/pitch sliders**, use Google's **separate Cloud TTS Gemini-TTS endpoint** (`texttospeech.googleapis.com`, the `gemini-tts` voice family) - different API, different auth (Cloud project + service account), exposes `audioConfig.speakingRate`, `pitch`, `volumeGainDb`, `sampleRateHertz`. Not covered by this skill; only mentioned so you know the option exists when post-processing won't cut it.

**No SSML support** on the Gemini API. `<prosody>`, `<break time="3s"/>`, `<emphasis>` are ignored. Use inline bracket tags and `[wait N sec]` instead.

---

## Failure modes

- **`PERMISSION_DENIED` / `API key not valid`** → keychain entry missing or wrong. Re-check `security find-generic-password -a "$USER" -s "gemini-api-key" -w`.
- **`Model not found` / 404** → the preview model ID drifted. Check current IDs: `curl "https://generativelanguage.googleapis.com/v1beta/models?key=$KEY" | jq -r '.models[].name' | grep -i tts`.
- **Empty / silent audio** → the model probably refused (safety filter). Check `jq '.candidates[0].finishReason' /tmp/tts_resp.json` - `SAFETY` means content was blocked.
- **Audio sounds garbled / wrong speed** → wrong ffmpeg flags. MUST be `-f s16le -ar 24000 -ac 1`. The "44100" sample-rate default will play at ~half speed.
- **`afplay` won't play raw PCM** → expected, afplay needs a WAV header. Convert first.
- **Quality drifts after ~2 min of audio** → chunk long scripts: split by paragraph, call per chunk, concatenate WAVs with `ffmpeg -f concat`.
- **Output exceeds 16384 tokens** → model output cap. Chunk the input.

---

## Cost note

TTS is metered separately from text generation. Per-character pricing is roughly comparable to other Google TTS tiers; preview pricing may change. For batch jobs (audiobook chapters, hours of narration), check current pricing at https://ai.google.dev/pricing before kicking off a long run.

---

## See also

- `gemini` SKILL.md `image` mode - same keychain pattern, same "CLI doesn't drive this, use curl" constraint
- `gemini` SKILL.md `write` mode - generate the script in the target language first, THEN TTS it
- macOS built-in `say` command - instant, free, lower quality; fine for dev/debug, not for shipped audio
