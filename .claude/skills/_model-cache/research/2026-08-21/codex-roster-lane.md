# Routing-table delta brief

Cutoff: changes or newly confirmed facts from 2026-08-10 through 2026-08-21. Prices are USD per 1 million tokens unless stated otherwise.

## Max-out settings for new entrants

| Model | Production ID | Maximum reasoning configuration | Context / max output |
|---|---|---|---|
| Gemini 3.7 Flash | `gemini-3.7-flash` | `thinkingLevel: "HIGH"` in `generateContent`, or `thinking_level: "high"` in Interactions API | 1,048,576 / 65,536 |
| GLM-5.3 | `glm-5.3` | `thinking.type: "enabled"` plus `reasoning_effort: "max"` | 1,000,000 reported |
| Qwen3.8-27B | `qwen/qwen3.8-27b` on OpenRouter | `enable_thinking: true`, `reasoning_effort: "xhigh"`; temperature 1.0, top-p 0.95, top-k 20, min-p 0, presence penalty 0, repetition penalty 1 | 262,144 |
| Qwen3.8-2.4T-A95B | `Qwen/Qwen3.8-2.4T-A95B` checkpoint | Thinking required; highest available reasoning effort | 262,144 native, approximately 1,010,000 with extension / 131,072 reported |
| Grok 4.6 | `grok-4-6` | `reasoning_effort: "xhigh"` where supported | 500,000 |

## 1. Gemini 3.7 Flash

