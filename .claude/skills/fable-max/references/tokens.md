# Token Economy: spend less, get more (Fable 5.1)

Official facts from platform.claude.com (effort, pricing, fable-5-1/whats-new) and code.claude.com (prompt-caching, model-config, costs, sub-agents), accessed 2026-09-02. Measured numbers flagged with source + date; all are Fable 5.1 unless stated.

## Contents
- Effort: the biggest single lever
- Per-role effort defaults
- Prompt caching: reads are cheap, writes are the bill
- Subscription limits (the binding constraint in Claude Code)
- Model routing: the biggest structural saver
- Context hygiene: lean context = better output
- Do-not list

## Effort: the biggest single lever

Level names are recalibrated per model (official): re-sweep on 5.1 even if you swept Fable 5. Official anchors: 5.1 `medium` ≈ Fable 5 at lower cost; 5.1 `low` "often competitive with Opus and Sonnet on cost per task while scoring higher"; gains over Fable 5 are largest at the higher settings; Fable 5 saturated at xhigh/max, 5.1 keeps climbing.

Same prompt, one SVG task (Simon Willison, 2026-09-01):

| Effort | Output tokens | Time | Cost |
|---|---|---|---|
| low | 1,998 | 24 s | $0.10 |
| medium | 1,977 | 23 s | $0.10 |
| high | 2,612 | 30 s | $0.13 |
| xhigh | 36,767 | 7:51 | $1.83 |
| max | 65,927 | 13:54 | $3.30 |

Artificial Analysis composite, cost per index task (2026-09-01/02): low 58 at $0.77, medium 60 at $1.00, high 62 at $1.43, xhigh 65 at $2.65-2.72, max 66 at $3.69-3.76. Fable 5 max was 62 at $3.14: 5.1 `high` buys Fable 5 max's score at under half the cost; 5.1 `max` costs 20% MORE per task than Fable 5 max because it emits ~1.7x the output tokens. Time to first token: 6 s low, 39 s high, 130 s xhigh, 297 s max.

Agentic coding, CursorBench 3.2.0 (Anthropic chart as read by several testers, 2026-09-01): 5.1 low 66.2% at $2.90, medium 68.0% at $3.53, high 69.4% at $4.80, xhigh 72.8% at $6.96, max 73.4% at $9.64; Fable 5 max 70.5% at $17.32; GPT-5.6 Sol max 67.2% at $5.69; Grok 4.6 xhigh 70.8% at $2.81.

Where more effort HURT: code review recall fell from 61.0% at low to 57.1% at high and took 3 min longer per task (CodeRabbit, 45 tasks, 2026-09-01); FrontierCode score peaked at medium because higher effort touched unrequested files (Cognition, 2026-08-31); ARC-AGI-2 identical at xhigh and max (ARC Prize, 2026-09-01). A single 1-hour web build at max spent ~30 min thinking before the first line of code (CodeFactory, 2026-09-02).

Mechanics: `/effort <level>` (saved per model since 2.1.251; `s` inside the picker = this session only, 2.1.257), `--effort`, `CLAUDE_CODE_EFFORT_LEVEL`, `effortLevel` in settings. `max` is session-only unless set via the env var. `ultracode` = xhigh + Claude Code's dynamic workflows (18-agent spec phase, 2 hours and $156 before the first line of code on one build, Bowen 2026-09-01; 344 tool calls and $9.13 vs $2.31 at high on another, Dash 2026-09-02): a planning mode, not a smarter model. `ultrathink` in the prompt changes nothing on 5.1. Thinking cannot be disabled (`alwaysThinkingEnabled`, `MAX_THINKING_TOKENS=0` are ignored).

**Changing `/effort` mid-session still restarts the Claude Code cache** (cache key = model + effort; official prompt-caching doc). The API's per-message effort (beta) keeps the cache; Claude Code does not use it yet. Pick effort at session start; for one cheap question mid-session, spawn a subagent.

## Per-role effort defaults

