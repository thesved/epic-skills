#!/bin/bash
# run_lane.sh <letter>: one codex web-research lane on gpt-5.6-sol (ChatGPT sub), read-only sandbox, web search on.
L=$1; D=$HOME/.claude/skills/_model-cache/research/2026-09-05
mkdir -p "$D/logs/work$L"; cd "$D/logs/work$L"
echo "start $(date -u +%FT%TZ)" > "$D/logs/lane$L.log"
codex exec --json -m gpt-5.6-sol -c model_reasoning_effort=high -c tools.web_search=true -s read-only --skip-git-repo-check -C "$D/logs/work$L" -o "$D/codex-lane-$L.md" < "$D/prompts/lane$L.md" >> "$D/logs/lane$L.log" 2>&1
echo "exit=$? end $(date -u +%FT%TZ)" >> "$D/logs/lane$L.log"
