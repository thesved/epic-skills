#!/bin/bash
# judge via Gemini (OpenRouter route). Usage: judge-gemini.sh <promptfile>
bash "$HOME/.claude/skills/gemini-bridge/ask.sh" "$1"
