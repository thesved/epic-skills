# Model-cache delta brief

Cutoff: 2026-09-02, inclusive. Only changes effective or announced from 2026-08-21 through 2026-09-02 are treated as deltas.

Price notation is `input / cached-input / output` per 1M tokens unless another unit is shown. `N/P` means not published. Native CNY pricing is retained rather than converted.

## Frontloaded delta table

| Provider | Item | Status | Date | Exact ID | Price | Context / max output | Routing-table change |
|---|---|---:|---:|---|---|---|---|
| OpenAI | Sol price reduction | OFFICIAL, GA | 2026-08-21 | `gpt-5.6-sol`, alias `gpt-5.6` | $4 / $0.40 / $20, previously $5 / N/P / $30 | 1.05M / 128K | Update cost weights. Prompts above 272K receive higher long-context pricing. |
| OpenAI | Regional processing per request | OFFICIAL, GA | 2026-08-21 | Domain-level routing, not a model ID | No model-price change | Unchanged | Add regional endpoint/domain selection where residency matters. |
| OpenAI | Audio-model deprecations announced | OFFICIAL, deprecated | 2026-08-26 | `whisper-1`, `gpt-4o-transcribe`, `gpt-4o-mini-transcribe`, `gpt-4o-transcribe-diarize` | No price delta announced | Model-specific | Migrate to `gpt-live-transcribe` or `gpt-transcribe` before 2027-02-26. |
| OpenAI | Assistants API retirement | OFFICIAL, retired | 2026-08-26 | Assistants API | N/A | N/A | Remove Assistants routes. Use Responses plus Conversations. |
| OpenAI | mTLS and X.509 workload identity federation | OFFICIAL, GA | 2026-08-29 | Platform feature | No price change | N/A | Authentication/configuration delta only. |
| OpenAI Codex | GPT-5.4 removed for ChatGPT-login users | OFFICIAL, effective retirement | 2026-08-31 | `gpt-5.4`, `gpt-5.4-mini` | API prices unchanged | API access remains | Delete these from ChatGPT-login Codex routes. They remain usable with API-key billing. Prefer Terra/Luna. |
| Google | Gemini 3.5 Transcribe | OFFICIAL, GA | 2026-08-26 | `gemini-3.5-transcribe` | $2 audio input / no cache / $12 text output, about $0.005/min blended | Up to 60 min; 30 min with diarization or timestamps; token limits N/P | Add batch/unary transcription route. |
| Google | Gemini 3.5 Transcribe Live | OFFICIAL, GA | 2026-08-26 | `gemini-3.5-transcribe-live` | $3.50 audio input / no cache / $21 text output, about $0.009/min blended | Live WebSocket session limits; conventional token maximum N/P | Add streaming transcription route. |
| Google | Gemini Omni 1.1 Flash | OFFICIAL, GA | 2026-08-27 | `gemini-omni-1.1-flash` | $1.50 input / no cache listed / $9 text output; video output $17.50/M tokens, about $0.10/sec at 720p | 1,048,576 input; 3 to 10 sec video, up to 4K | Add as video generation/editing route, not as a general chat model. |
| Google | Omni preview retirement scheduled | OFFICIAL, deprecated | 2026-08-27 | `gemini-omni-flash-preview` | N/A | N/A | Replace with `gemini-omni-1.1-flash`; shutdown 2026-09-30. |
| Google | Agentic video understanding | OFFICIAL, feature preview | 2026-09-01 | `gemini-3.7-flash`, `gemini-3.6-flash`, `gemini-3.5-flash-lite` with `processing: "agentic"` | No feature fee; normal base-model token prices | Base-model limits unchanged | Add a capability flag, not a new model route. Available in Interactions and GenerateContent APIs. |
| Google | Robotics ER 1.6 retired | OFFICIAL, retired | 2026-08-31 | `gemini-robotics-er-1.6-preview` | N/A | N/A | Remove route; migrate to Robotics ER 2 preview. |
| xAI | Imagine Image 2.0 default and editing changes | OFFICIAL, GA update | 2026-08-28 | `grok-imagine-image-2.0` | Input image $0.01; output: 1K low $0.04, 2K low $0.06, 1K medium $0.06, 2K medium $0.08 | Up to 5 source images; non-token output | Default `quality` changes from `medium` to `auto`. Auto currently chooses low for generation and medium for editing. Pin quality for reproducibility. |
| xAI | Grok Bot plan expansion | OFFICIAL, plan change | 2026-08-26 | Grok Bot | Subscription entitlement | N/A | Availability expanded to SuperGrok and specified Cursor paid/team plans, with separate usage accounting. |
| DeepSeek | Experimental vision model and Files/Responses support | OFFICIAL, experimental | 2026-08-21 | `deepseek-v4-flash-vision-exp` | $0 during experimental availability | 1M / 384K; up to 384 image tokens per image | Add opt-in experimental multimodal route. Do not replace pinned `DeepSeek-V4-Flash-0731`. |
| Zhipu/Z.AI | GLM 5.3 weights released | OFFICIAL, open weights | 2026-08-28 | `zai-org/GLM-5.3`; API `glm-5.3` | API $1.40 / $0.26 / $4.40 | 1M / 128K | The promised weights actually shipped. Self-hosting becomes a real route option. |
| Zhipu/Z.AI | GLM 5.3 Flash | OFFICIAL, released | 2026-09-02 | `glm-5.3-flash`; weights `zai-org/GLM-5.3-Flash` | Launch promo $0.075 / $0.015 / $0.25 through 2026-09-09 24:00 UTC+8; list $0.15 / $0.03 / $0.50 | 1M / 128K | Add low-cost multimodal route. Always-reasoning model; 320B total, 18B active. |
| Alibaba/Qwen | Qwen 3.8 Flash | OFFICIAL, released | 2026-08-26 | `qwen3.8-flash` | Global: CNY0.80 / CNY0.10 / CNY2.70; explicit cache creation CNY1.00 | 1M / 131,072; CoT up to 262,144 | Add fast multimodal route. Global rate limit 30K RPM and 5M TPM. |
| Alibaba/Qwen | Qwen MT Image 2.0 | OFFICIAL, released | 2026-08-28 | `qwen-mt-image-2.0` | CNY0.004/image in China, CNY0.004375/image in Singapore | Non-token image output | Add image-translation route. Official pages conflict on whether support is 11 or 55 languages, so do not encode that claim as settled. |
| Alibaba/Qwen | Qwen Flash Character global availability | OFFICIAL, regional expansion | 2026-08-30 | `qwen-flash-character` | CNY0.25 / cache price N/P / CNY1.50 | 32,768 / 32,768, default output 4,096 | Add US/global region route. Not a new model ID. |
| Alibaba/Qwen | Qwen 3.8 Max dated snapshot | OFFICIAL, released | 2026-09-02 | `qwen3.8-max-0902`, alias `qwen3.8-max-2026-09-02` | Global: CNY12 / CNY1.50 / CNY36; explicit cache create/read CNY15/CNY1 | 1M / 131,072 | Add pinned reproducible snapshot. Its global snapshot TPM limit is 150K, much lower than the floating Max alias. |
| Anthropic | Claude Mythos 5.1 | OFFICIAL, restricted preview | 2026-09-01 | Public API ID N/P | Starts at $10 / cache N/P / $50 | Context and output limits N/P | Do not expose as a normal public route. Limited to vetted US cyberdefense and life-science users; 30-day retention required. Fable 5.1 omitted as requested. |
| Mistral | OCR 4.1 reaches GA | OFFICIAL, GA | 2026-08-31 | `mistral-ocr-4-1`; aliases `mistral-ocr-latest`, `mistral-ocr-4` | $4/1,000 pages; Document AI $5/1,000 annotated pages | Page-based, not token-context based | Status change only if already following the aliases. Pin the dated ID for reproducibility. |
| OpenAI Codex CLI | Stable releases | OFFICIAL | 2026-08-24 to 2026-09-01 | `0.149.1`, `0.150.0`, `0.150.1`, `0.151.0`, `0.152.0`, `0.152.1` | N/A | N/A | Upgrade for task mentions, MCP/plugin handling, credential refresh, rate-limit banners, long shell timeout, and Guardian fix. `0.153.0-alpha.5` appeared 2026-09-02 as prerelease. |
| Gemini CLI | Stable releases | OFFICIAL | 2026-08-25 and 2026-09-01 | `0.57.0`, `0.58.0` | N/A | N/A | Upgrade for capacity retries, transactional cancellation rollback, policy checkers, macOS Seatbelt hardening, and A2A cancellation fixes. |
| OpenCode | Stable releases | OFFICIAL | 2026-08-21 to 2026-09-01 | `1.18.20` through `1.18.26` | N/A | N/A | Important provider-adapter fixes for xAI, Vertex regional routing, Anthropic slugs, Cloudflare gateways, Bedrock caching, Azure auth, and GPT-5.6 reasoning settings. |
| Cursor | Cloud-agent release | OFFICIAL | 2026-08-27 | Cursor product release | Plan-dependent | N/A | Adds repo-less Cloud Agents, Cursor Origin repositories, browser live preview/port forwarding, and Vercel publishing. No model-cache ID change. |

