# Fable 5.1 Prompting Playbook (Claude Code first)

Default context: you are prompting Fable INSIDE Claude Code (99% case). Claude Code 2.1.258's own system prompt already ships Anthropic's Fable 5.1 snippets (verified against the live prompt this session and the Piebald-AI extraction of 2.1.257, 2026-09-01), so your leverage is the task prompt, the effort dial, and the /goal condition, not system-level behavior rules. For raw API, Agent SDK, or custom subagent bodies (surfaces that ship bare), load `api.md`.

Official facts from platform.claude.com (models/fable-5-1/*, prompt-engineering/prompting-claude-fable-5-1, effort, refusals-and-fallback) and code.claude.com (model-config, goal, prompt-caching), accessed 2026-09-02. Community facts flagged inline with source and date; the day-one sweep (2026-09-01/02) covered 93 YouTube tests, HN, Reddit, X, CodeRabbit, Every, Cognition, Snorkel, Vals, Artificial Analysis, ARC Prize.

## Contents
- Facts (what Fable 5.1 is and costs)
- What Claude Code already ships (do not duplicate)
- The core law: goal + reason + boundaries + verification
- The task prompt shape
- What changed from Fable 5 (7 official deltas + fixes)
- The gap snippets (long runs only)
- DELETE list (scaffolding that hurts Fable)
- Refusal navigation
- Routing: when NOT to use Fable
- Inversions (how competent users sabotage themselves)

## Facts

- `claude-fable-5-1`, released 2026-09-01. Same weights as `claude-mythos-5-1` (Project Glasswing only, fewer safeguards). Successor to Fable 5 (2026-06-09). Knowledge cutoff Jun 2026.
- $10 in / $50 out per MTok (2x Opus 5), cache read $0.25 (quarter of Fable 5, half of Opus 5), cache write $12.50/$20 unchanged. 1M context flat-priced, 128K max output. "Slower" latency tier: ~50-66 tok/s output, time-to-first-token 6 s at low, 39 s at high, 130 s at xhigh, 297 s at max (Artificial Analysis, 2026-09-02).
- Anthropic's own routing: "For most workloads, start with Claude Opus 5. Use Claude Fable 5.1 for demanding reasoning and long-horizon agentic work, or when your evals on Claude Opus 5 at higher effort still fall short." fable-max is an escalation profile, not a default.
- Thinking always on, adaptive, invisible (raw chain of thought never returned). No prefill, no non-default temperature/top_p/top_k. 30-day retention, no ZDR unless Anthropic authorizes.
- Safety classifiers: `cyber`, `bio`, `frontier_llm`, `reasoning_extraction`, `general_harms`. Claude Code flagged request → session silently moves to Opus 4.8 (cyber) or Opus 5 (bio) and STAYS there until you re-select. Anthropic: cyber false positives down 60% per Claude Code session vs Fable 5, bio 85% down; finding vulnerabilities in source is now allowed, exploit writing and pentesting are not.
- Claude Code: `/model fable` (2.1.255+ resolves the alias to 5.1; 2.1.258 recommended; the Claude apps gateway still maps `fable`/`best` to Fable 5, pick 5.1 explicitly there). Default effort HIGH in Claude Code, MEDIUM on claude.ai and Cowork. Never the account default on any plan. Fast mode (`/fast`) is Opus-only.
- Plans: Max, Team Premium, Enterprise Premium include it up to 50% of the weekly limit ("uses your limits ~2x faster than Opus" per the picker). Pro runs it on usage credits only. Weekly limits change 2026-09-14 (+25% permanent replaces +50% temporary, a net 17% cut vs late August).
- Every text output carries a statistical watermark.

## What Claude Code already ships (do not duplicate)

Verified in the 2.1.258 live system prompt for Fable 5.1: the full "operating autonomously" block, the "Delivering work" scope block, the progress-updates line ("Before you start, say in a line what you're about to do..."), lead-with-outcome writing rules (no em dashes, no parentheticals, lists for parallel items), report-faithfully, assessment-vs-action, act-when-ready, "don't wrap up early because context is summarized" (the context-anxiety fix), memory format, and two per-turn injections: the tool-batching nudge ("First privately list what you need next; then request every item that doesn't depend on another's result in this one response.") and the tool-output-visibility note. Claude Code also nudges the model when the user has not heard from it in a while. This holds for interactive sessions AND `claude -p`.

BAN: pasting official Fable snippets into CLAUDE.md. Redundant with the harness, a per-turn token tax (Claude Code 2.1.258 already spends ~37K tokens on system prompt + tools + skills before your first message; `/context` shows it), and CLAUDE.md past ~200 lines "may reduce adherence". Falsifiable test for ANY rule you are about to add: would Claude Code already do this without being told? Yes: do not add it.

Not shipped (see gap snippets): scope-and-tests restraint, surgical-edit instruction, search-at-low-effort nudge, audit-claims, self-verification cadence, quote audit.

Surfaces that ship WITHOUT the snippets (load `api.md`): raw Messages API, Agent SDK without the `claude_code` preset, custom subagents ("only this system prompt plus basic environment details").

## The core law

Anthropic cut Claude Code's own system prompt ~80% for Fable 5 and kept it lean for 5.1. The surviving shape: **give the model a goal, the reason behind it, explicit boundaries, and a way to verify its own work.** Your task prompts should have the same shape.

Official (model-config, "To get the most from Fable"):
1. Describe the outcome, not the steps.
2. Hand it ambiguous problems (root-cause hunts, outage debugging, architecture). Launch evidence: Millennium's 4-5-year-old 1-in-a-million crash, Red Hat "root cause of every broken build we tested", Ramp's unattended 38-hour research run.
3. Skip verification reminders (it self-verifies). A verification MEANS (test command, spec, oracle, Playwright + screenshots) is not a reminder; keep providing that. The ruler, not the nag.
4. Size up: give it work you would normally break into pieces.
5. Keep it working until the outcome holds: set a goal (/goal).

Official: "Start at the top of your difficulty range." And new for 5.1: "Your existing Claude Fable 5 prompts should perform well on Claude Fable 5.1 without changes."

## The task prompt shape

```
I'm working on [the larger task] for [who it's for]. They need [what the output enables].
Request: [one clear sentence, the OUTCOME, not the steps]
Output format: [exactly how structured / delivered]
Constraints: [what must NOT happen; what initiative IS permitted]
Verify with: [the means: test command, spec, oracle, screenshot check]
Checkpoints: [when to stop and ask; omit and it runs autonomously]
```

The WHY line is load-bearing (official: Fable "performs better when it understands the intent behind a request"). The verify line is the ruler. New for 5.1: the **permitted-initiative line**. "Useful initiative" and "scope creep" are the same behavior under different acceptance criteria (Lane B synthesis, 2026-09-02): 7 unrequested SEO articles on a SaaS build, unrequested font-hunting background agents on a design task, "only generate the slides, don't do anything else" as the fix (Rogoff, 2026-09-01). Say what extras are welcome and what are not.

For deadline-shaped tasks say "ship a runnable end-to-end slice first, then deepen": under a 7-minute cap Fable 5 shipped a playable game, Fable 5.1 built deeper modules and no `index.html` (Agent Workflow Lab, 2026-09-02).

For multi-turn autonomy, convert the outcome into a /goal (goal.md, 4-element gate).

## What changed from Fable 5 (7 official deltas + fixes)

Each is documented by Anthropic with a prompting fix; the fix text is in api.md. Inside Claude Code, items 1, 2, 4 and 5 are already handled by the harness.

| # | 5.1 behavior | Where it bites | Fix |
|---|---|---|---|
| 1 | One tool call per turn in coding/computer-use loops where the next reads are implied (explicitly named fetches still run in parallel) | Extra round trips and wall-clock, same answer quality | Per-turn batching nudge (CC ships it). API: turn-scoped system message every tool-result turn |
| 2 | Fewer progress updates, more so at higher effort and in long tool chains; final message may cover only the last step | Silent minutes; evaluator sees less | CC ships the progress line. API: `thinking.display: "updates"`; delete any "hold findings for the final response" line |
| 3 | At `low`, answers from memory instead of searching | Stale facts (a tester got Dec-2025 subscriber counts, Nyanta 2026-09-02) | Raise effort for that turn, or the search-nudge snippet |
| 4 | Denser prose | Reader fatigue | "Please remove all mannered prose." in the user message (CC ships writing rules) |
| 5 | Less bold/headers/lists | Old anti-formatting rules over-suppress | Delete them; conditional formatting rule (CC ships one) |
| 6 | Reproduces source passages without quote marks; Every got 43 "quotes" when asking for 8-12, several not in the source | Research and summaries | One complete worked example in the prompt; audit every exact quote against the source before delivery |
| 7 | Whole-file rewrites for small edits | Output tokens, time; FrontierCode score fell at higher effort because unrequested files got touched (Cognition 2026-08-31) | Surgical-edit snippet; "unified diff with 3 lines of context" for API harnesses |

Also documented: stops to ask "Shall I apply this?" for already-authorized work, or narrates the next step instead of doing it (fix: the autonomy block, CC ships it); asks fewer clarifying questions once that block is present (so list the confirmations you DO want); at xhigh/max drafts a long deliverable in thinking and again in output (run those at high; one tester hit the 64K output cap three times at high on a physics sim and shipped nothing, Chaen 2026-09-02; another exhausted a 64K thinking budget with zero output, AICodeKing 2026-09-02).

Positive deltas worth exploiting: holds state across 40+ steps and says when it is stuck instead of reporting success (Anthropic PM, X 2026-09-01); Playwright/Chromium self-testing loops fix real bugs unprompted when the harness is named in the prompt (Marvijo, 2026-09-01: 5 bugs caught in a 48-min, 195K-token run); pushes back on wrong diagnoses and bad architecture ("just give it bash" for local models, van Zyl 2026-09-02); vision on dense charts jumps from 29% to 73% with a crop/zoom tool (official); computer use recovers from failed steps.

## The gap snippets (long runs only)

Not in the Claude Code prompt. Paste into the task prompt (not CLAUDE.md) for long or unattended runs; verbatim text in api.md:

1. **Scope and tests** ("If, while working or testing, you find a pre-existing bug... report it as a follow-up... Commit tests only where the task asks..."). Official: unrequested additions and committed test files "drop substantially with no measurable change in task success".
2. **Surgical edits** ("The number of tokens used to edit files is best minimized...").
3. **Audit claims** ("Before reporting progress, audit each claim against a tool result from this session..."). Snorkel's transcript audit (2026-09-01) found 5.1 claiming to have re-verified work it had not re-run; CC ships only the report-faithfully half.
4. **Self-verification cadence** ("Establish a method for checking your own work at an interval of [X]..."). `/claude-api prompt-audit` flags end-state-only verification on multi-hour builds for exactly this reason.
5. **Search at low effort** (only if you run subagents or turns at `low`).
6. **Quote audit** for research deliverables: every exact quote checked against source text.

Do NOT add: "do not ask clarifying questions" (already shipped; stacking it suppresses the questions you want), "you have ample context" (shipped), progress-update requests (shipped), tool-batching (shipped per turn).

## DELETE list

Each of these Opus-era or Fable-5-era habits degrades 5.1 or wastes tokens. Falsifiable test: does the rule manage a failure mode you no longer observe, or would Claude Code do it untold? Yes: delete. Lance Martin (Anthropic, X 2026-09-01): strip "verification rituals, emphasis boosters, scratchpad requests, step-by-step chain examples, and contradictory rules". `/claude-api prompt-audit` finds most of these.

1. **Step-by-step recipes.** Fable follows them literally, even when wrong. Official: "Prefer general instructions over prescriptive steps."
2. **"Show your reasoning / think out loud / reproduce your chain of thought."** `reasoning_extraction` is an official refusal category; in Claude Code a refusal reroutes the session to Opus. Ask for conclusions, evidence, assumptions, or a brief rationale.
3. **Token/context countdowns.** Early stopping. Claude Code now tells the model not to wrap up early; do not undo that with your own budget nagging.
4. **Verification reminders** ("remember to run the tests"). Noise. Keep the verification MEANS.
5. **Enumerated edge-case behavior lists.** One brief instruction steers most behaviors.
6. **Anti-formatting rules** ("never use bullets or bold"). New for 5.1: it under-formats already; these rules strip structure the content needs.
7. **"Hold all findings for the final response."** New for 5.1: silences the few progress updates it still writes.
8. **Negative-only constraints where the intent is statable** ("No text inside generated images"). `/claude-api prompt-audit` flags them; say the intent.
9. **"Always use high, never xhigh" rules from the Fable 5 guide.** Obsolete: 5.1 scales cleanly to xhigh/max (Fable 5 saturated); the rule is now "high default, sweep per task".
10. **Official snippets duplicated into CLAUDE.md.** The harness ships them.

Self-audit prompt (Pawel Huryn, 2026-06-11, still the best):
```
Read your own instruction files (CLAUDE.md, skills, rules, memory files) end to end.
1. Where do they contradict each other? Quote both sides.
2. Which rules exist to manage a weaker model: guardrails for failure modes you
   don't have, recipes for things you no longer need spelled out, hardcoded facts
   that have drifted? List them with file:line.
3. Which rules teach by bad example: documents that violate the patterns they prescribe?
4. What would you delete? What would you keep exactly as is, and why?
Don't fix anything yet. Report first. I decide what gets cut.
```

## Refusal navigation

- Official false-positive triggers and fixes: ask "Are there any bugs in this program?" not "Does this compile without errors?"; explain lesser-known languages and hand over their docs; strip base64 from tool output before it re-enters context.
- Phrase security work defensively ("I am reviewing my own authorized codebase"), say "input-validation bugs" not "security audit". Finding vulnerabilities is allowed on 5.1; pentest scripts, exploit payloads, binary scanning are not (route those to Opus 5 directly, or the DeepSeek seat per the cache table).
- The first request of a session carries CLAUDE.md, directory listing, git status and loaded skills: security wording there (or "virology" in git history, HN 2026-09-01) can flag the session before you type anything. Anthropic staff: check skills and CLAUDE.md first. `claude --safe-mode` isolates it.
- Day-one false positives still reported: "military campaign" metaphor in math, signed-cookie REST work flagged as cryptography, a Windows-to-Linux port refusing at the auth code, Linux `seccomp` mentions, medical/biotech work, asking the model about its own release ("smoked Astra" tester got silently rerouted). Non-deterministic: the same refused protein-binding prompt ran later without complaint (CodeFactory, 2026-09-02).
- The fallback banner shows ONCE; the session then stays on Opus 4.8/5. `switchModelsOnFlag: false` makes it ask instead (headless turns end with a refusal). Verify per-turn serving model in `~/.claude/projects/<slug>/<session>.jsonl`, field `message.model` (a Fable 5 issue #76518 has a cron watcher for `model_refusal_fallback`).
- A memory file that records the refusal can re-trigger it on restart. Scrub refusal mentions from memory files.
- Never carry a subagent's exploit-flavored report back into the Fable session (delegation.md).

## Routing: when NOT to use Fable

Anthropic and the day-one evidence agree: Opus 5 is the daily driver, Fable 5.1 is the hard tail and the long unattended run.

- **Fable 5.1**: long-horizon (hours+), ambiguous or underspecified, root-cause debugging, cross-file review, scientific/terminal agent work (Terminal-Bench-Science 52.6% vs Opus 5 29.0%, official), policy-heavy approvals (Zapier: 100% where Fable 5 scored 0), objective critique (rejects sycophantic framings GPT-5.6 Sol accepts, Every and Chaen 2026-09-01/02), first-principles architecture audits, design taste on single-file UI (dethroned Opus 5 on multi-component one-shot UI per several testers; lost 4 of 5 blind taste tests to Opus 5 in another, Simmons 2026-09-02, so taste is a coin flip, verify).
- **Opus 5 high**: routine coding, maintenance, fast interactive turns, slide/document presentation polish, operations-style cross-app workflows (Zapier: Opus 5 50% vs Fable 5.1 36%), and anything under a tight deadline. Snorkel matched-task set: Opus 5 solved 23 vs Fable 5.1's 20, and 67% vs 18% on build/dependency tasks ("Fable is not a strict upgrade in this evaluation", 2026-09-01). Opus 5 review seat stays (higher precision, Fable higher recall).
- **GPT-5.6 Sol**: the executor. Senior SWE-Bench tasteful pass tie at 34.7% with Sol xhigh at about half Fable's output cost; Sol wins mechanics/interaction logic and speed on visual builds (RemakeBench 2026-09-02; Finn: Sol 2 min vs Fable 12 min for the same 20/20 build), Fable wins agentic hunts (Finn's Gauntlet: Fable 100/100 in 143 tool calls, Sol 0/100) and factual research depth (Kasra: 344 tool calls, real ASINs). Full logic in delegation.md.
- **Sonnet/Haiku**: mechanical execution, wrappers.
- **Grok 4.6 / GLM 5.3 Flash / Kimi K3**: 90-96% of the quality at 1/10 to 1/400 the dollar cost on the same gauntlets (Johnston 2026-09-02: Grok $2.50 vs Fable $42.24 for a 94 vs 98 score). Opinion seats and bulk, per the cache table.
- **GPT-6 Astra** (2026-09-03, `gpt-6-astra`, $10/$50 like Fable, cache read $1 vs Fable's $0.25): reachable on the Pro sub, API key and OpenRouter since 2026-09-05 (Codex 0.153.4). It takes computer use / browser QA (OSWorld 72.6 in 40 min vs Sol 65.7 in 75), long tool-heavy runs (1/3 of Sol's tokens per coding task) and terminal science (TB-Science 64.6 vs Fable 5.1 52.6); Fable 5.1 keeps orchestration, ambiguous asks, UI taste, review verdicts and breadth (AA Intelligence 66 vs 61, Coding Agent 70 vs 67, HLE 65.0 vs 57.2). Operating card and effort ladder in `_model-cache/examples/openai.md`, evidence in `_model-cache/research/2026-09-04/`.
- Sandwich (still the best shape): cheap model explores, Fable plans at medium/high, Sol executes (Astra for GUI-in-the-loop or multi-hour tool runs; Muse Spark 1.3 at low for cheap bounded non-sensitive work and 1M-token reads, card in `_model-cache/examples/muse.md`), Fable or Opus reviews.

## Inversions (how competent users sabotage themselves)

1. **"More instructions = more control."** On Fable your guardrails ARE the sabotage: recipes degrade output, one "show your reasoning" line reroutes the session to Opus, and stacked autonomy blocks kill the clarifying questions you wanted.
2. **"The official snippets belong in my CLAUDE.md."** The harness ships them; you pay ~37K base tokens per turn already.
3. **"max = best results."** Measured: 5.1 max scores 66 on the AA index at $3.69-3.76 per task and 1.7x the output tokens of Fable 5; xhigh scores 65 at $2.72; high 62 at $1.43 (2026-09-01). CodeRabbit's 45-task review: `low` beat `high` on recall (61.0 vs 57.1%) and was faster. Cognition's FrontierCode peaked at `medium`. High is the default, medium the workhorse, low the reviewer, xhigh the escalation, max the exception with a stop bound.
4. **"The green /goal check means done."** Evaluator reads the transcript only; 5.1 writes fewer progress notes, so force evidence to be PRINTED. See goal.md.
5. **"The fallback banner will warn me."** Once. Then the session is Opus until you switch back.
6. **"Cheaper cache reads = cheaper runs."** True only when cache READS were a third or more of the old bill. Cache WRITES ($12.50-20/M) were 58-66% of two measured multi-turn bills (AICodeKing session; a 573M-token enterprise run at $1,024); max effort adds output tokens faster than the read discount removes them; subscriptions do not see the API price at all (Anthropic: reads count at a reduced rate toward usage, "overall ~same as Fable 5"). Stable prefixes and effort discipline are the levers.
7. **"Fable is the best model, so use it for everything."** It loses to Opus 5 on routine PRs at 2x the price, burns the 5-hour Max window in 12-60 minutes on parallel high/xhigh builds with subagents (dozens of day-one reports), and caps at 50% of your weekly limit. Pay for the hard 10%.
