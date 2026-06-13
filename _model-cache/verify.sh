#!/usr/bin/env bash
# End-to-end model verification - actually calls one model per capability and
# prints a PASS/FAIL table. Resolves keys (OS store -> env -> .env -> rc) then runs
# verify.py. Use this to prove the cache's recommendations actually work.
#   verify.sh --cheap   # text liveness only (~free)
#   verify.sh           # + image, tts, realtime audio, codex  (~10-15c)
#   verify.sh --full    # + veo video, lyria music, deep-research, video-analysis (~$0.50-1, minutes)
set -uo pipefail
CACHE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$CACHE_DIR/lib.sh"
export GEMINI_API_KEY="$(resolve_key GEMINI_API_KEY)"
export OPENAI_API_KEY="$(resolve_key OPENAI_API_KEY)"
export OPENROUTER_API_KEY="$(resolve_key OPENROUTER_API_KEY)"
exec python3 "$CACHE_DIR/verify.py" "$@"
