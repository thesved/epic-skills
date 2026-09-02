#!/usr/bin/env bash
# yt.sh - analyze a YOUTUBE video (public URL) with Gemini. No download, no upload:
# Gemini fetches the URL server-side. For LOCAL video files use video.sh (Files API, direct only).
#
# Usage:
#   ./yt.sh <youtube-url> [question...]        # default: Flash, static processing, via OpenRouter
#   GEMINI_MODEL=pro ./yt.sh <url> [q...]      # Pro (deep reasoning)
#   GEMINI_ROUTE=google ./yt.sh <url> [q...]   # Google direct (GEMINI_API_KEY; needs prepaid balance)
#   GEMINI_VIDEO=agentic ./yt.sh <url> [q...]  # agentic processing (Interactions API, Google direct ONLY,
#                                              #  route forced to google): the model navigates the
#                                              #  timeline itself (transcript/frames/audio on demand).
#                                              #  Measured 2026-09-02 on a 20-min video:
#                                              #  8.4k tokens vs 114.8k static (93% fewer),
#                                              #  28 s vs 15 s, same answer quality.
#                                              #  Use for long videos (>~15 min) or
#                                              #  "find the moment where..." questions;
#                                              #  static stays better for short clips
#                                              #  and frame-precise questions.
#   ./yt.sh <url> - <<EOF                      # question from stdin (heredoc-safe
#   long multi-line prompt...                  #  for big context blocks)
#   EOF
#
# Route (GEMINI_ROUTE): openrouter (default) | google
#   openrouter: chat/completions with a `video_url` part, provider PINNED to "Google AI Studio"
#     with allow_fallbacks:false. YouTube URLs only work on the AI Studio provider; when OpenRouter
#     falls back to Vertex the call 400s ("Cannot fetch content from the provided URL"). Probe
#     2026-09-02: 2-min clip 1.8k tokens $0.0017; 19-min video 101.9k tokens $0.077, 3.5 min wall
#     time (Google direct static: 15 s). Retries 429/5xx (AI Studio upstream rate limits happen).
#   google: generateContent with fileData.fileUri (static) or Interactions API (agentic).
# Model (GEMINI_MODEL): flash (default) | pro | <exact-model-id>
#   openrouter ids: google/gemini-3.7-flash, google/gemini-3.1-pro-preview (bare ids get google/ prefixed).
#   agentic supports gemini-3.7-flash, gemini-3.6-flash, gemini-3.5-flash-lite (not pro).
# Auth: openrouter route = $OPENROUTER_API_KEY / keychain `openrouter-api-key`;
#       google route = $GEMINI_API_KEY / keychain `gemini-api-key` (both via lib.sh).
# Limits: ~1 h at high media resolution, ~3 h at low, per 1M context. Errors come back
#   on stdout as "yt.sh ERR: ..." (billing: "prepayment credits are depleted" = top up or use openrouter).
set -euo pipefail

URL="${1:?usage: yt.sh <youtube-url> [question...]}"; shift || true
if [ "${1:-}" = "-" ]; then
  QUESTION="$(cat)"
else
  QUESTION="${*:-Summarize this video in 5 bullets. Note total duration and MM:SS timestamps for the key moments.}"
fi

SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; . "$SELF/../_model-cache/lib.sh"

ROUTE="${GEMINI_ROUTE:-openrouter}"
VIDEO="${GEMINI_VIDEO:-static}"
if [ "$VIDEO" = "agentic" ] && [ "$ROUTE" != "google" ]; then
  echo "[yt.sh: agentic mode is Interactions-API only, routing direct to Google]" >&2
  ROUTE=google
fi

case "${GEMINI_MODEL:-flash}" in
  flash) MODEL="gemini-3.7-flash" ;;
  pro)   MODEL="gemini-3.1-pro-preview" ;;
  *)     MODEL="${GEMINI_MODEL}" ;;
esac

if [ "$ROUTE" = "openrouter" ]; then
  KEY="$(resolve_key OPENROUTER_API_KEY)"
  [ -n "$KEY" ] || { echo "ERROR: no OpenRouter key (keychain openrouter-api-key / env OPENROUTER_API_KEY)" >&2; exit 1; }
  case "$MODEL" in */*) ORMODEL="$MODEL" ;; *) ORMODEL="google/${MODEL#google/}" ;; esac
  BODY="$(jq -n --arg q "$QUESTION" --arg u "$URL" --arg m "$ORMODEL" \
    '{model:$m, provider:{order:["Google AI Studio"], allow_fallbacks:false},
      messages:[{role:"user", content:[{type:"text", text:$q},{type:"video_url", video_url:{url:$u}}]}]}')"
  attempt=0
  while :; do
    attempt=$((attempt+1))
    resp="$(curl -s --max-time "${OPENROUTER_TIMEOUT:-900}" -w $'\n%{http_code}' \
      https://openrouter.ai/api/v1/chat/completions \
      -H "Authorization: Bearer ${KEY}" -H 'content-type: application/json' \
      -H 'HTTP-Referer: https://claude.ai/code' -H 'X-Title: yt.sh' \
      ${OPENROUTER_PROXY:+--proxy "$OPENROUTER_PROXY"} -d "$BODY")"
    code="${resp##*$'\n'}"; body="${resp%$'\n'*}"
    if { [ "$code" = 429 ] || [ "$code" = 000 ] || { [ "$code" -ge 500 ] 2>/dev/null; }; } && [ "$attempt" -lt 4 ]; then
      delay=$((attempt*attempt*5)); echo "[yt.sh: openrouter http $code, retry $attempt in ${delay}s]" >&2; sleep "$delay"; continue
    fi
    break
  done
  printf '%s' "$body" | jq -r '.choices[0].message.content
      // ("yt.sh ERR: " + (.error.message // "no text returned") + (.error.metadata.raw // "" | if . == "" then "" else " | " + (.|tostring|.[0:300]) end))'
  exit 0
fi

KEY="$(resolve_key GEMINI_API_KEY)"
[ -n "$KEY" ] || { echo "ERROR: no API key (keychain gemini-api-key / env GEMINI_API_KEY)" >&2; exit 1; }
MODEL="${MODEL#google/}"

if [ "$VIDEO" = "agentic" ]; then
  # Interactions API: video part carries processing:"agentic"; answer lives in steps[].model_output.
  curl -sS --max-time 900 -X POST "https://generativelanguage.googleapis.com/v1beta/interactions" \
    -H "x-goog-api-key: ${KEY}" -H 'content-type: application/json' \
    -d "$(jq -n --arg q "$QUESTION" --arg u "$URL" --arg m "$MODEL" \
          '{model:$m, input:[{type:"video", uri:$u, processing:"agentic"},{type:"text", text:$q}]}')" \
    | jq -r 'if .error then ("yt.sh ERR: " + .error.message)
             else ([.steps[]? | select(.type=="model_output") | .content[]? | select(.type=="text") | .text] | join("\n"))
                  // "yt.sh ERR: no text returned" end'
else
  curl -sS --max-time 600 -X POST \
    "https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent?key=${KEY}" \
    -H 'content-type: application/json' \
    -d "$(jq -n --arg q "$QUESTION" --arg u "$URL" \
          '{contents:[{parts:[{text:$q},{fileData:{fileUri:$u}}]}]}')" \
    | jq -r '.candidates[0].content.parts[0].text // ("yt.sh ERR: " + (.error.message // "no text returned"))'
fi
