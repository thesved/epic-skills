#!/usr/bin/env bash
# Gemini seat smoke test. Route (GEMINI_ROUTE): openrouter (default, google/gemini-3.1-flash-lite, ~free)
# | google (direct generateContent, gemini-flash-lite-latest; needs prepaid balance). Override model: GEMINI_SMOKE_MODEL.
set -uo pipefail
SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; . "$SELF/../_model-cache/lib.sh"
ROUTE="${GEMINI_ROUTE:-openrouter}"
if [ "$ROUTE" = "openrouter" ]; then
  key="$(resolve_key OPENROUTER_API_KEY)"
  [ -z "$key" ] && { echo "Gemini - ERR: no OpenRouter key"; exit 1; }
  model="${GEMINI_SMOKE_MODEL:-google/gemini-3.1-flash-lite}"
  curl -s --max-time 60 https://openrouter.ai/api/v1/chat/completions -H "Authorization: Bearer ${key}" -H 'content-type: application/json' \
    -d "$(jq -n --arg m "$model" '{model:$m, messages:[{role:"user", content:"Reply with exactly: GEMINI_OK"}]}')" \
  | python3 -c '
import sys,json
d=json.load(sys.stdin); c=d.get("choices")
if c: print("Gemini - ok (%s | route=openrouter | model=%s | provider=%s)"%(c[0]["message"]["content"].strip(), d.get("model"), d.get("provider")))
else: print("Gemini - ERR:", d.get("error",{}).get("message","unknown")); sys.exit(1)'
  exit $?
fi
key="$(resolve_key GEMINI_API_KEY)"
[ -z "$key" ] && { echo "Gemini - ERR: no key (env / ~/.zshrc / keychain gemini-api-key)"; exit 1; }
model="${GEMINI_SMOKE_MODEL:-gemini-flash-lite-latest}"
curl -s "https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=$key" \
  -H 'content-type: application/json' -d '{"contents":[{"parts":[{"text":"Reply with exactly: GEMINI_OK"}]}]}' \
| python3 -c '
import sys,json
d=json.load(sys.stdin); c=d.get("candidates")
if c: print("Gemini - ok (%s | route=google | resolved=%s)"%(c[0]["content"]["parts"][0]["text"].strip(), d.get("modelVersion")))
else: print("Gemini - ERR:", d.get("error",{}).get("message","unknown")); sys.exit(1)'
