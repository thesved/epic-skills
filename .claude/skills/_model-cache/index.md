# Model cache, index

Single source of truth for **which model to use, its current id, pricing, and how to call it well**, so the skills stay lean and never hardcode stale ids. Read the per-provider file for the call shape before generating.

- **Gemini** → [`gemini.md`](gemini.md), text/reasoning, image, TTS, **realtime audio (Live API)**, video analysis, video-gen (veo), music (lyria), deep-research
- **OpenAI/Codex** → [`openai.md`](openai.md), prompt-writing, second-opinion, codex (Responses API), **realtime audio**, image-gen
- **OpenRouter** → [`openrouter.md`](openrouter.md), generic OpenAI-compatible **fallback** for text/reasoning across many providers (one key)
- **Prompt examples** → [`examples/`](examples/), copy-pasteable best-practice prompts per model with the efficiency lever each pulls. **Split by domain so you load only what the task needs, read the ONE file that matches before composing a prompt:**

| doing… | read |
|---|---|
| Gemini text / reasoning / JSON / long-context | [`examples/gemini-text.md`](examples/gemini-text.md) |
| Gemini image gen / edit (Nano Banana) | [`examples/gemini-image.md`](examples/gemini-image.md) |
| Gemini TTS or Live realtime voice | [`examples/gemini-audio.md`](examples/gemini-audio.md) |
| Gemini video analysis or Veo video-gen | [`examples/gemini-video.md`](examples/gemini-video.md) |
| Lyria music or deep-research | [`examples/gemini-gen.md`](examples/gemini-gen.md) |
| Any OpenAI: **gpt-6-astra operating card** / gpt-5.6 / gpt-5.5 / codex / realtime / gpt-image-2 | [`examples/openai.md`](examples/openai.md) |
| Grok / xAI via OpenRouter (route-to/away, effort dial, agentic patterns) | [`examples/grok.md`](examples/grok.md) |
| Kimi K3 / Moonshot via OpenRouter (route-to/away, param traps, board-seat verdict) | [`examples/kimi.md`](examples/kimi.md) |
| DeepSeek V4 Pro 0813 / Flash 0731 (effort ladder, caching, peak pricing, provider pinning, no-vision, Harness) | [`examples/deepseek.md`](examples/deepseek.md) |
| GLM 5.3 Flash (ex ox-alpha: effort `high` not max, Baseten pinning, promo cliff 2026-09-09, route-to/away, local sizes) | [`examples/glm-flash.md`](examples/glm-flash.md) |
| Meta Muse Spark 1.3 via OpenRouter (effort low, mandatory reasoning, media shapes that work, Contributor data trade, Codex incompatibility, route-to/away) | [`examples/muse.md`](examples/muse.md) |

