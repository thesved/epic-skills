# Model sweep 2026-08-21: DeepSeek V4 Pro 0813 GA, Gemini 3.7 Flash max-out, GLM 5.3, Qwen 3.8

Learning report (history + evidence HERE; operating changes went to `openrouter.md`, `gemini.md`, `index.md`, `examples/deepseek.md`, `examples/gemini-text.md`, bridge scripts). Lanes: `update.sh` diff, 24 YouTube videos watched by Gemini 3.7 Flash with the goal embedded (`youtube-evidence.md`), 2 codex gpt-5.6-sol web lanes with search (`codex-deepseek-lane.md`, `codex-roster-lane.md`), 2 live API probes (OpenRouter endpoints + calls; Gemini REST + docs), own verification. Delegation per fable-max: Fable orchestrated and wrote every prompt, Sonnet wrappers ran yt.sh, codex did the web sweeps on the OpenAI sub.

## TLDR (what changed for us)

1. **Board open-family seat moved to `deepseek/deepseek-v4-pro-0813`** (GA 2026-08-12). The unsuffixed `deepseek/deepseek-v4-pro` we were calling on OpenRouter is STILL the April 0423 build (codex lane, OpenRouter pages). Direct-API aliases already roll to 0813/0731.
2. **Effort `high`, not `max`, for V4 Pro.** Max overthinks and loops (AICodeKing, AI Coding Daily suite: High 12.05/20 $0.04 beat Max 11.65/20 $0.05; Bijan comments; Cline issue 13041). Flash is the opposite: it needs `max` (4.1 to 6.7/10).
3. **DeepSeek is no longer "almost free".** Direct API time-variable since 2026-08-16 16:00 UTC: Pro $0.66/$1.98 off-peak, $1.32/$3.96 peak (01-04 and 06-10 UTC), cache-hit 6-12x the old price. At peak a blended agent workload costs MORE than Gemini 3.7 Flash. GPT-5.6 Luna now matches V4 Flash on cheap coding.
4. **Our OpenRouter key cannot reach DeepSeek's own endpoint** (data-policy guardrail, probe-verified 404). Every DeepSeek seat call has been landing on re-hosts at 1.2-2x native price. Fix is a privacy setting: user decision, NOT applied.
5. **Gemini 3.7 Flash max-out pinned down by live probe**: `thinkingLevel` low/medium(default)/high, `minimal` = 400; legacy `thinkingBudget` 1024 silently = off, 4096 thinks; the integer-enum schema trap is FIXED on 3.7; `gemini-flash-latest` now resolves to 3.7-flash (changelog page is stale, says 3.5); 170-185 tok/s measured, TTFB 1.3 s; Batch/Flex 50% off; intro price ends 2026-12-31 (official). Route: one-shot UI, PDF/vision to dashboard, cheap sub-agents. Do not route spec-strict multi-component builds, shaders, long-horizon agent runs (NERD UP side-by-side: 3.1 Pro followed spec, 3.7 Flash invented features and got math wrong).
6. **GLM 5.3 replaces GLM 5.2 as 2nd open seat** ($1.40/$4.40, AA 60 = Kimi K3, post-training of 5.2, mandatory thinking, text-only). It silently ignores `json_schema` (probe got markdown, no error): opinion seat only, never structured work. Weights not public until ~2026-08-28.
7. **Qwen 3.8 27B = cheap open model WITH vision** ($0.45/$3.20, Apache 2.0, 7 providers). Thinking `medium`; `xhigh` burns 11-21k thinking tokens and overruns a 32k output cap (Witteveen, corroborated by 3 commenters). Qwen3.8-Max weights (2.4T-A95B) are source-available under a custom licence, not open source.
8. Nothing new from Anthropic/OpenAI pricing. Codex CLI 0.148.0 (2026-08-18): `codex exec fork`, cost estimates, fail-closed sandbox. gpt-5.4 leaves ChatGPT-login Codex 2026-08-31. GPT-5.6 Sol Ultrafast (Cerebras, 750 tok/s) is limited preview. No Grok 4.7, no Gemini 3.5/3.7 Pro, "Mythos 6" is rumor. `gemini-3.5-flash` is now pricier than 3.7-flash ($9 vs $3.75 out).

**Benchmark-index caveat binding** (memory `feedback-benchmark-indexes-weak`): all AA numbers below are direction only. Rank by cost-per-completed-task and demonstrated behaviour.

