# /goal Forging: bulletproof goal statements

Official facts from code.claude.com/docs/en/goal and docs/en/model-config (accessed 2026-09-02, Claude Code 2.1.258). Community facts flagged inline. Fable 5.1 (2026-09-01) changes the economics of long runs (cache reads at $0.25/MTok, longer unattended horizon) but the evaluator mechanics are the same; verified 5.1 overnight `/goal` transcripts are still thin (2026-09-02), so treat the 5.1-specific advice as provisional.

## Contents
- Mechanics (how /goal actually works)
- The 4-element gate
- Evaluator blindness (the load-bearing insight)
- Goal file pattern
- Goodhart warning
- Template gallery (real, published)
- Fable 5.1 + /goal combo settings
- Overnight / unattended runs
- Failure gallery

## Mechanics

- `/goal <condition>`: prose condition, max 4,000 chars. Setting it starts a turn immediately with the condition as the directive. Replaces any active goal. One per session.
- After EVERY turn a separate evaluator (your configured small fast model, default Haiku; override with `ANTHROPIC_DEFAULT_HAIKU_MODEL`, which also moves every other small-model job) receives condition + conversation and returns one of three verdicts with a reason: **not yet met** (Claude continues, taking the reason as guidance), **met** (goal clears, achieved entry in transcript), **impossible** (goal clears, failed entry). Ctrl+O shows the reason; `/goal` (no args) shows condition, elapsed time, turns evaluated, token spend, last reason.
- The evaluator reads the TRANSCRIPT ONLY. It runs no commands, reads no files. Official: "It doesn't run commands or read files independently."
- No-progress guard: several consecutive turns with no tool use stop the loop with a warning; the goal stays set and evaluation resumes after your next prompt.
- Errors you must fix clear the goal (warning starts `Goal cleared after an unrecoverable error`): auth failure (when Claude Code manages credentials), exhausted credit balance, context overflow auto-compact could not clear, model unavailable. Rate limits and overloads leave it active.
- Background work defers evaluation: a running subagent or background shell skips that turn's check. After 30 min of waiting a check-in is due (then 1h, then every 2h; `CLAUDE_CODE_GOAL_CHECKIN_MINUTES` scales it, `0` disables); interactive sessions self-start at most three idle check-ins per goal between your prompts, headless sessions only deliver check-ins at turn ends.
- `/goal clear` (aliases stop, off, reset, none, cancel). `/clear` also removes it.
- Headless: `claude -p "/goal <condition>"` runs to completion; add `--output-format stream-json --verbose` or nothing prints until the end.
- Resume: an active goal is restored on `--continue`, `--resume <id|name>`, and the picker (2.1.239+); turn count, timer, and token baseline reset. Achieved or cleared goals do not restore.
- Requires the workspace trust dialog; dead if `disableAllHooks` or `allowManagedHooksOnly` (the command says why).
- vs auto mode: "Auto mode removes per-tool prompts; /goal removes per-turn prompts." Complementary; use both for unattended runs.
- Evaluator cost: negligible.

## The 4-element gate

A condition ships ONLY when all four are present:

1. **Measurable end state**: test result, build exit code, file count, empty queue.
2. **Stated check**: the exact command whose output proves it (`npm test` exits 0, `git status` is clean).
3. **Constraints**: what must NOT change on the way (no other test file modified, no hardcoding).
4. **Stop bound**: "or stop after N turns" (or a time clause). Claude reports progress against it each turn.

GATE: any element missing, do not emit the /goal. Fix it first.

BAN (unverifiable adjectives): "clean", "production-ready", "improved", "better", "polished", "robust", "high quality" as end states. Falsifiable test: can a Haiku evaluator verify the claim from command output printed in the transcript? No: reword into a check that prints evidence, or cut it.

Negative example (published burn): `/goal a world where 'substrate, not model' is the obvious right axis` looped indefinitely; one user reported $200 / 14h on vague goals (findskill.ai, 2026-05).

## Evaluator blindness (the load-bearing insight)

The evaluator judges only what Claude surfaced in the conversation. Consequence: the condition must FORCE evidence into the transcript. Write "run X and show the output" into the condition. If proof lives in unlogged state (a file the agent never prints, a browser it never screenshots), the goal never resolves, or worse, the evaluator hallucinates success.

