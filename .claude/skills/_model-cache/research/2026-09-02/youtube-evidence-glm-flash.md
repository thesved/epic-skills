# YouTube sweep 2026-09-02: GLM 5.3 Flash / ox-alpha, 98 videos, transcript mode

Goal: where GLM 5.3 Flash belongs in the routing table and how to max it out. Every upload 2026-08-15 to 2026-09-02 over 2.5 minutes from 11 search queries (117 candidates, 107 in scope, 98 analyzed, 9 had no captions). Analyst: `google/gemini-3.7-flash` via OpenRouter over yt-dlp auto-captions plus top 100 comments (the Gemini prepaid balance was exhausted by the Fable sweep, so no frame-level evidence; grade T = transcript-derived, A = asserted, C = commenter). The operating verdict lives in `examples/glm-flash.md`; index in `youtube-index-glm-flash.md`.

## Identity, timeline, scale
| Finding | Grade | Source |
|---|---|---|
| ox-alpha appeared 2026-08-20/21 on OpenRouter (`stealth/ox-alpha`), OpenCode ("free unlimited"), Cline, Hermes; free for 6-7 days; Z.ai confirmed GLM 5.3 Flash on 2026-08-26 with MIT weights | T | Berman TOWXXhn7ctY, Theo Xdxp3lbQKyQ, Fireship r-tzcMlQISk, many |
| 42-44T tokens in 6 days, #1 on OpenRouter, 2x DeepSeek, 500K users / 13M sessions on OpenCode (10% of its traffic); Z.ai promised 100T/day capacity, throughput collapsed after ~10T (24 tok/s, 34K context clamps, 504s, EU region blocks) | T/C | Fireship, AICodeKing CpMCYO2oWBI, Mehul -gZ1ijkLvoo, Code A Program Ig9y56dBYP0 |
| Fingerprinting: tokenizer 75-token offset match, Z.ai Java class in a stack trace, video-token counting, `parseAmountToCents` code twin with GLM 5.3, "subagents with Chinese names" | T/C | Better Stack hKEdP8nz_w0, Goldie vtegscTMTTA, Stacked 1TD8QbFHC7g |
| The viral "80% DeepSWE" was an 8/10-task sample; full run 58-63% | T | Fireship, John Kim YrUVDm88zBw, Cloud Codes Sz0W7Zt39d0 |
| KingBench 70/80 as ox-alpha → 63/80 on the official API (elevator 8→6, contact lens 10→7, SVG 10→8) | T | AICodeKing CpMCYO2oWBI |

## Settings that matter
| Finding | Grade | Source |
|---|---|---|
| Effort values `low/high/max` only; `medium` → "The request is invalid low or high max" | T | Yousaf ZvqyO4r15GE |
| Thinking cannot be disabled; forced non-thinking gives malformed code; `low` hallucinates asset URLs; uncapped `max` ran 75K+ reasoning tokens without emitting code; a 10-25K thinking cap keeps quality (Inferencer "limited thinking") | T | xCreate tz6b8Xee2B8 |
| `high` ≈ max quality at ~40% of the tokens ("less than 1% improvement for all the extra tokens"); "if it fails, flip to 5.3 full" | C (3, 3+ likes) | Witteveen 7YQJsll4vqw comments, xCreate comments |
| Official params temp 1.0, top_p 0.95, effort max; llama.cpp run used the same | T | digma zIncCNg9z1c, Digital Spaceport ZWS2JVN2iBI |
| "don't overthink it / think less, do more" cut reasoning loops and 504s; ask for modular multi-file output instead of 2,000-3,000-line single files | T | Bowen c4UiiWU7DoI, Stefan 3D 6ExAg0WSUQs, 1littlecoder 3INNP9KXxp4 |
| Provider speed: Z.ai direct 28-33 tok/s (TTFT 4.4 s under load), Baseten 114-115 tok/s; OpenRouter routes 94% to Z.ai unless pinned | T | Theo, ErrorFixer nqDEIUbnya4, Valkov 6QdkqroaeD8 (4-60 tok/s swings) |
| Cline exposes None/Low/Medium/High/Extra High labels for it (harness-side mapping) | T | Tech2AI o-80Oyqffno |

