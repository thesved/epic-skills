# Open-weight field, non-Chinese + small vendors, as of 2026-08-12

Scope: nvidia/nemotron-3.5-lightning, upstage/solar-pro4, poolside/laguna-s-2.1, plus the Llama/Mistral question.
Prices given by caller, not re-verified. Everything else verified against sources listed in §5.
Use-case lens: ~4000 calls, long shared fixed rulebook prefix, strict JSON array up to 64k output, Hungarian, e-commerce product attributes.

---

## 1. The framing answer

### 1a. Headline: the top of the open-weight field is Chinese, and it is not close

Artificial Analysis open-weights board, Intelligence Index, fetched 2026-08-12 [S1]:

| Rank | Model | Index | AA blended price | Origin |
|---|---|---|---|---|
| 1 | Kimi K3 (max) | 60 | $2.3 | CN |
| 2 | GLM-5.2 (max) | 53 | $0.9 | CN |
| 3 | DeepSeek V4 Flash 0731 | 52 | $0.1 | CN |
| 4 | MiniMax-M3 | 45 | $0.2 | CN |
| 5 | MiMo-V2.5-Pro (Xiaomi) | 43 | $0.2 | CN |
| 6 | **Inkling (Thinking Machines)** | **42** | $0.7 | US |
| 7 | **Nemotron 3 Ultra 550B (NVIDIA)** | **38** | $0.5 | US |
| 8 | **Mistral Medium 3.5** | **30** | $1.2 | FR |
| 9 | **Nemotron 3 Super 120B** | **26** | $0.3 | US |
| 10 | **gpt-oss-120b (OpenAI)** | **24** | $0.2 | US |
| 10= | **Nemotron 3.5 Lightning 30B-A3B** | **24** | $0.10/$0.25 on OR | US |
| 12 | **Command A+ (Cohere)** | **23** | n/a | CA |

So the non-Chinese open-weight ranking by raw capability is:

**Inkling (42) > Nemotron 3 Ultra (38) > Mistral Medium 3.5 (30) > Nemotron 3 Super (26) > gpt-oss-120b (24) = Nemotron 3.5 Lightning (24) > Command A+ (23).**

The single best open-weight model in the world right now is **Kimi K3** at index 60 [S1]. The best **non-Chinese** open-weight model is **Inkling** at 42 [S1], Apache 2.0, 975B total / 41B active, 1M context, multimodal text+image+audio, released 2026-07-15 [S9].

Two in-scope models are absent from the AA open-weights board entirely: **Laguna S 2.1** and **Muse Glimmer 30B**. No AA index score found for either (see §6).

### 1b. Capability per dollar

Using AA index divided by AA blended price [S1]:

1. **DeepSeek V4 Flash 0731**: 52 at $0.1. Roughly 520 index-points per dollar. Nothing else is within 2x. Chinese.
2. **MiniMax-M3**: 45 at $0.2, and **MiMo-V2.5-Pro**: 43 at $0.2. Chinese.
3. **Nemotron 3.5 Lightning**: 24 at $0.10/$0.25 OpenRouter. Best non-Chinese cheap tier, and the only one that combines the low price with ~670 output tokens/sec [S2].
4. **gpt-oss-120b**: 24 at $0.2. Same intelligence as Lightning, roughly double the price, much slower.
5. **Nemotron 3 Super 120B**: 26 at $0.3.
6. **Inkling**: 42 at $0.7. Best non-Chinese capability-per-dollar once you need real reasoning.

Blunt read: for pure cost efficiency the non-Chinese field is beaten by DeepSeek V4 Flash by a factor of about 2 to 5. If Chinese-origin weights are acceptable, that is the answer for bulk work. If they are not, Nemotron 3.5 Lightning is the cheap tier and Inkling is the smart tier.

### 1c. Truly open weights versus "open" in name only

