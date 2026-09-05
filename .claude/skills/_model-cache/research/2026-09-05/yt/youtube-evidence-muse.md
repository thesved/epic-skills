# YouTube sweep 2026-09-05: 209 videos on Meta Muse Spark 1.3, Gemini 3.7 Flash analyst, goal-lensed

This sweep covers every markdown report in `reports_muse/`: 87 were labeled hands-on, including 33 useful Spark 1.3 developer evaluations, 52 earlier or general Muse evaluations, and 2 irrelevant gameplay streams; 115 were analyzable reaction-only videos; 9 were not analyzable, with the 2 gameplay streams overlapping the hands-on label. Hands-on Spark 1.3 runs carry the evidence. Videos that merely display Meta's launch table supply context, not independent validation. Grades are D for demonstrated on screen and A for asserted.

## TLDR for our routing (10 to 15 bolded decisions with evidence)

**Route non-sensitive, high-volume implementation work to Spark 1.3 Contributor through OpenRouter, because $0.10/M input, $0.002/M cached input, and $0.20/M output can make complete iterations cost cents.** One multi-file voxel project plus fixes cost $0.014, including about 6M cached and 1M input tokens. D; QuartzRouter, "New Muse Spark 1.3 destroys Spark 1.2", `85KA-zOMeX0`, 00:29 to 00:42 and 02:40.

**Do not send proprietary repositories or client data through Contributor, because its discount explicitly exchanges prompts, outputs, and code for Meta product training.** Use the Standard endpoint at $1.25/M input, $0.15/M cached input, and $4.25/M output when privacy matters. D; Onde eu Clico, "Muse Spark 1.3 Catches Up to Anthropic for a Fraction of the Cost", `50xpDCpfPao`, 06:25 to 07:01.

**Keep Fable 5.1 as planner, reviewer, and final polish model, while Spark drafts broad implementations and inexpensive iterations.** Spark produced much broader prototypes quickly, but Fable was reported to produce substantially better architecture, visual finish, and intricate logic. D; Siamese Cat Dev, "I Tested Meta’s Muse Spark 1.3 Against Claude Fable 5.1", `41dHckkZtV0`, 03:39 to 10:40 and 11:02 to 11:18. D; Bijan Bowen, "Meta Muse Spark 1.3 Is HERE", `tLlEzZUyGdM`, 16:43 to 17:18 and 31:25 to 31:55.

**Escalate correctness-critical, long autonomous runs to Sol or Astra when Spark misses completion, drifts from plan, or mishandles irreversible operations.** Spark scored 8/100 on a multi-turn financial workflow and sometimes declared work done prematurely, despite strong intermediate reasoning. D; Matt Johnston, "Muse Spark 1.3 Is Too Cheap For A Reason", `6dH5opXkdU0`, 14:17 to 15:33. A; AICodeKing, "Muse Spark 1.3 & Gemini 3.8 Flash", `WZDtEAFHj7k`, 07:13 to 08:11.

**Use high or xhigh effort for complex builds, but impose a wall-time and token budget before escalating.** Demonstrated runs ranged from 1 minute 49 seconds to 26 minutes, while a CAD workflow reportedly occupied almost 3 hours and another xhigh codebase task needed 6 cycles over roughly an hour. D; Marvijo AI Software, "Five Websites, Same Brief", `aTGPHeRunWI`, 00:52 to 07:15. D; QuartzRouter, `85KA-zOMeX0`, 00:43 to 02:44. D; Onde eu Clico, `50xpDCpfPao`, 08:18 to 13:50. A; STARTUP HAKK, "Muse Spark 1.3 - Meta is cookin!", `yuBJ4Scm_38`, 07:48 to 08:23.

**Require explicit implementation contracts, routes, mechanics, viewport limits, and build checks instead of vague quality language.** A frozen contract produced 5 first-prompt builds with no build errors, while "Call of Duty quality" produced primitive output until mechanics were specified. D; Marvijo AI Software, `aTGPHeRunWI`, 00:34 to 07:15. D; Siamese Cat Dev, `41dHckkZtV0`, 05:56 to 07:54.

**Put browser execution, tests, screenshot inspection, and an independent reviewer around every Spark coding run.** Spark repaired camera-relative controls when given human feedback and tests, and repaired a Three.js mesh after being shown a screenshot, but skipped self-verification in another agent task. D; Agent Workflow Lab, "Muse Spark 1.3 Built 3 Browser Games", `aqrt3hIsu24`, 01:34 to 02:28. D; Bijan Bowen, `tLlEzZUyGdM`, 13:25 to 14:12. D; 阿石OMP, "Gemini 3.8 Flash vs Meta Muse Spark 1.3", `3pFzcIOpZAM`, 03:27 to 05:22.

**Do not trust Spark unattended with physics, CAD dimensions, collision systems, or camera coordinates.** Independent runs exposed inverted steering, upside-down mounting geometry, floating objects, incorrect hitboxes, stuck enemies, and nonfunctional smelting and sand physics. D; Agent Workflow Lab, `aqrt3hIsu24`, 01:51 to 02:28. D; Bijan Bowen, `tLlEzZUyGdM`, 20:45 to 22:55. D; IA Latinoamérica, "Does Muse Spark 1.3 CRUSH Gemini 3.8?", `xpvOpAFLRbA`, 05:16 to 13:58. D; QuartzRouter, `85KA-zOMeX0`, 02:24 to 04:35.

**Prefer Spark for frontend breadth, stateful UI prototypes, single-file games, tool-driven retrieval, and bounded repository analysis.** It repeatedly built working dashboards, simulations, games, structured JSON, and responsive multi-framework sites in one prompt. D; Marvijo AI Software, `aTGPHeRunWI`, 00:52 to 07:15. D; Johanna Hendrix, "Meta Muse Spark 1.3 Review", `qfVFUcLpVYU`, 08:24 to 18:29.

**Use the 1M context through tools and search scripts, not by assuming the model will reason perfectly over a raw million-token prompt.** In an approximately 800k-token corpus, tool-assisted retrieval found three needles in 16, 7, and 7 seconds and correctly rejected a nonexistent fact in 40 seconds. D; AI Consultive, "Meta sort un modèle top 3 mondial", `wLGEhu5EEzQ`, 08:33 to 12:20.

**Treat Meta's launch benchmark table as directional context only.** Numerous videos re-read the same table, while independent suites found Spark 1.3 at 79/100 versus Spark 1.2 at 83/100 and 71.25% versus 76.25%, contradicting the implied universal upgrade. D; Matt Johnston, `6dH5opXkdU0`, 15:09 to 15:33. D; AICodeKing, `WZDtEAFHj7k`, 01:08 to 07:33.

**Do not plan production capacity around the free OpenCode Zen route.** Reports describe it as temporary, show rate-limit retries, and contrast it with a Muse CLI that returned `billing_error` without billing details. D; WTF Code, "Muse Spark 1.3 Is FREE", `iqwJI3PMn0A`, 08:37 to 08:44. D; Jesus Vibe, "Muse Spark 1.3 recrea GALAXIAN", `M_CYl8oz5Yc`, 04:55 to 07:18. D; カレーちゃんのAI道場, "MetaがMuse Spark1.3をリリース", `-WCBmotfxS4`, 13:17 to 14:55.

**Treat audio support as provisional and do not confuse Spark with Glimmer.** OpenRouter showed an audio degradation warning, although one direct test successfully analyzed a 44-second clip with audio; Glimmer is a separate model and appears here only in comparative cost and speed charts. D; Bijan Bowen, `tLlEzZUyGdM`, 01:18 to 01:36. D; Johanna Hendrix, `qfVFUcLpVYU`, 03:50. D; 阿石OMP, `3pFzcIOpZAM`, 02:06 to 02:35.

**Build provider retries and idempotent tool operations into the OpenRouter path.** Launch-period hands-on runs encountered repeated HTTP 503 errors, rate limits, an 8-minute connection failure, and missing OpenCode model metadata. D; Fahd Mirza, "Going Open Weight Soon, Fully Tested", `euJl6i8pT3g`, 04:29 to 04:42. D; Johanna Hendrix, `qfVFUcLpVYU`, 06:00. D; Marvijo AI Software, `aTGPHeRunWI`, 04:42.

## Who actually ran it

The table is restricted to Spark 1.3 itself. `HVkVcNtTBvc` and `ujH24Pgd4Ao` were labeled hands-on by their reports, but their live runs were of other models or Muse Voice, so they are not counted here.