## Required checks with no qualifying delta

| Check | Finding |
|---|---|
| OpenAI GPT-6 | **NOT FOUND** on OpenAI Index, API models, API changelog, or Codex changelog by the cutoff. No public model ID, preview, price, or limits. |
| OpenAI “Astra” | **NOT FOUND as a released/public API model.** OpenAI had acknowledged Astra-related internal/upcoming work before the window, but not a GPT-6 release or route. |
| OpenAI “Bel” | **UNOFFICIAL RUMOR. NOT FOUND** on any official OpenAI page. The Aug 25 social-media claim about a more than 10T-parameter pretraining run is unverified. |
| GPT-5.6 snapshot change | **NOT FOUND.** Official pages expose floating IDs `gpt-5.6-sol`, `gpt-5.6-terra`, and `gpt-5.6-luna`, without a new dated snapshot in this window. |
| Sol Ultrafast GA | **NOT FOUND.** It remained a limited preview for selected customers. The 750 tokens/sec and up-to-14x figures are OpenAI claims, not independent measurements. |
| Gemini 3.8 Flash | **NOT FOUND.** The 2026-09-02 YouTube title is not corroborated by the Gemini API changelog, Google AI blog, or official model catalog. No `gemini-3.8-flash` ID exists there. |
| Gemini 3.5 Pro or 3.7 Pro | **NOT FOUND.** `gemini-3.1-pro-preview` remains the official Pro route. |
| “Gemini Omni 1.1” as a chat model | False interpretation. The real `gemini-omni-1.1-flash` release is a video generation/editing model. |
| Nano Banana, image model, Veo, TTS, Live API | No separate qualifying model or price change in the window, apart from Gemini Transcribe Live and Omni 1.1. |
| Grok 4.7 | **NOT FOUND** in xAI models or release notes. |
| Grok 4.6 snapshot or price change | **NOT FOUND.** Current `grok-4.6` remains $2 / $0.50 / $6 below 200K prompt tokens and $4 / $1 / $12 at or above 200K, with 500K context. |
| Grok Code | No new model in the window. Current route remains `grok-build-0.1`, with aliases including `grok-code-fast-1-0825`; 256K context. |
| DeepSeek V4.x or V5 after the baseline | **NOT FOUND.** Stable snapshots remain `DeepSeek-V4-Flash-0731` and `DeepSeek-V4-Pro-0813`. |
| Qwen 4 | **NOT FOUND** on Alibaba Model Studio lifecycle or model pages. |
| Kimi K3.x | **NOT FOUND.** Moonshot still presents Kimi K3 as its current release. |
| Meta | No new official model, dated snapshot, retirement, token price, or rate-plan delta in the window. |
| OpenRouter Gemini promo ending Aug 27 | **Refuted.** OpenRouter still showed the 50 percent price, $0.75 input and $3.75 output, at the cutoff. |
| OpenRouter new policy | No policy with a provable Aug 21 to Sep 2 effective date. The revised BYOK page says only “August 2026,” without a day, so it is excluded from the delta. |