**Genuinely downloadable, licensed, self-hostable:**
- **Nemotron 3.5 Lightning 30B-A3B**: OpenMDW-1.1, weights on Hugging Face and build.nvidia.com, NVFP4 and BF16 checkpoints [S2][S3][S4].
- **Laguna S 2.1**: OpenMDW-1.1, weights at `poolside/Laguna-S-2.1-FP8` on Hugging Face [S6][S7].
- **Inkling**: Apache 2.0, full weights at `thinkingmachines/Inkling` [S9].
- **Muse Glimmer 30B**: Apache 2.0, `meta-models/Muse-Glimmer-30B`, BF16 plus GGUF quants, also on Ollama and LM Studio [S10][S11].
- **Solar Open 2 250B-A15B**: Upstage's open-weight model, `upstage/Solar-Open2-250B` [S12].
- **Mistral Large 3** (675B total / 41B active, Apache 2.0, released 2025-12-02) and **Mistral Small 4** (Apache 2.0, 2026-03-16) [S13][S14].
- **gpt-oss-120b**, **Nemotron 3 Ultra/Super**, **Kimi K3**, **GLM-5.2**, **DeepSeek V4 Flash** per the AA open-weights board [S1].

**API-only, loosely called open:**
- **Upstage Solar Pro 4**. This is the big correction. Upstage's own launch post: "You use it through an API with no GPUs or serving infrastructure." No weights. Upstage explicitly separates it from Solar Open 2, which is the open-weights product [S5]. On OpenRouter it is served by exactly one provider, Upstage itself [S8].
- **Meta Muse Spark 1.2**. Zuckerberg said on 2026-08-10 that Meta will open source it. As of that date the weights are **promised, not released** [S10].
- **Mistral Medium 3.5**. AA lists it on the open-weights board [S1] but I could not verify a downloadable checkpoint or license. Treat as unverified (§6).

### 1d. Best open-weight pick per job

**(a) Hard reasoning: Inkling (Thinking Machines).**
Index 42, top non-Chinese open weight, Apache 2.0, 975B-A41B MoE with native reasoning, 1M context [S1][S9]. If Chinese weights are allowed, Kimi K3 at 60 and GLM-5.2 at 53 are strictly better [S1]. Runner-up non-Chinese: Nemotron 3 Ultra 550B at 38 [S1].

**(b) Bulk cheap structured extraction: Nemotron 3.5 Lightning.**
$0.10/$0.25, 262k context on OpenRouter, ~670 output tok/s, 3B active parameters out of 30B, MoE, NVFP4 and BF16, OpenMDW-1.1 [S2][S3][S8]. It was explicitly built for "high-volume, low-latency execution" and NVIDIA is candid that complex reasoning should go to frontier models [S4]. Caveat: index 24 is thin. If Chinese weights are acceptable, DeepSeek V4 Flash gives index 52 at the same $0.1 blended price [S1], which is more than twice the intelligence for the same money and is the correct answer on merit.

**(c) Coding: Laguna S 2.1 (Poolside).**
Vendor-published card numbers, benchmarks dated 2026-07-21 [S6]: Terminal-Bench 2.1 70.2%, SWE-bench Multilingual 78.5% (vs Qwen 3.7 Max 78.3%), SWE-Bench Pro 59.4% (vs DeepSeek-V4-Pro 55.4%). 118B total / 8.5B active, 1M native context, OpenMDW-1.1. It beats models roughly 10x its size on agentic coding [S7]. Weak spots on its own card: DeepSWE 40.4% (Kimi K3 69%), SWE Atlas codebase QnA 46.2% (Claude Fable 5 70%), Toolathlon Verified 49.7% (Muse Spark 1.1 75.6%) [S6]. Note Muse Glimmer 30B claims SWE-Bench Verified 76.0 [S11], but that is a different benchmark from Laguna's set so the two are not directly comparable.

**(d) Long context: Laguna S 2.1 or Inkling, both 1M native.**
Laguna's card states 1,048,576 tokens native, reducible to 262,144 by config edit, with an explicit warning: "At long context you may experience some quality degradation" [S6]. Inkling is also 1M [S9]. Solar Pro 4 advertises 524k on OpenRouter and 512k input / 128k output in the vendor post [S5][S8], the largest verified output cap in this set, but it is API-only so it does not qualify as an open-weight pick.