| source | harness or surface | what they did | grade | video id |
|---|---|---|---|---|
| Bijan Bowen | Muse Code CLI via OpenRouter | Seven coding, CAD, Blender, Godot, MCP, and screenshot-debug tasks, with final token and cost totals [04:18 to 31:01] | D | `tLlEzZUyGdM` |
| AICodeKing | KingBench harness, Verdent shown separately | Eight coding, math, 3D, SVG, and agent tasks [01:08 to 06:44] | D | `WZDtEAFHj7k` |
| Onde eu Clico | OpenCode Go | PDF reader, voxel game, landing page, and long CAD engine workflow [08:59 to 15:13] | D | `50xpDCpfPao` |
| まさおAIじっくり解説ch | OpenCode and preview harness | Video analysis and multiple web, Three.js, SVG, and diagram tests [05:48 to 17:21] | D | `TcQiRWIj6hg` |
| Fahd Mirza | Hermes Agent CLI via OpenRouter | Provisioned AWS S3 and CloudFront, deployed a site, then ran vision, chemistry, and multilingual tests [01:10 to 10:50] | D | `euJl6i8pT3g` |
| STARTUP HAKK | OpenCode, tested before recording | Large-codebase implementation that needed 6 iterations and about an hour [06:41 to 08:23] | D | `kqvU-NKrP_8` |
| STARTUP HAKK | OpenCode, duplicate or closely related upload | Same reported large-codebase workflow and first-run failure [07:48 to 08:23] | D | `yuBJ4Scm_38` |
| NiceKate AI | OpenCode Desktop | PDF-to-web, image-to-Blender, OpenSCAD, WebGL, Remotion, and game tasks [02:27 to 12:35] | D | `Zyw4mz84_Dw` |
| 阿石OMP | Comparative agent harness | Content-card agent task and civilization simulation against Gemini 3.8 Flash [03:27 to 08:15] | D | `3pFzcIOpZAM` |
| WEBdoze | OpenCode Zen | Astro and Tailwind site build against Gemini 3.8 Flash in Antigravity [00:42 to 10:28] | D | `N4q3EUP61kI` |
| WTF Code | OpenCode CLI and Zen | Flappy Bird, typing game refactor, and trading dashboard with Playwright checking [03:33 to 08:21] | D | `iqwJI3PMn0A` |
| AI Consultive | OpenCode | Video-to-site build and tool-assisted retrieval over about 800k tokens [05:08 to 14:35] | D | `wLGEhu5EEzQ` |
| IA Professeur | OpenCode Zen | Three.js FPS, refusal and clarification behavior, and Versailles model [01:11 to 08:33] | D | `mlV3wNToE3g` |
| QuartzRouter | `pi` v0.66.4 through OpenRouter | Voxel game generation and two-bug repair at xhigh [00:43 to 04:50] | D | `85KA-zOMeX0` |
| Hyperautomation Labs | Web app execution surface | Ran three Spark-generated apps, including RTS, tuner, and board game [01:54 to 03:21] | D | `5ySUNQJ-wg8` |
| Codedigipt | OpenCode Zen | Image-to-dashboard and Three.js orbital dashboard [00:10 to 02:13] | D | `dYSy5H0YQo4` |
| Siamese Cat Dev | OpenCode Contributor | Browser OS, shooters, and 5-subagent kart racer [01:31 to 10:15] | D | `41dHckkZtV0` |
| Marvijo AI Software | OpenCode CLI | Five frozen-contract full-stack framework builds against Gemini 3.8 Flash [00:34 to 07:15] | D | `aTGPHeRunWI` |
| Johanna Hendrix | OpenRouter test surface | Video/audio, JSON, support, 3D game, code-size, particle, UI, and writing tests [03:50 to 18:29] | D | `qfVFUcLpVYU` |
| IA Latinoamérica | OpenCode Zen | Four xhigh coding and multimodal 3D tasks [03:49 to 13:58] | D | `xpvOpAFLRbA` |
| カレーちゃんのAI道場 | Muse Code 1.0.2 | Contributor high run for SVG and Three.js flamingo animations [14:45 to 74:45] | D | `-WCBmotfxS4` |
| Mustafa Sayed | OpenCode plus Superpowers | Repository architecture review and Flutter/Supabase remediation [04:10 to 07:53] | D | `etLSxX9ou-s` |
| Coding Lifestyle 4u | OpenCode CLI in VS Code | Began scaffolding a large Next.js employee system from a 2,169-line prompt [03:47 to 04:35] | D | `g4Xp4nnRFY4` |
| Cloud Developer | Prayas Chat proxy | Basic identity and latency query only, no coding or tools [03:46 to 04:55] | D | `e_--oV2QUiY` |
| Agent Workflow Lab | Hermes Agent CLI v0.21.0 via OpenRouter | Three games, automated QA, human playtesting, and repair loops [00:27 to 04:43] | D | `aqrt3hIsu24` |
| David Yin | Command Code/OpenCode plan surfaces | Eight Chinese questions measuring latency and reasoning-token share [01:04 to 02:40] | D | `P5NAmw1mDWg` |
| Jesus Vibe | OpenCode Zen GUI | One-prompt Galaxian game at xhigh, including provider retries [00:25 to 13:34] | D | `M_CYl8oz5Yc` |
| TonkaToyXL | Frozen no-tools harness | Two one-shot visual coding tests against Gemini and Qwen [00:12 to 02:45] | D | `l3OW5b0172Q` |
| MaNaMiiStudio | Cline in VS Code via OpenRouter | Two React/Vite interactive applications at xhigh [02:17 to 12:40] | D | `BDi912pibRU` |
| MaNaMiiStudioGB | Cline via OpenRouter | English-language upload of the same two-app experiment [02:18 to 12:33] | D | `4g51N4YXQMo` |
| Matt Johnston | Stone Labs Benchmark Workbench | Nine independent capability tests with per-task scores [01:21 to 15:33] | D | `6dH5opXkdU0` |
| WEBdoze | OpenCode and `ego-browser` | Frontend redesign with and without an external design skill [01:25 to 14:20] | D | `jSmGKrhYkmc` |

## Strengths

| finding | grade | source with timestamp |
|---|---|---|
| Strong breadth in one-shot frontend and application scaffolding, including responsive routes, local state, charts, games, simulations, and WebGL | D | Marvijo AI Software, "Five Websites, Same Brief", `aTGPHeRunWI`, 00:52 to 07:15 |
| Five out of five full-stack framework projects passed the build on prompt 1 with 0 build errors | D | Marvijo AI Software, `aTGPHeRunWI`, 00:52 to 07:15 |
| Can repair defects when given concrete console errors, screenshots, QA reports, or human playtest descriptions | D | Siamese Cat Dev, `41dHckkZtV0`, 08:33 to 09:19; Agent Workflow Lab, `aqrt3hIsu24`, 01:51 to 02:28; Bijan Bowen, `tLlEzZUyGdM`, 13:25 to 14:12 |
| Tool-assisted long-context retrieval succeeded at the beginning, middle, and end of an approximately 800k-token corpus | D | AI Consultive, `wLGEhu5EEzQ`, 08:33 to 11:15 |
| Correctly rejected nonexistent information after checking all 34 documents | D | AI Consultive, `wLGEhu5EEzQ`, 11:24 to 12:20 |
| Successfully completed AWS provisioning, frontend generation, deployment, and live URL verification | D | Fahd Mirza, `euJl6i8pT3g`, 01:10 to 06:20 |
| Strong bounded structured-output compliance: 100 JSON entries and 30 support tickets under schema and word-count constraints | D | Johanna Hendrix, `qfVFUcLpVYU`, 08:24 to 12:57 |
| Good visual pragmatics on a WhatsApp screenshot and correct multi-step chemistry reasoning with final pH 9.38 | D | Fahd Mirza, `euJl6i8pT3g`, 06:22 to 08:50 |
| Built OpenSCAD files that compiled and could be physically printed, despite dimensional mistakes | D | Bijan Bowen, `tLlEzZUyGdM`, 20:45 to 22:55 |
| Connected to Blender and Godot through MCP and produced a playable wrestling game | D | Bijan Bowen, `tLlEzZUyGdM`, 22:58 to 25:56 |
| Generated a smooth 100,000-particle canvas scene and a 1,134-byte animated campfire under a 2KB limit | D | Johanna Hendrix, `qfVFUcLpVYU`, 15:48 to 15:58 |
| Shows useful boundary calibration on impossible or unbounded prompts, offering scoped alternatives | D | IA Professeur, `mlV3wNToE3g`, 01:39 to 02:44 |

## Weaknesses, failures, refusals, costs

| finding | grade | source with timestamp |
|---|---|---|
| Multi-turn financial workflow collapsed at final execution and scored 8/100 | D | Matt Johnston, "Too Cheap For A Reason", `6dH5opXkdU0`, 14:17 to 14:52 |
| Independent aggregate score regressed from Spark 1.2's 83/100 to Spark 1.3's 79/100 | D | Matt Johnston, `6dH5opXkdU0`, 15:09 to 15:33 |
| KingBench regressed from Spark 1.2's 76.25% to Spark 1.3's 71.25%, including SVG and folding-animation losses | D | AICodeKing, `WZDtEAFHj7k`, 01:08 to 07:33 |
| Repeated collision, camera, pathfinding, coordinate-frame, and object-clipping bugs | D | IA Latinoamérica, `xpvOpAFLRbA`, 05:16 to 13:58; Agent Workflow Lab, `aqrt3hIsu24`, 01:51 to 02:28 |
| CAD output inverted screw tapers and axle slots, requiring gluing and sanding | D | Bijan Bowen, `tLlEzZUyGdM`, 21:20 to 22:38 |
| Weak visual fidelity can yield primitive geometry, distorted SVGs, inaccurate proportions, sparse scenes, and low-poly output despite realism prompts | D | NiceKate AI, `Zyw4mz84_Dw`, 04:09 to 08:08; Agent Workflow Lab, `aqrt3hIsu24`, 02:46 |
| Can skip research or self-verification and compress detailed instructions into a much simpler result | D | NiceKate AI, `Zyw4mz84_Dw`, 06:17 to 09:24; 阿石OMP, `3pFzcIOpZAM`, 03:27 to 04:25 |
| Long agent runs can drift from plan, claim completion early, or rewrite entire files for small edits | A | AICodeKing, `WZDtEAFHj7k`, 07:13 to 08:11 |
| Large codebase run produced no usable output initially, needed 6 iterations and roughly an hour, and remained "vibe coded" | D | STARTUP HAKK, `yuBJ4Scm_38`, 07:48 to 08:23 |
| Contributor tier exposes submitted data to training; Standard is 12.5x the input price and 21.25x the output price | D | Onde eu Clico, `50xpDCpfPao`, 06:25 to 07:01 |
| HTTP 503, rate-limit, disconnection, and metadata fallback failures appeared across providers and harnesses | D | Fahd Mirza, `euJl6i8pT3g`, 04:29 to 04:42; Johanna Hendrix, `qfVFUcLpVYU`, 06:00; Marvijo AI Software, `aTGPHeRunWI`, 04:42 |
| Audio is advertised as an input but OpenRouter warns that support is incomplete and quality may degrade | D | Bijan Bowen, `tLlEzZUyGdM`, 01:18 to 01:36 |
| Free OpenCode route experienced upstream `rate_limit_exceeded` retries | D | Jesus Vibe, `M_CYl8oz5Yc`, 04:55 to 07:18 |
| Literal negative-prompt text can bleed into customer-facing answers | D | Johanna Hendrix, `qfVFUcLpVYU`, 12:07 |
| Raw API costs can accumulate: one 7-task suite reached $16.99 | D | Bijan Bowen, `tLlEzZUyGdM`, 30:22 to 31:01 |
| The model correctly refused an unbounded AAA-quality task and endless subagent loop, but this means orchestration must handle clarification turns | D | IA Professeur, `mlV3wNToE3g`, 01:39 to 02:24 |

## Measured costs, speed, tokens

Repeated appearances of the same tariff or benchmark figure are consolidated and co-cited. This includes every distinct cost, token, throughput, latency, and task wall-time figure found in the useful Spark 1.3 hands-on reports. Unrelated mock application values, such as a shopping-cart total, are excluded.