## Provider detail and evidence quality

### OpenAI

The actionable model change is the Sol price cut. The official card still gives `gpt-5.6-sol` a 1.05M context and 128K output limit. Prompts above 272K are billed at 2x input and 1.5x output, and cache writes cost 1.25x normal input. The promotional price is promised through at least 2026-11-21. [Sol model card](https://developers.openai.com/api/docs/models/gpt-5.6-sol), [API changelog](https://developers.openai.com/api/docs/changelog).

The 2026-08-31 GPT-5.4 change is specifically about Codex when authenticated with a ChatGPT account. It is not an API model retirement. API-key users can continue routing to GPT-5.4. [Codex changelog](https://learn.chatgpt.com/docs/changelog).

GPT-6, Bel, and a public Astra model remain unsupported by official evidence. Searching the [OpenAI Index](https://openai.com/index/), [API model catalog](https://developers.openai.com/api/docs/models), API changelog, and Codex changelog yielded no public GPT-6 ID. Ultrafast also remains a selective preview. [Ultrafast announcement](https://openai.com/index/previewing-ultrafast/).

### Google

Gemini Omni 1.1 Flash is the biggest classification trap. It belongs in the video-generation lane. It supports extension, first-and-last-frame interpolation, editing, and resolution selection, but it is not a replacement for Gemini Flash text routing. [Gemini API changelog](https://ai.google.dev/gemini-api/docs/changelog), [Omni documentation](https://ai.google.dev/gemini-api/docs/video), [pricing](https://ai.google.dev/gemini-api/docs/pricing).

For agentic video understanding, Google claims up to 88 percent fewer video tokens, 66 percent lower cost, and 7 percent higher accuracy. Those are vendor measurements. I found no independent reproduction published by the cutoff, so they should not change quality weights without local evaluation. [Google announcement](https://blog.google/innovation-and-ai/models-and-research/gemini-models/introducing-agentic-video-in-gemini/).

The Gemini 3.8 Flash claim is not a release. The official changelog’s newest qualifying entry is the Sep 1 agentic-video feature.

### xAI

There is no Grok text-model delta. The current official catalog still identifies `grok-4.6` as the flagship, with 500K context and a two-tier long-context tariff. `grok-build-0.1` remains the coding route. [xAI models](https://docs.x.ai/developers/models), [pricing](https://docs.x.ai/developers/pricing).

The Image 2.0 default change can alter both cost and output consistency. A generation request that previously defaulted to medium now usually receives low quality under `auto`. Pin `quality: "medium"` if cache comparisons or image-quality thresholds assume the former behavior. [Release notes](https://docs.x.ai/developers/release-notes), [Image 2.0 model card](https://docs.x.ai/developers/models/grok-imagine-image-2.0).

### DeepSeek

The only new model is the free experimental vision route. It also brought new Responses, Messages, and Files API support plus DeepSeek Harness 0.1.1. [Aug 21 release](https://api-docs.deepseek.com/news/news260821/).

Stable time-variable prices remain:

- Off-peak: $0.007 cached, $0.22 cache miss, $0.66 output.
- Peak: $0.014 cached, $0.44 cache miss, $1.32 output.
- Peak periods: 01:00 to 04:00 and 06:00 to 10:00 UTC, Monday through Friday.

The vendor comparison to Anthropic models was not independently substantiated by the cutoff. [DeepSeek pricing](https://api-docs.deepseek.com/quick_start/pricing).

### Zhipu/Z.AI

GLM 5.3’s open weights were uploaded on Aug 28 under the custom GLM 5.3 license. [GLM 5.3 repository](https://huggingface.co/zai-org/GLM-5.3).

GLM 5.3 Flash has both first-party API and open-weight options. Its weights use an MIT license, while the API launch discount lasts only through Sep 9. In Z.AI’s Coding Plan it receives three times the quota of GLM 5.3, with half-point off-peak and weekend accounting. [Official launch](https://autoclaw.z.ai/blog/model/glm-5.3-flash/), [developer page](https://docs.z.ai/guides/vlm/glm-5.3-flash), [pricing](https://docs.z.ai/guides/overview/pricing), [weights](https://huggingface.co/zai-org/GLM-5.3-Flash).

Artificial Analysis independently measured GLM 5.3 Flash and assigned an Intelligence Index of 57, with roughly 42 to 49 output tokens/sec depending on endpoint conditions. That is independent evidence of service performance, but not a replication of Z.AI’s individual benchmark claims. [Artificial Analysis](https://artificialanalysis.ai/models/glm-5-3-flash).

### Alibaba/Qwen

`qwen3.8-max-0902` deserves a separate cache entry from the floating `qwen3.8-max` alias. Its 150K global TPM ceiling may matter more than its nominal model quality for high-throughput routing. [Qwen 3.8 Max](https://help.aliyun.com/en/model-studio/qwen3-8-max).

The Qwen 3.8 Flash and Max improvements are vendor claims. I found no independent Sep 2 evaluation of the dated Max snapshot by the cutoff. [Model lifecycle](https://help.aliyun.com/en/model-studio/newly-released-models), [Qwen 3.8 Flash](https://help.aliyun.com/en/model-studio/qwen3-8-flash), [Qwen MT Image 2.0](https://help.aliyun.com/en/model-studio/qwen-mt-image-2-0).

### Moonshot/Kimi

No Kimi K3.x snapshot, price change, retirement, or plan/rate-limit delta was found. Moonshot’s official site continued to present the July 16 Kimi K3 release with 1M context. [Moonshot AI](https://www.moonshot.ai/), [platform changelog](https://platform.kimi.ai/blog/posts/changelog).

### Anthropic

Fable 5.1 is intentionally omitted. Mythos 5.1 is included because it is a distinct restricted deployment and has routing implications for approved users. It uses the same underlying model family but reduced safeguards and a mandatory 30-day retention policy. It is not appropriate for a general public cache entry. [Claude Mythos 5.1](https://www.anthropic.com/claude/mythos).

No other model deprecation or retirement became effective in this window. [Anthropic model deprecations](https://docs.anthropic.com/en/docs/about-claude/model-deprecations).

### Mistral and Meta

Mistral’s only qualifying model-status change was OCR 4.1 reaching GA. Its aliases already pointed to 4.1, so floating-alias users need no change. [Mistral changelog](https://docs.mistral.ai/resources/changelogs), [Mistral API pricing](https://mistral.ai/pricing/api/).

Meta published no qualifying first-party model release in the window. [Meta AI blog](https://ai.meta.com/blog/).

### OpenRouter

The claimed 2026-08-27 Gemini 3.7 Flash promo expiry is not supported. At the cutoff, OpenRouter still displayed:

- Input: $0.75/M
- Cache read: $0.075/M
- Cache write: $0.04167/M as listed by OpenRouter
- Output: $3.75/M
- Context: 1,048,576
- Maximum output: 65,536

[OpenRouter Gemini 3.7 Flash](https://openrouter.ai/google/gemini-3.7-flash).

OpenRouter’s dated announcement feed contains an Aug 21 image-benchmark update, but no routing-policy change. The BYOK policy page’s month-only timestamp is insufficient to assign it to this exact window. Its current terms show 5 percent BYOK fees after the plan allowance and a 5.5 percent credit-purchase fee, but I have excluded those from the delta table. [Announcements](https://openrouter.ai/blog/announcements/), [BYOK announcement](https://openrouter.ai/blog/announcements/1-million-free-byok-requests-per-month/), [current pricing](https://openrouter.ai/pricing).

## Dated source list

- OpenAI: [API changelog](https://developers.openai.com/api/docs/changelog), entries dated 2026-08-21, 2026-08-26, and 2026-08-29.
- OpenAI: [Codex changelog](https://learn.chatgpt.com/docs/changelog), GPT-5.4 removal effective 2026-08-31.
- OpenAI: [Codex CLI releases](https://github.com/openai/codex/releases), releases dated 2026-08-24 through 2026-09-02.
- Google: [Gemini API changelog](https://ai.google.dev/gemini-api/docs/changelog), entries dated 2026-08-26, 2026-08-27, 2026-08-31, and 2026-09-01.
- Google: [Agentic video announcement](https://blog.google/innovation-and-ai/models-and-research/gemini-models/introducing-agentic-video-in-gemini/), 2026-09-01.
- Google: [Gemini CLI 0.57.0](https://github.com/google-gemini/gemini-cli/releases/tag/v0.57.0), 2026-08-25; [0.58.0](https://github.com/google-gemini/gemini-cli/releases/tag/v0.58.0), 2026-09-01.
- xAI: [Release notes](https://docs.x.ai/developers/release-notes), Imagine update dated 2026-08-28.
- xAI: [Grok Bot plan announcement](https://x.ai/news/grok-bot-more-plans), page dated 2026-08-26.
- DeepSeek: [Vision experiment announcement](https://api-docs.deepseek.com/news/news260821/), 2026-08-21.
- Z.AI: [GLM 5.3 weights](https://huggingface.co/zai-org/GLM-5.3), initial release 2026-08-28.
- Z.AI: [GLM 5.3 Flash announcement](https://autoclaw.z.ai/blog/model/glm-5.3-flash/), 2026-09-02.
- Alibaba: [Model Studio lifecycle](https://help.aliyun.com/en/model-studio/newly-released-models), entries dated 2026-08-26, 2026-08-28, 2026-08-30, and 2026-09-02.
- Anthropic: [Claude Mythos 5.1](https://www.anthropic.com/claude/mythos), 2026-09-01.
- Mistral: [Model changelog](https://docs.mistral.ai/resources/changelogs), OCR 4.1 GA dated 2026-08-31.
- OpenRouter: [Announcement archive](https://openrouter.ai/blog/announcements/), checked through 2026-09-02.
- OpenCode: [GitHub releases](https://github.com/anomalyco/opencode/releases), versions 1.18.20 through 1.18.26 dated 2026-08-21 through 2026-09-01.
- Cursor: [Changelog](https://cursor.com/en-US/changelog), Cloud Agents entry dated 2026-08-27.