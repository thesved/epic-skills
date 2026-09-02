# YouTube sweep 2026-09-02: 104 videos on Claude Fable 5.1, Gemini 3.7 Flash analyst, goal-lensed

Goal: how to use Fable 5.1 best in Claude Code and on the API (effort, prompting deltas, cost, /goal, refusals, routing vs Sol/Opus 5/others). Every upload since 2026-08-25 over 3 minutes from 17 search queries (178 candidates, 117 recent, 3 multi-hour streams skipped), watched server-side with the goal embedded and the top 100 comments attached; 11 low-view videos analyzed from auto-captions after the Gemini prepaid balance ran out (mode T in `youtube-index-fable.md`). Evidence grade: D = demonstrated on screen, A = asserted (slide, presenter), C = commenter, T = transcript-derived. Official benchmark tables were on screen in ~80 of the videos and are not repeated here (see lane A/C); presenters misread the effort-cost charts in inconsistent ways, so per-effort dollar figures below come from Artificial Analysis and the CursorBench table where several sources agree.

## Effort

| Finding | Grade | Source |
|---|---|---|
| CursorBench 3.2.0 per effort: low 66.2% $2.90, medium 68.0% $3.53, high 69.4% $4.80, xhigh 72.8% $6.96, max 73.4% $9.64; Fable 5 max 70.5% $17.32; Opus 5 max 70.0% $8.23; Sol max 67.2% $5.69; Grok 4.6 xhigh 70.8% $2.81 | D (table on screen, 5 sources agree) | Dubibubi GI2PDQs7AnY, Melvynx P4IFQYCStA4, Duthie Oa-eH3L4Dcw, Gork 8TpoU2Zqqkw |
| AA index: max 66 at $3.69-3.76 (1.7x Fable 5's output tokens, +20% cost), xhigh 65 at $2.72, high 62 at $1.43; Fable 5 max 62 at $3.14 | D | Better Stack 0lBvjhcRqyU, Berman epogfA_0R4E, Rithesh lFEEPX5qpMA |
| Same 65-line bug review: low $0.17/44 s, medium $0.17/42 s, high $0.21/56 s, max $0.71/166 s (13,950 output tokens) | D | DeepOnAI YHnLcCKq-1c |
| Same planted-bug fix: high $0.46, 5 turns, clean refactor; low $0.39, 6 turns, ugly loop patch | D | Hyperautomation iDUOqaLbcQQ |
| Output tokens per effort on a WebGL FPS build: low 25.6K, medium 43.9K, high 71.5K, xhigh 81.6K, max 200.5K; Opus 5 17.5-28.2K | D | Masao 3OpOwED2sBQ |
| Same site build: low $1.42/27 tool calls, medium $2.14/35, high $2.31/38, max $5.96/92, ultracode $9.13/344 tool calls/58 min | D | Dash vTFBgML4jGg |
| Max spent ~30 of 60 min thinking before code on a web build | D | CodeFactory lC31iWMDV7U |
| Effort tier ranking claim "Boris Cherny defaults to xhigh"; presenter found medium optimal | A | Dubibubi |
| `max` tested for an hour: no task that needed it over xhigh; "poor fuel efficiency" | D | AI Jitan Lab DIPuKCkXa4I |
| claude.ai `Max` tooltip: "can consume 3.5x+ or more usage than High" | D | Cordero vrJZ_OdUm9I, Yilmaz saAuWExdF70 |
| Defaults slide: high in Claude Code, medium in Cowork and claude.ai | D | 20+ videos |

## Cost, cache, subscription

| Finding | Grade | Source |
|---|---|---|
| Four identical site builds Fable 5 vs 5.1 at 97% cache hit: $20.22→$18.24, $14.67→$14.52, $21.64→$12.83, $17.37→$11.18; 5.1 3-6 min faster each | D | Herk FFWtxjvW2ts |
| 5-6 h of continuous builds = 45% of weekly Fable, 23% weekly all-models, 21% of a 5-h window | D | Herk |
| Next.js scaffold: $11.12 API-equivalent, 95% cache hits, 38% of a 5-h window + 7% weekly in two prompts | D | Battisti 6LX8pcSf7rA |
| Session cost anatomy: $3.60 = 58% cache writes, 32% output, 8% cache reads, 1% input | D | AICodeKing UZ2PRAjEPRY |
| Enterprise 573M-token run $1,024: reads 89.8% of tokens / 12.6% of cost, writes 9.4% / 65.8%, output 0.8% / 21.4% | D | AICodeKing (community dashboard) |
| One-liner `claude -p` = $0.62, of which $0.616 the 30.8K-token tool-definition cache write | D | DeepOnAI |
| Rube Goldberg physics sim at high: three 64K output-cap hits, 70 min, zero artifact; Opus 5 succeeded in 38 min | D | Chaen uyRaur94Rwk |
| 20-min xhigh build: $19.58, 32.1M cache reads (98% hit, 1h TTL), 48% of a 5-h window, 24% of weekly Fable | D | AI Unleashed GA71PeeBoVo |
| 2h02m build $225 API-equivalent (98.4% Fable), 52% window / 16% weekly all / 30% weekly Fable | D | van Zyl WjOcStPCbgk |
| 12 subagents + usage credits, no cap: 5-h window in 20 min, $305 in 30 min | D | BuenaVentura hI-cm9svXv8 |
| ultracode Subway FPS: 18-agent 2-hour DESIGN.md phase, 1.8M tokens, $156 credits, 100% of window | D | Bowen 9Z9rPZavjUU |
| Single agent: 14 min = 10% of a Max 5x window (≈2h20m to drain) | D | Melvynx |
| Cursor agent on 5.1 medium looped 16 min / $5.57 on a simple timezone UI; Claude Code did it in 7 min / $3.27 | D | Melvynx |
| Weekly limit change 2026-09-14 (+25% permanent replaces +50% temp, net -17%) | D (@ClaudeDevs post on screen) | JoCoding 911nK2zX9Q0, Universe of AI yYzwMHHCTwA |
| "Cache savings are API only, subscriptions unchanged" | C (many) | Finn, Saraev, Roth comments |
| Claude Code `/context` base overhead 37.1K tokens (system 6.1K, tools 22K, skills 9K) | D | van Zyl |
| Stealth pre-release routing detectable by knowledge-cutoff probe ("when did opus 4.6 release, without tools") | D/C | Universe of AI, AI Revolution pUF5uEQ14QE |

## Behavior deltas seen in the wild

| Finding | Grade | Source |
|---|---|---|
| Scope creep: 16-min design task spawning unrequested font-hunting agents; fix "generate the slides and nothing else" | D | Rogoff -E2emAQOX1E |
| 7 unrequested SEO articles on a SaaS /goal build | D | Income Stream Surfers lq0GGz5uvS8 |
| Fifth-Avenue flythrough: rendered a 15-block city instead of the corridor | D | Johnston PHfRIvc-yT0 |
| Skipped an explicit "pause for asset approval" gate | D | AI Unleashed |
| Under a 7-min cap: Fable 5 shipped a playable game, 5.1 built modules and no entry point; unattended 5.1 needed 12 min to be playable, 21 min to finish with 13/13 tests | D | Agent Workflow Lab HqbCj-7d5Uo |
| Chose a cheaper "chibi" low-poly style and admitted it when questioned | D | The Neuron 9F_uP0_bTYo |
| Self-refusal loop: writes unsafe Win32 Rust, then refuses to review the same code | A | AICodeKing |
| Protein-binding prompt refused, then accepted later unchanged | D | CodeFactory |
| Asking 5.1 about its own release triggers refusal + silent Opus fallback | D | Roth GdArAq7WMSM |
| Commenters: fewer forced Opus fallbacks than Fable 5; medical still blocked; "hi" triggers fallback (pre-release Fable 5 complaint) | C | Inteligência Mil Grau, Herk, WorldofAI |
| Playwright self-test loop caught 5 real bugs unprompted, 48 min, 195K tokens, one prompt | D | Marvijo hhbCLvs7ZP0 |
| Pushed back on "just give it bash" harness design with a structured-tools argument | D | van Zyl |
| Long-context: 40+ step state, says when stuck (Anthropic PM slide) | A | Ai Untapped e7mO1eHVNt8 |
| Hallucination: AA Omniscience rate up vs Fable 5/Opus 5 (attempts 93.4% vs 87.8%) | D | Dubibubi, Rithesh |
| Vision: missed a camouflaged frog, false snake pattern | D | ByteForward XIJYZqJxWAA |
| 3D/physics glitches: z-fighting, floating candles, inverted knees, hull clipping, particle stutter | D | Berman, Stanik YHFZJJhJu0E, Herk 8IyORt-7rOQ, Dom 2xRSGBVMnqw, RemakeBench wHA7uAIkQTc |
| Stylistic tic: dual-color italic hero text | D | Margerie KmILNQqlw9o |

## Routing evidence (who won what)

| Finding | Grade | Source |
|---|---|---|
| Finn suite: Fable 5.1 307 vs Sol 290 / 500; Gauntlet (agentic egg hunt) Fable 100/100 in 143 tool calls vs Sol 0/100; Pixel Perfect Sol 1:48/$0.12 vs Fable 4:18/$0.42 for 2 points; Build-Off Sol 2 min/$0.10 vs Fable 12 min/$0.58 same 20/20 | D | Finn N3Me0Pf2hiY |
| RemakeBench 6 game menus: Fable 5.1 max $17-32 and 54-81 min per task, best textures/props; Sol better mechanics (Echo eye tracking), $3-16; Grok 4.6 $1-4 near-Fable fidelity; Kimi K3 $1-5, loops | D | RemakeBench |
| Better Stack F1 game: Fable 5.1 xhigh 1st ($18.87/60 min, bug-free), Fable 5 2nd, Kimi K3 3rd ($1.26), Sol 4th (broken, $5.15/7 min), Grok 5th | D | Better Stack |
| Johnston 9-test gauntlet: Fable 5.1 98 ($42.24, 149 min), Grok 4.6 94 ($2.50, 60 min), Opus 5 91 ($13), Sol 88 ($5.27), GLM 5.3 Flash 83 ($0.09) | D | Johnston |
| Simmons 5 blind builds: Opus 5 won 3, Fable 5 won 1, Fable 5.1 won 1 (the 3D sim) but was 27-69% cheaper than Fable 5 each time | D | Simmons SgqdiS3H1Vg |
| Chaen 3 tasks: Opus 5 won the physics sim (Fable timed out), Fable won the anomaly dashboard, Sol won the slide deck | D | Chaen |
| Bug Hunt Bench 105 planted bugs: Fable 5.1 43, Sol 42 (Fable 2.24x faster, 26% cheaper than Fable 5), Grok 27 | D | Rithesh (third-party post) |
| Preston: Fable 5.1 100% precision on a 12-planted-error fact-check (20 issues, 0 hallucinated); Sol 53 issues incl. false ones; both repaired a broken repo, 31/31 tests | D | Preston ua0SblzFq-M |
| Every: 5.1 half the tokens and 60% of the time of Opus 5 per agent step; slide layout beats Sol; Sol beats it on short posts and dashboards narrative; 5.1 rejects sycophantic framings Sol accepts | D | Every yZddAiz4HP8 |
| Zapier AutomationBench: 100% on policy-heavy approvals (Fable 5: 0), 0% on pipeline analysis and market research, Opus 5 50% vs 36% on operations | D (slides) | Duke Pan ui1oFP_-O7M |
| CodeRabbit: 34% fewer comments, 70% fewer nitpicks, flat recall, 49% slower; low beat high | D | Duke Pan, AICodeKing |
| Cognition: Devin moves Opus 5 traffic to 5.1 starting with code review; $2.68 vs $5.84 per FrontierCode task | D | Mohan Lwtwnuc0Vmc |
| Godot MCP gauntlet: Opus 5 max finished passes faster with fewer tokens than 5.1; both needed a "wrap it up" prompt to stop polishing | D | BuenaVentura |
| 3D scene builds: Fable 5.1 $0.94-1.41 vs Sol $0.15-0.18 per scene, 6-9x cheaper, Fable more detail | D | MilerDev OGDJgq1Fdmc, Erwan urcrt8CbD9k |
| DeepSeek V4 Flash did 3 web apps for $0.30 total vs $15.30 on Fable 5.1, needing 2-3 fix turns | D | Onde eu Clico sCUWk43udRQ |

## Tactics that measurably helped (D)

- "Playwright and Chromium are preinstalled globally, use them to play-test your game with screenshots and iterate until it's good." (Marvijo, two runs)
- "Only generate the slides. Don't do anything else." (Rogoff) and "Não use nenhuma skill." to isolate native behavior (Battisti)
- Meta-prompt: Opus 5 writes the structured spec, Fable 5.1 executes at high/max (CodeFactory)
- Kill loop: "Ask all agents to start wrapping it up. Do not add anything new. Just complete the game as it stands so that it can be played and tested." (BuenaVentura)
- `/claude-api prompt-audit` on a spec file flagged end-state-only verification and a negative-only constraint (AI Unleashed)
- Nick Ponte's three templates: Finish the Job ("take ownership... test your work... verify the final result accomplishes my original goal"), Clone & Compare, Critic Mode ("review your work as if you were a skeptical expert... find the 5 biggest weaknesses... fix... only then give me the final version")
- Balmer: "Interview me until you can state the real problem clearly... give me three credible routes, recommend one, build the plan, then start the work you can do"
- Verdent-style parallel worktrees share the prefix cache across branches (AICodeKing)

## Other-model news carried by these videos (cross-checked in lane E)
GPT-6/Astra: previewed 2026-09-01 as OpenAI's first "Critical" cyber-tier model (100% ExploitBench, two V8 zero-days), not released; alpha ids `mozaik-alpha-fdm`/`ultima-alpha`. Gemini 3.8 Flash: rumored (WSJ/BI), not in the API. Grok 4.7: Musk says mid-September. Qwen 3.8 Max 0902: released, #1 Code Arena WebDev (claim). GLM 5.3 Flash: see the GLM evidence file. Cursor loses OpenAI models 2026-11-12. Codex Pro 20x = true 20x weekly with no 5-h throttle (OpenAI staff post). Claude Code weekly limits -17% net on 2026-09-14.
