#!/usr/bin/env bash
# OpenRouter seat smoke test - cheap single-model ping (NOT fusion; fusion would
# fan out N+1 paid calls). Verifies key + endpoint reachability only.
# Key: env OPENROUTER_API_KEY else keychain openrouter-api-key. Override model with
# OPENROUTER_SMOKE_MODEL. Default = a cheap, always-on non-routing model.
set -uo pipefail
SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; . "$SELF/../_model-cache/lib.sh"
key="$(resolve_key OPENROUTER_API_KEY)"
[ -z "$key" ] && { echo "OpenRouter - ERR: no key (env / ~/.zshrc / keychain openrouter-api-key)"; exit 1; }
model="${OPENROUTER_SMOKE_MODEL:-z-ai/glm-4.7-flash}"
curl -s https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $key" -H 'content-type: application/json' \
  -d "$(jq -n --arg m "$model" '{model:$m,messages:[{role:"user",content:"Reply with exactly: OPENROUTER_OK"}]}')" \
| python3 -c '
import sys,json
d=json.load(sys.stdin)
ch=d.get("choices")
if ch:
    t=ch[0]["message"]["content"].strip()
    print("OpenRouter - ok (%s | served=%s)"%(t, d.get("provider","?")))
else:
    print("OpenRouter - ERR:", d.get("error",{}).get("message","unknown"))
    sys.exit(1)
'
