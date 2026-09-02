# GLM 5.3 Flash (ex ox-alpha): route-to / route-away, max-out settings

Sources: Z.ai launch post and docs, Hugging Face card, OpenRouter listing and probe (2026-09-02), 98 YouTube hands-on tests (`research/2026-09-02/youtube-evidence-glm-flash.md`), codex lane F (`research/2026-09-02/codex-lane-F.md`). Verified 2026-09-02. Grades: D demonstrated, A asserted, C commenter, T transcript-derived.

## Facts
- Released 2026-08-26 by Z.ai as the reveal of the anonymous OpenRouter/OpenCode model `ox-alpha` (2026-08-20 to 08-26, free; Z.ai asserts "most popular model of the week", circulating totals 16-44T tokens conflict and no primary OpenRouter number exists; fingerprinted by tokenizer offsets (11/11, 44/44 matches), Java stack traces and video-token counting; the preview honoured `/nothink`, the released API does not). Weights MIT on `zai-org/GLM-5.3-Flash`. 320B total / 18B active MoE (288 experts, 8 active + 1 shared), 45 layers (34 KDA linear + 11 sparse MLA, 3:1), index-pool KV compression (3x less attention compute, 4.4x smaller KV cache than GLM 5.3), multi-token-prediction head, trained on a 30T multimodal corpus, natively multimodal (text, image, video in; text out). Served on domestic Chinese accelerators via a custom SGLang stack.
- ids: OpenRouter `z-ai/glm-5.3-flash` (+`:batch`, alias `~z-ai/glm-flash-latest`; 1,310,720 ctx is router metadata, the contract is 1,048,576 in / 131,072 out; no `:free` slug since the reveal); Z.ai direct `glm-5.3-flash`; Cline free tier; Verdent caps ctx at 300K. Inputs text, image, video, file (HF card ships an image-text-to-text example); audio NOT FOUND.
- Price: **promo $0.075 / $0.25 per 1M, cache read $0.015, through 2026-09-09 24:00 UTC+8; list $0.15 / $0.50, cache $0.03.** Batch twin 50% off list. Z.ai Coding Plan: Lite $18/mo (10k credits/wk, ~80 prompts per 5h), Pro ~$80 (60k/wk), Max ~$168 (140k/wk); Flash burns 1/3 the credits of GLM 5.3 (3x quota); off-peak and weekends 50% (peak = 14:00-18:00 UTC+8 weekdays). Anniversary "reset cards" (announced 2026-09-01) refill the weekly and 5-h pools to 100%: needs ZCode 3.8.1+ signed in with the plan linked, API-key-only users get none, earliest card is spent first, cards expire.
- Effort: reasoning ALWAYS on, values `low | high | max` only. `medium` returns `The request is invalid low or high max` (D). Disabling thinking in a harness produces malformed code (D). Official recommendation temp 1.0, top_p 0.95, effort max; the field says **`high`**: within 1% of max at ~40% of the output tokens (D/C, several sources), max = 47K output tokens per AA task (2.4x Luna, 2.8x Sol) and doom loops. Coding calls: `thinking: {type: "enabled", clear_thinking: false}` and replay every returned `reasoning_content` (OpenRouter: `reasoning_details`) unchanged across tool turns; stateless chat: `clear_thinking: true`.
- Structured output: `response_format` is `json_object` only, NO JSON-schema enforcement on Z.ai or the standard OpenRouter route (`:batch` claims schema support, unverified, Together only). Known bug (zai-org/GLM-5 issue 133, D): json_object mode deletes lowercase `json` substrings, `application/json` becomes `application/`. Tool schemas (`tools`, `tool_choice`, streamed calls, interleaved reasoning) work; put the schema in the prompt and validate client-side, or route strict-schema generation to Luna.
- Speed: 28-60 tok/s on Z.ai and most OpenRouter hosts (AA: 49 tok/s, TTFT 1.5 s); Baseten on OpenRouter 114-115 tok/s (D, Theo; ErrorFixer). Z.ai holds ~94% of OR traffic, so pin `provider: Baseten` for speed. "Flash" means cheap, not fast.
- Benchmarks (vendor unless noted): AA index 57 (= GPT-5.6 Terra, Qwen 3.8 Flash Next 56, Gemini 3.7 Flash 56), AA agentic 58, $0.09 per index task list ($0.045 promo); Terminal-Bench 2.1 84.3 (Opus 4.8 85.0, Terra 87.4); DeepSWE 1.1 63.4 (Opus 4.8 58.0, GLM 5.2 46.2); AutomationBench 48.8; Toolathon 78.4 (Opus 4.8 76.2); Z.ai CodeBench 29.0 vs Opus 4.8 29.5; NL2Repo 56.3 vs Opus 4.8 69.7; BabyVision 53.4 vs Gemini 3.7 Flash 70.9; Office-QA Pro 62.4 (beats Opus 4.8); SimpleQA 33.5; AA Omniscience hallucination score positive (+7 vs Qwen Flash Next -10). Independent: KingBench 63/80 official API vs 70/80 as ox-alpha (AICodeKing); Johnston 9-test gauntlet 91 (= Kimi K3, above GLM 5.3 full 87; Grok 4.6 94, Fable 5.1 98); AI Coding Daily 21 prompts: bottom on edge-case pass rate (8.9/24) but cleanest, most idiomatic code; Arena agent leaderboard 19th, $0.12 median per task.

