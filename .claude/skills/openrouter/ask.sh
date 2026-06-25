#!/usr/bin/env bash
# OpenRouter seat (one-shot REST query) - used by /board and ad-hoc key-backed asks.
# Resolves the key via lib.sh (env -> ~/.zshrc -> keychain openrouter-api-key), so it
# works in the keychain-only setup where the session env has no OPENROUTER_API_KEY.
#
# Two modes:
#   plain    bash openrouter/ask.sh /tmp/brief        (model = $OPENROUTER_MODEL, default z-ai/glm-5.2)
#   fusion   bash openrouter/ask.sh --fusion /tmp/brief
#            -> openrouter/fusion panel+judge deliberation. Panel + judge are env-overridable:
#               OPENROUTER_FUSION_PANEL  (csv of provider/model, default GLM-5.2 + DeepSeek-V4-Pro)
#               OPENROUTER_FUSION_JUDGE  (synthesizer that writes the final answer, default z-ai/glm-5.2)
# Briefing from the file arg (if it exists) or stdin.   echo "..." | bash openrouter/ask.sh --fusion
set -uo pipefail
SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; . "$SELF/../_model-cache/lib.sh"
key="$(resolve_key OPENROUTER_API_KEY)"
[ -z "$key" ] && { echo "OpenRouter seat ERR: no key (keychain openrouter-api-key / env OPENROUTER_API_KEY)"; exit 1; }

fusion=0
if [ "${1:-}" = "--fusion" ]; then fusion=1; shift; fi
if [ -n "${1:-}" ] && [ -f "$1" ]; then brief="$(cat "$1")"; else brief="$(cat)"; fi

if [ "$fusion" = 1 ]; then
  panel="${OPENROUTER_FUSION_PANEL:-z-ai/glm-5.2,deepseek/deepseek-v4-pro}"
  judge="${OPENROUTER_FUSION_JUDGE:-z-ai/glm-5.2}"
  body="$(jq -n --arg p "$brief" --arg panel "$panel" --arg judge "$judge" '
    {model:"openrouter/fusion",
     messages:[{role:"user",content:$p}],
     plugins:[{id:"fusion",
               analysis_models:($panel|split(",")|map(gsub("^\\s+|\\s+$";""))),
               model:$judge}]}')"
else
  model="${OPENROUTER_MODEL:-z-ai/glm-5.2}"
  body="$(jq -n --arg p "$brief" --arg m "$model" '{model:$m,messages:[{role:"user",content:$p}]}')"
fi

curl -s https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $key" -H 'content-type: application/json' \
  -H 'HTTP-Referer: https://claude.ai/code' -H 'X-Title: board-seat' \
  -d "$body" \
  | jq -r '.choices[0].message.content // ("OpenRouter seat ERR: " + (.error.message // "no content returned"))'
