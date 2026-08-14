# Chinese open-weight models on OpenRouter, state as of 2026-08-12

Research date: 2026-08-12. Every factual claim below carries a numbered source. Prices were pre-verified by the requester and are reproduced, not re-checked; the per-provider price spreads shown here come from the OpenRouter endpoints API pulled live on 2026-08-12 [S1].

Method note: the per-provider facts (max output tokens, supported parameters, quantisation, served context, provider count) come from `https://openrouter.ai/api/v1/models/<slug>/endpoints`, pulled 2026-08-12 [S1]. That endpoint is the authority on what OpenRouter will actually accept, and it disagrees with several vendor model cards. Where they disagree, the API wins and the disagreement is flagged.

Two scope corrections up front:
- **qwen/qwen3.7-flash is NOT open weight.** It is proprietary, API only [S8][S9].
- **qwen/qwen3.8-max is NOT open weight today.** Weights were promised "next week" at launch and had not shipped as of 2026-08-10, with no license named [S6][S7].

---

## 1. Comparison table

| Model | What it is | Released | Price in/out/cache per M | Ctx (served) | Max out | Strict schema | Multilingual evidence | Verdict |
|---|---|---|---|---|---|---|---|---|
| deepseek/deepseek-v4-pro | 1.6T MoE, 49B active, MIT, text only [S2][S3] | 2026-04-24 [S1][S2] | $1.168 / $2.336 / $0.099 (routed default = Novita; first-party DeepSeek endpoint is $0.435/$0.87) [S1] | 1,048,576 on most; Together 512k, BaseTen 262k [S1] | 384k (DeepSeek), 1,048,576 (Cloudflare, CoreWeave, Parasail), **16,384 (DeepInfra)**, 32,768 (Venice) [S1] | `structured_outputs` on 13 of 18 endpoints; **first-party DeepSeek endpoint has `response_format` only, no `structured_outputs`** [S1] | No Hungarian evidence found | **WATCH** (quality ceiling fallback) |
| deepseek/deepseek-v4-flash-0731 | 284B MoE, 13B active, MIT, re-post-trained July build [S1][S4][S10] | 2026-07-31 [S1][S10] | $0.08 / $0.18 / $0.016 | 1,048,576 on most; AkashML 131k, Decart/Sail 262k [S1] | 384k (DeepSeek, DeepInfra), 393,216 (Novita, AtlasCloud, SiliconFlow), 1,048,576 (BaseTen, Parasail, Ambient, Morph, Inceptron), 131,072 (Baidu, Ionstream), 65,536 (Io Net), 32,768 (Venice) [S1] | `structured_outputs` on 19 of 24 endpoints [S1] | No Hungarian evidence found | **TEST (rank 1)** |
| deepseek/deepseek-v4-flash (alias) | Same 284B/13B model, **April build**; OpenRouter names this slug "DeepSeek V4 Flash 0423" [S1] | 2026-04-24 [S1] | $0.14 / $0.28 | 1,048,576 on most [S1] | 393,216 (SiliconFlow, Alibaba, Novita, AtlasCloud, Phala), 384k (StreamLake, Cloudflare), **65,536 (DeepInfra)**, 32,768 (Venice) [S1] | `structured_outputs` on 13 of 17 endpoints [S1] | No Hungarian evidence found | SKIP (superseded by 0731) |
| qwen/qwen3.8-max | 2.4T total / ~95B active multimodal, **closed weights today** [S6][S7] | 2026-08-03 [S1][S6] | $2.00 / $6.00 | 1,000,000, **single provider (Alibaba)** [S1] | 131,072 [S1] | Yes, `structured_outputs` listed [S1] | No Hungarian evidence found | **WATCH** (only if weights land) |
| qwen/qwen3.7-flash | Vision-language reasoning model, **proprietary**, no tech report, no param count [S1][S8][S9] | 2026-07-27 [S1] | $0.03 / $0.13 sticker, **tiered: $0.10/$0.40 above 32k prompt, $0.20/$0.80 above 256k** [S9] | 1,000,000, **single provider (Alibaba)** [S1] | 65,536 [S1] | **No.** Model card claims structured outputs; OpenRouter exposes `response_format` only, no `structured_outputs` [S1][S9] | No Hungarian evidence found | **TEST (rank 3, as cheap control only)** |
| z-ai/glm-5.2 | 753B MoE, 40B active, MIT, weights on HF + ModelScope [S5] | 2026-06-16 on OpenRouter, weights 2026-06-17 [S1][S5] | $0.50 / $3.15 (cheapest = Sail Research; Z.AI first-party $1.40/$4.40) [S1] | 1,048,576 on most; DigitalOcean 262k, AkashML 96,890, Ambient 202,752 [S1] | 131,072 typical; 1,048,576 (Decart, Inceptron, Morph, Friendli); 262,144 (Cloudflare, CoreWeave, Parasail, BaseTen, SiliconFlow) [S1] | `structured_outputs` on ~20 of 26 endpoints; **SiliconFlow lists neither `response_format` nor `structured_outputs`**; DigitalOcean, Novita, AtlasCloud, Z.AI list `response_format` only [S1] | Only a soft third-party claim that the vocabulary is "aggressively multilingual" [S12]. No Hungarian benchmark found | **TEST (rank 2)** |
| moonshotai/kimi-k3 | 2.8T MoE, 16 of 896 experts active, KDA + AttnRes, native vision, **custom license with a $20M revenue MaaS gate** [S13][S14] | 2026-07-16 on OpenRouter, weights ~2026-07-27 [S1][S13] | $3.00 / $15.00 | 1,048,576; Sail Research 974,842; Together 1,000,000 [S1] | **16,384 (DeepInfra)**, 65,535 (Chutes), 262,144 (BaseTen), 1,048,576 (Morph, Wafer, Modal) [S1] | Yes on most endpoints; json_schema confirmed to return conforming objects [S15] | No Hungarian evidence found | SKIP for bulk (see gotchas) |
| minimax/minimax-m3 | 428B MoE, ~23B active, GQA + MiniMax Sparse Attention, native text/image/video, **custom minimax-community license** [S11] | 2026-06-01 [S1][S11] | $0.30 / $1.20 | **Mostly 524,288, not 1M.** Only GMICloud, Novita and Parasail serve near 1M [S1] | 32,768 (Parasail), 65,536 (Venice), 131,072 (Novita), 256,000 (Morph), 512,000 (DeepInfra, Minimax) [S1] | **Patchy.** `structured_outputs` on only 3 of 9 endpoints (Together, Parasail, Morph). Novita, AtlasCloud and Venice expose no `response_format` at all [S1] | No Hungarian evidence found | SKIP / WATCH |
| inclusionai/ling-3.0-flash | 124B MoE, 5.1B active, hybrid reasoning, KDA + MLA 5:1, MIT weights [S16][S17] | Model 2026-07-23, weights MIT 2026-08-05 [S1][S16] | $0.021 / $0.063 | 262,144 (Novita), 131,072 (DeepInfra). **Only 2 providers** [S1] | **32,768 on both providers** [S1] | **No.** Neither endpoint lists `structured_outputs` OR `response_format`. Only `tools` / `tool_choice` [S1] | No Hungarian evidence found | **SKIP** |
| meituan/longcat-2.0 | 1.6T MoE, ~48B active, LongCat Sparse Attention, native 1M ctx, MIT, trained end to end on Chinese chips [S18][S19] | Open-sourced 2026-06-30 [S18], OpenRouter listing 2026-07-20 [S1] | $0.30 / $1.20 | 1,048,756, **single provider (AtlasCloud), fp8** [S1] | 262,144 [S1] | **No.** No `response_format`, no `structured_outputs`. Only `tools` / `tool_choice` [S1] | No Hungarian evidence found | **SKIP** |

