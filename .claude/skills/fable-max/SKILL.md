---
name: fable-max
description: >-
  Gets maximum results from Claude Fable 5 and forges verifiable /goal
  statements. Defaults to Claude Code context: model and effort choice,
  task-prompt framing, /goal conditions rewritten through a 4-part gate
  (measurable end state, check command, constraints, stop bound).
  De-prescribes Opus-era prompts and CLAUDE.md files that degrade Fable
  (step recipes, show-your-reasoning refusal triggers, token countdowns).
  Routes work between Fable, Opus, Sonnet, and Haiku to cut token spend
  without losing quality. Also builds Fable system prompts for API, Agent
  SDK, and custom subagent harnesses (surfaces without Claude Code's
  built-in Fable instructions). Use when the user says fable-max, max out
  fable, get the most out of fable, fable settings, prompt for fable,
  fable system prompt, api prompt for fable, write my goal, goal
  statement, /goal settings, overnight run setup, should I use fable,
  de-prescribe, save tokens, or reduce token usage.
argument-hint: goal <objective> | session | prompt <file|text> | api <use case> | route <task>
---

Research-backed (official docs + community evidence + Claude Code system-prompt dump, 2026-07-04). Detail lives in four references; load ONLY what the active mode names:

- `references/goal.md`: /goal mechanics, condition gate, templates, overnight runs
- `references/prompting.md`: Claude Code-first Fable prompting (default guide)
- `references/api.md`: API / Agent SDK / subagent system prompts (the 1% case)
- `references/tokens.md`: effort economics, cache breakers, model routing, context hygiene

Pick the mode from the request. No mode named: infer from intent; a bare `/fable-max` means `session`. Default surface is Claude Code; go to `api.md` only when the user names API, SDK, or subagent authoring.

## Mode: goal <objective>

Read `references/goal.md`. Turn the user's objective into a /goal statement.

1. Extract the real want (what they want, not just what is checkable).
2. Draft the condition through the 4-element gate: measurable end state, stated check command, constraints, stop bound ("or stop after N turns").
3. GATE: all 4 present or do not emit. BAN: "clean", "production-ready", "improved", "robust" and other adjectives a Haiku evaluator cannot verify from command output in the transcript.
4. Evaluator-blindness check: the condition must force evidence into the transcript ("run X and show the output"). The evaluator reads the transcript only; it runs nothing.
5. Goodhart check: name what the agent could ship that satisfies the letter but not the want; add a checkable proxy for the qualitative want.
6. Emit: the `/goal` line, plus a settings block (model per routing test, `/effort`, auto mode for unattended, budget/turn caps), plus one sentence on the riskiest way this goal could technically pass while failing.

## Mode: session

Read `references/prompting.md` and `references/tokens.md`. Configure the CURRENT Claude Code session for maximum Fable results. Emit a checklist, applied where possible:

1. Routing test first: does this task earn Fable (long-horizon, ambiguous, architecture, cross-file)? If routine coding, say so and recommend Opus/Sonnet instead. Fable is 2x Opus price.
2. `/model fable`, `/effort high` (xhigh ONLY if capability-critical; cite the 3x cost).
3. Task prompt in the shape from prompting.md: WHY line + outcome + output format + constraints + verification means + checkpoints.
4. Do NOT paste official snippets into CLAUDE.md or the prompt; the harness ships them. For long runs only, add the 3 gap snippets from prompting.md (audit-claims, verification cadence, context-anxiety).
5. Context hygiene: /clear if switching topics, prune stale MCP servers, warn if CLAUDE.md exceeds ~200 lines.
6. Set model + effort BEFORE starting work: mid-session changes invalidate the cache.

## Mode: prompt <file|text>

Read `references/prompting.md`. De-prescribe an Opus-era prompt, skill, or CLAUDE.md for Fable.

1. Run the DELETE list: flag step-by-step recipes, "show your reasoning" lines (refusal trigger), token countdowns, verification reminders (keep verification MEANS), enumerated edge-case lists, and official snippets duplicated into CLAUDE.md. Quote each offending line with file:line.
2. Falsifiable test per rule: does it manage a weaker model's failure mode you no longer observe, or would Claude Code already do this untold? Yes: mark for deletion.
3. Rewrite survivors as goal + reason + boundaries + verification. Prefer one brief instruction over enumerations.
4. Report first, edit only on approval (the user decides what gets cut).

## Mode: api <use case>

Read `references/api.md`. Assemble a Fable system prompt for a raw API call, Agent SDK app, or custom subagent body.

1. Confirm the surface (raw API / SDK / subagent); note the SDK `claude_code` preset shortcut before hand-assembling.
2. Build: core-law shape (goal, reason, boundaries, verification means) + the snippets the use case needs from api.md.
3. GATE: scan the assembled prompt against the DELETE list bans (no show-your-reasoning, no step recipes, no token countdowns).
4. Emit prompt + paired config (effort, streaming, `fallbacks` to Opus 4.8, max_tokens sized for thinking + text).

## Mode: route <task>

Read the routing sections of `references/tokens.md` and `references/prompting.md`. Answer: which model, which effort, single session or sandwich (cheap explores, Fable plans, Opus/Sonnet executes, Fable reviews). Always state the cost logic in one line.

## Examples

Input: `/fable-max goal: make the flaky auth tests reliable`
Output:
```
/goal running `npm test -- test/auth` 5 times in a row exits 0 every time
with no test skipped or deleted, and `npm run lint` exits 0; show each
run's output; without modifying test assertions to weaken them; or stop
after 20 turns
```
Settings: `/model fable` (root-cause hunt across runs = Fable territory), `/effort high`, auto mode ON. Goodhart risk: the agent could add retries around flaky tests instead of fixing the race; the "no weakened assertions" constraint plus 5-consecutive-runs check guards that.

Input: `/fable-max prompt CLAUDE.md`
Output: a report quoting each Opus-era line with file:line and verdict, e.g. "line 14: 'Always think step by step and show your reasoning before answering' [DELETE: reasoning-extraction refusal trigger on Fable, silently reroutes session to Opus 4.8]; line 22: 'After each change run the tests' [DELETE: Fable self-verifies; noise]", then a proposed minimal rewrite, applied only after approval.