| Role | Effort | Why |
|---|---|---|
| Orchestrator, planning, decomposition | `high` (Claude Code default); `medium` for ordinary planning turns once your evals confirm | Medium ≈ Fable 5 high; high is where 5.1's long-horizon gains live |
| Long unattended run under /goal | `high`; `xhigh` only after a `high` attempt failed for depth | xhigh triples cost per task; max adds 1.7x output tokens and 5-minute silences |
| Code review / issue discovery (Fable seat) | `low` | CodeRabbit: low beat high on recall and precision |
| Fable as implementation escalation (Sol failed twice) | `medium` | FrontierCode peak; less scope creep than high |
| Subagents on Fable | `low`, and only when the task needs Fable at all | Same weekly Fable cap as the main session |
| Long single-shot deliverable (document, big file) | `high`, never xhigh/max | drafts the deliverable twice at xhigh/max (official) |
| Anything routine | Opus 5 or Sonnet 5, not Fable at low | Fable low still costs 2x Opus per token and burns the Fable cap |

Never `max` as a standing default. Use it for a named frontier problem with a stop bound.

## Prompt caching: reads are cheap, writes are the bill

Prices: cache read $0.25/MTok (0.025x input; Opus 5 is $0.50, Sonnet 5 $0.20), 5m write $12.50, 1h write $20. Min cacheable prefix 512 tokens. Cached reads do not count toward input-tokens-per-minute rate limits.

TTL defaults in Claude Code (official prompt-caching doc): 1 hour for the main conversation on a subscription in plan; 5 minutes for API key, usage credits, Bedrock/Vertex/Foundry, subagents, workflows, forks, compaction. `promptCacheTtl` / `subagentPromptCacheTtl` settings, `experimental.cacheTtl` per agent (2.1.248). `/cost` shows the per-session cache line (hit ratio, misses, warm/cold) since 2.1.251; `/claude-api cost-optimize` walks the levers.

Anthropic's "25% typical, up to 45% agentic" saving is the cache-READ cut on a Fable-5 workload mix (August 2026, four weeks, default effort). Arithmetic: it needs reads to have been a third (25%) or 60% (45%) of the old DOLLAR bill. Where it does not apply: uncached or first-turn requests, prefix-rewriting harnesses, output-heavy turns, `max` effort, and every subscription.

Measured bills (2026-09-01/02): a $3.60 session was 58% cache writes and 8% cache reads (AICodeKing); a 573M-token enterprise run at $1,024 was 89.8% read tokens but 12.6% of cost, and 9.4% write tokens but 65.8% of cost; a single `claude -p` one-liner cost $0.62, of which $0.616 was the 30.8K-token cache WRITE of Claude Code's own tools (DeepOnAI). Nate Herk's four identical site builds: 5.1 1-41% cheaper than Fable 5 at 97% cache hit. Atomic Agent's three prompts: 7.5% cheaper. Cognition's FrontierCode: $2.68 vs $5.84 (46%) at 95% cache reads.

Rules that follow:
- Stability of the prefix is the lever, not the read price: pick model, effort, tools, MCP servers, output style BEFORE loading repo context. Each of those restarts the cache (model switch, effort change, MCP connect/disconnect, plugin toggle, denying a whole tool, upgrading Claude Code, `/compact`). Editing repo files, CLAUDE.md, permission mode, skills, `/recap`, `/rewind`, spawning subagents keep it.
- Keep the session alive: a 5-minute TTL that lapses re-writes the whole prefix at $12.50-20/M (a 500K prefix = $6-10). On subscriptions the main conversation gets 1h.
- Compact LATER than you did on Fable 5 (official: early compaction "may no longer be the right cost-intelligence tradeoff"), but a context overflow that auto-compact cannot clear now clears an active /goal, so watch `/context`.
- Bulk work goes to Batch (50% off) or a cheaper model; Fable Batch is $5/$25.

## Subscription limits (the binding constraint in Claude Code)