- Released GA 2026-08-13 as exactly `gemini-3.7-flash`. No dated snapshot ID appears in the public model catalog. It accepts text, images, video, audio, and PDF; emits text. Context is exactly 1,048,576 input and 65,536 output tokens. [Google release notes, 2026-08-13](https://ai.google.dev/gemini-api/docs/changelog), [model page, updated 2026-08-13](https://ai.google.dev/gemini-api/docs/models/gemini-3.7-flash).

- Thinking levels are `LOW`, `MEDIUM`, and `HIGH`; default is `MEDIUM`. `MINIMAL` is unsupported and returns an error. Gemini 3 uses `thinkingLevel` in `thinkingConfig`; the newer Interactions API spells it `thinking_level`. `thinking_budget` belongs to Gemini 2.5 and is not the 3.7 control. [Thinking documentation](https://ai.google.dev/gemini-api/docs/thinking), [latest-model migration guide](https://ai.google.dev/gemini-api/docs/latest-model).

- Migration warning: Google says to remove explicit `temperature`, `top_p`, `top_k`, and prefilled assistant turns for the newest Gemini models. Those controls can hurt performance even when accepted by a compatibility layer. [Google migration guide](https://ai.google.dev/gemini-api/docs/latest-model).

- Standard pricing through 2026-12-31 is $0.75 input, $3.75 output including thinking, $0.075 cache read, and $0.50 per million cached tokens per hour. From 2027-01-01: $1.50, $7.50, $0.15, and $1.00 respectively. Google shows no context-length price step above 200K. [Google pricing](https://ai.google.dev/gemini-api/docs/pricing).

- Batch and Flex each cost $0.375 input, $1.875 output, and $0.0375 cache read through 2026-12-31; then $0.75, $3.75, and $0.075. Priority is $1.35 input, $6.75 output, and $0.135 cache read; it doubles to $2.70, $13.50, and $0.27 on 2027-01-01. Cache-storage price is not discounted for Batch, Flex, or Priority. [Google pricing](https://ai.google.dev/gemini-api/docs/pricing).

- OpenRouter lists `google/gemini-3.7-flash` at promotional $0.375/$1.875. Its Batch route stacks another 50% discount, yielding $0.1875/$0.9375. The advertised promotion ends 2026-08-27, although the expiry was recoverable only through OpenRouter’s LinkedIn announcement as relayed by TipRanks. [OpenRouter model listing, checked 2026-08-21](https://openrouter.ai/google/), [TipRanks report, 2026-08-14](https://www.tipranks.com/news/private-companies/openrouter-highlights-discounted-access-to-google-deepmind-gemini-3-7-flash).

- Interactive RPM, TPM, and RPD are now account-specific and exposed in AI Studio rather than a stable public table. Public rolling ten-minute spend caps are Free: unavailable, Tier 1: $10, Tier 2: $50, Tier 3: $200. Batch permits 100 concurrent jobs, 2 GB per input file, and 20 GB file storage. The table exposes 3,000,000 enqueued tokens for 3.7 Flash at Tier 1 but no 3.7 row for Tiers 2 or 3. [Rate-limit page, updated 2026-08-18](https://ai.google.dev/gemini-api/docs/rate-limits).

- Structured outputs, function calling, code execution, context caching, file search, search and Maps grounding, URL context, and preview computer use are explicitly supported. [Model page](https://ai.google.dev/gemini-api/docs/models/gemini-3.7-flash).

- Independent/model-card results: Artificial Analysis Intelligence Index 56; DeepSWE 65.3%; AA reports average completion time of 1.7 minutes and approximately 40% lower latency than GPT-5.6 Terra max. Third-party reporting places output speed near 340.1 tokens/s. [DeepMind model card, 2026-08-13](https://deepmind.google/models/model-cards/gemini-3-7-flash/), [Artificial Analysis, 2026-08-13](https://artificialanalysis.ai/articles/gemini-3-7-time-frontier), [Unifically measurement report, 2026-08-18](https://unifically.com/blogs/gemini-3.7-flash-api).

- Gemini 3.5 Pro remained unreleased on 2026-08-13. Google declined to say whether it would ship, while reporting already pointed to Gemini 4 training. There is no official Gemini 3.7 Pro announcement. [Axios, 2026-08-13](https://www.axios.com/2026/08/13/google-gemini-37-flash), [Alphabet Q2 remarks](https://blog.google/company-news/inside-google/message-ceo/alphabet-earnings-q2-2026/).

## 2. GLM-5.3

- Z.ai launched GLM-5.3 on 2026-08-14. It uses the same base model as GLM-5.2; gains are from post-training. GLM-5’s disclosed architecture is 744B total parameters and 40B active, so the circulating 743B figure is incorrect. Open weights were deliberately delayed approximately two weeks, meaning GLM-5.3 was not yet an available open-weight model on 2026-08-21. [Z.ai GLM-5.3 announcement](https://z.ai/blog/glm-5.3), [GLM-5 architecture](https://z.ai/blog/glm-5).

- Reasoning cannot be disabled: `thinking.type` accepts `enabled`; `disabled` fails. `reasoning_effort` supports `low`, `high`, and `max`, with `max` the default and recommended coding setting. [Z.ai announcement, 2026-08-14](https://z.ai/blog/glm-5.3).

- Official vendor benchmark deltas versus GLM-5.2: TerminalBench 2.1, 88.2 versus 81.0; TerminalBench 3, 28.3 versus 4.6; DeepSWE, 66.9 versus 46.2; Automation, 48.2 versus 26.2. On the same table, Kimi K3 scores 88.3 and 67.5 on TerminalBench 2.1 and DeepSWE; DeepSeek V4 Pro 0813 scores 87.9 and 62.7; Qwen3.8-Max scores 86.6 and 56.6. [Z.ai benchmark table](https://z.ai/blog/glm-5.3).

- Artificial Analysis currently scores GLM-5.3 at 60, tied with Kimi K3 max and above Qwen3.8-2.4T-A95B at 58. This does not establish a universal winner: Kimi narrowly leads GLM on two prominent coding-agent tests, and GLM’s weights are not downloadable yet. [Artificial Analysis GLM-5.3](https://artificialanalysis.ai/models/glm-5-3), [Kimi provider results](https://artificialanalysis.ai/providers/kimi), [Qwen result](https://artificialanalysis.ai/models/qwen3-8-2-4t-a95b).

- Coding Plan rollout covers all users. Z.ai advertises a 1.5x quota increase through 2026-08-31 and a 50% points discount outside 14:00 to 18:00 UTC+8 on weekdays. [Z.ai announcement](https://z.ai/blog/glm-5.3).

- Gateway catalogs list `z-ai/glm-5.3`, 1,000,000 context, text-only, at $1.40 input and $4.40 output. Z.ai’s own public price table had not added GLM-5.3 by 2026-08-21, so this remains gateway-level confirmation rather than first-party API pricing. [ModelsAtlas live catalog](https://modelsatlas.com/models/z-ai/glm-5.3), [Requesty, 2026-08-18](https://www.requesty.ai/models/zai/glm-5.3), [Z.ai pricing page](https://docs.z.ai/guides/overview/pricing).

- Verdict: strongest current API-accessible open-weight candidate by composite score, tied with Kimi K3, but technically not an available open-weight release until Z.ai publishes the checkpoint. Do not automatically displace Kimi for coding routes.

## 3. Qwen3.8 family

- The new post-cutoff event was the 2026-08-12 weight release for `Qwen/Qwen3.8-2.4T-A95B`: 2.4T total and 95B active parameters. The checkpoint is text-only and thinking-required, unlike the hosted multimodal Qwen3.8-Max API. Native context is 262,144; documented extension is approximately 1,010,000. [NVIDIA, 2026-08-12](https://developer.nvidia.com/blog/serve-qwen3-8-2-4t-a95b-a-2-4t-parameter-model-with-configurable-reasoning-on-nvidia-gb300-nvl72/), [Alibaba announcement](https://www.alibabacloud.com/en/press-room/alibaba-unveils-qwen3-8-max).

- The 2.4T checkpoint is source-available under the custom `qwen3.8-max` license, not Apache 2.0 or an OSI-approved license. It includes attribution and large-scale MaaS restrictions, so label it “open weights,” not unqualified “open source.” [Qwen license](https://huggingface.co/Qwen/Qwen3.8-2.4T-A95B/blob/main/LICENSE).

- Qwen3.8-27B arrived 2026-08-14 as an Apache-2.0 dense multimodal model with 262,144 context. OpenRouter lists `qwen/qwen3.8-27b` at exactly $0.45 input and $3.20 output. [Official model card](https://huggingface.co/Qwen/Qwen3.8-27B-FP8), [OpenRouter listing](https://openrouter.ai/qwen).

- Official 27B thinking sampling: temperature 1.0, top-p 0.95, top-k 20, min-p 0, presence penalty 0, repetition penalty 1. Non-thinking: temperature 0.7, top-p 0.80, top-k 20, min-p 0, presence penalty 1.5, repetition penalty 1. Reasoning efforts are `low`, `medium`, and default `xhigh`; `enable_thinking=False` disables reasoning. [Qwen model card](https://huggingface.co/Qwen/Qwen3.8-27B-FP8).

- Vendor 27B results include TerminalBench 2.1 73.0, SWE-bench Pro 61.7, DeepSWE 42.2, QwenSWE 79.0, GPQA 89.2, and LiveCodeBench 90.3. Artificial Analysis subsequently reported an Intelligence Index of 52, with unusually high output-token consumption in its run. Treat route economics cautiously. [Qwen model card](https://huggingface.co/Qwen/Qwen3.8-27B-FP8), [independent result report, 2026-08-18](https://data-today.net/aidummies/aidummies-qwen-3-8-27b-benchmark-matches-gpt-5-6/).

- Bug reports: the initial chat template crashes when OpenAI-compatible tool arguments arrive as a JSON string rather than a mapping. A separate community evaluation reports that `reasoning_effort=low` may fail to cap thinking and can exhaust the output budget without producing a final answer. [Qwen issue 1894, 2026-08-14](https://github.com/QwenLM/Qwen3/issues/1894), [community benchmark repository](https://github.com/kr4ckhe4d/local-llm-benchmarks).

## 4. OpenAI and Codex

- OpenAI previewed GPT-5.6 Sol Ultrafast on Cerebras on 2026-08-13: up to 750 output tokens/s and up to 14x Standard speed. It remains a limited preview for selected customers; pricing was not published. [OpenAI, 2026-08-13](https://openai.com/index/previewing-ultrafast/).

- Codex CLI 0.148.0, released 2026-08-18, added `/export`, `codex exec fork`, archive/restore, startup prompt drafting, cost and credit estimates, built-in Bedrock Runtime routing for GPT-5.6, asynchronous MCP hooks, and sandbox fail-closed behavior. [Official release](https://github.com/openai/codex/releases/tag/rust-v0.148.0).

- OpenAI’s 2026-08-20 Codex rate card says GPT-5.4 and GPT-5.4 mini disappear from ChatGPT-authenticated Codex on 2026-08-31; API-key usage is unaffected. Suggested replacements are Terra and Luna. Token-credit rates: Sol 125 input, 12.5 cached input, 750 output; Terra 50, 5, 300; Luna 5, 0.5, 30 per million tokens. [OpenAI Help, updated 2026-08-20](https://help-lb.openai.com/en/articles/11481834).

- No verified API-dollar price change and no official product or release named “Codex 2.0” appeared during the window.

## 5. Anthropic

- No Opus 5, Fable 5, or Sonnet 5 model or price change was announced after 2026-08-10. Fable 5 remains $10 input and $50 output. [Anthropic newsroom, checked 2026-08-21](https://www.anthropic.com/news), [Fable 5 announcement and pricing](https://www.anthropic.com/news/claude-fable-5-mythos-5).

- Claude Code 2.1.229 on 2026-08-12 added server hooks for self-hosted runners, SSE keepalives during long Vertex and Bedrock thinking, plugin-marketplace command sources, and streaming fixes. 2.1.233 on 2026-08-15 added GitLab merge-request URLs in worktrees, `CLAUDE_CODE_TOOL_MEMORY_LIMIT`, WebFetch cache TTL, and MCPv2 reconnect fixes. 2.1.234 and 2.1.235 on 2026-08-18 and 2026-08-19 added `CLAUDE_CODE_PROJECT_DIR_NAME` and prompt-cache/TUI fixes. [Official changelog](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md).

- “Mythos 6” is unsubstantiated rumor. The actual reporting concerned possible Fable 5.1 testing and speculative internal names “Mythos 2” and “Mythos 3.” Anthropic separately described an unreleased internal “Model 2” in a safety report; that is not evidence of a customer model named Mythos 6. [Axios rumor report, 2026-08-19](https://www.axios.com/2026/08/19/ai-models-astra-mythos-release-rumors), [Axios safety report, 2026-08-14](https://www.axios.com/2026/08/14/anthropic-model-2-ai-risk).

## 6. xAI

- Grok 4.6 launched 2026-08-12, not merely as a pending model. It is available through xAI API, OpenRouter, Vercel, and Cloudflare. List price below 200K context is $2 input and $6 output. [xAI launch, 2026-08-12](https://x.ai/news/grok-4-6).

- Cache-read price is $0.50 below 200K, up from Grok 4.5’s $0.30, an exact increase of $0.20 or 66⅔%. Requests at or above 200K are $4 input, $1 cache read, and $12 output. [Current pricing summary](https://routerplex.com/blog/grok-4-6-api-pricing-setup), [xAI pricing documentation](https://docs.x.ai/developers/pricing).

- No official Grok 4.7 announcement exists as of 2026-08-21.

- X says Grok is available wherever X is available, covering EU consumer access. This does not prove EU API deployment, data residency, or uniform availability of Grok 4.6 in every EU endpoint. [X Help](https://help.x.com/en/using-x/about-grok).

## 7. Moonshot Kimi

- Moonshot’s 2026-08-12 pricing explainer confirmed unchanged Kimi K3 API rates: $0.30 cache hit, $3 uncached input, and $15 output. It also reconfirmed 2.8T parameters, vision, and 1M context. [Kimi pricing, 2026-08-12](https://www.kimi.ai/resources/kimi-k3-pricing), [Kimi K3 technical announcement](https://www.kimi.com/blog/kimi-k3).

- Artificial Analysis now scores Kimi K3 max at 60 and low at 48. Max ties GLM-5.3’s composite score; Kimi remains the safer presently downloadable open-weight leader while GLM-5.3 weights are delayed. [Artificial Analysis](https://artificialanalysis.ai/providers/kimi).

- No official model, checkpoint, or API alias named `k3-0.8` was found.

## 8. Cheap-tier candidates

- **LongCat-2.0:** list $0.75 uncached input, $0.015 cached, $2.95 output; limited promotion $0.30/$0.006/$1.20. Verdict: attractive cache-heavy agent route, but run tool-use regressions first. [Official pricing, checked 2026-08-21](https://longcat.chat/platform/docs/Pricing/LongCat-2.0.html).

- **dots3-note-preview:** weights released 2026-08-14; 280B total, 16B active, 512K context, text/vision/audio. Price: $0 for weights; no first-party hosted token price published. Verdict: evaluation or self-host candidate, not yet a dependable API-table entry. [RedNote announcement report, 2026-08-17](https://markets.financialcontent.com/stocks/article/accwirecq-2026-8-17-rednote-releases-first-open-weight-model-in-the-dots3-series-exploring-long-horizon-real-world-tasks).

- **Nemotron 3.5 Lightning 30B-A3B:** released 2026-08-11; 30B total, 3B active, 1M context; OpenRouter price reported at $0.10/$0.25. Verdict: strong cheap subagent, extraction, and router candidate. [Pricing catalog](https://tokenrate.dev/models/nemotron-3-5-lightning).

- **Muse Spark 1.2:** released before cutoff; Standard remains $1.25 input, $0.15 cache read, $4.25 output. Contributor pricing is $0.10/$0.002/$0.20 but authorizes Meta to use prompts and outputs. Verdict: Contributor only for non-sensitive traffic; Standard is no longer compelling beside Gemini’s promotion. [Vercel catalog](https://vercel.com/ai-gateway/models/muse-spark-1.2), [Contributor terms and exact rates](https://www.layer3labs.io/guides/muse-spark-1-2-pricing).

- **Muse Glimmer:** released 2026-08-10; Apache-2.0 30B model, 131K context, $0.35 input, $0.04 cache read, $1.50 output. Verdict: worthwhile small-model or self-host route, not a frontier coding replacement. [Vercel catalog](https://vercel.com/ai-gateway/models/muse-glimmer).

## Confidence and gaps

- Google has not publicly documented which exact model `gemini-flash-latest` currently resolves to. Community reports say 3.7 Flash, but this is not safe routing-table evidence.
- No reliable reproduction or first-party issue was found for Gemini PDF plus tool-calling failures, OpenRouter upstream idle timeouts, or generalized instruction drift and over-scoping.
- The approximately 340.1 tokens/s Gemini figure is third-party reporting, not a directly archived Artificial Analysis model page.
- OpenRouter’s 2026-08-27 Gemini promotion expiry was not available on a stable first-party documentation page.
- Gemini interactive RPM, TPM, and RPD numbers cannot be stated exactly because Google moved them to account-specific AI Studio views.
- No official Gemini 3.7 Pro status exists beyond the absence of an announcement.
- GLM-5.3’s $1.40/$4.40 price, 1M context, and text-only designation are gateway-catalog data, not yet present in Z.ai’s own price/spec table.
- `~z-ai/glm-latest` could not be verified as a real alias. The leading `~` may be erroneous.
- No public GLM-5.3 free API-tier allowance was found; Coding Plan promotions are verified, but they are not equivalent to a free API tier.
- Qwen’s `reasoning_effort=low` failure is a community bug report, not a confirmed framework-independent model defect.
- Grok 4.6 cache pricing and `xhigh` max-effort behavior were not both visible on the crawled first-party xAI pages; cache tiers and effort syntax rely partly on current integration documentation.
- EU consumer Grok availability is documented broadly; EU-specific Grok 4.6 API availability and residency are not.
- Grok 4.7, Kimi `k3-0.8`, “Codex 2.0,” and Anthropic “Mythos 6” have no verified official release evidence.
- dots3-note-preview has no verified hosted-token price.
- LongCat’s promotional end date was not published on the pricing page.
- Muse Spark Contributor cache price of $0.002 comes from a secondary integration guide because Vercel rounds its display.