Independent intelligence ranking, Artificial Analysis, August 2026 [S20][S21]: Kimi K3 (max) 60, GLM-5.2 (max) 53, DeepSeek V4 Flash 0731 (reasoning, max effort) 52. A second aggregation of the same index reports Kimi K3 57, GLM-5.2 51, DeepSeek V4 Pro (max reasoning) 44 [S12]. Note the two aggregations disagree by 2 to 3 points, so treat these as ordinal, not exact. The striking result is that **V4 Flash 0731 outscores V4 Pro** on this index at roughly a fifteenth of the price. Reference point: Claude Opus 5 (adaptive reasoning, max effort) sits at 63 [S20].

---

## 2. Per-model detail

### deepseek/deepseek-v4-pro

**Strongest point:** the widest provider pool of any model here (18 endpoints), MIT license, and a first-party DeepSeek endpoint priced at $0.435/$0.87, well under the routed default the OpenRouter model page shows [S1].

**Weakest point:** it is beaten on the Artificial Analysis index by its own Flash sibling at 0731 while costing roughly 15x more [S20][S12]. There is no measured reason to pay for Pro on an extraction workload.

Gotchas:
- The **first-party DeepSeek endpoint does not list `structured_outputs`**, only `response_format` [S1]. If you route by price you land on the endpoint with the weakest schema enforcement.
- **DeepInfra caps output at 16,384 tokens** on this model [S1]. A 64k JSON array is impossible there and will truncate silently mid-array.
- Quantisation varies across fp4 (Ionstream, DeepInfra, AtlasCloud, BaseTen), fp8, and unknown [S1]. fp4 endpoints are the ones that show up cheap in price sorting.
- Text only. No image input [S1].

**How to drive it well:** pin a single provider that lists `structured_outputs` and a max output above your ceiling. CoreWeave and Cloudflare both list `structured_outputs` and 1,048,576 max output [S1]. Set `reasoning_effort` explicitly; the parameter is accepted on every endpoint [S1].