## Capability routing, who to reach for
| need | first choice | id (verify in provider file) | why |
|---|---|---|---|
| Different-model second opinion | either | gemini-3.1-pro-preview / gpt-5.5 | architecture diversity |
| Write a prompt for Claude/Opus | **Codex** | gpt-5.5 | spec-like, less conversational |
| Non-English copy / translate | **Gemini** | gemini-3.7-flash | stronger multilingual |
| Image generate / edit | **Gemini** Nano Banana | gemini-3.1-flash-image (key) | cheap, fast edits; Codex gpt-image-2 fallback |
| TTS / narration | **Gemini** | gemini-3.1-flash-tts-preview (key) | 30 voices, multi-speaker |
| Analyze a video / YouTube | **Gemini** (only option) | gemini-3.7-flash / 3.1-pro; `GEMINI_VIDEO=agentic` for >15 min (Interactions API, 93% fewer tokens measured 2026-09-02) | Claude can't; Gemini's moat |
| Realtime/live voice audio | either | gemini-2.5-flash-native-audio-… / gpt-realtime-2.1(-mini) | WebSocket; Gemini audio-out ~5× cheaper than full 2.1, but 2.1-mini narrows it to ~1.5×; OpenAI GA + simpler |
| Agentic coding via OpenAI key | OpenAI codex | gpt-5.3-codex (Responses API) | heavy coding; CLI `gpt-5.5` for interactive |
| Computer use / browser QA / desktop app driving (Blender, Unreal, CRM canvases) | **gpt-6-astra** (`codex exec -m gpt-6-astra -c model_reasoning_effort=high`, reachable on the Pro sub since 2026-09-05, CLI 0.153.4) | OSWorld 2.0 72.6 at ~40 min/task vs Sol 65.7 at ~75, ScreenSpot-Pro 92.7 vs 76.9; card in `examples/openai.md`. Also on our API key and on OpenRouter (`openai/gpt-6-astra`, `-pro`, `:batch`) since 2026-09-04 |
| Terminal science / data analysis agents, multi-hour tool loops | **gpt-6-astra** via Codex (Pro sub); Fable 5.1 for ambiguous asks | TB-Science 64.6 vs Fable 5.1 52.6 (official), 1/3 of Sol's tokens per coding task (AA); Fable 5.1 keeps ambiguous and taste-heavy work |
| Text fallback when a route throttles | **OpenRouter** | provider/model | one key → many providers |
| Long-context doc dump (< ~200K, or video) | **Gemini** | gemini-3.7-flash | 1M ctx, cheapest |
| Recall-critical long text read (200K to 1M tokens), PDF or MP4 read without Google | **Muse Spark 1.3** via OpenRouter, effort `low` | meta/muse-spark-1.3 | measured 2026-09-05: 293K-token needle 3/3 in 15 s for $0.37; official MRCR 98.1 at 512K-1M vs Sol 73.8; MP4 with sound and PDF work, WAV is silently dropped, YouTube URLs 400. Never the Contributor tier for private text (trains on data). Card: `examples/muse.md` |
| Video generation | Gemini veo | veo-3.1-lite-generate-preview; `gemini-omni-1.1-flash` (GA 2026-08-27) for edit / extend / interpolate | |
| Transcribe audio (meetings, podcasts) | **Gemini** | gemini-3.5-transcribe (unary, $0.005/min) / gemini-3.5-transcribe-live (WebSocket) | GA 2026-08-26; cheaper and cleaner than 3.7-flash on audio |
| Music generation | Gemini lyria | lyria-3-pro-preview | |
| Multi-step cited research | Gemini deep-research | deep-research-pro-preview-12-2025 | or use `/deep-research` skill |

Smoke = cheapest lite (`gemini-flash-lite-latest`) / `gpt-5.6-sol`. Default Gemini auth = **paid `GEMINI_API_KEY`** (REST), not OAuth.

## Structured-output traps (measured 2026-08-12, cost a real bake-off to find)
Deep-research writeups behind each claim: [`research/2026-08-12/`](research/2026-08-12/).

