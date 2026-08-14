# Google Gemini + xAI Grok lineups, verified 2026-08-12

Everything below verified live on 2026-08-12 against primary docs where possible. Source numbers in `[n]` map to the Sources section. Nothing here is from model memory.

---

## 1. Comparison table

Prices = USD per 1M tokens, paid tier, text.

| Model | In | Out | Cached in | Ctx | Max out | Thinking counts vs output cap | Strict schema | Batch | Best for |
|---|---|---|---|---|---|---|---|---|---|
| gemini-3.6-flash | $1.50 | $7.50 | $0.15 | 1M | 64K | YES (shared budget) | responseSchema, OpenAPI subset | 50% off, ~24h | default workhorse, agentic + coding, fewer wasted tokens |
| gemini-3.5-flash | $1.50 | $9.00 | $0.15 | 1M | 65,536 | YES | same | 50% off | max flash intelligence, "sustained frontier performance" |
| gemini-3.5-flash-lite | $0.30 | $2.50 | $0.03 | 1M | 64K | YES | same | 50% off | cheapest current-gen, bulk classification/extraction |
| gemini-3.1-flash-lite | $0.25 | $1.50 | $0.025 | 1M (unverified) | 64K (unverified) | YES | same | 50% off | absolute cheapest still-listed, prior gen |
| gemini-3.1-pro-preview | $2.00 (<=200k) / $4.00 (>200k) | $12.00 / $18.00 | $0.20 / $0.40 | 1M | 64K | YES | same | 50% off | hardest reasoning, best multilingual number on record (MMMLU 92.6) |
| grok-4.5 | $2.00 (<200k) / $4.00 | $6.00 / $12.00 | $0.30 / $0.60 | 500k | not documented | not documented | json_schema, strict implicit on tools | not verified | xAI flagship, code + chat |
| grok-4.3 | $1.25 / $2.50 | $2.50 / $5.00 | $0.20 / $0.40 | 1M | not documented | not documented | json_schema | not verified | cheap 1M-context long-doc work |
| grok-4.20-0309-reasoning | $1.25 / $2.50 | $2.50 / $5.00 | $0.20 / $0.40 | 1M | not documented | not documented | json_schema | not verified | prior-gen reasoning, 1M ctx |
| grok-4.20-0309-non-reasoning | same as above | same | same | 1M | not documented | n/a (no reasoning) | json_schema | not verified | latency-critical, no thinking spend |
| grok-4.20-multi-agent-0309 | $1.25 / $2.50 | $2.50 / $5.00 | $0.20 / $0.40 | 1M | not documented | not documented | json_schema | not verified | parallel-agent hard problems, `xhigh` effort |
| grok-build-0.1 | $1.00 / $2.00 | $2.00 / $4.00 | $0.20 / $0.40 | 256k | not documented | not documented | json_schema | not verified | build/agent product tier, cheapest Grok |

Gemini price tiering: only 3.1-pro-preview tiers by prompt size (<=200k vs >200k). All flash/flash-lite are flat [2].
Grok price tiering: every model tiers at the 200k prompt boundary, price doubles above it [3].
Gemini cache storage: $1.00 per 1M tokens per hour on flash/flash-lite, $4.50 on 3.1-pro-preview [2].

---

## 2. What changed since 2026-07-12

Confirmed removals, with Google's own stated replacements [4]:

- `gemini-2.0-flash`: shutdown 2026-06-01, replacement `gemini-3.6-flash`.
- `gemini-2.0-flash-lite`: shutdown 2026-06-01, replacement `gemini-3.1-flash-lite`.
- `gemini-3-pro-preview`: shutdown 2026-03-09, replacement `gemini-3.1-pro-preview`.
- `gemini-2.5-flash`: still stable, no shutdown date announced.

New/current stable list on the models page [1]: `gemini-3.6-flash`, `gemini-3.5-flash`, `gemini-3.5-flash-lite`, `gemini-3.1-flash-lite`. Pro tier is still `gemini-3.1-pro-preview` (Preview status), nothing has superseded it in the public API list. Press coverage says a 3.5 Pro is "on the way" but it is not in the API list today [7].

`gemini-robotics-er-2` exists, out of scope, not researched.

xAI: `grok-4.5` is the documented flagship, "the most intelligent and fastest model we've built" [3]. Nothing newer is listed. `grok-4.3` and the `grok-4.20-*` family remain as cheaper 1M-context options, `grok-build-0.1` is a separate 256k build tier.

