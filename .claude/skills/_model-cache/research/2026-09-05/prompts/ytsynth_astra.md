TASK: synthesize the per-video YouTube analysis reports in the directory `reports_astra/` (one markdown file per video, produced by Gemini 3.7 Flash with a research goal) into ONE delta document: what is NEW about GPT-6 Astra since our 2026-09-04 sweep (which already covered 82 videos from the launch window and concluded: Astra = computer-use and long-horizon executor, not an orchestrator; effort high is the sweet spot, max buys nothing; asks more clarifying questions, stops early, over-tests, over-formats, sensitive to AGENTS.md; fixes = action-chaining clause, pruned AGENTS.md, locked tests; Plus excluded from Chat; Pro 200 messages per week; Codex limits separate; 272K input cliff on the API; cyber refusals). The reader runs Astra through the Codex CLI on a ChatGPT Pro subscription next to Claude Fable 5.1 and GPT-5.6 Sol.

Read EVERY file in reports_astra/ (use shell: ls, cat, grep; about 80 files). Do not modify any file. Write the final document as your final message.

RULES: 1) Only what is new or different vs the 09-04 conclusions above; confirmed-unchanged items go in one short list. 2) Hands-on videos (HANDS-ON: yes) first; reaction-only videos are context. 3) Every finding cites channel, title, id and timestamp; copy numbers exactly; grade D (demonstrated) or A (asserted). 4) No em dashes or en dashes. 5) Frontload.

OUTPUT (markdown, headings exactly):
# YouTube delta 2026-09-05: <N> new videos on GPT-6 Astra since the 09-04 sweep
## TLDR: what changed (8 to 12 bolded decisions with evidence)
## Who actually ran it now (table: source | surface | what they did | grade | id)
## New measured numbers (cost, tokens, wall time, limits burn; table)
## New failure modes and fixes (table)
## New comparisons vs Fable 5.1 / Sol / Gemini 3.8 Flash / Muse Spark 1.3 (table)
## Confirmed, unchanged
## Index (table of ALL videos: views | date | length | channel | title | hands-on | addresses goal | confidence | id)