### deepseek/deepseek-v4-flash-0731 and the deepseek-v4-flash alias

**What the dated variant actually is.** DeepSeek shipped 0731 on 2026-07-31 as a public beta re-post-training of the same 284B/13B architecture, not a new model, adding native Responses API support and a Codex integration [S10]. The slug `deepseek/deepseek-v4-flash`, which the requester called the alias, is on OpenRouter literally titled **"DeepSeek V4 Flash 0423"** with a created date of 2026-04-24 [S1]. So it is not a floating alias that tracks the newest build. It is the pinned April build. (A separate slug `~deepseek/deepseek-v4-flash-latest` exists and is the actual floating pointer [S10].)

**Why they are priced differently.** Nothing about the model changed in size. The 0731 slug attracted 24 competing endpoints including several bidding at $0.08/M input (DeepInfra, OpenInference, DigitalOcean) and Decart at $0.081/$0.162, whereas the 0423 slug has 17 endpoints and its low end sits higher in the default routing [S1]. OpenRouter's headline price is the routed default over the live provider set, so the newer, more contested slug is cheaper. Third-party reporting puts the 0731 input price about 36 percent below 0423 [S10]. Practical consequence: the dated slug is both newer and cheaper, and there is no reason to use the 0423 slug.

**Strongest point:** best measured intelligence per dollar in the whole field. Artificial Analysis places 0731 at 52 on the intelligence index, third among open weights, at $0.08/$0.18 with $0.016 cache reads [S20]. 19 of 24 endpoints expose `structured_outputs`, and many allow 384k or more output tokens [S1].

**Weakest point:** the intelligence-index number is measured at **max reasoning effort** [S20], and reasoning tokens are billed as output. The headline price is not the price you will pay if you leave effort high.

Gotchas:
- Provider quantisation ranges from bf16 (Morph) through fp8 to fp4 (DeepInfra, Decart, Sail Research, Inceptron, AtlasCloud, Ambient, Ionstream) [S1]. Cheap and fp4 correlate.
- Max output varies by a factor of 32 across providers, from 32,768 (Venice) to 1,048,576 [S1]. Auto-routing between providers mid-batch will change your effective output ceiling between calls.
- Served context varies: AkashML 131,072, Decart / Sail Research / CoreWeave 262,144, most others 1,048,576 [S1].
- Availability is the one thing that is not a risk here. 24 endpoints is the deepest pool in the field.

**How to drive it well:** pin one provider, set `reasoning_effort` low or off for extraction, use `structured_outputs` with a JSON schema, set `max_tokens` explicitly, and lean hard on the $0.016 cache read for the fixed rulebook prefix. That prefix caching is the single biggest cost lever available across all models here.

### qwen/qwen3.8-max

**Strongest point:** flagship-tier multimodal reasoning (text, image, video in) with a 1M window, `structured_outputs` supported, at $2.00/$6.00 [S1].

**Weakest point:** it is not open weight. Alibaba said Qwen3.8-Max and Qwen3.8-27B would hit Hugging Face and ModelScope within a week of the 2026-08-03 launch; as of 2026-08-10 the week had passed, neither model was on Hugging Face, and no license had been named [S6][S7].

Gotchas:
- **Single provider (Alibaba).** No failover, no price competition, no quant choice [S1].
- Max output 131,072, well below the 1M context [S1].
- The 2.4T total / ~95B active figure is a vendor claim, unverified by any independent eval found [S6][S7].

**How to drive it well:** treat as a closed frontier API, not an open-weight option. Revisit if and when weights ship.

### qwen/qwen3.7-flash (scrutinised hardest, as requested)

**Strongest point:** $0.03/M input is the lowest sticker price of any capable multimodal model, with a 1M window and vision plus video input [S1].

**Weakest point:** the $0.03 is a sub-32k-prompt rate. Above 32k prompt tokens it becomes $0.10/$0.40, and above 256k it becomes $0.20/$0.80 [S9]. OpenRouter's own observed 30-day customer blend is $0.044 input and $0.149 output, above the list price [S9]. For a pipeline whose defining feature is a long fixed rulebook prefix, the sticker price is close to fictional: if the prefix pushes you past 32k, you pay $0.10/M, which is **more than DeepSeek V4 Flash 0731 at $0.08/M**, from a model with no schema enforcement and one provider.

