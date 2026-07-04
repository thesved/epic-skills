#!/usr/bin/env bash
# Board smoke = verify every seat is reachable. Delegates to each seat's own
# smoke.sh (no duplication). Fable needs no check - it runs via the Agent tool,
# always available in-session.
set -uo pipefail
SKILLS="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "SEAT CHECK:"
echo "- Fable  - ok (in-session, Agent tool)"
printf -- '- '; bash "$SKILLS/gemini-bridge/smoke.sh"        || true
printf -- '- '; bash "$SKILLS/codex-bridge/smoke.sh"  || true
printf -- '- '; bash "$SKILLS/openrouter-bridge/smoke.sh"   || true
echo
echo "(agy - the optional agentic Gemini seat - is not pinged here; it uses OAuth quota."
echo " To check it: agy -p 'Reply with exactly: AGY_OK' </dev/null )"