| measurement | value | grade and source |
|---|---|---|
| Contributor API | $0.10/M input, $0.002/M cached input, $0.20/M output | D; Onde eu Clico, `50xpDCpfPao`, 06:25; QuartzRouter, `85KA-zOMeX0`, 00:29 to 00:42 |
| Standard API | $1.25/M input, $0.15/M cached input, $4.25/M output | D; Onde eu Clico, `50xpDCpfPao`, 06:25 |
| Conflicting cache listing | $0.02/M cache read, weighted averages $0.01353/M input and $0.1996/M output | D; MaNaMiiStudio, `BDi912pibRU`, 00:36 to 00:59 |
| Artificial Analysis cost/task | Spark high or xhigh reported at $0.41 and $0.55 | D; IA Latinoamérica, `xpvOpAFLRbA`, 00:57 to 01:02 |
| OpenRouter throughput and latency | 83 t/s, 2.63s TTFT | D; MaNaMiiStudioGB, `4g51N4YXQMo`, 00:51 |
| OpenRouter provider distribution | 83 tps average; P50 114, P90 165, P99 241 tps; 2.63s P50 latency | D; MaNaMiiStudio, `BDi912pibRU`, 00:36 to 00:59 |
| Other observed/provider speeds | 85 t/s and 2.89s; 88 t/s and 3.93s; 91.0 t/s and 2.67s; 149.9 t/s; 172 t/s; 208 t/s; 209 t/s and 44.05s TTFT | D; Bijan Bowen, `tLlEzZUyGdM`, 03:56; Codedigipt, `dYSy5H0YQo4`, 07:42; Vini Lana, `ujH24Pgd4Ao`, 36:54 to 39:35; Dracon Dev & AI, `HVkVcNtTBvc`, 04:37; MaNaMiiStudio, `BDi912pibRU`, 01:03 to 02:13; まさおAIじっくり解説ch, `TcQiRWIj6hg`, 05:18; AI Consultive, `wLGEhu5EEzQ`, 03:08 |
| Simple proxy query | 234 prompt, 792 output, 1,026 total tokens in 0.70s | D; Cloud Developer, `e_--oV2QUiY`, 04:42 |
| Comparative agent task | Spark 3m53s and 29 steps; Gemini 2m48s and 22 steps, or 5m including publishing | D; 阿石OMP, `3pFzcIOpZAM`, 03:27 to 05:22 |
| Cline smart-city run | 8,100 prompt and 124,000 total/output-reported tokens | D; MaNaMiiStudio, `BDi912pibRU`, 03:06 to 03:31 |
| Cline room-planner run | 7,000 prompt, 122,000 tokens, 22m49.09s | D; MaNaMiiStudio, `BDi912pibRU`, 09:21 to 09:48 |
| OpenCode small apps | about 3m at $0.10; 3.5m at $0.25; 1.5 to 2m at $0.35 to $0.40 | D; Onde eu Clico, `50xpDCpfPao`, 08:59 to 12:26 |
| OpenCode CAD context | 424.8k tokens, 40% context, $2.48; almost 3h for the largest CAD workflow | D; Onde eu Clico, `50xpDCpfPao`, 08:18 to 13:50 |
| OpenCode subscription use | $10/month, approximately R$50/month; 3h used 19.6% of a 5h quota, 7.8% weekly, 3.9% monthly | D; Onde eu Clico, `50xpDCpfPao`, 07:53 to 08:48 |
| QuartzRouter voxel project | 26m initial, 5m fix, $0.014 total, about 6M cached plus about 1M input tokens | D; QuartzRouter, `85KA-zOMeX0`, 00:57 to 04:50 |
| Five-site Spark times | 2m00s, 2m36s, 1m49s, 2m24s, 2m22s | D; Marvijo AI Software, `aTGPHeRunWI`, 00:52 to 07:15 |
| Five-site Gemini times | 7m32s, 17m43s, 12m41s, 7m23s, 7m50s | D; Marvijo AI Software, `aTGPHeRunWI`, 00:52 to 07:15 |
| Astro comparison | Spark 6m12s; Gemini 7m30s | D; WEBdoze, `N4q3EUP61kI`, 04:15 to 05:08 |
| Frozen visual suite | Spark 408.8s and 47,006 output tokens for less than $0.01; Gemini 159.3s and 52,613 for $0.048; Qwen 284.9s and 97,308 for $0.654 | D; TonkaToyXL, `l3OW5b0172Q`, 02:07 to 02:35 |
| Video/audio audit | 44s clip, $0.0307, 15,876 total tokens, 3,980 reasoning tokens | D; Johanna Hendrix, `qfVFUcLpVYU`, 03:50 |
| JSON task | $0.0855, 20,584 total tokens, 9,294 reasoning tokens | D; Johanna Hendrix, `qfVFUcLpVYU`, 08:24 |
| Support task | $0.0385, 10,235 total tokens, 1,449 reasoning tokens | D; Johanna Hendrix, `qfVFUcLpVYU`, 10:58 |
| Max-effort game | $0.90, 28,378 output and 35,972 total tokens | D; Johanna Hendrix, `qfVFUcLpVYU`, 13:25 |
| Small code and writing | 1,134 bytes at $0.0601; termination email $0.0163, 3,737 total and 2,687 reasoning tokens | D; Johanna Hendrix, `qfVFUcLpVYU`, 15:48 and 18:29 |
| Failed generation | 8m before network `finish_reason: error` | D; Johanna Hendrix, `qfVFUcLpVYU`, 06:00 |
| Bijan cumulative run | $1.36 at 2.8M input and 106.2k output; $4.20 at 12.3M and 261.3k; then $6.94, $9.01, $10.66, $13.07; final $16.99 at 52.5M input and 908.5k output | D; Bijan Bowen, `tLlEzZUyGdM`, 06:12 to 31:01 |
| Bijan task times | screenshot repair 12m; CAD 11m24s; subway game 34m50s; MCP wrestling game under 10m | D; Bijan Bowen, `tLlEzZUyGdM`, 13:25 to 24:30 |
| OpenCode game/dashboard runs | 28s, 73s, and 2m05s; project read in 2.9s | D; WTF Code, `iqwJI3PMn0A`, 03:33 to 08:01 |
| Image-to-code runs | 1m27s with 23,062 context tokens; 2m17s with 36,928 | D; Codedigipt, `dYSy5H0YQo4`, 00:47 to 00:53 |
| Free OpenCode runs | $0.00 for 26,909 tokens with 9.2s thinking; $0.00 for 32.4k tokens with 10.8s thinking | D; IA Professeur, `mlV3wNToE3g`, 01:26 to 06:15 |
| Repository review | 22 reads, 6 searches, 3m42s at xhigh | D; Mustafa Sayed, `etLSxX9ou-s`, 06:36 to 07:53 |
| Video/site and retrieval | 41.6s, 19MB video; site 1m42s plus 11s server start; retrieval 16s, 7s, 7s, and 40s over about 800k tokens | D; AI Consultive, `wLGEhu5EEzQ`, 05:33 to 12:20 |
| Direct Muse CLI animations | SVG 81s; Three.js 64s | D; カレーちゃんのAI道場, `-WCBmotfxS4`, 25:54 and 71:15 |
| Full test session | $2.49 across AWS, vision, chemistry, and multilingual tests | D; Fahd Mirza, `euJl6i8pT3g`, 10:42 to 10:50 |
| Chinese question sample | 30s median versus 14s for prior version; 82% of output tokens were billed reasoning | D; David Yin, `P5NAmw1mDWg`, 02:22 to 02:40 |
| Meta efficiency claim | about 20% fewer tool calls and 25% fewer tokens than 1.2 | A; Onde eu Clico, `50xpDCpfPao`, 01:50 |
| Reaction-only verbosity analysis | 120M reasoning tokens versus 72M market median; roughly 3x Spark 1.2 thinking volume | A; Yersham, "Benchmarks versus reality", `1WVbF2wp9k4`, 13:26 to 15:44 |

## How-to-get-the-max: effort, prompting, harness, tiers

1. Use `meta/muse-spark-1.3-contributor` on OpenRouter only for public, generated, disposable, or otherwise non-sensitive work; use Standard for proprietary material. D; Onde eu Clico, `50xpDCpfPao`, 06:25 to 07:43.

2. Default to high effort for ordinary coding and xhigh for hard multi-file, 3D, or audit work, but attach explicit wall-time and token ceilings. D; QuartzRouter, `85KA-zOMeX0`, 00:43 to 01:06; Mustafa Sayed, `etLSxX9ou-s`, 04:03 to 07:53.

3. Give a frozen implementation contract covering routes, components, persistence, viewport, forbidden placeholders, completion behavior, and the exact build/test command. D; Marvijo AI Software, `aTGPHeRunWI`, 00:34 to 00:52.

4. Translate subjective goals into mechanics and invariants: controls, coordinate axes, collision rules, asset policy, feedback, state transitions, and camera behavior. D; Siamese Cat Dev, `41dHckkZtV0`, 05:56 to 07:54; カレーちゃんのAI道場, `-WCBmotfxS4`, 72:15 to 73:45.

5. Require the harness to build, execute tests, open the rendered result, capture screenshots, and repeat until both automated checks and visual review pass. D; WEBdoze, `jSmGKrhYkmc`, 06:11 to 06:53; Agent Workflow Lab, `aqrt3hIsu24`, 01:09 to 04:43.

6. When a visual defect appears, send the screenshot rather than only describing it. Spark's demonstrated screenshot loop repaired a Three.js layering fault in 12 minutes. D; Bijan Bowen, `tLlEzZUyGdM`, 13:25 to 14:12.

7. Put planning before Spark and an independent Fable, Sol, or Astra review after it; isolate parallel implementers in separate workspaces and inspect every diff. A; AICodeKing, `WZDtEAFHj7k`, 08:00 to 09:20.

8. Use tool-assisted search over large contexts. Let Spark write deterministic search scripts, then make it cite document and match counts, including negative searches. D; AI Consultive, `wLGEhu5EEzQ`, 08:33 to 12:20.

9. Add idempotent retries for HTTP 503, rate limits, and connection failures, but cap retries so a degraded provider does not burn an entire orchestration budget. D; Fahd Mirza, `euJl6i8pT3g`, 04:29 to 04:42; Jesus Vibe, `M_CYl8oz5Yc`, 04:55 to 07:18.

10. Verify skills and MCP registrations before the run. One redesign silently skipped its required skill until the OpenCode daemon was restarted. D; WEBdoze, `jSmGKrhYkmc`, 10:50 to 13:24.

11. Never allow unattended destructive writes, publishing, billing, or customer messaging. Spark's calibration is useful, but separate reports still show premature completion and full-file rewrites. A; AICodeKing, `WZDtEAFHj7k`, 07:13 to 08:11.

12. Use a routing escalation trigger based on failed tests, repeated whole-file rewrites, missing requested sections, geometry errors, or two unsuccessful repair cycles, then hand the state and diffs to Fable, Sol, or Astra. This routing rule is an inference from demonstrated failures. D evidence; Matt Johnston, `6dH5opXkdU0`, 03:28 to 15:33; 阿石OMP, `3pFzcIOpZAM`, 03:27 to 05:22.

## Comparisons with numbers (Fable 5.1, Sol, Astra, Gemini 3.7/3.8 Flash, DeepSeek, GLM, Qwen; table)

Vendor launch-table rows are labeled context even though the table was demonstrated on screen.