Gotchas:
- **Not open weight.** Proprietary, no published technical report, no parameter count, no benchmarks from Alibaba [S9].
- **No `structured_outputs` on OpenRouter.** The model card claims structured output support but OpenRouter exposes only `response_format` [S1][S9]. That means JSON-mode-ish nudging, not server-side schema validation.
- Thin parameter surface generally: no `reasoning_effort` (only a `reasoning` toggle), no `frequency_penalty`, no `stop`, no `top_k`, no `structured_outputs` [S1]. `stop` missing is a real annoyance for streamed array output.
- **Max output 65,536** [S1], which is exactly the 64k the pipeline wants, with zero headroom, and reasoning tokens compete for that same budget.
- **Single provider (Alibaba).** No failover [S1].
- Latency tail: 59 tok/s at P50, and P99 at 90.19 seconds, roughly one request in a hundred taking a minute and a half [S9]. Over 4000 calls that is ~40 requests hitting 90 seconds.
- Tool call error rate 8.88 percent versus 6.45 percent for the Plus tier [S9].
- Independent quality: Roboflow's vision benchmark ranks it 22nd of 23 overall at 61.7 percent, last on OCR at 84.1 percent [S9]. That is a vision-specific result and does not directly bound its Hungarian text extraction, but it is the only independent number available for this model.
- Third-party guidance explicitly says do not use it for document extraction or precise localisation [S9].

**How to drive it well:** if tested at all, test it as a price control with a hard `max_tokens`, an aggressive client-side JSON repair layer, and a measured prompt-token count so you know which pricing tier you are actually in. Do not assume $0.03.

### z-ai/glm-5.2

**Strongest point:** the best-documented open-weight release in the set. MIT with no commercial restrictions, no hosting carve-outs, no fine-tuning limits, weights on Hugging Face under `zai-org` and on ModelScope, published on 2026-06-17 [S5]. 753B total / 40B active. Artificial Analysis index 51 to 53, first among open weights at launch [S5][S20]. FrontierSWE 74.4 percent, Terminal-Bench 2.1 81 percent, Code Arena Frontend 1595, GDPval-AA number 3, ARC-AGI-2 22.8 percent [S5]. Roughly 26 endpoints on OpenRouter, so availability is strong.

**Weakest point:** output at $3.15/M is 17x DeepSeek V4 Flash 0731's $0.18. On a 64k-output job that dominates the bill, and reasoning tokens are output tokens.

Gotchas:
- **SiliconFlow exposes neither `response_format` nor `structured_outputs`** [S1]. DigitalOcean, Novita, AtlasCloud and the Z.AI first-party endpoint expose `response_format` but not `structured_outputs` [S1]. Price-sorted routing can land you on a schema-weak endpoint.
- Served context varies sharply: AkashML 96,890, Ambient 202,752, DigitalOcean 262,144, versus 1,048,576 elsewhere [S1]. A 1M-context prompt will simply fail on some endpoints.
- Max output is 131,072 on most endpoints, 96,890 on AkashML [S1].
- Quantisation spans fp4 (Decart, DeepInfra, Inceptron, CoreWeave, Morph, Parasail, Wafer, AtlasCloud on one endpoint) and fp8 [S1].
- The multilingual claim is soft. One third-party comparison says the vocabulary is "aggressively multilingual" and that the prior GLM-5.1 was the right default for a 60 percent multilingual ticket mix [S12]. That is a blog assertion, not a benchmark.

**How to drive it well:** pin Sail Research ($0.50/$3.15, fp8, `structured_outputs` listed, 131,072 max output) or CoreWeave, use a JSON schema, cap `reasoning_effort`, and budget for reasoning tokens as billed output.

### moonshotai/kimi-k3

**Strongest point:** the strongest open-weight model measured. Artificial Analysis index 60 at max effort, third overall behind only Claude Fable 5 and GPT-5.6 Sol, first on the Frontend Code Arena [S20]. Number 1 on Program Bench, SWE Marathon, BrowseComp, SpreadsheetBench 2 and Automation Bench [S13]. `response_format` with `json_schema` is confirmed to return conforming objects [S15].

**Weakest point:** it is architected against cheap bulk work. Reasoning is always on, `reasoning_effort` defaults to `max`, and there is no non-thinking variant to fall back to [S13][S15]. Reasoning tokens are billed output at $15/M.

Gotchas:
- **License is not MIT.** It is a custom document with a commercial gate: running K3 as a paid Model-as-a-Service requires a separate agreement with Moonshot once the business crosses $20M/year in revenue from that use [S13].
- **Rate-limit accounting trap.** Moonshot's gateway counts input tokens plus the *requested* `max_completion_tokens` toward your TPM budget even when the model returns a short answer, and if you omit the field it assumes the default 131,072 output allowance [S15]. A 4000-call batch that omits `max_completion_tokens` will burn TPM 131k at a time and 429 almost immediately. Moonshot has not published per-tier RPM/TPM numbers, so any specific figure quoted elsewhere is unverified [S15].
- Cost blow-up: a query a non-reasoning model answers in 200 tokens can cost 1,000 to 3,000 tokens at max effort [S15].
- One report says the API accepts `reasoning_effort: "none"` despite the docs, cutting simple-query cost 6.3x [S15]. Single source, treat as unverified.
- **Sampling params unsupported on the first-party path.** The Moonshot AI endpoint on OpenRouter exposes no `temperature`, `top_p`, `top_k`, `seed` or `logprobs` at all [S1]. Community-hosted endpoints (Morph, DeepInfra, Fireworks, Wafer) do expose them because they serve the open weights themselves, which means **your sampling behaviour changes depending on which provider you land on**.
- **DeepInfra caps output at 16,384 tokens** [S1]. Chutes caps at 65,535 [S1].
- Quantisation is mxfp4 on the first-party, Chutes and Modal endpoints, fp4 on Morph and Sail Research, fp8 on BaseTen, bf16 on DeepInfra [S1]. mxfp4 is the native release format [S14].