## Cost and quota (measured)
| Finding | Grade | Source |
|---|---|---|
| Promo $0.075/$0.25, cache $0.015, to 2026-09-09; list $0.15/$0.50, cache $0.03; Coding Plan Lite $18 (10K credits/wk, ~80 prompts/5h), Pro $80 (60K), Max $168 (140K); Flash burns 1/3 of 5.3's credits; off-peak/weekends 50% | T | digma, GREZA DvfA-yfJm3Y, AISeeKing iaMJIvt-TKg, Witteveen |
| Full business site in OpenCode at max: 200K tokens, $0.31, "a good few hours", 403/503 errors | T | Income Stream Surfers 5MVH0V4vtsQ |
| Hundreds of PRs audited: 6M input (mostly cached) + 300K output = $0.12 ($0.50 uncached) vs over $100 on Fable 5.1 for a subset | T | Theo |
| 21-prompt Laravel suite: ~$0.02/prompt promo (~$0.18 list), 9-20 min per prompt, edge-case score 8.9/24 (bottom), cleanest code | T | AI Coding Daily k803f7PPSKw |
| Same agent task: GLM 93 turns / 114K tokens / 73 min / $0.16 vs DeepSeek V4 Flash 9 turns / 70K / 10 min / $0.02 | T | Rithesh pek_uo4k6Vc |
| Agentic test battery: GLM $0.069 vs Qwen 3.8 Flash $0.051 (GLM wrote 39 vs 14 test assertions) | T | Local Agent Lab HftGO8ORB2M |
| AA: 47K output tokens per index task vs Luna 20K, Sol 17K; $0.09/task list, $0.045 promo; 150M vs 110M median tokens for the suite ($138 run) | T | Berman, Singularity Feed 80ctP7nuJlM |
| 9.5 h of six heavy ZCode runs = 23% of a mid-tier weekly quota; on the Lite plan a 5-h window goes in ~1 h of coding | T/C | Bowen VmT7SU81tuM, Berman comment |
| Minecraft clone 260K tokens / 5 h; Elden Ring clone 96K / 3 h (OpenCode, free period) | T | Claude Knows My API Key 8KFSHExzxbg |

## What it does well (T unless noted)
Single-file frontend/canvas/Three.js: Mac OS 9 web OS with mini-games (67 min), Rubik's cube sim, V8 engine exploded view, padlock mechanics, DAW, speedboat racer, Fall Guys clone, Rolodex full-stack 69/69 tests (GLM 5.3 full, Donner); Next.js + Drizzle + SQLite scaffold (only model with a real DB in an 8-model bake-off); auth/login working first pass (MG 7469fPGuLeE); 22K-line C# → Rust in one prompt (C); zero-fabrication extraction (84 cells, blanks left blank), 45K-row CSV, earnings-report HTML; tool selection/disambiguation/recovery in a 19-scenario suite (asks on ambiguous "Jordan", finds backup file); self-caught 6 bugs during game generation; 39-assertion API suite and self-repaired a Flask reloader; hallucination traps refused 3/3; 84-language generation without template repetition; Firmware/ARMv6 reverse engineering and a device root exploit in a day (GLM 5.3 full); Blender headless pipelines; 12-hour autonomous Blender restaurant (A).

## Failure modes (T unless noted)
Slow and verbose (20+ min narrating a migration plan before code; 45-75 min scaffolds; 1 h for a 3,000-line app in Claude Code; "2 hours for a small task", 5 likes); doom loops ("why me" existential thinking, 540 likes); mid-task stalls needing "is it done?" prodding; worktree deletion (C); NL2Repo whole-repo generation 56.3 vs Opus 4.8 69.7; vision precision (frog/snake style misses, form coordinates, "barely competes with Luna" 10 likes); Chinese text bleed in long English PDFs; identity hallucination ("I am Claude"); prompt-injection payload echoed downstream; copy = slop, Orwell overcorrection; 3D spatial bugs everywhere (inverted axes, clipping, 20K-poly assets, 92% of tokens reasoning on a ship sim); git commits dated 2025-01-01 (C); Dutch output "not great" (C); ZCode sub-agents lose project memory (official warning); Verdent caps ctx at 300K; quality drop past ~100K context on embedded projects (C, 2 likes).