**(e) Multilingual non-English: no confident non-Chinese open-weight pick exists.**
- The best open-weight multilingual model on the only multilingual leaderboard I could pull (BenchLM, MMLU-ProX weighted, August 2026) is **Qwen3.5 397B at 69.7%**, Chinese. Then GLM-5 48.7%, Nemotron 3 Ultra 47.4%, Kimi K2.5 38.2% [S15].
- **Nemotron 3 Ultra at 47.4% is the top non-Chinese open weight on that board** [S15]. That is the closest thing to an evidence-backed answer. Note this is Ultra 550B, not the in-scope Lightning.
- **Muse Glimmer 30B** is trained on data from 100+ languages per its model card, which is a vendor claim with no independent multilingual score found [S11].
- **Solar Pro 4 / Solar Open 2**: official language support is Korean, English, Japanese only [S5][S12]. Upstage's multilingual strength is Korean-specific and demonstrated on Korean benchmarks (Ko-GDPval, Korean law/medicine/office). Solar Open 2 scores 86.8 on Ko-GDPval, matching DeepSeek-V4-Pro at 6x its size [S12]. **This does not generalise to European languages.** There is no Upstage evidence for any European language beyond English. Answering the caller's question directly: no, Solar's Korean strength is not evidence of Hungarian or European ability, and Upstage does not claim it.
- **Hungarian specifically: no evidence found for any in-scope model.** No published Hungarian score for Nemotron 3.5 Lightning, Solar Pro 4, or Laguna S 2.1. Hungarian benchmarks exist (OpenHuEval, HuLU, HuGME, and the EU MMLU released 2026-07-22 which does cover Hungarian across 16 EU languages) but no article I found publishes model results on them for these models [S16][S17].

### 1f. Verdict against the actual pipeline (4000 calls, Hungarian, 64k JSON out)

- Nemotron 3.5 Lightning: cheapest credible non-Chinese candidate, but index 24 and a 3B-active model asked to emit a 64k-token strict JSON array is the risky combination. No Hungarian evidence. **TEST, on a small Hungarian sample, before committing.**
- Solar Pro 4: **SKIP.** API-only, single provider, Korean/English/Japanese only, and the price is a promotion.
- Laguna S 2.1: 1M context suits the fixed rulebook prefix, but it is a coding specialist with no extraction or multilingual evidence, single provider, and the free tier trains on your data. **WATCH.**
- If Chinese weights are acceptable, DeepSeek V4 Flash 0731 at index 52 / $0.1 is the model this pipeline actually wants [S1].

---

## 2. Comparison table, in-scope models

| Model | What it is | Released | Price (in/out per 1M) | Ctx | Max out | Strict schema | License | Verdict |
|---|---|---|---|---|---|---|---|---|
| nvidia/nemotron-3.5-lightning | 30B total / 3B active MoE, hybrid Mamba-Transformer, text-only reasoning, distilled from Nemotron 3 Ultra | 2026-08-11 [S3][S8] | $0.10/$0.25 (caller); OR page showed $0.05/$0.20 | 262k on OR [S8]; AA article says 1M [S2] | not verified | OR page lists structured outputs + tool calling but values not rendered; unverified | OpenMDW-1.1, commercial use, no permission needed [S2][S3] | **TEST** |
| upstage/solar-pro4 | Agentic API model, size undisclosed | 2026-08-10 per OR [S8]; 2026-08-11 per vendor blog [S5] | $0.03/$0.12 = 90% off, list $0.30/$1.20, $0.06 cached in, promo ends 2026-09-10 [S5][S8] | 524k OR [S8]; 512k in vendor post [S5] | 128k [S5] | Vendor states tool calling + structured outputs supported [S5] | **Proprietary, API only, no weights** [S5] | **SKIP** |
| poolside/laguna-s-2.1 | 117.6B total / 8.5B active MoE, 256 experts + 1 shared, 48 layers (12 global attn + 36 sliding window 512), Muon optimizer, coding specialist | 2026-07-21, checkpoint updated Aug 2026 [S6][S7] | $0.09/$0.18 (caller and OR, 10% off) [S8b]; earlier article quoted $0.10/$0.20/$0.01 cache read [S7] | 1,048,576 native, reducible to 262,144 [S6] | not verified | Interleaved thinking between tool calls, per-request thinking on/off; no explicit JSON-schema doc [S6] | OpenMDW-1.1 [S6] | **WATCH** |