- **Probe your ACTUAL schema against every model before running anything.** `structured_outputs: true` in a catalogue means the model has *a* strict mode, not that it accepts *your* schema, and a rejection silently downgrades the call to loose JSON. That reads as a quality gap on the scoreboard when it is a plumbing gap.
- **Gemini accepts `enum` on STRING only.** An integer enum is rejected, and the error names an unrelated property ("requires unspecified property 'attribute_name'"), so it looks like a bug in a different field. One integer enum blocked strict mode on all five Gemini rungs; removing it unlocked 18 of 19 models across every vendor.
- **Anthropic strict mode**: no `minimum`/`maximum`, no `minLength`/`maxLength`, no `maxItems`, `minItems` only 0 or 1, no recursion, `additionalProperties` must be false. Guarantees parseable JSON by construction.
- **OpenAI strict mode**: supports the numeric bounds and recursion Anthropic lacks, but bans `allOf`/`not`/`if-then-else`, requires EVERY property in `required`, caps at 5000 properties / 10 nesting levels, and can still truncate mid-object.
- **Portable rule**: put in the schema only what every provider enforces identically; check your own bounds in code. A rule a vendor silently ignores is worse than no rule, because you stop checking it.
- **Reasoning tokens are billed as output AND drawn from the same `max_tokens` budget.** Measured: a cheap reasoning model spent its entire 6000-token allowance thinking and returned `finish_reason=length` with EMPTY content, indistinguishable from a refusal. For rule-following bulk work send `reasoning: {effort:"low", exclude:true}`. Gemini cannot disable thinking at all, floor is `minimal`; xAI cannot either except via a separate non-reasoning endpoint; OpenAI reasoning also counts against `max_output_tokens`.
- **Provider roulette on OpenRouter is real.** The same model id served by different upstreams differs in max output (up to 32x: DeepInfra caps some 1M-context models at 16,384), in quantisation, in latency (measured 78s vs 557s for one model on one prompt), and in whether `response_format` is offered at all. Pin the provider for anything reproducible.
- **Headline prices can be conditional.** Tiered by prompt length (qwen3.7-flash is $0.03/M only below a 32k prompt, $0.10 above), or a promotion with an expiry (solar-pro4's $0.03 reverts to $0.30 on 2026-09-10). Always read the endpoint, not the marketing line.
- **`:batch` twins exist on OpenRouter for most models at 50% off**, and on Gemini batch, context caching and structured output all still work. For a bulk job that is the single biggest lever after model choice.
- **No Hungarian (or CEE) benchmark exists for ANY 2026 model**, from any vendor or leaderboard. OpenHuEval covers GPT-4-era models only; MMMLU's 14 languages exclude Hungarian. Multilingual quality for these languages can only be measured, never looked up.

## Delegation roles, current picks (refresh with every model update; skills point HERE, never hardcode)
Axes: intelligence = how hard a problem it takes unsupervised; taste = UI/UX, code quality, API design, copy. Tie-break for anything that ships: intelligence > taste > cost. Verified 2026-07-12; review/gemini/grok/open-family rows refreshed 2026-08-14; **orchestrator, review-gate, video and open-family rows refreshed 2026-09-02 for Fable 5.1 and GLM 5.3 Flash** (see `research/2026-09-02/`); **GPT-6 Astra rows verified 2026-09-05 (reachable on the Pro sub, API key and OpenRouter; small-task bakeoff tie with Sol) and Muse Spark 1.3 row added** (see `research/2026-09-05/muse-sweep.md` and `astra-delta.md`).
| role | current pick | why now |
|---|---|---|
| Orchestrator / plans / taste judging / final review | **fable-5-1** (`/model fable`, Claude Code 2.1.255+): `high` to orchestrate, `medium` for routine planning turns, `xhigh` only after `high` failed, never `max` | released 2026-09-01; best planning layer and long-horizon runner (Terminal-Bench-Science 52.6 vs Opus 5 29.0), taste is a coin flip vs Opus 5 (verify). 2x Opus price, capped at 50% of a Max plan's weekly limit, `max` = 1.7x Fable 5's output tokens; Anthropic's own advice is start on Opus 5 |
| Fable review pass (issue discovery, cheap) | fable-5-1 at `low` | CodeRabbit 2026-09-01: low beat high on recall (61.0 vs 57.1) and precision, 3 min faster; the one Fable job where the $0.25 cache read matters |
| Implementation ESCALATION (Sol failed twice, integration-heavy, under-specified) | fable-5-1 at `medium`, clean branch | Senior SWE-Bench 2026-09-02: tasteful tie with Sol xhigh at ~2x Sol's output cost; FrontierCode peaks at medium. Exception path, not the default |
| Implementation that ships (features, anything with judgment) | gpt-5.6-sol via codex CLI | best executor; cost is a tie-breaker only. **External verification mandatory, never accept Sol's own test results** (METR record reward-hacking, see `examples/openai.md`) |
| **GUI-in-the-loop implementation, computer-use verification, multi-hour tool runs, terminal science** (reachable since 2026-09-05) | **gpt-6-astra via codex CLI at `high`** (`xhigh` after a failed high, never `max`/`ultra` by default); Sol stays the plain-implementation default | Astra's differentiated wins are computer use (OSWorld 72.6 in 40 min vs Sol 65.7 in 75), long tool loops (1/3 of Sol's tokens, Pokémon 18 h vs 97 h) and TB-Science (64.6 vs Fable 5.1 52.6). NOT a Sol replacement for plain reasoning (AA index 61 = Sol at 1.75x cost per task) and NOT the coding-ceiling pick (AA Coding Agent 67 vs Fable 5.1 70; Theo/Ben: 11.3% threads needing correction vs Fable 7.0%). Prune AGENTS.md, add the action-chaining clause, lock tests before it runs, stay under 272K input; card in `examples/openai.md`. Day-one bakeoff 2026-09-05: Astra 8/8 text tasks vs Sol 6/8 through Codex, buggy-repo fix 11/11 in 53-58 s with 4-5 commands vs Sol 55-97 s, so no regression vs Sol on small work; the differentiated GUI/long-horizon wins remain official numbers plus practitioner reports, not our measurement. Codex allowances: 100-900 local messages per 5 h on Pro 20x, weekly limits apply, paid instant reset exists |
| **Cheap bounded executor for NON-sensitive work: single-pass frontend or 3D prototypes, spec'd bugfixes, 1M-token reads, PDF/MP4 extraction** (added 2026-09-05) | `openrouter-bridge/ask.sh -m meta/muse-spark-1.3` or the mini agent loop, effort `low`; **never `-contributor`** for anything private (trains on prompts; our account blocks it anyway) | AA index 61 at $0.55/task (Sol 61 at $0.95, Fable 66 at $3.69); our bakeoff: 11/11 tasks at low, textwrap-exact 55-60/60 at default and 60/60 at xhigh vs 37-57/60 at low (Sol 57/60), repo fix in 6 turns for $0.023; use low for loops, default for exact-spec code, xhigh only when time is free (5-6 min per call, provider errors on tool loops). NOT for taste, multi-turn autonomy, audio, Codex CLI (rejects its tool names), security, or as the sole reviewer; sole upstream with launch 503s. Card: `examples/muse.md` |
| Mechanical bulk (migrations, boilerplate, rote tests, log analysis) | gpt-5.6-terra via codex CLI | ~5.5-class at half price, sub-billed; ONLY when the task is rote AND low-stakes. When in doubt → sol |
| Mission-critical review gate | best available, plural: fable-5-1 (low for discovery, high for the final verdict) + opus-5 (precision seat, 39.3 vs 37.3) + gpt-5.6-sol as independent seats | a defect that slips a gate stalls all downstream work; gate cost is small vs stall cost and usually pays back in speed |
| Independent review seat + security review | opus-5 (`claude-opus-5`, released 2026-07-24) | near-Fable at half price ($5/$25), 1M ctx, ties Fable 5.1 on APEX-SWE and beats it on build/dependency tasks (Snorkel 2026-09-01); security reports must not return through Fable (cyber flag → session pinned to Opus 4.8). Fable 5.1 may now FIND vulnerabilities in source, still never exploit/pentest work. GPT-6 Astra is Preparedness-Critical for cyber: it refuses PoC exploits, the API kills flagged runs (`misalignment_policy_violation`), and Daybreak reduced-refusal access is NOT available on Astra (Daybreak Blue/Red are Sol / `gpt-5.6-cyber`), so it adds nothing to this seat |
| Wrapper plumbing / mid-taste | sonnet-5 | cheap, reliable executor of ready-made prompts |
| Read-only scout | haiku | cheapest useful |
| Cross-family opinion (board Grok seat) | x-ai grok chain (`openrouter-bridge/ask.sh --grok`) | latest = grok-4.6 (2026-08-12): cost/task ~2x 4.5 via token inflation, no longer a fast lane; route-to/away in `examples/grok.md` |
| Cheap diverse opinion (board open-family seat) | `openrouter-bridge/ask.sh -m deepseek/deepseek-v4-pro-0813` (2nd seat: `-m z-ai/glm-5.3`) | non-OAI/Anthropic/Google/xAI architecture diversity; one plain call per model, never a router. 0813 = GA snapshot (2026-08-12), effort `high` (max overthinks); unsuffixed `deepseek-v4-pro` on OpenRouter is the April build. GLM 5.3 (2026-08-14) = AA 60, mandatory thinking, ignores json_schema silently. DeepSeek direct price is time-variable since 2026-08-16 (2x at 01-04 and 06-10 UTC) and our OpenRouter key cannot reach the DeepSeek-hosted endpoint (data-policy guardrail), so seats land on re-hosts at 1.2-2x: see `examples/deepseek.md` |
| Cheap security / cyber second opinion (opt-in) | `-m deepseek/deepseek-v4-pro-0813`, effort high | CyberGym 83.3 = Fable 5; ~20x cheaper per solved exploit task than Opus 4.8 and no refusal downgrade; text-only, slow (50-90 tok/s), never the judge of its own work |
| Cheapest capable executor + 3rd opinion seat (bulk single-file frontend, scaffolding with a real DB, PR triage, structured extraction, tool loops, multilingual) | `-m z-ai/glm-5.3-flash` (released 2026-08-26 = ox-alpha; effort `high`, never `medium` (400), pin Baseten for 2-3x tok/s; promo $0.075/$0.25 to 2026-09-09, then $0.15/$0.50) | AA 57 = Terra at $0.09/task; MIT weights, vision in; 98-video verdict in `examples/glm-flash.md`. NOT for interactive loops (28-60 tok/s, 9-20 min per prompt), whole-repo generation, vision precision, prose, strict JSON-schema output, sole security review, or untrusted web input. DeepSeek V4 Flash stays the fast cheap sub-agent (2.5x tok/s, 7x fewer turns on one task) |
| High-stakes extra seat (opt-in) | `-m moonshotai/kimi-k3` | strongest open-weight (above Opus 4.8 on GDPval-AA v2), adds Moonshot family; day-one caveats + flip-to-default conditions in `examples/kimi.md` (verified 2026-07-16) |
| Video / multimodal / 1M-ctx dumps / non-English / one-shot UI + PDF-to-dashboard | gemini-3.7-flash (REST); `GEMINI_VIDEO=agentic` for long videos | the moat; Claude can't do video. 340 tok/s, thinking `low|medium|high` (`minimal` = 400). NOT for spec-strict multi-component builds or long-horizon agent runs (drifts off spec, hallucinates scope; 3.1-pro-preview follows spec) |
| **Bulk structured extraction** (thousands of schema-constrained calls over a fixed rulebook) | cheapest model that PASSES a schema probe on your real schema, then batch it | the price spread across rungs is 10-100x, and the deciding factor is never the headline benchmark: it is strict-schema support, max output, and cache-read price. Probe, do not read it off a spec sheet, see the trap list below |