---

## 3. Per-model notes

### gemini-3.6-flash
The default. Released 2026-07-21 [6]. Positioned as "balances speed with intelligence" [1] and marketed on token efficiency: "designed to produce polished outputs with fewer unnecessary edits and less hedging, while reducing token use" [6]. Knowledge cutoff March 2026 for some domains, January 2025 for others [5].

- Drive it well: `thinking_level` defaults to `medium`, four levels `minimal|low|medium|high` [8]. For bulk deterministic extraction set `minimal` and reclaim the output budget.
- Strongest point: cheaper output than 3.5-flash ($7.50 vs $9.00) with the same input price, and explicitly tuned to emit fewer tokens. For a 4000-call bulk job that is the whole ballgame.
- Weakest point: no per-model implicit-cache threshold published for 3.6 specifically (see gotchas).
- Gotchas:
  - 1M in / 64K out [5]. The 64K out is a hard ceiling, not a suggestion.
  - Thinking tokens are billed as output: "When thinking is turned on, response pricing is the sum of output tokens and thinking tokens" [8].
  - Thinking cannot be turned fully off. Floor is `minimal`, not `off` (only the older 2.5-flash-lite had an actual Off default) [8].

### gemini-3.5-flash
"Most intelligent model for sustained frontier performance" [1]. 1M ctx, 65,536 max out [9]. Same $1.50 input as 3.6-flash but $9.00 output. `thinking_level` default `medium` [8].

- Strongest point: top flash-tier reasoning quality.
- Weakest point: costs 20% more per output token than 3.6-flash for a mandate that 3.6 was built to undercut. Only pick it if a quality delta is measured, not assumed.
- Confirmed implicit caching model with a 4,096-token minimum [10].

### gemini-3.5-flash-lite
"Fastest, most cost-effective" [1]. $0.30 in / $2.50 out, cache reads $0.03 [2]. 1M ctx, 64K out [9]. `thinking_level` default is `minimal` here, which is the right default for bulk work [8].

- Strongest point: 5x cheaper input than 3.6-flash, and the minimal-by-default thinking means the output budget is not silently eaten.
- Weakest point: output is $2.50, only 3.3x cheaper than 3.6-flash's $7.50, so on output-heavy jobs the saving is smaller than the headline input ratio suggests.

### gemini-3.1-flash-lite
Prior-gen, still listed and still the cheapest Gemini: $0.25 in (text/image/video), $0.50 audio, $1.50 out, cache $0.025 [2]. Named as the migration target for the dead 2.0-flash-lite [4].

- Use it only if 3.5-flash-lite is measurably no better on your task. Otherwise the newer lite is the safer default.

### gemini-3.1-pro-preview
Still the Pro tier and still Preview [1]. 1M ctx, 64K out [11]. `thinking_level` supports only `low|medium|high`, default `high` [8]. There is no `minimal` on Pro, so Pro always burns real thinking tokens.

- Strongest point: the best multilingual evidence in the whole comparison, MMMLU 92.6% [11], and the top Global-MMLU-Lite score on the public leaderboard at 93.2% [12].
- Weakest point: default `high` thinking plus $12-$18 output and >200k price doubling makes it the easiest model here to accidentally overspend on.
- Gotcha: implicit caching threshold 4,096 tokens, cache storage $4.50 per 1M per hour, 22x the flash rate [2][10].

### grok-4.5
Flagship. 500k ctx, knowledge cutoff 2026-02-01 [3]. $2.00/$6.00 under 200k prompt, $4.00/$12.00 above. Cached input $0.30.

- Drive it well: `reasoning_effort` accepts `low|medium|high`, defaults to `high` [13]. Set `low` for latency-sensitive bulk.
- Strongest point: cheapest cached-input-to-input ratio in the table (0.15x) and automatic caching with no cache-management API to maintain [14].
- Weakest point: 500k ctx is the smallest in the Grok line, and reasoning cannot be disabled at all: "Reasoning cannot be disabled" [13].
- Gotchas:
  - `presencePenalty`, `frequencyPenalty` and `stop` cannot be used with reasoning models [13].
  - `logprobs` and `top_logprobs` are not supported by grok-4.20 and newer, which includes 4.5 [3].
  - Reasoning tokens "are billed as part of your total consumption" [13].

