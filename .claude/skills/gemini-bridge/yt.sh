#!/usr/bin/env bash
# yt.sh - analyze a YOUTUBE video (public URL) with Gemini via REST.
# Gemini ingests public YouTube URLs server-side through `fileData.fileUri`,
# no download, no upload. For LOCAL video files use video.sh (File API).
#
# Usage:
#   ./yt.sh <youtube-url> [question...]        # default model = Flash
#   GEMINI_MODEL=pro ./yt.sh <url> [q...]      # Pro (deep reasoning)
#   ./yt.sh <url> - <<EOF                      # question from stdin (heredoc-safe
#   long multi-line prompt...                  #  for big context blocks)
#   EOF
#
# Model selection (GEMINI_MODEL): flash (default) | pro | <exact-model-id>
# Auth: $GEMINI_API_KEY, else keychain `gemini-api-key` (via lib.sh).
set -euo pipefail

URL="${1:?usage: yt.sh <youtube-url> [question...]}"; shift || true
if [ "${1:-}" = "-" ]; then
  QUESTION="$(cat)"
else
  QUESTION="${*:-Summarize this video in 5 bullets. Note total duration and MM:SS timestamps for the key moments.}"
fi

SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; . "$SELF/../_model-cache/lib.sh"
KEY="$(resolve_key GEMINI_API_KEY)"
[ -n "$KEY" ] || { echo "ERROR: no API key (keychain gemini-api-key / env GEMINI_API_KEY)" >&2; exit 1; }

case "${GEMINI_MODEL:-flash}" in
  flash) MODEL="gemini-3.5-flash" ;;
  pro)   MODEL="gemini-3.1-pro-preview" ;;
  *)     MODEL="${GEMINI_MODEL}" ;;
esac

curl -sS --max-time 600 -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent?key=${KEY}" \
  -H 'content-type: application/json' \
  -d "$(jq -n --arg q "$QUESTION" --arg u "$URL" \
        '{contents:[{parts:[{text:$q},{fileData:{fileUri:$u}}]}]}')" \
  | jq -r '.candidates[0].content.parts[0].text // ("yt.sh ERR: " + (.error.message // "no text returned"))'
