#!/usr/bin/env bash
# OpenRouter seat (one-shot REST query) - used by /board and ad-hoc key-backed asks.
# Resolves the key via lib.sh (env -> ~/.zshrc -> keychain openrouter-api-key), so it
# works in the keychain-only setup where the session env has no OPENROUTER_API_KEY.
#
# Two modes:
#   plain    bash openrouter-bridge/ask.sh /tmp/brief        (model = $OPENROUTER_MODEL, default z-ai/glm-5.3)
#            bash openrouter-bridge/ask.sh -m deepseek/deepseek-v4-pro-0813 /tmp/brief   (per-call model)
#   grok     bash openrouter-bridge/ask.sh --grok /tmp/brief
#            -> the /board Grok seat. Self-healing chain (xAI region-blocks the newest
#               model in the EU; OpenRouter egresses from a Cloudflare edge near YOUR IP):
#                 1. $OPENROUTER_GROK_MODEL (default x-ai/grok-4.6) direct
#                 2. on "not available in your region": retry through a US SOCKS5 proxy
#                    ($OPENROUTER_PROXY, else NordVPN service creds "user:pass" from
#                    keychain item `nordvpn-socks5` -> $NORD_SOCKS_HOST:1080, default
#                    us.socks.nordhold.net)
#                 3. still failing: fall back to $OPENROUTER_GROK_FALLBACK (x-ai/grok-4.5)
# $OPENROUTER_PROXY (any curl --proxy URL) applies to ALL modes when set.
# All modes retry 429/5xx/transport with backoff under a total deadline (see call() below);
# tune with OPENROUTER_TIMEOUT / OPENROUTER_MAX_RETRIES / OPENROUTER_RETRY_DEADLINE.
# A reasoning model on a heavy brief can outlast the harness's 120s default Bash timeout: fire
# slow seats in the BACKGROUND and poll, or give the foreground call an explicit longer timeout.
# Briefing from the file arg (if it exists) or stdin.   echo "..." | bash openrouter-bridge/ask.sh
set -uo pipefail
SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; . "$SELF/../_model-cache/lib.sh"
key="$(resolve_key OPENROUTER_API_KEY)"
[ -z "$key" ] && { echo "OpenRouter seat ERR: no key (keychain openrouter-api-key / env OPENROUTER_API_KEY)"; exit 1; }

grok=0
if [ "${1:-}" = "--grok" ]; then grok=1; shift; fi
if [ "${1:-}" = "-m" ] || [ "${1:-}" = "--model" ]; then OPENROUTER_MODEL="${2:?-m needs provider/model}"; shift 2; fi
if [ -n "${1:-}" ] && [ -f "$1" ]; then brief="$(cat "$1")"; else brief="$(cat)"; fi

