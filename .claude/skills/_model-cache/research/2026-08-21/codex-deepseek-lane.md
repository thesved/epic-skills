# DeepSeek API lineup brief

As of 2026-08-21. Prices are per 1 million tokens. OpenRouter provider data is live and can change without notice.

## Executive routing view

- **Routine coding, retrieval, parallel agents, high-volume workloads:** V4 Flash 0731, usually `high`.
- **Architecture, difficult debugging, code review, long-horizon agents:** V4 Pro 0813, usually `high`.
- **Use `max` selectively:** It improves hard-agent benchmarks but increases latency, token use, verbosity, and reported loop risk.
- **Direct API IDs are rolling aliases:** `deepseek-v4-pro` currently maps to Pro 0813; `deepseek-v4-flash` currently maps to Flash 0731.
- **OpenRouter snapshot IDs are safer for reproducibility:** `deepseek/deepseek-v4-pro-0813` and `deepseek/deepseek-v4-flash-0731`.
- **Important:** OpenRouter’s unsuffixed `deepseek/deepseek-v4-pro` and `deepseek/deepseek-v4-flash` pages still identify the April 0423 snapshots. They are not equivalent to the current direct aliases.

Sources: [DeepSeek pricing and model matrix, accessed 2026-08-21](https://api-docs.deepseek.com/quick_start/pricing/), [official V4 launch, 2026-04-24](https://api-docs.deepseek.com/news/news260424/), [OpenRouter Pro 0813, accessed 2026-08-21](https://openrouter.ai/deepseek/deepseek-v4-pro-0813), [OpenRouter Flash 0731](https://openrouter.ai/deepseek/deepseek-v4-flash-0731).

---

## 1. DeepSeek-V4-Pro-0813

### Identity and limits

- **Release:** OpenRouter lists 2026-08-12. Hugging Face and independent launch coverage appeared 2026-08-13.
- **Direct ID:** `deepseek-v4-pro`.
- **OpenRouter pinned ID:** `deepseek/deepseek-v4-pro-0813`.
- **OpenRouter unsuffixed ID:** `deepseek/deepseek-v4-pro`, currently an older **V4 Pro 0423** route.
- **Architecture:** 1.6 trillion core parameters, 49 billion active per token.
- **Artifact size discrepancy:** Hugging Face may report about 1.7T because the uploaded artifact includes DSpark speculative-decoding auxiliary parameters.
- **Context:** Direct API advertises 1M. OpenRouter metadata gives 1,048,576 tokens.
- **Maximum output:** Direct docs say 384K; OpenRouter metadata says 384,000.
- **Modality:** Text input and text output only. It is not a vision model.
- **License for downloadable weights:** MIT.

Sources: [official Pro 0813 model card, 2026-08-13](https://huggingface.co/deepseek-ai/DeepSeek-V4-Pro-0813), [official pricing matrix](https://api-docs.deepseek.com/quick_start/pricing/), [OpenRouter pinned page, 2026-08-12](https://openrouter.ai/deepseek/deepseek-v4-pro-0813), [OpenRouter old 0423 page](https://openrouter.ai/deepseek/deepseek-v4-pro).

### Reasoning controls

- Native self-hosted/chat-template levels: `low`, `high`, `max`.
- Hosted DeepSeek API formally exposes `high` and `max`; default is `high`.
- OpenAI-compatible Chat Completions:
  - Enable or disable thinking with `thinking: {"type":"enabled"}` or `{"type":"disabled"}`.
  - Set effort with `reasoning_effort`.
  - Compatibility mapping: `low` and `medium` map to `high`; `xhigh` maps to `max`.
- Anthropic-compatible API:
  - `output_config: {"effort":"high"}` or `{"effort":"max"}`.
- Responses API:
  - `reasoning: {"effort":"high"}` or `{"effort":"max"}`.
- DeepSeek may automatically promote particularly complex agent requests to `max`.
- In thinking mode, `temperature`, `top_p`, frequency penalty, and presence penalty are ignored.
- Tool-call continuation must send the returned `reasoning_content` back with the assistant tool-call message. Omitting it can produce HTTP 400.

Source: [official thinking-mode guide, accessed 2026-08-21](https://api-docs.deepseek.com/guides/thinking_mode/).

### Sampling recommendations

For self-hosting and official benchmark reproduction:

- `temperature: 1.0`
- `top_p: 0.95` for agentic workloads
- `top_p: 1.0` otherwise
- Maximum output up to 384K for high/max runs

These settings do not affect hosted thinking requests because the hosted API ignores sampling parameters in thinking mode.

Source: [official Pro 0813 model card](https://huggingface.co/deepseek-ai/DeepSeek-V4-Pro-0813).

### Tools and structured output

- Normal function calling: supported.
- `tool_choice`: generally supported, but DeepSeek’s direct Chat Completions integration notes that thinking mode rejects some `tool_choice` combinations.
- Strict tool arguments:
  - Available through the `/beta` endpoint.
  - Every supplied tool must set `strict: true`.
  - Supports only a documented subset of JSON Schema.
- JSON mode:
  - `response_format: {"type":"json_object"}`.
  - Prompt must explicitly contain the word `json`.
  - DeepSeek recommends including the intended schema or example in the prompt.
  - Valid JSON is targeted, but arbitrary response JSON Schema enforcement is not guaranteed.
  - Official docs acknowledge occasional empty output.
- OpenRouter’s Flash page advertises JSON Schema support, while the Pro page describes JSON response formatting without broad schema enforcement. Treat this as route/provider-dependent.

Sources: [tool calling and strict mode](https://api-docs.deepseek.com/guides/tool_calls/), [JSON mode](https://api-docs.deepseek.com/guides/json_mode/), [direct API integration notes](https://api-docs.deepseek.com/quick_start/agent_integrations/oh_my_pi/).

### Responses API

Supported for both current V4 models, with important limitations:

- Stateless implementation.
- Unsupported: `previous_response_id`, conversations, `store`, background mode.
- Unsupported fields may be silently ignored.
- Image and file content are unsupported. Image parts can be replaced with placeholders rather than processed visually.
- Supported tools: functions, web search, and the `apply_patch` custom tool.
- Other built-in tools can be ignored.
- `reasoning.effort` and `max_output_tokens` are supported.
- Developer-role messages are treated as system messages.
- Prompt cache keys are unsupported because DeepSeek caching is automatic.

Source: [official Responses API guide, accessed 2026-08-21](https://api-docs.deepseek.com/guides/responses_api/).

### Cache mechanics

- Automatic disk-backed context caching. No cache key is required.
- Best-effort, not guaranteed.
- Only full matching prefixes receive hits.
- Cache units are persisted at request boundaries, including the end of input and output.
- Long requests can gain additional internal cache boundaries at fixed intervals.
- Newly constructed cache entries can take seconds to become reusable.
- Entries can survive from hours to days.
- Usage fields:
  - `prompt_cache_hit_tokens`
  - `prompt_cache_miss_tokens`

Source: [official context-cache guide](https://api-docs.deepseek.com/guides/kv_cache/).

### Known operational quirks

- **Overthinking at max:** Plausible and repeatedly reported, but not documented as an official 0813 defect. It manifests as verbosity, unnecessary exploration, and slow task closure.
- **Tool loops:** Real integration reports exist, including repeated no-op tool calls and endless read/reason cycles. Some reports involve the April model or third-party harnesses, so they do not establish a universal 0813 defect.
- **Reasoning passback:** A confirmed protocol constraint. Failing to replay `reasoning_content` during tool turns causes errors or broken trajectories.
- **Clarifying questions:** No strong primary or independent evidence establishes excessive clarification as a systematic 0813 quirk.

Examples: [Hermes Agent issue 37255, 2026-06-02](https://github.com/NousResearch/hermes-agent/issues/37255), [Qwen Code issue 4695, 2026-06](https://github.com/QwenLM/qwen-code/issues/4695), [Cline Flash xhigh loop issue 13041, 2026-08-07](https://github.com/cline/cline/issues/13041), [Goose reasoning-content issue 9200](https://github.com/aaif-goose/goose/issues/9200).

---

## 2. DeepSeek-V4-Flash-0731

### Identity and limits

- **Release:** 2026-07-31.
- **Direct ID:** `deepseek-v4-flash`.
- **OpenRouter pinned ID:** `deepseek/deepseek-v4-flash-0731`.
- **OpenRouter floating alias:** literal `~deepseek/deepseek-v4-flash-latest`.
- **Floating behavior:** Redirects to the latest Flash snapshot; currently 0731.
- **Architecture:** 284B total, 13B active.
- **Direct context/output:** 1M context, 384K maximum output.
- **Modality:** Text only.
- **License:** MIT.

Sources: [official Flash 0731 model card, 2026-07-31](https://huggingface.co/deepseek-ai/DeepSeek-V4-Flash-0731), [OpenRouter Flash 0731](https://openrouter.ai/deepseek/deepseek-v4-flash-0731), [OpenRouter floating alias](https://openrouter.ai/~deepseek/deepseek-v4-flash-latest).

### OpenRouter metadata discrepancy

OpenRouter’s Flash pages expose conflicting limits:

- Page header: approximately 1M context.
- Detailed metadata: 1,310,720 context and 262,144 maximum output.
- Direct DeepSeek docs: 1M context and 384K maximum output.

Do not assume OpenRouter can deliver 384K output without testing the selected provider. Pin the provider and inspect its returned limits.

### Capabilities

- Same self-hosted reasoning levels: `low`, `high`, `max`.
- Same hosted reasoning compatibility mappings as Pro.
- Same official local sampling recommendations: temperature 1.0, top-p 0.95 for agents, 1.0 otherwise.
- Function calling, JSON mode, strict beta tools, Responses API, and automatic prefix caching are supported.
- Text only. Adding an image field in a client does not create vision capability.

### April IDs and deprecation

- Direct `deepseek-v4-flash` and `deepseek-v4-pro` are rolling names. They were not cut off; DeepSeek retargeted them to the newer snapshots.
- OpenRouter’s unsuffixed pages remain live and still describe the 0423 models:
  - `deepseek/deepseek-v4-flash`
  - `deepseek/deepseek-v4-pro`
- The legacy direct names `deepseek-chat` and `deepseek-reasoner` were retired in July 2026. They should not be used for current integrations.

Sources: [OpenRouter Flash 0423](https://openrouter.ai/deepseek/deepseek-v4-flash), [OpenRouter Pro 0423](https://openrouter.ai/deepseek/deepseek-v4-pro), [official current pricing matrix](https://api-docs.deepseek.com/quick_start/pricing/).

---

## 3. Pricing

### Current direct API pricing

Effective time reported by contemporaneous pricing trackers:

- **2026-08-16 16:00 UTC**
- **2026-08-17 00:00 Beijing time**

DeepSeek’s current official page confirms the prices and windows, but does not expose that cutover timestamp in its live text.

Peak windows:

- UTC: **01:00-04:00** and **06:00-10:00**
- Beijing UTC+8: **09:00-12:00** and **14:00-18:00**
- All other times are off-peak.

| Model | Band | Cache hit USD | Cache miss USD | Output USD | Cache hit RMB | Cache miss RMB | Output RMB |
|---|---:|---:|---:|---:|---:|---:|---:|
| Flash | Off-peak | $0.007 | $0.22 | $0.66 | ¥0.05 | ¥1.50 | ¥4.50 |
| Flash | Peak | $0.014 | $0.44 | $1.32 | ¥0.10 | ¥3.00 | ¥9.00 |
| Pro | Off-peak | $0.022 | $0.66 | $1.98 | ¥0.15 | ¥4.50 | ¥13.50 |
| Pro | Peak | $0.044 | $1.32 | $3.96 | ¥0.30 | ¥9.00 | ¥27.00 |

Source: [official DeepSeek pricing, accessed 2026-08-21](https://api-docs.deepseek.com/quick_start/pricing/). Cutover corroboration: [AI Builder Price, 2026-08](https://www.aibuilderprice.com/deepseek-api-pricing-calculator), [DevTK pricing guide, updated 2026-08-17](https://devtk.ai/en/blog/deepseek-api-pricing-guide-2026/).

### Previous flat pricing

| Model | Cache hit USD | Cache miss USD | Output USD | Cache hit RMB | Cache miss RMB | Output RMB |
|---|---:|---:|---:|---:|---:|---:|
| Flash | $0.0028 | $0.14 | $0.28 | ¥0.02 | ¥1.00 | ¥2.00 |
| Pro | $0.003625 | $0.435 | $0.87 | ¥0.025 | ¥3.00 | ¥6.00 |

The new off-peak prices are still substantially above the old flat schedule, particularly output.

### OpenRouter pass-through

- OpenRouter’s general policy says provider pricing is passed through.
- At the time checked, the **DeepSeek-hosted routes displayed the direct off-peak rates**:
  - Pro: $0.66 input, $1.98 output, $0.022 cache read.
  - Flash: $0.22 input, $0.66 output, $0.007 cache read.
- This is evidence that OpenRouter has ingested the new tariff.
- No OpenRouter primary document was found explicitly promising automatic peak/off-peak switching at the exact DeepSeek boundaries.
- Other OpenRouter providers show their own flat or promotional rates. They do not appear tied to DeepSeek’s clock.

Source: [OpenRouter pricing FAQ](https://openrouter.ai/docs/faq), plus the live model pages cited below.

### Selected OpenRouter providers

Format: input/output/cache-read USD per 1M; throughput is OpenRouter’s displayed recent estimate.

#### Pro 0813

| Provider | Input | Output | Cache | tok/s |
|---|---:|---:|---:|---:|
| DeepSeek, off-peak when checked | $0.66 | $1.98 | $0.022 | 30 |
| GMICloud promo | $1.188 | $3.564 | $0.0396 | 40 |
| Alibaba International | $1.205 | $3.615 | $0.1205 | 50 |
| StreamLake | $1.32 | $3.96 | $0.044 | 40 |
| Novita | $1.32 | $3.96 | $0.132 | 42 |
| Baseten | $1.32 | $3.96 | $0.132 | 94 |
| Cloudflare | $1.32 | $3.96 | $0.044 | 27 |
| Fireworks | $1.32 | $3.96 | $0.044 | 44 |
| Together | $1.32 | $3.96 | $0.13 | 56 |
| Parasail | $1.32 | $3.96 | $0.044 | 76 |

DeepInfra and CoreWeave were not listed for the pinned 0813 route when checked.

Source: [OpenRouter Pro 0813 provider table, accessed 2026-08-21](https://openrouter.ai/deepseek/deepseek-v4-pro-0813).

#### Flash 0731

| Provider | Input | Output | Cache | tok/s |
|---|---:|---:|---:|---:|
| Relace | $0.07 | $0.14 | $0.014 | 65 |
| DeepInfra | $0.08 | $0.18 | $0.016 | 46 |
| GMICloud promo | $0.084 | $0.168 | $0.0168 | 60 |
| Baseten | $0.13 | $0.26 | $0.028 | 50 |
| CoreWeave | $0.13 | $0.28 | $0.07 | 72 |
| Novita | $0.14 | $0.28 | $0.028 | 65 |
| Fireworks | $0.22 | $0.66 | $0.007 | 79 |
| DeepSeek, off-peak when checked | $0.22 | $0.66 | $0.007 | 71 |
| Cloudflare | $0.44 | $1.32 | $0.014 | 56 |

Other notable live observations:

- Baidu: $0.14/$0.28/$0.028, 102 tok/s.
- Atlas: $0.44/$1.32/$0.028, 106 tok/s.
- Wafer: $0.28/$0.56/$0.07, 160 tok/s.
- OpenInference: $0.065/$0.14/$0.014, 10 tok/s.

Source: [OpenRouter Flash 0731 provider table, accessed 2026-08-21](https://openrouter.ai/deepseek/deepseek-v4-flash-0731).

OpenRouter did not expose a reliable per-provider quantization field on these pages. Do not infer FP4, FP8, or an accuracy-equivalent deployment from the provider name or price.

---

## 4. Benchmarks

### Official Pro 0813 table

All DeepSeek figures below use each model’s published harness/configuration. Pro 0813 was evaluated with DeepSeek Harness Minimal mode, `max`, temperature 1.0, and top-p 0.95.

| Benchmark | Pro 0813 | Flash 0731 | Kimi K3 | Opus 4.8 | Fable 5 |
|---|---:|---:|---:|---:|---:|
| HLE, no tools | 42.7 | 37.8 | 43.5 | 49.8 | 53.3 |
| HLE, tools | 60.0 | 51.5 | 56.0 | 57.9 | 63.0 |
| Terminal-Bench 2.1 | 87.9 | 82.7 | 88.3 | 85.0 | 88.0 |
| NL2Repo | 61.5 | 54.2 | not reported | 69.7 | not reported |
| Cybergym | 83.3 | 76.7 | 80.0 | 78.3 | 83.1 |
| DeepSWE | 62.7 | 54.4 | 67.5 | 58.0 | 70.0 |
| Toolathlon-V | 74.1 | 70.3 | 76.5 | 76.2 | 77.9 |
| Agents Last Exam | 25.7 | 25.2 | 27.6 | 25.7 | not reported |
| AutomationBench | 31.8 | 25.1 | 30.8 | 27.2 | 29.1 |
| DSBench Fullstack | 71.1 | 68.7 | 73.7 | 71.6 | 77.2 |
| DSBench Hard | 67.2 | 59.6 | 63.0 | 71.7 | 68.3 |

Source: [official Pro 0813 Hugging Face model card](https://huggingface.co/deepseek-ai/DeepSeek-V4-Pro-0813).

Notes:

- DeepSeek’s official table compares against **Opus 4.8**, not Opus 5.
- GPT-5.6 is absent.
- Therefore no official DeepSeek table supports a direct Pro 0813 versus Opus 5 or GPT-5.6 claim.

### Independent remeasurement

- Artificial Analysis currently scores:
  - Pro 0813: **53** Intelligence Index, approximately **81.1 output tok/s**, 1M context, text only.
  - Flash 0731: approximately **52** on the current model page, versus 50 in its 2026-07-31 launch article.
- Artificial Analysis measured Flash at about **79** on Terminal-Bench 2.1 versus DeepSeek’s official **82.7**.
- Secondary captures of the AA leaderboard report Pro 0813 at **78.65**, commonly rounded to **79.0**, versus DeepSeek’s official **87.9**.
- The Pro delta is therefore approximately **8.9 points** using 79.0, or **9.25 points** using 78.65.
- Likely causes include harness, scaffolding, timeout, effort, tool implementation, and task-environment differences. This does not by itself demonstrate benchmark manipulation.

Sources: [Artificial Analysis Pro page, accessed 2026-08-21](https://artificialanalysis.ai/models/deepseek-v4-pro/), [Artificial Analysis Terminal-Bench 2.1 leaderboard](https://artificialanalysis.ai/evaluations/terminalbench-v2-1), [Flash launch analysis, 2026-07-31](https://artificialanalysis.ai/articles/deepseek-v4-flash-0731-scores-50-on-the-artificial-analysis-intelligence-index-10-points-above-previous-deepseek-v4-flash), [secondary AA capture, 2026-08](https://rohitai.com/blog/deepseek-v4-pro-0813-ga-benchmarks-pricing).

---

## 5. DeepSeek Harness: `deepseek-harness`, `dsh`

### What it is

- Open-source, provider-pluggable coding-agent harness from DeepSeek.
- Repository: [github.com/deepseek-ai/deepseek-harness](https://github.com/deepseek-ai/deepseek-harness).
- Architecture: one swappable agent loop plus Cordis plugins for tools, UI, storage, policies, providers, and orchestration.
- License: MIT.
- Status: explicitly a **developer preview** with possible compatibility-breaking changes.
- npm status on 2026-08-21:
  - Stable tag: `0.1.0-rc.7`.
  - Next tag: `0.1.0-rc.8`.
  - Multiple RC publishes occurred during 2026-08-14 through 2026-08-20.

Sources: [official repository](https://github.com/deepseek-ai/deepseek-harness), [npm package and versions, accessed 2026-08-21](https://www.npmjs.com/package/%40deepseek-ai/dsh?activeTab=versions).

### Install and run

```bash
npx @deepseek-ai/dsh web
```

Other entry forms:

```bash
dsh --profile <name>
dsh --profile headless "job"
dsh plugin --profile <name> <pnpm-args>
```

A bare `npx @deepseek-ai/dsh` invokes the launcher but `web` is the documented interactive profile.

### Presets or modes

Official/source naming is closer to:

- **Standard:** General coding agent with the normal tool bundle.
- **PTC / Code:** Programmatic tool-calling style, where TypeScript orchestrates tool use.
- **Minimal:** Deliberately small agent surface, primarily persistent shell plus string-replace editing. This is the configuration used for DeepSeek’s published agent benchmarks.
- **Creator:** Standard capabilities plus harness inspection and plugin/preset construction.

“Creative” appears to be an informal or mistaken name for **Creator**.

Reference: [official CLI reference](https://github.com/deepseek-ai/deepseek-harness/blob/master/apps/cli/reference/README.md).

### Model support

- Native `deepseek-official` provider.
- Anthropic and OpenAI provider catalogs.
- Custom OpenAI-compatible gateways.
- Self-hosted endpoints.
- The harness is not limited to DeepSeek models.

Source: [official provider guide](https://github.com/deepseek-ai/deepseek-harness/blob/master/docs/user/guide/providers.md).

### Image input

A custom model can declare:

```yaml
input: [text, image]
```

in `$DSH_HOME/settings.yaml`, normally `~/.dsh/settings.yaml`.

This enables the harness to send image blocks only when the selected custom provider/model actually supports them. It does **not** make DeepSeek V4 Pro or Flash multimodal. The official DeepSeek route remains text-only.

### Comparison

| Tool | Positioning | Main distinction |
|---|---|---|
| DeepSeek Harness | RC-stage, local/web/headless, model-provider neutral | Maximum plugin, loop, preset, and provider extensibility; aligned with DeepSeek benchmark scaffolding |
| Codex CLI | OpenAI coding agent across terminal, IDE, app, and cloud | More mature product workflow, native OpenAI Responses/tool stack and hosted task integration |
| Claude Code | Anthropic terminal coding agent | Mature opinionated workflow around Claude models, subagents, hooks, and Anthropic integrations |
| OpenCode | Open-source multi-provider terminal/desktop agent | Broader established multi-provider UX; less specifically aligned with DeepSeek’s own benchmark harness |

References: [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness), [OpenAI Codex documentation](https://developers.openai.com/codex/), [Claude Code overview](https://docs.anthropic.com/en/docs/claude-code/overview), [OpenCode repository](https://github.com/anomalyco/opencode).

---

## 6. Practitioner consensus and routing

### V4 Pro 0813 is best at

- Architecture and multi-file planning.
- Difficult debugging and code review.
- Scientific or algorithmic code analysis.
- Long-horizon repository work when paired with the Minimal harness.
- Agent tasks that need substantial private reasoning before acting.
- Producing high-quality diagnoses before delegating implementation to a cheaper model.

### Weakest at

- Latency-sensitive interactive editing.
- Cost-sensitive bulk transformations.
- Aesthetic frontend work, according to several practitioner reports.
- Tasks where `max` turns into excessive exploration.
- Tool environments that do not correctly replay reasoning blocks.
- Some long-context tool trajectories, where integrations report repeated reads, no-op calls, or failure to terminate.

### Flash versus Pro routing

- Flash is the better default for:
  - Routine implementation.
  - Search, extraction, and repository reconnaissance.
  - Parallel workers.
  - Test generation and mechanical fixes.
  - High-volume OpenRouter traffic.
- Pro is the escalation route for:
  - Architectural decisions.
  - Hard debugging.
  - Security or correctness review.
  - Failed Flash attempts.
  - Long, ambiguous agent tasks.

### Is Flash max as good as Pro high for coding?

- **Not verified as a general claim.**
- Earlier official DeepSeek positioning said Flash at a larger reasoning budget could approach Pro-class reasoning while remaining weaker on knowledge and complicated agents.
- The current official GA table compares both principally under max-oriented benchmark settings and still has Pro ahead:
  - Terminal-Bench 2.1: 87.9 versus 82.7.
  - DeepSWE: 62.7 versus 54.4.
  - NL2Repo: 61.5 versus 54.2.
  - DSBench Hard: 67.2 versus 59.6.
- Artificial Analysis has their composite scores much closer, roughly 53 versus 52.
- Practical conclusion: Flash max can overlap with Pro high on routine coding, but there is no controlled published effort-matched result establishing equivalence.

Practitioner sources:

- [LocalLLaMA Pro 0813 release thread, 2026-08-13](https://www.reddit.com/r/LocalLLaMA/comments/1vn9it4/deepseekaideepseekv4pro0813_hugging_face/)
- [LocalLLaMA Flash appreciation thread, 2026-08-08](https://www.reddit.com/r/LocalLLaMA/comments/1vio0x6/deepseek_v4_flash_0731_appreciation_post/)
- [LocalLLaMA Flash reliability thread, 2026-08-08](https://www.reddit.com/r/LocalLLaMA/comments/1vikgrj/is_anyone_else_finding_deepseekv4flash_unreliable/)
- [LocalLLaMA Pro coding reports, 2026-04-26](https://www.reddit.com/r/LocalLLaMA/comments/1swiy4b/anyone_actually_tried_deepseek_v4_pro_for_coding/)
- [HN V4 launch discussion, 2026-04-24](https://news.ycombinator.com/item?id=47884971)
- [HN practitioner discussion, approximately 2026-08-20](https://news.ycombinator.com/item?id=49078583)
- [Simon Willison V4 analysis, 2026-04-24](https://simonwillison.net/2026/Apr/24/deepseek-v4/)
- [Simon Willison AI feed with 0813 note, 2026-08-12](https://feeds.simonwillison.net/tags/ai/)

Reddit and HN reports are anecdotal. They are useful for failure modes, not prevalence estimates.

---

## 7. Changes from 2026-08-14 through 2026-08-21

Verified:

- **2026-08-16 16:00 UTC:** New peak/off-peak direct API pricing took effect, corresponding to 2026-08-17 00:00 Beijing.
- **2026-08-14 through 2026-08-20:** DeepSeek Harness published multiple RC packages, including rc.6, rc.7, and an rc.8 next tag.
- No official DeepSeek announcement or model card was found for:
  - V4.1.
  - A newer Pro snapshot after 0813.
  - A newer Flash snapshot after 0731.
  - A new vision-capable V4 API model.
- The official status surface did not provide enough crawlable historical detail to verify a DeepSeek outage specifically during 2026-08-14 through 2026-08-21.
- Practitioner reports on 2026-08-14 alleged rollout-quality problems with Pro 0813, but these are not evidence of a confirmed API outage or rollback.

Sources: [official pricing](https://api-docs.deepseek.com/quick_start/pricing/), [DeepSeek Harness npm versions](https://www.npmjs.com/package/%40deepseek-ai/dsh?activeTab=versions), [DeepSeek status](https://status.deepseek.com/), [practitioner rollout report, 2026-08-14](https://www.reddit.com/r/DeepSeek/comments/1vn5y49/deepseeks_v4_pro_0813_official_release_last_night/).

## Confidence and gaps

- **High confidence:** Direct IDs, current model mapping, official feature matrix, reasoning parameter mappings, text-only modality, cache mechanics, current USD prices, peak windows, official benchmark values, parameter counts, DSH repository/license/RC status.
- **Cutover timestamp:** 2026-08-16 16:00 UTC is supported by contemporaneous independent pricing pages, but is no longer visible on DeepSeek’s live pricing page.
- **Direct exact binary context limit:** DeepSeek says 1M; OpenRouter gives 1,048,576 for Pro. The upstream docs do not clearly state whether the direct hard limit is exactly 1,048,576.
- **Flash OpenRouter limits:** 1,310,720 context and 262,144 output conflict with DeepSeek’s 1M/384K documentation.
- **OpenRouter intraday pass-through:** The first-party route displayed the current off-peak price, but no explicit OpenRouter documentation was found confirming exact automatic peak switching.
- **Provider quantization:** Not exposed reliably by the OpenRouter pages. Quantization is unknown for the listed hosted routes.
- **Pro independent Terminal-Bench value:** The live Artificial Analysis page did not expose the row in crawlable text. The 78.65/79.0 figure relies on contemporaneous secondary captures.
- **Opus 5 and GPT-5.6:** Absent from DeepSeek’s official 0813 benchmark table. No official apples-to-apples comparison was verified.
- **Flash max versus Pro high:** No controlled effort-matched benchmark was found.
- **Clarifying-question quirk:** Not verified as a systematic model behavior.
- **Tool-loop prevalence:** Individual issues are verified, but several involve older snapshots or client integrations. Incidence on the native 0813 API is unknown.
- **DSH mode name:** Official/source material supports “Creator”; “Creative” appears informal.
- **Historical outages:** No authoritative, complete incident record for 2026-08-14 through 2026-08-21 was available from the crawlable status page.
