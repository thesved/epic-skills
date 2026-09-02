#!/bin/bash
# judge via Claude Code headless (cross-family vs OpenAI target/proposer). Usage: judge-claude.sh <promptfile>
M="${JUDGE_CLAUDE_MODEL:-opus}"
env -u CLAUDECODE claude -p --model "$M" --setting-sources project --output-format text < "$1"