## Typical response time
Measured once 2026-06-13 (a few runs, median, reference only; not re-run every verify). `verify.sh` prints a live `SECS` column (single run by default). **Scales with output length, image resolution, video/audio duration, and context size.**
| capability | model | latency | per unit |
|---|---|---|---|
| lite / text-fallback | gemini-flash-lite-latest (= 3.5-flash-lite) · openrouter | ~0.5 s | per request |
| text (short) | gemini-3.7-flash · gpt-5.6-sol | ~1-2 s | per request; +~output tokens. 3.7-flash measured 2026-08-21: 170-185 tok/s on a 600-word answer, TTFB 1.3 s at thinkingLevel low |
| tts | gemini-3.1-flash-tts-preview | ~2-3 s | per short utterance (~1× audio length) |
| video analysis | gemini-3.7-flash | ~2-3 s | short clip; +~ video length / ingestion |
| realtime audio | gemini-live · gpt-realtime | ~4 s round-trip | first audio <1 s, then streams in real time |
| image | gemini-3.1-flash-image | ~10 s | per image @1K (more @2K/4K) |
| music | lyria-3-pro-preview | ~20 s | per song |
| video-gen | veo-3.1-lite-generate-preview | ~45 s | per clip (~6-10 s per sec of video; async poll) |
| deep-research | deep-research-pro-preview-12-2025 | ~2-3 min | per query (agentic; high variance; async poll) |

