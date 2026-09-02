#!/usr/bin/env bash
# Gemini seat (one-shot text query) - used by /board and ad-hoc asks.
# Route (GEMINI_ROUTE): openrouter (default) | google
#   openrouter: chat/completions on OpenRouter, model google/gemini-3.7-flash (override BOARD_GEMINI_MODEL),
#               key = $OPENROUTER_API_KEY / keychain `openrouter-api-key`. Works when the Google prepaid balance is empty.
#   google:     generateContent direct, model gemini-flash-latest, key = $GEMINI_API_KEY / keychain `gemini-api-key`.
# Briefing from $1 (a file) or stdin:   bash ask.sh /tmp/brief   |   echo "..." | bash ask.sh
set -uo pipefail
SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; . "$SELF/../_model-cache/lib.sh"
if [ -n "${1:-}" ] && [ -f "$1" ]; then brief="$(cat "$1")"; else brief="$(cat)"; fi
ROUTE="${GEMINI_ROUTE:-openrouter}"
if [ "$ROUTE" = "openrouter" ]; then
  key="$(resolve_key OPENROUTER_API_KEY)"
  [ -z "$key" ] && { echo "Gemini seat ERR: no OpenRouter key (keychain openrouter-api-key / env OPENROUTER_API_KEY)"; exit 1; }
  model="${BOARD_GEMINI_MODEL:-google/gemini-3.7-flash}"; case "$model" in */*) ;; *) model="google/${model}" ;; esac
  body="$(jq -n --arg p "$brief" --arg m "$model" '{model:$m, messages:[{role:"user", content:$p}]}')"
  attempt=0
  while :; do
    attempt=$((attempt+1))
    resp="$(curl -s --max-time "${OPENROUTER_TIMEOUT:-600}" -w $'\n%{http_code}' https://openrouter.ai/api/v1/chat/completions \
      -H "Authorization: Bearer ${key}" -H 'content-type: application/json' \
      -H 'HTTP-Referer: https://claude.ai/code' -H 'X-Title: gemini-bridge ask.sh' -d "$body")"
    code="${resp##*$'\n'}"; out="${resp%$'\n'*}"
    if { [ "$code" = 429 ] || [ "$code" = 000 ] || { [ "$code" -ge 500 ] 2>/dev/null; }; } && [ "$attempt" -lt 4 ]; then
      delay=$((attempt*attempt*5)); echo "[ask.sh: openrouter http $code, retry $attempt in ${delay}s]" >&2; sleep "$delay"; continue
    fi
    break
  done
  printf '%s' "$out" | jq -r '.choices[0].message.content // ("Gemini seat ERR: " + (.error.message // "no text returned"))'
  exit 0
fi
key="$(resolve_key GEMINI_API_KEY)"
[ -z "$key" ] && { echo "Gemini seat ERR: no key (keychain gemini-api-key / env GEMINI_API_KEY)"; exit 1; }
model="${BOARD_GEMINI_MODEL:-gemini-flash-latest}"; model="${model#google/}"
curl -s "https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=$key" \
  -H 'content-type: application/json' \
  -d "$(jq -n --arg p "$brief" '{contents:[{parts:[{text:$p}]}]}')" \
  | jq -r '.candidates[0].content.parts[0].text // ("Gemini seat ERR: " + (.error.message // "no text returned"))'
