#!/bin/bash
D=$HOME/.claude/skills/_model-cache/research/2026-09-05/yt; cd $D
Q=("GPT-6 Astra" "GPT-6 Astra hands on" "GPT-6 Astra Codex" "GPT-6 Astra vs Fable 5.1" "GPT-6 Astra review" "Astra OpenAI test" "GPT-6 Astra coding" "GPT-6 Astra computer use" "GPT-6 Astra limits" "GPT-6 Astra API" "GPT-6 Astra vs Muse Spark" "OpenAI Astra first week" "GPT-6 Astra tutorial" "GPT-6 Astra Claude Code" "GPT-6 Astra Cursor" "GPT-6 Astra benchmark" "GPT 6 Astra" "ChatGPT 6 Astra" "Astra GPT-6 agent" "GPT-6 Astra Pro subscription")
: > raw_astra.jsonl
for q in "${Q[@]}"; do yt-dlp -j --no-warnings --flat-playlist --skip-download "ytsearch25:$q" 2>/dev/null | jq -c --arg q "$q" '{id,title,channel:(.channel//.uploader//"?"),duration:(.duration//0),views:(.view_count//0),q:$q}' >> raw_astra.jsonl; done
jq -s 'group_by(.id)|map(.[0]+{hits:length})|.[]' -c raw_astra.jsonl > candidates_astra.jsonl
echo "done $(date -u +%FT%TZ) raw=$(wc -l < raw_astra.jsonl) uniq=$(wc -l < candidates_astra.jsonl)" > search_astra.done
