#!/usr/bin/env bash
# OpenRouter seat (one-shot REST query) - used by /board and ad-hoc key-backed asks.
# Resolves the key via lib.sh (env -> ~/.zshrc -> keychain openrouter-api-key), so it
# works in the keychain-only setup where the session env has no OPENROUTER_API_KEY.
#
# Three modes:
#   plain    bash openrouter-bridge/ask.sh /tmp/brief        (model = $OPENROUTER_MODEL, default z-ai/glm-5.2)
#   grok     bash openrouter-bridge/ask.sh --grok /tmp/brief
#            -> the /board Grok seat. Self-healing chain (xAI region-blocks the newest
#               model in the EU; OpenRouter egresses from a Cloudflare edge near YOUR IP):
#                 1. $OPENROUTER_GROK_MODEL (default x-ai/grok-4.5) direct
#                 2. on "not available in your region": retry through a US SOCKS5 proxy
#                    ($OPENROUTER_PROXY, else NordVPN service creds "user:pass" from
#                    keychain item `nordvpn-socks5` -> $NORD_SOCKS_HOST:1080, default
#                    us.socks.nordhold.net)
#                 3. still failing: fall back to $OPENROUTER_GROK_FALLBACK (x-ai/grok-4.3)
#   fusion   bash openrouter-bridge/ask.sh --fusion /tmp/brief
#            -> openrouter/fusion panel+judge deliberation. Panel + judge are env-overridable:
#               OPENROUTER_FUSION_PANEL  (csv of provider/model, default GLM-5.2 + DeepSeek-V4-Pro)
#               OPENROUTER_FUSION_JUDGE  (synthesizer that writes the final answer, default z-ai/glm-5.2)
# $OPENROUTER_PROXY (any curl --proxy URL) applies to ALL modes when set.
# Briefing from the file arg (if it exists) or stdin.   echo "..." | bash openrouter-bridge/ask.sh --fusion
set -uo pipefail
SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; . "$SELF/../_model-cache/lib.sh"
key="$(resolve_key OPENROUTER_API_KEY)"
[ -z "$key" ] && { echo "OpenRouter seat ERR: no key (keychain openrouter-api-key / env OPENROUTER_API_KEY)"; exit 1; }

fusion=0; grok=0
if [ "${1:-}" = "--fusion" ]; then fusion=1; shift; fi
if [ "${1:-}" = "--grok" ]; then grok=1; shift; fi
if [ -n "${1:-}" ] && [ -f "$1" ]; then brief="$(cat "$1")"; else brief="$(cat)"; fi

# call BODY [extra curl args...] -> raw JSON response
call() {
  local body="$1"; shift
  curl -s --max-time 300 https://openrouter.ai/api/v1/chat/completions \
    -H "Authorization: Bearer $key" -H 'content-type: application/json' \
    -H 'HTTP-Referer: https://claude.ai/code' -H 'X-Title: board-seat' \
    ${OPENROUTER_PROXY:+--proxy "$OPENROUTER_PROXY"} "$@" -d "$body"
}
mkbody() { jq -n --arg p "$brief" --arg m "$1" '{model:$m,messages:[{role:"user",content:$p}]}'; }
extract() { jq -r '.choices[0].message.content // ("OpenRouter seat ERR: " + ((.error.metadata.raw // .error.message) // "no content returned"))'; }
ok() { jq -e '.choices[0].message.content' >/dev/null 2>&1 <<<"$1"; }

if [ "$fusion" = 1 ]; then
  panel="${OPENROUTER_FUSION_PANEL:-z-ai/glm-5.2,deepseek/deepseek-v4-pro}"
  judge="${OPENROUTER_FUSION_JUDGE:-z-ai/glm-5.2}"
  body="$(jq -n --arg p "$brief" --arg panel "$panel" --arg judge "$judge" '
    {model:"openrouter/fusion",
     messages:[{role:"user",content:$p}],
     plugins:[{id:"fusion",
               analysis_models:($panel|split(",")|map(gsub("^\\s+|\\s+$";""))),
               model:$judge}]}')"
  call "$body" | extract
elif [ "$grok" = 1 ]; then
  primary="${OPENROUTER_GROK_MODEL:-x-ai/grok-4.5}"
  fallback="${OPENROUTER_GROK_FALLBACK:-x-ai/grok-4.3}"
  resp="$(call "$(mkbody "$primary")")"
  if ! ok "$resp" && grep -qi "not available in your region" <<<"$resp"; then
    # region-blocked: retry through a US egress if we have one
    if [ -z "${OPENROUTER_PROXY:-}" ]; then
      socks="$(resolve_key NORDVPN_SOCKS5)"   # keychain nordvpn-socks5, value "serviceuser:servicepass"
      if [ -n "$socks" ]; then
        resp="$(call "$(mkbody "$primary")" --proxy "socks5h://${NORD_SOCKS_HOST:-us.socks.nordhold.net}:1080" --proxy-user "$socks")"
      fi
    fi
  fi
  if ! ok "$resp" && [ "$primary" != "$fallback" ]; then
    resp="$(call "$(mkbody "$fallback")")"
    ok "$resp" && echo "[grok seat: $primary unavailable, answered by $fallback]"
  fi
  extract <<<"$resp"
else
  model="${OPENROUTER_MODEL:-z-ai/glm-5.2}"
  call "$(mkbody "$model")" | extract
fi