Context notes for the reference models the caller asked not to deep-dive: Inkling 975B-A41B, Apache 2.0, 1M ctx, multimodal, AA index 42 [S1][S9]. Muse Glimmer 30B, Apache 2.0, 100+ languages claimed, AIME 2026 94.7 / SWE-Bench Verified 76.0 / MCP Atlas 75.5 / DeepSearch QA 74.6, all vendor claims [S10][S11]. Muse Spark 1.2 weights promised not released [S10].

---

## 3. Per-model notes

### nvidia/nemotron-3.5-lightning

**Strongest.** Speed-per-dollar on the non-Chinese side. AA measured ~670 output tok/s and about 0.5 minutes per Intelligence Index task, and calls it the accuracy-speed Pareto frontier for small open models [S2][S4]. Index 24 is a +9 jump over Nemotron 3 Nano's 15, and matches gpt-oss-120b at roughly a quarter of the total parameters [S2]. Agentic numbers beat its bigger sibling: GDPval-AA v2 Elo 824, above both gpt-oss-120b and Nemotron 3 Super, and Terminal-Bench v2.1 24% versus 7% for Nemotron 3 Nano [S2]. NVIDIA claims 86% on PinchBench while finishing 10,000 tasks 30% faster than Qwen3.6 35B at similar accuracy (vendor claim) [S4]. Licensing is genuinely permissive: OpenMDW-1.1, weights plus training data plus recipes, free commercial use, no permission request [S3]. Runs on one consumer GPU or DGX Spark [S3]. NVFP4 and BF16 checkpoints with minimal degradation between them [S2].

**Weakest.** Index 24 puts it below every Chinese model on the board and at the bottom of the non-Chinese tier. NVIDIA itself frames it as the wrong tool for complex reasoning [S4]. Text-only, no vision [S2][S8].

**Gotchas.**
- Context is contested: OpenRouter says 262k [S8], the AA launch article says 1M [S2]. Caller's verified figure is 262k. Assume 262k.
- Price is contested: caller says $0.10/$0.25, the OR page rendered $0.05/$0.20 [S8]. Possibly a routing-tier or promo difference.
- Parameter count varies by source: 31.6B/3.6B active per AA [S2], 30B/3B per NVIDIA [S3][S4].
- Quantisation differs across hosts. AA lists DeepInfra, Fireworks, FriendliAI, CoreWeave and others [S2]; OpenRouter routes across several with modes for balanced / speed / tool-calling accuracy [S8]. An NVFP4 host and a BF16 host are not the same model in practice.
- No published language list I could verify. The Hugging Face card returned HTTP 401 to my fetch.

### upstage/solar-pro4

**Strongest.** Very large context at 524k with a genuinely large 128k output cap, which is unusual and directly relevant to a 64k-output job [S5][S8]. Cached input at $0.06 per 1M (list) is built for repeated calls sharing a prefix, exactly the shape of a bulk pipeline [S5]. Solid agentic numbers: Terminal-Bench v2.1 57, AA-LCR long-document reasoning 71, tau-3-Banking multi-turn tool use 23, all improved over Solar Pro 3 [S5]. Confirmed tool calling and structured outputs [S5]. Korean capability is real and independently framed: sibling Solar Open 2 hits 86.8 Ko-GDPval, MMLU-Pro 86.2, LiveCodeBench 92.4, and a Korean benchmark average of 85.4 that edges DeepSeek-V4-Flash at 84.9 [S12].

**Weakest.** It is not an open-weight model at all. Upstage's own launch post is explicit that Solar Pro 4 is API-only and that Solar Open 2 is the open-weights product [S5].

