# /goal Forging: bulletproof goal statements

All official facts from code.claude.com/docs/en/goal + docs/en/model-config (accessed 2026-07-04). Community facts flagged inline.

## Contents
- Mechanics (how /goal actually works)
- The 4-element gate
- Evaluator blindness (the load-bearing insight)
- Goodhart warning
- Template gallery (real, published)
- Fable + /goal combo settings
- Overnight / unattended runs
- Failure gallery

## Mechanics

- `/goal <condition>`: prose condition, max 4,000 chars. Needs Claude Code v2.1.139+.
- After EVERY turn, a separate evaluator model (your configured small fast model, default Haiku) receives the condition + the conversation so far and decides: met or keep going. Completion is judged by a fresh model, not the one doing the work.
- The evaluator reads the TRANSCRIPT ONLY. It runs no commands, reads no files. Official: "It doesn't run commands or read files independently."
- `/goal` (no args) = status: turn count, elapsed time, token spend. `/goal clear` (aliases: stop, off, reset, none, cancel) removes it.
- Auto-clears when met; achievement record goes in transcript.
- Headless: `claude -p "/goal <condition>"` runs to completion in one invocation.
- Resume: an active goal survives `--resume` / `--continue`; the condition carries over but turn count, timer, and token baseline reset. Achieved or cleared goals do not restore.
- Requires accepted workspace trust dialog. Dead if `disableAllHooks` or `allowManagedHooksOnly` is set.
- One goal per session.
- vs auto mode: "Auto mode removes per-tool prompts; /goal removes per-turn prompts." Complementary; use both for unattended runs.
- Evaluator cost: negligible (Haiku reads transcript once per turn).

## The 4-element gate

A condition ships ONLY when all four are present:

1. **Measurable end state**: test result, build exit code, file count, empty queue.
2. **Stated check**: the exact command whose output proves it (`npm test` exits 0, `git status` is clean).
3. **Constraints**: what must NOT change on the way (no other test file modified, no hardcoding).
4. **Stop bound**: "or stop after N turns" (or a time clause).

GATE: any element missing, do not emit the /goal. Fix it first.

BAN (unverifiable adjectives): "clean", "production-ready", "improved", "better", "polished", "robust", "high quality" as end states. Falsifiable test: can a Haiku evaluator verify the claim from command output printed in the transcript? No: reword into a check that prints evidence, or cut it.

Negative example (published burn): `/goal a world where 'substrate, not model' is the obvious right axis` looped indefinitely; one user reported $200 / 14h on vague goals (findskill.ai, 2026-05).

## Evaluator blindness (the load-bearing insight)

The evaluator judges only what Claude surfaced in the conversation. Consequence: the condition must FORCE evidence into the transcript. Write "run X and show the output" into the condition. If proof lives in unlogged state (a file the agent never prints, a browser it never screenshots), the goal never resolves, or worse, the evaluator hallucinates success.

## Goodhart warning

The agent optimizes exactly what the condition measures, nothing else. Field case (Jason Croucher, medium.com, 2026-05-18): space-shooter game passed every check, "a provably correct, useless result", bare unplayable canvas, because visual quality was unmeasured. Fix: "write the condition as what you want, not only how you will check it", then add a checkable proxy for the qualitative want (headless playtest prints `COMPLETABLE` per level, screenshots taken and reviewed against the brief).

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

UI from screenshot (findskill.ai, claimed 20 min):
```
/goal turn this screenshot into a working app. Goal is reached once you
tested every feature end to end in the browser
```

Fable-native audit (awesome-claude-fable-5):
```
/goal boot this project's real site, screenshot every page, run a
full-site UI/UX audit, and produce an actionable design report
```

Game dev anti-Goodhart pattern (Croucher):
```
/goal build exits 0; a deterministic headless playtest prints COMPLETABLE
for every level; stated invariants hold; determinism verified across two runs
```

## Fable + /goal combo settings

Official pairing (model-config doc): "Describe the outcome, not the steps: hand it the result you want and let it plan the path. To keep it working until that outcome holds, set a goal."

Emit alongside every forged goal:
- `/model fable` (only if the task passes the routing test in prompting.md; Fable is 2x Opus price)
- `/effort high` (Fable default; xhigh only for capability-critical, see tokens.md numbers)
- Auto mode ON for unattended runs (goal starts turns, auto approves tools within them)
- Condition includes a verification step whose output Claude prints (evaluator blindness)
- "Do not ask clarifying questions; use your best judgment" for overnight (community consensus)

## Overnight / unattended runs

Community-hardened (Eva Khmelinskaya, medium.com, 2026-05-18):
- Context overflow kills runs, not time: "It just ran out of memory, not time." Redirect bulky tool output to files, not the transcript.
- Compaction dilutes instructions: "even essential instructions from CLAUDE.md lose effectiveness after multiple compaction rounds." Put critical constraints IN the goal condition; the condition is re-sent to the evaluator every turn and survives compaction.
- Checkpoint to a STATUS.md so a fresh session can pick up cold.
- For multi-hour work, phase-split into 30-60 min fresh `claude -p` sessions with `--max-budget-usd`, chained by STATUS.md.
- Watch the first hour before walking away.
- Sentinel for anything unattended: a separate cheap watchdog (cron / `/loop`, haiku/sonnet) reads STATUS.md + `git log` every 15-30 min and checks progress against expected milestones; two checks with no new artifact → alert or restart. It verifies artifacts, not the run's own claims. (Details: delegation.md → Sentinel.)
- Always a turn cap. Always.

## Failure gallery

- Vague or philosophical goal: token loop, no flip point ("code a bit cleaned up" has no yes/no).
- Multi-want mush: "Complete all backlog tasks + 90% coverage + clean code" ran a full day and worked once (findskill), but "clean code" resolves on evaluator vibes. Split into checkable parts.
- Wrong model under the goal: Haiku spent 25 min / 46K tokens looping to a result Opus 4.8 hit in ~2 min (XDA). Model choice dominates goal wording.
- Proof outside transcript: condition requires evidence the agent never prints, goal never resolves.
