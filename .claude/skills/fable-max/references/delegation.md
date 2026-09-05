# Delegation: the orchestrator plans, other models execute

The top model plans the graph, writes the specs, judges, and reviews; everything token-hungry or mechanical runs on someone else's meter, behind a runner agent that keeps the flood out of the orchestrator's context. Two wins at once: subscription/price arbitrage AND a clean brain (one report per node comes back, raw logs stay on disk for any model to read). Community-measured savings 46-74%; on long autonomous runs 10x+. Fable 5.1 (2026-09-01) does not change the shape: it is 2x Opus 5 per token, capped at 50% of a Max plan's weekly limit, and Anthropic itself says to start on Opus 5.

**Who is currently best at what lives in `~/.claude/skills/_model-cache/index.md` → "Delegation roles" table** (refreshed with every model update). This file carries only the logic that does not drift. The bridges own the call shapes:
- **codex-bridge** `implement` / `review` / `computer-use` / `steer`: OpenAI-executor shell-outs, driven by the `codex-runner` agent
- **gemini-bridge**: video, multimodal, long-context dumps, non-English, driven by the `model-runner` agent
- **openrouter-bridge / board**: cross-family opinions, cheap open-family text; `model-runner` again
- Routes are fixed by the subscriptions: Anthropic models = Claude subagents, OpenAI models = codex CLI. OpenRouter for those two families only with explicit user approval in the session (ask first). It is not a fallback an agent picks to save effort.

## Routing logic (timeless; names come from the cache table)

Planning quality is the top model's moat; execution is near-parity across frontier coders. Pay top-model rates only where errors compound: decomposition, architecture, non-obvious debugging, conflict arbitration, plan + final review, /goal ownership, authoring delegated prompts.

- Effort per role on Fable 5.1 (numbers in tokens.md): orchestrate at `high` (medium for routine planning turns), review at `low`, escalation-implement at `medium`, never `max` as a default. Sol executes at high, xhigh for hard repo work.
- Fable 5.1 as an executor: only as the ESCALATION path (Sol failed twice, or the task is integration-heavy and under-specified). Senior SWE-Bench (2026-09-02): tasteful pass tied at 34.7% between Fable 5.1 medium and Sol xhigh, Sol at about half the output dollars; Cognition's hybrid harness nearly matched pure Fable at $1.43 vs $2.68 per task. Fable wins agentic hunts and research depth, Sol wins mechanics and speed on visual builds.
- Tie-break for anything that ships: **intelligence > taste > cost**. Cost is a tie-breaker only. The value-tier executor is for rote AND low-stakes work; implementation that ships defaults to the top executor tier. When in doubt, the better model.
- Cheaper output below the bar → redo with a smarter model without asking; escalating costs less than shipping mediocre work.
- **Mission-critical review gates get the best available models, plural** (independent seats, cross-family). A defect that slips a gate stalls everything downstream; gate cost is trivial vs stall cost and usually pays back in shipping speed.
- User-facing work (UI, copy, API design): the executor drafts, but the taste JUDGING is the orchestrator's own job, the top model has the best taste; delegate the drafting, never the verdict.
- Security-flavored review never returns through Fable (refusal-downgrade risk, see prompting.md); route it to the cache table's review seat.
- Computer use: delegating it is a COST move (screenshot loops are token furnaces), not a quality move; quality-critical GUI verification stays on the best GUI driver (check the cache).

## Gates (all three, before any delegation)

1. **Size gate:** under ~15 min of work, do it in-session. Delegation overhead (briefing + verification + handoff risk) eats the savings on small jobs.
2. **Spec gate:** if the orchestrator cannot write the task self-contained (goal, acceptance criteria, must-not-touch, verify commands), the task still needs thinking, not typing. Keep it.
3. **Taste gate:** user-facing output → high-taste model or executor draft + taste review.

## Graph, not queue

Plan the work as nodes with dependencies and allowed paths, print it, then run every independent node in parallel: about three codex executors by default (the user's setting, not a measured optimum: scale back when the allowance or rate limits bite, scale up when they do not). Coupled files get one owner and run sequentially (parallel owners on coupled systems: +0.46 with defects rising vs +1.00 sequential, Shumer's data). The graph is a draft: a runner report, a failed check, or a reality touch re-plans it. Waiting on one executor while the others idle is the failure this section exists to end.

## Runner layer (every non-Claude executor, even a single task)