**Gotchas.**
- **Price is a 90% promotion that expires 2026-09-10** [S5][S8]. List price is $0.30/$1.20. Any cost model built on $0.03/$0.12 is a 10x underestimate after that date. This is the single most important finding on this model.
- **Single upstream provider.** OpenRouter states one provider, requests forwarded directly, no failover [S8]. Upstage going down means the pipeline goes down.
- **Language support is Korean, English, Japanese, officially** [S5][S12]. No Hungarian, no European language evidence of any kind. For a Hungarian pipeline this alone disqualifies it.
- Release date differs by source: OR says 2026-08-10 [S8], the vendor blog says 2026-08-11 [S5].
- Model size, architecture, and training details are undisclosed.

### poolside/laguna-s-2.1

**Strongest.** Genuinely strong agentic coding for the size and price. SWE-bench Multilingual 78.5% edges Qwen 3.7 Max at 78.3%, and SWE-Bench Pro 59.4% beats DeepSeek-V4-Pro at 55.4%, from a 118B-A8B model [S6]. 1M native context at $0.09/$0.18 is the cheapest million-token window in this comparison. OpenMDW-1.1, weights public, fits on a single DGX Spark [S6][S7]. Per-request thinking on/off with interleaved thinking between tool calls, which is the right control surface for mixed cheap/expensive workloads [S6].

**Weakest.** Narrow. The card states it is designed specifically for software engineering and agentic coding, and asks users to confirm suitability for other applications [S6]. It loses badly outside its lane: DeepSWE 40.4% vs Kimi K3 69%, SWE Atlas 46.2% vs Claude Fable 5 70%, Toolathlon Verified 49.7% vs Muse Spark 1.1 75.6% [S6]. No AA Intelligence Index placement found.

**Gotchas.**
- **Single provider on OpenRouter**, requests forwarded directly [S8b].
- **Free tier usage may be used to train future models** per the OpenRouter page [S8b]. For proprietary rulebooks and product data this matters.
- **Long-context quality degradation is admitted on the card**: 1M is available, not free of cost [S6].
- Ops sharp edges: FP8 weights are ~121GB, needs vLLM 0.25.0+, and you must set `VLLM_BLOCKSCALE_FP8_GEMM_FLASHINFER=0` when serving with vLLM. Sampling defaults in `generation_config.json` are authoritative (top_k 20) [S6].
- SWE-bench **Multilingual** means multiple programming languages, not natural languages. Do not read 78.5% as evidence of Hungarian ability. The card gives no non-English natural-language evidence at all [S6].
- Note the caller's own record: this model replaced laguna-m.1, which was removed from OpenRouter.

---

## 4. Migration note: what OpenRouter removed and what replaced it

**The Llama family is over, and the removals are a consequence, not a routing decision.**

Meta ended the open-weight Llama line. On 2026-04-08 Meta Superintelligence Labs shipped **Muse Spark**, a closed-weight API-only reasoning model, Meta's first proprietary frontier release, replacing Llama as the flagship [S18]. Llama 4 underperformed and Meta restructured its AI group [S10]. In early August 2026 OpenRouter delisted the entire free Meta Llama tier, including llama-3.2-3b and llama-3.3-70b [S19]. So yes: **the Llama 3.x models are obsolete**. They are two generations behind the Nemotron 3 / Muse / Inkling class and were removed because Meta abandoned the line, not because of a supply problem.

Then on **2026-08-10** Zuckerberg partially reversed course: Meta released **Muse Glimmer**, a 30B open-weight model under **Apache 2.0**, distilled from Muse Spark, targeted at local agents on consumer hardware, weights on Hugging Face, Ollama and LM Studio [S10][S11]. He also committed to open sourcing **Muse Spark 1.2**, but as of 2026-08-10 those weights are promised only, not released [S10].

