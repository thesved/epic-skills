#!/usr/bin/env bash
# conv.sh - multi-turn conversations on OpenRouter (persisted message history).
# The API is stateless: NO mid-generation steering exists. This is the honest
# equivalent of "messaging a sub-agent" for REST models: every turn boundary is a
# steering point; full history is re-sent (and re-billed; prefer cache-read models).
#
#   conv.sh new <name> [-m provider/model] [prompt-file]    (stdin fallback)
#   conv.sh msg <name> [prompt-file]                        follow-up turn, context kept
#   conv.sh show <name>                                     print the conversation
#   conv.sh ls                                              list conversations
#   conv.sh rm <name>                                       delete a conversation
#
# State: $OPENROUTER_CONV_HOME (default ~/.openrouter-conv)/<name>/
#   conv.json  = the full messages array (source of truth)
#   meta.json  = model
#   rN.json    = raw response per turn (diagnose with jq: finish_reason, usage)
set -uo pipefail
SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; . "$SELF/../_model-cache/lib.sh"
BASE="${OPENROUTER_CONV_HOME:-$HOME/.openrouter-conv}"

usage() { sed -n '2,17p' "$0" | sed 's/^# \{0,1\}//'; exit 1; }
[ $# -ge 1 ] || usage
cmd="$1"; shift || true

read_brief() { if [ -n "${1:-}" ] && [ -f "$1" ]; then cat "$1"; else cat; fi; }

post_turn() { # post_turn <dir>  -> appends assistant reply to conv.json, prints it
  local d="$1" key model n resp content fin
  key="$(resolve_key OPENROUTER_API_KEY)"
  [ -z "$key" ] && { echo "ERR: no key (keychain openrouter-api-key / env OPENROUTER_API_KEY)"; return 1; }
  model="$(jq -r .model "$d/meta.json")"
  n="$(ls "$d"/r*.json 2>/dev/null | wc -l | tr -d ' ')"; n=$((n + 1))
  resp="$(jq -n --arg m "$model" --slurpfile msgs "$d/conv.json" '{model:$m,messages:$msgs[0]}' \
    | curl -s --max-time "${OPENROUTER_TIMEOUT:-300}" \
        https://openrouter.ai/api/v1/chat/completions \
        -H "Authorization: Bearer $key" -H 'content-type: application/json' \
        -H 'HTTP-Referer: https://claude.ai/code' -H 'X-Title: conv' \
        ${OPENROUTER_PROXY:+--proxy "$OPENROUTER_PROXY"} -d @-)"
  printf '%s' "$resp" > "$d/r$n.json"
  content="$(jq -r '.choices[0].message.content // empty' <<<"$resp" 2>/dev/null)"
  if [ -z "${content//[[:space:]]/}" ]; then
    echo "ERR turn $n: empty content. Raw error: $(jq -r '.error.message // "none"' <<<"$resp" 2>/dev/null) (full: $d/r$n.json)"
    return 1
  fi
  fin="$(jq -r '.choices[0].finish_reason // "n/a"' <<<"$resp")"
  # append assistant reply only after a good response, so a failed turn is retryable
  jq --arg a "$content" '. += [{role:"assistant",content:$a}]' "$d/conv.json" > "$d/.c.tmp" \
    && mv "$d/.c.tmp" "$d/conv.json"
  echo "[conv: turn=$n model=$model finish=$fin]" >&2
  printf '%s\n' "$content"
}

case "$cmd" in
new)
  name="${1:?name}"; shift
  model="${OPENROUTER_MODEL:-z-ai/glm-5.2}"
  if [ "${1:-}" = "-m" ]; then model="${2:?-m needs provider/model}"; shift 2; fi
  d="$BASE/$name"
  [ -f "$d/conv.json" ] && { echo "ERR: conversation '$name' exists (conv.sh rm $name first, or msg to continue)"; exit 1; }
  mkdir -p "$d"
  jq -n --arg m "$model" '{model:$m}' > "$d/meta.json"
  read_brief "${1:-}" | jq -Rs '[{role:"user",content:.}]' > "$d/conv.json"
  post_turn "$d";;
msg)
  name="${1:?name}"; shift
  d="$BASE/$name"
  [ -f "$d/conv.json" ] || { echo "ERR: no conversation '$name' (conv.sh new first)"; exit 1; }
  read_brief "${1:-}" | jq -Rs --slurpfile c "$d/conv.json" '$c[0] + [{role:"user",content:.}]' > "$d/.c.tmp" \
    && mv "$d/.c.tmp" "$d/conv.json"
  post_turn "$d";;
show)
  d="$BASE/${1:?name}"
  jq -r '.[] | "== \(.role) ==\n\(.content)\n"' "$d/conv.json" 2>/dev/null || { echo "no such conversation"; exit 1; };;
ls)
  [ -d "$BASE" ] || { echo "(none)"; exit 0; }
  found=0
  for m in "$BASE"/*/meta.json; do
    [ -f "$m" ] || continue; found=1
    d="$(dirname "$m")"
    echo "$(basename "$d")  model=$(jq -r .model "$m")  msgs=$(jq length "$d/conv.json")"
  done
  [ "$found" = 1 ] || echo "(none)";;
rm)
  d="$BASE/${1:?name}"
  [ -d "$d" ] || { echo "no such conversation"; exit 1; }
  rm -rf "$d"; echo "removed";;
*) usage;;
esac