- Max plans: Fable capped at 50% of the weekly limit, 5-hour rolling windows; the picker says "~2x faster than Opus". Pro: usage credits only. `Continue at usage limit` in `/config` resumes a paused session when the window resets (reported working, ByteForward 2026-08-29; one X report says continuation is bugged, unverified).
- Anthropic (CJ Avilla, X 2026-09-01): cache reads already count at a reduced rate toward subscription usage; overall Max usage "should be ~same as Fable 5". Boris Cherny: up to 38% lower cost for a typical Claude Code session (API-metered).
- Day-one field range (2026-09-01/02): Max 5x window gone in 12 min (two parallel `max` audits), 20 min (12 subagents in a gauntlet loop, plus $305 of usage credits in 30 min), 35-45 min (single heavy builds at high/xhigh), 2h 20m (one agent, 14 min = 10%); versus 5-6 hours of site builds using 45% of the weekly Fable cap, and a 2-hour 5.1 build using 52% of a window, 30% of weekly Fable, 16% of weekly all-models (van Zyl). Variance drivers: initial uncached context, effort, subagent count, parallel sessions, `max`.
- 2026-09-14: the temporary +50% weekly boost ends, a permanent +25% replaces it (net 17% less than late August).
- Unattended overnight on a subscription is a gamble; API key or usage credits with a hard monthly cap is the reliable path. Watch `/cost` and `/usage`.

## Model routing: the biggest structural saver

Subagent frontmatter `model:` pins that agent's billing. `CLAUDE_CODE_SUBAGENT_MODEL` sets the default (per-agent `model:` wins); `CLAUDE_CODE_SUBAGENT_MODEL_FORCE=1` overrides everything (2.1.257). `/tasks` shows each subagent's model and effort. Forks (`subagent_type: "fork"`) inherit the cache.

```yaml
---
name: deep-reasoner
description: High-reasoning phases: architecture, complex debugging,
  algorithm design. Think hard, return a concise conclusion
  the orchestrator can act on.
model: opus
---
```
```yaml
---
name: fast-worker
description: Mechanical tasks: boilerplate, tests, formatting,
  simple edits. Execute efficiently.
model: sonnet
---
```

- Fable orchestrates, Sol (codex) or Sonnet generates the volume; Every measured 5.1 at under half the tokens and 60% of the time of Opus 5 per agent step, and 1.8 billion tokens in one day when xhigh kept spawning subagents. Per-step efficiency and total-session burn are different numbers: cap subagents.
- Keep fan-out ONE level: nesting re-carries context per level (~7x).
- The lead may keep working while subagents run (official: lower time to completion, same cost) but must not edit a file a reviewer subagent is inspecting (loop reports, 2026-09-02).
- Executor picks and bridges: `_model-cache/index.md` roles table; logic in delegation.md.

## Context hygiene: lean context = better output

- `/context` first: Claude Code 2.1.258 spends ~37K tokens (system prompt 6K, tools 22K, skills 9K) before your first message (van Zyl, 2026-09-02). Prune skills and MCP servers you do not use this session.
- `/clear` on every topic switch. One topic per session: a 72-message session that kept growing cost one tester 253M tokens, 63% of a weekly limit (Rachel noCode, 2026-09-02).
- `/compact` deliberately (later than on Fable 5), never let auto-compact fire mid-task; critical constraints live in the /goal condition or the task prompt, not only CLAUDE.md.
- CLAUDE.md under ~200 lines: it loads every turn. Rules max ~3, file pointers over pasted content.
- MCP pruning: 10+ servers can preload ~82K tokens; deferred tool search took one setup from 51K to 8.5K. Prefer CLI tools over MCP equivalents.
- `.claudeignore`: node_modules, dist, build, coverage, lockfiles, logs.
- Effort amplifies good context; it does not compensate for bad. Lean context + high beats bloated context + max.

## Do-not list

1. Do not run Fable 5.1 at `max` "to be safe": ~7x low's cost per task, 5-minute first-token waits, 1.7x Fable 5's output, and no ARC-AGI-2 gain over xhigh.
2. Do not switch models or effort mid-session for one cheap question: the cache rebuild can cost more than the question; subagent it.
3. Do not put Fable on every subagent: 2x Opus per token AND the same 50% weekly Fable cap.
4. Do not carry 10 MCP servers you use twice a month.
5. Do not show the model token countdowns (it now has the anti-anxiety line; do not fight it) and do not let auto-compact decide when your instructions get summarized away.
6. Do not let a 5-minute cache TTL lapse between turns on API billing: the prefix re-write is the single largest line on most Fable invoices.
7. Do not read "cost per model step" as "cost per completed task"; measure the task.
