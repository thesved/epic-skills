# BANKED research, 2026-08-12: new labs + misc models
Source: subagent aa0668308495b4bb4 (completed). Salvaged before spend-limit wipeout of its siblings.

## Thinking Machines Lab, Inkling family

### thinkingmachines/inkling
- First in-house TML model, 2026-07-15. MoE, 975B total / 41B active, 256 routed experts (6 active/token) + 2 shared, interleaved sliding-window/global attention 5:1. 45T tokens text+image+audio+video, encoder-free multimodal, trained on GB300 NVL72. Up to 1M ctx. Controllable thinking effort (scalar 0.2..0.99). Open weights Apache 2.0, HF `thinkingmachines/Inkling`, NVFP4 checkpoint.
- Bench @effort 0.99: HLE text 29.7, HLE+tools 46.0, AIME 2026 97.1, GPQA-D 87.2, SWE-bench Verified 77.6, Terminal Bench 2.1 63.8, MMMU Pro 73.5, VoiceBench 91.4; model card adds IFBench 79.8, Global-MMLU-Lite 88.7, MCP Atlas 76.0, Toolathlon Verified 45.5.
- Vendor itself says "not the strongest overall model available today, open or closed"; positioned as a customizable BASE for fine-tuning via Tinker. Willison 2026-07-16: model card + data documentation unusually thin.
- Model card limitations, verbatim: hallucination, "occasional failures to follow instructions precisely", "degraded performance in long multi-turn conversations". Languages listed only as "English, general multilingual support".
- Model card mentions NO JSON mode and NO structured output. Tool use documented.
- OpenRouter: `thinkingmachines/inkling`, canonical `inkling-20260715`, listed 2026-07-17, `:batch` exists. Model ctx 1,048,576 but top_provider ctx 524,288, max_completion_tokens 262,144. supported_parameters have `response_format` but **NOT `structured_outputs`** (JSON mode yes, strict schema no). reasoning default_enabled true, default effort high.
- Per-provider split matters: DeepInfra (fp8, 524k ctx, 262k max out, HAS response_format, uptime 99.59%), BaseTen (1M ctx but max out only 32,768, NO response_format), Together (524k ctx, NO response_format). `supports_implicit_caching: false` everywhere but `input_cache_read` is priced, so caching needs explicit triggering.
- AA via OR: intelligence 42.3, coding 52.1, agentic 34.1.

