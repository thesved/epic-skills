#!/bin/bash
# pipeline2.sh <name> <ids-file> <goal-file> <candidates.jsonl>: metadata-free analysis (YouTube blocks yt-dlp watch pages on this IP today); uses flat-search fields, plus meta/<id>.json when present.
NAME=$1; IDS=$2; GOAL=$3; CAND=$4
D=$HOME/.claude/skills/_model-cache/research/2026-09-05/yt; cd $D; mkdir -p reports_$NAME
analyze(){ id=$1; NAME=$2; GOAL=$3; CAND=$4; out=reports_$NAME/$id.md; [ -s $out ] && return
  if [ -s meta/$id.json ]; then m=meta/$id.json; hdr="## Video: $(jq -r .title $m), $(jq -r .channel $m)
**URL:** https://www.youtube.com/watch?v=$id  **Views:** $(jq -r .view_count $m)  **Date:** $(jq -r .upload_date $m)  **Length:** $(jq -r .duration $m)s"; ctx=$(jq -r '"TITLE: \(.title)\nCHANNEL: \(.channel)\nUPLOADED: \(.upload_date)\nLENGTH: \(.duration) s\nVIEWS: \(.view_count)\nDESCRIPTION: \(.description)\n\nTOP COMMENTS (\(.comments|length)):\n" + ([.comments[]|"- @\(.author) (\(.like_count//0) likes): \(.text)"]|join("\n"))' $m)
  else c=$(grep -F "\"id\":\"$id\"" $CAND | head -1); hdr="## Video: $(echo "$c" | jq -r .title), $(echo "$c" | jq -r .channel)
**URL:** https://www.youtube.com/watch?v=$id  **Views:** $(echo "$c" | jq -r .views)  **Date:** unknown (metadata fetch blocked)  **Length:** $(echo "$c" | jq -r .duration)s"; ctx=$(echo "$c" | jq -r '"TITLE: \(.title)\nCHANNEL: \(.channel)\nLENGTH: \(.duration) s\nVIEWS: \(.views)\n(no description or comments available; state the upload date if it is visible in the video or its page)"'); fi
  { echo "$hdr"; echo; bash ~/.claude/skills/gemini-bridge/yt.sh "https://www.youtube.com/watch?v=$id" - <<PROMPT
$(cat $GOAL)

Watch the video at the URL and use the metadata below. Report ONLY through the lens of the research goal. Every finding needs a timestamp. Separate DEMONSTRATED (shown on screen: a run, a terminal, a bill, a table) from ASSERTED (said or read from a press release). Never invent numbers. No em dashes.

Output format (markdown, keep headings exactly):
**ADDRESSES GOAL:** yes / partially / no, one line why
**HANDS-ON:** yes (presenter actually ran the model) / no (reaction only)
**CONFIDENCE:** 1 to 5
**UPLOAD DATE:** if visible, else unknown
### Demonstrated findings (with timestamps)
### Asserted claims (with timestamps)
### Strengths reported
### Weaknesses, failures, refusals, costs reported
### How-to-get-the-max tips (effort, prompts, harness, settings, pricing tiers)
### Comparisons vs other models (numbers)
### What the comments add (corrections, counter-evidence, first-hand reports)

$ctx
PROMPT
  } > $out 2>&1; }
export -f analyze
xargs -P 6 -I{} bash -c "analyze {} $NAME $GOAL $CAND" < $IDS
echo "analyze done $(date -u +%FT%TZ) reports=$(ls reports_$NAME | wc -l)" > pipeline2_$NAME.done
