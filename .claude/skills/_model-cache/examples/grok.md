# Grok / xAI - prompt examples (grok-4.5 via OpenRouter)

Researched 2026-07-09 (launch +1 day). Ids/pricing/region chain → `../openrouter.md`. `[off]`=official docs.x.ai, `[com]`=community-verified, `[?]`=unverified. Per-effort quality/latency curves unmeasured by anyone yet.

---

## Route to / away (what it is actually FOR)

**TO it:** agentic tool loops (AA #1 of 28 - its real edge, not raw IQ), multi-file codebase repair/refactor and terminal tasks (Cursor co-trained, RL on "investigate, use tools, recover from mistakes, verify"), legal+finance knowledge work (#1 Harvey Legal), cheap-and-fast Opus-class second opinion, long executors where token efficiency compounds (~4.2x fewer output tokens than Opus on SWE-Bench Pro) [off+com].
**AWAY:** frontend/design taste (Fable/Opus clearly better [com]), hard novel math/physics ("struggles spectacularly" on rigid-body dynamics [com]), news/politics/customer-facing prose (documented system-prompt steering in the consumer product; API coding traffic is where the concern is weakest [com]), >200k input (price reportedly doubles [?] - verify before big-context runs).

## Effort dial (only real knob besides caching)

`reasoning: {"effort": "low"|"medium"|"high"}` through OpenRouter; **default is HIGH** with ~15s time-to-first-token - set it explicitly or easy calls pay hard-call latency. Official intent [off]: low = latency-sensitive agentic use + simple tool calling; medium = complex data analysis + long-context; high = competition-grade reasoning only. Reasoning can't be disabled.
**Param trap:** do NOT send `stop` / `frequency_penalty` / `presence_penalty` - OpenRouter lists them as supported but xAI reasoning models error on them [off]. `tools`/`tool_choice`/`structured_outputs`/`response_format`/`seed` pass through fine. `:exacto` routing variant = highest tool-call accuracy; `:nitro` = speed.

## Caching (xAI's own top lever)

Front-load static content (system prompt, few-shot, reference docs), append-only messages - "any edit, removal, or reorder breaks the cache" [off]. Via OpenRouter caching is automatic (read $0.50/1M = 0.25x, write free) but sticky-routing dependent; watch `cached_tokens` > 0. xAI-direct adds `prompt_cache_key` for reliable hits. Server-side agent tools (web/X search, Python sandbox) are **xAI-direct only, not on OpenRouter** - for realtime-X knowledge go direct or use OR's web plugin.

## Patterns

**Agentic executor** - lever: its RL training (recover + verify) [off+com]:
```
GOAL: <one measurable end state>.
TOOLS: <list + when each is allowed + what results mean>.
VERIFY: run <check command> before declaring done.
Recover from tool errors yourself; do not ask. Stop when VERIFY passes.
```
+ `effort=low` for the loop; the API model is raw - it expects YOU to define tool policy [off].

**Spec task** - lever: Grok family prefers "controlled operating instructions" over conversational [com]:
```
<goal>...</goal>
<context>surgical: only the relevant files, never repo dumps</context>
<output_format>...</output_format>
<quality_bar>... plus explicit must-NOT list</quality_bar>
```
XML/markdown-labeled sections stop it treating random paragraphs as requirements [off-prior].

**Board seat** - lever: cross-family disagreement is the product:
```
Argue the strongest case AGAINST the consensus below. Cite concrete failure modes.
```
+ `effort=high`. Mine its tool-use/pragmatics takes; ignore its style opinions; discount politics-adjacent claims.