## Route TO it (cheapest seat that is still smart, effort `high`)
- Bulk single-file frontend and canvas/Three.js/WebGL prototypes (consistently strong: 2,000-5,600-line single files, working games, dashboards, DAW, procedural sims; D, 10+ sources).
- Full-stack scaffolding with a real database (the only model in Better Stack's 8-model bake-off besides GLM 5.3 full to ship Next.js + Drizzle + SQLite; 45 min, $0). Phase the spec with per-phase success criteria (Donner: 69/69 tests in one prompt).
- PR triage and code auditing at volume: hundreds of PRs for $0.12 with cache (Theo) vs over $100 on Fable 5.1 for a subset.
- Structured extraction with zero fabrication (84 cells across 14 benchmarks, blanks left blank; 45,000-row CSV analysis; earnings-report extraction with citations). Schema in the prompt plus client-side validation, not `response_format` (see Facts).
- Tool-calling loops with error recovery (picks the right tool, asks on ambiguity, recovers from corrupt files, writes 39-assertion test suites, fixes a broken Flask reloader on its own).
- Long autonomous background runs on the Coding Plan (9.5 h of heavy runs = 23% of a weekly mid-tier quota, Bowen).
- Bulk translation of code (22K-line C# to Rust in one prompt under 2 EUR, C) and multilingual generation (84 languages incl. Tigrinya, Balochi; Dutch reported poor).
- Opinion seat: open-weight, non-DeepSeek architecture, low hallucination.
- Security work that Fable refuses: fewer refusals than frontier models (C); the full GLM 5.3 is the stronger seat there (DeepSeek V4 Pro 0813 stays the cache's pick). Never the sole security or geopolitical reviewer: CTGT found a concentrated blacklist on China-sensitive topics, and no ExploitBench result exists.

## Route AWAY
- Anything interactive or latency-bound: 9-20 min per prompt in OpenCode, 45-75 min scaffolds, 1 h for a 3,000-line app in Claude Code, "Flash is a lie" (D, 8+ sources). Cursor agent looped 16 min / $5.57 on a trivial UI.
- Whole-repository generation and deep multi-file refactors (NL2Repo 13 points behind Opus 4.8; "wanders off mid-task", stops and needs "is it done?" prodding; one worktree deletion report).
- Vision-precise work (object detection "barely competes with Luna", form-field coordinates wrong; BabyVision 17 points behind Gemini 3.7 Flash). Vision as a coding-loop aid (screenshot → CSS fix, UI self-inspection) works.
- Copy and prose ("AI slop", Orwell overcorrection), and non-English output in some languages.
- Physics/3D spatial logic (inverted controls, clipping, 20K-polygon assets, 92% of tokens spent reasoning on a ship sim).
- Untrusted web content in the loop: resisted executing an injected instruction but echoed the payload downstream (D).
- Pixel-perfect one-shot UI when the reference matters: Qwen 3.8 Flash Next and Gemini 3.7 Flash match screenshots better.
- Sub-agent orchestration inside Z.ai's own ZCode (project memory not passed to sub-agents; official warning). Under Claude Code / OpenCode it is fine as a single agent.

## Max-out settings
```
model: z-ai/glm-5.3-flash        # OpenRouter; or glm-5.3-flash direct
provider: {order: ["Baseten"], allow_fallbacks: true, quantizations: ["fp8"], require_parameters: true}
                                  # Baseten 113 tok/s, Fireworks 70, Modal 68, Z.ai 23; fp8 = the official checkpoint (Venice/Cloudflare quant unknown)
reasoning: {effort: "high", exclude: false}   # not max (2.4x tokens for <1%), never medium (400); low for tiny edits/classification
thinking: {type: "enabled", clear_thinking: false}   # Z.ai direct; replay reasoning_content / reasoning_details across tool turns
temperature: 1.0, top_p: 0.95     # official; top_p 1.0 only to reproduce Z.ai's Terminal-Bench harness (65,536 out)
max_tokens: 65536+ (131072 if the harness allows)   # reasoning bills as output; 40-90K thinking runs are normal
retry: 403/503 with backoff       # load shedding is routine on Z.ai and OR
stop rule: 2 failed test-repair cycles or 40K generated tokens, then escalate to Sol (not to 5.3 full)
```
Prompt lines that measurably helped (D): "don't overthink it / think less, do more" (cuts reasoning loops and 504s); "write modular multi-file output, not one 2,000-line file" (avoids mid-stream hangs); Plan-mode → Act-mode in Cline; a hard "wrap it up, add nothing new" to end polish loops; "search before answering" for freshness; explicit layout/coordinate specs for UI.
Harness: Claude Code via `ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic` (Z.ai's own guide is inconsistent about which slots map to Flash: set all three `ANTHROPIC_DEFAULT_{OPUS,SONNET,HAIKU}_MODEL=glm-5.3-flash[1m]` explicitly, plus `CLAUDE_CODE_AUTO_COMPACT_WINDOW=1000000`, `API_TIMEOUT_MS=3000000`; the npx helper defaults the Opus slot to GLM 4.7) or via OpenRouter (`https://openrouter.ai/api`, not guaranteed by either side, smoke-test tool calls, reasoning replay and compaction first); OpenCode (best-evidenced harness; `OPENCODE_EXPERIMENTAL_OUTPUT_TOKEN_MAX=128000`, a 16K cap gets eaten by thinking and returns nothing); Cline free tier; Codex via proxy (no Flash-specific compat evidence, its MCP resource-read tools were not RL-tuned, falls back to CLI; keep Sol in Codex). Any other harness: 5-case gate before unattended use (read file, edit file, parallel tool call, tool error + recovery, 20K+ continuation with reasoning preserved). Z.ai direct = servers in China; ZDR providers exist on OpenRouter at list price (C).
Local: FP8 ~331-386 GB (4x H200 / 2x DGX Spark NVFP4 at 25-40 tok/s, 262K ctx cap; M3 Ultra 512 GB Q9 16-20 tok/s; M3 Ultra 256 GB MLX 4-bit 165 GB at 29 tok/s), Unsloth 3-bit 128-150 GB, 1-bit 93 GB at 71% top-1; needs Unsloth's llama.cpp fork or `mlx-vlm>=0.6.17`; vision not in llama.cpp yet; CPU-only ~2 tok/s. vLLM on 4x B200 hit recurring illegal-memory-access crashes; the DGX recipes needed day-zero patches. Community abliterated/"uncensored" repacks exist: never in a trusted security or production-code lane. Qwen 3.8 Flash Next (125B/6B) is the local pick under 128 GB (3x faster, 80% 1-bit retention); GLM wins on quality when the box is big enough.

## vs neighbours (cost per COMPLETED task decides)
- DeepSeek V4 Flash: 2-2.5x faster (108 vs 44 tok/s), fewer turns (9 vs 93 on one identical agent task, $0.02 vs $0.16), better edge-case pass rate; GLM cleaner code, lower hallucination, vision, harder tasks. Keep DeepSeek Flash for fast iterative sub-agents, GLM for quality-per-dollar on bounded tasks.
- GPT-5.6 Luna: ~$0.05 per AA task vs $0.09, half the tokens, faster, strict schema; Agent Arena median $0.08 vs $0.12 per task (Flash emits ~2x the output). GLM +5-7 index points, open weights, cheaper per successful LiveBench task ($0.031 vs $0.169). Route on accepted PRs per dollar, not list price.
- Qwen 3.8 Flash Next: cheaper per agentic suite (27% less), better vision-to-frontend and local speed; GLM better on SVG/3D/agentic app dev (KingBench 63 vs 56).
- GLM 5.3 full ($1.40/$4.40): 3x the credits, stronger on C++/systems and security, no vision; Sam Witteveen's rule: if Flash fails, escalate to Fable/Sol, not to 5.3 full.
- Kimi K3 ($3/$15): tied on Johnston's gauntlet at 30x the output price.

## Traps
- Promo pricing doubles 2026-09-10. AA's "$0.045/task" is the promo figure.
- 1M context is an envelope: quality drops past ~100K in embedded-code reports (C), local NVFP4 stalls past 262-300K, Verdent caps at 300K.
- Identity hallucination ("I am Claude"), Chinese text bleed in long English documents, git commits dated 2025-01-01 (C).
- Free proxies (Imparro, AIHubMix, b.ai, Token Router) cap at ~10 requests or die within days; not for pipelines.
- KingBench dropped 70 → 63 between stealth and the official API (checkpoint or serving difference); do not carry ox-alpha impressions over unverified.
- SWE-bench Verified / Pro, Vals, ExploitBench results for Flash: NOT FOUND (2026-09-02). Do not substitute full GLM 5.3 scores; vendor DeepSWE 63.4 is the only SWE-style number.
- `:batch` metadata is broken (1,048,575 ctx, 943,717 max completion, Together only, no uptime data): not for pipelines yet.