### grok-4.3 and grok-4.20 family
All 1M ctx, all priced identically at $1.25/$2.50 below 200k [3]. `grok-4.20-0309-non-reasoning` is the only model in either lineup where you can genuinely have zero thinking spend, because it is a separate non-reasoning endpoint rather than a flag. `grok-4.20-multi-agent-0309` adds an `xhigh` effort level that "controls agent count, not depth" [13].

- Pick 4.3 over 4.5 when you need 1M context or half the price and do not need the newest reasoning.

### grok-build-0.1
256k ctx, $1.00/$2.00 below 200k [3]. Cheapest Grok. Positioned around the Grok Build product surface. No further primary detail found.

---

## 4. Structured output

### Gemini
Config is `response_format` with `mime_type: "application/json"` plus a `schema` field carrying a JSON Schema subset [15].

Supported: `string`, `number`, `integer`, `boolean`, `object`, `array`, and `null` as a union member (`{"type": ["string","null"]}`). Guidance keys `title`, `description`. `enum` for strings or numbers. `format` for `date-time`, `date`, `time`. Objects: `properties`, `required`, `additionalProperties`. Arrays: `items`, `prefixItems`, `minItems`, `maxItems`. Numbers: `minimum`, `maximum` [15].

Restrictions, quoted: "Not all JSON Schema features are supported" and "Very large or deeply nested schemas may be rejected" [15]. The docs do not enumerate which unsupported keys are silently dropped versus rejected, so treat any exotic keyword as unverified and test it.

Grounding interaction: the current docs say structured outputs CAN be combined with Gemini 3-series tools including Google Search, URL Context, Code Execution, File Search and Function Calling, and document no mutual exclusivity [15]. The old "JSON mode XOR grounding" rule is not stated in today's docs. Do not assume it still holds either way without an integration test.

`propertyOrdering`: not present in the current structured-output page. It was a Gemini-specific extension in earlier revisions. Could not verify its current status, see section 7.

### xAI
`response_format.type` = `json_schema` with the schema under `response_format.json_schema`. Also `json_object` and `text` [16]. Documented on "supported Grok 4 family models", examples use grok-4.5.

Strict is implicit for tools: "xAI models will always generate tool call arguments that strictly conform to the tool's input JSON Schema (the `strict` flag is implicitly always `true`)" [16].

xAI's schema documentation is materially more precise than Google's. Supported: string, number, integer, boolean, null, enum, const, array, object, `anyOf`, `oneOf`, `allOf` (single subschema), non-circular `$ref`/`$defs`. Enforced string formats: date, time, date-time, email, uuid, ipv4, ipv6, uri [16].

Hard gotcha: "`additionalProperties` defaults to `false` and must be set to `true` explicitly" [16]. This is the opposite of JSON Schema's own default and will silently strip fields if you port a schema over.

Enforcement ceilings [16]: min/max numeric unbounded, minLength/maxLength enforced to 2,048 chars, minItems/maxItems enforced to 256 items, minProperties/maxProperties to 64 properties. Past those bounds the constraint is not guaranteed.

Rejected outright: empty enums, empty anyOf variants, boolean property schemas, `maxContains`/`minContains`, array-form `items`. Regex `pattern` does not support backreferences, unicode property escapes, word boundaries, lookahead/lookbehind, inline modifiers [16].

Best-effort only (works in practice, not structurally guaranteed): `not`, `if`/`then`/`else`, multi-subschema `allOf`, non-standard `format` values [16].

Note the 256-item array ceiling against the use case: a strict JSON array of 4000-ish product attribute rows would exceed xAI's guaranteed `maxItems` enforcement. Chunk it.

---

## 5. Caching

### Gemini
Implicit caching "is enabled by default for all Gemini 2.5 and newer models" [10]. No opt-in, no cache object, discount applied on hit automatically.

Published minimum thresholds [10]:
- gemini-3.5-flash: 4,096 tokens
- gemini-3.1-pro-preview: 4,096 tokens
- gemini-2.5-flash: 2,048 tokens
- gemini-2.5-pro: 2,048 tokens

The caching page does not list gemini-3.6-flash or gemini-3.5-flash-lite thresholds. The blanket "2.5 and newer" statement covers them, but the exact minimum is unverified, assume 4,096 and put the fixed rulebook prefix first.

Explicit caching still exists on generateContent but is "not supported in the Interactions API" [10]. TTL defaults are not stated on the caching page, unverified.