Fable 5.1 twist: it writes FEWER progress notes between tool calls than Fable 5 (official), and Claude Code shows them as collapsed thinking. Only text and tool output in the transcript count for the evaluator, so the condition must demand the evidence be PRINTED in the reply, not just produced.

## Goal file pattern (long or evolving goals)

Conditions near the 4,000-char cap are unwieldy and frozen at `/goal` time. For multi-clause programs, put the clauses in a repo file and keep the `/goal` line short:

```
/goal every clause in <repo>/GOAL.md is satisfied; at every checkpoint print the
FULL current content of <repo>/GOAL.md followed by per-clause evidence (command
output, not claims); never edit <repo>/GOAL.md yourself and prove it by printing
`git log --oneline -- <repo>/GOAL.md`; or stop after N turns
```

Why it works despite evaluator blindness: the condition FORCES the agent to print the file every checkpoint, so the evaluator sees the current clauses in the transcript. Bonus: re-printing each checkpoint survives compaction better than a one-shot long condition.

Rules:
- The file is USER-owned. User edits it mid-run to update the goal (no `/goal clear` needed; next checkpoint prints the new version). The agent treats it read-only; the never-edit clause + git evidence guard against self-weakening.
- The 4-element gate applies INSIDE the file: every clause = measurable end state + check command + constraints. Same adjective BAN.
- The stop bound stays in the `/goal` LINE, never only in the file.
- Each clause must still force evidence into the transcript ("print X").
- Delegation-backed programs: the `/goal` line begins `invoke /fable-max delegate and run per <orientation doc>`, and the file carries a delegation clause (named delegation map, orchestrator verifies every delegated result itself via git diff + tests, checkpoints print which executor did what). The condition is the only thing that survives compaction and fresh sessions; if the delegate invocation lives only in skill context or a doc, resumed sessions silently stop delegating.

## Goodhart warning

The agent optimizes exactly what the condition measures, nothing else. Field case (Jason Croucher, medium.com, 2026-05-18): space-shooter game passed every check, "a provably correct, useless result", bare unplayable canvas, because visual quality was unmeasured. Fix: "write the condition as what you want, not only how you will check it", then add a checkable proxy for the qualitative want (headless playtest prints `COMPLETABLE` per level, screenshots taken and reviewed against the brief).

5.1-specific Goodhart shapes seen in the first 48h: "useful initiative" vs scope creep (7 unrequested SEO articles on a SaaS build, Income Stream Surfers 2026-09-01; unrequested background agents on a design task, Rogoff 2026-09-01), and a design task where the model chose a cheaper "chibi" low-poly style and admitted it under questioning (The Neuron live, 2026-09-02). Put the permitted initiative AND the fidelity requirement in the condition.

## Template gallery (real, published)

Entries are as published. Several fail the 4-element gate (no check command or no stop bound); run every one through the gate before use, do not copy raw.

Tests + lint (official docs; stop bound added by us):
```
/goal all tests in test/auth pass and the lint step is clean, or stop after 15 turns
```

Build + test with constraints (XDA, 2026-06-17):
```
/goal running javac Zoo.java ZooTest.java && java ZooTest exits 0,
without modifying ZooTest.java and without hardcoding, or stop after 10 turns
```

Docs sync (official; FAILS the gate as published: no check command, no stop bound. Gated version below):
```
/goal CHANGELOG.md has an entry for every PR merged this week; prove it by
listing merged PRs via `gh pr list --state merged` and grepping CHANGELOG.md
for each; or stop after 10 turns
```

Self-verifying build (Marvijo, 2026-09-01, Fable 5.1 high, 48 min, 195k tokens; the Playwright clause is what made it self-heal five real bugs):
```
/goal a playable browser game exists in this directory; Playwright and Chromium
are preinstalled, use them to play-test with screenshots and iterate until every
scenario in test/playtest.js passes; print the final test output; or stop after
30 turns
```

Game dev anti-Goodhart pattern (Croucher):
```
/goal build exits 0; a deterministic headless playtest prints COMPLETABLE
for every level; stated invariants hold; determinism verified across two runs
```

## Fable 5.1 + /goal combo settings

Official pairing (model-config): "Describe the outcome, not the steps: hand it the result you want and let it plan the path. To keep it working until that outcome holds, set a goal."

