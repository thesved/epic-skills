#!/bin/bash
# pipeline.sh <name> <ids-file> <goal-file> <mindate YYYYMMDD> [exclude-ids-file]
# 1) fetch metadata + top 60 comments per id (parallel 8) -> meta/<id>.json  2) filter by upload_date  3) analyze with yt.sh (parallel 5) -> reports_<name>/<id>.md  4) index
NAME=$1; IDS=$2; GOAL=$3; MIN=$4; EXCL=${5:-/dev/null}
D=$HOME/.claude/skills/_model-cache/research/2026-09-05/yt; cd $D
fetch(){ id=$1; [ -s meta/$id.json ] && return; yt-dlp -j --no-warnings --skip-download --write-comments --extractor-args "youtube:max_comments=60;comment_sort=top" "https://www.youtube.com/watch?v=$id" 2>/dev/null | jq -c '{id,title,channel:(.channel//.uploader//"?"),upload_date,duration,view_count,like_count,description:(.description//""|.[0:1500]),comments:[.comments[]?|{author,like_count,text:(.text|.[0:300])}]}' > meta/$id.json; }
export -f fetch
grep -v -F -f $EXCL $IDS | xargs -P 8 -I{} bash -c 'fetch {}'
: > list_$NAME.txt
for id in $(cat $IDS); do [ -s meta/$id.json ] || continue; grep -qxF "$id" $EXCL 2>/dev/null && continue; ud=$(jq -r '.upload_date//"0"' meta/$id.json); [ "$ud" -ge "$MIN" ] && echo $id >> list_$NAME.txt; done
echo "fetch done $(date -u +%FT%TZ) in-scope=$(wc -l < list_$NAME.txt)" > pipeline_$NAME.fetched
analyze(){ id=$1; NAME=$2; GOAL=$3; out=reports_$NAME/$id.md; [ -s $out ] && return; m=meta/$id.json
  ctx=$(jq -r '"TITLE: \(.title)\nCHANNEL: \(.channel)\nUPLOADED: \(.upload_date)\nLENGTH: \(.duration) s\nVIEWS: \(.view_count) LIKES: \(.like_count)\nDESCRIPTION: \(.description)\n\nTOP COMMENTS (\(.comments|length)):\n" + ([.comments[]|"- @\(.author) (\(.like_count//0) likes): \(.text)"]|join("\n"))' $m)
  { echo "## Video: $(jq -r .title $m), $(jq -r .channel $m)"; echo "**URL:** https://www.youtube.com/watch?v=$id  **Views:** $(jq -r .view_count $m)  **Date:** $(jq -r .upload_date $m)  **Length:** $(jq -r .duration $m)s"; echo;
  bash ~/.claude/skills/gemini-bridge/yt.sh "https://www.youtube.com/watch?v=$id" - <<PROMPT
$(cat $GOAL)

Watch the video at the URL and use the metadata and top comments below. Report ONLY through the lens of the research goal. Every finding needs a timestamp. Separate DEMONSTRATED (shown on screen: a run, a terminal, a bill, a table) from ASSERTED (said or read from a press release). Never invent numbers. No em dashes.

Output format (markdown, keep headings exactly):
**ADDRESSES GOAL:** yes / partially / no, one line why
**HANDS-ON:** yes (presenter actually ran the model) / no (reaction only)
**CONFIDENCE:** 1 to 5
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
xargs -P 5 -I{} bash -c "analyze {} $NAME $GOAL" < list_$NAME.txt
echo "analyze done $(date -u +%FT%TZ) reports=$(ls reports_$NAME | wc -l)" > pipeline_$NAME.done