| comparison | numbers | grade and source |
|---|---|---|
| Fable 5.1, independent Stone suite | Fable 91/100, Spark 1.3 79/100, Spark 1.2 83/100, Gemini 3.8 Flash 72/100, Gemini 3.7 Flash 66/100 | D; Matt Johnston, `6dH5opXkdU0`, 15:09 to 15:33 |
| Fable 5, independent KingBench | Fable 82.5%, Gemini 3.8 Flash 81.25%, Qwen 3.8 Max 81.25%, Spark 1.2 76.25%, DeepSeek V4 Flash 72.5%, Spark 1.3 71.25%, Sol 71.25% | D; AICodeKing, `WZDtEAFHj7k`, 05:42 to 06:44 |
| Fable 5.1 intelligence and cost | Fable max 66, Spark xhigh 63; Fable $0.94/task or $2.76 max with fallback, Spark high $0.41 and xhigh $0.55 | D; IA Latinoamérica, `xpvOpAFLRbA`, 00:29 to 01:02 |
| Sol, Meta launch-table context | GDPval 1754 vs 1710; JobBench 64.9 vs 45.4; OSWorld 66.9 vs 62.7; DeepSearchQA 89.4 vs 93.0; Agentic IF 57.8 vs 60.5; AutomationBench 49.4 vs 46.7; DeepSWE 75.4 vs 73.0; SWEAtlas 59.4 vs 53.5; Terminal-Bench 88.8 vs 88.8; MRCR 512K to 1M 98.1 vs 73.8 | D, launch-table context; Bijan Bowen, `tLlEzZUyGdM`, 00:16 to 00:46 |
| Astra and harness effect | Coding Agent Index: Astra in Codex CLI 63, Spark in Muse Code 62, Astra in OpenCode 61, Spark in OpenCode 58, Sol in Codex CLI 61, Sol in OpenCode 59 | D; IA Latinoamérica, `xpvOpAFLRbA`, 00:26 |
| Astra cost/accuracy | Astra High $7.48 at 57.6%, Astra Max $10.35 at 56.7%, Fable High $19.50 at 55.8% on Terminal-Bench 4.0 | D; Vini Lana, `ujH24Pgd4Ao`, 20:20 to 20:38 |
| Gemini 3.8, five-site direct test | Spark 47/50 versus Gemini 34/50; Spark 1m49s to 2m36s per project versus Gemini 7m23s to 17m43s | D; Marvijo AI Software, `aTGPHeRunWI`, 00:52 to 07:15 |
| Gemini 3.8, content-agent direct test | Spark 3m53s, 29 steps, missed verification and report; Gemini 2m48s, 22 steps, completed verification and report | D; 阿石OMP, `3pFzcIOpZAM`, 03:27 to 05:22 |
| Gemini and Qwen, frozen visual suite | Spark 63.9/100, Qwen 61.3/100, Gemini 51.0/100; costs less than $0.01, $0.654, and $0.048 respectively | D; TonkaToyXL, `l3OW5b0172Q`, 02:07 to 02:45 |
| Gemini 3.7 and 3.8, KingBench | Gemini 3.8 81.25%, Gemini 3.5 30%; Stone suite separately reports Gemini 3.8 at 72 and 3.7 at 66 | D; AICodeKing, `WZDtEAFHj7k`, 05:42 to 06:44; Matt Johnston, `6dH5opXkdU0`, 15:16 |
| Throughput comparison | Gemini 3.8 302 t/s, Spark 209, Glimmer 109, Fable 67, DeepSeek V4 Pro 57 | D; 阿石OMP, `3pFzcIOpZAM`, 02:06 to 02:35 |
| DeepSeek and GLM intelligence/cost | GLM 5.3 Flash $0.06 and score 57; GLM 5.3 max $0.53 and 60; DeepSeek V4 $0.88 in one chart and score 53 in another; Spark high $0.41 and 60, xhigh $0.55 and 63 | D; IA Latinoamérica, `xpvOpAFLRbA`, 00:57 to 01:02; MaNaMiiStudio, `BDi912pibRU`, 01:03 to 02:13 |
| GLM direct qualitative comparison | Presenter said GLM 5.3 Flash produced a cleaner one-prompt voxel build than Spark 1.3 | A; QuartzRouter, `85KA-zOMeX0`, 04:14 to 04:20 |
| Qwen direct visual comparison | Qwen passed 16/20 functional checks, Spark 14/20, Gemini 11/20; Spark nevertheless won combined score due to visual and cost categories | D; TonkaToyXL, `l3OW5b0172Q`, 02:16 to 02:45 |
| Glimmer, separate model | Glimmer high was shown at 109 t/s and $0.10/task; it is not Spark 1.3 | D; 阿石OMP, `3pFzcIOpZAM`, 02:06 to 02:35; IA Latinoamérica, `xpvOpAFLRbA`, 01:02 |

## Spark 1.3 vs 1.2 regressions and gains reported

| change | evidence | grade and source |
|---|---|---|
| Major official long-context gain | MRCR 256K to 512K: 98.5 vs 66.3; 512K to 1M: 98.1 vs 55.5 | D, launch-table context; Bijan Bowen, `tLlEzZUyGdM`, 00:16 to 00:46 |
| Official coding gain | DeepSWE 75.4 vs 55.0; SWEAtlas 59.4 vs 46.2; Terminal-Bench 88.8 vs 82.9 | D, launch-table context; Bijan Bowen, `tLlEzZUyGdM`, 00:16 to 00:46 |
| Official agent gain | OSWorld 66.9 vs 47.6; Agentic IF 57.8 vs 46.2; AutomationBench 49.4 vs 38.2 | D, launch-table context; Onde eu Clico, `50xpDCpfPao`, 02:01 |
| Claimed efficiency gain | About 20% fewer tool calls and 25% fewer tokens | A; Onde eu Clico, `50xpDCpfPao`, 01:50 |
| Independent overall regression | Stone suite: 79/100 for 1.3 versus 83/100 for 1.2 | D; Matt Johnston, `6dH5opXkdU0`, 15:09 to 15:33 |
| Independent visual regression | KingBench total: 71.25% versus 76.25%; SVG 5/10 versus 10/10; folding table 5/10 versus 8/10 | D; AICodeKing, `WZDtEAFHj7k`, 03:04 to 07:33 |
| Independent logic gains | Elevator simulation 7/10 versus 5/10; GMT watch 8/10 versus 6/10 | D; AICodeKing, `WZDtEAFHj7k`, 02:04 to 02:32 and 05:14 to 05:41 |
| Latency regression | Median 30 seconds versus 14 seconds on eight Chinese questions | D; David Yin, `P5NAmw1mDWg`, 02:22 to 02:40 |
| Reasoning-volume concern | 82% of output tokens were reasoning in that sample; another analysis asserted roughly 3x 1.2 thinking volume | D and A; David Yin, `P5NAmw1mDWg`, 02:22 to 02:40; Yersham, `1WVbF2wp9k4`, 13:26 to 15:44 |
| Concrete game improvement with remaining gaps | Fixed 1.2's ground transparency; still left broken furnace and sand physics | D; QuartzRouter, `85KA-zOMeX0`, 01:16 to 04:35 |

The resolution is task mix. Spark 1.3 clearly improves official long-context and codebase benchmarks and shows stronger bounded logic in some tests, but the independent suites indicate that visual generation and long-loop reliability did not improve uniformly.

## Muse Code CLI, Contemplating mode, free and contributor tiers, region gating (what videos showed)

| topic | what was shown | grade and source |
|---|---|---|
| Muse Code | Muse Code 1.0.2 ran `muse-spark-1.3-contributor --high`; flags such as `--ultra` and `--yolo` were also demonstrated | D; カレーちゃんのAI道場, `-WCBmotfxS4`, 14:45 to 28:00; Bijan Bowen, `tLlEzZUyGdM`, 08:00 to 08:15 |
| Muse Code integrations | Dashboard tabs showed Muse Code, OpenCode, Claude Code, Cursor, Cline, cURL, and Python | D; カレーちゃんのAI道場, `-WCBmotfxS4`, 12:21 |
| Muse Code access | One presenter requested Muse Code access and was rejected | D; NiceKate AI, `Zyw4mz84_Dw`, 02:24 |
| Billing | Direct web and Muse CLI attempts returned `billing_error` without a registered payment method | D; カレーちゃんのAI道場, `-WCBmotfxS4`, 13:17 to 14:55 |
| Contemplating or max | Videos showed max benchmark rows, but reports state the configuration remained restricted or pending safety evaluation; actual public runs generally used high, xhigh, or ultra | D and A; NiceKate AI, `Zyw4mz84_Dw`, 01:36 to 01:45; Standarity, "The Model That Asks Before It Acts", `4FPKhryHKiQ`, 00:20 |
| Free route | OpenCode Zen exposed "Muse Spark 1.3 Free", but reports call it temporary and show rate-limit retries | D; WTF Code, `iqwJI3PMn0A`, 01:52 to 04:40 and 08:37 to 08:44; Jesus Vibe, `M_CYl8oz5Yc`, 04:55 to 07:18 |
| Contributor | $0.10/M input, $0.002/M cached, $0.20/M output, with data used for product improvement | D; Onde eu Clico, `50xpDCpfPao`, 06:25 to 07:01 |
| Standard | $1.25/M input, $0.15/M cached, $4.25/M output, with data not used for product improvement | D; Onde eu Clico, `50xpDCpfPao`, 06:25 |
| OpenCode Go quota | 45,300 requests per 5-hour window in supported regions | D; AI Consultive, `wLGEhu5EEzQ`, 00:36 |
| Higher OpenCode plan | 236,400 requests/month under a $60 tier, with 45,300 per 5 hours | D; Dracon Dev & AI, `HVkVcNtTBvc`, 04:44 |
| Muse subscription display | 799 JPY/month for 10 to 50 prompts per 5 hours, 2,399 JPY/month for 3x usage, and 7,999 JPY/month for the highest tier | D; カレーちゃんのAI道場, `-WCBmotfxS4`, 15:45 to 16:30 |
| Region gating | Contributor pricing was described as region-restricted, and OpenCode stated limits only for supported regions; no report supplied a complete Spark 1.3 country list | A and D; Hyperautomation Labs, `5ySUNQJ-wg8`, 06:28; AI Consultive, `wLGEhu5EEzQ`, 00:36 |
| Our usable path | Given Muse is available to this developer only through OpenRouter, the practical surfaces are OpenRouter-compatible OpenCode, Cline, Hermes, `pi`, or a custom OpenAI-compatible orchestrator | Inference from demonstrated harnesses; MaNaMiiStudio, `BDi912pibRU`, 02:17 to 02:35; Agent Workflow Lab, `aqrt3hIsu24`, 00:27; QuartzRouter, `85KA-zOMeX0`, 00:43 |

## Contradictions between videos and what resolves them

| contradiction | resolution |
|---|---|
| Meta's table says 1.3 is a large upgrade, while independent suites show 79 vs 83 and 71.25% vs 76.25% | The launch table measures long-context, repo, and agent benchmarks; independent suites emphasize visual correctness, games, CAD, and final execution. Both can be true. D; Matt Johnston, `6dH5opXkdU0`, 15:09 to 15:33; AICodeKing, `WZDtEAFHj7k`, 05:42 to 07:33. |
| Reports transcribe Terminal-Bench as 86.8, 88.0, 88.4, 88.8, 89.4, or 89.8 | These are inconsistent readings of similar screenshots, sometimes mixing max, high, minimal, or action variants. Use 88.8 only as the most repeated launch-table transcription, not as independently reproduced evidence. D context; Bijan Bowen, `tLlEzZUyGdM`, 00:16 to 00:46; QuartzRouter, `85KA-zOMeX0`, 00:08 to 00:26. |
| MRCR 512K to 1M appears as 98.1, 95.5, 90.1, or 76.1 | This is report/OCR inconsistency. The repeated 98.1 figure is the modal launch-table reading, while no independent run reproduced that benchmark. D context; Onde eu Clico, `50xpDCpfPao`, 02:01; IA Professeur, `mlV3wNToE3g`, 00:22. |
| Reported throughput ranges from 83 to 209 t/s | Provider, route, date, cache state, reasoning effort, and chart methodology differ. Treat throughput as endpoint-specific, not a fixed model property. D; MaNaMiiStudio, `BDi912pibRU`, 00:36 to 02:13; AI Consultive, `wLGEhu5EEzQ`, 03:08. |
| Spark decisively beats Gemini in one five-site test, but Gemini wins another site test and performs better in the content-agent workflow | Prompt contracts and harness capabilities dominate. Gemini's autonomous browser verification helped where inspection mattered; Spark excelled under frozen, implementation-first contracts. D; Marvijo AI Software, `aTGPHeRunWI`, 00:34 to 07:15; WEBdoze, `N4q3EUP61kI`, 04:15 to 11:34; 阿石OMP, `3pFzcIOpZAM`, 03:27 to 05:22. |
| Spark sometimes self-verifies effectively and sometimes skips verification | It verifies reliably when the harness exposes browser/test tools and the prompt explicitly requires checking. Without that contract, it often rushes to output. D; WTF Code, `iqwJI3PMn0A`, 07:23 to 07:52; 阿石OMP, `3pFzcIOpZAM`, 03:27 to 04:25. |
| Free access is widely demonstrated, yet Muse CLI returned a billing error | OpenCode Zen was a promotional third-party free route. Direct Meta or Muse CLI access still required billing and could be account-gated. D; WTF Code, `iqwJI3PMn0A`, 01:52 to 04:40; カレーちゃんのAI道場, `-WCBmotfxS4`, 13:17 to 14:55. |
| Audio worked in a 44-second test despite an explicit degradation warning | Audio can work, but the provider did not guarantee full support. Route important audio through the dedicated video/audio analyst rather than relying on Spark. D; Johanna Hendrix, `qfVFUcLpVYU`, 03:50; Bijan Bowen, `tLlEzZUyGdM`, 01:26. |
| One Contributor listing says $0.02/M cache read while most say $0.002/M | Treat $0.002/M as the repeated displayed tariff and verify OpenRouter's live model metadata before execution. The $0.02 report may be a transcription or provider-listing discrepancy. D; MaNaMiiStudio, `BDi912pibRU`, 00:36 to 00:59; Onde eu Clico, `50xpDCpfPao`, 06:25. |
| Spark's refusal to attempt an unbounded AAA game is described as both a weakness and better calibration | For autonomous orchestration it is a strength, but the controller must be able to answer clarification questions or replace the request with bounded acceptance criteria. D; IA Professeur, `mlV3wNToE3g`, 01:39 to 02:44. |