Emit alongside every forged goal:
- `/model fable` (only if the task passes the routing test in prompting.md; Fable 5.1 is 2x Opus 5 price and burns subscription limits ~2x faster per the model picker itself)
- `/effort high` (5.1 default in Claude Code). `xhigh` only after a `high` attempt failed for depth; never `max` under a goal (1.7x output tokens per task, and one measured 64k-thinking exhaustion with zero output).
- Auto mode ON for unattended runs (goal starts turns, auto approves tools within them).
- Condition includes a verification step whose output Claude PRINTS (evaluator blindness).
- Three budgets, stated in the condition: turns or wall-clock, tokens (check `/cost`), and max concurrent subagents. Field reports (2026-09-02): a lead that keeps spawning subagents, rereads the same code for two hours, or edits a file a reviewer subagent is still inspecting. The stop bound is the only brake the evaluator enforces.
- Do NOT add "do not ask clarifying questions": Claude Code 2.1.258 already ships the autonomy block for Fable 5.1, and stacking it suppresses the questions you want on genuine ambiguity. Add the confirmations you DO want instead.

## Overnight / unattended runs

- Context overflow kills runs, not time (Khmelinskaya, 2026-05): redirect bulky tool output to files. Fable 5.1 note: with cache reads at a quarter of the price, compacting EARLY is no longer the cost-optimal move (official prompting guide); let it run longer before `/compact`, but a context overflow that auto-compact cannot clear now CLEARS the goal, so keep an eye on `/context`.
- Compaction dilutes instructions: critical constraints belong IN the goal condition (re-sent to the evaluator every turn) or the goal file (re-printed every checkpoint), not only CLAUDE.md.
- Checkpoint to a STATUS.md so a fresh session can pick up cold; commit at milestones.
- Subscription runs: the 5-hour window is the binding constraint, not the model. Day-one reports (2026-09-01/02) range from a Max 5x window gone in 12-45 minutes on parallel `max`/xhigh builds with subagents, to 5-6 hours of site builds consuming 45% of the weekly Fable cap. Anthropic staff: cache reads count at a reduced rate toward subscription usage and overall Max usage "should be ~same as Fable 5". Max plans cap Fable at 50% of the weekly limit; Pro runs Fable on usage credits only. For a true overnight run use an API key or enable usage credits, and set the turn cap accordingly.
- Phase-split multi-hour work into 30-60 min fresh `claude -p` sessions with `--max-budget-usd`, chained by STATUS.md; the condition survives `--resume` anyway.
- Watch the first hour before walking away.
- Sentinel for anything unattended: a separate cheap watchdog (cron / `/loop`, haiku/sonnet) reads STATUS.md + `git log` every 15-30 min and checks progress against expected milestones; two checks with no new artifact → alert or restart. It verifies artifacts, not the run's own claims. (Details: delegation.md → Sentinel.) The built-in goal check-ins (30m/1h/2h) only fire while BACKGROUND work is pending; they are not a progress sentinel.
- Log the served model: a cyber flag silently moves the session to Opus 4.8, a bio flag to Opus 5, and it STAYS there until you pick Fable again (model-config). `switchModelsOnFlag: false` makes it ask instead (headless sessions then end the turn with a refusal). CLAUDE.md, skills, and git history with security wording can trigger it on the FIRST request; test with `claude --safe-mode`.
- Always a turn cap. Always.

## Failure gallery

- Vague or philosophical goal: token loop, no flip point ("code a bit cleaned up" has no yes/no).
- Multi-want mush: "Complete all backlog tasks + 90% coverage + clean code" ran a full day and worked once (findskill), but "clean code" resolves on evaluator vibes. Split into checkable parts.
- Wrong model under the goal: Haiku spent 25 min / 46K tokens looping to a result Opus 4.8 hit in ~2 min (XDA). Model choice dominates goal wording.
- Proof outside transcript: condition requires evidence the agent never prints, goal never resolves.
- Subagent storm (5.1, 2026-09-02): lead keeps spawning subagents against a fuzzy target; 5-hour window gone, no artifact. Cap subagents in the condition.
- Silent fallback (Fable line): the run "finishes" on Opus 4.8 after a security-flavored step; the evaluator does not know. Print the model in checkpoints (`/model` shows it) or read `message.model` in the session jsonl.
