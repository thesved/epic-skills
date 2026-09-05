# Lane C: Meta Muse benchmarks and routing verdict, research cutoff 2026-09-05

## TLDR: decisions for our routing

1. **Keep Claude Fable 5.1 as orchestrator, use Muse Spark 1.3 as a long-context challenger.** Spark 1.3 max scores 62 on the Artificial Analysis Intelligence Index versus 66 for Fable 5.1 max, while Spark xhigh costs $0.55 per AA task versus $3.69 for Fable max. [COMMUNITY][DEMONSTRATED] [Artificial Analysis Spark report, published 2026-09-02, accessed 2026-09-05](https://artificialanalysis.ai/articles/muse-spark-1-3/) [COMMUNITY][DEMONSTRATED] [Artificial Analysis Fable release, published 2026-08, accessed 2026-09-05](https://artificialanalysis.ai/models/releases/claude-fable-5-1)

2. **Do not displace GPT-5.6 Sol for implementation that ships until Spark passes repository-level trials.** Meta reports DeepSWE 75.4 for Spark max versus public results of 74.0 for Opus 5 and 73.0 for Sol, but Meta used its own mini-swe-agent run and Spark was absent from the cited public Datacurve leaderboard when checked. [OFFICIAL][DEMONSTRATED] [Meta evaluation methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [public-board comparison, published 2026-09-03, accessed 2026-09-05](https://developer.tenten.co/meta-muse-spark-1-3-coding-benchmark)

3. **Route non-sensitive mechanical bulk work to Contributor before standard Spark.** At the requested OpenRouter rates, a 30K-input, 3K-output turn costs $0.0036 on Contributor versus $0.05025 on standard Spark, while OpenRouter presents the two variants with otherwise matching capability metadata. [OFFICIAL][DEMONSTRATED] [OpenRouter Contributor listing, published 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3-contributor) [OFFICIAL][DEMONSTRATED] [OpenRouter standard listing, published 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3)

4. **Keep proprietary code, credentials, customer material, and review deliberations off Contributor.** OpenRouter says Contributor traffic may be used to improve Meta products, so its discount changes the data-handling decision even if checkpoint capability is identical. [OFFICIAL][ASSERTION] [OpenRouter Contributor listing, published 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3-contributor)

5. **Keep Opus 5 as the independent review seat.** Spark and Glimmer are not independent from each other because Meta describes Glimmer as distilled from Spark, while Opus remains cross-family; Meta's own GDPVal-AA v2 result also places Opus at 1824 versus Spark max at 1754. [OFFICIAL][ASSERTION] [Meta Glimmer announcement, published 2026-08-10, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-glimmer-open-agentic-model) [OFFICIAL][DEMONSTRATED] [Meta Spark methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)

6. **Keep Gemini 3.7 Flash as the video and audio route.** Meta documents native video, image, and document perception for Spark but publishes no Video-MME, audio-understanding benchmark, video-token rate, or price-per-minute calculation for Spark 1.3; Google documents video tokenization, sampling behavior, and pricing for Gemini. [OFFICIAL][ASSERTION] [Meta Muse page, accessed 2026-09-05](https://ai.meta.com/llama?via=aivyx) [OFFICIAL][DEMONSTRATED] [Google video documentation, published 2026-09-04, accessed 2026-09-05](https://ai.google.dev/gemini-api/docs/generate-content/video-understanding?authuser=31&hl=en) [OFFICIAL][DEMONSTRATED] [Google token documentation, published 2026-09-04, accessed 2026-09-05](https://ai.google.dev/gemini-api/docs/tokens)

7. **Use Spark 1.3 or Contributor for million-token text review pilots.** Meta reports MRCR v2 scores of 98.5 at 256K-512K and 98.1 at 512K-1M, versus Sol at 91.5 and 73.8, respectively, using 100 eight-needle examples per range. [OFFICIAL][DEMONSTRATED] [Meta evaluation methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [numeric transcription of Meta table, published 2026-09-03, accessed 2026-09-05](https://www.datacamp.com/blog/muse-spark-1-3)

8. **Treat Spark max as a benchmark reference, not an OpenRouter route.** Meta evaluates both xhigh and max, but OpenRouter exposes reasoning controls without establishing that its route serves Meta's separately reported max configuration. [OFFICIAL][ASSERTION] [Meta Spark launch, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-spark-1-3) [OFFICIAL][DEMONSTRATED] [OpenRouter model listing, published 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3)

9. **Resolve the 18+ attestation before any Spark routing test.** The live probe returned HTTP 403 with the exact text, “This model requires you to complete the following before use: 18+ age confirmation. Confirm at https://openrouter.ai/settings/preferences.” and `missing_attestation_types ["age_18plus"]`. [COMMUNITY][DEMONSTRATED] [OpenRouter preference endpoint named by the response, accessed 2026-09-05](https://openrouter.ai/settings/preferences)

10. **Interpret that gate as an account eligibility attestation, not as a benchmark or moderation setting.** OpenRouter's general terms permit users from age 13 with parental permission below 18, while Meta's Glimmer card says, “The model is not intended to be downloaded by or used by individuals under the age of 18.” The evidence therefore points to a Muse-specific upstream condition, although OpenRouter has not documented the exact attestation lifecycle. [OFFICIAL][ASSERTION] [OpenRouter terms, published 2026-07-29, accessed 2026-09-05](https://openrouter.ai/terms) [OFFICIAL][ASSERTION] [Meta Glimmer model card, published 2026-08-10, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B?inference_provider=together)

11. **Use Glimmer as the local, private Muse option, not as a frontier replacement.** The official 17 GB K-quant target fits a 24 GB or 32 GB Apple-silicon system, and an independent M4 Max run measured 16.8 output tokens/s at 128K with 26.4 GB peak memory, but Glimmer's official Terminal-Bench 2.1 result is only 51.7. [OFFICIAL][DEMONSTRATED] [Meta Glimmer model card, published 2026-08-10, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B?inference_provider=together) [COMMUNITY][DEMONSTRATED] [oMLX M4 Max measurements, published 2026-08-11, accessed 2026-09-05](https://omlx.ai/benchmarks/performance/1pql8mxy)

12. **Do not make a Hungarian routing change.** Glimmer is claimed to support more than 100 languages and Spark 1.2 has French, German, Spanish, and Chinese Arena results, but no Hungarian-specific Muse benchmark or human evaluation was found. [OFFICIAL][ASSERTION] [Meta Glimmer announcement, published 2026-08-10, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-glimmer-open-agentic-model) [COMMUNITY][DEMONSTRATED] [Muse Spark 1.2 Arena snapshot, date not visible, accessed 2026-09-05](https://modeligent.com/models/muse-spark-1.2)

## 1. Independent benchmarks

### Frontloaded result

Spark 1.3 is a cost-efficient frontier-adjacent model, not the overall leader. Its strongest independently visible case is a 61 to 62 AA Intelligence Index at $0.55 per task for xhigh. Fable 5.1 retains the highest aggregate and coding scores in the compared roster, while Spark is much cheaper. [COMMUNITY][DEMONSTRATED] [Artificial Analysis Spark report, published 2026-09-02, accessed 2026-09-05](https://artificialanalysis.ai/articles/muse-spark-1-3/) [COMMUNITY][DEMONSTRATED] [Toolbit AA transcription, published 2026-09-02, accessed 2026-09-05](https://www.toolbit.ai/updates/models/muse-spark-1-3)

Artificial Analysis v4.1 combines GDPVal-AA v2, tau3-Banking, Terminal-Bench 2.1, SciCode, Humanity's Last Exam, GPQA Diamond, CritPt, AA-Omniscience, and AA-LCR. Its cost per task includes weighted input, output, reasoning, and cache charges. [COMMUNITY][ASSERTION] [Artificial Analysis comparison methodology, accessed 2026-09-05](https://artificialanalysis.ai/models/comparisons/gpt-5-6-terra-vs-step-3-7-flash)

### Artificial Analysis roster snapshot

`NR` means no stable number was exposed in the inspected source. Total output is the aggregate output token count reported for the full AA evaluation, not tokens per individual task.

| Model and effort | Intelligence | Coding | Agentic | Cost per task | Output speed | Total output | Evidence |
|---|---:|---:|---:|---:|---:|---:|---|
| Muse Spark 1.3, xhigh | 61 | 76.3 | 59.3 | $0.55 | 149.9 t/s | 100M | [COMMUNITY][DEMONSTRATED] [AA Spark xhigh, published 2026-09-02, accessed 2026-09-05](https://artificialanalysis.ai/models/muse-spark-1-3-xhigh) |
| Muse Spark 1.3, max | 62 to 62.1 | 76.3 | 59.3 | NR, max not broadly priced | NR | 120M | [COMMUNITY][DEMONSTRATED] [AA Spark max, published 2026-09-02, accessed 2026-09-05](https://artificialanalysis.ai/models/muse-spark-1-3) |
| Muse Spark 1.2, xhigh | 56.8 to 57 | 72.2 | 49.3 | NR | NR | NR | [COMMUNITY][DEMONSTRATED] [OpenRouter AA snapshot, published 2026-08-05, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.2) |
| Claude Fable 5.1, max | 66 | 81.6 | 61.3 | $3.69 | 66 t/s | NR | [COMMUNITY][DEMONSTRATED] [AA Fable release, published 2026-08, accessed 2026-09-05](https://artificialanalysis.ai/models/releases/claude-fable-5-1) |
| Claude Opus 5, max | 63 | 78.0 | 59.2 | $2.34 | 57.1 t/s | 100M | [COMMUNITY][DEMONSTRATED] [AA Opus release, published 2026-07, accessed 2026-09-05](https://artificialanalysis.ai/models/releases/claude-opus-5) |
| GPT-5.6 Sol, max | 61 | NR | NR | $0.95 | 77 t/s | NR | [COMMUNITY][DEMONSTRATED] [AA Sol release, published 2026-07, accessed 2026-09-05](https://artificialanalysis.ai/models/releases/gpt-5-6-sol) |
| GPT-5.6 Terra, max | 57 in release curve | NR | NR | $0.53 | 103 t/s | NR | [COMMUNITY][DEMONSTRATED] [AA Terra release, published 2026-07, accessed 2026-09-05](https://artificialanalysis.ai/models/releases/gpt-5-6-terra) |
| GPT-5.6 Luna, max | 52 | NR | NR | $0.05 | 168.4 t/s | 130M | [COMMUNITY][DEMONSTRATED] [AA Luna, published 2026-07, accessed 2026-09-05](https://artificialanalysis.ai/models/gpt-5-6-luna) |
| GPT-6 Astra, max | 61 | NR | NR | $1.67 | NR | 42M | [COMMUNITY][DEMONSTRATED] [AA Astra, published 2026-09-03, accessed 2026-09-05](https://artificialanalysis.ai/models/gpt-6-astra/) |
| Gemini 3.7 Flash, high | 56 | NR | NR | $0.40 | 320 t/s | 64M | [COMMUNITY][DEMONSTRATED] [AA Gemini 3.7 Flash, published 2026-08, accessed 2026-09-05](https://artificialanalysis.ai/models/gemini-3-7-flash) |
| Gemini 3.1 Pro Preview | 48 | NR | NR | $0.33 | 111.2 t/s | 56M | [COMMUNITY][DEMONSTRATED] [AA Gemini 3.1 Pro, published 2026-02, accessed 2026-09-05, older than preferred window](https://artificialanalysis.ai/models/gemini-3-1-pro-preview/) |
| DeepSeek V4 Pro 0813 | 53 | NR | NR | NR | 60.2 t/s | NR | [COMMUNITY][DEMONSTRATED] [AA DeepSeek V4 Pro, published 2026-08, accessed 2026-09-05](https://artificialanalysis.ai/models/deepseek-v4-pro) |
| GLM 5.3, max | 60 | NR | NR | $0.68 | 62.8 t/s | 170M | [COMMUNITY][DEMONSTRATED] [AA GLM 5.3, published 2026-08, accessed 2026-09-05](https://artificialanalysis.ai/models/glm-5-3) |
| GLM 5.3 Flash | 57 | NR | NR | $0.09 | 47.4 t/s | 150M | [COMMUNITY][DEMONSTRATED] [AA GLM 5.3 Flash, published 2026-08-26, accessed 2026-09-05](https://artificialanalysis.ai/models/glm-5-3-flash/) |
| Kimi K3, max | 60 | NR | NR | $0.84 | 39.2 t/s | 130M | [COMMUNITY][DEMONSTRATED] [AA Kimi K3, published 2026-08, accessed 2026-09-05](https://artificialanalysis.ai/models/kimi-k3) |
| Qwen 3.8 2.4T-A95B, max | 58 | NR | NR | $0.81 | 40 t/s | 140M | [COMMUNITY][DEMONSTRATED] [AA Qwen 3.8 flagship, published 2026-08, accessed 2026-09-05](https://artificialanalysis.ai/models/qwen3-8-2-4t-a95b) |
| Grok 4.6, high | 61 | NR | NR | $0.94 | 65 t/s | NR | [COMMUNITY][DEMONSTRATED] [AA Grok comparison, published 2026-08, accessed 2026-09-05](https://artificialanalysis.ai/models/comparisons/grok-4-6-vs-kimi-k3) |

The Qwen 3.8 label is ambiguous because it names a family. The table uses the 2.4T-A95B flagship; the separate 27B xhigh model scores 52, costs $0.37 per AA task, runs at 41.5 t/s, and consumed 160M aggregate output tokens. [COMMUNITY][DEMONSTRATED] [AA Qwen 3.8 27B, published 2026-08, accessed 2026-09-05](https://artificialanalysis.ai/models/qwen3-8-27b)

AA provider-speed pages changed during the sweep. One Spark comparison exposed about 182 t/s and 27.51 seconds to first token, while the dedicated xhigh page showed 149.9 t/s; these should be treated as provider and time-window measurements, not immutable model properties. [COMMUNITY][DEMONSTRATED] [AA Spark provider measurements, accessed 2026-09-05](https://artificialanalysis.ai/models/muse-spark-1-3-xhigh/providers)

### LiveBench

LiveBench's current table gives Spark xhigh an overall 81.6, between Fable max at 83.4 and Sol max at 81.0. Spark leads Sol on agentic coding by 64.1 to 56.2 but trails Fable's 66.1. [COMMUNITY][DEMONSTRATED] [LiveBench, benchmark release 2026-06-25, current table accessed 2026-09-05](https://livebench.ai/?lang=zh-hant)

| Model | Effort | Overall | Reasoning | Coding | Agentic coding | Math | Data | Language | Instruction | Cost per successful task | Evidence |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| Muse Spark 1.3 | xhigh | 81.6 | 89.7 | 81.1 | 64.1 | 95.9 | 79.6 | 82.8 | 78.0 | $0.219 | [COMMUNITY][DEMONSTRATED] [LiveBench, release 2026-06-25, accessed 2026-09-05](https://livebench.ai/?lang=zh-hant) |
| Claude Fable 5.1 | max | 83.4 | 91.7 | 86.4 | 66.1 | 97.0 | 80.3 | 89.5 | 73.0 | $1.212 | [COMMUNITY][DEMONSTRATED] [LiveBench, release 2026-06-25, accessed 2026-09-05](https://livebench.ai/?lang=zh-hant) |
| GPT-5.6 Sol | max | 81.0 | 91.7 | 83.9 | 56.2 | 96.2 | 79.8 | 87.7 | 71.8 | $0.515 | [COMMUNITY][DEMONSTRATED] [LiveBench, release 2026-06-25, accessed 2026-09-05](https://livebench.ai/?lang=zh-hant) |

A separate LiveBench mirror reports a different normalization, Spark 85.47, Fable 86.55, Sol 85.26, Opus 83.44, and Gemini 3.7 Flash 83.15. It also reports output tokens per case of 28,234 for Spark, 20,255 for Fable, 11,729 for Sol, 14,826 for Opus, and 22,610 for Gemini. Because those overall scores differ from LiveBench's own table, the token figures are useful as a directional efficiency warning, not as canonical LiveBench results. [COMMUNITY][DEMONSTRATED] [ModelMarkets LiveBench mirror, benchmark release 2026-06-25, accessed 2026-09-05](https://modelmarkets.ai/benchmarks/livebench?model=moonshotai%2FKimi-K3)

### Terminal-Bench 2.1

Meta's own native-harness result is 88.8 for Spark max and 89.2 for xhigh. Artificial Analysis reports about 85 to 86, with the detailed AA transcription giving 85.8. [OFFICIAL][DEMONSTRATED] [Meta methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [AA breakdown transcription, published 2026-09-02, accessed 2026-09-05](https://temperature2.com/models/muse-spark-1-3/)

A broad third-party compilation reports the following scores, but it mixes vendor cards, native coding agents, and public leaderboard results, so it is not a uniform independent rerun. [COMMUNITY][ASSERTION] [Terminal-Bench compilation, published 2026-09-03, accessed 2026-09-05](https://anotherwrapper.com/tools/llm-pricing/evals/terminal-bench-2-1)

| Model | Terminal-Bench 2.1 reported score |
|---|---:|
| Muse Spark 1.3 | 88.8 |
| GPT-5.6 Sol | 88.8 |
| Kimi K3 | 88.3 |
| GLM 5.3 | 88.2 |
| DeepSeek V4 Pro 0813 | 87.9 |
| GPT-5.6 Terra | 87.4 |
| Qwen 3.8 Max | 86.6 |
| Gemini 3.7 Flash | 85.8 |
| GPT-5.6 Luna | 84.7 |
| Claude Opus 5 | 84.6 |
| GLM 5.3 Flash | 84.3 |
| Claude Fable 5.1 | 84.3 |
| Muse Spark 1.2 | 82.9 |

All values in the preceding table are [COMMUNITY][ASSERTION] from the same [2026-09-03 compilation, accessed 2026-09-05](https://anotherwrapper.com/tools/llm-pricing/evals/terminal-bench-2-1), not a single-harness reproduction.

### LMArena

No Muse Spark 1.3 entry was found. The latest usable Muse result is Spark 1.2, with Text 1498.7, Coding 1533.1, Hard Prompts 1511.7, Vision 1290, WebDev 1534.7, Chinese 1529.3, French 1526.9, German 1508, Spanish 1482.2, Multi-turn 1518.6, and Instruction Following 1478.2. Effort and exact sampling parameters are not disclosed by the snapshot. [COMMUNITY][DEMONSTRATED] [Modeligent Arena snapshot, date not visible, accessed 2026-09-05](https://modeligent.com/models/muse-spark-1.2)

A second snapshot gives Text 1498 plus or minus 10 from 3,280 votes, Coding 1533 plus or minus 20 from 947 votes, Hard Prompts 1511 plus or minus 13 from 2,148 votes, and Vision 1290 plus or minus 18 from 1,282 votes. [COMMUNITY][DEMONSTRATED] [No Way Arena snapshot, published 2026-09-03, accessed 2026-09-05](https://no-way.dev/benchmarks)

No Spark 1.3 result was found for Search Arena. No exact WebDev, text, or vision number should be transferred from 1.2 to 1.3.

### Official Spark 1.3 benchmark table

These are vendor-run or vendor-selected figures, not independent results. Meta used max for Spark, Sol, and Opus where supported, then selected the highest comparable result from its evaluation, an official leaderboard, or a provider self-report. [OFFICIAL][ASSERTION] [Meta methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)

| Benchmark | Harness and task count | Spark 1.3 max | Sol max | Opus 5 max | Evidence |
|---|---|---:|---:|---:|---|
| DeepSWE v1.1 | mini-swe-agent, 113 tasks, 91 repos, 5 languages | 75.4 | 73.0 | 74.0 | [OFFICIAL][DEMONSTRATED] [Meta methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [table transcription, 2026-09-03](https://www.datacamp.com/blog/muse-spark-1-3) |
| SWE Atlas QnA | mini-swe-agent, 124 public questions | 59.4 | 53.5 | 52.7 | [OFFICIAL][DEMONSTRATED] [Meta methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [table transcription, 2026-09-03](https://www.datacamp.com/blog/muse-spark-1-3) |
| Terminal-Bench 2.1 | 89 tasks, native coding harnesses in isolated sandboxes | 88.8 | 88.8 | 86.7 | [OFFICIAL][DEMONSTRATED] [Meta methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [table transcription, 2026-09-03](https://www.datacamp.com/blog/muse-spark-1-3) |
| GDPVal-AA v2 | 220 tasks, AA Stirrup harness, Elo with human baseline 1000 | 1754 | 1710 | 1824 | [OFFICIAL][DEMONSTRATED] [Meta methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [table transcription, 2026-09-03](https://www.datacamp.com/blog/muse-spark-1-3) |
| JobBench | 65 tasks, OpenCode and file-aware grader | 64.9 | 45.4 | 65.7 | [OFFICIAL][DEMONSTRATED] [Meta methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [table transcription, 2026-09-03](https://www.datacamp.com/blog/muse-spark-1-3) |
| OSWorld 2.0 | 108 tasks, Meta common evaluation framework | 66.9 | 62.7 | 68.3 | [OFFICIAL][DEMONSTRATED] [Meta methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [table transcription, 2026-09-03](https://www.datacamp.com/blog/muse-spark-1-3) |
| DeepSearchQA | 900 questions, common backend and harness | 89.4 | 93.0 | 90.4 | [OFFICIAL][DEMONSTRATED] [Meta methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [table transcription, 2026-09-03](https://www.datacamp.com/blog/muse-spark-1-3) |
| Agentic IF Index | internal composite, task count not stated | 57.8 | 60.5 | 59.1 | [OFFICIAL][DEMONSTRATED] [Meta methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [table transcription, 2026-09-03](https://www.datacamp.com/blog/muse-spark-1-3) |
| AutomationBench v3 | 600 deterministic tasks | 49.4 | 46.7 | 50.3 | [OFFICIAL][DEMONSTRATED] [Meta methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [table transcription, 2026-09-03](https://www.datacamp.com/blog/muse-spark-1-3) |
| MRCR v2, 256K-512K | 100 eight-needle examples, o200k rebinned | 98.5 | 91.5 | NR | [OFFICIAL][DEMONSTRATED] [Meta methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [table transcription, 2026-09-03](https://www.datacamp.com/blog/muse-spark-1-3) |
| MRCR v2, 512K-1M | 100 eight-needle examples, o200k rebinned | 98.1 | 73.8 | NR | [OFFICIAL][DEMONSTRATED] [Meta methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [table transcription, 2026-09-03](https://www.datacamp.com/blog/muse-spark-1-3) |

### Reasoning, knowledge, hallucination, and long-context subtests

At max, an AA-derived breakdown reports Coding 76.3, GPQA Diamond 93.8, Terminal-Bench 2.1 85.8, AA-LCR 79.0, SciCode 57.3, tau3-Banking 52.4, Humanity's Last Exam 49.1, and AA-Omniscience accuracy 44. [COMMUNITY][DEMONSTRATED] [Temperature2 AA transcription, published 2026-09-02, measured 2026-09-04, accessed 2026-09-05](https://temperature2.com/models/muse-spark-1-3/)

Relative to Spark 1.2, AA reports GDPVal rising from 1615 to 1709 at xhigh and 1754 at max, Terminal-Bench rising from about 80 to 85 and 86, and tau3-Banking rising from 35 to 47 and 52. AA-LCR regresses from 83 to 79 at both 1.3 effort settings. [COMMUNITY][DEMONSTRATED] [Artificial Analysis Spark report, published 2026-09-02, accessed 2026-09-05](https://artificialanalysis.ai/articles/muse-spark-1-3/)

AA-Omniscience accuracy falls from 45 for Spark 1.2 to 42 at 1.3 xhigh and 44 at max. AA says xhigh shows higher abstention and lower hallucination, but the full hallucination-rate value was not exposed in the inspected page. [COMMUNITY][DEMONSTRATED] [Artificial Analysis Spark report, published 2026-09-02, accessed 2026-09-05](https://artificialanalysis.ai/articles/muse-spark-1-3/)

### Muse Glimmer 30B benchmark table

Meta evaluated Glimmer mostly at high reasoning with temperature 1, top-p 0.95, and top-k 64. Competitor results were selected from favorable first-party, internal, or public results, so the table is vendor evidence. [OFFICIAL][ASSERTION] [Meta Glimmer methodology, published 2026-08-10, accessed 2026-09-05](https://research.meta.ai/static/muse-glimmer-methodology)

| Area | Benchmark | Glimmer 30B | Effort and harness |
|---|---|---:|---|
| Agentic | MCP Atlas | 75.5 | High, Meta evaluation |
| Agentic | DeepSearch | 74.6 | High, Meta evaluation |
| Agentic | tau3-Banking | 23.5 | High, benchmark harness |
| Agentic | WildClaw | 47.6 | High, Meta evaluation |
| Agentic | GDPVal-AA v2 | 953 | High, AA-style Elo |
| Agentic | GAIA 2 | 43.3 | High |
| Agentic | SkillsBench | 44.3 | High |
| Computer use | OSWorld | 65.9 | High |
| Coding | SWE-bench Pro | 51.2 | High |
| Coding | SWE-bench Verified | 76.0 | High |
| Coding | Terminal-Bench 2.1 | 51.7 | High, Terminus 2 |
| Coding | SciCode | 43.6 | High |
| Vision | CharXiv | 78.8 | High |
| Vision | ScreenSpot | 75.4 | High |
| Vision | OmniDocBench 1.5 | 75.8 | High |
| Vision | MMMU-Pro | 74.0 | High |
| Safety | CI Memories violation | 26.4 | High |
| Safety | CI Memories coverage | 64.8 | High |
| Safety | SIREN attack success | 28.4 | High |
| Safety | SIREN utility | 94.2 | High |
| General | IFBench | 77.0 | High |
| General | AIME | 94.7 | High |
| General | GPQA Diamond | 83.5 | High |
| General | Humanity's Last Exam, text | 22.0 | High |
| Long context | AA-LCR | 80.0 | High |
| Long context | BEAM 128K | 65.1 | High |

Every value in the Glimmer table is [OFFICIAL][DEMONSTRATED] from the [Meta model card, published 2026-08-10, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B?inference_provider=together), with configuration detail from the [Meta methodology, published 2026-08-10, accessed 2026-09-05](https://research.meta.ai/static/muse-glimmer-methodology). No independent reproduction of this complete benchmark table was found.

## 2. Official versus independent deltas

### Frontloaded result

The largest clean delta found is Terminal-Bench 2.1: Meta's native-harness 88.8 versus AA's 85.8, a Meta advantage of 3.0 points. The most plausible explanation is scaffold and harness choice, not necessarily checkpoint difference. [OFFICIAL][DEMONSTRATED] [Meta methods, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [AA transcription, published 2026-09-02, accessed 2026-09-05](https://temperature2.com/models/muse-spark-1-3/)

| Evaluation | Meta or vendor result | Independent result | Delta and explanation |
|---|---:|---:|---|
| Terminal-Bench 2.1, max | 88.8 | 85.8 AA | Meta +3.0. Meta used native coding harnesses and its internal sandbox framework; AA used its standardized evaluation path. [OFFICIAL][DEMONSTRATED] [Meta methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [AA transcription, 2026-09-02](https://temperature2.com/models/muse-spark-1-3/) |
| Terminal-Bench 2.1, xhigh | 89.2 | about 85 AA | Approximately Meta +4. Meta's table is non-monotonic because xhigh exceeds max on this benchmark. [COMMUNITY][DEMONSTRATED] [VentureBeat table analysis, published 2026-09-03, accessed 2026-09-05](https://venturebeat.com/technology/meta-says-muse-spark-1-3-has-frontier-performance-but-its-best-results-come-from-a-model-developers-cant-broadly-use-yet) [COMMUNITY][DEMONSTRATED] [AA report, 2026-09-02](https://artificialanalysis.ai/articles/muse-spark-1-3/) |
| GDPVal-AA v2, max | 1754 | 1754 AA | No visible delta. This is the strongest cross-source agreement. [OFFICIAL][DEMONSTRATED] [Meta methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [AA report, 2026-09-02](https://artificialanalysis.ai/articles/muse-spark-1-3/) |
| DeepSWE v1.1 | 75.4 | No public Spark row found | Cannot calculate. Meta ran Spark itself using mini-swe-agent; competitor rows came from the public Datacurve board. [OFFICIAL][ASSERTION] [Meta methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [board inspection report, 2026-09-03](https://developer.tenten.co/meta-muse-spark-1-3-coding-benchmark) |
| LiveBench overall | No official Meta number | 81.6 xhigh | Independent evidence places Spark below Fable 83.4 and just above Sol 81.0. [COMMUNITY][DEMONSTRATED] [LiveBench, accessed 2026-09-05](https://livebench.ai/?lang=zh-hant) |
| AA-LCR | Official MRCR 98.1 at 512K-1M | AA-LCR 79 | Different benchmark and therefore not a direct contradiction. MRCR is eight-needle retrieval; AA-LCR tests a different long-context reasoning distribution. [OFFICIAL][DEMONSTRATED] [Meta methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [AA report, 2026-09-02](https://artificialanalysis.ai/articles/muse-spark-1-3/) |

Meta explicitly says third-party models may be disadvantaged because its team used “best-effort” harnesses that may not be tuned for them, while it selected the highest comparable values from several provenance types. That disclosure is important because it prevents the official table from being treated as a single controlled tournament. [OFFICIAL][ASSERTION] [Meta evaluation methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)

## 3. Effort curves

### Frontloaded result

Only xhigh and max have useful public Spark 1.3 curves. There is no complete low, medium, high, xhigh, max table with both score and cost.

| Metric | Spark 1.2 xhigh | Spark 1.3 xhigh | Spark 1.3 max | Source and harness |
|---|---:|---:|---:|---|
| AA Intelligence Index | 57 | 61 | 62 | AA v4.1 common harness. [COMMUNITY][DEMONSTRATED] [AA report, 2026-09-02](https://artificialanalysis.ai/articles/muse-spark-1-3/) |
| AA cost per task | NR | $0.55 | NR, max not broadly public | AA weighted task cost. [COMMUNITY][DEMONSTRATED] [AA xhigh page, 2026-09-02](https://artificialanalysis.ai/models/muse-spark-1-3-xhigh) |
| GDPVal-AA v2 | 1615 | 1709 | 1754 | AA and Meta Stirrup-style harness. [COMMUNITY][DEMONSTRATED] [AA report, 2026-09-02](https://artificialanalysis.ai/articles/muse-spark-1-3/) |
| Terminal-Bench 2.1, AA | about 80 | about 85 | about 86 | AA common harness. [COMMUNITY][DEMONSTRATED] [AA report, 2026-09-02](https://artificialanalysis.ai/articles/muse-spark-1-3/) |
| Terminal-Bench 2.1, Meta native | NR | 89.2 | 88.8 | Meta native coding harness, internal sandbox. [COMMUNITY][DEMONSTRATED] [VentureBeat table transcription, 2026-09-03](https://venturebeat.com/technology/meta-says-muse-spark-1-3-has-frontier-performance-but-its-best-results-come-from-a-model-developers-cant-broadly-use-yet) |
| tau3-Banking | 35 | 47 | 52 | AA standardized agentic harness. [COMMUNITY][DEMONSTRATED] [AA report, 2026-09-02](https://artificialanalysis.ai/articles/muse-spark-1-3/) |
| AA-LCR | 83 | 79 | 79 | AA long-context harness. [COMMUNITY][DEMONSTRATED] [AA report, 2026-09-02](https://artificialanalysis.ai/articles/muse-spark-1-3/) |
| AA-Omniscience accuracy | 45 | 42 | 44 | AA knowledge and abstention harness. [COMMUNITY][DEMONSTRATED] [AA report, 2026-09-02](https://artificialanalysis.ai/articles/muse-spark-1-3/) |
| Meta JobBench | NR | 61.2 | 64.9 | 65 tasks, OpenCode and file-aware grader. [COMMUNITY][DEMONSTRATED] [VentureBeat table transcription, 2026-09-03](https://venturebeat.com/technology/meta-says-muse-spark-1-3-has-frontier-performance-but-its-best-results-come-from-a-model-developers-cant-broadly-use-yet) |
| Meta OSWorld 2.0 | NR | 57.2 | 66.9 | 108 tasks, Meta common framework. [COMMUNITY][DEMONSTRATED] [VentureBeat table transcription, 2026-09-03](https://venturebeat.com/technology/meta-says-muse-spark-1-3-has-frontier-performance-but-its-best-results-come-from-a-model-developers-cant-broadly-use-yet) |

Max gives only one AA aggregate point over xhigh, 62 versus 61, while using substantially more reasoning on some tasks. A secondary analysis reports 62 percent more reasoning tokens on GDPVal and 28 percent more on tau3 at max. [COMMUNITY][DEMONSTRATED] [The Decoder, published 2026-09-03, accessed 2026-09-05](https://the-decoder.com/meta-closes-in-on-the-top-with-muse-spark-1-3-and-undercuts-rivals-on-price/)

The routing default should therefore be xhigh. Escalate to max only for high-value agentic or desktop-control tasks after confirming that the selected OpenRouter endpoint actually exposes a matching configuration.

## 4. Token efficiency

### Frontloaded result

Meta's clearest efficiency claim is relative, not absolute: Spark 1.3 used approximately 20 percent fewer tool calls and 25 percent fewer tokens than Spark 1.2 in Meta engineering use. [OFFICIAL][ASSERTION] [Meta Spark launch, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-spark-1-3)

The exact wording is: “using ~20% fewer tool calls and ~25% fewer tokens.” [OFFICIAL][ASSERTION] [Meta Spark launch, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-spark-1-3)

### Measured token indicators

| Model | Token measure | Interpretation |
|---|---:|---|
| Spark 1.3 xhigh | 100M total AA output tokens | Aggregate evaluation output, not per task. [COMMUNITY][DEMONSTRATED] [AA xhigh page, 2026-09-02](https://artificialanalysis.ai/models/muse-spark-1-3-xhigh) |
| Spark 1.3 max | 120M total AA output tokens | About 20 percent above xhigh at aggregate level, but score moves only 61 to 62. [COMMUNITY][DEMONSTRATED] [AA max page, 2026-09-02](https://artificialanalysis.ai/models/muse-spark-1-3) |
| Opus 5 max | 100M total AA output tokens | Same aggregate total as Spark xhigh in the captured page. [COMMUNITY][DEMONSTRATED] [AA Opus page, 2026-07](https://artificialanalysis.ai/models/claude-opus-5) |
| Gemini 3.7 Flash high | 64M total AA output tokens | Lower aggregate output than Spark xhigh. [COMMUNITY][DEMONSTRATED] [AA Gemini page, 2026-08](https://artificialanalysis.ai/models/gemini-3-7-flash) |
| GPT-6 Astra max | 42M total AA output tokens | Lowest captured total among these entries, but its evaluated availability was limited. [COMMUNITY][DEMONSTRATED] [AA Astra page, 2026-09-03](https://artificialanalysis.ai/models/gpt-6-astra/) |
| GPT-5.6 Luna max | 130M total AA output tokens | More aggregate output than Spark xhigh. [COMMUNITY][DEMONSTRATED] [AA Luna page, 2026-07](https://artificialanalysis.ai/models/gpt-5-6-luna) |
| GLM 5.3 Flash | 150M total AA output tokens | More aggregate output than Spark xhigh. [COMMUNITY][DEMONSTRATED] [AA GLM Flash page, 2026-08-26](https://artificialanalysis.ai/models/glm-5-3-flash/) |
| GLM 5.3 | 170M total AA output tokens | Highest captured aggregate total in this comparison. [COMMUNITY][DEMONSTRATED] [AA GLM page, 2026-08](https://artificialanalysis.ai/models/glm-5-3) |
| Kimi K3 max | 130M total AA output tokens | More aggregate output than Spark xhigh. [COMMUNITY][DEMONSTRATED] [AA Kimi page, 2026-08](https://artificialanalysis.ai/models/kimi-k3) |
| Qwen 3.8 flagship | 140M total AA output tokens | More aggregate output than Spark xhigh. [COMMUNITY][DEMONSTRATED] [AA Qwen page, 2026-08](https://artificialanalysis.ai/models/qwen3-8-2-4t-a95b) |

The LiveBench mirror points in the opposite direction for several peers: Spark uses 28,234 output tokens per case versus Sol's 11,729 and Fable's 20,255. Because the mirror's overall scores disagree with LiveBench itself, this is a prompt to measure token use in the actual Claude Code scaffold, not a final efficiency ranking. [COMMUNITY][DEMONSTRATED] [ModelMarkets mirror, accessed 2026-09-05](https://modelmarkets.ai/benchmarks/livebench?model=moonshotai%2FKimi-K3)

No source exposed a stable answer-token versus hidden-reasoning-token percentage for Spark. The only direct local observation is the supplied Glimmer probe, which returned 98 visible reasoning tokens for a one-word answer; that single probe is not representative of task-level reasoning share. [COMMUNITY][DEMONSTRATED] [OpenRouter Glimmer page, accessed 2026-09-05](https://openrouter.ai/meta/muse-glimmer-30b)

## 5. Cost per completed task

### Assumptions

The calculations use the requested per-million-token rates: Spark $1.25/$4.25, Contributor $0.10/$0.20, Glimmer $0.30/$1.10, Sol $2/$10, Terra $2/$12, Luna $0.20/$1.20, Gemini promo $0.375/$1.875, GLM Flash $0.15/$0.50, DeepSeek re-host $0.25/$0.75, Fable $10/$50, and Opus $5/$25.

OpenRouter independently displays Spark at $1.25/$4.25 and Glimmer at $0.30/$1.10. [OFFICIAL][DEMONSTRATED] [OpenRouter Spark comparison, published 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3) [OFFICIAL][DEMONSTRATED] [OpenRouter Glimmer comparison, accessed 2026-09-05](https://openrouter.ai/compare/meta/muse-glimmer-30b/qwen/qwen3.7-max)

Google's $0.375/$1.875 figures are batch or flex promo rates, while standard Gemini 3.7 Flash is $0.75/$3.75 through the documented promotional period. [OFFICIAL][DEMONSTRATED] [Google pricing, published 2026-08-13, accessed 2026-09-05](https://ai.google.dev/gemini-api/docs/pricing?authuser=1)

### Raw token-shape math

The formula is `(input tokens / 1M × input price) + (output tokens / 1M × output price)`.

| Model | 30K input, 3K output coding turn | 200K input review, output excluded | 2K input, 1K output chat |
|---|---:|---:|---:|
| Muse Spark 1.3 | $0.050250 | $0.250000 | $0.006750 |
| Muse Spark 1.3 Contributor | $0.003600 | $0.020000 | $0.000400 |
| Muse Glimmer 30B | $0.012300 | $0.060000 | $0.001700 |
| GPT-5.6 Sol | $0.090000 | $0.400000 | $0.014000 |
| GPT-5.6 Terra | $0.096000 | $0.400000 | $0.016000 |
| GPT-5.6 Luna | $0.009600 | $0.040000 | $0.001600 |
| Gemini 3.7 Flash promo | $0.016875 | $0.075000 | $0.002625 |
| GLM 5.3 Flash | $0.006000 | $0.030000 | $0.000800 |
| DeepSeek V4 Pro re-host | $0.009750 | $0.050000 | $0.001250 |
| Claude Fable 5.1 | $0.450000 | $2.000000 | $0.070000 |
| Claude Opus 5 | $0.225000 | $1.000000 | $0.035000 |

All values in this table are [COMMUNITY][DEMONSTRATED] arithmetic under the stated scenario rates. OpenRouter notes that real costs vary because models tokenize the same material differently and billing follows each model's tokenizer. [OFFICIAL][ASSERTION] [OpenRouter model API documentation, accessed 2026-09-05](https://openrouter.ai/docs/guides/overview/models)

The 200K review column is an input-only floor because no output length was specified. Add the model's output price divided by 1,000 for every additional 1K output tokens.

### Adjustment using measured cost per AA task

| Model | Measured AA cost per task | Quality point | Routing implication |
|---|---:|---:|---|
| Spark 1.3 xhigh | $0.55 | Index 61 | Best verified frontier-adjacent price point in this comparison. [COMMUNITY][DEMONSTRATED] [AA Spark, 2026-09-02](https://artificialanalysis.ai/models/muse-spark-1-3-xhigh) |
| Sol max | $0.95 | Index 61 | Same rounded index, 73 percent higher measured task cost than Spark xhigh. [COMMUNITY][DEMONSTRATED] [AA Sol, 2026-07](https://artificialanalysis.ai/models/releases/gpt-5-6-sol) |
| Opus 5 high | $1.23 | Index 61 | Same rounded index, more than twice Spark xhigh's measured task cost. [COMMUNITY][DEMONSTRATED] [AA Opus, 2026-07](https://artificialanalysis.ai/models/releases/claude-opus-5) |
| Fable 5.1 max | $3.69 | Index 66 | Higher ceiling, about 6.7 times Spark xhigh's task cost. [COMMUNITY][DEMONSTRATED] [AA Fable, 2026-08](https://artificialanalysis.ai/models/releases/claude-fable-5-1) |
| Terra max | $0.53 | Index 57 in release curve | Similar measured cost with a lower aggregate score. [COMMUNITY][DEMONSTRATED] [AA Terra, 2026-07](https://artificialanalysis.ai/models/releases/gpt-5-6-terra) |
| Luna max | $0.05 | Index 52 | Far cheaper, lower ceiling, appropriate for rote work. [COMMUNITY][DEMONSTRATED] [AA Luna, 2026-07](https://artificialanalysis.ai/models/gpt-5-6-luna) |
| Gemini 3.7 Flash high | $0.40 | Index 56 | Cheaper and much faster, but lower text-agent aggregate. [COMMUNITY][DEMONSTRATED] [AA Gemini, 2026-08](https://artificialanalysis.ai/models/gemini-3-7-flash) |
| GLM 5.3 Flash | $0.09 | Index 57 | Strong cheap-executor benchmark, but Contributor's nominal raw-token price is lower. [COMMUNITY][DEMONSTRATED] [AA GLM Flash, 2026-08-26](https://artificialanalysis.ai/models/glm-5-3-flash/) |
| GLM 5.3 max | $0.68 | Index 60 | Close to Spark xhigh, slightly lower index and higher measured cost. [COMMUNITY][DEMONSTRATED] [AA GLM, 2026-08](https://artificialanalysis.ai/models/glm-5-3) |
| Kimi K3 max | $0.84 | Index 60 | Close capability, higher measured cost and slower output. [COMMUNITY][DEMONSTRATED] [AA Kimi, 2026-08](https://artificialanalysis.ai/models/kimi-k3) |
| Grok 4.6 high | $0.94 | Index 61 | Same rounded index at higher measured cost. [COMMUNITY][DEMONSTRATED] [AA Grok comparison, 2026-08](https://artificialanalysis.ai/models/comparisons/grok-4-6-vs-kimi-k3) |
| GPT-6 Astra max | $1.67 | Index 61 | Same rounded index at roughly three times Spark xhigh's measured cost. [COMMUNITY][DEMONSTRATED] [AA Astra, 2026-09-03](https://artificialanalysis.ai/models/gpt-6-astra/) |

Contributor cannot be adjusted accurately from AA because no independent run identifies input, answer, and reasoning-token splits for that endpoint. Applying standard Spark's token behavior to Contributor is plausible if it is exactly the same checkpoint and serving configuration, but that equivalence is asserted by listing metadata rather than independently demonstrated. [OFFICIAL][ASSERTION] [OpenRouter Contributor listing, published 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3-contributor)

## 6. Access, Contributor terms, and the 18+ gate

### Verified OpenRouter versus Meta facts

OpenRouter lists Spark 1.3 with a 1,048,576-token context, text, image, video, file, and audio inputs, plus reasoning, tools, structured output, and related sampling controls. [OFFICIAL][DEMONSTRATED] [OpenRouter Spark listing, published 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3)

Meta independently verifies approximately 1M context and native video, image, and document perception, but the inspected Meta pages do not publish OpenRouter's model ID, $1.25/$4.25 rates, $0.15 cache-read rate, $0.0025 web-search charge, 943,718 maximum output, single-provider topology, moderation flag, or exact supported-parameter array. Those OpenRouter fields are therefore marketplace facts, not Meta-page confirmations. [OFFICIAL][ASSERTION] [Meta Muse page, accessed 2026-09-05](https://ai.meta.com/llama?via=aivyx) [OFFICIAL][DEMONSTRATED] [OpenRouter Spark listing, published 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3)

Meta's official launch says Spark 1.3 is available in Muse Code and Meta Model API, with open weights coming, but it does not publish a Contributor tier or OpenRouter-specific terms. [OFFICIAL][ASSERTION] [Meta Spark launch, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-spark-1-3)

### Age gate verdict

The supplied live probe demonstrates that both Spark endpoints currently require the `age_18plus` attestation. The exact 403 text is:

> “This model requires you to complete the following before use: 18+ age confirmation. Confirm at https://openrouter.ai/settings/preferences.”

[COMMUNITY][DEMONSTRATED] [OpenRouter preference page identified in the error, accessed 2026-09-05](https://openrouter.ai/settings/preferences)

Meta's Glimmer card supplies the closest first-party explanation: “The model is not intended to be downloaded by or used by individuals under the age of 18.” [OFFICIAL][ASSERTION] [Meta Glimmer model card, published 2026-08-10, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B?inference_provider=together)

OpenRouter's general terms say users must be at least 13 and require a parent or guardian's permission when under 18, so 18+ is not a platform-wide minimum. [OFFICIAL][ASSERTION] [OpenRouter terms, published 2026-07-29, accessed 2026-09-05](https://openrouter.ai/terms)

The best-supported interpretation is that OpenRouter records an account-level confirmation required by particular Meta Muse endpoints. It does not imply a higher reasoning setting, relaxed moderation, or consent to Contributor training. OpenRouter did not publish documentation establishing how long the attestation is retained, whether organizations inherit it, or an exhaustive list of every gated model.

The supplied Glimmer probe succeeded through DeepInfra without the same 403 despite Meta's under-18 model-card sentence. This is an observed marketplace inconsistency, not evidence that Glimmer's policy language is absent. [COMMUNITY][DEMONSTRATED] [OpenRouter Glimmer listing, accessed 2026-09-05](https://openrouter.ai/meta/muse-glimmer-30b) [OFFICIAL][ASSERTION] [Meta Glimmer card, published 2026-08-10, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B?inference_provider=together)

## 7. Routing matrix

| Role | Spark 1.3 | Contributor | Glimmer 30B | Deciding evidence and confidence |
|---|---|---|---|---|
| Orchestrator | **COMPLEMENTS** | **LOSES** for sensitive orchestration | **LOSES** | Fable max leads AA 66 to Spark max 62 and LiveBench 83.4 to 81.6. High confidence. [COMMUNITY][DEMONSTRATED] [AA Spark report, 2026-09-02](https://artificialanalysis.ai/articles/muse-spark-1-3/) [COMMUNITY][DEMONSTRATED] [LiveBench, accessed 2026-09-05](https://livebench.ai/?lang=zh-hant) |
| Implementation that ships | **COMPLEMENTS** | **COMPLEMENTS** only for non-sensitive repos | **LOSES** | Spark has vendor DeepSWE 75.4 and independent LiveBench coding 81.1, but no public DeepSWE row; Glimmer TBench is 51.7. Medium confidence. [OFFICIAL][DEMONSTRATED] [Meta methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [COMMUNITY][DEMONSTRATED] [LiveBench](https://livebench.ai/?lang=zh-hant) [OFFICIAL][DEMONSTRATED] [Glimmer card, 2026-08-10](https://huggingface.co/meta-models/Muse-Glimmer-30B?inference_provider=together) |
| Mechanical bulk | **LOSES** on price | **DISPLACES** when data is safe | **COMPLEMENTS** locally | Contributor costs $0.0036 for the 30K/3K shape versus GLM Flash $0.006 and Luna $0.0096. High price confidence, medium quality-equivalence confidence. [OFFICIAL][DEMONSTRATED] [Contributor listing, 2026-09-02](https://openrouter.ai/meta/muse-spark-1.3-contributor) |
| Mission-critical review gate | **COMPLEMENTS** as a second pass | **LOSES** due data terms | **LOSES** | Fable has higher aggregate and coding scores; Opus has higher Meta GDPVal, JobBench, and OSWorld results. High confidence. [COMMUNITY][DEMONSTRATED] [AA comparison, 2026-09-02](https://www.toolbit.ai/updates/models/muse-spark-1-3) [COMMUNITY][DEMONSTRATED] [Meta table transcription, 2026-09-03](https://www.datacamp.com/blog/muse-spark-1-3) |
| Independent review seat | **LOSES** | **LOSES** | **LOSES** | Glimmer is distilled from Spark, so the three Muse routes do not provide cross-family independence. High confidence. [OFFICIAL][ASSERTION] [Meta Glimmer announcement, 2026-08-10](https://research.meta.ai/blog/introducing-muse-glimmer-open-agentic-model) |
| Video and multimodal | **COMPLEMENTS**, after access works | **COMPLEMENTS** for non-sensitive media | **LOSES** on video and audio | Spark has native multimodal input but no published video or audio score; Glimmer is text and image only; Gemini has documented video processing. High confidence for routing, low confidence on comparative visual quality. [OFFICIAL][ASSERTION] [Meta Muse page](https://ai.meta.com/llama?via=aivyx) [OFFICIAL][DEMONSTRATED] [Google video docs, 2026-09-04](https://ai.google.dev/gemini-api/docs/generate-content/video-understanding?authuser=31&hl=en) |
| Long-context dumps | **COMPLEMENTS**, potentially displaces text-only Gemini jobs | **DISPLACES** when non-sensitive | **LOSES** beyond 131K | Spark MRCR is 98.1 at 512K-1M; Glimmer context is 131,072+. High confidence for retrieval, medium for synthesis. [OFFICIAL][DEMONSTRATED] [Meta Spark methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) [OFFICIAL][DEMONSTRATED] [Glimmer card, 2026-08-10](https://huggingface.co/meta-models/Muse-Glimmer-30B?inference_provider=together) |
| Cheap opinion seat | **LOSES** standard-price contest | **DISPLACES** on price when data is safe | **COMPLEMENTS** as private local opinion | Contributor chat shape costs $0.0004, below GLM Flash $0.0008 and the DeepSeek re-host scenario $0.00125. High price confidence. [OFFICIAL][DEMONSTRATED] [Contributor listing, 2026-09-02](https://openrouter.ai/meta/muse-spark-1.3-contributor) |
| Bulk structured extraction | **LOSES** on price | **DISPLACES** for public or sanitised documents | **COMPLEMENTS** locally | OpenRouter lists structured output and file input for Spark, and Contributor has the lowest scenario cost. High feature confidence, medium extraction-quality confidence because no extraction benchmark was found. [OFFICIAL][DEMONSTRATED] [OpenRouter Spark listing, 2026-09-02](https://openrouter.ai/meta/muse-spark-1.3) |
| Local model | **LOSES**, no weights yet | **LOSES**, hosted data-discount route | **DISPLACES or COMPLEMENTS**, depending on memory | Glimmer has Apache 2.0 weights, 17 GB quantization, and measured 26.4 GB peak at 128K on M4 Max. High confidence. [OFFICIAL][DEMONSTRATED] [Meta card, 2026-08-10](https://huggingface.co/meta-models/Muse-Glimmer-30B?inference_provider=together) [COMMUNITY][DEMONSTRATED] [oMLX, 2026-08-11](https://omlx.ai/benchmarks/performance/1pql8mxy) |
| Non-English, including Hungarian | **COMPLEMENTS**, unproven for Hungarian | **COMPLEMENTS** on non-sensitive text | **COMPLEMENTS**, not a demonstrated winner | Glimmer claims 100+ languages and Spark 1.2 has multilingual Arena scores, but Hungarian is absent. Low confidence. [OFFICIAL][ASSERTION] [Meta Glimmer announcement, 2026-08-10](https://research.meta.ai/blog/introducing-muse-glimmer-open-agentic-model) [COMMUNITY][DEMONSTRATED] [Spark 1.2 Arena snapshot](https://modeligent.com/models/muse-spark-1.2) |

## 8. Muse multimodal input versus Gemini 3.7 Flash

### Frontloaded result

Gemini remains the production video route. Spark is interesting as a multimodal agent with a real execution environment, but its public evidence is demos, Arena placement for 1.2, and broad capability claims, not standardized video or audio evaluation.

Meta says Spark perceives video, images, and documents and performs visual reasoning through a real execution environment. [OFFICIAL][ASSERTION] [Meta Muse page, accessed 2026-09-05](https://ai.meta.com/llama?via=aivyx)

Meta's Spark 1.2 release describes visual reasoning over charts, audio-visual material, and video-heavy enterprise workflows. [OFFICIAL][ASSERTION] [Meta Spark 1.2 multimodal article, published 2026-08-20, accessed 2026-09-05](https://research.meta.ai/blog/multimodal-intelligence-of-muse-spark-1-2)

A third-party report of Design Arena results places Spark 1.2 first in video-to-website, second in image-to-HTML, and third in image-to-frontend, with Elo above 1250, but it does not provide the full model-by-model score table or sampling details. [COMMUNITY][ASSERTION] [TipRanks report, published 2026-08-21, accessed 2026-09-05](https://www.tipranks.com/news/private-companies/metas-muse-spark-1-2-gains-top-rankings-in-multimodal-coding-benchmarks)

Spark 1.2's captured LMArena Vision score is 1290 plus or minus 18 over 1,282 votes. No corresponding Spark 1.3 Vision row was found. [COMMUNITY][DEMONSTRATED] [No Way snapshot, published 2026-09-03, accessed 2026-09-05](https://no-way.dev/benchmarks)

Roboflow lists Spark 1.3 as number 10 of 52 in its visual model catalog but exposes no task score in the inspected result, so it is not usable as a comparative benchmark. [COMMUNITY][ASSERTION] [Roboflow model page, published 2026-09-03, accessed 2026-09-05](https://playground.roboflow.com/models/meta/muse-spark-1-3)

One third-party deployment document says Spark 1.3 audio input is unsupported even though OpenRouter's listing includes audio. This is a provider-interface conflict, not proof that the base model lacks audio perception. [COMMUNITY][ASSERTION] [Empirio deployment notes, published 2026-09-02, accessed 2026-09-05](https://docs.empiriolabs.ai/models/muse-spark-1-3) [OFFICIAL][DEMONSTRATED] [OpenRouter Spark listing, published 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3)

Glimmer accepts text and image, uses up to 4,096 visual tokens per image, and does not claim audio support. [OFFICIAL][DEMONSTRATED] [Meta Glimmer card, published 2026-08-10, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B?inference_provider=together)

### Gemini video cost per minute

Google's legacy static accounting is 263 video tokens per second. At the requested $0.375 per million input-token promo rate, one minute is 15,780 tokens and costs approximately $0.0059175. At the $0.75 standard rate, it costs approximately $0.011835. [OFFICIAL][DEMONSTRATED] [Google token documentation, published 2026-09-04, accessed 2026-09-05](https://ai.google.dev/gemini-api/docs/generate-content/tokens) [OFFICIAL][DEMONSTRATED] [Google pricing, published 2026-08-13, accessed 2026-09-05](https://ai.google.dev/gemini-api/docs/pricing?authuser=1)

Google's newer static guidance is approximately 100 tokens per second at low resolution and 300 at high resolution. At promo rates, those equal approximately $0.00225 and $0.00675 per minute. At standard rates, they equal approximately $0.0045 and $0.0135 per minute. [OFFICIAL][DEMONSTRATED] [Google token documentation, published 2026-09-04, accessed 2026-09-05](https://ai.google.dev/gemini-api/docs/tokens)

Google says agentic video processing can use up to 88 percent fewer tokens depending on the video and query, so no single agentic per-minute figure is defensible. [OFFICIAL][ASSERTION] [Google video documentation, published 2026-09-04, accessed 2026-09-05](https://ai.google.dev/gemini-api/docs/generate-content/video-understanding?authuser=31&hl=en)

No Muse frame-sampling rate or video-token accounting rule was found, so Muse's price per minute cannot be calculated from its per-token price without inventing a conversion.

## 9. Glimmer local performance and deployment fit

Glimmer is a dense 29.6B-parameter model including a 1.8B vision encoder, with 52 transformer layers, a 202,048-token vocabulary, 131,072-plus context, and an Apache 2.0 license. [OFFICIAL][DEMONSTRATED] [Meta model card, published 2026-08-10, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B?inference_provider=together)

Meta reports a 17 GB K-Quant build with about 1.0 percent quality degradation, and a dynamic K-Quant under 20 GB with about 0.2 percent degradation. [OFFICIAL][DEMONSTRATED] [Meta model card, published 2026-08-10, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B?inference_provider=together)

Meta's batch-one greedy measurements report 23.7 t/s baseline and 37.8 t/s with DFlash on M4 Max, plus 26.6 and 50.2 t/s on M5 Max. [OFFICIAL][DEMONSTRATED] [Meta model card, published 2026-08-10, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B?inference_provider=together)

Independent oMLX measurements on a 128 GB, 40-core M4 Max at 4-bit quantization show:

| Context | Prompt processing | Generation | Peak memory |
|---:|---:|---:|---:|
| 1K | 238.9 t/s | 25.9 t/s | 19.9 GB |
| 4K | 198.0 t/s | 22.8 t/s | 20.1 GB |
| 8K | 121.5 t/s | 10.7 t/s | 20.3 GB |
| 16K | 126.2 t/s | 18.2 t/s | 20.7 GB |
| 32K | 145.3 t/s | 18.8 t/s | 21.6 GB |
| 64K | 146.7 t/s | 18.4 t/s | 23.2 GB |
| 128K | 130.9 t/s | 16.8 t/s | 26.4 GB |

Every value in the preceding table is [COMMUNITY][DEMONSTRATED] from [oMLX, published 2026-08-11, accessed 2026-09-05](https://omlx.ai/benchmarks/performance/1pql8mxy). The run disabled thinking, so it is a throughput and memory measurement, not a reasoning-quality result.

An LMSYS community implementation measured 15.3 to 17.6 t/s for 4-bit variants on Apple M5 Pro without the DFlash MLX optimization. [COMMUNITY][DEMONSTRATED] [LMSYS Glimmer deployment report, published 2026-08-10, accessed 2026-09-05](https://www.lmsys.org/blog/2026-08-10-meta-muse-glimmer)

## 10. Benchmark hygiene

### Frontloaded result

No Muse-specific counterpart to the 2025 Llama 4 Arena release-model controversy was found by the cutoff. Muse nevertheless warrants caution because Meta uses mixed score provenance, private or internal harnesses, highest-comparable selection, and a max configuration that is not clearly available through OpenRouter.

In 2025, Meta submitted an experimental Llama 4 Maverick version to LMArena rather than the publicly released default model. TechCrunch reported that the normal Maverick ranked substantially lower after LMArena changed its policies. [COMMUNITY][DEMONSTRATED] [TechCrunch, published 2025-04-11, accessed 2026-09-05, older than preferred window](https://techcrunch.com/2025/04/11/metas-vanilla-maverick-ai-model-ranks-below-rivals-on-a-popular-chat-benchmark/)

The Leaderboard Illusion paper reported undisclosed private testing and said Meta tested 27 model variants during the relevant period before revealing the strongest one. [COMMUNITY][DEMONSTRATED] [arXiv paper, published 2025-04-28, accessed 2026-09-05, older than preferred window](https://arxiv.org/abs/2504.20879)

A separate report summarized the allegation that private access and repeated submissions allowed major labs to optimize toward Arena's preference distribution. [COMMUNITY][ASSERTION] [TechCrunch, published 2025-04-30, accessed 2026-09-05, older than preferred window](https://techcrunch.com/2025/04/30/study-accuses-lm-arena-of-helping-top-ai-labs-game-its-benchmark/)

LMArena later showed that controlling for response style and sentiment reduced Maverick Experimental's apparent advantage, supporting the view that presentation preferences affected the original ranking. [OFFICIAL][DEMONSTRATED] [LMArena analysis, published 2025-04-22, updated 2026-03-02, accessed 2026-09-05](https://news.lmarena.ai/sentiment-control/)

No evidence was found that Meta submitted a custom Muse Spark 1.3 Arena variant, concealed 1.3 variants, or substituted a non-public checkpoint under the same name. The more immediate Muse concern is simpler: there is no visible 1.3 Arena row.

Meta's Spark methodology openly says it uses the highest comparable score from internal runs, leaderboards, and provider self-reports, while admitting competitor harnesses may not be optimized. [OFFICIAL][ASSERTION] [Meta methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)

Meta's original Muse Spark report also said Apollo Research observed unusually high evaluation awareness, including recognition of alignment traps and the possibility of changing behavior under evaluation. This is not proof of benchmark contamination, but it increases the value of hidden, repository-specific tests. [OFFICIAL][ASSERTION] [Meta Muse Spark launch, published 2026-04-08, accessed 2026-09-05](https://ai.meta.com/blog/introducing-muse-spark-msl/)

### Evidence grading

| Evidence type | What it establishes | Main limitation |
|---|---|---|
| Artificial Analysis | Common cross-model harness, effort and token-cost accounting | Provider performance and board values can change; not every max configuration is public. [COMMUNITY][ASSERTION] [AA methodology page, accessed 2026-09-05](https://artificialanalysis.ai/models/comparisons/gpt-5-6-terra-vs-step-3-7-flash) |
| LiveBench | Independent category-level results and cost per successful task | Snapshot and normalization differ across mirrors. [COMMUNITY][DEMONSTRATED] [LiveBench, accessed 2026-09-05](https://livebench.ai/?lang=zh-hant) |
| Meta Spark table | Best-case capability under Meta-selected harnesses | Mixed provenance and favorable score selection. [OFFICIAL][ASSERTION] [Meta methods, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology) |
| LMArena | Human pairwise preference at scale | Sensitive to style, identity, sampling population, and variant selection. [OFFICIAL][DEMONSTRATED] [LMArena style analysis, updated 2026-03-02](https://news.lmarena.ai/sentiment-control/) |
| Local Glimmer tests | Memory and throughput on Apple hardware | Do not establish coding or reasoning quality. [COMMUNITY][DEMONSTRATED] [oMLX, 2026-08-11](https://omlx.ai/benchmarks/performance/1pql8mxy) |
| Supplied OpenRouter probes | Actual route accessibility, provider, latency, and returned reasoning metadata | Single-request observations, not statistical performance measurements. [COMMUNITY][DEMONSTRATED] [OpenRouter Glimmer page, accessed 2026-09-05](https://openrouter.ai/meta/muse-glimmer-30b) |

## Not found after searching

The sweep did not find the following. Absence means no defensible public number was located by 2026-09-05, not that the model cannot perform the task.

- **Muse Spark 1.3 on LMArena Text, Vision, WebDev, or Search Arena.** Queries included `"Muse Spark 1.3" LMArena`, `"Muse Spark 1.3" Chatbot Arena`, `"Muse Spark 1.3" Vision Arena`, `"Muse Spark 1.3" WebDev Arena`, and `"Muse Spark 1.3" Search Arena`.

- **Spark 1.3 SWE-bench Verified or SWE-bench Pro.** Queries included `"Muse Spark 1.3" SWE-bench Verified`, `"Muse Spark 1.3" SWE-bench Pro`, `site:swebench.com "Muse Spark 1.3"`, and `site:scale.com "Muse Spark 1.3" SWE`. A secondary benchmark inventory also reports no published SWE-bench Verified result. [COMMUNITY][ASSERTION] [Mungomash benchmark inventory, published 2026-09-04, accessed 2026-09-05](https://mungomash.com/ai/benchmarks/)

- **Spark 1.3 Terminal-Bench 4.** Queries included `"Muse Spark 1.3" "Terminal-Bench 4"` and `site:terminal-bench.com "Muse Spark"`. A third-party comparison likewise says no Muse result was available. [COMMUNITY][ASSERTION] [Codersera comparison, published 2026-09-03, accessed 2026-09-05](https://codersera.com/blog/muse-spark-1-3-vs-claude-opus-5-2026/)

- **Spark or Glimmer Aider Polyglot.** Queries included `"Muse Spark 1.3" Aider polyglot`, `"Muse Glimmer 30B" Aider`, and `site:aider.chat "Muse Spark"`.

- **Spark or Glimmer LiveCodeBench.** Queries included `"Muse Spark 1.3" LiveCodeBench`, `"Muse Glimmer 30B" LiveCodeBench`, and `site:livecodebench.github.io "Muse"`.

- **Spark 1.3 ARC-AGI-2 or ARC-AGI-3.** Queries included `"Muse Spark 1.3" ARC-AGI-2`, `"Muse Spark 1.3" ARC-AGI-3`, and `site:arcprize.org "Muse Spark"`.

- **Spark 1.3 MMMU or MMMU-Pro.** Queries included `"Muse Spark 1.3" MMMU` and `"Muse Spark 1.3" MMMU-Pro`. Glimmer's official MMMU-Pro 74.0 is available, but it cannot be transferred to Spark. [OFFICIAL][DEMONSTRATED] [Meta Glimmer card, published 2026-08-10, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B?inference_provider=together)

- **Spark Video-MME, MVBench, LongVideoBench, or an equivalent standardized video score.** Queries included `"Muse Spark 1.3" Video-MME`, `"Muse Spark 1.3" video benchmark`, `"Muse Spark 1.2" Video-MME`, and `"Muse Spark" LongVideoBench`.

- **Spark audio-understanding benchmarks.** Queries included `"Muse Spark 1.3" audio benchmark`, `"Muse Spark 1.3" AudioBench`, `"Muse Spark" MMAU`, and `"Muse Spark" speech benchmark`.

- **Spark BrowseComp.** Queries included `"Muse Spark 1.3" BrowseComp`, `site:openai.com BrowseComp "Muse Spark"`, and `"Muse Spark" browsing benchmark`.

- **Spark METR time horizon.** Queries included `"Muse Spark 1.3" METR time horizon`, `site:metr.org "Muse Spark"`, and `"Muse Spark" task horizon`.

- **A Hungarian-specific score.** Queries included `"Muse Spark" Hungarian benchmark`, `"Muse Glimmer" Hungarian`, `"Muse Spark" magyar`, and `"Muse Spark" multilingual benchmark Hungarian`.

- **Contributor-specific independent benchmark results.** Queries included `"Muse Spark 1.3 Contributor" benchmark`, `"Muse Spark 1.3 Contributor" Artificial Analysis`, and `"Muse Spark Contributor" LiveBench`. The inference that Contributor matches standard Spark depends on OpenRouter metadata.

- **A published reasoning-token percentage for Spark.** Queries included `"Muse Spark 1.3" reasoning tokens`, `"Muse Spark 1.3" token efficiency`, and `"Muse Spark 1.3" reasoning token share`.

- **Muse video price per minute.** Queries included `"Muse Spark" video tokenization`, `"Muse Spark" video tokens per second`, and `"Meta Model API" Muse video pricing`.

- **An official OpenRouter definition of `missing_attestation_types`, `age_18plus`, storage duration, organization inheritance, or an exhaustive gated-model list.** Queries included `site:openrouter.ai/docs age_18plus`, `site:openrouter.ai "missing_attestation_types"`, and `site:openrouter.ai/docs attestation age confirmation`.

- **A Meta page confirming OpenRouter's exact Spark rates, cache rate, web-search fee, 943,718 maximum output, moderation flag, or complete supported-parameter list.** Queries included `site:ai.meta.com Muse Spark API pricing`, `site:research.meta.ai Muse Spark context max output`, and `site:developers.meta.com Muse Spark pricing`.

- **An independent reproduction of Glimmer's official SWE-bench, Terminal-Bench, MMMU-Pro, or agentic table.** Queries included `"Muse Glimmer 30B" independent benchmark`, `"Muse Glimmer 30B" SWE-bench reproduction`, and `"Muse Glimmer 30B" Terminal-Bench independent`.

## Sources

- [Meta, Muse Spark 1.3 launch, 2026-09-02](https://research.meta.ai/blog/introducing-muse-spark-1-3)
- [Meta, Spark 1.3 evaluation methodology, 2026-09-02](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)
- [Meta, Muse platform page, accessed 2026-09-05](https://ai.meta.com/llama?via=aivyx)
- [Meta, original Muse Spark launch, 2026-04-08](https://ai.meta.com/blog/introducing-muse-spark-msl/)
- [Meta, Spark 1.2 multimodal article, 2026-08-20](https://research.meta.ai/blog/multimodal-intelligence-of-muse-spark-1-2)
- [Meta, Glimmer announcement, 2026-08-10](https://research.meta.ai/blog/introducing-muse-glimmer-open-agentic-model)
- [Meta, Glimmer model card, 2026-08-10](https://huggingface.co/meta-models/Muse-Glimmer-30B?inference_provider=together)
- [Meta, Glimmer evaluation methodology, 2026-08-10](https://research.meta.ai/static/muse-glimmer-methodology)
- [OpenRouter, Muse Spark 1.3, 2026-09-02](https://openrouter.ai/meta/muse-spark-1.3)
- [OpenRouter, Muse Spark 1.3 Contributor, 2026-09-02](https://openrouter.ai/meta/muse-spark-1.3-contributor)
- [OpenRouter, Muse Spark 1.2, 2026-08-05](https://openrouter.ai/meta/muse-spark-1.2)
- [OpenRouter, Muse Glimmer 30B, 2026-08-09](https://openrouter.ai/meta/muse-glimmer-30b)
- [OpenRouter, Glimmer comparison page, accessed 2026-09-05](https://openrouter.ai/compare/meta/muse-glimmer-30b/qwen/qwen3.7-max)
- [OpenRouter, Glimmer batch variant, 2026-08-09](https://openrouter.ai/meta/muse-glimmer-30b%3Abatch)
- [OpenRouter, terms, 2026-07-29](https://openrouter.ai/terms)
- [OpenRouter, preferences, accessed 2026-09-05](https://openrouter.ai/settings/preferences)
- [OpenRouter, model documentation, accessed 2026-09-05](https://openrouter.ai/docs/guides/overview/models)
- [Artificial Analysis, Spark 1.3 report, 2026-09-02](https://artificialanalysis.ai/articles/muse-spark-1-3/)
- [Artificial Analysis, Spark 1.3 xhigh, 2026-09-02](https://artificialanalysis.ai/models/muse-spark-1-3-xhigh)
- [Artificial Analysis, Spark 1.3 max, 2026-09-02](https://artificialanalysis.ai/models/muse-spark-1-3)
- [Artificial Analysis, Spark provider measurements, accessed 2026-09-05](https://artificialanalysis.ai/models/muse-spark-1-3-xhigh/providers)
- [Artificial Analysis, Fable 5.1 release, 2026-08](https://artificialanalysis.ai/models/releases/claude-fable-5-1)
- [Artificial Analysis, Opus 5 release, 2026-07](https://artificialanalysis.ai/models/releases/claude-opus-5)
- [Artificial Analysis, Opus 5 model page, 2026-07](https://artificialanalysis.ai/models/claude-opus-5)
- [Artificial Analysis, Sol release, 2026-07](https://artificialanalysis.ai/models/releases/gpt-5-6-sol)
- [Artificial Analysis, Terra release, 2026-07](https://artificialanalysis.ai/models/releases/gpt-5-6-terra)
- [Artificial Analysis, Luna, 2026-07](https://artificialanalysis.ai/models/gpt-5-6-luna)
- [Artificial Analysis, Astra, 2026-09-03](https://artificialanalysis.ai/models/gpt-6-astra/)
- [Artificial Analysis, Gemini 3.7 Flash, 2026-08](https://artificialanalysis.ai/models/gemini-3-7-flash)
- [Artificial Analysis, Gemini 3.1 Pro Preview, 2026-02](https://artificialanalysis.ai/models/gemini-3-1-pro-preview/)
- [Artificial Analysis, DeepSeek V4 Pro, 2026-08](https://artificialanalysis.ai/models/deepseek-v4-pro)
- [Artificial Analysis, GLM 5.3, 2026-08](https://artificialanalysis.ai/models/glm-5-3)
- [Artificial Analysis, GLM 5.3 Flash, 2026-08-26](https://artificialanalysis.ai/models/glm-5-3-flash/)
- [Artificial Analysis, Kimi K3, 2026-08](https://artificialanalysis.ai/models/kimi-k3)
- [Artificial Analysis, Qwen 3.8 flagship, 2026-08](https://artificialanalysis.ai/models/qwen3-8-2-4t-a95b)
- [Artificial Analysis, Qwen 3.8 27B, 2026-08](https://artificialanalysis.ai/models/qwen3-8-27b)
- [Artificial Analysis, Grok 4.6 comparison, 2026-08](https://artificialanalysis.ai/models/comparisons/grok-4-6-vs-kimi-k3)
- [Artificial Analysis, evaluation methodology page, accessed 2026-09-05](https://artificialanalysis.ai/models/comparisons/gpt-5-6-terra-vs-step-3-7-flash)
- [LiveBench, release 2026-06-25, accessed 2026-09-05](https://livebench.ai/?lang=zh-hant)
- [ModelMarkets, LiveBench mirror, accessed 2026-09-05](https://modelmarkets.ai/benchmarks/livebench?model=moonshotai%2FKimi-K3)
- [DataCamp, Spark 1.3 benchmark table transcription, 2026-09-03](https://www.datacamp.com/blog/muse-spark-1-3)
- [Temperature2, AA Spark breakdown, 2026-09-02](https://temperature2.com/models/muse-spark-1-3/)
- [Toolbit, AA Spark comparison, 2026-09-02](https://www.toolbit.ai/updates/models/muse-spark-1-3)
- [VentureBeat, max versus xhigh analysis, 2026-09-03](https://venturebeat.com/technology/meta-says-muse-spark-1-3-has-frontier-performance-but-its-best-results-come-from-a-model-developers-cant-broadly-use-yet)
- [The Decoder, effort-token analysis, 2026-09-03](https://the-decoder.com/meta-closes-in-on-the-top-with-muse-spark-1-3-and-undercuts-rivals-on-price/)
- [AnotherWrapper, Terminal-Bench compilation, 2026-09-03](https://anotherwrapper.com/tools/llm-pricing/evals/terminal-bench-2-1)
- [Tenten, DeepSWE public-board inspection, 2026-09-03](https://developer.tenten.co/meta-muse-spark-1-3-coding-benchmark)
- [Modeligent, Spark 1.2 Arena snapshot, date not visible](https://modeligent.com/models/muse-spark-1.2)
- [No Way, Arena snapshot, 2026-09-03](https://no-way.dev/benchmarks)
- [Roboflow, Spark 1.3 visual catalog, 2026-09-03](https://playground.roboflow.com/models/meta/muse-spark-1-3)
- [Empirio, Spark 1.3 deployment notes, 2026-09-02](https://docs.empiriolabs.ai/models/muse-spark-1-3)
- [TipRanks, Design Arena report, 2026-08-21](https://www.tipranks.com/news/private-companies/metas-muse-spark-1-2-gains-top-rankings-in-multimodal-coding-benchmarks)
- [oMLX, Glimmer Apple benchmark, 2026-08-11](https://omlx.ai/benchmarks/performance/1pql8mxy)
- [LMSYS, Glimmer deployment benchmark, 2026-08-10](https://www.lmsys.org/blog/2026-08-10-meta-muse-glimmer)
- [Google, Gemini pricing, 2026-08-13](https://ai.google.dev/gemini-api/docs/pricing?authuser=1)
- [Google, token documentation, 2026-09-04](https://ai.google.dev/gemini-api/docs/tokens)
- [Google, generate-content token documentation, 2026-09-04](https://ai.google.dev/gemini-api/docs/generate-content/tokens)
- [Google, video understanding, 2026-09-04](https://ai.google.dev/gemini-api/docs/generate-content/video-understanding?authuser=31&hl=en)
- [Mungomash, benchmark inventory, 2026-09-04](https://mungomash.com/ai/benchmarks/)
- [Codersera, Spark versus Opus comparison, 2026-09-03](https://codersera.com/blog/muse-spark-1-3-vs-claude-opus-5-2026/)
- [TechCrunch, Llama 4 Arena model mismatch, 2025-04-11, older source](https://techcrunch.com/2025/04/11/metas-vanilla-maverick-ai-model-ranks-below-rivals-on-a-popular-chat-benchmark/)
- [TechCrunch, Arena gaming allegations, 2025-04-30, older source](https://techcrunch.com/2025/04/30/study-accuses-lm-arena-of-helping-top-ai-labs-game-its-benchmark/)
- [The Leaderboard Illusion, arXiv, 2025-04-28, older source](https://arxiv.org/abs/2504.20879)
- [LMArena, sentiment-control analysis, 2025-04-22, updated 2026-03-02](https://news.lmarena.ai/sentiment-control/)