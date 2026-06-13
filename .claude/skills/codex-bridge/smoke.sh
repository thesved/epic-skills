#!/usr/bin/env bash
# Codex seat smoke test. Prompt via STDIN (positional arg hangs on "Reading
# additional input from stdin…"). Model via CODEX_MODEL (default gpt-5.5; older
# /-codex-suffixed ids 400). If it errors on the model id, run update-models.
set -uo pipefail
command -v codex >/dev/null 2>&1 || { echo "Codex - DOWN: codex CLI not installed (npm i -g @openai/codex)"; exit 1; }
model="${CODEX_MODEL:-gpt-5.5}"
out="$(printf 'Reply with exactly: CODEX_OK\n' | codex exec -m "$model" --skip-git-repo-check 2>&1)"
if printf '%s' "$out" | grep -q CODEX_OK; then
  echo "Codex - ok ($model)"
else
  echo "Codex - ERR ($model): $(printf '%s' "$out" | grep -iE 'error|not supported|400|unauthor' | head -1 | cut -c1-120)"
  exit 1
fi
