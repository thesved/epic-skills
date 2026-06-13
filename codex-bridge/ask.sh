#!/usr/bin/env bash
# Codex seat (one-shot query) - used by /board and ad-hoc Codex asks.
# Prompt via STDIN (positional arg hangs on "Reading additional input from stdin…").
# Model = $BOARD_CODEX_MODEL or gpt-5.5 (only reliable id on ChatGPT login).
# Briefing from $1 (a file) or stdin. Strips the codex banner/footer → just the answer.
#   bash codex-prompt/ask.sh /tmp/brief   |   echo "…" | bash codex-prompt/ask.sh
set -uo pipefail
command -v codex >/dev/null 2>&1 || { echo "Codex seat ERR: codex CLI not installed"; exit 1; }
model="${BOARD_CODEX_MODEL:-gpt-5.5}"
if [ -n "${1:-}" ] && [ -f "$1" ]; then brief="$(cat "$1")"; else brief="$(cat)"; fi
out="$(printf '%s' "$brief" | codex exec -m "$model" --skip-git-repo-check 2>&1)"
# answer is the text between the lone `codex` marker line and the `tokens used` footer
ans="$(printf '%s\n' "$out" | awk '/^codex$/{c=1;next} /^tokens used$/{c=0} c')"
if [ -n "$ans" ]; then printf '%s\n' "$ans"; else printf '%s\n' "$out"; fi