## Refresh (the `update-models` flow)
1. `_model-cache/update.sh [gemini|openai|all]`: deterministic: pulls the live model list, diffs vs the snapshot, prints **NEW / REMOVED / CHANGED**.
2. Web-research **only** the flagged models (capability + pricing + one best-practice sample) and edit the provider file. If nothing changed → just refresh pricing.
2b. Any flagged model that could change a **Delegation roles** row (above): re-verify that row and its date. Skills depend on this table instead of hardcoding names.
3. `update-models all` → re-research every model; `update-models <ids>` → only those.

`.snap-gemini.tsv` / `.snap-openai.txt` = machine snapshots (diff basis). `.updated` = last refresh timestamp, **if it's older than ~30-60 days, run `update.sh` before trusting ids/pricing** (the lineups drift).

## Verify (prove models actually work, E2E)
`_model-cache/verify.sh` calls one real model per capability and prints a PASS/FAIL table (don't trust the cache; run it):
- `verify.sh --cheap`: text liveness only (gemini text+lite, openai text, openrouter), ~free
- `verify.sh`: + image, tts, realtime audio (both), codex, ~10-15¢
- `verify.sh --full`: + veo video, lyria music, deep-research, YouTube video-analysis, ~$0.50-1, minutes
- **single run by default** (saves credits). Add `--repeat N` to average the fast endpoints over N runs (manual latency benchmarking, `SECS` then shows median + min-max); paid-gen stays 1×.

Helpers: `realtime_gemini.py` / `realtime_openai.py` (raw-websocket text→WAV clients), `lib.sh` (key resolver + `wav_ok`). Last full run 2026-06-13: **13/13 PASS**.

## Keys (resolved by `lib.sh`: env → `~/.zshrc` export → keychain)
Stored in macOS **keychain** (`gemini-api-key`, `openai-api-key`, `openrouter-api-key`); `lib.sh resolve_key` derives the service name. `GEMINI_API_KEY` (paid, REST + Live API) · `OPENAI_API_KEY` (codex/realtime/responses) · `OPENROUTER_API_KEY` (fallback). First keychain read may pop a macOS access prompt, click **Always Allow** so scripts read non-interactively.
