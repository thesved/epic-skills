#!/usr/bin/env bash
# Codex seat smoke test. Prompt via STDIN (positional arg hangs on "Reading
# additional input from stdin…"). Model via CODEX_MODEL (default gpt-5.6-sol).
# On model-id error: update the codex CLI, then update-models.
set -uo pipefail
command -v codex >/dev/null 2>&1 || { echo "Codex - DOWN: codex CLI not installed (npm i -g @openai/codex)"; exit 1; }
inst="$(codex --version 2>/dev/null | awk '{print $NF}')"; latest="$(npm view @openai/codex version 2>/dev/null)"
if [ -n "$latest" ] && [ "$inst" != "$latest" ]; then echo "Codex CLI - DRIFT: installed $inst, latest $latest (run 'codex update' at session start, never mid-run)"; else echo "Codex CLI - $inst (latest)"; fi
model="${CODEX_MODEL:-gpt-5.6-sol}"
out="$(printf 'Reply with exactly: CODEX_OK\n' | codex exec -m "$model" --skip-git-repo-check 2>&1)"
if printf '%s' "$out" | grep -q CODEX_OK; then
  echo "Codex - ok ($model)"
else
  echo "Codex - ERR ($model): $(printf '%s' "$out" | grep -iE 'error|not supported|400|unauthor' | head -1 | cut -c1-120)"
  exit 1
fi
