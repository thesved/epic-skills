#!/bin/bash
# search.sh: 25 YouTube queries x 25 flat results -> candidates.jsonl (deduped by id)
D=$HOME/.claude/skills/_model-cache/research/2026-09-05/yt; cd $D
Q=("Muse Spark 1.3" "Meta Muse Spark" "Muse Spark 1.3 review" "Muse Spark 1.3 vs Fable 5.1" "Muse Spark vs GPT-6 Astra" "Meta Muse model AI" "Muse Glimmer 30B" "Muse Glimmer local" "Meta Superintelligence Labs Muse" "Muse Spark coding test" "Muse Spark agentic" "Muse Spark OpenRouter" "Muse Spark contributor tier" "Muse Spark 1.2" "Meta Muse Spark benchmark" "Muse Spark hands on" "Meta Muse Spark 1.3 released" "Muse Spark API tutorial" "Muse Spark Claude Code" "Meta AI new model Muse" "Muse Spark multimodal video" "Muse Spark 1.1" "Meta Muse LLM" "Muse Glimmer 30B ollama" "Muse Spark Cline" "Meta Muse Spark Gemini 3.7 comparison")
: > raw.jsonl
for q in "${Q[@]}"; do yt-dlp -j --no-warnings --flat-playlist --skip-download "ytsearch25:$q" 2>/dev/null | jq -c --arg q "$q" '{id,title,channel:(.channel//.uploader//"?"),duration:(.duration//0),views:(.view_count//0),q:$q}' >> raw.jsonl; done
jq -s 'group_by(.id)|map(.[0]+{hits:length})|.[]' -c raw.jsonl > candidates.jsonl
echo "done $(date -u +%FT%TZ) raw=$(wc -l < raw.jsonl) uniq=$(wc -l < candidates.jsonl)" > search.done