## Index

Dates are the report's upload date where recoverable, otherwise `unknown`. This table contains all 209 reports and is sorted by the report's hands-on label, then views. Titles have ASCII hyphens substituted for prohibited dash characters.

| views | date | length | channel | title | hands-on | addresses goal | confidence | id |
|---:|---|---:|---|---|---|---|---:|---|
| 68433 | September 2, 2026 | 2169s | Bijan Bowen | Meta Muse Spark 1.3 Is HERE - Is THIS a Real Opus Competitor? | yes | yes | 5 | `tLlEzZUyGdM` |
| 41742 | April 8, 2026 | 2527s | Bijan Bowen | Meta AI Muse Spark Is HERE - Testing Meta’s New Frontier Model! | yes | partial | 4 | `cfxRAdmxjOo` |
| 36941 | August 5, 2026 | 814s | WorldofAI | Muse Spark 1.2 - Meta’s New Frontier Model Is 250x Cheaper Than Fable! (Fully Tested) | yes | partial | 5 | `6J8pE92Biko` |
| 32140 | August 6, 2026 | 2212s | Bijan Bowen | Meta Muse Code Is HERE - Spark 1.2 & Meta’s NEW Coding Agent! | yes | yes | 5 | `Gjw3ok6alYY` |
| 27367 | unknown | 2015s | Bijan Bowen | Meta Muse Spark 1.1 First Test - Is THIS a Frontier Model? | yes | partial | 3 | `XCYYDhG9zKw` |
| 27294 | unknown | 1010s | WorldofAI | Meta Muse Spark 1.1 IS UNDERRATED! Beats Opus 4.8 & Grok 4.5! (Fully Tested) | yes | partial | 4 | `gI5d2czu9JE` |
| 19380 | April 8, 2026 | 819s | WorldofAI | Meta AI Muse Spark IS INCREDIBLE! Powerful Coding & Multimodal Model! (Fully Tested) | yes | partial | 4 | `6_m2SaAl5-0` |
| 17958 | unknown | 630s | AICodeKing | Muse Spark 1.3 & Gemini 3.8 Flash: Gemini has leveled up BIG TIME! | yes | yes | 5 | `WZDtEAFHj7k` |
| 13236 | unknown | 1901s | Bijan Bowen | Meta Muse Spark Contemplating - A GPT Pro & Deep Think Competitor? | yes | partial | 5 | `XrlkTpvUXHI` |
| 13040 | September 2, 2026 | 962s | Onde eu Clico | 😮 Muse Spark 1.3 Catches Up to Anthropic for a Fraction of the Cost! Almost Free! | yes | partial | 5 | `50xpDCpfPao` |
| 11200 | unknown | 1215s | まさおAIじっくり解説ch | [Breakthrough Value] A Deep Dive into Meta's "Muse Spark 1.3"! The Highly Anticipated New Model T... | yes | partial | 3 | `TcQiRWIj6hg` |
| 9725 | unknown | 855s | TheAIGRID | Meta Just Changed Everything. Muse Spark Destroys GPT-5.4 & Gemini on Key Benchmarks. | yes | partial | 4 | `mOTzmb1m0Uc` |
| 9301 | September 3, 2026 | 3464s | Vini Lana | GPT-6 Astra vale o hype? Testes vs Fable 5.1, Gemini 3.8 e Muse Spark 1.3 | yes | partial | 5 | `ujH24Pgd4Ao` |
| 8764 | unknown | 423s | AICodeKing | Muse Spark 1.1 (Fully Tested): Okay, it's SO GOOD! | yes | partial | 5 | `ZtiDMXiDARs` |
| 8492 | April 10, 2026 | 429s | AICodeKing | Muse Spark + Claude Code: This FULLY FREE MODEL is A CRAZY FRONTEND BEAST! | yes | partial | 4 | `vWqNowqpYjo` |
| 8054 | August 5, 2026 | 637s | AICodeKing | Muse Code + Spark 1.2 (Free Tier): Okay, this is ACTUALLY GOOD! | yes | yes | 5 | `E1S-9pLUPw0` |
| 7191 | September 2, 2026 | 660s | Fahd Mirza | Muse Spark 1.3: Going Open Weight Soon, Fully Tested | yes | partial | 5 | `euJl6i8pT3g` |
| 6974 | unknown | 730s | STARTUP HAKK | Muse Spark 1.3 - Meta is cookin! | yes | partial | 4 | `kqvU-NKrP_8` |
| 6092 | unknown | 611s | WTF Code | Muse Spark 1.2 Is FREE - A New Challenger to Claude Opus 4.8? | yes | partial | 5 | `9RVtAn0utcQ` |
| 5826 | unknown | 817s | NiceKate AI | Gemini 3.8 Flash、Muse Spark 1.3 实测：跑得快，做得对吗？ | yes | partial | 5 | `Zyw4mz84_Dw` |
| 5661 | September 2026 | 650s | 阿石OMP | Meta 最新 AI 竟然超越 GPT-5.6？Gemini 3.8 Flash 對決 Meta Muse Spark 1.3！ | yes | partial | 5 | `3pFzcIOpZAM` |
| 5375 | April 8, 2026 | 982s | Fahd Mirza | Muse Spark Tested: Meta's Comeback Model That Rebuilt Everything From Scratch | yes | partial | 5 | `DuieiBVMPyY` |
| 5043 | unknown | 712s | WEBdoze | Gemini 3.8 Flash vs Muse Spark 1.3: Don't Trust the Benchmarks! | yes | partial | 4 | `N4q3EUP61kI` |
| 4905 | unknown | 533s | WTF Code | Muse Spark 1.3 Is FREE - One of the Best AI Coding Models! | yes | partial | 5 | `iqwJI3PMn0A` |
| 4847 | August 5, 2026 | 853s | Your AI Guy | Muse Spark 1.2 - Meta's New Frontier Model Is 260x Cheaper Than Fable! | yes | partial | 5 | `LViTqChz-kU` |
| 4811 | unknown | 542s | AI Coding Daily | I Tested NEW Muse Spark 1.2 by Meta on 15 Coding Prompts | yes | partial | 5 | `c-V4MrY03Mc` |
| 4742 | July 9, 2026 | 518s | Fahd Mirza | Meta Is Back: First Thoughts on Muse Spark 1.1 | yes | partial | 4 | `8jjrDXVL31w` |
| 4607 | August 6, 2026 | 536s | Julian Goldie SEO | I Tested Meta's Muse Spark 1.2 So You Don't Have to… | yes | partial | 5 | `eBY_O1Gq6hI` |
| 4604 | July 11, 2026 | 748s | Infotech4you - مروي سليمان | Meta is back with a vengeance! Muse Spark 1.1: A completely different model! | yes | partial | 5 | `dOVtLDkAhfQ` |
| 4066 | unknown | 1547s | YJ X AI | Meta Muse Spark vs Gemini 3.1 Pro / Who will Win? | yes | partial | 5 | `fhWN7gsg1eA` |
| 4014 | unknown | 980s | Matt Johnston / AI Engineer | Muse Spark 1.3 Is Too Cheap For A Reason | yes | partial | 5 | `6dH5opXkdU0` |
| 3680 | unknown | 1088s | Fahd Mirza | Muse Code with Muse Spark 1.2: Fan-Out Coding Agent with Vision | yes | partial | 5 | `m568RMyJKg0` |
| 3317 | September 2, 2026 | 720s | STARTUP HAKK | Muse Spark 1.3 - Meta is cookin! | yes | partial | 4 | `yuBJ4Scm_38` |
| 3301 | August 22, 2026 | 489s | Codedigipt | Muse Spark 1.2 - Meta’s NEW AI Coding Model That Challenges Opus 4.8 & GPT 5.6 | yes | partial | 5 | `-E1CSm1Nh5M` |
| 2911 | unknown | 402s | Red Stapler | Meta AI Muse Spark Coding Review (It's BAD) | yes | partial | 5 | `oD5xWAwaupM` |
| 2638 | unknown | 786s | 阿石OMP | 【實測多模態模型】 Qwen 3.8、Gemini 3.7、Muse Spark 1.2 模型能力與成本！ | yes | partial | 3 | `gZZtLKGXXE4` |
| 2341 | April 9, 2026 | 1550s | Discover AI | NEW Meta's MUSE-SPARK vs SONNET 4.6 on Reasoning | yes | partial | 4 | `SeMe473ytDg` |
| 2282 | 20260903 | 929s | AI Consultive | Meta sort un modèle top 3 mondial, gratuitement (Muse Spark 1.3) | yes | partial | 5 | `wLGEhu5EEzQ` |
| 2237 | 2026-07-10 | 569s | Ray Codes | Meta Muse Spark 1.1 Just Dropped: $0 Autonomous Coding Agent! | yes | partial | 4 | `ymd94d1d1Kk` |
| 2107 | September 2, 2026 | 550s | IA Professeur | Muse Spark 1.3: Meta AI’s New Free AI Model to Compete with Claude Opus 5 & ChatGPT by OpenAI | yes | partial | 5 | `mlV3wNToE3g` |
| 2058 | 2026-09-05 | 296s | QuartzRouter | New Muse Spark 1.3 destroys Spark 1.2 | yes | partial | 5 | `85KA-zOMeX0` |
| 1982 | April 9, 2026 | 484s | Codedigipt | Muse Spark : Meta’s NEW AI Just Went Next Level | yes | partial | 4 | `2BgQ01xuE3c` |
| 1791 | September 2, 2026 | 493s | Hyperautomation Labs | BREAKING: Meta Muse Spark 1.3 Beats Opus 5 at Coding, 4x Cheaper | yes | partial | 3 | `5ySUNQJ-wg8` |
| 1479 | April 8, 2026 | 403s | Data Science in your pocket | How to use Meta Muse Spark for free ? | yes | partial | 4 | `nFT00lKKx_I` |
| 1181 | unknown | 346s | Marc illy A.I Master | New Meta Muse Spark AI Deep Dive: How to Use It for High-End Graphics (FULL GUIDE) | yes | partial | 3 | `mBHsksjJdqA` |
| 1152 | April 8, 2026 | 928s | Kenil Barochia / AI & TECH | Meta's New Muse Spark AI Model Just Changed Everything : (FIRST LOOK + 10 Tests) | yes | partial | 4 | `i9ITO6E-D-k` |
| 1098 | September 3, 2026 | 491s | Codedigipt | Meta Muse Spark 1.3 - The New AI Coding & Reasoning Beast | yes | partial | 4 | `dYSy5H0YQo4` |
| 1049 | July 7, 2026 | 560s | ZoCo Marketing | Meta's Muse AI Is Free... Is It Actually Good? | yes | partial | 4 | `xjnMZIFh1-o` |
| 982 | 20260821 | 515s | Coding Shiksha | How to Use Meta Muse Spark 1.2 FREE Unlimited Model on OpenCode AI Agent in VSCode | yes | partial | 4 | `MVS9cO366og` |
| 967 | unknown | 1324s | The Feature Crew | Meta FINALLY released a new model, is it any good? (muse spark) | yes | partial | 5 | `xbX9Ev3KkJg` |
| 891 | unknown | 889s | Siamese Cat Dev | I Tested Meta’s Muse Spark 1.3 Against Claude Fable 5.1 and Here’s What Happened | yes | partial | 5 | `41dHckkZtV0` |
| 819 | unknown | 463s | Marvijo AI Software | Gemini 3.8 Flash vs Muse Spark 1.3: Five Websites, Same Brief | yes | partial | 5 | `aTGPHeRunWI` |
| 811 | 20260902 | 1181s | Johanna Hendrix | Meta Muse Spark 1.3 Review: A Huge Leap Forward | yes | partial | 5 | `qfVFUcLpVYU` |
| 616 | unknown | 328s | Brennan McDonald | I spent $17 testing Muse Spark 1.2 and Muse Code | yes | partial | 5 | `5Wud09Pm4PQ` |
| 586 | August 21, 2026 | 342s | QuartzRouter | I forced the new Muse Spark 1.2 LLM to make Minecraft | yes | partial | 5 | `GdQm4kUdnTU` |
| 523 | unknown | 895s | WEBdoze | From AI Slop to Pro Design: MuseSpark 1.3 & Gemini 3.8 Flash | yes | partial | 4 | `jSmGKrhYkmc` |
| 516 | August 5, 2026 | 353s | VK AI | 🔥 Get Muse Spark 1.2 API Key FREE! | yes | partial | 5 | `bzCzR2pcfgE` |
| 461 | September 2, 2026 | 920s | IA Latinoamérica | Does Muse Spark 1.3 CRUSH Gemini 3.8? | yes | yes | 5 | `xpvOpAFLRbA` |
| 381 | April 9, 2026 | 280s | Code Bear | Meta's NEW Llama Replacement - Muse Spark (Tested) | yes | partial | 4 | `aBiX279NRwM` |
| 376 | April 8, 2026 | 467s | SkillCurb | Meta's New AI Model Muse Spark Just Changed Everything (Fully Tested) | yes | partial | 4 | `RVRwgKfV1zE` |
| 364 | unknown | 578s | Arindam Majumder | Muse Code vs. Claude Code: Which AI Agent Should You Use? | yes | partial | 5 | `57tYcXL1hSA` |
| 359 | September 3, 2026 | 4958s | カレーちゃんのAI道場 | MetaがMuse Spark1.3をリリース、Google「Gemini 3.8 Flash」公開。3週間で3.7→3.8、Fable5.1をみよう、今日のAIニュース | yes | partial | 5 | `-WCBmotfxS4` |
| 343 | unknown | 414s | Pat Simmons | MuseSpark + Claude Code = The Easiest Way to Build a Website | yes | partial | 5 | `KVpEoIFYRiU` |
| 329 | April 9, 2026 | 971s | Intelligence Frontier | Biggest Meta AI Launch in 2026: Muse Spark, Multi-Agent Mode & Personal Superintelligence | yes | partial | 4 | `bJEaiq2jXsg` |
| 322 | August 8, 2026 | 198s | Julian Goldie Agency | Meta Muse Spark 1.2 put to the test against GPT 5.6 and Qwen 3.8 | yes | partial | 4 | `kI7pzca2fQk` |
| 318 | unknown | 632s | Ramanpal Singh | Meta's Muse Code Test: 5 Projects, Too Many Bugs | yes | partial | 5 | `Ja42Shhjr7w` |
| 297 | August 2026 | 257s | GPT-Graham | GPT-6, Meta Muse & DeepSeek V4 / State Of Intelligence #1 | yes | partial | 4 | `yMMGwWQ3C00` |
| 284 | April 9, 2026 | 333s | SwiftUI Animation & Agentic Coding | Xcode 27: How To Use Muse Spark 1.2 for Agentic SwiftUI Coding | yes | partial | 5 | `2ttK5Wn6in0` |
| 269 | unknown | 280s | Coding Lifestyle 4u | Meta Muse Spark 1.3 FREE in VS Code 🔥 OpenCode AI Coding Agent Setup | yes | partial | 5 | `g4Xp4nnRFY4` |
| 266 | unknown | 449s | Intelligence Frontier | Muse Spark Is Already Building Real Apps & Games in One Shot - Community Highlights | yes | partial | 4 | `mAWe_nz4V6k` |
| 231 | September 3, 2026 | 503s | Mustafa Sayed | تجربة موديل Muse Spark 1.3 المجاني في OpenCode مع سكيلز Superpowers | yes | partial | 5 | `etLSxX9ou-s` |
| 216 | unknown | 1161s | Mayor Dev | Test hasil UI dari Model GRATISAN (Muse Spark 1.2 Contributor) | yes | partial | 5 | `BASOuoRjHDo` |
| 213 | unknown | 381s | Dracon Dev & AI | Gemini 3.8 Flash, GPT-6 Astra, Muse Spark 1.3, Omen Alpha Review | yes | partial | 3 | `HVkVcNtTBvc` |
| 159 | April 8, 2026 | 999s | Where Do I Click | ✨Introducing Muse Spark: Meta's New Multimodal AI Model with Built-In Agents | yes | partial | 5 | `4LXmmvEY7-A` |
| 156 | unknown | 315s | Agent Workflow Lab | Six Green Test Runs, Two Different Games: Testing Meta's Muse Spark 1.2 | yes | partial | 5 | `18AXNfAeP78` |
| 155 | unknown | 908s | Matt Johnston / AI Engineer | I Found Meta's Secret Weapon (Muse Spark 1.2) | yes | partial | 5 | `HeI1xIKxibY` |
| 149 | unknown | 312s | Alex Volkov from ThursdAI | Meta AI new Muse spark updates and conversation mode - hands on stress test | yes | partial | 4 | `dlyHElB-4OI` |
| 100 | September 4, 2026 | 389s | Cloud Developer | Meta Muse Spark 1.3 FREE Test 🔥 GPT-6 Astra FREE Promo / No Subscription! | yes | partial | 3 | `e_--oV2QUiY` |
| 98 | unknown | 728s | Sai Santosh Kumar | Meta Muse Spark 1.1 Vs Grok 4.5 / Surprised!! | yes | partial | 5 | `zMqb8-nJG_8` |
| 73 | unknown | 299s | Agent Workflow Lab | Muse Spark 1.3 Built 3 Browser Games - Human Playtesting Changed the Verdict | yes | partial | 5 | `aqrt3hIsu24` |
| 42 | 2026-09-03 | 219s | David Yin 不确定体验局 | Meta 模型Muse Spark 1.3 这么便宜图什么？ | yes | partial | 5 | `P5NAmw1mDWg` |
| 26 | April 9, 2026 | 862s | Jesus Vibe / AI Software Engineer | "¡IMPOSIBLE!" META Muse Spark 1.3 recrea GALAXIAN en 1 SOLO PROMPT | yes | partial | 4 | `M_CYl8oz5Yc` |
| 25 | unknown | 211s | TonkaToyXL | Qwen 3.8 Max vs Gemini 3.8 Flash vs Muse Spark 1.3 / One-Shot Cabin Battle | yes | partial | 5 | `l3OW5b0172Q` |
| 20 | unknown | 4269s | realrlin LIVE | Muse Spark 1.3 Contributor Max Plays Slay the Spire - 10 A20 Heart Runs (No Memory) | yes | no | 5 | `ayXf66M2JfU` |
| 14 | unknown | 5356s | realrlin LIVE | Muse Spark 1.3 Contributor Max Plays Slay the Spire - 10 A20 Heart Runs (Memory) | yes | no | 5 | `f_WLsGx5hrc` |
| 1 | September 4, 2026 | 792s | MaNaMiiStudio | ตัวตึงตัวใหม่! Meta Muse-Spark 1.3 พรอมต์เดียวบิลด์ห้อง 3D ฉ่ำๆ | yes | partial | 5 | `BDi912pibRU` |
| 0 | unknown | 792s | MaNaMiiStudioGB | Meta Muse-Spark 1.3 is ACTUALLY COOKING?! 1-Prompt 3D Web App in 22 Mins | yes | partial | 5 | `4g51N4YXQMo` |
| 26777 | unknown | 248s | CNBC Television | Meta unveils Muse Spark AI model to rival top chatbots | no | partial | 5 | `7ivZzV3H3E0` |
| 21112 | April 2026 | 646s | Nathan Visser | Meta Muse Spark Explained: What It Means For Your Business | no | partial | 3 | `R9m2erfb79I` |
| 16397 | September 2, 2026 | 1373s | Inteligência Mil Grau | NEW Gemini 3.8 Released Outperforms Previous Version and Meta's Muse Spark 1.3 Launches | no | partial | 4 | `uLgVMS5NZMg` |
| 14753 | July 9, 2026 | 732s | Eli the Computer Guy | Meta Releases AI Coding Model Muse Spark 1.1 - Zuckerberg is Lost | no | partial | 5 | `EyU3qOolddc` |
| 14651 | September 2, 2026 | 631s | ByteForward | Google Drops Gemini 3.8 Flash.. then Meta Launches Muse Spark 1.3!? | no | partial | 4 | `DFV9qvzS624` |
| 11258 | unknown | 684s | RepoChad | Muse Spark 1.3 is HERE: Open Weights Are Coming? | no | partial | 5 | `pIR8crZIH1k` |
| 11235 | unknown | 211s | AIM Network | Meta's $14 Billion Bet on Alexandr Wang Just Paid Off - Muse Spark Is Here | no | partial | 4 | `sfAbxNsxTJc` |
| 11166 | September 4, 2026 | 6755s | Fernanda Kipper | Bora tomar café? #60 / GPT 6 Astra x Claude Fable 5.1 x Meta Muse spark 1.3 | no | partial | 4 | `k8a6qDHx5sw` |
| 8046 | September 3, 2026 | 1694s | Le Bretzel | Actus IA : GPT-6 ASTRA est là et bouleverse TOUT ! (+ Fable 5.1 Gemini, Muse Spark…) | no | partial | 4 | `o3XAR2alIsI` |
| 7826 | unknown | 2342s | IBM Technology | Thinking Machines Lab drops Inkling & Meta’s Muse Spark 1.1 | no | partial | 3 | `8rGYGFmytQs` |
| 5972 | April 8, 2026 | 299s | DailyNoons | Zuckerberg Just Ended the Open Source Era: Muse Spark is Here. | no | partial | 4 | `yp7dN_5xjAE` |
| 1685 | 20260903 | 348s | Softreviewed | How to Use Muse Spark 1.3 for FREE 🤯 - Stop Paying for Codex & Claude Code! | no | partial | 4 | `XEAAUEw4RR4` |
| 1510 | April 9, 2026 | 231s | Tech Bard | Meta Just Dropped Muse Spark! Zuck's $BILLIONS AI Bet Finally Has a Product | no | partial | 4 | `bFaeT0gaFUc` |
| 1463 | April 8, 2026 | 749s | Superbash (BoxminingAI) | Muse Spark: Meta Unleashes NEW AI Model (Are they back?) | no | partial | 4 | `i9ZvQ8k0ZoU` |
| 1424 | unknown | 281s | Dario Serventi | Ghost - Mary on a cross / guitar cover with Positive Grid SPARK AMP | no | no | 5 | `Lba8ZI-MrF8` |
| 1413 | unknown | 302s | TechWealth Hub | Muse Spark: Meta's First Superintelligence Labs Model - Benchmarks and Capabilities | no | partial | 3 | `UcOg9X-5NIw` |
| 1406 | unknown | 242s | Avi Elkharrat | Spark40 Quick Tip: EQ your Streaming Music to Balance Bass Heaviness | no | no | 5 | `G3cBk-Ytk0o` |
| 1359 | unknown | 246s | Bruno Virgilio | God Forbid - Antihero (With drums by Wilfred Ho) Positive Grid Spark | no | no | 5 | `DUrhT1m3rVQ` |
| 1307 | July 9, 2026 | 237s | Data Science in your pocket | Meta Muse Spark 1.1 : Beats GPT 5.5, Claude Opus 4.8 | no | partial | 3 | `tu4hsnEfWP0` |
| 1267 | September 3, 2026 | 491s | AI WITH Rithesh | Meta Muse Spark 1.3 BEATS Gemini 3.8 Flash? 🔥 Benchmarks, Demos & Price | no | partial | 3 | `nvjenm5WbxA` |
| 1219 | 2026-04-10 | 440s | Business Data Science with Delali | Is Meta back to the AI race with Muse Spark release? | no | partial | 4 | `XQ3hKsUFmi8` |
| 1123 | unknown | 440s | BetterWay | Why Meta’s New AI Muse Spark Is Putting Them Back In The AI Race | no | partial | 4 | `NE4Ay_vNVUg` |
| 1114 | August 6, 2026 | 538s | AI Stack Engineer | Muse Code: Meta's Claude Code Competitor Powered by Muse Spark 1.2 | no | partial | 4 | `IF_sJX4jFtY` |
| 1046 | April 8, 2026 | 398s | Amrit Talks | Muse Spark AI / Is It The Smartest or The Scariest AI Ever ? | no | partial | 4 | `7oA8IvYVwPc` |
| 992 | 20260430 | 618s | Rogério Campos | Meta Muse Spark: The Multimodal AI That Lives in Your Glasses | no | no | 5 | `A6AakMgO1w8` |
| 959 | 20260902 | 193s | DistroTester | Meta rolls out Muse Spark 1.3 with stronger coding and agentic performance | no | partial | 3 | `owa_BBxjNwU` |
| 923 | unknown | 2109s | The Information | Meta Debuts Muse Spark 1.1, Blue Origin to Raise $10B, Cursor Develops AI Agent | no | partial | 4 | `XEWLb_9rINA` |
| 889 | September 3, 2026 | 850s | SYNVUM | Latest AI - September 3, 2026 - Gemini 3.8, Muse Spark & New AI Agents | no | partial | 4 | `FRkkZtJVPo8` |
| 870 | 2026-08-11 | 340s | 橘鸦Juya | Meta Releases Muse Glimmer and Teases Open Weights for Muse Spark 1.2 | no | partial | 3 | `CjVC_cZe-M4` |
| 837 | August 15, 2026 | 206s | Learn With Trevor | I Tested Meta s Muse Spark 1.2 So You Don't Have to | no | partial | 3 | `sVHC87IS0Ew` |
| 649 | September 2, 2026 | 995s | David Duthie | Meta Releases Muse Spark 1.3 - Frontier AI at a SHOCKING Price! | no | partial | 3 | `VUm2ZNXom9A` |
| 631 | unknown | 237s | Data Science in your pocket | Meta Muse Spark 1.3 | no | partial | 4 | `KTYydWGxyYA` |
| 600 | July 9, 2026 | 183s | Jigs Dev | Muse Spark 1.1: How to Use & Overview | no | partial | 4 | `tpo5NPShtjs` |
| 569 | unknown | 391s | Neural News Network | Meta Just Replaced Your Assistant (Muse Spark) | no | partial | 4 | `GOc_vheNeyc` |
| 490 | unknown | 438s | Ai Boffins | Zuckerberg Spent Billions In Silence - Meta AI Muse Spark | no | partial | 4 | `ATO3lW5JZyU` |
| 456 | unknown | 351s | TechWealth Hub | Meta Muse Spark 1.1: API Preview, Coding Agents, and the Catch | no | partial | 4 | `oO7e5eO2VF8` |
| 358 | August 6, 2026 | 769s | Sarthaksavvy | Don’t Use Meta’s MUSE Code Before Watching This | no | partial | 4 | `ZHXfecErlDw` |
| 346 | unknown | 602s | AGENT MODE | DeepSeek-V4-Pro vs Meta Muse Spark 1.2 - Who Wins? | no | partial | 4 | `LFndqWEgH14` |
| 342 | unknown | 515s | AI Frontline | Meta Just Dropped Muse Spark Meta’s Bold Move Into Superintelligence | no | partial | 2 | `cORzFUsYrhc` |
| 340 | July 2026 | 507s | The AI Layers | Meta's Biggest AI Launch Yet / Muse Spark 1.1 Explained | no | partial | 4 | `yQpFUVqYKFA` |
| 339 | unknown | 535s | Mahan Javaheri | Muse Spark 1.1 Changes Everything... | no | partial | 4 | `b_DXD3tf7rk` |
| 312 | unknown | 570s | kemalcodes | Meta Muse Code vs Claude Code: The Catch Nobody Mentions | no | partial | 5 | `6K2X8k-fPr0` |
| 288 | April 8, 2026 | 543s | Prism Labs | Meta Muse Spark: The Closed Model Nobody Expected | no | partial | 4 | `LDMjQ3I2Nmw` |
| 281 | August 5, 2026 | 342s | Data Science in your pocket | Meta Muse Code and Muse Spark 1.2 | no | partial | 4 | `ncrI3iTjdWQ` |
| 277 | July 9, 2026 | 301s | Webronaq | Meta Muse Spark 1.1 Explained: Agentic AI Models | no | partial | 3 | `AuLSVG4WTsE` |
| 269 | unknown | 624s | The AI Brief | Meta Muse Spark 1.1 Just Dropped - I Tested It Against Opus & Grok | no | partial | 3 | `D-_bImnD8RQ` |
| 259 | September 4 | 1092s | Yersham | Тестирование Meta Muse Spark 1.3: бенчмарки против реальности | no | partial | 4 | `1WVbF2wp9k4` |
| 252 | unknown | 463s | Guides & Newsletter | Muse Spark 1.1: Meta’s New Agentic AI Model Explained | no | partial | 3 | `wmxkljsEvBU` |
| 245 | August 5, 2026 | 424s | AI WITH Rithesh | Muse Code and Muse Spark 1.2 - All you need to know in less than 8 minutes | no | partial | 5 | `by3NHbVRnrw` |
| 231 | April 10, 2026 | 777s | Jaeden Schafer | Meta's AI Strategy and Muse Spark Model Insights | no | partial | 4 | `n25u8-cXt7s` |
| 224 | unknown | 277s | SH AI Academy | Muse Spark: As AI Coding Assistant Every Developer Needs! | no | partial | 2 | `h13S4XAqabY` |
| 219 | unknown | 1280s | Binary Verse AI | Muse Spark 1.2 Benchmarks: Is Meta’s Muse Code a Real Claude Code and Codex Challenger | no | partial | 4 | `00rDiUUbdLA` |
| 215 | September 3, 2026 | 5823s | Alex Volkov from ThursdAI | Sep 3, 2026 - Fable 5.1, Muse Spark 1.3 catches Fable 5, an uncensored GLM-5.3 | no | partial | 5 | `Cfg0N_wJfb0` |
| 204 | 20260806 | 184s | 120X GROWTH | Meta Muse Spark 1.2 is HERE! Better Than Claude Opus 5, GPT-5.6 & Grok 4.5? | no | partial | 4 | `LBTtGtixx44` |
| 198 | July 9, 2026 | 1447s | Radio | ChatGPT 5.6, Grok 4.5 and Meta Muse Spark 1.1 Just Dropped | no | partial | 4 | `iyiBDHBKN18` |
| 196 | unknown | 531s | AI Unfiltered with Thorsten Meyer | Don't Use Meta Muse Spark 1.2 Until You See This | no | partial | 3 | `UppZUQ4qV2Q` |
| 188 | unknown | 528s | AI Observer | Muse Spark Just Started Meta’s Secret AI Comeback | no | partial | 3 | `-D-8QHDCw6E` |
| 186 | unknown | 330s | DEEPTECH AI LABS | Meta Muse Code + Spark 1.2: This Coding Agent Has One Big Catch | no | partial | 4 | `qA2URxRO_VE` |
| 182 | unknown | 246s | runtime tech | Meta's Muse Code wants to replace Claude Code for 10 cents | no | partial | 4 | `qqIrhtFYz_g` |
| 150 | unknown | 237s | NeuroAI by Loveleen | Muse Spark: The AI Nobody Fully Explained Yet | no | partial | 2 | `nEk-pL9fskA` |
| 149 | unknown | 284s | AI PRIME HUBB | Meta's Muse Spark 1.1 REVEALED - AI Industry Shaken | no | partial | 3 | `4R9H81xGzyQ` |
| 144 | unknown | 435s | Uplatz | Meta’s Coding Push: Muse Spark 1.2 and Muse Code Take on Agentic Software Development | no | partial | 2 | `mVSVR056hCo` |
| 138 | 2026-09-03 | 367s | AI 风向标 | 卷疯了！谷歌突袭Gemini 3.8 Flash与Cyber，Meta发布Muse Spark 1.3 | no | partial | 3 | `xja9Nr0tDJE` |
| 126 | unknown | 192s | あきらパパのAI活用学習部屋 | [Muse Spark 1.3] What's Changed? A 3-Minute Guide | no | partial | 4 | `vyu-tEvmduk` |
| 123 | September 2, 2026 | 424s | The Solo Engineer | Muse Spark 1.3 - Meta Just Upgraded Its Agentic model | no | partial | 4 | `_H4toUzkkKk` |
| 94 | 2026-09-02 | 370s | AI 风向标 | Anthropic发布Fable 5.1与Mythos 5.1登顶，Meta超级应用定名Muse | no | partial | 4 | `yotsNVeX-Qk` |
| 91 | unknown | 459s | MuniPrakash Ganji | ChatGPT vs Claude vs Muse Spark ⚡ Which AI Wins in 2026? | no | partial | 2 | `atAEyv4dxZI` |
| 85 | August 2026 | 279s | ByteForward | Muse Spark 1.2: Meta’s New AI Coder Just Dropped | no | partial | 4 | `OyziexwHg_I` |
| 84 | unknown | 377s | The Solo Engineer | Meta's $0.10 Muse AI Agent Changes Everything 🤯 | no | partial | 4 | `4dSX-K6YwT4` |
| 83 | unknown | 366s | AINexLayer | Meta’s Radical Reset: Inside the Muse Spark AI 🚀 | no | partial | 3 | `x29oSiLb6YA` |
| 79 | July 2026 | 313s | Product Teardowns | Why Meta Is Locking Its AI Behind A Paywall: The Muse Spark 1.1 Secret | no | partial | 3 | `xKoz9cmIjmg` |
| 79 | unknown | 226s | TechWealth Hub | Muse Spark 1.2 Ties GPT-5.6 Sol on GameDevBench | no | partial | 4 | `qP1Vd7-2vvs` |
| 77 | unknown | 360s | ApexAPI | Muse Spark 1.1 Full Breakdown The Model That Repairs Its Own Code | no | partial | 4 | `AnwXOsroQmI` |
| 73 | unknown | 347s | Nemanja Divjak / Automate Like Crazy | Meta's New Model Fixes Its Own Bugs Full Muse Spark 1 1 Demos | no | partial | 4 | `9457ISm8Dpg` |
| 73 | unknown | 350s | Refreshing AI Latest | Meta’s New Muse Spark: The Path to Personal Superintelligence? | no | partial | 5 | `3RSA9CRS0xU` |
| 70 | July 2026 | 372s | AI.Preneur | Grok 4.5 & Meta Muse Spark vs Claude Opus 4.8: Opus-Class or Hype? | no | partial | 3 | `0Wh8u-CqjFo` |
| 67 | unknown | 282s | 智用AI | Does Muse Spark 1.3 Really Save 25% Tokens? The Key Is the Mode | no | partial | 4 | `MOtpWR2zfGs` |
| 64 | August 5, 2026 | 596s | Intelligence | Meta's Muse Code: the Cheap Tier Trains On Your Code | no | partial | 3 | `0huMQ_B-DuM` |
| 64 | unknown | 210s | Core Infotech | Meta Muse Code & Muse Spark Course - Build AI Agents, APIs, and Full-Stack Apps | no | no | 1 | `ztEIJR18ywk` |
| 63 | unknown | 362s | aiunlocked | META MUSE SPARK: Meta’s Most Powerful AI Yet | no | partial | 2 | `nzPEoZZz_9U` |
| 62 | July 2026 | 326s | Sketched Truths | Muse Spark 1.1 BEATS Claude Opus on Benchmarks - But There's a Catch | no | partial | 4 | `VedXW4km9Yg` |
| 60 | September 2, 2026 | 411s | Soham Ghugare | Muse Spark 1.3 Is the New #1 Coding AI | no | partial | 4 | `Yni-KwM3gy4` |
| 59 | unknown | 245s | Guardian Owl Digital | Meta Muse Spark 1.1: Agentic Coding A.I. at Lower Usage Costs | no | partial | 4 | `Z_GZkmCsExM` |
| 59 | unknown | 650s | Stewart Vickers AI | Muse Code + Muse Spark 1.2: your $200 Claude Code seat is optional | no | partial | 4 | `ZTbyvwnOb-0` |
| 58 | September 2, 2026 | 208s | Standarity | Meta's Muse Spark 1.3: The Model That Asks Before It Acts, Highlighted | no | partial | 4 | `4FPKhryHKiQ` |
| 55 | August 2026 | 569s | Stewart Vickers AI | Muse Spark 1.2 is $0.10/M - Cursor seats just got exposed | no | partial | 4 | `sJ91CArlAxk` |
| 53 | unknown | 193s | Learn With Trevor | Meta Muse Spark 1.1 Beats GPT 5.5 and Claude Opus 4.8 | no | partial | 2 | `ZJwPYwsRQnc` |
| 51 | unknown | 326s | AI News | Meta's Muse Code Undercuts Claude Code by 60%-But It Defaults Using Your Code as Training Data | no | partial | 4 | `xvVKetpkSzc` |
| 46 | September 4, 2026 | 456s | AI 风向标 | GPT-6 Astra刷新SOTA！Muse Spark 1.3回馈数据省90% | no | partial | 3 | `6Zj18i8brEU` |
| 45 | unknown | 703s | AI tech | Muse Spark 1.2: Metas 1M-Token Coding Model Co-Trained With Its Own Agent | no | partial | 3 | `g1wXyiVmyeg` |
| 42 | 2026-04-10 | 405s | Blunt AI - Technology through Data | Meta’s AI Comeback? Muse Spark Explained | no | partial | 4 | `ni_ucTIEf0I` |
| 40 | 2026-09-04 | 181s | The Last Three Minutes | 今朝の3本 2026.09.04｜GPT-6 Astra公開、Meta Muse Spark 1.3 | no | partial | 4 | `mdfUGqdSIH8` |
| 38 | unknown | 241s | Effloow | Meta Muse Spark Developer Guide 2026: Benchmarks, Modes, API - Deep Dive | no | partial | 3 | `DcMHDoT59cI` |
| 37 | 20260814 | 396s | HSM TECH | Meta Muse Code Explained: Can It Challenge Claude Code? | no | partial | 3 | `JUDQassgLUE` |
| 37 | unknown | 2773s | Future Frontiers AI | Muse Spark 1.2 - Meta's New Frontier Model Is 260x Cheaper Than Fable | no | partial | 3 | `-r00N2rCd8U` |
| 37 | unknown | 470s | Build Signal | Meta's Third Door: Inside Muse Code and the Muse Spark 1.2 Gamble | no | partial | 3 | `Ra8O_U_OT4s` |
| 34 | unknown | 232s | Isla Hammond | Muse Spark Coding Copilot: Local Setup, Real Tasks, Zero Subscription | no | partial | 2 | `H9eVKEpWP1w` |
| 31 | unknown | 467s | Jengo | Meta and the Dawn of Muse Spark Superintelligence | no | partial | 2 | `HuGnJcC6uog` |
| 30 | unknown | 520s | Nebula | Meta Muse Spark 1.3: Real-World Benchmarks, Architecture, and Costs | no | partial | 4 | `W_i0lG3_fMc` |
| 29 | 2026-09-03 | 497s | The Cef Experience | GPT6 Astra, Fable 5.1 and Muse Spark 1.3 in one week.. | no | partial | 4 | `QmEh1jpzrvo` |
| 27 | September 4, 2026 | 261s | AI with Aayush | 4 AI Launches in 3 Days / GPT-6 Astra vs. Fable 5.1 vs. Gemini 3.8 vs. Muse Spark | no | partial | 5 | `57ieeF-qhjg` |
| 26 | unknown | 1844s | Parzival of Algorithmic Progress | Grok 4.5 and Muse Spark enter the frontier? AI-2040 decel exposed! | no | no | 2 | `tM2VXb2a6qc` |
| 25 | unknown | 411s | AI REPORTER | Muse Spark 1.2 - Meta's New Frontier Model Is 250x Cheaper Than Fable! | no | partial | 3 | `FEzFiQZCYMY` |
| 25 | unknown | 899s | AI Brief | EP 618 : Meta Muse Spark 1.3 & Google Gemini 3.8 Flash | no | partial | 4 | `SZDiPy3OQl4` |
| 21 | unknown | 902s | AIかわら版【AIニュースと解説】 | 【解説】Muse Spark 1.3の強みと注意点：コーディングAIの導入判断 | no | partial | 4 | `J80lAgWSbBc` |
| 19 | unknown | 778s | AI Fire | EP 347: UCSB Debuts Quantum Framework & Meta Launches Muse Spark 1.3 | no | partial | 2 | `wKDaoYy072k` |
| 16 | September 3 | 457s | XPulse AI | Gemini 3.7 Flash Drops, Meta’s Muse Spark 1.3, Anthropic Pauses Agents | no | partial | 3 | `7ovGlBCb50A` |
| 15 | unknown | 373s | plain. | Muse Spark 1.3 explained in 7 minutes | no | partial | 4 | `dDn1GHND9cg` |
| 12 | unknown | 454s | AGI降临派社区 | 【AI最前沿128】Meta 发布 Muse Spark 1.3 | no | partial | 3 | `e3Mt920oU1A` |
| 11 | 20260728 | 447s | Bryan Software | GLM 5.2 vs Muse Spark 1.1: Which Is Better? | no | partial | 4 | `p5wokfDB1Uk` |
| 10 | unknown | 1045s | ComplexClearly | Muse Spark 1.3 Review: Did Meta Finally Catch the Frontier? | no | partial | 5 | `jK6LITKH7JA` |
| 10 | unknown | 301s | ai_pulse | Meta Muse Spark 1.1: The REAL Agentic AI Game Changer | no | partial | 2 | `4iMH3Ng-3Dg` |
| 9 | unknown | 331s | Dan Mowinski | Inside Meta’s $135B AI Strategy (Muse Spark Explained) | no | partial | 2 | `P08VCqSSQxY` |
| 7 | unknown | 210s | Computalis | Muse Code and Muse Spark 1.2: What Changes When the Model and Harness Are Co-Designed? | no | partial | 4 | `Z_UUScnDkVo` |
| 6 | unknown | 1252s | Latent AI | Muse Spark 1.3: Deep Dive Audio Overview | no | partial | 4 | `CfFKSNz4CO8` |
| 6 | unknown | 483s | Latent AI | Muse Spark 1.3: Meta's 1M-Token Agent, Audited | no | partial | 3 | `LCyPeqTUkYA` |
| 6 | unknown | 715s | Krittin Kalra | Did Meta Game the Muse Spark Benchmarks? Here’s the Truth | no | partial | 4 | `Wwnj2Umsn68` |
| 5 | unknown | 1875s | Josh Snider | Glasshouse in February - Self-Expression Album by Muse Spark 1.3 | no | no | 5 | `3aJ74dAUdT0` |
| 3 | unknown | 392s | easyvibecoding | Meta 發布 Muse Spark 1.3，內部比較少用約 25% tokens | no | partial | 5 | `slmBwQiiGng` |
| 0 | 20260904 | 1234s | Künstlich Intelligent | GPT-6 Astra & AGI / Claude Fable 5.1 / Gemini 3.8 Flash / Muse Spark 1.3 | no | partial | 4 | `dK4vRbpceBs` |
| 0 | unknown | 1235s | Künstlich Intelligent | GPT-6 Astra & AGI / Claude Fable 5.1 / Gemini 3.8 Flash / Muse Spark 1.3 / Nvidia | no | partial | 3 | `XEOQuO0wCNQ` |
| 0 | unknown | 737s | DX Today Podcast | Meta's Muse Spark: Alexandr Wang's $14B Gamble Delivers a Proprietary Frontier Model | no | partial | 3 | `CodAQDLeY9U` |