**How to drive it well:** always send an explicit, tight `max_completion_tokens`, set `reasoning_effort` down from `max`, and pin a provider. Use it as a quality reference to score cheaper models against, not as the bulk workhorse.

### minimax/minimax-m3

**Strongest point:** the only genuinely native multimodal open-weight model here, text, image and video in from step 0 of training, paired with frontier agentic coding: vendor-claimed 80.5 percent SWE-bench Verified, 66.0 percent Terminal-Bench 2.1, ~80 percent MMMU-Pro [S11].

**Weakest point:** the schema surface is the weakest of any model with a real provider pool, and the advertised context is not what most providers serve.

Gotchas:
- **Only 3 of 9 endpoints list `structured_outputs`** (Together, Parasail, Morph). Novita, AtlasCloud and Venice expose **no `response_format` at all** [S1]. The MiniMax first-party endpoint has `response_format` but not `structured_outputs` [S1].
- **Context is 524,288 on most endpoints, not the advertised 1M** [S1]. Only GMICloud (1,048,576), Novita (1,000,000) and Parasail (1,048,576) approach the headline.
- Max output spans 32,768 (Parasail) to 512,000 (DeepInfra, MiniMax) [S1]. Parasail is the endpoint that also advertises the full 1M context, so the endpoint with the best context has the worst output cap.
- No `reasoning_effort` on any endpoint, only a `reasoning` toggle [S1].
- License is a custom `minimax-community` license, not MIT [S11].
- The launch benchmark claims were reported as unverified at the time [S11], and Artificial Analysis's own writeup was headlined "leading open weights model, once the weights are released" [S11], meaning the numbers preceded the artefact.

**How to drive it well:** if used, pin Together or Parasail for `structured_outputs`, verify the served context matches your prompt length, and set `max_tokens` under the pinned provider's cap.

### inclusionai/ling-3.0-flash

**Strongest point:** genuinely extraordinary economics. 124B total with only 5.1B active per token, MIT weights published 2026-08-05, at $0.021/$0.063 [S1][S16]. Ant claims it matches or beats their own 1T flagship on most benchmarks shown with one eighth the total and one twelfth the active parameters [S16][S17].

**Weakest point, and it is disqualifying for this use case:** no structured output path and a 32,768-token output ceiling.

**The `structured_outputs` question, confirmed.** Pulled live on 2026-08-12, both endpoints (Novita and DeepInfra) list `tools` and `tool_choice` but **neither `structured_outputs` nor `response_format`** [S1]. What that means in practice:
- There is no server-side JSON-schema-constrained decoding available. Nothing in the stack guarantees the emitted tokens form valid JSON, let alone your schema.
- There is also no JSON mode. `response_format: {"type": "json_object"}` is the weaker, older guarantee, and even that is absent, so the model is free to emit prose, markdown fences, or a truncated array.
- OpenRouter will not silently emulate it for you. When a provider does not declare a parameter, OpenRouter's normalisation either drops it or refuses to route, depending on your `require_parameters` setting. Sending a schema and assuming enforcement is the failure mode to avoid.
- The one structured path that does exist is **function calling**: `tools` is supported, so you can define a single tool whose arguments are your schema and force it with `tool_choice`. That gives you a schema-shaped target, but the enforcement quality depends entirely on the provider's tool-call implementation and is not equivalent to constrained decoding.
- Net effect for a bulk pipeline: you must implement your own validate-and-repair loop and budget for a non-trivial reject rate, which eats the price advantage.

Other gotchas:
- **Max output 32,768 on both providers** [S1]. A 64k-token JSON array is structurally impossible. This alone ends the conversation for the stated use case.
- **Only 2 providers** [S1]. Single-digit redundancy.
- Served context is 262,144 (Novita) and only 131,072 (DeepInfra), against a native 256K design [S16].
- DeepInfra is bf16 but priced at $0.06/$0.18, roughly 3x the Novita price [S1]. The headline $0.021 is Novita only, and Novita's quantisation is reported as unknown [S1].
- No `reasoning_effort` despite being a hybrid-reasoning model [S1].
- Zero independent evaluation found. Every performance number traces to Ant's own release [S16][S17].

**How to drive it well:** single forced tool call as the schema carrier, chunk output well under 32k, full client-side validation. Realistically, use it for short classification calls, not long array extraction.

### meituan/longcat-2.0

