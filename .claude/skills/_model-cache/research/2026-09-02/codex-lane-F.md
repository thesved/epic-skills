# TLDR

1. **Put GLM-5.3-Flash in the cheap multimodal worker lane**, below Fable 5.1 and GPT-5.6 Sol, alongside DeepSeek V4 Pro. It is best used for repo reconnaissance, scaffolding, routine implementation, visual inspection, long-context triage, and second-opinion review.
2. **It is not text-only.** Z.ai calls it its “first natively multimodal model in the GLM-5 family”; it accepts text, images, video, and files, then outputs text. `[OFFICIAL, ASSERTED]` ([Z.ai, 2026-09-02](https://autoclaw.z.ai/blog/model/glm-5.3-flash/))
3. **Architecture:** 320B rounded total, 18B active, 45 layers, 34 linear-attention layers, 11 sparse-attention layers, 288 routed experts with top-8 selection, one shared expert, mHC, and IndexPool. `[OFFICIAL, DEMONSTRATED]` ([config.json, accessed 2026-09-02](https://huggingface.co/zai-org/GLM-5.3-Flash/blob/main/config.json))
4. **Capacity:** Z.ai guarantees 1,048,576 context and 131,072 maximum output. OpenRouter advertises a 1,310,720 router-level context, but its top upstream provider metadata still says 1,048,576. Plan around 1M, not 1.31M.
5. **Pricing through 2026-09-09 16:00 UTC:** $0.075 input, $0.015 cache read, $0.25 output per million tokens. List pricing is $0.15, $0.03, $0.50. `[OFFICIAL, DEMONSTRATED]` ([Z.ai pricing](https://docs.z.ai/guides/overview/pricing))
6. **Thinking is mandatory.** It cannot be disabled. Supported effort levels are exactly `low`, `high`, and `max`; `max` is the default. `[OFFICIAL, DEMONSTRATED]` ([Z.ai thinking docs](https://docs.z.ai/guides/capabilities/thinking-mode))
7. **Tool calling is a real strength, but strict structured output is not production-safe.** OpenRouter explicitly says standard Flash supports JSON output “without JSON-schema enforcement.” A reproduced issue also showed `json_object` deleting lowercase `json` on two providers.
8. **Independent capability is strong but below elite execution:** Artificial Analysis 57, LiveBench 71.6, and Agent Arena rank 19 overall. It trails full GLM-5.3 and the best proprietary executors, while often beating their cost by an order of magnitude.
9. **“Cheap per token” does not always mean cheapest completed task.** Agent Arena reports $0.12 median/task for Flash, $0.39 Terra, and $0.08 Luna. Flash emits roughly twice Luna’s output tokens per task.
10. **Production setting:** default to `high` for routine agent runs; escalate to `max` for hard debugging, repo-wide analysis, and benchmark reproduction. Give it at least 64K output headroom, preferably 128K, and preserve reasoning blocks between tool calls.

# 1. Official facts

## Identity, architecture, license, and modalities

| Fact | Verified result | Evidence |
|---|---|---|
| Release | 2026-08-26 | `[OFFICIAL, ASSERTED]` [Z.ai release post](https://z.ai/blog/glm-5.3-flash) |
| Z.ai API model | `glm-5.3-flash` | `[OFFICIAL, DEMONSTRATED]` [Z.ai model docs](https://docs.z.ai/guides/vlm/glm-5.3-flash) |
| OpenRouter standard | `z-ai/glm-5.3-flash` | `[OFFICIAL, DEMONSTRATED]` [OpenRouter model page](https://openrouter.ai/z-ai/glm-5.3-flash) |
| OpenRouter batch | `z-ai/glm-5.3-flash:batch` | `[OFFICIAL, DEMONSTRATED]` [OpenRouter batch page](https://openrouter.ai/z-ai/glm-5.3-flash%3Abatch) |
| Rolling alias | `~z-ai/glm-flash-latest` | `[OFFICIAL, DEMONSTRATED]` [OpenRouter API catalog](https://openrouter.ai/api/v1/models) |
| Free slug | `z-ai/glm-5.3-flash:free` | **NOT FOUND** in the 2026-09-02 OpenRouter catalog |
| Weights | `zai-org/GLM-5.3-Flash` | `[OFFICIAL, DEMONSTRATED]` [Hugging Face](https://huggingface.co/zai-org/GLM-5.3-Flash) |
| License | MIT | `[OFFICIAL, DEMONSTRATED]` Hugging Face displays “License: mit” |
| Parameters | 320B rounded, HF reports 321B exact, 18B active | `[OFFICIAL, DEMONSTRATED]` |
| Inputs | Video, image, text, file | `[OFFICIAL, ASSERTED]` |
| Output | Text | `[OFFICIAL, ASSERTED]` |
| Context | 1M native | `[OFFICIAL, DEMONSTRATED]` |
| Max output | 128K, exactly 131,072 | `[OFFICIAL, DEMONSTRATED]` |

The configuration exposes 45 transformer layers: 34 KDA-style linear-attention layers and 11 DeepSeek-style sparse-attention layers. It has 64 attention heads, 288 routed experts, top-8 routing, one shared expert, three initial dense layers, `index_kpool: 4`, and `mhc: true`. Z.ai claims 3.01x lower attention compute and 4.44x smaller KV cache than full GLM-5.3. ([Z.ai docs](https://docs.z.ai/guides/vlm/glm-5.3-flash), [configuration](https://huggingface.co/zai-org/GLM-5.3-Flash/blob/main/config.json))

Z.ai’s precise description is:

> “first natively multimodal model in the GLM-5 family”

That directly falsifies the text-only hypothesis. The Hugging Face card also supplies a working `image-text-to-text` example. OpenRouter declares text, image, and video input. Audio support is **NOT FOUND**.

## Context discrepancy

Three numbers appear:

- Z.ai and the weights: **1,048,576 context, 131,072 max output**.
- OpenRouter standard route: **1,310,720 router context**, but `top_provider.context_length` is 1,048,576.
- Batch route: **1,048,575 context**, with a nonsensical-looking provider maximum completion of 943,717.

Treat 1,048,576 plus a 131,072 output ceiling as the operational contract. Do not build around the larger OpenRouter router-level number or the batch metadata anomaly.

## Pricing and providers

All figures are USD per 1M tokens as of 2026-09-02.

| Route | Input | Cache read | Output | Notes |
|---|---:|---:|---:|---|
| Z.ai direct promotion | $0.075 | $0.015 | $0.25 | Ends 2026-09-09 at 16:00 UTC |
| Z.ai direct list | $0.15 | $0.03 | $0.50 | Forecast using this |
| OpenRouter promo providers | $0.075 | $0.015 | $0.25 | Z.ai, NovitaAI, DeepInfra, GMICloud |
| OpenRouter Morph | $0.13 | $0.02 | $0.45 | Standing price |
| OpenRouter Makora | $0.14 | $0.024 | $0.47 | Fast but current uptime was weaker |
| Most other OpenRouter providers | $0.15 | $0.03 | $0.50 | List price |
| OpenRouter batch | $0.15 | $0.03 | $0.50 | Together only; no usable uptime data yet |
| Full GLM-5.3 direct | $1.40 | $0.26 | $4.40 | Roughly 9x input and output price |

OpenRouter listed 22 standard providers: Z.ai, NovitaAI, DeepInfra, GMICloud, Morph, Makora, Modal, Parasail, Reka, Together, Wafer, DigitalOcean, SiliconFlow, Friendli, Phala, Fireworks, NextBit, StreamLake, Cloudflare, io.net, Baseten, and Venice. `[OFFICIAL, DEMONSTRATED]`

Current provider performance was highly variable:

- Baseten: 113 tokens/s P50
- Fireworks: 70
- Modal: 68
- Friendli: 60
- Makora: 59
- Together: 54
- Z.ai: 23
- GMICloud: 18

These are live OpenRouter measurements, not controlled throughput tests. Artificial Analysis measured the first-party Z.ai API at 48.7 tokens/s and 1.52 seconds TTFT. ([OpenRouter](https://openrouter.ai/z-ai/glm-5.3-flash), [Artificial Analysis](https://artificialanalysis.ai/models/glm-5-3-flash/))

The official checkpoint is dynamic E4M3 FP8. OpenRouter’s current provider page did not expose every provider’s quantization in accessible text. **Current exact quantization for all 22 providers: NOT FOUND.** An August 27 endpoints snapshot identified most then-listed routes as FP8 and Venice and Cloudflare as unknown. For quality consistency, use the `quantizations: ["fp8"]` routing filter.

## Thinking and tools

Z.ai’s exact model-specific recommendation is:

> `temperature: 1`, `top_p: 0.95`, and `reasoning_effort: max`

Thinking behavior:

- `thinking.type` accepts only `enabled`.
- Thinking cannot be disabled.
- `reasoning_effort` accepts `low`, `high`, or `max`.
- Missing or invalid effort falls back to `max`.
- For coding agents, use `clear_thinking: false`.
- For ordinary stateless chat, the HF card says to explicitly use `clear_thinking: true`.
- When `clear_thinking` is false, return the complete, unchanged `reasoning_content` with subsequent tool results.

OpenRouter uses:

```json
"reasoning": {
  "effort": "max",
  "exclude": false
}
```

and returns `reasoning_details`, which must be preserved across tool turns.

Function calling supports `tools`, `tool_choice`, streaming tool calls, and interleaved reasoning. Z.ai officially documents `tool_choice: "auto"`; OpenRouter declares both `tools` and `tool_choice`.

## Structured output

This is the sharpest integration warning.

- Z.ai’s documentation calls its feature “Structured Output”, but the documented API is only `response_format: {"type":"json_object"}`. Its schema example places the schema in the system prompt, then validates client-side with Python `jsonschema`. That is not native schema enforcement. ([Z.ai structured output docs](https://docs.z.ai/guides/capabilities/struct-output))
- OpenRouter’s standard Flash page says it supports `response_format` **“without JSON-schema enforcement.”**
- OpenRouter’s batch page claims JSON-schema support, but it had no meaningful uptime data and only Together was listed. This remains `[OFFICIAL, ASSERTED, NOT INDEPENDENTLY DEMONSTRATED]`.
- A Flash-specific GitHub issue reproduced lowercase `json` disappearing under `json_object` through both Z.ai and Novita. For example, `application/json` became `application/`. The issue is now closed, but a conclusive maintainer explanation or verified fix was **NOT FOUND**. `[UNOFFICIAL, DEMONSTRATED]` ([issue 133, 2026-08-27](https://github.com/zai-org/GLM-5/issues/133))
- The reported full GLM-5.3 problem is separate: one independent test got 0/3 schema-valid structured responses, while nested tool calls passed 24/24 once the output budget was raised to 16K. That result must not automatically be transferred to Flash. ([MCP Playground, 2026-08-26](https://mcpplaygroundonline.com/blog/glm-5-3-mcp-servers))

Verdict: use tool schemas, but route strict response-schema generation elsewhere or validate and retry with another model.

## Coding Plan and reset cards

Current plan changes:

- Flash consumes one-third the quota of full GLM-5.3.
- The plan is now points-based and has a weekly limit.
- Calls during off-peak hours and all weekend consume 50% of normal points.
- Pro and Max advertise 6x and 14x the Lite allowance.
- BigModel’s first-five-day trial currently grants 3M full GLM-5.3 tokens plus 5M Flash tokens daily.
- An exact equivalent Z.ai global trial allocation was **NOT FOUND**.

The anniversary promotion was announced on 2026-09-01 and is live on 2026-09-02: every current subscriber is supposed to receive a reset card for the weekly and five-hour pools. The direct X page could not be retrieved, so the announcement is `[OFFICIAL, ASSERTED, DIRECT PAGE BLOCKED]`; the mechanics are documented officially:

> “After you click Reset, that quota goes straight back to 100%”

You must be signed into ZCode 3.8.1 or newer with the Coding Plan linked. API-key-only users do not receive cards. Cards expire, and the earliest-issued card is used first. ([ZCode usage docs](https://zcode.z.ai/en/docs/usage-stats), [announcement corroboration, 2026-09-01](https://runtimewire.com/article/zai-glm-coding-plan-anniversary-reset-card))

# 2. The Ox Alpha story

## What is actually verified

- Ox Alpha appeared around 2026-08-20 or 2026-08-21 as a free anonymous route, identified in OpenCode as `x-preview-f-free` and on OpenRouter as `stealth/ox-alpha`.
- Z.ai later confirmed it was GLM-5.3-Flash.
- Z.ai’s release text says:

> “It quickly became the most popular model of the week”

- Z.ai also asserts all preview traffic was served on Chinese AI accelerators. No independent infrastructure audit was published.
- The free preview ended around the August 26 reveal. There is no current Flash `:free` slug.

The wording “most-used model on OpenRouter” should be tightened to **Z.ai asserts it was the most popular model of that week on OpenCode and OpenRouter**. A frozen primary OpenRouter token total for the preview was **NOT FOUND**.

Circulating usage figures conflict:

- A Reddit snapshot reported 26T tokens by August 24.
- Secondary reporting cited 42T over six days.
- Other posts circulated roughly 16T, 20T, and 23T.
- OpenCode’s current cumulative page combines data in ways that produce an impossible pre-launch range, so it is not a clean reveal-period record.
- OpenRouter’s current Z.ai organization page shows 8.11T tokens for the post-release Flash slug, but that is not the Ox Alpha preview total.

Therefore: qualitative rank verified only as a vendor assertion; exact preview token count **NOT VERIFIED**.

## How the community identified it

The strongest pre-reveal work was black-box fingerprinting:

1. CTGT measured an exact **11-of-11 tokenizer match** with the GLM-5.x vocabulary, Z.ai-style Chinese error bodies, a temperature ceiling of 1.0, forced reasoning, 1M context, and working vision. `[UNOFFICIAL, DEMONSTRATED]` ([CTGT, 2026-08-24](https://www.ctgt.ai/research/behaviorally-fingerprinting-ox-alphas-provenance))
2. A separate published investigation used more than 600 calls and about 13.5M prompt tokens. It found a **44-of-44 GLM-5-generation tokenizer match**, retrieved 3/3 needles at 934,221 tokens, accepted input around 1.005M, and measured a 131,072 output ceiling. `[UNOFFICIAL, DEMONSTRATED]` ([evidence repository](https://github.com/LuD1161/ox-alpha-identification-public))
3. That work correctly established the Z.ai and GLM-5 generation, but initially favored the original GLM-5 checkpoint. It explicitly said the exact checkpoint and quantization were unproven. The later vendor reveal resolved the checkpoint identity.

The preview also allowed `/nothink` and could sharply reduce reasoning with `low`. The released Flash API now explicitly forces thinking, so do not carry the preview’s `/nothink` behavior into production assumptions.

## Anonymous practitioner findings

Positive reports clustered around:

- Long autonomous runs that continued making progress.
- Repo planning and infrastructure work.
- Greenfield scaffolding.
- Tool selection and tool argument formation.
- Finding holes missed by a stronger primary model.
- Pairing a premium orchestrator with Ox as the bulk executor.

Typical quote:

> “it seems it gets stuff done”

([r/opencode, approximately 2026-08-23](https://www.reddit.com/r/opencode/comments/1vvx2cj/try_ox_alpha_its_great/))

Negative reports included:

- Severe congestion, dropped connections, and speeds as low as 5 to 8 tokens/s.
- Repeating a failed approach after correction.
- Hallucinated implementation details.
- One Rust practitioner reported unsafe behavior and ignored repository instructions.
- Extreme token consumption for some multimodal requests, including an anecdotal 500K-token image description.
- Inconsistent claims that it was either five times more token-efficient than DeepSeek or vastly more wasteful.

These are anecdotes, not controlled comparisons. Their disagreement is itself useful: harness, provider, context preservation, and output caps materially affect the model.

# 3. Benchmarks and harness caveats

## Official vendor table

`[OFFICIAL, ASSERTED]`, not independently reproduced here.

| Benchmark | Flash | GLM-5.2 |
|---|---:|---:|
| Terminal-Bench 2.1 | 84.3 | 81.0 |
| DeepSWE v1.1 | 63.4 | 46.2 |
| NL2Repo | 56.3 | 48.9 |
| Toolathlon Verified | 78.4 | 59.9 |
| AutomationBench v1.0.6 | 48.8 | 26.2 |
| Agents’ Last Exam | 26.3 | 20.4 |
| HLE with Tools | 55.3 | 54.7 |
| GDPval-AA v2 | 1773 | 1504 |

Important harness details from the model card:

- Terminal-Bench: Claude Code 2.1.207, temperature 1, top-p 1, 65,536 output tokens, six-hour timeout.
- DeepSWE: `mini-swe-agent`, temperature 0.95, top-p 1, 400K context, six-hour timeout.
- NL2Repo: temperature 1, top-p 1, 64K output, 1M context, anti-hacking judges.
- Toolathlon: pass@1 averaged across three official-service runs.
- AutomationBench includes a fix for the benchmark’s null-type bug.
- HLE used a 300K managed context and GPT-5.6 Luna medium as judge.
- Z.ai Code Bench ran inside Claude Code 2.1.207: Flash max scored 29.0 versus Opus 4.8 at 29.5.

SWE-bench Pro, SWE-bench Verified, and ExploitBench results for Flash were **NOT FOUND**. Do not substitute full GLM-5.3 scores.

## Independent measurements

| Source | Flash result | Useful comparisons | Caveat |
|---|---|---|---|
| Artificial Analysis | Index 57 rounded, 57.5 in OpenRouter metadata; $0.09 per Index task; 48.7 tokens/s; 150M output tokens | Terra 57 at $1.74 blended; Luna 52 at $0.17; DeepSeek V4 Flash 52 at $0.23; full GLM-5.3 60 at $0.90 | Independent standardized suite, but not a coding-agent completion rate |
| LiveBench | 71.6 overall; $0.031 per successful task | Qwen 3.8 Flash 76.2; full GLM-5.3 76.1; Luna max 73.6; DeepSeek V4 Pro 0813 71.6; Ox Alpha max 69.2 | Same 2026-06-25 task release, models added later; provider and harness details remain material |
| Agent Arena, Sep 1 snapshot | Rank 19; net improvement 4.03%; confirmed success 14.56%; $0.12 median/task; 31.2K output tokens | DeepSeek Pro High rank 14 and $0.26; full GLM max rank 20 and $0.45; Terra xHigh rank 21 and $0.39; Luna xHigh rank 26 and $0.08 | Observational usage, not randomized; scaffold and task selection confound results |
| AI Coding Daily | 20.01/40, $0.02 average prompt, 8:54 average time | DeepSeek V4 Flash max 23.18; Luna high 24.86; Terra high 25.65; full GLM high 27.96; Sol high 34.72 | Four custom projects, different harnesses, partly subjective scoring |
| KingBench rerun | 63/80 reported for released Flash, versus 70/80 for Ox preview | Preview apparently scored better | Custom eight-task video benchmark; public runnable fixtures and raw results **NOT FOUND** |

Artificial Analysis’s useful warning is verbatim:

> “It’s also notably slow and very verbose.”

Its run generated 150M output tokens versus a 110M median. This is why output pricing and token ceilings matter more than the 18B active-parameter headline suggests. ([Artificial Analysis](https://artificialanalysis.ai/models/glm-5-3-flash/))

The LiveBench Ox 69.2 versus released Flash 71.6 difference also shows that a model label, provider, effort setting, or harness can shift results meaningfully even when the underlying weights are related.

## Explicit non-findings

As of 2026-09-02:

- SWE-bench Verified for Flash: **NOT FOUND**
- SWE-bench Pro for Flash: **NOT FOUND**
- Vals Flash evaluation: **NOT FOUND**
- ExploitBench or ExploitGym Flash evaluation: **NOT FOUND**
- Better Stack Flash bake-off: **NOT FOUND**
- RemakeBench Flash evaluation: **NOT FOUND**
- Reproducible public KingBench harness: **NOT FOUND**

SEO comparison pages that estimate or copy neighboring-model scores are not evidence.

# 4. Practitioner evidence and compatibility

## What it excels at

The combined evidence supports:

- **Repository reconnaissance:** reading large portions of a repo, producing dependency maps, and locating likely change sites.
- **Long-context review:** million-token capacity is real enough that anonymous testing retrieved three needles at 934K.
- **Bulk agent work:** docs, tests, migrations, boilerplate, first-pass refactors, issue triage, and log analysis.
- **Tool argument shaping:** full GLM-5.3’s 24/24 nested-tool result does not prove Flash, but Flash’s official Toolathlon and OpenCode behavior point in the same direction.
- **Visual coding loops:** screenshot inspection, chart/document review, rendered UI comparison, and browser feedback.
- **Second opinions:** community users repeatedly reported it catching omissions missed by more expensive models.

## Failure modes

- **Reasoning bloat:** mandatory thinking plus 128K output can turn a vague task into an expensive wandering run.
- **Correction resistance:** anonymous users described it as strong at greenfield work but weak at taking correction.
- **Loops:** reports vary, but high and max effort can spend very long periods reconsidering the same plan.
- **Provider variance:** current routes range from 18 to 113 tokens/s, with different uptime and context behavior.
- **JSON problems:** no schema enforcement on the standard OpenRouter route; reproduced lowercase `json` deletion under JSON mode.
- **Output-cap failures:** OpenCode can exhaust a 16K cap entirely inside thinking and return no deliverable.
- **Safety and low-level correctness:** one Rust report described introducing undefined behavior and ignoring repository instructions. This is anecdotal, but enough to require tests and premium review.
- **Censorship and security blind spots:** CTGT found a concentrated blacklist on certain China-sensitive topics. That makes it unsuitable as the sole geopolitical or security analyst.
- **Verbosity:** independent measurement confirms above-median output use.

## Best settings

Use:

- `temperature: 1.0`
- `top_p: 0.95` for general work
- `top_p: 1.0` for reproducing Z.ai’s agentic coding harnesses
- `reasoning_effort: high` for normal production
- `reasoning_effort: max` for hard analysis and benchmark reproduction
- `reasoning_effort: low` for small edits, classification, and short review
- At least 64K `max_tokens` for substantial agent runs
- 128K when the harness permits it
- Preserve reasoning blocks exactly between tool calls
- Require tests, linting, and a second-model review before accepting multi-file changes

## Harness compatibility

### Claude Code direct through Z.ai

Z.ai provides an official Anthropic-compatible endpoint:

```json
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "YOUR_ZAI_KEY",
    "ANTHROPIC_BASE_URL": "https://api.z.ai/api/anthropic",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-5.3-flash[1m]",
    "CLAUDE_CODE_AUTO_COMPACT_WINDOW": "1000000",
    "API_TIMEOUT_MS": "3000000"
  }
}
```

The same page is internally inconsistent: its summary maps Opus, Sonnet, and Haiku to Flash, while its detailed example maps only Haiku to Flash and maps Sonnet and Opus to full GLM-5.3. If you intentionally want all Claude Code work on Flash, explicitly set all three default model variables to `glm-5.3-flash[1m]`. ([Z.ai Claude Code guide](https://docs.z.ai/devpack/tool/claude))

### Claude Code through OpenRouter

OpenRouter’s Anthropic-compatible base URL is `https://openrouter.ai/api`. OpenRouter itself warns that Claude Code is only guaranteed against Anthropic’s first-party service. Test tool calls, reasoning preservation, and compaction before using this route on unattended work.

### OpenCode

OpenCode is the best-evidenced non-Z harness because Ox Alpha was deployed there and most independent coding comparisons used it. For long-thinking local or OpenAI-compatible routes, the reported workaround is:

```bash
export OPENCODE_EXPERIMENTAL_OUTPUT_TOKEN_MAX=128000
```

This is `[UNOFFICIAL, DEMONSTRATED]`, not an OpenCode contract. ([DGX Spark recipe](https://github.com/alexellis/glm-5.3-flash-4x-dgx-spark-switchless/blob/master/docs/recipe.md))

### Codex CLI

OpenRouter documents Codex CLI through a custom OpenAI-compatible provider at `https://openrouter.ai/api/v1`. A Flash-specific, official Codex CLI compatibility result was **NOT FOUND**. Given your table, keep Sol in Codex CLI and run Flash through OpenCode or Z.ai’s Claude Code endpoint unless your own smoke suite passes.

### Cline, Roo, Kilo, claude-code-router

Credible Flash-specific issue reports in those repositories were **NOT FOUND** by 2026-09-02. Generic OpenAI or Anthropic compatibility is not proof of correct reasoning-block and tool-call behavior. Run a five-case gate:

1. Read file.
2. Edit file.
3. Parallel tool call.
4. Tool error and recovery.
5. 20K-plus context continuation with preserved reasoning.

## Local deployment

| Hardware and quant | Demonstrated result |
|---|---|
| Official FP8 | NVIDIA recommends 4x GB200 or 8x H200 for aggregated serving; BF16 KV; 1,048,576 context |
| 4x DGX Spark, NVFP4 | About 182 GiB weights, 262K configured context, 48 to 51 tokens/s code decode, up to 72 warm, about 1,800 tokens/s prefill |
| 2x DGX Spark, NVFP4 | Serving and tool calling demonstrated at 262K, but required seven day-zero fixes |
| 256GB M3 Ultra, MLX 4-bit | 165.4GB active memory and 29.2 tokens/s reported |
| 128GB M5 Max, MLX 2-bit | Booted after a custom model-mapping patch; reliable text-published tokens/s **NOT FOUND** |
| M5 Ultra 512GB projections | 4-bit and 8-bit estimates exist, but the cited machine was not yet available; calculated, not demonstrated |

The first-party FP8 checkpoint is roughly 331GB. Community NVFP4 packages are roughly 182GB. BF16 is roughly 640GB before runtime overhead.

A vLLM issue reported recurrent illegal-memory-access crashes on 4x B200, while the DGX reports required custom patches. Local deployment is viable, but still early-adopter infrastructure.

Community “uncensored”, abliterated, FP8, NVFP4, W4A16, GGUF, and MLX derivatives already exist, including OrcaRouter and dealignai variants. Note only: these are not Z.ai releases, have no comparable safety or regression guarantee, and should not enter a trusted security or production-code lane without independent evaluation.

# 5. Routing verdict and max-out configuration

## Recommended table position

| Lane | Model | Route to it | Do not route |
|---|---|---|---|
| Orchestration | Fable 5.1 | Task decomposition, requirements, delegation, acceptance criteria | Bulk rote implementation |
| Premium execution | GPT-5.6 Sol via Codex | High-blast-radius changes, architectural refactors, final fixes, security-sensitive implementation | Cheap background sweeps |
| Cheap multimodal worker | **GLM-5.3-Flash** | Repo maps, scaffolding, docs, tests, migrations, visual inspection, long-context triage, parallel review | Strict-schema pipelines, sole security signoff, subtle unsafe-language work |
| Cheap fast implementer | DeepSeek V4 Pro 0813 | Terminal-heavy iterations, correction loops, rapid patch-test cycles | Visual work |
| Deep open-weight escalation | Full GLM-5.3 | Harder open-weight coding or security second opinion | Routine work where Flash suffices |
| Video specialist | Gemini 3.7 Flash | Long video, audio-video timelines, primary multimodal analysis | Pure code tasks where its harness is weaker |

GLM-5.3-Flash should replace full GLM-5.3 for most bulk work. Escalate to full GLM only after Flash fails a bounded retry or when deeper reasoning is worth about 9x the token price.

It should not replace Gemini as your primary video model yet. Z.ai’s own visual table shows Gemini 3.7 Flash ahead on BabyVision, MVBench, and MMVU. Flash is valuable where visual input must immediately feed a coding or tool loop.

For security, use Flash as a cheap dissenting reviewer, never as the only reviewer. There is no Flash ExploitBench evidence, and the black-box testing found politically concentrated filtering.

## Cost per completed task

There is no universal controlled “completed Claude Code task” dataset covering all three models.

Best available proxies:

| Proxy | Flash | Terra | Luna |
|---|---:|---:|---:|
| LiveBench cost per successful task | $0.031 | NOT FOUND | $0.169 |
| Agent Arena median cost per task | $0.12 | $0.39 | $0.08 |
| AI Coding Daily average prompt cost | $0.02 | $0.20 to $0.36 | $0.04 to $0.10 |
| AI Coding Daily score / 40 | 20.01 | 25.21 to 25.65 | 24.86 to 28.22 |

Flash is cheaper per successful LiveBench task and per AI Coding Daily attempt, but Luna is cheaper per observed Agent Arena task because it produces far fewer output tokens. Therefore:

- Flash beats Terra economically for most bounded worker tasks.
- Flash does **not** automatically beat Luna on completed-task cost.
- Route on accepted PRs per dollar, not list token price.
- Add a stop condition such as two failed test-repair cycles or 40K generated tokens, then escalate to Sol.

## Exact max-quality Z.ai request

```json
{
  "model": "glm-5.3-flash",
  "messages": [],
  "temperature": 1.0,
  "top_p": 0.95,
  "max_tokens": 131072,
  "stream": true,
  "reasoning_effort": "max",
  "thinking": {
    "type": "enabled",
    "clear_thinking": false
  },
  "tool_stream": true,
  "tools": [],
  "tool_choice": "auto"
}
```

For stateless chat, change `clear_thinking` to `true`. For coding, keep it false and replay every returned `reasoning_content` block unchanged.

## Exact max-quality OpenRouter request

```json
{
  "model": "z-ai/glm-5.3-flash",
  "messages": [],
  "temperature": 1.0,
  "top_p": 0.95,
  "max_tokens": 131072,
  "stream": true,
  "reasoning": {
    "effort": "max",
    "exclude": false
  },
  "tools": [],
  "tool_choice": "auto",
  "provider": {
    "sort": "throughput",
    "quantizations": ["fp8"],
    "require_parameters": true,
    "allow_fallbacks": true,
    "max_price": {
      "prompt": 0.15,
      "completion": 0.50
    }
  }
}
```

Preserve OpenRouter’s returned `reasoning_details` unchanged across tool turns.

Useful variations:

- Promo-only ceiling through September 9: set `prompt: 0.075`, `completion: 0.25`.
- Cost-first: change `sort` to `"price"`.
- Reproducible evals: pin one provider with `order` or `only`; do not permit arbitrary fallback.
- Private code: add `"zdr": true` or `"data_collection": "deny"`, then confirm that enough providers remain.
- Production default: change effort from `max` to `high`.
- Terminal-Bench reproduction: temperature 1, top-p 1, max tokens 65,536, max effort.

My practical policy would be:

```text
low   = summaries, classification, tiny edits, rote file transforms
high  = default coding worker, tests, refactors, repo review
max   = ambiguous debugging, long-context synthesis, second-opinion audit
Sol   = failed Flash retry, high-blast-radius merge, final security judgment
```

# Full source list

## Official and platform-owner sources

- `[OFFICIAL, ASSERTED]` [Z.ai release post](https://z.ai/blog/glm-5.3-flash), 2026-08-26.
- `[OFFICIAL, ASSERTED]` [Z.ai AutoClaw technical summary](https://autoclaw.z.ai/blog/model/glm-5.3-flash/), 2026-09-02.
- `[OFFICIAL, DEMONSTRATED]` [Z.ai GLM-5.3-Flash documentation](https://docs.z.ai/guides/vlm/glm-5.3-flash), accessed 2026-09-02.
- `[OFFICIAL, DEMONSTRATED]` [Hugging Face model card](https://huggingface.co/zai-org/GLM-5.3-Flash), accessed 2026-09-02.
- `[OFFICIAL, DEMONSTRATED]` [Hugging Face configuration](https://huggingface.co/zai-org/GLM-5.3-Flash/blob/main/config.json), accessed 2026-09-02.
- `[OFFICIAL, DEMONSTRATED]` [Hugging Face generation defaults](https://huggingface.co/zai-org/GLM-5.3-Flash/blob/main/generation_config.json), accessed 2026-09-02.
- `[OFFICIAL, DEMONSTRATED]` [Z.ai pricing](https://docs.z.ai/guides/overview/pricing), accessed 2026-09-02.
- `[OFFICIAL, DEMONSTRATED]` [Z.ai thinking mode](https://docs.z.ai/guides/capabilities/thinking-mode), accessed 2026-09-02.
- `[OFFICIAL, DEMONSTRATED]` [Z.ai structured output](https://docs.z.ai/guides/capabilities/struct-output), accessed 2026-09-02.
- `[OFFICIAL, DEMONSTRATED]` [Z.ai function calling](https://docs.z.ai/guides/capabilities/function-calling), accessed 2026-09-02.
- `[OFFICIAL, DEMONSTRATED]` [OpenRouter standard model page](https://openrouter.ai/z-ai/glm-5.3-flash), accessed 2026-09-02.
- `[OFFICIAL, DEMONSTRATED]` [OpenRouter batch page](https://openrouter.ai/z-ai/glm-5.3-flash%3Abatch), accessed 2026-09-02.
- `[OFFICIAL, DEMONSTRATED]` [OpenRouter live model catalog](https://openrouter.ai/api/v1/models), accessed 2026-09-02.
- `[OFFICIAL, DEMONSTRATED]` [OpenRouter reasoning controls](https://openrouter.ai/docs/guides/best-practices/reasoning-tokens), accessed 2026-09-02.
- `[OFFICIAL, DEMONSTRATED]` [OpenRouter provider routing](https://openrouter.ai/docs/guides/routing/provider-selection), accessed 2026-09-02.
- `[OFFICIAL, DEMONSTRATED]` [Z.ai Claude Code integration](https://docs.z.ai/devpack/tool/claude), accessed 2026-09-02.
- `[OFFICIAL, DEMONSTRATED]` [ZCode model and plan configuration](https://zcode.z.ai/en/docs/configuration), accessed 2026-09-02.
- `[OFFICIAL, DEMONSTRATED]` [ZCode quota reset documentation](https://zcode.z.ai/en/docs/usage-stats), accessed 2026-09-02.
- `[OFFICIAL, DEMONSTRATED]` [ZCode changelog](https://zcode.z.ai/en/changelog), accessed 2026-09-02.
- `[OFFICIAL, ASSERTED, DIRECT PAGE BLOCKED]` [Z.ai anniversary announcement on X](https://x.com/Zai_org/status/2094769612730532172), 2026-09-01.
- `[OFFICIAL, DEMONSTRATED]` [NVIDIA Dynamo deployment recipe](https://docs.nvidia.com/dynamo/dev/recipes/glm-5-3-flash), accessed 2026-09-02.

## Independent and community sources

- `[UNOFFICIAL/INDEPENDENT, DEMONSTRATED]` [Artificial Analysis](https://artificialanalysis.ai/models/glm-5-3-flash/), accessed 2026-09-02.
- `[UNOFFICIAL/INDEPENDENT, DEMONSTRATED]` [LiveBench leaderboard](https://livebench.ai/), 2026-06-25 task snapshot, accessed 2026-09-02.
- `[UNOFFICIAL/INDEPENDENT, DEMONSTRATED]` [LiveBench methodology repository](https://github.com/LiveBench/new-livebench), accessed 2026-09-02.
- `[UNOFFICIAL/INDEPENDENT, DEMONSTRATED]` [Agent Arena](https://arena.ai/leaderboard/agent), 2026-09-01 snapshot.
- `[UNOFFICIAL/INDEPENDENT, DEMONSTRATED]` [AI Coding Daily](https://aicodingdaily.com/leaderboard), Flash added 2026-08-27, accessed 2026-09-02.
- `[UNOFFICIAL, DEMONSTRATED]` [CTGT Ox Alpha fingerprinting](https://www.ctgt.ai/research/behaviorally-fingerprinting-ox-alphas-provenance), 2026-08-24.
- `[UNOFFICIAL, DEMONSTRATED]` [Ox Alpha evidence repository](https://github.com/LuD1161/ox-alpha-identification-public), investigation dated 2026-08-21, accessed 2026-09-02.
- `[UNOFFICIAL, DEMONSTRATED]` [Aseem Shrey investigation](https://aseemshrey.com/blog/unmasking-ox-alpha/), 2026-08-21.
- `[UNOFFICIAL, DEMONSTRATED]` [Flash JSON-mode issue 133](https://github.com/zai-org/GLM-5/issues/133), opened 2026-08-27.
- `[UNOFFICIAL, DEMONSTRATED]` [Full GLM-5.3 MCP and structured-output test](https://mcpplaygroundonline.com/blog/glm-5-3-mcp-servers), 2026-08-26.
- `[UNOFFICIAL, ANECDOTAL]` [Ox Alpha long-run discussion](https://www.reddit.com/r/opencode/comments/1vvx2cj/try_ox_alpha_its_great/), approximately 2026-08-23.
- `[UNOFFICIAL, ANECDOTAL]` [Ox Alpha versus DeepSeek discussion](https://www.reddit.com/r/opencode/comments/1vve6dq/ox_alpha_is_better_than_dsv4f/), approximately 2026-08-22.
- `[UNOFFICIAL, ANECDOTAL]` [Ox Alpha community impressions](https://www.reddit.com/r/opencode/comments/1vwlbr0/what_does_everyone_think_of_ox_alpha/), approximately 2026-08-23.
- `[UNOFFICIAL, DEMONSTRATED]` [Four-DGX-Spark deployment recipe](https://github.com/alexellis/glm-5.3-flash-4x-dgx-spark-switchless/blob/master/docs/recipe.md), accessed 2026-09-02.
- `[UNOFFICIAL, DEMONSTRATED]` [Two-DGX-Spark deployment report](https://github.com/tonyd2wild/GLM-5.3-Flash-NVFP4-DFlash2-2x-DGX-Spark/blob/main/docs/DEPLOY-REPORT.md), deployment dated 2026-08-26.
- `[UNOFFICIAL, DEMONSTRATED]` [vLLM crash report](https://github.com/vllm-project/vllm/issues/54317), accessed 2026-09-02.
- `[UNOFFICIAL, DEMONSTRATED]` [rapidMLX 256GB Mac measurement](https://rapidmlx.com/changelog/0.13.3), 2026-09-01.
- `[UNOFFICIAL, COMMUNITY DERIVATIVE]` [Uncensored W4A16 variant](https://huggingface.co/AIAgens/GLM-5.3-Flash-UNCENSORED-W4A16), accessed 2026-09-02.
- `[UNOFFICIAL, CORROBORATION]` [Anniversary reset report](https://runtimewire.com/article/zai-glm-coding-plan-anniversary-reset-card), 2026-09-01.