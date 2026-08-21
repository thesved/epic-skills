# YouTube sweep 2026-08-21: 24 videos, Gemini 3.7 Flash analyst, goal-lensed

Goal: how to MAX OUT and WHEN TO ROUTE TO DeepSeek V4 Pro 0813 / V4 Flash 0731, Gemini 3.7 Flash, GLM 5.3, Qwen 3.8. Each video watched server-side by Gemini with the goal embedded; top 120 comments mined per video. Evidence grade: D = demonstrated on screen, A = asserted (slide/bench table), C = commenter claim.

## DeepSeek V4 Pro 0813

| Finding | Grade | Source |
|---|---|---|
| High effort beats Max on a 4-task agentic suite: Pro High 12.05/20 $0.04 7:15 vs Pro Max 11.65/20 $0.05 9:06; V4 Flash Max 12.6/20 $0.02 5:04 beat both | D | AI Coding Daily e2CPf06MDn4 [02:27] (commenter @ZachAR3 says a config bug may explain Pro=Flash tie; retest pending) |
| Max effort overthinks: 5-10 min reasoning chains on simple tasks, over-engineers one-line fixes into refactors; commenter fix: effort "very high" not max | D/C | AICodeKing W_e-YR4QRvg [07:56-09:25], @fyucko |
| "max reasoning is broken / wasteful, default high better" | C | Bijan Mu5a8ErscIE @TheRobojay |
| Strengths demonstrated: autonomous multi-bug fix in FastAPI+Redis+SQLite app, self-verifies via headless Chrome; long-horizon MLX fine-tune pipeline 10/10; combinatorics 10/10; 3D watch 7/10 (beat Fable 5's 4/10) | D | Fahd Mirza Deklc0BO_wk [00:45-05:48]; AICodeKing [05:13-06:15] |
| Security/cyber: 6/6 pass on exploit task at $0.224 total vs Opus 4.8 1/1 at $4.18 (~20x cheaper per solve); passed internal security scan without refusal | D | Mehul NK6saQAqd7U [16:09-18:58, 20:56] |
| Weaknesses: SVG/visual taste 5/10; headless-test self-loops inflate runtime (Subway FPS fail); CAD manufacturability misses; game physics/collision bugs; no enemy spawn logic | D | AICodeKing [04:22]; Bijan Mu5a8ErscIE [13:59-17:30] |
| NO VISION (harness returns "model does not support images"); most-cited weakness across 5 videos' comments | D/C | BridgeMind ya4B53HSBfM [05:33-06:45]; disputed by @nbhuan: `~/.dsh/settings.yaml` `input: [text, image]` |
| Infinite loop failure: PDF-gen task "looped until I killed it to save $$", GPT Terra did it in 2 min | C | AICodeKing @dmccallie |
| Slow: 52-90 tok/s, TTFT 1.6-2.9s; unsuitable as low-latency daily driver, fine for long deep runs | D | BridgeMind [02:04]; Mehul [21:50]; Cloud Codes IEjylUYFLf4 [06:18] |
| Real spend: $5.87 / 114.4M tok / 784 req (BridgeMind); $3.06 / 187.8M tok with 183.7M cache hits (Mehul); $2.73 / 232.9M tok / 7 heavy builds (Bijan). Caching = ~90% of the saving | D | three dashboards |
| Direct DeepSeek API beats OpenCode Zen proxy on both pass rate (40/41 vs 37/41) and cost | D | AI Coding Daily ltJukPGSqEg [08:22] (Flash, same API) |
| OpenRouter: 16 providers, 4x price spread, 4-57 tok/s; third-party providers charge up to 10x native for cache reads; pin provider | D | Mehul [15:20-16:08]; Cloud Codes |
| Vendor Terminal-Bench 2.1 87.9 was run in DeepSeek's own harness (minimal mode, max effort); AA neutral-harness rerun 79.0 (-8.9) | A | Cloud Codes [05:05] |
| Strict json_schema not supported on OpenRouter yet (commenter) | C | Bijan @filipborch-solem1354 (probe below decides) |
| Asks clarifying questions on ambiguous prompts instead of guessing | D | AICodeKing [09:00] |
| "best for large codebase navigation, watch out for slow reasoning on multi-file edits" | C | AI Search 62HSUsS0ypo @CaelisNorthwick |

## DeepSeek V4 Flash 0731

| Finding | Grade | Source |
|---|---|---|
| Max effort is what makes it competitive: 4.1/10 (High) to 6.7/10 (Max) on AI Coding Daily suite, ~$0.01/task | D | ltJukPGSqEg [09:22] |
| Full-stack dashboard: only model of 8 to ship a REAL SQLite DB (others mocked), but broken layout; $0.08, 3.35M tok, 23m48s at 28.4 tok/s (provider artifact: CoreWeave does ~140 tok/s per commenter) | D/C | Better Stack 93iYf9wp7Qw [02:59], @bastiat691 |
| Reasoning-token bloat: 39k of 46k output tokens were reasoning | D | Better Stack |
| Infinite tool-call loop on direct API, ~20 min, manual kill | D | ltJukPGSqEg [09:00] |
| Frontend Arena #7 (1586), weakest named model on visual taste | A | Prompt Engineering b6HIoqT__E8 [00:55] |
| Luna Medium = same score/cost, faster (3:00 vs 5:04); after price hike "Luna is the budget goat" (30+ likes) | D/C | e2CPf06MDn4; 93iYf9wp7Qw comments |
| Routing quirk: `deepseek/deepseek-v4-flash` direct on OpenCode sends code to mainland-China infra; OpenCode default proxies via US | D | ltJukPGSqEg [10:09] |

## DeepSeek pricing change (time-variable)

- Effective 2026-08-17 00:00 Beijing = 2026-08-16 16:00 UTC. Peak = 09:00-12:00 and 14:00-18:00 Beijing = 01:00-04:00 and 06:00-10:00 UTC, 7 h/day, every day (Juya 56kvIlS0EAs; AI Coding Daily; Cloud Codes).
- RMB per 1M (Juya, on-screen official table): Flash off-peak hit 0.05 / miss 1.5 / out 4.5, peak 0.10 / 3.0 / 9.0. Pro off-peak hit 0.15 / miss 4.5 / out 13.5, peak 0.30 / 9.0 / 27.0.
- USD (AI Coding Daily [05:14]): Pro cache-hit $0.003625 to $0.022 off-peak (6x) to $0.044 peak (12x); out $0.87 to $1.98 to $3.96. Flash hit $0.0028 to $0.007 to $0.014; out $0.28 to $0.66 to $1.32.
- Blended agent workload (7:2:1, Cloud Codes [02:30]): V4 Pro $0.35/M off-peak (1.7x cheaper than Gemini 3.7 Flash $0.58) vs $0.69/M peak (MORE expensive than Gemini). Gemini batch $0.29/M beats DeepSeek peak.
- OpenCode "operation cheapseek" tries to hold old prices via own routing (e2CPf06MDn4 [07:20]).

## DeepSeek Harness (dsh)

- v0.1 dev preview, MIT, github.com/deepseek-ai/deepseek-harness, `npx @deepseek-ai/dsh web` (port 3000). "Cordis" plugin framework (tools/skills/sessions/sandboxes/fs/subagents). Modes: Standard, PTC (programmatic tool calling via TypeScript Code Mode), Minimal (bash + str_replace_editor), Creative. Trajectory replay. Effort dial High/Max in UI. Frequent breaking changes. (Juya; AI Coding Daily [07:55]; BridgeMind [00:21])
- Vision via `~/.dsh/settings.yaml` `input: [text, image]` claimed by 2 commenters, contested by a third. Unverified.
- Bench numbers on the model card were produced in this harness; neutral harness drops ~9 pts (Cloud Codes).
- API now also speaks OpenAI Responses format (Juya [01:03]; ltJukPGSqEg [06:09]).

## Gemini 3.7 Flash

| Finding | Grade | Source |
|---|---|---|
| Specs: 1,048,576 in / 65,536 out; thinking Low/Medium/High, `minimal` errors; caching, code exec, functions, structured outputs, Batch, Flex, Priority; no audio-gen | D | Bijan _onfQRKB1JY [03:57] |
| 340 tok/s at High; TTFT ~10 s (thinking billed as output before first visible token); 10k-token completion 39 s vs DeepSeek 120 s | A | Cloud Codes [06:18]; Surya 4cZY-R7LoyY [04:57] |
| Concurrency 2,500 vs DeepSeek 500; max single output 64k vs DeepSeek 384k | A | Cloud Codes [06:58] |
| Price $0.75/$3.75 intro to 2026-12-31, then $1.50/$7.50; cache read $0.075; OpenRouter promo $0.375/$1.875 until 2026-08-27 | A | Juya [02:01]; Bijan |
| Strong: one-shot single-file apps (hex-grid game 5/5, browser OS 3,178 lines in 58 s, Electron app, Chrome extension, Stripe checkout first try), UI-card design fidelity beat Sonnet 5 and Sol, vision-debugging from phone photo, PDF to dashboard | D | Ramanpal t9ydLkq5dXI; Bijan; Kostya ncD551CmZII; AI Search |
| Weak: Three.js/GLSL shader total fail (Sonnet 5 passed), CSS animation/rotation logic, CAD overhang reasoning, mobile responsive layouts clip, emoji-instead-of-icons, scroll-pin breaks, can't package exe/bat | D | Ramanpal [04:18, 08:18]; Kostya [00:57-04:12]; Bijan [16:17] |
| INSTRUCTION DRIFT on structured full-stack tasks: hallucinated unrequested features, wrong monthly-total math, broken dashboard cards; 3.1 Pro followed spec exactly | D | NERD UP r4NqnBfcH4g [03:05-07:04] |
| "takes the shorter route even if incorrect", "accuracy by far lower than 3.1 pro" (9 likes), "falls apart on production Rust", "lazy on long-horizon, Qwen 3.8 27B beats it there" | C | Google hands-on kacf2bib-X0, Surya, Bijan comments |
| Via OpenRouter + OpenCode: "Upstream idle timeout exceeded"; via Antigravity agent stalls; AI Studio direct never crashed | D | Ramanpal [00:28] |
| Tool calling problems with PDF input (commenter) | C | Bijan @XieQiu |
| OpenRouter Auto routing serves mixed quantizations; pin provider | C | Bijan @leonxger |
| Google's own positioning: high-volume document workflows, intent-classification/routing upstream of a frontier planner, parallel cheap sub-agents | A | Google kacf2bib-X0 [00:41-04:02] |
| Thinking Off used for extraction/digest tasks: worked well | D | Ramanpal [05:26-07:09] |
| AA index 56 vs V4 Pro 53; AA cost/task $0.40 vs V4 Pro $0.25 peak / ~$0.08 off-peak | A | Cloud Codes [04:33]; AI Search |
| DeepSWE v1.1 65.3 (Terra 69.6, Sonnet 5 53.8); commenter: Luna Max scores above it for less money | A/C | Bijan; @royclerx8894 |

## GLM 5.3 (Z.ai, 2026-08-14 research drop, weights ~2 weeks later)

| Finding | Grade | Source |
|---|---|---|
| ~753B MoE / ~40B active (same arch as 5.2, post-training only); 1M ctx; 128k out | A | Bijan 3TeW8L9wy-Y [01:27]; Prompt Engineering |
| Thinking can no longer be disabled (`thinking.type: disabled` errors); effort low/high/max (Cline shows Off/Low/Med/High/XHigh); max = recommended coding default | D | Bijan [03:05]; Prompt Eng [06:56] |
| Token-efficient: Max 34.5% acc at ~75k tok/task vs Opus 4.8 29.5% at ~120k, Fable 5 Max 39.5% at ~115k (Z.ai bench) | A | Prompt Eng [01:57] |
| Price $1.40/$4.40, cached $0.34 (OpenRouter); Coding Plan off-peak 50% outside 14:00-18:00 UTC+8 weekdays; eval settings temp 1.0 top_p 0.95 | A | Prompt Eng; AI Search [25:45] |
| KingBench 3 #1 91.25% (early access, affiliate link, top comment 68 likes: "trained on your benchmark?") | D/C | AICodeKing iMpBNN-0-Ss |
| Strong: OpenSCAD/CAD, structured web apps, multi-file toolkits, long-horizon agentic troubleshooting, security audit (CyberGym 84.5) | D/A | Bijan |
| Weak: C++/OpenGL game physics (worse than Qwen 3.8), real-time 3D combat, context-grounding hallucination (claimed its own specs unreleased while in context), ISS tracker needed multi-turn | D | Bijan [10:55, 27:51]; Prompt Eng [07:08-10:43] |
| NO native vision (analyze_image tool plugin only), top comment 175 likes "needs native vision so bad" | D/C | Bijan |
| ExploitBench 54.4 vs Sol 76.5 (behind despite CyberGym win) | A | AI Search |
| Repeated high-liked comments: Qwen 3.8 27B matched or beat it on same tasks | C | Bijan (62 likes) |

## Qwen 3.8

| Finding | Grade | Source |
|---|---|---|
| 27B dense, vision encoder, 262k ctx (1M ext), Apache 2.0; thinking off/low/medium/xhigh; MEDIUM = sweet spot; XHigh burns 11k-21k thinking tokens and blows the 32k default output cap with no output | D | Sam Witteveen PTuGGdDuyPI [05:43-12:25] |
| Raise max_output to 35-65k if using high effort; infinite thinking loops reported by 3+ commenters; "tell it to chill with output length" | D/C | Witteveen; AI Search comments |
| Sampling (commenter): temp 1 top_p 0.95 top_k 20 for thinking, temp 0.7 non-think | C | @JobbfiboJobbson |
| Qwen 3.8 Max (2.4T-A95B): XHigh slower than Preview but cheaper via caching; bugs: hallucinated modern skyline in dungeon scene, broken battle math, Z-fighting; $6-35/task on gauntlet tasks vs Kimi K3 $1-16, Sol $6-21, Opus 5 Max $29-134 | D | RemakeBench Amm6SM86000 |
| Reasoning-control bug in Hermes: set thinking low for agentic | C | Bijan @hotrodhunk7389 |
| AA Intelligence 52 / Agentic 51 (27B); 58 (Max) | A | Witteveen; AI Search |

## Cross-model head-to-heads worth keeping

- AI Coding Daily 4-task suite (e2CPf06MDn4): Sol Medium 18.0/20 $1.01; Opus 5 Medium 17.75 $1.10; Luna Max 17.5 $0.10; Terra Medium 16.45 $0.20 2:44; Grok 4.5 12.8 $0.24; V4 Flash Max 12.6 $0.02; Luna Medium 12.5 $0.02; Sonnet 5 Med 12.0 $0.79; Qwen 3.8 Max High 11.6 $0.45; Gemini 3.6 Flash High 11.45 $0.11; GLM 5.2 10.3 $0.43.
- Better Stack 8-model dashboard build: Luna $0.06, V4 Flash $0.08, Kimi K3 $0.58, Sol $0.90 (fastest 3m42s, best UI), Gemini 3.6 Flash $1.79, GLM 5.2 $3.68, Opus 5 $9.65 (40 min).
- RemakeBench gauntlet: Opus 5 Max $104-134/task with no proportional quality lead; Kimi K3 Max cheapest ($0.92-15.58); Sol only model that did not shortcut constraints.
- Mehul: Grok 4.6 xhigh failed config task (dummy API key) 6/10; Sol 10/10 in 45 s; Grok 8/10 vs Sol 5/10 on security-work guardrails.
- Commenter corrections on Grok 4.6 cost: cache-read $0.50 = same as Sol/Opus 5, so agentic cost parity, not "half price" (Caleb Cx-pVoBR7C0 @Schnarchos).

## Most valuable videos to watch
1. AI Coding Daily e2CPf06MDn4 (DeepSeek effort ladder + exact new pricing + cross-model $/task)
2. Bijan Bowen _onfQRKB1JY (Gemini 3.7 Flash, 7 real agentic tests, specs)
3. Cloud Codes IEjylUYFLf4 (per-dollar routing math Gemini vs DeepSeek incl. peak/off-peak)
4. Mehul NK6saQAqd7U (DeepSeek caching economics + security-task head-to-heads; skip first 10 min Grok)
5. Sam Witteveen PTuGGdDuyPI (Qwen 3.8 thinking-budget failure mode)