**Strongest point:** 1.6T MoE with ~48B active and a native 1M context under a permissive MIT license, and it has a real track record: it topped OpenRouter's global usage charts for two months under the codename "Owl Alpha" before being revealed [S18][S19]. It is also the first trillion-parameter model trained and served end to end on Chinese-made chips with no Nvidia GPUs [S18].

**Weakest point:** on OpenRouter it is served by exactly **one provider (AtlasCloud, fp8)** [S1]. Single upstream, no failover, no quant choice, no price competition. For a 4000-call batch that is a real outage risk.

Gotchas:
- **No `response_format`, no `structured_outputs`** on the only endpoint [S1]. Same practical consequences as Ling above: forced tool call or client-side repair.
- No `reasoning_effort` [S1].
- Max output 262,144, which is generous, but useless without schema enforcement [S1].
- Release date sources conflict: VentureBeat and several outlets say open-sourced 2026-06-30 [S18], MarkTechPost dates the release announcement 2026-07-05 [S19], and the OpenRouter listing was created 2026-07-20 [S1]. Flagged, not resolved.
- Text only, no image input [S1].

**How to drive it well:** single forced tool call, explicit `max_tokens`, and a fallback model configured because there is no second provider.

---

## 3. Ranked shortlist: three worth benchmarking on Hungarian structured extraction

**1. deepseek/deepseek-v4-flash-0731.** Highest independently measured intelligence per dollar in the set (Artificial Analysis 52, third among open weights, at $0.08/$0.18) [S20], `structured_outputs` on 19 of 24 endpoints, output ceilings up to 384k and beyond, MIT, and a 24-provider pool that removes availability risk [S1]. The $0.016 cache read is the right shape for a long fixed rulebook prefix.
**Biggest single risk:** the 52 score is measured at max reasoning effort [S20]. If Hungarian extraction quality only holds at max effort, reasoning tokens bill as output and the cost advantage over GLM-5.2 shrinks a lot. Measure quality at low effort and at max effort, and price both.

**2. z-ai/glm-5.2.** Best-documented open-weight release (MIT, no carve-outs, weights on HF and ModelScope), strongest independent benchmark trail, deep provider pool, `structured_outputs` on most endpoints, and the only model in the field with even a soft third-party claim of multilingual strength [S5][S12][S20].
**Biggest single risk:** $3.15/M output. On a 64k-output-per-call job with 4000 calls it is by far the most expensive of the three, and reasoning tokens count as output. If it does not beat V4 Flash 0731 on Hungarian by a wide margin, the price cannot be justified.

**3. qwen/qwen3.7-flash, as a price control only.** Include it to establish the floor, not because it is expected to win.
**Biggest single risk:** three risks that compound, and any one could disqualify it. No `structured_outputs` on OpenRouter despite the model card [S1][S9]; a 65,536 max output with zero headroom over the 64k target [S1]; and tiered pricing where a long prefix moves you to $0.10/$0.40, making it more expensive per input token than V4 Flash 0731 [S9]. Measure your actual prompt token count before believing any cost projection.

**Quality reference, not a candidate:** run a 50-call Kimi K3 sample to establish the Hungarian quality ceiling and score the cheap models against it. Do not run 4000 calls through it: mandatory reasoning at $15/M output plus the TPM accounting trap (input plus *requested* `max_completion_tokens`, defaulting to 131,072 if omitted) makes a bulk batch both expensive and 429-prone [S15].

**Explicitly out:** ling-3.0-flash (32,768 max output kills a 64k array; no schema surface at all) and longcat-2.0 (single provider, no schema surface) [S1]. minimax-m3 is WATCH: the schema surface is too patchy across providers and the served context is half the advertised figure [S1].

---

## 4. Sources