Cache pricing [2]: reads at $0.15 per 1M on 3.6/3.5-flash, $0.03 on 3.5-flash-lite, $0.20/$0.40 on 3.1-pro-preview. Explicit-cache storage billed per hour: $1.00 per 1M tokens/hour on flash tiers, $4.50 on Pro. Implicit caching has no storage charge (there is no cache object to store).

### xAI
Caching is automatic, no explicit cache API: xAI performs prompt caching automatically and bills cached tokens at a reduced rate [14]. xAI recommends setting the `x-grok-conv-id` HTTP header to maximise hit rate [14]. Observe hits via `response.usage.prompt_tokens_details.cached_tokens` (Chat Completions) or `response.usage.input_tokens_details.cached_tokens` (Responses) [14].

Docs warn entries can be evicted under memory pressure and requests may route to different servers. No published TTL, no published minimum token threshold. Both unverified.

Cached-input discount is steep and uniform: roughly 0.15-0.16x the base input price on every model [3].

---

## 6. Batch

Gemini Batch API: "50% of the standard cost", target turnaround "24 hours, but in majority of cases, it is much quicker" [17]. Input file cap 2GB, inline requests under 20MB [17]. Context caching works in batch ("Context caching is supported for batch requests", standard cache rates on hit) and structured output works in batch [17]. This combination, 50% off AND cache hits, is the single most important economic fact for a 4000-call fixed-prefix pipeline.

xAI: a Batch API is referenced in search results around the docs but I could not open a primary xAI batch page and cannot state a discount or SLA. Unverified.

---

## 7. Thinking and reasoning controls

### Gemini
The parameter is `thinking_level`, values `minimal|low|medium|high` [8]. There is no `thinking_budget` in the current thinking docs, the older numeric budget knob is not documented today.

Defaults [8]:
- gemini-3.6-flash: `medium`
- gemini-3.5-flash: `medium`
- gemini-3.5-flash-lite: `minimal`
- gemini-3.1-pro-preview: `high`, and Pro only accepts `low|medium|high`

"Gemini models engage in dynamic thinking by default, automatically adjusting the amount of reasoning effort based on the complexity of the request" [8]. Thinking cannot be set to off on any current model, the floor is `minimal`.

THE OUTPUT-CAP TRAP. The official thinking page states pricing plainly: "When thinking is turned on, response pricing is the sum of output tokens and thinking tokens" [8]. What it does NOT plainly state is whether thought tokens are deducted from `maxOutputTokens`. I could not find that sentence in Google's own docs, and that omission is itself the trap. Multiple independent, reproducible bug reports say the answer is yes, thinking tokens are counted against `maxOutputTokens` on Gemini 3-series [18][19][20]:
- googleapis/python-genai issue 2062, titled "max_output_tokens caps thinking + output tokens combined, causing infinite hangs without it" [19].
- ha-llmvision issue 609, "Gemini 2.5/3 Flash thinking tokens consume maxOutputTokens, causing empty responses" [18].
- Google AI dev forum thread "Gemini 3 output limited to ~4k tokens instead of 65k" [20].

Practical consequence for a 64k-output job: you must set `maxOutputTokens` to the full 65,536 AND set `thinking_level: "minimal"`, otherwise the thinking phase eats headroom and you get a truncated or empty JSON array with `finishReason: MAX_TOKENS`. Treat this as verified-by-community, not verified-by-Google.

### xAI
`reasoning_effort`, values `low|medium|high`, default `high`, and "Reasoning cannot be disabled" [13]. `grok-4.20-multi-agent` adds `xhigh`, which "controls agent count, not depth" [13]. Reasoning tokens "are billed as part of your total consumption" [13]. Whether they count against `max_tokens` is not documented, unverified. If you need genuinely zero reasoning spend on xAI, the only clean route is the separate `grok-4.20-0309-non-reasoning` endpoint.

---

## 8. Gotchas list

Gemini:
- Thinking tokens share the `maxOutputTokens` budget (community-verified, not documented). Biggest single cause of silent truncation. [18][19][20]
- Thinking cannot be disabled, only reduced to `minimal`, and Pro cannot even go that low. [8]
- Pro price doubles above a 200k prompt, and Pro's cache storage is $4.50 per 1M per hour. [2]
- "Very large or deeply nested schemas may be rejected" and the unsupported-keyword list is not published. Test your real schema before a 4000-call run. [15]
- The 3.6-flash / 3.5-flash-lite implicit-cache thresholds are not published individually. [10]
- Preview status on the entire Pro tier (`gemini-3.1-pro-preview`) means it can move under you. Its predecessor `gemini-3-pro-preview` was already shut down 2026-03-09. [1][4]
- Three models vanished from the API list between 2026-07-12 and now, all with published replacements. Pin model IDs and watch the deprecations page. [4]

