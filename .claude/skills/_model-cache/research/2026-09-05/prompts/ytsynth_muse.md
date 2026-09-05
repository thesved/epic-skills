TASK: synthesize the per-video YouTube analysis reports in the directory `reports_muse/` (one markdown file per video, produced by Gemini 3.7 Flash watching each video with a research goal) into ONE evidence document about Meta's Muse Spark 1.3 for a developer who orchestrates several AI models (Claude Fable 5.1 orchestrates, GPT-5.6 Sol and GPT-6 Astra implement via Codex, Gemini 3.7 Flash for video, cheap open models for bulk; Muse reachable only via OpenRouter).

Read EVERY file in reports_muse/ (use shell: ls, cat, grep; there are about 150 files). Also read `list_muse.txt`, `ids_muse2.txt`, `ids_muse3.txt` only if you need the id lists. Do not modify any file. Write the final document as your final message.

The reports have these fields: ADDRESSES GOAL, HANDS-ON (yes = presenter actually ran the model), CONFIDENCE 1-5, UPLOAD DATE, then sections Demonstrated findings (with timestamps), Asserted claims, Strengths, Weaknesses, How-to-get-the-max tips, Comparisons vs other models (numbers), What the comments add. Header line has the video title, channel, URL, views, date, length.

RULES: 1) Hands-on videos about Spark 1.3 carry almost all the value; rank them first. Videos that only re-read Meta's launch table are context, not evidence; say so. 2) Every finding cites the video (channel, title, id) and the timestamp from the report. Never invent a number; copy numbers exactly as the report states them. 3) Grade each finding D (demonstrated on screen) or A (asserted). 4) Separate Spark 1.3 from 1.2/1.1 and from Glimmer; Glimmer only where a video compares it to Spark. 5) No em dashes or en dashes anywhere. 6) Frontload: the first section must be the decisions, each one sentence bolded then evidence.

OUTPUT (markdown, headings exactly):
# YouTube sweep 2026-09-05: <N> videos on Meta Muse Spark 1.3, Gemini 3.7 Flash analyst, goal-lensed
One paragraph: scope, how many hands-on, how many reaction-only, how many not analyzable.
## TLDR for our routing (10 to 15 bolded decisions with evidence)
## Who actually ran it (table: source | harness or surface | what they did | grade | video id)
## Strengths (table: finding | grade | source with timestamp)
## Weaknesses, failures, refusals, costs (table)
## Measured costs, speed, tokens (table with every dollar, token, tok/s and wall-time number found, with source)
## How-to-get-the-max: effort, prompting, harness, tiers (numbered rules, each with source)
## Comparisons with numbers (Fable 5.1, Sol, Astra, Gemini 3.7/3.8 Flash, DeepSeek, GLM, Qwen; table)
## Spark 1.3 vs 1.2 regressions and gains reported
## Muse Code CLI, Contemplating mode, free and contributor tiers, region gating (what videos showed)
## Contradictions between videos and what resolves them
## Index (table of ALL videos: views | date | length | channel | title | hands-on | addresses goal | confidence | id), sorted hands-on first then views
