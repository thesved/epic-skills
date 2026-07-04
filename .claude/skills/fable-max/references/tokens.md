# Token Economy: spend less, get more

Official facts from code.claude.com (prompt-caching, model-config, subagents) and platform.claude.com/docs/en/build-with-claude/effort, accessed 2026-07-04. Community numbers flagged with source + confidence.

## Contents
- Effort: the biggest single lever
- Prompt caching: what breaks it, what doesn't
- Model routing: the biggest structural saver
- Context hygiene: lean context = better output
- Do-not list

## Effort: the biggest single lever

Measured, same prompt across tiers (Simon Willison, simonwillison.net, 2026-06-09):

| Effort | Output tokens | Cost |
|---|---|---|
| low | 1,929 | $0.097 |
| medium | 2,290 | $0.115 |
| high | 2,057 | $0.103 |
| xhigh | 5,992 | $0.300 |
| max | 14,430 | $0.722 |

xhigh is ~3x low, max ~7.5x. Independent timing tests (Pawel Huryn, n=50, X 2026-06): "Below max, completion time barely moves. Effort doesn't impact the capability much." Official: lower effort on Fable "still perform[s] well and often exceed[s] xhigh performance on prior models".

Routing by effort:
- `low`: subagents, mechanical tasks, latency-sensitive.
- `medium`: routine agentic work, cost-sensitive.
- `high`: Fable default, the sweet spot for most real work.
- `xhigh`: capability-critical only (hard reviews, gnarly plans).
- `max`: frontier problems only; session-scoped in Claude Code.

Mechanics: `/effort <level>`; effort shapes ALL output (text + tool calls + thinking), "a behavioral signal, not a strict token budget"; scale is calibrated per model (high on Fable != high on Opus). Changing effort mid-session invalidates the cache (Claude Code warns first).

Task budgets (`task-budgets` beta) are API-only: "not supported on Claude Code or Cowork surfaces."

## Prompt caching: what breaks it, what doesn't

Claude Code manages caching automatically. Cache reads cost ~10% of input price; official example: "a 170-turn Opus session can cost $21 instead of $168." Fable's minimum cacheable prefix is 512 tokens (lower than Opus 4.8's 1,024). Subscription sessions get 1h TTL; raw API key defaults to 5m (`ENABLE_PROMPT_CACHING_1H=1` opts in).

BREAKS cache (full re-read of everything after the change):
- Switching models mid-session (per-model caches)
- Changing effort level (confirmation dialog shown)
- Toggling fast mode
- Connecting/disconnecting an MCP server (unless tools are deferred)
- Enabling/disabling a plugin that ships MCP servers
- Denying an entire tool (Bash, WebFetch)
- Upgrading Claude Code
- `/compact` (intentional; rebuilds conversation layer, keeps system layer)

KEEPS cache:
- Editing repo files
- Editing CLAUDE.md mid-session (applies only after /clear or restart)
- Changing output style or permission mode
- Invoking skills/commands, `/recap`, `/rewind`
- Spawning subagents (parent prefix stays cached)

Rule that follows: pick model + effort at session start and hold them. For a one-off cheap question mid-session, spawn a subagent instead of switching models.

## Model routing: the biggest structural saver

Subagent frontmatter `model:` field pins that agent's billing to that model. Pattern (Pillitteri, pasqualepillitteri.it, 2026-07-02; single-source savings claim):

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

- Fable/Opus orchestrates, cheap models generate the volume: claimed 80-90% of tokens shift to sonnet/haiku, 5-10x cost cut (unbenchmarked, but the mechanism is official).
- Keep fan-out ONE level: nesting re-carries context per level, up to ~7x multiplication (community, Huryn).
- Quality bonus, not just cost: subagents keep search/log floods out of the main context; only summaries return. Lean main context = better main-model attention.
- HN pattern (matheusmoreira, 2026-07-01): "Fable to plan and review, Sonnet for the implementation."

## Context hygiene: lean context = better output

Token saving and quality improvement are the same move here. Official-adjacent: quality degrades from ~50% context fill. Community "context rot": past ~300-400K tokens "the context is not full, it is poisoned."

- `/clear` on every topic switch. One topic per session.
- `/compact` deliberately at 40-70% fill, never let auto-compact fire mid-task. Compaction also dilutes CLAUDE.md instructions over repeated rounds (overnight-run reports), so critical constraints belong in the /goal condition or the task prompt, not only CLAUDE.md.
- CLAUDE.md under ~500 words: it loads every turn. Rules max ~3, file pointers over pasted content.
- MCP pruning: 10+ connected servers can preload ~82K tokens; deferred tool search took one setup from 51K to 8.5K (Njenga/Spence, medium, 2026). Audit `~/.claude.json`, project-scope your servers, prefer CLI tools over MCP equivalents.
- `.claudeignore`: node_modules, dist, build, coverage, lockfiles, logs.
- Effort amplifies good context; it does not compensate for bad. Lean context + high beats bloated context + max.

## Do-not list

1. Do not run Fable at max effort "to be safe": ~7.5x cost for gains that only show on frontier problems.
2. Do not switch models mid-session for one cheap question: the cache rebuild can cost more than the question; subagent it.
3. Do not put Fable on every subagent: 2x Opus pricing on mechanical work, and Max-plan windows drain far faster than the official "~2x" (13-minute depletion reports, 2026-06).
4. Do not carry 10 MCP servers you use twice a month.
5. Do not show the model token countdowns (early stopping) and do not let auto-compact decide when to summarize your instructions away.
