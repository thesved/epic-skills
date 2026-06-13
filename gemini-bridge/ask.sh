#!/usr/bin/env bash
# Gemini seat (one-shot REST query) - used by /board and ad-hoc key-backed asks.
# Resolves the key via lib.sh (env → ~/.zshrc → keychain), so it works in the
# keychain-only setup where the session env has no GEMINI_API_KEY.
# Model = $BOARD_GEMINI_MODEL or the self-updating alias `gemini-flash-latest`
# (tracks newest flash - no pinned version to drift). Briefing from $1 (a file) or stdin.
#   bash gemini/ask.sh /tmp/brief        |        echo "…" | bash gemini/ask.sh
set -uo pipefail
SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; . "$SELF/../_model-cache/lib.sh"
key="$(resolve_key GEMINI_API_KEY)"
[ -z "$key" ] && { echo "Gemini seat ERR: no key (keychain gemini-api-key / env GEMINI_API_KEY)"; exit 1; }
model="${BOARD_GEMINI_MODEL:-gemini-flash-latest}"
if [ -n "${1:-}" ] && [ -f "$1" ]; then brief="$(cat "$1")"; else brief="$(cat)"; fi
curl -s "https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=$key" \
  -H 'content-type: application/json' \
  -d "$(jq -n --arg p "$brief" '{contents:[{parts:[{text:$p}]}]}')" \
  | jq -r '.candidates[0].content.parts[0].text // ("Gemini seat ERR: " + (.error.message // "no text returned"))'