## Comparisons (winner, evidence)
- vs Opus 4.8: vendor near-parity (CodeBench 29.0 vs 29.5, Terminal-Bench 84.3 vs 85.0, DeepSWE 63.4 vs 58.0, Toolathon 78.4 vs 76.2); KingBench 78.75% vs Opus 4.8 80%.
- vs Opus 5 / Fable: "very good but Opus 5 clearly better" on UE5 logic (C); Johnston gauntlet 91 vs Fable 5.1 98 at 1/470 the cost; Berman: Sol wins 3D dioramas, GLM wins 3 of 4 web-design one-shots; mechanical-watch gear alignment where Fable 5 failed (A).
- vs DeepSeek V4 Flash: DS 2.5x faster and 7-8x cheaper per completed iterative task, higher edge-case pass rate; GLM cleaner code, better hard tasks, vision, lower hallucination; Tech2WiLD replaced DS Flash with GLM as local supervisor for reliability.
- vs Qwen 3.8 Flash Next: GLM KingBench 63 vs 56 (SVG 8 vs 6, folding table 7 vs 2); Qwen 3-4x faster (4 vs 15 min bug fix), better vision-to-frontend fidelity, 27% cheaper per suite, fits under 128 GB locally.
- vs Kimi K3: tied at 91 on Johnston's gauntlet at 30x the output price; Kimi loops on hard tasks.
- vs GLM 5.3 full: Flash better on Three.js wrestling game, worse on single-file C++ 3D; full is text-only, 3x the credits, stronger security/systems; escalate failures to Fable/Sol rather than 5.3 full (Witteveen).
- vs Gemini 3.7 Flash: 200 tok/s vs 35 tok/s; $2 vs $9 for the same Rolodex app (Gemini shallower); 12 min vs 1.7 min per AA task (34 likes).

## Harness and local
- Claude Code: `ANTHROPIC_BASE_URL` to Z.ai's Anthropic-compatible endpoint (npx helper; default maps the Opus slot to GLM 4.7, fix it; Windows needs manual env), or OpenRouter/AgentRouter proxies; free web-tier Z.ai keys fail with `[1113] Insufficient balance`.
- OpenCode: `/models` → provider; Cline free tier; Kilo Code; Codex via proxy (MCP resource-read tools untuned, falls back to CLI); Hermes Agent; Verdent; Herdr.
- Local: FP8 331-386 GB (8x H100/H200, 4x GB200), NVFP4 on 2x DGX Spark 25-40 tok/s (262K ctx cap, `sm121-v8` image), 4x Spark for full ctx; M3 Ultra 512 GB MLX Q9 370 GB at 16-20 tok/s; Unsloth 3-bit 128-150 GB (needs Unsloth's llama.cpp fork), 1-bit 93 GB (71% top-1, "never worth it" 38 likes); 5x 24 GB GPUs for 1-bit at 128K ctx, 33 → 14 tok/s as KV fills; CPU-only <2 tok/s; `mlx-vlm>=0.6.17`; vision not in llama.cpp yet; Orca SAQ 4-bit 200 GB at 92.3% token agreement.

## Other-model news carried (cross-checked in lane E)
Qwen 3.8 Flash Next 2026-08-26/27 ($0.16/$0.47, 125B/6B, Qwen 4 architecture preview); Tencent Hy4 preview 2026-08-27/28 (770B/49B, Apache 2.0); DeepSeek V4 Flash Vision exp 2026-08-21; Gemini 3.5 Transcribe 2026-08-26; Gemini Omni 1.1 Flash 2026-08-27; GLM 5.3 full weights 2026-08-28; GLM 5.5 rumored; Grok 4.7 rumored; GPT-6/Astra rumored (delayed for alignment); Nvidia acquiring Hugging Face (reported, unverified); OpenAI Jalapeño chip; Fish Audio S2.1 Pro free API; Apple M5 Ultra 512 GB Mac Studio; Xiaomi AI Cube.
