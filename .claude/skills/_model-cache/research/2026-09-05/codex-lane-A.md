# Lane A: Meta Muse model family from Meta and Meta Superintelligence Labs, research cutoff 2026-09-05

## TLDR: decisions for our routing

1. **Treat Muse Spark 1.3 as an experimental specialist for long-horizon coding, computer use, and research, not as a default implementation model.** [OFFICIAL][DEMONSTRATED] Meta reports that Spark 1.3 materially outperforms 1.2 on every disclosed benchmark and reaches 75.4 on DeepSWE v1.1, 88.8 on TerminalBench 2.1, and 98.1 on the 512K to 1M MRCR2 band. The evaluations used maximum reasoning and often model-native harnesses, so they do not establish a harness-neutral advantage over the current roster. [Meta, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-spark-1-3), [methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)

2. **Do not activate the Contributor route for private repositories, credentials, customer data, or unpublished work.** [COMMUNITY][ASSERTION] OpenRouter states: “Prompts and outputs may be used to improve Meta’s products.” Its public listing otherwise presents the Contributor route as the same Spark 1.3 model at substantially lower prices. No accessible Meta policy disclosed retention, human review, opt-out, deletion, or training exclusions. [OpenRouter, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3-contributor)

3. **The supplied Spark prices agree with OpenRouter, but they are not verified as Meta’s direct API prices.** [COMMUNITY][DEMONSTRATED] OpenRouter lists Spark 1.3 standard at $1.25 per million input tokens, $4.25 per million output tokens, and $0.15 per million cached input tokens. Contributor is $0.10, $0.20, and $0.002 respectively. [OpenRouter standard, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3), [OpenRouter Contributor, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3-contributor) [OFFICIAL][ASSERTION] Meta’s public cookbook instead calls the Meta Model API preview “free”; the first-party pricing portal was login-gated, so a direct numerical comparison could not be completed. [Meta cookbook, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-model-cookbook/blob/main/README.md)

4. **The current 403 is an account attestation gate, not evidence that Spark itself or the Meta upstream was unavailable.** [COMMUNITY][DEMONSTRATED] The 2026-09-05 probe returned HTTP 403 with: “This model requires you to complete the following before use: 18+ age confirmation. Confirm at https://openrouter.ai/settings/preferences.” The metadata was `missing_attestation_types ["age_18plus"]`. OpenRouter visibly marks Spark 1.1, 1.2, 1.2 Contributor, 1.3, and 1.3 Contributor as 18+ models. [OpenRouter model catalog, accessed 2026-09-05](https://openrouter.ai/models?fmt=cards&input_modalities=video&q=t) [OFFICIAL][ASSERTION] Meta’s Glimmer card says: “Muse Glimmer is not intended for individuals under the age of 18.” No accessible Meta source was found that applies that exact clause to Spark or explains OpenRouter’s attestation implementation. [Meta model card, published 2026-08, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B)

5. **For sensitive workloads, use Spark standard only after accepting the age gate, and regard Contributor as a separate data-governance decision.** [COMMUNITY][ASSERTION] The price differential is explicitly coupled to possible product-improvement use of prompts and outputs. OpenRouter does not disclose a reduced model, smaller context, or feature restriction on the Contributor page. That is an omission, not an official quality-equivalence guarantee from Meta. [OpenRouter Contributor, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3-contributor)

6. **Muse Glimmer 30B is the practical Apple-silicon candidate, provided the Mac has at least 24 GB of unified memory and expectations are set below Spark.** [OFFICIAL][ASSERTION] Meta recommends approximately 24 GB to 32 GB for quantized local use, with BF16 requiring about 59 GB to 60 GB and Q4 or INT4 artifacts about 16 GB to 17 GB before runtime overhead. Meta explicitly positions Glimmer as less capable than Spark. [Meta OSS cookbook, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-oss-cookbook/blob/main/README.md) [OFFICIAL][DEMONSTRATED] Meta’s computer-use recipe observed about 25 GB for a quantized model, projector, and 128K cache. [Meta recipe, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-oss-cookbook/blob/main/recipes/computer-use-web/README.md)

7. **Use Glimmer locally for cheap text, image, tool, and autonomous-agent work, but not as the audio or video seat.** [OFFICIAL][ASSERTION] Its official card supports text and images as input and text as output. Audio input and output are unsupported. Video is not explicitly optimized and is handled as individual frames. [Meta model card, published 2026-08, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B)

8. **Set Spark reasoning effort explicitly and reserve high effort for tasks that justify output-token cost.** [OFFICIAL][ASSERTION] Meta’s cookbook documents `minimal`, `low`, `medium`, and `high`, says `xhigh` is accepted but currently maps to `high`, and says the default is still being finalized. Reasoning tokens count against the output budget and are billed as output tokens. [Meta reasoning notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/06_reasoning_tokens.ipynb)

