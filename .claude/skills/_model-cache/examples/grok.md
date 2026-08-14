# Grok / xAI, prompt examples (grok-4.6 via OpenRouter)

Researched 2026-07-09 (4.5 launch +1 day); 4.6 update 2026-08-14 (launch +2 days, evidence: `../research/2026-08-14/model-sweep.md`). Ids/pricing/region chain → `../openrouter.md`. `[off]`=official docs.x.ai, `[com]`=community-verified, `[?]`=unverified.

## Grok 4.6 deltas (2026-08-12; RL/post-train update on 4.5, not a new pretrain)
- AAI 61 (= GPT-5.6 Sol, 2 behind Fable 5); SWE-bench (Vals) 95.6% (+9 vs 4.5) [com].
- **Cost per TASK ~2x 4.5 despite flat $2/$6 unit price**: ~30% more output tokens per run (~$0.84/task, ~1/4 of Fable). Cache read $0.30 → $0.50/1M. Budget by task, not by unit price [com].
- **The 4.5 speed edge is GONE** (token inflation): stop routing latency-sensitive work here [com].
- Grok 4.7 teased ~Sept w/ SpaceX data; re-verify this file then [?].

---

## Route to / away (what it is actually FOR)

**TO it:** repo-wide audits / multi-file comprehension and restructuring at ~1/4 Fable task cost (its 4.6 sweet spot [com]), agentic tool loops (Cursor co-trained, RL on "investigate, use tools, recover from mistakes, verify"), legal+finance knowledge work (#1 Harvey Legal), cheap Opus-class second opinion.
**AWAY:** frontend/UI/design taste (Fable/Sol clearly better; 4.6 output "Tailwind-template-like" [com]), 3D/canvas/WebGL (blank first passes, inverted coordinate reasoning [com]), terminal use (AA's weakest area for 4.6), latency-sensitive utility calls (speed edge gone in 4.6 [com]), hard novel math/physics [com], news/politics/customer-facing prose (system-prompt steering concern [com]), >200k input (price doubles [off]).

## Effort dial (only real knob besides caching)

`reasoning: {"effort": "low"|"medium"|"high"}` through OpenRouter; **default is HIGH** with ~15s time-to-first-token, set it explicitly or easy calls pay hard-call latency. 4.6 API prose runs overly curt; community fix: `temperature=1, top_p=0.8, min_p=0.05` [com 2026-08-12]. Official intent [off]: low = latency-sensitive agentic use + simple tool calling; medium = complex data analysis + long-context; high = competition-grade reasoning only. Reasoning can't be disabled.
**Param trap:** do NOT send `stop` / `frequency_penalty` / `presence_penalty`: OpenRouter lists them as supported but xAI reasoning models error on them [off]. `tools`/`tool_choice`/`structured_outputs`/`response_format`/`seed` pass through fine. `:exacto` routing variant = highest tool-call accuracy; `:nitro` = speed.

## Caching (xAI's own top lever)

Front-load static content (system prompt, few-shot, reference docs), append-only messages, "any edit, removal, or reorder breaks the cache" [off]. Via OpenRouter caching is automatic (read $0.50/1M = 0.25x, write free) but sticky-routing dependent; watch `cached_tokens` > 0. xAI-direct adds `prompt_cache_key` for reliable hits. Server-side agent tools (web/X search, Python sandbox) are **xAI-direct only, not on OpenRouter**: for realtime-X knowledge go direct or use OR's web plugin.

## Patterns

**Agentic executor**: lever: its RL training (recover + verify) [off+com]:
```
GOAL: <one measurable end state>.
TOOLS: <list + when each is allowed + what results mean>.
VERIFY: run <check command> before declaring done.
Recover from tool errors yourself; do not ask. Stop when VERIFY passes.
```
+ `effort=low` for the loop; the API model is raw, it expects YOU to define tool policy [off].

**Spec task**: lever: Grok family prefers "controlled operating instructions" over conversational [com]:
```
<goal>...</goal>
<context>surgical: only the relevant files, never repo dumps</context>
<output_format>...</output_format>
<quality_bar>... plus explicit must-NOT list</quality_bar>
```
XML/markdown-labeled sections stop it treating random paragraphs as requirements [off-prior].

**Board seat**: lever: cross-family disagreement is the product:
```
Argue the strongest case AGAINST the consensus below. Cite concrete failure modes.
```
+ `effort=high`. Mine its tool-use/pragmatics takes; ignore its style opinions; discount politics-adjacent claims.