xAI:
- `additionalProperties` defaults to `false`, inverted vs standard JSON Schema. [16]
- Array constraint enforcement only guaranteed to 256 items, strings to 2,048 chars, objects to 64 properties. [16]
- `presencePenalty`, `frequencyPenalty`, `stop` are rejected on reasoning models. [13]
- `logprobs`/`top_logprobs` unsupported on grok-4.20 and newer. [3]
- Cache entries evict under memory pressure and requests may hit different servers, so cache hit rate is not guaranteed. Set `x-grok-conv-id`. [14]
- EU: grok-4.5 launched 2026-07-08 blocked in all 27 EU states over EU AI Act GPAI-with-systemic-risk obligations, then became available in the API console for EU users on 2026-07-17. As of 2026-08-12 EU API access is open. Two caveats from the same reporting: xAI has never published a country list, and inference still runs in US regions, so "available in the EU" does not mean "processed in the EU". This matters for a GDPR review on Hungarian partner/product data. Sourced from secondary coverage only, xAI has no primary page on this. [21]
- No verified batch API discount or SLA. [unverified]

---

## 9. Multilingual, Hungarian and CEE

Honest answer: thin.

- gemini-3.1-pro-preview reports MMMLU (multilingual QA) 92.6% with no per-language breakdown [11].
- gemini-3.1-pro-preview leads the public Global-MMLU-Lite leaderboard at 93.2%, ahead of gemini-3-pro-preview at 92.2% [12].
- Global-MMLU-Lite's latest release does add Hungarian, along with Slovak, Czech, Oriya, Tajik and Italian [12]. But the Artificial Analysis leaderboard shows only an all-language average plus English, Chinese, Hindi, Spanish, French, Arabic, Bengali, Portuguese, Indonesian, Japanese, Swahili, German, Korean, Italian, Yoruba, Burmese. No Hungarian, Czech, Slovak, Polish or Romanian column is displayed [12].
- The gemini-3.6-flash model card mentions only "Automated safety policy evaluation across multiple languages" and names no languages [5].

**No Hungarian-specific or CEE-specific published evaluation found for any Gemini 3.5/3.6 model or any Grok model.** No evidence found. Do not assume the Gemini multilingual reputation transfers to Hungarian attribute extraction, benchmark it on your own labelled set.

---

## 10. Pick this when

1. **Bulk 4000-call fixed-prefix Hungarian extraction, cost-first**: `gemini-3.5-flash-lite` via Batch API. $0.15 in / $1.25 out batched, cache reads $0.03, and `minimal` thinking is already the default so the 64K output budget stays yours.
2. **Same job, quality-first**: `gemini-3.6-flash` via Batch, `thinking_level: "minimal"`, `maxOutputTokens: 65536`. $0.75 in / $3.75 out batched. Cheaper output than 3.5-flash for a model explicitly built to emit fewer tokens.
3. **Never** run the bulk job on `gemini-3.1-pro-preview`: default `high` thinking, no `minimal` level, $12-$18 output, and the thinking tokens eat the same 64K cap.
4. **Need one hard adjudication pass over the tricky 5%**: `gemini-3.1-pro-preview`, it is the only model here with a published top-tier multilingual number.
5. **Need >500k of context in one call**: `grok-4.3` or the `grok-4.20` family (1M ctx at $1.25/$2.50), or any Gemini (1M ctx). Not grok-4.5, it caps at 500k.
6. **Need a genuinely non-thinking model for latency or determinism**: `grok-4.20-0309-non-reasoning`. It is the only true thinking-off option across both vendors.
7. **Schema precision matters more than price**: xAI. Its structured-output contract is explicitly documented down to enforcement ceilings, Google's says "not all features are supported" and stops.
8. **EU data-residency is a hard requirement**: neither. Gemini needs a Vertex regional deployment (not covered here), and xAI EU access is console availability only, inference still runs in US regions [21].

---

## 11. Sources