| Removed from OpenRouter | Replaced by |
|---|---|
| meta-llama/llama-3.2-3b, llama-3.2-11b-vision, llama-3.3-70b | meta/muse-glimmer-30b (Apache 2.0, 2026-08-10, 100+ languages claimed) for open weights; meta/muse-spark-1.2 for capability, still closed [S10][S11] |
| nvidia/llama-3.3-nemotron-super-49b-v1.5 | Nemotron 3 family, which is no longer a Llama derivative: Nemotron 3.5 Lightning 30B-A3B (index 24), Nemotron 3 Super 120B (26), Nemotron 3 Ultra 550B (38), hybrid Mamba-Transformer, OpenMDW-1.1 [S1][S2][S3] |
| mistralai/devstral-2512 | Mistral Small 4 (2026-03-16, Apache 2.0), which merged Devstral (agentic coding), Magistral (reasoning) and Pixtral (vision) into one configurable model [S14] |

**Mistral's current flagship.** The open-weight flagship is still **Mistral Large 3**, 675B total / 41B active sparse MoE, Apache 2.0, released 2025-12-02 [S13]. The most recent tracked release is **Mistral Medium 3.5** (2026-04-29), which AA scores at index 30, the top non-Chinese non-US open weight, though I could not verify its license [S1][S13]. A new "fat but sparse" MoE family entered early access in July 2026 with Arthur Mensch confirming an open-weight flagship, but I found no evidence it has shipped as of 2026-08-12 [S20]. Mistral has not released a frontier-class model in 2026; Large 3 is eight months old and sits below Inkling and Nemotron 3 Ultra.

---

## 5. Sources

| # | Source | URL | Date |
|---|---|---|---|
| S1 | Artificial Analysis, open weights model leaderboard | https://artificialanalysis.ai/models/open-source | fetched 2026-08-12 |
| S2 | Artificial Analysis, "NVIDIA launches Nemotron 3.5 Lightning" | https://artificialanalysis.ai/articles/nemotron-3-5-lightning-launch | Aug 2026, fetched 2026-08-12 |
| S3 | Business Standard / Compsmag / Coingape launch coverage, license + availability | https://www.business-standard.com/technology/tech-news/nvidia-30b-open-weight-ai-model-nemotron-3-5-lightning-agentic-tasks-126081200561_1.html | 2026-08-12 |
| S4 | NVIDIA Technical Blog, Nemotron 3.5 Lightning | https://developer.nvidia.com/blog/nvidia-nemotron-3-5-lightning-delivers-fast-accurate-specialized-task-execution-for-long-running-agents/ | Aug 2026, fetched 2026-08-12 |
| S5 | Upstage, "Solar Pro 4: The Agentic Model That Finishes the Job" | https://www.upstage.ai/blog/en/solar-pro-4 | 2026-08-11, fetched 2026-08-12 |
| S6 | Hugging Face model card, poolside/Laguna-S-2.1-FP8 | https://huggingface.co/poolside/Laguna-S-2.1-FP8 | benchmarks dated 2026-07-21, card updated Aug 2026 |
| S7 | VentureBeat, "Poolside drops Laguna S 2.1" | https://venturebeat.com/infrastructure/poolside-drops-laguna-s-2-1-an-open-weight-coding-model-that-beats-rivals-10x-its-size | 2026-07-21 |
| S8 | OpenRouter model pages: nvidia/nemotron-3.5-lightning, upstage/solar-pro4 | https://openrouter.ai/nvidia/nemotron-3.5-lightning , https://openrouter.ai/upstage/solar-pro4 | fetched 2026-08-12 |
| S8b | OpenRouter model page, poolside/laguna-s-2.1 | https://openrouter.ai/poolside/laguna-s-2.1 | fetched 2026-08-12 |
| S9 | Thinking Machines Lab, Inkling launch; Unite.AI and VentureBeat coverage | https://thinkingmachines.ai/news/introducing-inkling/ , https://huggingface.co/thinkingmachines/Inkling | 2026-07-15/16 |
| S10 | The Register, "Zuck rekindles open weights Llama drama with Muse Glimmer" | https://www.theregister.com/ai-and-ml/2026/08/10/zuck-rekindles-open-weights-llama-drama-with-muse-glimmer/5285666 | 2026-08-10, fetched 2026-08-12 |
| S11 | Hugging Face, meta-models/Muse-Glimmer-30B README | https://huggingface.co/meta-models/Muse-Glimmer-30B | 2026-08-10 |
| S12 | Upstage, "Solar Open 2: Korea's Sovereign Foundation Model"; HF upstage/Solar-Open2-250B | https://www.upstage.ai/blog/en/solar-open-2 , https://huggingface.co/upstage/Solar-Open2-250B | 2026 |
| S13 | Mistral Large 3 developer guide + LM Market Cap Mistral model list | https://lmmarketcap.com/mistral-models | Large 3 released 2025-12-02; Medium 3.5 2026-04-29 |
| S14 | Mistral AI, "Introducing Mistral Small 4" | https://mistral.ai/news/mistral-small-4/ | 2026-03-16 |
| S15 | BenchLM, multilingual leaderboard (MMLU-ProX weighted) | https://benchlm.ai/multilingual | August 2026, fetched 2026-08-12 |
| S16 | EU MMLU announcement, DG Translation | https://translation.ec.europa.eu/news-and-events/news/towards-fair-multilingual-ai-eu-mmlu-new-eu-benchmark-llms-2026-07-22_en | 2026-07-22, fetched 2026-08-12 |
| S17 | OpenHuEval, Hungarian-specific LLM benchmark | https://arxiv.org/html/2503.21500v1 | 2025 |
| S18 | Codersera / Miraflow coverage of Muse Spark launch and end of Llama | https://codersera.com/blog/muse-spark-complete-guide-2026/ | Muse Spark released 2026-04-08 |
| S19 | Teamday, OpenRouter free models status | https://www.teamday.ai/blog/best-free-ai-models-openrouter-2026 | early August 2026 |
| S20 | TechTimes, Mistral open-weight model July early access | https://www.techtimes.com/articles/319798/20260706/mistral-ai-targets-frontier-gap-open-weight-model-entering-july-early-access.htm | 2026-07-06 |

