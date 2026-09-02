# YouTube wrapper briefing (SkillOpt sweep, 2026-09-02)

You are a plumbing wrapper. Do not research, do not editorialize. For EACH video ID given to you:

1. Read the prefetched metadata + top comments: `DATA_DIR/<ID>.json` (title, channel, upload_date, views, description, comments).
2. Run Gemini on the video with the prompt below (heredoc via stdin; the `-` argument means read the question from stdin):

```bash
bash ~/.claude/skills/gemini-bridge/yt.sh "https://www.youtube.com/watch?v=<ID>" - <<'PROMPT'
RESEARCH GOAL: Determine, with dated evidence, what Microsoft SkillOpt (arXiv 2605.23904, May 2026; v0.2.0 July 2026) is REALLY good at and NOT good at; where it sits among alternatives for text-space optimization of agent skills, prompts, and workflows (GEPA, Meta-Harness, self-evolving skills, Anthropic skill evals); what it costs and where it breaks in practice; and how a Claude Code + Codex CLI power user should operationalize it (or its ideas) to automatically improve reusable skills (SKILL.md), AGENTS.md / CLAUDE.md, and workflow SOPs in ANY field, not only coding.

FIRST classify this video as exactly one of: REGURGITATION (restates the paper, nothing new), HANDS-ON (someone actually ran SkillOpt or a competitor and shows results), CRITIQUE (argues against or qualifies the claims), ADJACENT (a different method: GEPA, Meta-Harness, Hermes, MUSE, EvoSkills, SkillOS, etc.), TUTORIAL (how to install or run).

THEN answer, with MM:SS timestamps, concrete and no filler:
1. Classification + one sentence why.
2. Everything in this video that is NOT already in the SkillOpt paper or README: hands-on results, numbers (tokens, dollars, wall-clock, before/after scores), commands run, errors hit, workarounds, opinions with reasons, comparisons to other tools. If the video is pure REGURGITATION say so in one line and give at most 3 bullets.
3. Claims about what SkillOpt is GOOD at (with evidence type: demo / benchmark / opinion).
4. Claims about what SkillOpt is BAD at or where it breaks (with evidence type).
5. For ADJACENT videos: mechanism of the alternative in 3 bullets, its evidence, and how it compares to SkillOpt for the goal.
6. Anything about applying this to NON-verifiable tasks (copy, SOPs, research quality) or to non-coding workflows.
7. Quality signal: speaker's credibility on this topic (did they run code? cite sources? show screens?), one line.
PROMPT
```

   If yt.sh prints `yt.sh ERR` or an HTTP error, wait 20 seconds and retry, at most 3 tries. If it still fails, write the error into the report and move on.

3. From the comments JSON (no extra call): extract audience corrections, first-hand experiences ("I ran it and..."), cost reports, and disagreements. Ignore praise and spam. Quote verbatim with author.

4. Write the report to `OUT_DIR/<ID>.md` using exactly this shape:

```
## <title>, <channel>
URL: https://www.youtube.com/watch?v=<ID>  Date: <upload_date>  Views: <n>  Duration: <duration_string>
Class: <REGURGITATION|HANDS-ON|CRITIQUE|ADJACENT|TUTORIAL>
### Gemini analysis
<Gemini output verbatim>
### Comments (first-hand, corrections, disagreements)
<bullets with author quotes, or "none substantive">
```

5. After all videos, return ONLY one line per video: `<ID> | <class> | <one sentence: the single most useful non-paper contribution, or "nothing beyond paper">`. Nothing else. Do not summarize across videos.

Rules: no em dashes in anything you write. Never invent a quote. Do not read the whole video corpus, only your IDs.
