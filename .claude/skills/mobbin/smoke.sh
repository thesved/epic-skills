#!/usr/bin/env bash
# mobbin smoke test - proves the MCP-wrapper CLI works without touching the user's
# real token (uses a throwaway MOBBIN_HOME for the logged-out checks), then runs an
# authed live check against the real token if present. Exit 0 = all checks passed.
#   bash ~/.claude/skills/mobbin/smoke.sh
set -uo pipefail
M="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/bin/mobbin"
TMP="$(mktemp -d)"
pass=0; fail=0
ok(){ printf '  \033[32mPASS\033[0m %s\n' "$1"; pass=$((pass+1)); }
no(){ printf '  \033[31mFAIL\033[0m %s\n' "$1"; fail=$((fail+1)); }

echo "mobbin smoke test"

# 1. syntax
python3 -c "import py_compile;py_compile.compile('$M',doraise=True)" 2>/dev/null \
  && ok "python syntax" || no "python syntax"

# 2. endpoint up + advertises the expected auth server (no auth needed)
meta=$(curl -sS -m 15 https://api.mobbin.com/.well-known/oauth-protected-resource/mcp 2>/dev/null)
echo "$meta" | grep -q "ujasntkfphywizsdaapi.supabase.co" \
  && ok "endpoint: oauth metadata OK, auth server unchanged" \
  || no "endpoint metadata (got '${meta:0:80}')"

# 3. logged-out -> clean 'login' error, not a crash (throwaway home)
gated="$(MOBBIN_HOME="$TMP/home" "$M" tools 2>&1)"
echo "$gated" | grep -qi "login" && ok "logged-out: clean auth error" \
  || no "logged-out auth error (got '${gated:0:80}')"

# 4. real token: doctor = auth + live tools/list (informational if not logged in)
if [ -f "${MOBBIN_HOME:-$HOME/.mobbin}/mcp_session.json" ]; then
  doc="$("$M" doctor 2>&1)"
  echo "$doc" | sed 's/^/  /'
  echo "$doc" | grep -q "auth: OK" && ok "live: auth + handshake" || no "live auth"
  echo "$doc" | grep -qE "[0-9]+ tool" && ok "live: server lists tools" || no "live tools/list"
else
  echo "  (not logged in - skipping live checks; run 'mobbin login')"
fi

echo "-------------------------------------------"
echo "checks: $pass passed, $fail failed"
rm -rf "$TMP"
[ "$fail" -eq 0 ]