---

## 6. Could not verify

1. **Max output tokens** for nemotron-3.5-lightning and laguna-s-2.1. Neither the OpenRouter pages nor the model cards exposed it in what I fetched. Directly relevant to the 64k-output requirement. Verify via the OpenRouter `/api/v1/models` endpoint before building.
2. **Strict JSON schema support** for all three. Both OpenRouter pages reference a supported-parameters block that did not render in my fetches. Solar Pro 4's vendor post asserts structured outputs [S5] but I did not see the parameter list. Verify with a live `response_format: json_schema` probe.
3. **Nemotron 3.5 Lightning official language list.** The Hugging Face card `nvidia/NVIDIA-Nemotron-3.5-Lightning-30B-A3B` returned HTTP 401 to my fetch. NVIDIA's own blog does not state supported languages [S4].
4. **Hungarian performance for any in-scope model.** No evidence found, for Nemotron 3.5 Lightning, Solar Pro 4, or Laguna S 2.1. Not weak evidence: none. Hungarian benchmarks exist (OpenHuEval, HuLU, HuGME, EU MMLU) but I found no published run of these models on them.
5. **Nemotron 3.5 Lightning context window.** 262k per OpenRouter versus 1M per Artificial Analysis. Unresolved.
6. **Nemotron 3.5 Lightning price.** Caller's verified $0.10/$0.25 versus $0.05/$0.20 rendered on the OR page.
7. **Whether Mistral Medium 3.5 is genuinely open weights.** AA lists it on the open-weights board [S1], but I found no downloadable checkpoint or license confirmation. Mistral Medium has historically been API-only.
8. **AA Intelligence Index scores for Laguna S 2.1 and Muse Glimmer 30B.** Neither appears on the AA open-weights board fetched today, so they cannot be placed in the capability ranking on the same scale as the others.
9. **Whether Mistral's July 2026 early-access "fat but sparse" MoE flagship has shipped.** No shipping announcement found as of 2026-08-12.
10. **Muse Spark 1.2 weights.** Promised on 2026-08-10, no release confirmed. Recheck before relying on it.
11. **Exact removal dates** for llama-3.2-11b-vision and mistralai/devstral-2512 from OpenRouter. The cause is established (Meta ending Llama, Mistral folding Devstral into Small 4) but I found no per-model delisting notice.