1. Gemini API models list, ai.google.dev/gemini-api/docs/models, fetched 2026-08-12
2. Gemini API pricing, ai.google.dev/gemini-api/docs/pricing, fetched 2026-08-12
3. xAI models + pricing, docs.x.ai/docs/models and docs.x.ai/developers/models, fetched 2026-08-12
4. Gemini deprecations, ai.google.dev/gemini-api/docs/deprecations, fetched 2026-08-12
5. Gemini 3.6 Flash model card, deepmind.google/models/model-cards/gemini-3-6-flash/, fetched 2026-08-12
6. OpenRouter google/gemini-3.6-flash, openrouter.ai/google/gemini-3.6-flash, fetched 2026-08-12 (release date 2026-07-21)
7. VentureBeat, "Google's Gemini 3.6 Flash model cuts AI agent token costs by up to 65%... and 3.5 Pro is on the way", venturebeat.com, seen 2026-08-12
8. Gemini thinking docs, ai.google.dev/gemini-api/docs/thinking, fetched 2026-08-12
9. Gemini 3.5 Flash and 3.5 Flash-Lite model cards, deepmind.google/models/model-cards/gemini-3-5-flash/ and /gemini-3-5-flash-lite/, via search 2026-08-12
10. Gemini context caching docs, ai.google.dev/gemini-api/docs/caching, fetched 2026-08-12
11. Gemini 3.1 Pro model card, deepmind.google/models/model-cards/gemini-3-1-pro/, fetched 2026-08-12
12. Global-MMLU-Lite leaderboard, artificialanalysis.ai/evaluations/global-mmlu-lite, fetched 2026-08-12; benchmark description cohere.com/research/globalmmlu
13. xAI reasoning guide, docs.x.ai/docs/guides/reasoning, fetched 2026-08-12
14. xAI prompt caching, docs.x.ai/developers/advanced-api-usage/prompt-caching (+ /how-it-works, /maximizing-cache-hits), via search 2026-08-12
15. Gemini structured output docs, ai.google.dev/gemini-api/docs/structured-output, fetched 2026-08-12
16. xAI structured outputs guide, docs.x.ai/docs/guides/structured-outputs, fetched 2026-08-12
17. Gemini Batch API, ai.google.dev/gemini-api/docs/batch-api, fetched 2026-08-12
18. GitHub valentinfrlch/ha-llmvision issue 609, "Gemini 2.5/3 Flash thinking tokens consume maxOutputTokens, causing empty responses", seen 2026-08-12
19. GitHub googleapis/python-genai issue 2062, "max_output_tokens caps thinking + output tokens combined, causing infinite hangs without it", seen 2026-08-12
20. Google AI Developers Forum, "Gemini 3 output limited to ~4k tokens instead of 65k", discuss.ai.google.dev/t/114011, seen 2026-08-12
21. EU block coverage (secondary only): cybernews.com/geo-restrictions/how-to-access-grok-4-5-in-the-eu, thebestvpn.com/how-to-access-grok, cloudmagazin.com 2026-07-10, moclaw.ai/blog/grok-4-5-eu-release-date; all seen 2026-08-12

---

## 12. Could not verify

- Whether Gemini thinking tokens count against `maxOutputTokens`, from a Google primary source. Community evidence is consistent and reproducible [18][19][20] but Google's thinking page only commits to the pricing statement.
- `propertyOrdering`: not present in the current structured-output docs. Cannot confirm whether it still works, was renamed, or was removed.
- The specific list of JSON Schema keywords Gemini silently ignores versus rejects. Docs say only "not all features are supported".
- Whether Gemini JSON mode and Google Search grounding are still mutually exclusive. Current docs say tools CAN be combined with structured outputs and mention no exclusivity, but do not explicitly retract the old restriction.
- Implicit-cache minimum token threshold for `gemini-3.6-flash` and `gemini-3.5-flash-lite` specifically.
- Gemini explicit-cache TTL default.
- gemini-3.1-flash-lite context window and max output (assumed 1M / 64K by family pattern, not confirmed on a model card).
- Gemini rate limits per tier. Not fetched, budget.
- xAI max output tokens for every model. Not documented on the models page.
- Whether xAI reasoning tokens count against `max_tokens`.
- xAI cache TTL and minimum cacheable prefix length.
- xAI Batch API existence, discount and SLA from a primary page.
- xAI EU status from a primary xAI source. All EU evidence is secondary press.
- Any Hungarian or CEE per-language benchmark for any model in scope. No evidence found.