## 1. DeepSeek V4 Pro 0813

Facts (official model card + api-docs + probe):
- 1.6T MoE / 49B active (HF artifact ~1.7T incl. DSpark speculative-decoding params), 1M ctx, 384k max out, text-only, MIT weights. Hosted effort `high` (default) and `max`; Chat Completions maps `low`/`medium` to high and `xhigh` to max; thinking mode ignores temperature/top_p; tool turns MUST replay `reasoning_content` or 400. JSON mode needs "json" in prompt; strict tool args only on `/beta`. Responses API supported but stateless (no `previous_response_id`, no images). Caching automatic, best-effort, hit tokens in `prompt_cache_hit_tokens`.
- Official benches run in DeepSeek Harness Minimal mode at max: Terminal-Bench 2.1 87.9 (Fable 5 88.0, Kimi K3 88.3), CyberGym 83.3 (Fable 83.1), DeepSWE 62.7 (Fable 70.0, Opus 4.8 58.0), HLE w/tools 60.0. Artificial Analysis neutral harness: ~79 on Terminal-Bench (-8.9), index 53. Official table compares to Opus 4.8, not Opus 5; GPT-5.6 absent.
- Probe 2026-08-21: 12 OpenRouter endpoints; DeepSeek-hosted $0.66/$1.98 with UTC-hour 2x override; re-hosts $1.19-1.32/$3.56-3.96, cache-read $0.04-0.44 (10x spread), fp4/fp8/unknown quant, 27-94 tok/s. `structured_outputs` advertised only on Alibaba/Together/Parasail/Cloudflare/Fireworks; Together returned valid strict JSON. Image part = 404. Effort high/max/low all accepted via `reasoning.effort`, but unpinned routing sent each call to a different provider (reasoning tokens 54/72/63, prompt tokens 19 vs 111 for one string): pin the provider before comparing anything.

Practitioner evidence (youtube-evidence.md): strong at autonomous multi-bug fixes, security tasks (6/6 exploit passes at $0.22 vs Opus 4.8 $4.18 for 1), long-horizon pipelines, 3D watch beat Fable 5; weak at SVG/visual taste, game physics, CAD, latency (50-90 tok/s); no vision is the most-cited complaint; infinite-loop reports on both Pro and Flash; three real dashboards: $2.73 / 233M tok, $3.06 / 188M tok (98% cache hits), $5.87 / 114M tok, all pre-hike.

Routing consequence (applied): board seat id bumped; `examples/deepseek.md` written; opt-in "cheap security second opinion" row added to roles table; bulk-extraction guidance now says probe Luna first.

## 2. DeepSeek pricing + account trap

Table and windows in `examples/deepseek.md` (source api-docs.deepseek.com/quick_start/pricing, cross-checked with Juya's on-screen RMB table and AI Coding Daily's USD walk-through; cutover timestamp from contemporaneous trackers, no longer on the live page). OpenRouter DeepSeek-hosted endpoints carry the same UTC-hour override table (probe). Re-hosts are flat.

Account trap: `provider.only: ["deepseek"]` -> 404 "guardrail restrictions and data policy"; `provider.order: ["DeepSeek"], allow_fallbacks: false` -> 404 "No endpoints found". Means the privacy setting on openrouter.ai excludes providers that may train on data, and DeepSeek first-party is one. Lifting it = per-request `provider.data_collection: "allow"` or the account page. Not applied (privacy decision).

## 3. Gemini 3.7 Flash

Docs (ai.google.dev models/pricing/thinking/changelog/rate-limits/batch): released 2026-08-13; $0.75/$3.75 to 2026-12-31 then $1.50/$7.50; cache read $0.075 -> $0.15; storage $0.50/M/h -> $1.00; Batch and Flex $0.375/$1.875 -> $0.75/$3.75; Priority $1.35/$6.75 -> $2.70/$13.50; no >200k price tier; rate limits account-specific in AI Studio (10-min spend caps Tier1 $10, Tier2 $50, Tier3 $200); batch 100 concurrent jobs, 2 GB file, 24 h target. Google migration guide: remove explicit temperature/top_p/top_k. AA index 56, DeepSWE 65.3, ~340 tok/s third-party.
Probe: see TLDR 5. Tool calling OK. Batch endpoint live. `gemini-pro-latest` -> 3.1-pro-preview; `gemini-3-pro-preview` gone from /models.
OpenRouter promo $0.375/$1.875 until 2026-08-27 (source only via OpenRouter LinkedIn/TipRanks); 6 Google endpoints spanning 7x price (discount tiers), `:batch` $0.1875/$0.9375.
Practitioner (7 videos): one-shot wins (browser OS 3,178 lines in 58 s, Electron app, Chrome extension, Stripe checkout, hex-grid game 5/5, UI card beat Sonnet 5 and Sol); demonstrated failures (Three.js/GLSL shader invisible mesh while Sonnet 5 passed, reward wheel would not spin, subscription-tracker math wrong + unrequested features, mobile clipping, emoji for icons, CAD overhang, scroll-pin); "accuracy by far lower than 3.1 pro" (9 likes), "lazy on long-horizon", "takes the shorter route even if incorrect"; OpenRouter+OpenCode idle timeouts vs stable AI Studio; Google's own framing = high-volume docs, intent routing, parallel cheap sub-agents under a frontier planner.

