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
| Any OpenAI: gpt-5.5 / codex / realtime / gpt-image-2 | [`examples/openai.md`](examples/openai.md) |
| Grok / xAI via OpenRouter (route-to/away, effort dial, agentic patterns) | [`examples/grok.md`](examples/grok.md) |
| Kimi K3 / Moonshot via OpenRouter (route-to/away, param traps, board-seat verdict) | [`examples/kimi.md`](examples/kimi.md) |

## Capability routing, who to reach for
| need | first choice | id (verify in provider file) | why |
|---|---|---|---|
| Different-model second opinion | either | gemini-3.1-pro-preview / gpt-5.5 | architecture diversity |
| Write a prompt for Claude/Opus | **Codex** | gpt-5.5 | spec-like, less conversational |
| Non-English copy / translate | **Gemini** | gemini-3.7-flash | stronger multilingual |
| Image generate / edit | **Gemini** Nano Banana | gemini-3.1-flash-image (key) | cheap, fast edits; Codex gpt-image-2 fallback |
| TTS / narration | **Gemini** | gemini-3.1-flash-tts-preview (key) | 30 voices, multi-speaker |
| Analyze a video / YouTube | **Gemini** (only option) | gemini-3.7-flash / 3.1-pro | Claude can't; Gemini's moat |
| Realtime/live voice audio | either | gemini-2.5-flash-native-audio-… / gpt-realtime-2.1(-mini) | WebSocket; Gemini audio-out ~5× cheaper than full 2.1, but 2.1-mini narrows it to ~1.5×; OpenAI GA + simpler |
| Agentic coding via OpenAI key | OpenAI codex | gpt-5.3-codex (Responses API) | heavy coding; CLI `gpt-5.5` for interactive |
| Text fallback when a route throttles | **OpenRouter** | provider/model | one key → many providers |
| Long-context doc dump | **Gemini** | gemini-3.7-flash | 1M ctx |
| Video generation | Gemini veo | veo-3.1-lite-generate-preview | |
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
Axes: intelligence = how hard a problem it takes unsupervised; taste = UI/UX, code quality, API design, copy. Tie-break for anything that ships: intelligence > taste > cost. Verified 2026-07-12; review/gemini/grok/open-family rows refreshed 2026-08-14 (see `research/2026-08-14/model-sweep.md`).
| role | current pick | why now |
|---|---|---|
| Orchestrator / plans / taste judging / final review | fable-5 (high effort, never above) | best planning layer AND highest taste available: taste review is orchestrator work, never delegated. 2x Opus price so it writes no bulk code |
| Implementation that ships (features, anything with judgment) | gpt-5.6-sol via codex CLI | best executor; cost is a tie-breaker only. **External verification mandatory, never accept Sol's own test results** (METR record reward-hacking, see `examples/openai.md`) |
| Mechanical bulk (migrations, boilerplate, rote tests, log analysis) | gpt-5.6-terra via codex CLI | ~5.5-class at half price, sub-billed; ONLY when the task is rote AND low-stakes. When in doubt → sol |
| Mission-critical review gate | best available, plural: fable-5 + opus-5 + gpt-5.6-sol as independent seats | a defect that slips a gate stalls all downstream work; gate cost is small vs stall cost and usually pays back in speed |
| Independent review seat + security review | opus-5 (`claude-opus-5`, released 2026-07-24) | near-Fable at half price ($5/$25, same as 4.8), 1M ctx; security reports must not return through Fable (refusal-downgrade risk) |
| Wrapper plumbing / mid-taste | sonnet-5 | cheap, reliable executor of ready-made prompts |
| Read-only scout | haiku | cheapest useful |
| Cross-family opinion (board Grok seat) | x-ai grok chain (`openrouter-bridge/ask.sh --grok`) | latest = grok-4.6 (2026-08-12): cost/task ~2x 4.5 via token inflation, no longer a fast lane; route-to/away in `examples/grok.md` |
| Cheap diverse opinion (board open-family seat) | `openrouter-bridge/ask.sh -m deepseek/deepseek-v4-pro` (2nd seat: `-m z-ai/glm-5.2`) | non-OAI/Anthropic/Google/xAI architecture diversity; one plain call per model, never a router. DeepSeek direct API goes time-variable 2026-08-16 16:00 UTC (peak $1.32/$3.96, off-peak $0.66/$1.98 vs $0.435/$0.87 now); OR route verified 2026-08-14, re-check after |
| High-stakes extra seat (opt-in) | `-m moonshotai/kimi-k3` | strongest open-weight (above Opus 4.8 on GDPval-AA v2), adds Moonshot family; day-one caveats + flip-to-default conditions in `examples/kimi.md` (verified 2026-07-16) |
| Video / multimodal / 1M-ctx dumps / non-English | gemini (REST) | the moat; Claude can't do video |
| **Bulk structured extraction** (thousands of schema-constrained calls over a fixed rulebook) | cheapest model that PASSES a schema probe on your real schema, then batch it | the price spread across rungs is 10-100x, and the deciding factor is never the headline benchmark: it is strict-schema support, max output, and cache-read price. Probe, do not read it off a spec sheet, see the trap list below |

## Typical response time
Measured once 2026-06-13 (a few runs, median, reference only; not re-run every verify). `verify.sh` prints a live `SECS` column (single run by default). **Scales with output length, image resolution, video/audio duration, and context size.**
| capability | model | latency | per unit |
|---|---|---|---|
| lite / text-fallback | gemini-flash-lite-latest · openrouter | ~0.5 s | per request |
| text (short) | gemini-3.5-flash · gpt-5.5 · gpt-5.3-codex | ~1-2 s | per request; +~output tokens |
| tts | gemini-3.1-flash-tts-preview | ~2-3 s | per short utterance (~1× audio length) |
| video analysis | gemini-3.5-flash | ~2-3 s | short clip; +~ video length / ingestion |
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
