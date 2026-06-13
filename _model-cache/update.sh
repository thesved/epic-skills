#!/usr/bin/env bash
# update.sh - deterministic half of `/<skill> update-models`.
# Fetches the live model list, diffs it against the cached snapshot, and prints
# exactly which models an agent must (re)research. The agent then edits the
# human-readable cache files (gemini.md / openai.md) for the flagged models only.
#
# Usage:
#   update.sh                 # all providers, diff-only (default)
#   update.sh gemini          # gemini only
#   update.sh openai          # openai only
#   update.sh all             # both (same as no arg)
#
# Exit 0 always (it is a report, not a gate). Reads GEMINI_API_KEY from env,
# else macOS keychain item `gemini-api-key`.
set -uo pipefail
CACHE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$CACHE_DIR/lib.sh"

gkey() { resolve_key GEMINI_API_KEY; }

update_gemini() {
  echo "== GEMINI =="
  local key; key="$(gkey)"
  if [ -z "$key" ]; then echo "  ERR: no key (env GEMINI_API_KEY or keychain gemini-api-key)"; return; fi
  local live snap; live="$(mktemp)"; snap="$CACHE_DIR/.snap-gemini.tsv"
  curl -s "https://generativelanguage.googleapis.com/v1beta/models?key=$key&pageSize=300" \
    | python3 -c '
import sys,json
d=json.load(sys.stdin)
for m in d.get("models",[]):
    n=m["name"].replace("models/","")
    meth=",".join(sorted(m.get("supportedGenerationMethods",[])))
    print(f"{n}\t{meth}")
' 2>/dev/null | sort > "$live"
  if [ ! -s "$live" ]; then echo "  ERR: endpoint returned no models (key invalid / network)"; rm -f "$live"; return; fi
  if [ -f "$snap" ]; then
    local new removed changed
    new="$(comm -23 <(cut -f1 "$live"|sort) <(cut -f1 "$snap"|sort))"
    removed="$(comm -13 <(cut -f1 "$live"|sort) <(cut -f1 "$snap"|sort))"
    changed="$(join -t$'\t' <(sort -k1,1 "$snap") <(sort -k1,1 "$live") | awk -F'\t' '$2!=$3{print $1}')"
    [ -n "$new" ]     && { echo "  NEW (research + add to cache):";   echo "$new"     | sed 's/^/    + /'; }
    [ -n "$removed" ] && { echo "  REMOVED (drop from cache):";       echo "$removed" | sed 's/^/    - /'; }
    [ -n "$changed" ] && { echo "  CHANGED methods (re-verify):";     echo "$changed" | sed 's/^/    ~ /'; }
    [ -z "$new$removed$changed" ] && echo "  no model changes since $(cat "$CACHE_DIR/.updated" 2>/dev/null || echo '?') - pricing-only refresh"
  else
    echo "  no prior snapshot - FIRST RUN, treat all as new:"
    cut -f1 "$live" | sed 's/^/    + /'
  fi
  cp "$live" "$snap"; rm -f "$live"
  echo "  snapshot: $(wc -l < "$snap" | tr -d ' ') models @ $(date -u +%FT%TZ)"
}

update_openai() {
  echo "== OPENAI =="
  local OPENAI_API_KEY; OPENAI_API_KEY="$(resolve_key OPENAI_API_KEY)"
  if [ -n "$OPENAI_API_KEY" ]; then
    local live snap; live="$(mktemp)"; snap="$CACHE_DIR/.snap-openai.txt"
    curl -s https://api.openai.com/v1/models -H "Authorization: Bearer $OPENAI_API_KEY" \
      | python3 -c '
import sys,json,re
d=json.load(sys.stdin)
# gpt* (covers gpt-N, -codex, -realtime, -image), o-series (o1..o5+), plus dall-e - future-proof
def keep(i): return i.startswith("gpt") or re.match(r"o\d", i) or "dall" in i
ids=[m["id"] for m in d.get("data",[]) if keep(m["id"])]
print("\n".join(sorted(ids)))
' 2>/dev/null | sort > "$live"
    if [ -s "$live" ]; then
      if [ -f "$snap" ]; then
        local new; new="$(comm -23 "$live" <(sort "$snap"))"
        [ -n "$new" ] && { echo "  NEW:"; echo "$new" | sed 's/^/    + /'; } || echo "  no new gpt/image models"
      else
        echo "  no prior snapshot - first run:"; sed 's/^/    + /' "$live"
      fi
      cp "$live" "$snap"
    else
      echo "  models endpoint failed"
    fi
    rm -f "$live"
  else
    echo "  no OPENAI_API_KEY - codex uses ChatGPT-login (no models list)."
    echo "  Verify the working id with: codex exec --help  (or interactive: codex then /model)."
    echo "  openai.md refresh is research-only."
  fi
}

update_openrouter() {
  echo "== OPENROUTER =="
  local snap live; snap="$CACHE_DIR/.snap-openrouter.txt"; live="$(mktemp)"
  curl -s https://openrouter.ai/api/v1/models \
    | python3 -c 'import sys,json;d=json.load(sys.stdin);print("\n".join(sorted(m["id"] for m in d.get("data",[]))))' 2>/dev/null | sort > "$live"
  if [ ! -s "$live" ]; then echo "  ERR: models endpoint failed"; rm -f "$live"; return; fi
  if [ -f "$snap" ]; then
    local new; new="$(comm -23 "$live" <(sort "$snap"))"
    [ -n "$new" ] && { echo "  NEW:"; echo "$new" | sed 's/^/    + /'; } || echo "  no new models"
  else
    echo "  no prior snapshot - $(wc -l < "$live" | tr -d ' ') models available (provider/model ids)"
  fi
  cp "$live" "$snap"; rm -f "$live"
  echo "  snapshot: $(wc -l < "$snap" | tr -d ' ') models"
}

case "${1:-all}" in
  gemini) update_gemini ;;
  openai) update_openai ;;
  openrouter) update_openrouter ;;
  all|"") update_gemini; echo; update_openai; echo; update_openrouter ;;
  *) echo "usage: update.sh [gemini|openai|openrouter|all]"; exit 0 ;;
esac
date -u +%FT%TZ > "$CACHE_DIR/.updated"
