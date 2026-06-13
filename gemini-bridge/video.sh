#!/usr/bin/env bash
# video.sh - analyze a LOCAL video file with Gemini via the File API (robust path).
#
# Why this exists: the `gemini` CLI's `@file.mp4` ingestion hangs/stalls on large
# videos (verified: a 76 MB screen recording never returned after 9+ min). The
# File API is the reliable mechanism Google documents for any video, and is the
# ONLY option for files >20 MB (inline base64 exceeds the request-size limit).
#
# Usage:
#   ./video.sh <video-file> [question...]            # default model = Flash
#   GEMINI_MODEL=pro ./video.sh <video-file> [q...]  # force Pro (deep reasoning)
#
# Model selection (GEMINI_MODEL): flash (default) | pro | <exact-model-id>
#   flash → gemini-3.5-flash      (latest GA Flash; cheap/fast: transcribe,
#                                  summarize, OCR, list, "what happens")
#   pro   → gemini-3.1-pro-preview (latest Pro, preview; deep reasoning:
#                                  intent, critique, cross-modal synthesis)
#   NB: we pin explicit IDs, NOT the `-latest` aliases - `gemini-flash-latest`
#   still resolves to the OLDER gemini-3-flash-preview, behind 3.5-flash GA
#   (verified 2026-06-11). Verify newest with:
#   curl ".../v1beta/models?key=$GEMINI_API_KEY" | jq -r '.models[].name'
#
# Optional GEMINI_FPS=<n>: override the 1-FPS default video sampling (raise for
#   fast motion / dense on-screen text so frames aren't skipped).
#
# Auth: uses $GEMINI_API_KEY if set, else the macOS keychain entry
# `gemini-api-key`. The File API requires the API-key tier - the free
# personal-Google-login (gemini CLI OAuth) hits a different endpoint and
# CANNOT upload files (gemini-cli issue #25167).
set -euo pipefail

FILE="${1:?usage: video.sh <video-file> [question...]}"; shift || true
QUESTION="${*:-Summarize this video in 5 bullets. Note total duration, whether there is spoken audio, and timestamps (MM:SS) for the key moments.}"
[ -f "$FILE" ] || { echo "ERROR: file not found: $FILE" >&2; exit 1; }

SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; . "$SELF/../_model-cache/lib.sh"
KEY="$(resolve_key GEMINI_API_KEY)"
[ -n "$KEY" ] || { echo "ERROR: no API key (OS store gemini-api-key / env GEMINI_API_KEY / .env)" >&2; exit 1; }

case "${GEMINI_MODEL:-flash}" in
  flash) MODEL="gemini-3.5-flash" ;;
  pro)   MODEL="gemini-3.1-pro-preview" ;;
  *)     MODEL="${GEMINI_MODEL}" ;;
esac

BASE="https://generativelanguage.googleapis.com"
MIME="$(file -b --mime-type "$FILE" 2>/dev/null || echo video/mp4)"
NUM_BYTES="$(wc -c < "$FILE" | tr -d ' ')"
echo ">> upload: $FILE ($NUM_BYTES bytes, $MIME) → model $MODEL" >&2

# 1) start resumable upload session, capture the upload URL from response headers
HDRS="$(curl -sS -D - -o /dev/null -X POST \
  "$BASE/upload/v1beta/files?key=$KEY" \
  -H "X-Goog-Upload-Protocol: resumable" \
  -H "X-Goog-Upload-Command: start" \
  -H "X-Goog-Upload-Header-Content-Length: $NUM_BYTES" \
  -H "X-Goog-Upload-Header-Content-Type: $MIME" \
  -H "Content-Type: application/json" \
  -d "{\"file\":{\"display_name\":\"$(basename "$FILE")\"}}")"
UPLOAD_URL="$(printf '%s' "$HDRS" | tr -d '\r' | awk -F': ' 'tolower($1)=="x-goog-upload-url"{print $2}')"
[ -n "$UPLOAD_URL" ] || { echo "ERROR: no upload URL returned" >&2; printf '%s\n' "$HDRS" >&2; exit 1; }

# 2) upload the bytes and finalize
FILE_JSON="$(curl -sS -X POST "$UPLOAD_URL" \
  -H "Content-Length: $NUM_BYTES" \
  -H "X-Goog-Upload-Offset: 0" \
  -H "X-Goog-Upload-Command: upload, finalize" \
  --data-binary "@$FILE")"
NAME="$(printf '%s' "$FILE_JSON" | jq -r '.file.name')"
URI="$(printf '%s' "$FILE_JSON" | jq -r '.file.uri')"
[ -n "$URI" ] && [ "$URI" != null ] || { echo "ERROR: upload failed" >&2; printf '%s\n' "$FILE_JSON" >&2; exit 1; }

# 3) poll until the file finishes server-side processing (video transcode)
STATE="$(printf '%s' "$FILE_JSON" | jq -r '.file.state')"
until [ "$STATE" = ACTIVE ]; do
  [ "$STATE" = FAILED ] && { echo "ERROR: file processing FAILED" >&2; exit 1; }
  sleep 3
  STATE="$(curl -sS "$BASE/v1beta/$NAME?key=$KEY" | jq -r '.state')"
  echo ">> state: $STATE" >&2
done

# 4) generateContent referencing the uploaded file (optional fps override)
echo ">> analyzing…" >&2
if [ -n "${GEMINI_FPS:-}" ]; then
  VIDEO_PART="$(jq -n --arg uri "$URI" --arg mime "$MIME" --argjson fps "$GEMINI_FPS" \
    '{fileData:{mimeType:$mime,fileUri:$uri},videoMetadata:{fps:$fps}}')"
else
  VIDEO_PART="$(jq -n --arg uri "$URI" --arg mime "$MIME" \
    '{fileData:{mimeType:$mime,fileUri:$uri}}')"
fi
curl -sS -X POST "$BASE/v1beta/models/$MODEL:generateContent?key=$KEY" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg q "$QUESTION" --argjson vp "$VIDEO_PART" \
    '{contents:[{parts:[{text:$q},$vp]}]}')" \
  | jq -r '.candidates[0].content.parts[]?.text // (.error.message // "no text in response")'

# cleanup: remove the uploaded file (auto-expires in 48h anyway)
curl -sS -X DELETE "$BASE/v1beta/$NAME?key=$KEY" >/dev/null 2>&1 || true