Agent/Workflow `model:` only accepts Claude models, and raw executor output must never land in the orchestrator's context. So every codex, Gemini, or OpenRouter run goes through a runner agent: `codex-runner` for OpenAI executors, `model-runner` for the rest (definitions in `~/.claude/agents/`, copies in `fable-max/agents/`).

- Prompt authorship (tested 2026-09-05, 12/12 blind for Sol over Fable-authored prompts, both judges, both orders; `_model-cache/research/2026-09-05/prompt-author-test.md`): Fable writes the SPEC, the runner has Sol compile it into the executor prompt and verifies no constraint was dropped. Sol drops rationale prose, so a WHY the executor needs goes into the spec explicitly.
- The runner is a babysitter with bounded judgment, not a dumb proxy: it compiles the spec into the executor prompt, launches via steer, loops the sentinel, retries or nudges once, answers the executor's trivial questions from the spec, verifies the diff against the spec's check, stops the daemon, and returns ONE report with the log path. It escalates only spec ambiguity, scope growth, user-interactive dependencies, two failed attempts, or a sentinel that tripped twice.
- Logs are the truth. Every run leaves `~/.codex-steer/<node>/{out.md,events.jsonl,state.json}` (or a conv dir for REST routes). The runner's report is a pointer plus a verdict; Fable, Opus, or the user can open the raw log any time. Sonnet never becomes the chokepoint of what happened.
- A newly added agent file becomes a `subagent_type` only in the NEXT Claude Code session. Until then: `Agent(subagent_type: "general-purpose", model: "sonnet")` with "read ~/.claude/agents/codex-runner.md and act as that agent" as the first line of the brief (forward-tested 2026-09-05).
- Label runners with the real worker (`description: "sol: auth-node"`): the UI shows the runner's Claude model; the label is the only trace.
- Parallel runners on one repo need `isolation: "worktree"` or executor edits collide.
- One level deep: runners cannot spawn agents. Fan-out inside a runner is shell parallelism (`&`, `claude -p`, `codex exec`), never the Agent tool.
- Workflow `budget.spent()` counts only Claude tokens; executor work is invisible there. Track the executor's own allowance separately.

## Verification sandwich (the shared term)