### thinkingmachines/inkling-small
- 2026-07-30. 276B total / 12B active, 42-layer decoder-only sparse MoE, text+image+audio in, up to 1M ctx (vendor), Apache 2.0. Built by on-policy distillation with full Inkling as teacher: beats the teacher on reasoning, loses on knowledge coverage and factuality.
- Bench: HLE text 31.6, SWE-bench Verified 80.2, GPQA-D 89.5, AIME 2026 95.5, HMMT Feb 2026 90.2, **IFBench 82.2** (above full Inkling's 79.8), Global-MMLU-Lite 86.7, MMMU Pro 74.0, GDPval-AA v2 1269 Elo.
- OpenRouter: ctx 524,288 (not 1M), max_completion_tokens 262,144. Params include **`structured_outputs`** but **NOT `response_format`**, the inverse of full Inkling. Providers: DeepInfra (structured_outputs YES, 99.40% uptime), Together (NO). Provider choice decides whether schema mode works.
- AA via OR: intelligence 41.2, coding 52.9, agentic 31.9.

## Anthropic Opus 5 / Opus 5 Fast

### anthropic/claude-opus-5
- Released 2026-07-24, `claude-opus-5`. Flagship for complex agentic coding + enterprise, positioned near Fable 5 intelligence at half price. 1M ctx, max output 128k sync; **Batch API supports up to 300k output** with beta header `output-300k-2026-03-24`. Training + knowledge cutoff May 2026. Adaptive thinking yes, extended thinking no, `effort` defaults to high.
- Vendor bench: Frontier-Bench v0.1 SOTA, CursorBench within 0.5% of Fable 5, ARC-AGI 3 ~3x next best, OSWorld 2.0 best at comparable cost. No structured-output or multilingual claims in the launch post.
- **Structured outputs supported** via `output_config.format` with `type:"json_schema"`, guarantees schema-valid JSON, no retries needed. Caveats: no recursive schemas, `additionalProperties` must be false, no minimum/maximum or minLength/maxLength, only minItems 0-1, limited regex, no external `$ref`. First request pays grammar-compilation latency, schema cached 24h, an extra system prompt is injected (raises input tokens). Legacy `output_format` + `structured-outputs-2025-11-13` header deprecated but works.
- Prompt caching: min cacheable prompt 512 tokens, up to 4 breakpoints, 5m default TTL or 1h. **Setting `output_config.effort` explicitly invalidates message-level caches on all models.**
- OpenRouter: ctx 1,000,000, max_completion_tokens 128,000 (the 300k batch beta is NOT exposed). 9 endpoints: Anthropic, Bedrock x3, Claude Platform on AWS, Google x3, Azure. **Google endpoints do not list `structured_outputs`** (only response_format); Anthropic/Bedrock/AWS/Azure do. Pin the provider if strict schema mode matters. `supports_implicit_caching:false`, cache read/write/write_1h all priced; OR does sticky provider routing for 5 min to maximise cache hits (`session_id` / `x-session-id`).
- AA via OR: intelligence 63.1, coding 78, agentic 59.2. Design Arena rank 1 dataviz + gamedev.

### anthropic/claude-opus-5-fast
- OR listed 2026-07-24, 2s after base. "identical capabilities with higher output speed at 2x pricing". Single provider (Anthropic only), no `temperature`, no `max_completion_tokens`.
- Anthropic docs: **research preview, gated** (account manager or waitlist). `speed:"fast"` + beta header `fast-mode-2026-02-01`. Up to 2.5x higher output tokens/sec, same weights, gains on OTPS not TTFT.
- Hard restrictions that kill it for a 4000-call bulk run: **not available with the Batch API**, not with Priority Tier, not on Bedrock / Google Cloud / Microsoft Foundry / Claude Platform on AWS. Separate rate limits with 429 + retry-after. **Fast and standard requests do not share cached prefixes**, so a fallback to standard is a guaranteed cache miss.

## Secondary, one line each
- **bytedance-seed/seed-2.0-code**: coding specialist, OR listed 2026-07-30, 262k ctx, 131k max out, text+image+video, HAS response_format + structured_outputs. ByteDance's own Seed 2.0 family page lists only Pro/Lite/Mini and never mentions a Code variant; release date 2026-02-14 comes from an aggregator only. Relevance LOW.
- **kwaipilot/kat-coder-pro-v2.5 / air-v2.5** (listed 2026-07-10): agentic coding, 256k ctx, 80k max out, TEXT ONLY. Vendor-claimed SWE-Bench Pro 65.2, PinchBench 94.9. Relevance NO.
- **meta/muse-spark-1.2**: 2026-08-05, Meta Superintelligence Labs flagship reasoning+coding, 1M ctx, API-only at launch. OR: ctx 1,048,576, **max_completion_tokens null**, text+image+file+audio+video, HAS response_format + structured_outputs. Weights promised, no date/license. Relevance PLAUSIBLE BUT UNPROVEN, zero multilingual evidence.
- **meta/muse-glimmer-30b**: 2026-08-10, Apache 2.0, 30B dense multimodal, logit-distilled from Muse Spark, 128k ctx, built for local agents on one 24GB GPU (~18GB @4bit), AA intelligence ~35. Relevance NO for this task (128k ctx too tight).
- **sakana/sakana-namazu**: Japanese-specialised post-train of Kimi K2.6 (keigo, JP business docs), OR listed 2026-08-11, 262k ctx, 65k max out, structured_outputs yes. **Reported unavailable in EU/EEA/UK/CH pending GDPR work.** Relevance NO.

## Sources
1. https://thinkingmachines.ai/news/introducing-inkling/ (2026-07-15)
2. https://thinkingmachines.ai/model-card/inkling/ (acc. 2026-08-12)
3. https://thinkingmachines.ai/news/inkling-small/ (2026-07-30)
4. https://openrouter.ai/thinkingmachines/inkling-small (acc. 2026-08-12)
5. https://www.anthropic.com/news/claude-opus-5 (2026-07-24)
6. https://platform.claude.com/docs/en/about-claude/models/overview (acc. 2026-08-12)
7. https://huggingface.co/thinkingmachines/Inkling-Small (acc. 2026-08-12)
8. https://simonwillison.net/2026/Jul/16/inkling/ (2026-07-16)
9. https://openrouter.ai/api/v1/models + /endpoints (fetched 2026-08-12, 406 models)
10. https://techcrunch.com/2026/07/24/anthropic-launches-opus-5/ (2026-07-24)
11. https://platform.claude.com/docs/en/build-with-claude/structured-outputs (acc. 2026-08-12)
12. https://platform.claude.com/docs/en/build-with-claude/prompt-caching (acc. 2026-08-12)
13. https://openrouter.ai/docs/features/prompt-caching (acc. 2026-08-12)
14. https://platform.claude.com/docs/en/build-with-claude/fast-mode (acc. 2026-08-12)
15-21. aggregator/press sources for the secondary models (see original transcript)
22. https://aclanthology.org/2025.findings-acl.390/ OpenHuEval (2025)

## COULD NOT VERIFY (carry forward, do not re-assume)
- **Any Hungarian benchmark for any 2026 model.** OpenHuEval exists but published results cover Claude 3 Opus / GPT-4 era only. MMMLU's 14 non-English languages do NOT include Hungarian. This is the single biggest evidence gap for the Pepita use case: HU competence must be measured by us, it cannot be looked up.
- MMMLU or any per-language score for Opus 5 (system card PDF exceeded fetch limit).
- Whether Inkling / Inkling-Small enforce strict JSON schema at model level (vendor cards silent, OR provider flags contradict each other).
- Any measured strict-JSON success rate at long output for ANY model here. Blogs asserting Inkling "JSON reliability" are SEO content with no methodology.
- Throughput/latency: OR `throughput_last_30m` and `latency_last_30m` returned null for all four primary models.
- Whether OR exposes the Anthropic 300k-output batch beta (OR reports 128k).
- Whether opus-5-fast is usable in batch (Anthropic docs say no).
- Official ByteDance publication for seed-2.0-code; Muse Spark 1.2 weights date/license; Inkling param count 975B vs 952B discrepancy.