# call BODY [extra curl args...] -> raw JSON body on stdout; one diag line on stderr.
# Retries 429 / 5xx / transport with backoff (honors Retry-After) under a TOTAL time
# budget, so a retry can never be killed mid-sleep by an outer timeout (board warning:
# a sync retry near a hard timeout turns a fast visible failure into a slow silent one).
# Tunables: OPENROUTER_TIMEOUT (curl --max-time, default 300), OPENROUTER_MAX_RETRIES
# (default 3), OPENROUTER_RETRY_DEADLINE (total secs allowed for retries, default 90).
call() {
  local body="$1"; shift
  local tmo="${OPENROUTER_TIMEOUT:-300}" max="${OPENROUTER_MAX_RETRIES:-3}" ddl="${OPENROUTER_RETRY_DEADLINE:-90}"
  local start="$SECONDS" attempt=0 resp code body_out ra delay fin
  local hdr; hdr="$(mktemp)"; trap 'rm -f "$hdr"' RETURN
  while :; do
    attempt=$((attempt+1))
    resp="$(curl -s --max-time "$tmo" -D "$hdr" -w $'\n%{http_code}' \
      https://openrouter.ai/api/v1/chat/completions \
      -H "Authorization: Bearer $key" -H 'content-type: application/json' \
      -H 'HTTP-Referer: https://claude.ai/code' -H 'X-Title: board-seat' \
      ${OPENROUTER_PROXY:+--proxy "$OPENROUTER_PROXY"} "$@" -d "$body")"
    code="${resp##*$'\n'}"; body_out="${resp%$'\n'*}"   # last line = HTTP status (000 = curl/transport fail)
    # retry only on transient failures, and only if a full backoff still fits the total deadline
    if { [ "$code" = 429 ] || [ "$code" = 000 ] || { [ "$code" -ge 500 ] 2>/dev/null; }; } \
       && [ "$attempt" -lt "$max" ]; then
      ra="$(grep -i '^retry-after:' "$hdr" | tail -1 | tr -dc '0-9')"
      delay="${ra:-$(( attempt*attempt*2 ))}"          # honor Retry-After, else 2s,8s,18s
      if [ $(( SECONDS - start + delay )) -lt "$ddl" ]; then
        echo "[openrouter seat: http $code, retry $attempt in ${delay}s]" >&2
        sleep "$delay"; continue
      fi
    fi
    fin="$(jq -r '.choices[0].finish_reason // "n/a"' <<<"$body_out" 2>/dev/null)"
    # content length + reasoning tokens in the status line: an empty answer is otherwise
    # indistinguishable from a refusal, a length cut, or a provider hiccup (see SKILL.md)
    clen="$(jq -r '(.choices[0].message.content // "") | length' <<<"$body_out" 2>/dev/null)"
    rtok="$(jq -r '.usage.completion_tokens_details.reasoning_tokens // 0' <<<"$body_out" 2>/dev/null)"
    echo "[openrouter seat: $((SECONDS-start))s http=$code finish=$fin content=${clen:-?}ch reasoning=${rtok:-?}tok]" >&2
    printf '%s' "$body_out"; return 0
  done
}
mkbody() { jq -n --arg p "$brief" --arg m "$1" '{model:$m,messages:[{role:"user",content:$p}]}'; }
# jq `//` only falls through on null/false, so content:"" used to print a blank line = silent empty.
# Trim and test explicitly: null / "" / whitespace-only all route to a loud ERR (with any .error payload).
extract() {
  local in out; in="$(cat)"
  # empty/whitespace body = transport or timeout kill (jq would exit 0 on empty stdin = silent blank)
  # NOTE: never use bash ${var//[[:space:]]/} here: it is superlinear (11 KB = 110 s) and a
  # reasoning-heavy body (DeepSeek/GLM return the reasoning text too) hung the seat for 7+ min.
  if ! grep -q '[^[:space:]]' <<<"$in"; then echo "OpenRouter seat ERR: empty response (transport/timeout?)"; return; fi
  out="$(jq -r '
    (.choices[0].message.content // "") as $c
    | if ($c | gsub("^\\s+|\\s+$";"")) != "" then $c
      else "OpenRouter seat ERR: " + ((.error.metadata.raw // .error.message) // "empty content returned")
      end' <<<"$in" 2>/dev/null)"
  if ! grep -q '[^[:space:]]' <<<"$out"; then echo "OpenRouter seat ERR: unparseable response"; else printf '%s\n' "$out"; fi
}
ok() { jq -e '(.choices[0].message.content // "") | gsub("^\\s+|\\s+$";"") != ""' >/dev/null 2>&1 <<<"$1"; }

if [ "$grok" = 1 ]; then
  primary="${OPENROUTER_GROK_MODEL:-x-ai/grok-4.6}"
  fallback="${OPENROUTER_GROK_FALLBACK:-x-ai/grok-4.5}"
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
  model="${OPENROUTER_MODEL:-z-ai/glm-5.3}"
  call "$(mkbody "$model")" | extract
fi