9. **Do not design around readable first-party Spark chain-of-thought traces.** [OFFICIAL][DEMONSTRATED] Meta’s Chat Completions examples return empty `reasoning_content`; the Responses API returns an encrypted reasoning item and an empty human-readable summary. [Meta reasoning notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/06_reasoning_tokens.ipynb) [COMMUNITY][DEMONSTRATED] The supplied Glimmer probe did expose 98 reasoning tokens through OpenRouter and DeepInfra, but that proves provider behavior for Glimmer, not Meta’s first-party Spark trace policy. [OpenRouter Glimmer, accessed 2026-09-05](https://openrouter.ai/meta/muse-glimmer-30b)

10. **Spark’s official tool surface is useful but narrower than OpenRouter’s parameter list suggests.** [OFFICIAL][DEMONSTRATED] Meta demonstrates multiple parallel function calls and strict JSON-schema output. However, the documented first-party Chat endpoint rejects `tool_choice` values other than automatic selection, including `none`, `required`, and named-tool forcing, with HTTP 400. Recursive structured schemas are also rejected. [Meta tool notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/03_tool_calling.ipynb), [structured-output notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/04_structured_output.ipynb)

11. **Do not depend on undocumented Spark media limits.** [OFFICIAL][ASSERTION] Meta documents image URLs, base64 images, supported image formats, approximately 50 images per request, 50 MB inline images, and 1 GiB Files API uploads. It does not publicly disclose Spark’s maximum video duration, frame rate, audio duration, audio formats, PDF page count, or general video upload rules in the accessible cookbook. [Meta vision notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/07_vision_input.ipynb)

12. **Do not assume Spark 1.1 or 1.2 has a stable support window.** [OFFICIAL][ASSERTION] Meta makes 1.3 the current cookbook default, but no public retirement date, compatibility period, or deprecation notice was found for 1.1 or 1.2. OpenRouter still lists all three versions. [Meta cookbook, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-model-cookbook/blob/main/README.md), [OpenRouter 1.1, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.1), [OpenRouter 1.2, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.2)

## 1. Family timeline and changes

The explicit progression is: original Spark established the multimodal agent architecture, 1.1 opened and strengthened the API model, 1.2 concentrated on long-horizon software engineering, and 1.3 concentrated on reliability, user collaboration, efficiency, professional work, and long context.

| Date | Official event | Explicit change |
|---|---|---|
| 2026-04-08 | Original Muse Spark announcement | [OFFICIAL][ASSERTION] Meta introduced MSL’s first Muse model as a natively multimodal reasoning and tool-use model with visual chain-of-thought and multi-agent orchestration. It launched through meta.ai and the Meta AI app, with a private API preview. Meta reported 58 percent on Humanity’s Last Exam and 38 percent on FrontierScience Research. This source predates the preferred 2026-07-01 window. [Meta, published 2026-04-08, accessed 2026-09-05](https://ai.meta.com/blog/introducing-muse-spark-msl/) |
| 2026-04-08 | Safety and preparedness report | [OFFICIAL][ASSERTION] Meta published a dedicated 160-page safety and preparedness report for the original model. This source predates the preferred window. [Meta report, published 2026-04-08, accessed 2026-09-05](https://ai.meta.com/static-resource/muse-spark-safety-and-preparedness-report/) |
| 2026-04-08, updated 2026-05-12 | Consumer rollout | [OFFICIAL][ASSERTION] Meta announced gradual Muse Spark expansion to Ray-Ban Meta and Oakley glasses in the United States and Canada, plus WhatsApp, Instagram, Facebook, Messenger, and Threads. The announcement names Muse Spark generically, not 1.1, 1.2, or 1.3. This source predates the preferred window. [Meta Newsroom, published 2026-04-08, updated 2026-05-12, accessed 2026-09-05](https://about.fb.com/news/2026/04/introducing-muse-spark-meta-superintelligence-labs/) |
| 2026-07-09 | Muse Spark 1.1 and public Meta Model API preview | [OFFICIAL][ASSERTION] Meta described 1.1 as a significant upgrade in tool use, computer use, coding, and multimodal reasoning. It added a one-million-token context window, active context management, multi-agent orchestration, subagents, compaction, and tool and function calling. [Meta, published 2026-07-09, accessed 2026-09-05](https://ai.meta.com/blog/introducing-muse-spark-meta-model-api/) |
| 2026-07-09 | Spark 1.1 evaluation report | [OFFICIAL][ASSERTION] Meta published a 112-page evaluation report covering capabilities and safety. [Meta report, published 2026-07-09, accessed 2026-09-05](https://ai.meta.com/static-resource/muse-spark-1-1-evaluation-report) |
| 2026-07-24 | Consumer actions powered by 1.1 | [OFFICIAL][ASSERTION] Meta explicitly says Spark 1.1 powers the Meta AI app and meta.ai action experience, including plans, email and calendar connections, slides, and task execution in select markets, with WhatsApp expansion described as later. [Meta Newsroom, published 2026-07-24, accessed 2026-09-05](https://about.fb.com/news/2026/07/meta-ai-muse-spark-doesnt-just-think-it-acts/) |
| 2026-07-27 | Smart-glasses update | [OFFICIAL][ASSERTION] Meta says “Muse Spark models” power features on Meta Ray-Ban Display glasses, without identifying a point version. [Meta, published 2026-07-27, accessed 2026-09-05](https://www.meta.com/blog/meta-ray-ban-display-glasses-v127-muse-spark-threads/) |
| 2026-08-05 | Muse Spark 1.2 and Muse Code | [OFFICIAL][ASSERTION] Meta concentrated additional training compute on coding, broadened coding environments, and improved code generation, debugging, codebase understanding, and end-to-end workflows. The model was co-trained with Muse Code using rejection-sampled agent trajectories, goals, tool use, compaction, and subagents. [Meta Research, published 2026-08-05, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-code-and-muse-spark-1-2) |
| 2026-08-20 | 1.2 multimodal intelligence report | [OFFICIAL][ASSERTION] Meta highlighted visual coding, audio-visual understanding, a robotics-oriented variant, and a ten-task preview of WildArtifactBench. [Meta Research, published 2026-08-20, accessed 2026-09-05](https://research.meta.ai/blog/multimodal-intelligence-of-muse-spark-1-2) |
| 2026-08-10 | Muse Glimmer 30B | [OFFICIAL][ASSERTION] Meta released an open-weight, dense, 30B agentic model distilled from Spark, intended for always-on agents on a Mac or PC with a single consumer GPU. [Meta Research, published 2026-08-10, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-glimmer-open-agentic-model) |
| 2026-09-02 | Muse Spark 1.3 | [OFFICIAL][ASSERTION] Meta emphasized professional agents, reliable long-horizon execution, correction of knowledge gaps, clarifying questions, confirmation before consequential actions, reduced false completion claims, improved coding efficiency, and stronger long context. Maximum reasoning is now described as available in Muse Code and the Meta Model API. [Meta Research, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-spark-1-3) |

### Exactly what changed from 1.1 to 1.2

[OFFICIAL][ASSERTION] Meta explicitly identifies coding as the center of the 1.2 update. Training used more compute, more diverse coding environments, and agent trajectories produced and graded with 1.1. Muse Code added asynchronous, persistent background agents, an append-only local event log, and bundled skills. Meta also says 1.2 can sustain kernel-optimization tasks exceeding 1,000 tool calls and lasting up to 24 hours. [Meta Research, published 2026-08-05, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-code-and-muse-spark-1-2)

[OFFICIAL][ASSERTION] What Meta does not disclose includes parameter count, architecture changes, training-token count, data composition, exact context-management algorithm, or whether any serving-side tool policies changed between 1.1 and 1.2. [Meta Research, published 2026-08-05, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-code-and-muse-spark-1-2)

### Exactly what changed from 1.2 to 1.3

[OFFICIAL][ASSERTION] Meta explicitly describes 1.3 as improving professional work, long-horizon coding, computer use, deep research, long-context retrieval, collaboration with the user, detection of missing information, and confirmation before consequential actions. Meta reports internal engineer comparisons showing about 20 percent fewer tool calls and about 25 percent fewer tokens than 1.2 on coding tasks. [Meta Research, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-spark-1-3)

[OFFICIAL][ASSERTION] Meta does not disclose a parameter count, architectural delta, training-token count, changed knowledge cutoff, or a precise definition of the reported tool-call and token-efficiency sample. [Meta Research, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-spark-1-3)

## 2. Official benchmark tables

### Muse Spark 1.3

The official comparison is favorable but narrow: Spark 1.3 is compared with Spark 1.2, Claude Opus 5, and GPT-5.6 Sol, generally at maximum available reasoning.

| Benchmark | Spark 1.3 | Spark 1.2 | Claude Opus 5 | GPT-5.6 Sol |
|---|---:|---:|---:|---:|
| GDPVal-AA v2 | 1754 | 1615 | 1710 | 1824 |
| JobBench | 64.9 | 61.6 | 45.4 | 65.7 |
| OSWorld 2.0 | 66.9 | 47.6 | 62.7 | 68.3 |
| DeepSearchQA | 89.4 | 85.9 | 93.0 | 90.4 |
| Agentic IF Index | 57.8 | 46.2 | 60.5 | 59.1 |
| AutomationBench | 49.4 | 38.2 | 46.7 | 50.3 |
| DeepSWE v1.1 | 75.4 | 55.0 | 73.0 | 74.0 |
| SWEAtlas Codebase QnA | 59.4 | 46.2 | 53.5 | 52.7 |
| TerminalBench 2.1 | 88.8 | 82.9 | 88.8 | 86.7 |
| MRCR2, 256K to 512K | 98.5 | 66.3 | 91.5 | Not shown |
| MRCR2, 512K to 1M | 98.1 | 55.5 | 73.8 | Not shown |

[OFFICIAL][DEMONSTRATED] Values are reproduced from Meta’s launch charts. The associated methodology states that Spark 1.3, Opus 5, and GPT-5.6 Sol use their maximum reasoning modes, while Spark 1.2 uses `xhigh`. Meta selects the highest comparable primary value from its own reproduction, an official leaderboard, or provider self-report. [Meta Research, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-spark-1-3), [methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)

#### Spark 1.3 footnotes and harness caveats

- [OFFICIAL][ASSERTION] GDPVal-AA v2 uses 220 tasks, the Stirrup harness, browser and computer tools, human Elo scoring, and a 1000 baseline. [Methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)

- [OFFICIAL][ASSERTION] JobBench spans 65 occupations and 35 occupation categories, uses OpenCode and file tools, and applies task-specific rubrics. [Methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)

- [OFFICIAL][ASSERTION] OSWorld 2.0 uses 108 Ubuntu tasks and partial-credit scoring as its primary measure. Meta says 1.3 used the 2026-08-08 environment, while 1.2 used the 2026-06-24 environment, so that row is not a perfectly controlled version-to-version comparison. [Methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)

- [OFFICIAL][ASSERTION] DeepSearchQA contains 900 questions. Models receive the same search backend, and scoring is based on answer F1. [Methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)

- [OFFICIAL][ASSERTION] AutomationBench contains 600 public version 3 tasks and uses deterministic pass-at-one evaluation. [Methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)

- [OFFICIAL][ASSERTION] DeepSWE v1.1 contains 113 tasks from 91 repositories in five languages. Spark 1.3 used mini-swe, while comparison values could come from official leaderboards. [Methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)

- [OFFICIAL][ASSERTION] SWEAtlas Codebase QnA contains 124 questions across 11 repositories and four languages. Spark used mini-swe, while GPT and Claude values came from their own cards. [Methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)

- [OFFICIAL][ASSERTION] TerminalBench 2.1 contains 89 tasks. Each model ran through its native coding harness in an isolated environment, making the comparison ecologically useful but not harness-identical. [Methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)

- [OFFICIAL][ASSERTION] MRCR2 uses 100 examples per context band, eight needles, and an output cap of 200K, with rule-based matching. [Methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)

- [OFFICIAL][ASSERTION] Meta says observed safety refusals were zero and therefore were not filtered from the results. It also warns that third-party prompts, tools, and runtimes were implemented on a best-effort basis and may not be optimal for every comparison model. [Methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)

[OFFICIAL][DEMONSTRATED] Meta chose Opus 5 and GPT-5.6 Sol as frontier comparisons. The official table does not show Claude Fable 5.1, Gemini 3.7 or 3.8 Flash, Grok 4.6, Kimi K3, GLM 5.3, or DeepSeek V4 Pro. This is an observation about table composition, not evidence that Meta evaluated and withheld those models. [Meta Research, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-spark-1-3)

### Muse Glimmer 30B

Meta compares Glimmer mainly against similarly sized open-weight reasoning models, Gemma 4 31B and Qwen 3.6 27B. Higher is better except CI Memories violation and Siren attack success rate.

| Category | Benchmark | Glimmer 30B | Gemma 4 31B | Qwen 3.6 27B |
|---|---|---:|---:|---:|
| General agentic | MCP Atlas Public | 75.5 | 54.2 | 62.5 |
| General agentic | DeepSearch QA | 74.6 | 61.7 | 71.1 |
| General agentic | tau3 Banking | 23.5 | 15.1 | 16.7 |
| General agentic | WildClawBench | 47.6 | 37.6 | 43.2 |
| General agentic | GDPVal-AA v2 | 953 | 811 | 1141 |
| General agentic | Gaia2 | 43.3 | 36.4 | 40.0 |
| General agentic | SkillsBench with skills | 44.3 | 32.4 | 46.6 |
| General agentic | OSWorld Verified | 65.9 | 58.5 | 75.6 |
| Agentic coding | SWE-Bench Pro | 51.2 | 36.9 | 50.2 |
| Agentic coding | SWE-Bench Verified | 76.0 | 66.6 | 77.2 |
| Agentic coding | TerminalBench 2.1 with Terminus 2 | 51.7 | 43.4 | 60.7 |
| Agentic coding | SciCode | 43.6 | 43.4 | 39.8 |
| Multimodal | CharXiv Reasoning | 78.8 | 77.7 | 78.4 |
| Multimodal | ScreenSpot Pro | 75.4 | 75.9 | 76.1 |
| Multimodal | OmniDocBench 1.5 | 75.8 | 72.5 | 77.8 |
| Multimodal | MMMU Pro | 74.0 | 73.0 | 75.0 |
| Security | CI Memories violation, lower is better | 26.4 | 12.1 | 53.4 |
| Security | CI Memories coverage | 64.8 | 53.0 | 66.9 |
| Security | Siren AgentDojo ASR, lower is better | 28.4 | 25.6 | 40.3 |
| Security | Siren AgentDojo utility | 94.2 | 90.8 | 92.7 |
| General | IFBench | 77.0 | 76.0 | 70.8 |
| General | AIME 2026 | 94.7 | 89.2 | 94.1 |
| General | GPQA Diamond AA | 83.5 | 85.7 | 84.2 |
| General | HLE Text AA | 22.0 | 23.6 | 23.1 |
| Long context | AA-LCR | 80.0 | 68.3 | 73.3 |
| Long context | Beam 128K | 65.1 | 58.2 | 63.0 |

[OFFICIAL][DEMONSTRATED] This table is reproduced from the official Meta model card. [Meta model card, published 2026-08, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B)

Meta supplies a separate chemistry and biology comparison that includes Kimi K3:

| Benchmark | Glimmer 30B | Gemma 4 31B | Qwen 3.6 27B | Kimi K3 |
|---|---:|---:|---:|---:|
| MBCT | 41.5 | 50.6 | 45.9 | 58.9 |
| HPCT | 52.3 | 54.0 | 48.7 | 59.6 |
| VCT | 37.0 | 43.5 | 33.7 | 48.0 |
| WMDP Bio | 86.5 | 85.9 | 84.8 | 89.1 |
| WMDP Chem | 75.2 | 80.5 | 74.8 | 84.2 |
| ProtocolQA | 80.2 | 75.8 | 69.1 | 81.9 |

[OFFICIAL][DEMONSTRATED] The official card shows Glimmer trailing Kimi K3 on all six chemistry and biology rows. [Meta model card, published 2026-08, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B)

#### Glimmer footnotes and harness caveats

- [OFFICIAL][ASSERTION] Meta selected open-weight comparison models in approximately the same size class. For each competitor, it used the more favorable value between a provider self-report and Meta’s internal reproduction, or Artificial Analysis where all compared models were available. [Methodology, published 2026-08, accessed 2026-09-05](https://research.meta.ai/static/muse-glimmer-methodology)

- [OFFICIAL][ASSERTION] Glimmer used high reasoning, temperature 1, top-p 0.95, and top-k 64. Gemma used thinking mode with the same sampling values. Qwen used thinking mode, temperature 1, top-p 0.95, and top-k 20, except on Gaia2 and WildClawBench where temperature was 0.6. [Methodology, published 2026-08, accessed 2026-09-05](https://research.meta.ai/static/muse-glimmer-methodology)

- [OFFICIAL][ASSERTION] MCP Atlas Public uses 500 public tasks, four runs, and Gemini 2.5 Pro as judge. DeepSearch QA uses 900 questions, four runs, common search tools, and a gpt-oss-120b extraction judge. [Methodology, published 2026-08, accessed 2026-09-05](https://research.meta.ai/static/muse-glimmer-methodology)

- [OFFICIAL][ASSERTION] WildClawBench uses 60 tasks in an OpenClaw Docker environment and three runs. Gaia2 uses 800 public tasks, OpenClaw, three runs, and a gpt-oss judge. [Methodology, published 2026-08, accessed 2026-09-05](https://research.meta.ai/static/muse-glimmer-methodology)

- [OFFICIAL][ASSERTION] OSWorld Verified uses 361 tasks after excluding eight Google Drive tasks, 1920 by 1080 screenshots, GUI-only interaction, up to 200 steps, and four runs. Muse and Qwen use a Claude-style action space normalized to a 0 to 1000 coordinate system, while Gemma uses a Gemini interface. [Methodology, published 2026-08, accessed 2026-09-05](https://research.meta.ai/static/muse-glimmer-methodology)

- [OFFICIAL][ASSERTION] SWE-Bench Verified contains 500 tasks and SWE-Bench Pro contains 731. Models receive bash and file tools, with four runs. Qwen’s Verified value is self-reported. Meta did not use Qwen’s refined SWE-Bench Pro self-report because it was produced on a different task set. [Methodology, published 2026-08, accessed 2026-09-05](https://research.meta.ai/static/muse-glimmer-methodology)

- [OFFICIAL][ASSERTION] TerminalBench contains 89 tasks and uses Terminus 2 in E2B. SciCode covers 288 subproblems in 16 scientific disciplines, uses no tools, and scores subproblems rather than complete problems. [Methodology, published 2026-08, accessed 2026-09-05](https://research.meta.ai/static/muse-glimmer-methodology)

- [OFFICIAL][ASSERTION] ScreenSpot Pro allows iterative cropping for up to ten rounds and three restarts. OmniDocBench uses Meta’s altered scoring, including formulas folded into text edit distance and a simpler Hungarian assignment than the official v1.6 MGAM evaluation. [Methodology, published 2026-08, accessed 2026-09-05](https://research.meta.ai/static/muse-glimmer-methodology)

- [OFFICIAL][ASSERTION] CI Memories uses 2,500 scenarios with Claude 4.6 Sonnet as judge. Siren combines 97 benign and 35 malicious tasks into 949 prompt-injection scenarios, with Claude Opus 4.6 as attacker for up to six attempts. [Methodology, published 2026-08, accessed 2026-09-05](https://research.meta.ai/static/muse-glimmer-methodology)

[OFFICIAL][DEMONSTRATED] Meta does not compare Glimmer against Spark or a full frontier-model set in the main table. Kimi K3 appears only in the chemistry and biology table. This matches Meta’s stated same-size open-model framing, but limits conclusions about Glimmer versus hosted frontier models. [Meta model card, published 2026-08, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B)

## 3. Official API surface, pricing, limits, caching, and batch

### Meta-hosted API

[OFFICIAL][DEMONSTRATED] Meta operates a first-party Meta Model API at `https://api.meta.ai/v1`. The official cookbook demonstrates compatibility with OpenAI-style and Anthropic-style SDKs, plus Claude Code and OpenCode configuration. The current cookbook default is `muse-spark-1.3`. [Meta cookbook, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-model-cookbook/blob/main/README.md)

[OFFICIAL][ASSERTION] The API was announced as a public preview on 2026-07-09, initially with Spark 1.1. Meta said 1.2 expanded global access and 1.3 is available in the API, but an exhaustive public region list was not accessible without signing in. [Meta 1.1 announcement, published 2026-07-09, accessed 2026-09-05](https://ai.meta.com/blog/introducing-muse-spark-meta-model-api/), [Meta 1.2 announcement, published 2026-08-05, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-code-and-muse-spark-1-2), [Meta 1.3 announcement, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-spark-1-3)

### Context and output limits

[OFFICIAL][DEMONSTRATED] Meta documents a 1,048,576-token combined context limit for Spark. Input plus requested output must fit inside that window. Oversized requests receive HTTP 400 rather than automatic server truncation. Meta exposes a token-counting endpoint. [Meta long-context notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/08_long_context.ipynb)

[COMMUNITY][DEMONSTRATED] The supplied OpenRouter metadata reports 943,718 as Spark 1.3’s maximum output and lists a one-million-token context. OpenRouter’s rendered public page confirms the context size but did not expose an independently readable Meta-authored output-limit specification. [OpenRouter Spark 1.3, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3)

### Pricing comparison

| Route | Input per 1M | Output per 1M | Cache read per 1M | Status |
|---|---:|---:|---:|---|
| OpenRouter Spark 1.3 standard | $1.25 | $4.25 | $0.15 | [COMMUNITY][DEMONSTRATED] |
| OpenRouter Spark 1.3 Contributor | $0.10 | $0.20 | $0.002 | [COMMUNITY][DEMONSTRATED] |
| Meta Model API public preview | “free” in cookbook | “free” in cookbook | No public numerical price found | [OFFICIAL][ASSERTION] |

[COMMUNITY][DEMONSTRATED] OpenRouter also lists web search at $0.0025 per call for the Spark routes. [OpenRouter standard, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3), [OpenRouter Contributor, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3-contributor)

[OFFICIAL][ASSERTION] The public Meta cookbook calls the preview free, but Meta’s detailed developer portal pricing page required authentication. It is therefore not possible from accessible official sources to say whether Meta’s production price equals OpenRouter’s standard price, whether the free statement has quotas, or whether the cookbook has lagged a pricing change. [Meta cookbook, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-model-cookbook/blob/main/README.md), [Meta developer portal, accessed 2026-09-05](https://ai.developer.meta.com/)

### Prompt caching

[OFFICIAL][DEMONSTRATED] Meta’s first-party API performs automatic prefix caching over an identical leading token sequence. No explicit cache key is required. The optional `prompt_cache_key` is a routing hint intended to improve cache affinity. Meta recommends putting stable content first and volatile content last. [Meta prompt-caching notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/05_prompt_caching.ipynb)

[OFFICIAL][ASSERTION] The default retention hint is `in_memory`. A `"24h"` retention value can be requested, but Meta describes it as a hint rather than a guarantee. Usage metadata reports cached-token counts. No accessible official page supplied first-party cache-write or cache-read prices. [Meta prompt-caching notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/05_prompt_caching.ipynb)

### Rate limits and batch

[OFFICIAL][ASSERTION] Meta’s detailed rate-limit pages were login-gated. No accessible official RPM, TPM, concurrent-request, daily-quota, or tier-escalation numbers were found. [Meta developer portal, accessed 2026-09-05](https://ai.developer.meta.com/)

[OFFICIAL][ASSERTION] No public Meta batch API, discount, latency target, or first-party Spark batch model identifier was found. [Meta cookbook, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-model-cookbook/blob/main/README.md)

[COMMUNITY][DEMONSTRATED] OpenRouter exposes a Glimmer `:batch` twin according to the supplied live metadata, but this is an OpenRouter routing product and was not found in Meta’s official Glimmer documentation. [OpenRouter Glimmer, accessed 2026-09-05](https://openrouter.ai/meta/muse-glimmer-30b)

## 4. Reasoning controls

The public Meta API documentation is internally specific about current wire values, but less specific about defaults and disabling reasoning.

| Question | Official result |
|---|---|
| Accepted values | [OFFICIAL][DEMONSTRATED] `minimal`, `low`, `medium`, and `high`. `xhigh` is accepted but currently maps to `high`. [Meta reasoning notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/06_reasoning_tokens.ipynb) |
| Default | [OFFICIAL][ASSERTION] Meta says the default is still being finalized and recommends setting effort explicitly. [Meta reasoning notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/06_reasoning_tokens.ipynb) |
| Disable reasoning | [OFFICIAL][ASSERTION] The notebook describes `none` in the conceptual spectrum but says the public endpoint does not reliably support it. No dependable documented off switch was found. [Meta reasoning notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/06_reasoning_tokens.ipynb) |
| Readable trace | [OFFICIAL][DEMONSTRATED] Chat Completions returns empty `reasoning_content`. Responses returns encrypted reasoning and an empty readable summary. [Meta reasoning notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/06_reasoning_tokens.ipynb) |
| Multi-turn preservation | [OFFICIAL][DEMONSTRATED] Reasoning can be preserved with `previous_response_id` or by replaying the encrypted reasoning item. [Meta reasoning notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/06_reasoning_tokens.ipynb) |
| Billing | [OFFICIAL][ASSERTION] Reasoning tokens count as output tokens, consume the output budget, and are billed at the output-token rate. [Meta reasoning notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/06_reasoning_tokens.ipynb) |

[OFFICIAL][ASSERTION] Meta’s Spark 1.3 launch uses the product phrase “max reasoning,” while the public API notebook’s highest effective wire level is `high`, with `xhigh` mapped to it. The accessible documentation does not say whether “max” is a separate future wire value, a Muse Code preset, or simply high effort plus a larger budget. [Meta 1.3 announcement, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-spark-1-3), [reasoning notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/06_reasoning_tokens.ipynb)

[COMMUNITY][DEMONSTRATED] The supplied OpenRouter Glimmer probe returned a visible reasoning trace containing 98 reasoning tokens for a one-word answer. That is a concrete provider-path observation, but it conflicts only with the first-party Spark presentation layer, not necessarily with the underlying model behavior. [OpenRouter Glimmer, accessed 2026-09-05](https://openrouter.ai/meta/muse-glimmer-30b)

## 5. Multimodal input and output limits

The official public Spark documentation is detailed for still images and sparse for audio, video, and document limits.

### Images

[OFFICIAL][DEMONSTRATED] Spark accepts public image URLs and base64-encoded images. Documented formats are JPEG, JPG, PNG, GIF, WebP, and X-Icon. Images are accepted in user messages, while putting an image in a developer or system message returns HTTP 400. [Meta vision notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/07_vision_input.ipynb)

[OFFICIAL][ASSERTION] Meta documents approximately 50 images per request, a 50 MB limit for an inline image, and a 1 GiB upload limit through the Files API. Image token use is resolution-dependent. [Meta vision notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/07_vision_input.ipynb)

### PDFs and files

[OFFICIAL][ASSERTION] PDF pages are converted into page images and consume the same image budget. Meta documents a 1 GiB Files API limit, but no accessible public page states a PDF-specific maximum page count or a smaller PDF-specific size limit. [Meta vision notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/07_vision_input.ipynb)

### Video

[OFFICIAL][ASSERTION] Meta calls Spark natively multimodal and describes 1.2 as capable of audio-visual understanding. The accessible API documentation did not specify maximum duration, maximum frame count, frame rate, supported container and codec combinations, or whether arbitrary video URLs are accepted alongside uploads. [Meta multimodal report, published 2026-08-20, accessed 2026-09-05](https://research.meta.ai/blog/multimodal-intelligence-of-muse-spark-1-2)

### Audio

[OFFICIAL][ASSERTION] The 1.2 report demonstrates audio-visual understanding, but no accessible official API page specifies audio formats, sample rates, channel limits, maximum duration, file size, or URL support. [Meta multimodal report, published 2026-08-20, accessed 2026-09-05](https://research.meta.ai/blog/multimodal-intelligence-of-muse-spark-1-2)

[COMMUNITY][DEMONSTRATED] OpenRouter lists text, images, video, PDFs or files, and audio as Spark 1.3 inputs, but warns that audio is not fully supported and may be degraded. The supplied live metadata agrees on those modalities. [OpenRouter Spark 1.3, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3)

### Output modalities

[COMMUNITY][DEMONSTRATED] OpenRouter lists text output for Spark 1.3. [OpenRouter Spark 1.3, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3)

[OFFICIAL][ASSERTION] No accessible Meta API document advertised image, video, or audio generation as a Spark output modality. Consumer voice experiences should not be interpreted as proof of a corresponding developer-API audio-output contract. [Meta original announcement, published 2026-04-08, accessed 2026-09-05](https://ai.meta.com/blog/introducing-muse-spark-msl/)

## 6. Tool calling, structured output, and streaming

### Tool calling

[OFFICIAL][DEMONSTRATED] Meta documents tools as JSON Schema function definitions and demonstrates one or multiple tool calls in a single assistant response, including parallel calls. The client must append the complete assistant tool-call message and then one result for every tool-call ID. Missing or mismatched results produce HTTP 400. [Meta tool notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/03_tool_calling.ipynb)

[OFFICIAL][DEMONSTRATED] The first-party Chat endpoint currently supports automatic tool selection. The documented endpoint rejects `tool_choice: none`, `required`, and explicit named-tool forcing with HTTP 400. Built-in web search is documented for the Responses API, not Chat Completions. [Meta tool notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/03_tool_calling.ipynb)

[COMMUNITY][DEMONSTRATED] OpenRouter advertises `tools` and `tool_choice` as supported parameters for Spark 1.3. That gateway-level declaration does not prove that every first-party `tool_choice` variant passes through unchanged, especially given Meta’s documented HTTP 400 behavior. [OpenRouter Spark 1.3, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3)

### Structured outputs

[OFFICIAL][DEMONSTRATED] Meta’s JSON-schema mode uses constrained decoding and guarantees parseable output against a supported schema. Object properties should be required, and `additionalProperties` should be false. Enums and Pydantic parsing are demonstrated. [Meta structured-output notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/04_structured_output.ipynb)

[OFFICIAL][DEMONSTRATED] Recursive schemas are rejected with HTTP 400. Chat Completions uses `response_format`; Responses uses `text.format`. Supplying the Chat-style field to Responses produces HTTP 400. [Meta structured-output notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/04_structured_output.ipynb)

### Streaming

[OFFICIAL][DEMONSTRATED] Meta streams using server-sent events. Usage is opt-in for streamed Chat requests. Visible answer tokens arrive as deltas, and tool arguments can stream incrementally. Meta’s examples indicate internal reasoning occurs before visible answer deltas, but they do not expose that reasoning text. [Meta streaming notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/02_streaming.ipynb)

## 7. Contributor tier

The exact accessible public definition is limited to lower pricing in exchange for possible use of prompts and outputs to improve Meta products.

[COMMUNITY][ASSERTION] OpenRouter’s exact data-use line is: “Prompts and outputs may be used to improve Meta’s products.” [OpenRouter Contributor, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3-contributor)

[COMMUNITY][DEMONSTRATED] OpenRouter presents the Contributor route with the same Spark 1.3 name, 1,048,576-token context, listed modalities, and Meta upstream, while charging $0.10 per million input, $0.20 per million output, and $0.002 per million cached input tokens. Standard is $1.25, $4.25, and $0.15. [OpenRouter standard, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3), [OpenRouter Contributor, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3-contributor)

[COMMUNITY][ASSERTION] Explicitly stated: prompts and outputs may be used for product improvement. Unstated: which fields are collected beyond prompts and outputs, whether source IP or account metadata is included, whether use means model training, evaluation, safety review, or all three, retention duration, human-review conditions, subcontractors, deletion rights, opt-out after submission, regional restrictions, enterprise eligibility, and whether sensitive-data filters differ. [OpenRouter Contributor, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3-contributor)

[COMMUNITY][ASSERTION] No documented quality or feature difference was found beyond price and data-use status. Identical marketplace metadata is evidence of advertised parity, not an official Meta guarantee of identical routing, service level, latency, capacity, safety filters, or future behavior. [OpenRouter Contributor, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3-contributor)

## 8. Muse Glimmer 30B

### Model, weights, and architecture

[OFFICIAL][ASSERTION] Glimmer is a dense 29.6B-parameter model, including a 1.8B-parameter ViT-G/14 vision encoder. It has 52 layers, hidden size 6656, 32 query heads, two key-value heads, a 131,072-plus-token context, and up to 4,096 visual tokens per image. Its training-data cutoff is 2026-01-04, and Meta says training covered more than 100 languages. [Meta model card, published 2026-08, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B)

[OFFICIAL][DEMONSTRATED] Official artifacts are hosted under Meta’s `meta-models` Hugging Face organization. Meta publishes BF16 weights, two 4-bit variants, a DFlash head, a perception encoder, GGUF artifacts, and ExecuTorch PTE variants. [Meta model card, published 2026-08, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B), [official GGUF commit, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B-GGUF/commit/b1f3e6ec2209678b3f29525bb9646286866f1675), [ExecuTorch repository, date not shown, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B-ExecuTorch-PTE/blob/main/README.md)

### License and commercial terms

[OFFICIAL][ASSERTION] Meta releases Glimmer under Apache License 2.0, not a custom Llama or Muse community license. Commercial and research use are permitted. The license grants broad copyright and patent rights, subject to retaining the license and notices, marking modified files, preserving attribution notices, and complying with the NOTICE mechanism. Patent rights terminate for a party that initiates specified patent litigation over the work. [Apache License 2.0, published 2004, older than preferred, accessed 2026-09-05](https://www.apache.org/licenses/LICENSE-2.0), [Meta model card, published 2026-08, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B)

[OFFICIAL][ASSERTION] Apache 2.0 grants no trademark permission and provides the work without warranties or liability. The license itself contains no European Union exclusion or EU-specific commercial clause. [Apache License 2.0, published 2004, older than preferred, accessed 2026-09-05](https://www.apache.org/licenses/LICENSE-2.0)

[OFFICIAL][ASSERTION] Meta additionally publishes an acceptable-use policy restricting illegal activity, violence, child exploitation, discrimination, certain high-impact decisions, unlicensed professional activity, and misuse of personal or sensitive information. It also says Glimmer is not intended for users under 18. These are use restrictions associated with the model distribution, not clauses added to Apache 2.0 itself. [Meta usage policy, date not shown, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B/blob/main/USAGE_POLICY.md), [Meta model card, published 2026-08, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B)

### What “distilled from Muse Spark” means

[OFFICIAL][ASSERTION] Meta says Glimmer’s pretraining used Spark outputs through logit distillation while retaining a similar data mixture. Mid-training shifted toward long-context and agent-heavy data with richer reasoning plus organic data. Post-training combined supervised fine-tuning, on-policy distillation, and reinforcement learning. [Meta Research, published 2026-08-10, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-glimmer-open-agentic-model)

[OFFICIAL][ASSERTION] Meta does not say that Glimmer is a parameter-pruned Spark checkpoint, that its weights are directly derived from Spark weights, or that it reproduces Spark capability. Meta explicitly frames Glimmer as less capable but small enough for local deployment. [Meta Research, published 2026-08-10, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-glimmer-open-agentic-model)

### Official quantizations and sizes

| Artifact | Published size |
|---|---:|
| Dynamic k-quant model GGUF | 19,653,957,984 bytes |
| 17 GB k-quant model GGUF | 16,756,681,056 bytes |
| DFlash k-quant GGUF | 1,631,205,312 bytes |
| Multimodal projector k-quant GGUF | 1,400,328,928 bytes |

[OFFICIAL][DEMONSTRATED] These byte counts appear in Meta’s official GGUF repository commit. [Meta GGUF commit, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B-GGUF/commit/b1f3e6ec2209678b3f29525bb9646286866f1675)

[OFFICIAL][DEMONSTRATED] The official ExecuTorch repository contains 16 variants totaling approximately 372 GB, with individual variants around 17.9 GB to 31.5 GB. It distinguishes text-only and text-image, solo and DFlash, Apple Metal and Nvidia SM80-plus-PTX targets. CPU-only execution is not supported by these PTE artifacts. [Meta ExecuTorch repository, date not shown, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B-ExecuTorch-PTE/blob/main/README.md)

### Recommended runtimes and hardware

[OFFICIAL][ASSERTION] Meta’s cookbook lists vLLM, SGLang, llama.cpp, Ollama, LM Studio, Transformers, MLX, and ExecuTorch across its recipes and integrations. It recommends vLLM for production tool calling, Transformers for learning and experimentation, Ollama for a simple local launch, and LM Studio for GUI-driven local use. [Meta OSS cookbook, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-oss-cookbook/blob/main/README.md), [quickstart, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-oss-cookbook/blob/main/quickstart/README.md)

[OFFICIAL][ASSERTION] BF16 requires about 59 GB to 60 GB. Meta describes Q4 or INT4 artifacts around 16 GB to 17 GB and suggests 24 GB to 32 GB of memory for quantized operation with useful context. For a 24 GB machine, the 17 GB k-quant is the safer official option. The dynamic quantization is recommended for a 32 GB machine and is described as slightly more accurate. [Meta OSS cookbook, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-oss-cookbook/blob/main/README.md), [ExecuTorch repository, date not shown, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B-ExecuTorch-PTE/blob/main/README.md)

[OFFICIAL][DEMONSTRATED] Meta’s browser-control recipe observed approximately 25 GB for the quantized model, projector, and a 128K cache on a Mac, with the model itself around 17 GB. Meta warns that real computer-control agents remain vulnerable to prompt injection. [Meta computer-use recipe, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-oss-cookbook/blob/main/recipes/computer-use-web/README.md)

[OFFICIAL][ASSERTION] The cookbook warns that the repository is under active construction. It says every recipe was verified with BF16 and vLLM, but not every quantized or runtime combination was individually verified. [Meta OSS cookbook, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-oss-cookbook/blob/main/README.md)

## 9. Official prompting guide, cookbook, and limitations

### Spark

[OFFICIAL][ASSERTION] Meta’s practical guidance is to select reasoning effort explicitly, put stable prompt content before volatile content for caching, provide precise tool descriptions, replay complete tool-call state, and use strict schemas with every object property required and `additionalProperties: false`. [Reasoning notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/06_reasoning_tokens.ipynb), [caching notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/05_prompt_caching.ipynb), [tool notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/03_tool_calling.ipynb), [structured-output notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/04_structured_output.ipynb)

[OFFICIAL][ASSERTION] For long-running agents, Meta’s own Muse Code design emphasizes explicit goals, compaction, subagents, persistent event logs, bundled skills, and environment-specific harnesses. [Meta 1.2 announcement, published 2026-08-05, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-code-and-muse-spark-1-2)

[OFFICIAL][ASSERTION] Spark 1.3 is trained to ask clarifying questions, flag missing information, correct course, and confirm consequential actions. That supports giving it authority boundaries and explicit confirmation checkpoints rather than an unconstrained autonomy prompt. [Meta 1.3 announcement, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-spark-1-3)

### Glimmer

[OFFICIAL][ASSERTION] Meta’s model card recommends temperature 1, top-p 0.95, and top-k 64. Supported reasoning levels are low, medium, high, and xhigh, with high or xhigh recommended for difficult tasks. [Meta model card, published 2026-08, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B)

[OFFICIAL][ASSERTION] Meta’s agentic cookbook describes channel-scoped responses for internal reasoning, tool calls, and user-visible answers. It recommends precise tool descriptions and explicit maximum-step limits for autonomous loops. [Meta agentic fundamentals, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-oss-cookbook/blob/main/agentic-fundamentals/README.md)

[OFFICIAL][ASSERTION] Known limitations include factual errors, bias, failures on multi-step tasks, uneven quality across languages, and behavior changes at the quality edge after quantization. Audio is unsupported, and video is only treated as separate frames rather than a specifically optimized modality. [Meta model card, published 2026-08, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B)

## 10. Consumer surfaces and version attribution

| Surface | Officially stated version |
|---|---|
| Meta AI app | [OFFICIAL][ASSERTION] Original Spark from 2026-04-08. Spark 1.1 explicitly powers Thinking and later action features. No official 1.2 or 1.3 assignment found. [Meta original announcement, published 2026-04-08, accessed 2026-09-05](https://ai.meta.com/blog/introducing-muse-spark-msl/), [1.1 announcement, published 2026-07-09, accessed 2026-09-05](https://ai.meta.com/blog/introducing-muse-spark-meta-model-api/) |
| meta.ai | [OFFICIAL][ASSERTION] Original Spark and then Spark 1.1 are explicit. No official 1.2 or 1.3 assignment found. [Meta 1.1 announcement, published 2026-07-09, accessed 2026-09-05](https://ai.meta.com/blog/introducing-muse-spark-meta-model-api/) |
| WhatsApp | [OFFICIAL][ASSERTION] Meta announced a generic Muse Spark rollout and later said 1.1 action features would come to WhatsApp. The currently deployed point version is not stated. [Meta Newsroom, published 2026-04-08, updated 2026-05-12, accessed 2026-09-05](https://about.fb.com/news/2026/04/introducing-muse-spark-meta-superintelligence-labs/), [Meta Newsroom, published 2026-07-24, accessed 2026-09-05](https://about.fb.com/news/2026/07/meta-ai-muse-spark-doesnt-just-think-it-acts/) |
| Instagram, Facebook, Messenger, Threads | [OFFICIAL][ASSERTION] Generic Muse Spark rollout only. No point version was identified. [Meta Newsroom, published 2026-04-08, updated 2026-05-12, accessed 2026-09-05](https://about.fb.com/news/2026/04/introducing-muse-spark-meta-superintelligence-labs/) |
| Ray-Ban Meta and Oakley glasses | [OFFICIAL][ASSERTION] Generic Muse Spark rollout in the United States and Canada. No point version was identified. [Meta Newsroom, published 2026-04-08, updated 2026-05-12, accessed 2026-09-05](https://about.fb.com/news/2026/04/introducing-muse-spark-meta-superintelligence-labs/) |
| Meta Ray-Ban Display | [OFFICIAL][ASSERTION] Meta says “Muse Spark models,” plural, without a point version. [Meta glasses update, published 2026-07-27, accessed 2026-09-05](https://www.meta.com/blog/meta-ray-ban-display-glasses-v127-muse-spark-threads/) |
| Muse Code | [OFFICIAL][ASSERTION] Spark 1.2 at launch, then Spark 1.3 including maximum reasoning. [Meta 1.2 announcement, published 2026-08-05, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-code-and-muse-spark-1-2), [Meta 1.3 announcement, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-spark-1-3) |

[OFFICIAL][ASSERTION] The absence of a 1.2 or 1.3 consumer-surface announcement does not prove those surfaces still run 1.1. It means Meta has not publicly mapped the later point versions to those products in the sources found. [Meta 1.3 announcement, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-spark-1-3)

## 11. Availability on other clouds and providers

### Spark

[OFFICIAL][ASSERTION] Meta’s current public model landing material points developers to the Meta Model API and OpenRouter. No official announcement was found for Spark on AWS Bedrock, Google Vertex AI, Microsoft Azure, Groq, Cerebras, Together, Fireworks, DeepInfra, or Phala as independently selectable upstreams. [Meta models landing page, accessed 2026-09-05](https://ai.meta.com/llama/)

[COMMUNITY][DEMONSTRATED] OpenRouter shows Meta as the sole upstream for Spark 1.3 and Contributor. Therefore, OpenRouter access is currently a gateway to Meta’s hosted route, not a choice among multiple Spark hosting vendors. [OpenRouter standard, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3), [OpenRouter Contributor, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3-contributor)

### Glimmer

[OFFICIAL][DEMONSTRATED] Meta publishes open weights, allowing independent hosting. Meta’s official Together guide uses model ID `meta-models/Muse-Glimmer-30B` and lists $0.35 per million input tokens, $1.50 per million output tokens, $0.04 per million cached input tokens, a 128K-plus context, Chat and Vision support, serverless and dedicated deployment, and a stated 99.9 percent SLA. [Meta Together guide, updated 2026-08-11, accessed 2026-09-05](https://github.com/meta-models/meta-oss-cookbook/blob/main/hosted/together-ai.md)

[COMMUNITY][DEMONSTRATED] OpenRouter currently aggregates four Glimmer providers:

| Provider | Input per 1M | Output per 1M | Cache read per 1M |
|---|---:|---:|---:|
| Phala | $0.30 | $1.10 | $0.04 |
| DeepInfra | $0.30 | $1.20 | $0.04 |
| Fireworks | $0.35 | $1.50 | $0.04 |
| Together | $0.35 | $1.50 | $0.04 |

[COMMUNITY][DEMONSTRATED] OpenRouter’s headline price is $0.30 input and $1.10 output, which represents its lowest listed provider rather than a uniform provider price. It lists a 131,072-token context and text plus image input with text output. [OpenRouter Glimmer, listed 2026-08-09, accessed 2026-09-05](https://openrouter.ai/meta/muse-glimmer-30b)

[COMMUNITY][DEMONSTRATED] OpenRouter lists Glimmer on 2026-08-09, one day before Meta’s official 2026-08-10 announcement. This is a marketplace-listing date conflict, not evidence that Meta’s stated announcement date is wrong. [OpenRouter Glimmer, listed 2026-08-09, accessed 2026-09-05](https://openrouter.ai/meta/muse-glimmer-30b), [Meta Research, published 2026-08-10, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-glimmer-open-agentic-model)

[COMMUNITY][DEMONSTRATED] The supplied provider metadata gives DeepInfra a 16,384-token maximum output. OpenRouter’s general Glimmer page presents the broader model context and can show larger completion capability elsewhere, so orchestration should honor the selected provider’s cap. [OpenRouter Glimmer, accessed 2026-09-05](https://openrouter.ai/meta/muse-glimmer-30b)

## 12. Deprecation and support policy

No official deprecation or guaranteed support schedule was found for Spark 1.1 or 1.2.

[OFFICIAL][ASSERTION] Meta’s cookbook has moved its default model to `muse-spark-1.3`. Meta’s 1.3 post still links the preceding 1.1 and 1.2 material, but neither source supplies an end-of-life date, notice period, migration deadline, alias behavior, or support guarantee. [Meta cookbook, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-model-cookbook/blob/main/README.md), [Meta 1.3 announcement, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-spark-1-3)

[COMMUNITY][DEMONSTRATED] OpenRouter still lists 1.1, 1.2, 1.2 Contributor, 1.3, and 1.3 Contributor. The 1.1 marketplace listing date is 2026-07-16, seven days after Meta’s official 2026-07-09 release. The 1.2 standard and Contributor pages show separate listing dates, 2026-08-05 and 2026-08-21 respectively. Continued listing is evidence of current catalog presence, not a future support promise. [OpenRouter 1.1, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.1), [OpenRouter 1.2, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.2), [OpenRouter 1.2 Contributor, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.2-contributor)

## Not found after searching

A 140-query sweep was completed across Meta AI, Meta Research, Meta Newsroom, Meta for Developers, the Meta Model API portal, Meta’s official GitHub organizations, Meta’s official Hugging Face organization, OpenRouter, and named cloud-provider surfaces.

The following were not found in accessible official sources:

1. [OFFICIAL][ASSERTION] A public Meta Model API pricing table that numerically confirms or contradicts OpenRouter’s $1.25 and $4.25 standard Spark prices. The accessible cookbook says preview access is free, while the detailed developer portal requires authentication. Queries included `"Muse Spark pricing" site:ai.meta.com`, `"Muse Spark pricing" site:developer.meta.com`, `"Meta Model API pricing Muse Spark"`, and `"muse-spark-1.3 input output price Meta`.

2. [OFFICIAL][ASSERTION] Official RPM, TPM, concurrency, daily quota, account-tier, or rate-limit escalation numbers. Queries included `"Muse Spark rate limits"`, `"Meta Model API RPM TPM"`, `site:ai.developer.meta.com "rate limits"`, and `site:developers.meta.com "Muse Spark" "rate limit"`.

3. [OFFICIAL][ASSERTION] A public region and country availability list for the Meta Model API or Contributor tier. Queries included `"Muse Spark API regions"`, `"Meta Model API countries"`, `"Contributor tier regions Meta"`, and `"Muse Spark global access countries"`.

4. [OFFICIAL][ASSERTION] A complete Meta-authored Contributor privacy and data-use policy covering collected metadata, training use, retention, deletion, human review, third parties, opt-out, enterprise eligibility, or regional exclusions. Queries included `"Muse Spark Contributor terms"`, `"Contributor tier data use Meta"`, `"prompts completions improve future Meta AI models retention"`, `"Muse Spark Contributor opt out"`, and `"Muse Spark Contributor human review"`.

5. [OFFICIAL][ASSERTION] An official Meta explanation for why Spark is age-gated on OpenRouter, or a Meta statement requiring OpenRouter’s `age_18plus` attestation specifically. Queries included `"Muse Spark 18+"`, `"Muse Spark age confirmation"`, `"missing_attestation_types age_18plus"`, `"OpenRouter 18+ age confirmation Muse Spark"`, and `"Muse Spark under 18 Meta terms"`.

6. [COMMUNITY][ASSERTION] Public OpenRouter documentation explaining whether the age attestation is self-declaration only, whether identity documents are requested, how long the attestation is retained, whether it is shared with Meta, or whether it applies account-wide. Queries included `"site:openrouter.ai/docs age_18plus"`, `"site:openrouter.ai age attestation"`, `"OpenRouter 18+ verification policy"`, and the exact 403 error string.

7. [OFFICIAL][ASSERTION] Spark video limits, including duration, frame rate, frame count, supported codecs and containers, resolution, URL fetching, and upload constraints. Queries included `"Muse Spark video max length fps formats"`, `"Meta Model API video input limits"`, and `"Muse Spark video URL upload"`.

8. [OFFICIAL][ASSERTION] Spark audio formats, duration, sample-rate, channel, size, URL, or upload limits. Queries included `"Muse Spark audio formats duration"`, `"Meta Model API audio limits"`, and `"Muse Spark audiovisual API audio upload"`.

9. [OFFICIAL][ASSERTION] A PDF-specific maximum page count, a PDF-specific size cap, or detailed non-PDF file-type limits. Queries included `"Muse Spark PDF pages size"`, `"Meta Model API file upload PDF limit"`, and `"Muse Spark documents supported file formats"`.

10. [OFFICIAL][ASSERTION] A first-party maximum output value of 943,718 for Spark 1.3. Meta publicly documents the combined 1,048,576-token window, but not that exact output cap. Queries included `"943718 Muse Spark"`, `"Muse Spark 1.3 max output tokens"`, and `"Meta Model API output limit 943718"`.

11. [OFFICIAL][ASSERTION] An official first-party Spark batch endpoint, batch discount, batch turnaround target, or batch model identifier. Queries included `"Muse Spark batch API"`, `"Meta Model API batch"`, and `"muse-spark-1.3 batch"`.

12. [OFFICIAL][ASSERTION] A public changelog enumerating every wire-level API difference between Spark 1.1, 1.2, and 1.3. Queries included `"Muse Spark changelog"`, `"Meta Model API release notes"`, `"Muse Spark 1.2 API changes"`, and `"Muse Spark 1.3 API changes"`.

13. [OFFICIAL][ASSERTION] Formal deprecation dates or support policies for Spark 1.1 and 1.2. Queries included `"Muse Spark 1.1 deprecation"`, `"Muse Spark 1.2 deprecation"`, `"Meta Model API support policy"`, and `"Muse Spark end of life"`.

14. [OFFICIAL][ASSERTION] An official assignment of Spark 1.2 or 1.3 to WhatsApp, Instagram, Facebook, Messenger, Threads, Ray-Ban Meta, Oakley glasses, or the current general Meta AI app. Queries included `"Muse Spark 1.3 Meta AI app"`, `"Muse Spark 1.3 WhatsApp"`, `"Muse Spark 1.2 Instagram"`, and `"Muse Spark 1.3 Ray-Ban"`.

15. [OFFICIAL][ASSERTION] Official Spark availability on Bedrock, Vertex AI, Azure AI, Groq, Cerebras, Together, Fireworks, DeepInfra, or Phala outside OpenRouter’s Meta upstream. Queries combined each provider name with `"Muse Spark 1.3"` and `"muse-spark-1.3"`.

16. [OFFICIAL][ASSERTION] Official Glimmer listings on Bedrock, Vertex AI, Azure AI, Groq, or Cerebras. Queries combined each provider with `"Muse Glimmer 30B"` and `"meta-models/Muse-Glimmer-30B"`.

17. [OFFICIAL][ASSERTION] A Meta-authored Glimmer `:batch` model identifier or batch policy. Queries included `"Muse Glimmer batch"`, `"Muse-Glimmer-30B batch API"`, and `site:github.com/meta-models Glimmer batch`.

18. [OFFICIAL][ASSERTION] An official Glimmer MLX weight repository or completed official MLX artifact. Meta mentions MLX as a runtime path, but accessible official materials still describe some Apple-silicon integration work as pending or evolving. Queries included `"site:huggingface.co/meta-models Muse Glimmer MLX"`, `"Muse-Glimmer-30B MLX official"`, and `"site:github.com/meta-models Glimmer MLX"`.

## Sources

- [Meta, Introducing Muse Spark, published 2026-04-08, accessed 2026-09-05](https://ai.meta.com/blog/introducing-muse-spark-msl/)
- [Meta, Muse Spark safety and preparedness report, published 2026-04-08, accessed 2026-09-05](https://ai.meta.com/static-resource/muse-spark-safety-and-preparedness-report/)
- [Meta Newsroom, original consumer rollout, published 2026-04-08, updated 2026-05-12, accessed 2026-09-05](https://about.fb.com/news/2026/04/introducing-muse-spark-meta-superintelligence-labs/)
- [Meta, Muse Spark 1.1 and Meta Model API, published 2026-07-09, accessed 2026-09-05](https://ai.meta.com/blog/introducing-muse-spark-meta-model-api/)
- [Meta, Muse Spark 1.1 evaluation report, published 2026-07-09, accessed 2026-09-05](https://ai.meta.com/static-resource/muse-spark-1-1-evaluation-report)
- [Meta Newsroom, Spark 1.1 consumer actions, published 2026-07-24, accessed 2026-09-05](https://about.fb.com/news/2026/07/meta-ai-muse-spark-doesnt-just-think-it-acts/)
- [Meta, smart-glasses update, published 2026-07-27, accessed 2026-09-05](https://www.meta.com/blog/meta-ray-ban-display-glasses-v127-muse-spark-threads/)
- [Meta Research, Muse Code and Muse Spark 1.2, published 2026-08-05, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-code-and-muse-spark-1-2)
- [Meta Research, Spark 1.2 multimodal intelligence, published 2026-08-20, accessed 2026-09-05](https://research.meta.ai/blog/multimodal-intelligence-of-muse-spark-1-2)
- [Meta Research, Muse Glimmer, published 2026-08-10, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-glimmer-open-agentic-model)
- [Meta Research, Glimmer methodology, published 2026-08, accessed 2026-09-05](https://research.meta.ai/static/muse-glimmer-methodology)
- [Meta official Glimmer model card, published 2026-08, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B)
- [Meta official Glimmer usage policy, date not shown, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B/blob/main/USAGE_POLICY.md)
- [Meta official Glimmer GGUF commit, date not shown, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B-GGUF/commit/b1f3e6ec2209678b3f29525bb9646286866f1675)
- [Meta official Glimmer ExecuTorch repository, date not shown, accessed 2026-09-05](https://huggingface.co/meta-models/Muse-Glimmer-30B-ExecuTorch-PTE/blob/main/README.md)
- [Meta OSS cookbook, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-oss-cookbook/blob/main/README.md)
- [Meta OSS quickstart, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-oss-cookbook/blob/main/quickstart/README.md)
- [Meta agentic fundamentals, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-oss-cookbook/blob/main/agentic-fundamentals/README.md)
- [Meta Glimmer computer-use recipe, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-oss-cookbook/blob/main/recipes/computer-use-web/README.md)
- [Meta official Together hosting guide, updated 2026-08-11, accessed 2026-09-05](https://github.com/meta-models/meta-oss-cookbook/blob/main/hosted/together-ai.md)
- [Apache License 2.0, published 2004, accessed 2026-09-05](https://www.apache.org/licenses/LICENSE-2.0)
- [Meta Research, Muse Spark 1.3, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/blog/introducing-muse-spark-1-3)
- [Meta Research, Spark 1.3 evaluation methodology, published 2026-09-02, accessed 2026-09-05](https://research.meta.ai/static/muse-spark-1-3-multimodal-evaluation-methodology)
- [Meta Model API cookbook, date not shown, accessed 2026-09-05](https://github.com/meta-models/meta-model-cookbook/blob/main/README.md)
- [Meta developer portal, accessed 2026-09-05](https://ai.developer.meta.com/)
- [Meta prompt-caching notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/05_prompt_caching.ipynb)
- [Meta reasoning notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/06_reasoning_tokens.ipynb)
- [Meta vision-input notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/07_vision_input.ipynb)
- [Meta long-context notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/08_long_context.ipynb)
- [Meta tool-calling notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/03_tool_calling.ipynb)
- [Meta structured-output notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/04_structured_output.ipynb)
- [Meta streaming notebook, date not shown, accessed 2026-09-05](https://raw.githubusercontent.com/meta-models/meta-model-cookbook/refs/heads/main/01_api_fundamentals/02_streaming.ipynb)
- [Meta public models landing page, accessed 2026-09-05](https://ai.meta.com/llama/)
- [OpenRouter, Muse Spark 1.3, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3)
- [OpenRouter, Muse Spark 1.3 Contributor, listed 2026-09-02, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.3-contributor)
- [OpenRouter, Muse Spark 1.2, listed 2026-08-05, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.2)
- [OpenRouter, Muse Spark 1.2 Contributor, listed 2026-08-21, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.2-contributor)
- [OpenRouter, Muse Spark 1.1, listed 2026-07-16, accessed 2026-09-05](https://openrouter.ai/meta/muse-spark-1.1)
- [OpenRouter, Muse Glimmer 30B, listed 2026-08-09, accessed 2026-09-05](https://openrouter.ai/meta/muse-glimmer-30b)
- [OpenRouter model catalog with age badges, accessed 2026-09-05](https://openrouter.ai/models?fmt=cards&input_modalities=video&q=t)
- [OpenRouter preferences and attestation destination, accessed 2026-09-05](https://openrouter.ai/settings/preferences)