1. OpenRouter endpoints API, `https://openrouter.ai/api/v1/models/<slug>/endpoints`, pulled live 2026-08-12. Source for all per-provider max output tokens, supported parameters, quantisation, served context, provider counts, per-endpoint pricing, and OpenRouter listing dates.
2. `https://huggingface.co/deepseek-ai/DeepSeek-V4-Pro` and `https://deepseek.ai/deepseek-v4`, accessed 2026-08-12. 1.6T total / 49B active, MIT, released 2026-04-24.
3. `https://www.opensourceforu.com/2026/08/deepseek-open-sources-v4-flash/`, August 2026. DeepSeek open-sources V4-Flash under MIT.
4. `https://huggingface.co/deepseek-ai/DeepSeek-V4-Flash`, accessed 2026-08-12. 284B total / 13B active.
5. `https://ai-beat.github.io/news/2026/06/glm-5-2-weights-delivered/` and `https://venturebeat.com/technology/z-ais-open-weights-glm-5-2-beats-gpt-5-5-on-multiple-long-horizon-coding-benchmarks-for-1-6th-the-cost`, June 2026. GLM-5.2 weights 2026-06-17, MIT, 753B/40B, FrontierSWE 74.4, Terminal-Bench 2.1 81, Code Arena Frontend 1595, GDPval-AA #3, ARC-AGI-2 22.8.
6. `https://www.testingcatalog.com/qwen-released-qwen3-8-max-with-open-weights-coming-soon/` and `https://www.scmp.com/tech/article/3362738/alibabas-ai-model-qwen38-max-made-widely-accessible-ahead-open-weights-release`, August 2026. Launch 2026-08-03, $2/$6, weights promised ~2026-08-10.
7. `https://cryptorank.io/news/feed/33f20-qwen3-8-max-the-capability-war-begins-alibaba-matches-us-closed-model-pricing-on-eve-of-open-weights-drop`, August 2026. As of 2026-08-10 neither Qwen3.8-Max nor Qwen3.8-27B was on Hugging Face and no license had been named. 2.4T total / ~95B active (vendor claim).
8. `https://openrouter.ai/qwen/qwen3.7-flash`, accessed 2026-08-12. Listed 2026-07-27, proprietary, single provider.
9. `https://www.eesel.ai/blog/qwen-3-7-flash-review`, accessed 2026-08-12. Tiered pricing ($0.10/$0.40 above 32k, $0.20/$0.80 above 256k), OpenRouter 30-day blend $0.044/$0.149, 59 tok/s P50 and 90.19s P99, 8.88 percent tool call error rate, Roboflow 22nd of 23 at 61.7 percent and last on OCR at 84.1 percent, structured outputs on the card but not exposed via OpenRouter, max output 65,536, closed weights, no technical report.
10. `https://ai-hippo.com/en/insights/deepseek-v4-flash-review/` and `https://openrouter.ai/deepseek/deepseek-v4-flash-0731`, accessed 2026-08-12. 0731 is a re-post-trained build shipped 2026-07-31 as public beta, same architecture and size as the April preview, adds native Responses API and Codex integration, roughly 36 percent cheaper input than 0423. `~deepseek/deepseek-v4-flash-latest` is the floating pointer slug.
11. `https://www.morphllm.com/minimax-m3`, `https://www.techtimes.com/articles/317532/20260601/minimax-m3-open-weight-coding-model-frontier-claims-unverified-benchmarks.htm`, `https://artificialanalysis.ai/articles/minimax-m3`, June 2026. Released 2026-06-01, 428B/23B, minimax-community license, SWE-bench Verified 80.5, Terminal-Bench 2.1 66.0, MMMU-Pro ~80 (vendor claims, reported as unverified at launch).
12. `https://www.marktechpost.com/2026/07/18/kimi-k3-vs-deepseek-v4-pro-vs-glm-5-2-open-trillion-scale-moe-models-compared-on-benchmarks-license-and-serving-cost/` and `https://lumienai.com/news/kimi-k3-deepseek-v4-pro-glm-5-2-moe-models-benchmarks-cost-license`, 2026-07-18. AA index Kimi K3 57, GLM-5.2 51, DeepSeek V4 Pro (max reasoning) 44; GLM-5.2 vocabulary described as aggressively multilingual.
13. `https://www.kimi.com/blog/kimi-k3`, `https://huggingface.co/moonshotai/Kimi-K3`, `https://roo.beehiiv.com/p/kimi-k3-open-weights-license-benchmarks`, July 2026. 2.8T, 16 of 896 experts, KDA + AttnRes, custom license with $20M/year MaaS commercial gate, reasoning always on with effort low/high/max defaulting to max, #1 on Program Bench, SWE Marathon, BrowseComp, SpreadsheetBench 2, Automation Bench.
14. `https://huggingface.co/blog/ResterChed/kimi-k3-model-overview-mxfp4-quantization-open-wei`, July 2026. MXFP4 native release format, weights 2026-07-27.
15. `https://synthorai.io/blog/kimi-k3-cost-measured/`, `https://kimi-ai.chat/docs/rate-limits/`, `https://platform.kimi.ai/docs/guide/use-reasoning-effort`, `https://www.together.ai/blog/kimi-k3-guide`, July to August 2026. Reasoning tokens billed as output, 200-token answer can cost 1,000 to 3,000 tokens at max effort, gateway counts input plus requested `max_completion_tokens` toward rate limits with a 131,072 default when omitted, no published per-tier RPM/TPM, `reasoning_effort: none` reportedly accepted cutting simple-query cost 6.3x, json_schema returns conforming objects.
16. `https://huggingface.co/inclusionAI/Ling-3.0-flash`, `https://www.businesswire.com/news/home/20260726584441/en/Ant-Group-Unveils-Ling-3.0-Flash-Delivering-Top-Tier-Performance-at-a-Fraction-of-the-Parameter-Scale`, `https://cryptobriefing.com/ant-group-ling-3-flash-124b-open-weights/`, July to August 2026. Released 2026-07-23, MIT weights 2026-08-05, 124B total / 5.1B active, KDA and MLA at 5:1, 256K native context, BF16 255GB and FP8 128GB.
17. `https://x.com/AntLingAGI/status/2080351022028095681`, July 2026. Vendor claim that Ling-3.0-flash matches or beats Ant's 1T flagship with one eighth total and one twelfth active parameters.
18. `https://venturebeat.com/technology/meituan-open-sources-longcat-2-0-the-1-6t-near-frontier-agentic-coding-model-thats-been-leading-openrouter-trained-entirely-on-chinese-chips` and `https://techjacksolutions.com/ai-brief/meituan-longcat-2-open-source-1-6t-moe-mit-license/`, 2026-06-30. 1.6T / ~48B active, MIT, native 1M context, trained end to end on Chinese chips, previously "Owl Alpha" topping OpenRouter for two months.
19. `https://www.marktechpost.com/2026/07/05/meituan-releases-longcat-2-0-a-1-6t-parameter-open-moe-model-with-native-1m-context-and-longcat-sparse-attention/`, 2026-07-05. LongCat Sparse Attention, native 1M context. Date conflicts with S18.
20. `https://benchlm.ai/benchmarks/artificialanalysis` and `https://artificialanalysis.ai/leaderboards/models`, August 2026. Top open weights by AA Intelligence Index: Kimi K3 (max) 60, GLM-5.2 (max) 53, DeepSeek V4 Flash 0731 (reasoning, max effort) 52. Claude Opus 5 (adaptive reasoning, max effort) 63 overall.
21. `https://artificialanalysis.ai/articles/artificial-analysis-intelligence-index-v4-1`, 2026. Index v4.1 methodology shift toward agentic workloads.
22. `https://translation.ec.europa.eu/news-and-events/news/towards-fair-multilingual-ai-eu-mmlu-new-eu-benchmark-llms-2026-07-22_en`, 2026-07-22. EU MMLU covers 16 EU official languages including Hungarian. No scores for any model in this report were found.
23. `https://arxiv.org/pdf/2503.21500` (OpenHuEval, Hungarian specifics) and HuLU, accessed 2026-08-12. Hungarian evaluation benchmarks exist. No results found for any 2026 Chinese model on them.