Before the change: see it broken (runner pins `git status --short`, captures the failing check or a screenshot). After: see it fixed (runner runs the spec's check; Fable reads `git diff` itself; the report is a claim). Then forward test on a fresh case, and iterate, since it is rarely right the first time. Cheap seats first (the runner, a Sonnet or Opus fresh reviewer); climb to a Fable subagent, Astra via a runner, or `/board` only when the cheap seat cannot settle it or the stakes are mission-critical. No mandatory fresh Fable per slice.

## Hard stuff goes up, not out

Examples of what earns a Fable subagent or Astra (the user's taste, not an exhaustive list): planning the graph, a second check on something important, brainstorming a way out, being stuck, confirming or refuting a diagnosis, a fresh-eyes plan check (fresh context matters as much as model strength), a taste verdict, experiment or eval design, a bias-free cross-family second eye. Astra still runs through `codex-runner`; a Fable subagent is a Claude agent and returns one report on its own. Both are metered (Fable cap, Pro allowance); use them when slowing down is faster.

## CLAUDE.md rubric block (template; fill the table FROM the cache roles table at paste time)

```markdown
## Picking the right models for workflows and subagents
Rankings, higher = better. Cost reflects what I actually pay. Intelligence =
how hard a problem the model takes unsupervised. Taste = UI/UX, code quality,
API design, copy.
| model | cost | intelligence | taste |
|---|---|---|---|
| <bulk executor> | 9 | 8 | 5 |
| <wrapper/mid> | 5 | 5 | 7 |
| <taste/review> | 4 | 7 | 9 |
| <orchestrator> | 2 | 9 | 9 |
- Defaults, not limits: standing permission to redo below-bar output with a
  smarter model without asking. Judge the output, not the price tag.
- Cost is a tie-breaker only; for anything that ships, intelligence > taste > cost.
- Bulk/mechanical work goes to the bulk executor via its CLI bridge, never MCP.
- User-facing (UI, copy, API design) needs taste >= 7.
- Reviews: orchestrator or taste/review model, optionally the bulk executor
  as an extra independent seat.
```

## Steering delegated runs (never fire-and-forget the steerable cases)

The runner owns steering; the orchestrator sends a nudge through the runner, never to the executor directly. `codex exec` has no mid-run channel (stdin consumed once). When mid-run coordination is plausible - run projected >5 min, user-interactive dependency (CAPTCHA, OAuth click, 2FA), scope likely to grow (hunts, scrapes, "find X"), or the user actively watching - launch the executor via **codex-bridge `steer` mode** (`steer/steer.sh`, wraps `codex app-server`): `msg` injects into the RUNNING turn, `img` injects a screenshot mid-turn, `interrupt` aborts without losing the thread, follow-up turns keep full context. Verified live 2026-08-13. Always pair `start` with `stop` (long-lived process; `steer.sh ls` audits orphans). NO polling instruction goes into the executor prompt - steering is push-based, costs zero executor tokens until used (mailbox-file polling was tried and rejected: constant re-reads burn tokens every checkpoint).
- Plain `codex exec` stays right for one-shot bounded tasks; if a follow-up NEED emerges after it finishes, `codex exec resume <thread_id> -` keeps context (capture thread_id from `--json` at launch - free insurance).
- OpenRouter/REST executors: no mid-flight channel exists, period. Chunk the work into turns with openrouter-bridge `conv.sh` (persisted history) so every chunk boundary is a steering point.

## Sentinel (inside the runner, no model in the loop)

Executors stall silently: a run dies mid-diff, a turn ends without the next starting, an allowance runs out. The watchdog is a script the runner blocks on, not an agent and not a timer in the orchestrator: `codex-bridge/steer/sentinel.sh <node> [--stall SECS] [--max SECS]` polls `state.json` and log growth and exits 0 on done, 2 on stall, 3 on a dead driver, 4 on max wall time, 5 on a limit/auth signature. The runner reacts (one nudge or restart, then escalate). Nothing reaches the orchestrator until a node is done or blocked; nobody polls by hand. The sentinel verifies artifacts (log growth, state, commits), never the executor's own status claims.

For a single long-running process (training, big build), use the in-session variant: Monitor tailing its log with a filter that fires on EVERY failure signature (`nan|Traceback|Killed|OOM`), not just success markers, plus a log-growth stall alarm and a process-gone check that EXITS the sentinel. Ordering matters: process check before stall check, or the sentinel outlives the run and false-alarms on a legitimately quiet log. Full mechanics + the 5h-dead-run postmortem: autoresearch skill, failure-modes.md "Live-log sentinel".

## Failure rules (each one cost someone a session or real money)

1. Orchestrator effort caps at HIGH; xhigh/max degrades orchestration (overthinking, loops). On Fable 5.1 the failure looks like a subagent storm: xhigh kept spawning subagents through a 1.8-billion-token day (Every, 2026-09-01), a lead re-read the same code for two hours, another edited a file while its reviewer subagent was still reading it. Cap concurrent and cumulative subagents in the brief; the lead never touches a file assigned to a reviewer.
2. A subagent's security/vulnerability report returning to Fable can trigger the silent Opus downgrade (cyber → Opus 4.8, bio → Opus 5, and the session stays there). Scrub exploit language from returning reports; base64 blobs in tool output are an official false-positive trigger too.
3. A runner reporting success is not evidence: check `git status`/`git diff` yourself. Fable 5.1 included: Snorkel's transcript audit (2026-09-01) caught it claiming a re-verification it never ran.
4. Runners cannot spawn agents (one-level depth); recursive delegation designs silently never execute. Fan-out inside a runner = shell parallelism.
5. When planning is trivial (bulk fan-out of identical mechanical tasks), skip the orchestrator entirely - a mid-tier fleet beats top-model-plus-fleet there. The premium buys nothing without hard decisions.
6. Never read a delegated command's success off `cmd | tail -N` - the pipeline exit is tail's, so a hard failure prints as exit 0 (masked a dead 2h image build). `set -o pipefail`, or log to a file and echo `exit=$?` explicitly.
7. Executor-written research-critical code (losses, metrics, harnesses) gets a multi-model adversarial review BEFORE the first expensive run, not after. Evidence 2026-07-12: two different-architecture reviewers on one diff returned DISJOINT critical bugs (sol: unguarded GAN discriminator = permanent zombie run; grok: penalty at a granularity the head cannot act on). Either alone would have shipped the other's bug into a 5-hour run. Scope the executor tightly too: told "zero warnings", one executor ran cargo fmt over the whole workspace; another added a build-time file check at a stage where the files cannot exist yet. Verify the DIFF SCOPE, not just the diff.
