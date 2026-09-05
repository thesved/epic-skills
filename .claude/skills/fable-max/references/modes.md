# fable-max, the non-default modes (goal, session, prompt, api, route)

Loaded only when the user names one of these modes. The default `/fable-max <task>` is `delegate`, which lives in SKILL.md. Shared context: three facts that changed with 5.1 and shape every mode: Anthropic's own routing is "start on Opus 5, escalate to Fable 5.1"; effort is a per-role dial (high to orchestrate, medium for routine planning, low to review, xhigh only after high failed, never max by default); and the harness already ships the autonomy, scope, progress, batching and anti-context-anxiety snippets, so the remaining gap snippets are scope-and-tests, surgical edits, audit-claims, verification cadence.

References per mode: `goal.md` (goal), `prompting.md` + `tokens.md` (session, route), `prompting.md` (prompt), `api.md` (api).

## Mode: goal <objective>

Read `references/goal.md`. Turn the user's objective into a /goal statement.

1. Extract the real want (what they want, not just what is checkable).
2. Draft the condition through the 4-element gate: measurable end state, stated check command, constraints, stop bound ("or stop after N turns").
3. GATE: all 4 present or do not emit. BAN: "clean", "production-ready", "improved", "robust" and other adjectives a Haiku evaluator cannot verify from command output in the transcript.
4. Evaluator-blindness check: the condition must force evidence into the transcript ("run X and show the output"). The evaluator reads the transcript only; it runs nothing. 5.1 narrates less, so demand the evidence be PRINTED.
5. Goodhart check: name what the agent could ship that satisfies the letter but not the want; add a checkable proxy for the qualitative want, and state the permitted initiative (5.1 adds unrequested features unless told otherwise).
6. Emit: the `/goal` line, plus a settings block (model per routing test, `/effort`, auto mode for unattended, budget/turn caps, max subagents), plus one sentence on the riskiest way this goal could technically pass while failing.
7. Multi-clause or evolving goal (>~1,500 chars, or the user will tune it mid-run): use the goal-file pattern from goal.md, clauses live in a user-owned repo file, the `/goal` line forces printing the file + per-clause evidence every checkpoint and bans agent edits to it. Default to this for program-scale goals.
8. Delegation-backed goal (execution runs on other models): the `/goal` line MUST begin with invoking the pattern, `invoke /fable-max delegate and run per <orientation doc>`, and the goal file gets a delegation clause (executors per the delegation map, orchestrator verifies every result itself, checkpoints print who did what). Skill context compacts away; the condition is re-sent every turn, so the /goal line is the only durable carrier of the orchestration pattern.


## Mode: session

Read `references/prompting.md` and `references/tokens.md`. Configure the CURRENT Claude Code session for maximum Fable results. Emit a checklist, applied where possible:

1. Routing test first: does this task earn Fable (long-horizon, ambiguous, root-cause, cross-file, scientific/terminal agent work)? If routine coding, say so and recommend Opus 5 (Anthropic's own default) or Sonnet. Fable is 2x Opus price and capped at 50% of a Max plan's weekly limit.
2. `/model fable` (needs Claude Code 2.1.255+; 2.1.258 recommended), `/effort high` (5.1 default; `medium` if the session is mostly routine planning; `xhigh` only if a `high` attempt failed; never `max` as a default, cite the 1.7x output tokens and 5-minute first-token waits). Effort is saved per model; `s` in the picker makes it session-only. Changing it mid-session restarts the cache.
3. Task prompt in the shape from prompting.md: WHY line + outcome + output format + constraints incl. permitted initiative + verification means + checkpoints.
4. Do NOT paste official snippets into CLAUDE.md or the prompt; the harness ships them. For long runs only, add the gap snippets from prompting.md (scope-and-tests, surgical edits, audit-claims, verification cadence).
5. Budget: `/context` (2.1.258 spends ~37K tokens before your first message; prune skills and MCP servers), `/cost` for the cache line, `/usage` for the 5-hour and weekly Fable bars. Subscription runs at high/xhigh with subagents drain a 5-hour window in 12-60 minutes; cap subagents.
6. Context hygiene: /clear if switching topics, prune stale MCP servers, warn if CLAUDE.md exceeds ~200 lines. Set model + effort + tools BEFORE loading repo context: each change restarts the cache.
7. Security-flavored repos: warn that CLAUDE.md, skills, and git history with exploit wording can flag the session on the first request and pin it to Opus 4.8; `claude --safe-mode` to test, `switchModelsOnFlag: false` to be asked.


## Mode: prompt <file|text>

Read `references/prompting.md`. De-prescribe an Opus-era or Fable-5-era prompt, skill, or CLAUDE.md for Fable 5.1.

1. Run the DELETE list: step-by-step recipes, "show your reasoning" lines (refusal trigger), token countdowns, verification reminders (keep verification MEANS), enumerated edge-case lists, anti-formatting rules, "hold findings for the final response", negative-only constraints, "never xhigh" effort rules, official snippets duplicated into CLAUDE.md. Quote each offending line with file:line. `/claude-api prompt-audit` is the bundled automated pass; run it too.
2. Falsifiable test per rule: does it manage a weaker model's failure mode you no longer observe, or would Claude Code already do this untold? Yes: mark for deletion.
3. Rewrite survivors as goal + reason + boundaries + verification. Prefer one brief instruction over enumerations.
4. Report first, edit only on approval (the user decides what gets cut).


## Mode: api <use case>

Read `references/api.md`. Assemble a Fable 5.1 system prompt for a raw API call, Agent SDK app, or custom subagent body.

1. Confirm the surface (raw API / SDK / subagent); note the SDK `claude_code` preset shortcut before hand-assembling.
2. Migration gate: no forced `tool_choice`, no `thinking` field, append-only history (thinking blocks bound to the prefix on accounts created on/after 2026-08-31), per-message effort and turn-scoped system messages via their beta headers instead of rewriting the prefix.
3. Build: core-law shape (goal, reason, boundaries, verification means) + the snippets the use case needs from api.md (finish-the-whole-task, delivering work, scope-and-tests, surgical edits, batching nudge per turn, progress updates, search-at-low, quoting example, compaction summary, long-output note).
4. GATE: scan the assembled prompt against the DELETE list bans (no show-your-reasoning, no step recipes, no token countdowns, no anti-formatting rules).
5. Emit prompt + paired config (effort, streaming above 21,333 max_tokens, `thinking.display: "updates"`, `fallbacks: "default"` with its beta header and the Opus 4.8 / Opus 5 targets, max_tokens sized for thinking + text, per-request logging of model, effort, cache, transformations).


## Mode: route <task>

Read the routing sections of `references/tokens.md` and `references/prompting.md`. Answer: which model, which effort, single session or sandwich (cheap explores, Fable plans at medium/high, Sol or Opus executes, Fable low or Opus 5 reviews). If the answer involves a non-Claude executor, continue into `delegate`. Always state the cost logic in one line (per completed task, not per token).


## Examples

Input: `/fable-max goal: make the flaky auth tests reliable`
Output:
```
/goal running `npm test -- test/auth` 5 times in a row exits 0 every time
with no test skipped or deleted, and `npm run lint` exits 0; print each
run's output; without modifying test assertions to weaken them and without
touching files outside test/auth and src/auth; or stop after 20 turns
```
Settings: `/model fable` (root-cause hunt across runs = Fable territory), `/effort high`, auto mode ON, at most 2 concurrent subagents. Goodhart risk: the agent could add retries around flaky tests instead of fixing the race; the "no weakened assertions" constraint plus 5-consecutive-runs check guards that.


Input: `/fable-max prompt CLAUDE.md`
Output: a report quoting each Opus-era line with file:line and verdict, e.g. "line 14: 'Always think step by step and show your reasoning before answering' [DELETE: reasoning-extraction refusal trigger on Fable, silently reroutes session to Opus]; line 22: 'After each change run the tests' [DELETE: Fable self-verifies; noise]; line 30: 'Never use bullet points or bold' [DELETE: Fable 5.1 under-formats already; replace with a conditional formatting rule]", then a proposed minimal rewrite, applied only after approval.


Input: `/fable-max route: review this 40-file PR for regressions`
Output: Fable 5.1 at `low` for the discovery pass (CodeRabbit: low beat high on recall), Opus 5 high as the independent precision seat, no Sol needed; cost logic: review is read-heavy and cache-hit-heavy, so it is the one Fable task where the $0.25 cache read matters and the effort dial should go DOWN.
