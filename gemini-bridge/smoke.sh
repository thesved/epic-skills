#!/usr/bin/env bash
# Gemini seat smoke test - cheapest lite model via the PAID key (REST).
# Throttle-proof (pay-as-you-go), ~12 tokens, instant. Uses the self-updating
# `gemini-flash-lite-latest` alias so it never goes stale. Key: env GEMINI_API_KEY
# else keychain `gemini-api-key`. Override model with GEMINI_SMOKE_MODEL.
set -uo pipefail
SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; . "$SELF/../_model-cache/lib.sh"
key="$(resolve_key GEMINI_API_KEY)"
[ -z "$key" ] && { echo "Gemini - ERR: no key (env / ~/.zshrc / keychain gemini-api-key)"; exit 1; }
model="${GEMINI_SMOKE_MODEL:-gemini-flash-lite-latest}"
curl -s "https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=$key" \
  -H 'content-type: application/json' \
  -d '{"contents":[{"parts":[{"text":"Reply with exactly: GEMINI_OK"}]}]}' \
| python3 -c '
import sys,json
d=json.load(sys.stdin)
c=d.get("candidates")
if c:
    t=c[0]["content"]["parts"][0]["text"].strip()
    um=d.get("usageMetadata",{})
    print("Gemini - ok (%s | resolved=%s | tier=%s)"%(t,d.get("modelVersion"),um.get("serviceTier","?")))
else:
    print("Gemini - ERR:",d.get("error",{}).get("message","unknown"))
    sys.exit(1)
'