## 4. GLM 5.3 and Qwen 3.8

GLM 5.3 (z.ai blog 2026-08-14): same base as 5.2 (744B/40B), thinking cannot be disabled, effort low/high/max (max default), Terminal-Bench 2.1 88.2, DeepSWE 66.9, AutomationBench 48.2 (#1), ExploitBench 54.4 (Sol 76.5). Token-efficient (34.5% at ~75k tok/task vs Opus 4.8 29.5% at ~120k on Z.ai's bench). Coding Plan: 1.5x quota to 2026-08-31, 50% off outside 14-18 UTC+8 weekdays. Probe: 1 endpoint (Z.AI fp8), 131k out, json_schema silently ignored. Videos: strong CAD/structured web/long-horizon troubleshooting, weak C++/OpenGL physics and real-time 3D (worse than Qwen 3.8 27B per host + 62-like comment), no native vision (175-like top comment), ZCode harness network drops. AICodeKing #1 KingBench result carries affiliate + contamination flags (68-like comment).

Qwen 3.8 27B (HF card 2026-08-14): dense, vision, 262k ctx, Apache 2.0, efforts low/medium/xhigh (default xhigh), `enable_thinking=false` to disable; official sampling temp 1.0/top_p 0.95/top_k 20 thinking, temp 0.7/top_p 0.8/presence 1.5 non-thinking; known bugs: chat template crashes on string tool args (issue 1894), `low` may not cap thinking. Probe: 7 OpenRouter endpoints $0.40-0.575 / $3.0-3.45; strict JSON OK via AkashML. Qwen3.8-2.4T-A95B: $2/$6, text-only, thinking required, custom licence.

## 5. Cross-model $/task evidence kept
AI Coding Daily suite and Better Stack bake-off tables are in `youtube-evidence.md`. Pattern: Sol medium and Opus 5 medium top quality at ~$1; Luna max within 0.5 pt at $0.10; V4 Flash max and Luna medium tie at $0.02; Opus 5 Max on gauntlet tasks $104-134 with no proportional quality lead (RemakeBench); Kimi K3 cheapest per finished agent task.

## 6. Forward tests run (see end of session log in git message)
- `verify.sh --cheap`, board smoke, `ask.sh -m deepseek/deepseek-v4-pro-0813` and `-m z-ai/glm-5.3` real answers, `yt.sh` on 24 videos (all succeeded first or second try), fresh-agent routing test against the updated cache.

## Sources (beyond the lane files)
api-docs.deepseek.com/quick_start/pricing, /guides/thinking_mode, /guides/responses_api, /guides/kv_cache, /guides/json_mode, /guides/tool_calls (accessed 2026-08-21); huggingface.co/deepseek-ai/DeepSeek-V4-Pro-0813 (2026-08-13); github.com/deepseek-ai/deepseek-harness; openrouter.ai/deepseek/deepseek-v4-pro-0813 and /endpoints API; artificialanalysis.ai/models/deepseek-v4-pro, /models/glm-5-3; ai.google.dev/gemini-api/docs/{models,pricing,thinking,changelog,rate-limits,batch-mode}; z.ai/blog/glm-5.3 (2026-08-14); huggingface.co/Qwen/Qwen3.8-27B-FP8 (2026-08-14); github.com/openai/codex/releases/tag/rust-v0.148.0 (2026-08-18); openai.com/index/previewing-ultrafast (2026-08-13); x.ai/news/grok-4-6 (2026-08-12); YouTube ids in youtube-evidence.md.