---

## 5. Could not verify

- **Hungarian competence for every single model in this report.** No Global-MMLU, MMMLU, MMLU-ProX, Flores, EU MMLU, OpenHuEval or HuLU result was found for DeepSeek V4 Pro, V4 Flash (either build), Qwen3.8-Max, Qwen3.7-Flash, GLM-5.2, Kimi K3, MiniMax M3, Ling-3.0-flash or LongCat 2.0. **No evidence found.** The only adjacent signal is a blog assertion that GLM-5.2's vocabulary is "aggressively multilingual" [S12], which is not a measurement. Hungarian quality must be measured in-house; there is no published number to lean on.
- **No credible community reports of Central and Eastern European language quality** were found for any of these models. Existing CEE work centres on Polish (Bielik, LLMzSzŁ) and does not cover 2026 Chinese frontier models.
- **IFBench and IFEval scores: none published** for any model in this set. Instruction-following claims here are inferred from agentic benchmarks (Program Bench, SWE Marathon, Terminal-Bench), which is not the same thing.
- **Schema-holding over long output: no published measurement** for any model. No source documents a failure rate for holding a JSON schema across a 64k-token output. This is the single most important unknown for the use case and can only be resolved by running it.
- **Qwen3.7-Flash parameter count and architecture:** not published by Alibaba, no technical report [S9].
- **Qwen3.8-Max weights and license:** not released as of 2026-08-10, no license named [S7]. Status after that date not verified.
- **Kimi K3 per-tier rate limits (RPM/TPM):** Moonshot has not published them [S15].
- **`reasoning_effort: "none"` on Kimi K3:** one source reports the API accepts it against the docs [S15]. Single source, not independently confirmed.
- **LongCat 2.0 exact open-source date:** sources give 2026-06-30 [S18] and 2026-07-05 [S19]; the OpenRouter listing is 2026-07-20 [S1]. Not resolved.
- **Ling-3.0-flash independent evaluation:** none exists. All performance claims trace to Ant Group [S16][S17].
- **Novita's quantisation for Ling-3.0-flash:** reported as "unknown" by the OpenRouter API [S1], so the $0.021 endpoint's precision is undetermined.
- **Launch-window 429 waves:** no source documented a specific 429 incident for any of these models. The Kimi K3 rate-limit accounting behaviour [S15] is a documented mechanism, not an observed incident.
- **Censorship or refusal patterns on benign commercial content:** no source found addressing refusal behaviour for e-commerce product attribute extraction on any of these models. **No evidence found**, in either direction.
- **Context degradation below the advertised window:** no independent long-context needle or degradation study was found for any of these models. The *served* context shortfalls documented above (MiniMax M3 at 524k versus an advertised 1M, GLM-5.2 endpoints at 96,890 to 262,144) are provider configuration facts from [S1], not measurements of quality decay.
