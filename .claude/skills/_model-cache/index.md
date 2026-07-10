# Model cache - index

Single source of truth for **which model to use, its current id, pricing, and how to call it well**, so the skills stay lean and never hardcode stale ids. Read the per-provider file for the call shape before generating.

- **Gemini** → [`gemini.md`](gemini.md) - text/reasoning, image, TTS, **realtime audio (Live API)**, video analysis, video-gen (veo), music (lyria), deep-research
- **OpenAI/Codex** → [`openai.md`](openai.md) - prompt-writing, second-opinion, codex (Responses API), **realtime audio**, image-gen
- **OpenRouter** → [`openrouter.md`](openrouter.md) - generic OpenAI-compatible **fallback** for text/reasoning across many providers (one key)
- **Prompt examples** → [`examples/`](examples/) - copy-pasteable best-practice prompts per model with the efficiency lever each pulls. **Split by domain so you load only what the task needs - read the ONE file that matches before composing a prompt:**

| doing… | read |
|---|---|
| Gemini text / reasoning / JSON / long-context | [`examples/gemini-text.md`](examples/gemini-text.md) |
| Gemini image gen / edit (Nano Banana) | [`examples/gemini-image.md`](examples/gemini-image.md) |
| Gemini TTS or Live realtime voice | [`examples/gemini-audio.md`](examples/gemini-audio.md) |
| Gemini video analysis or Veo video-gen | [`examples/gemini-video.md`](examples/gemini-video.md) |
| Lyria music or deep-research | [`examples/gemini-gen.md`](examples/gemini-gen.md) |
| Any OpenAI: gpt-5.5 / codex / realtime / gpt-image-2 | [`examples/openai.md`](examples/openai.md) |
| Grok / xAI via OpenRouter (route-to/away, effort dial, agentic patterns) | [`examples/grok.md`](examples/grok.md) |

## Capability routing - who to reach for
| need | first choice | id (verify in provider file) | why |
|---|---|---|---|
| Different-model second opinion | either | gemini-3.1-pro-preview / gpt-5.5 | architecture diversity |
| Write a prompt for Claude/Opus | **Codex** | gpt-5.5 | spec-like, less conversational |
| Non-English copy / translate | **Gemini** | gemini-3.5-flash | stronger multilingual |
| Image generate / edit | **Gemini** Nano Banana | gemini-3.1-flash-image (key) | cheap, fast edits; Codex gpt-image-2 fallback |
| TTS / narration | **Gemini** | gemini-3.1-flash-tts-preview (key) | 30 voices, multi-speaker |
| Analyze a video / YouTube | **Gemini** (only option) | gemini-3.5-flash / 3.1-pro | Claude can't; Gemini's moat |
| Realtime/live voice audio | either | gemini-2.5-flash-native-audio-… / gpt-realtime-2.1(-mini) | WebSocket; Gemini audio-out ~5× cheaper than full 2.1, but 2.1-mini narrows it to ~1.5×; OpenAI GA + simpler |
| Agentic coding via OpenAI key | OpenAI codex | gpt-5.3-codex (Responses API) | heavy coding; CLI `gpt-5.5` for interactive |
| Text fallback when a route throttles | **OpenRouter** | provider/model | one key → many providers |
| Long-context doc dump | **Gemini** | gemini-3.5-flash | 1M ctx |
| Video generation | Gemini veo | veo-3.1-lite-generate-preview | |
| Music generation | Gemini lyria | lyria-3-pro-preview | |
| Multi-step cited research | Gemini deep-research | deep-research-pro-preview-12-2025 | or use `/deep-research` skill |

Smoke = cheapest lite (`gemini-flash-lite-latest`) / `gpt-5.6-sol`. Default Gemini auth = **paid `GEMINI_API_KEY`** (REST), not OAuth.

## Delegation roles - current picks (refresh with every model update; skills point HERE, never hardcode)
Axes: intelligence = how hard a problem it takes unsupervised; taste = UI/UX, code quality, API design, copy. Tie-break for anything that ships: intelligence > taste > cost. Verified 2026-07-09.
| role | current pick | why now |
|---|---|---|
| Orchestrator / plans / final review | fable-5 (high effort, never above) | best planning layer; 2x Opus price so it writes no bulk code |
| Bulk executor (clear-spec impl, migrations, tests, analysis) | gpt-5.6-terra via codex CLI (`gpt-5.6-sol` for hard bulk) | ~5.5-class execution at half price, sub-billed. **If Sol executes, external verification is mandatory - never accept its own test results** (METR record reward-hacking, see `examples/openai.md`) |
| Taste work + independent review seat | opus-4.8 | taste ~9 at half Fable price; also the security-review seat (Fable refusal risk) |
| Wrapper plumbing / mid-taste | sonnet-5 | cheap, reliable executor of ready-made prompts |
| Read-only scout | haiku | cheapest useful |
| Cross-family opinion (board Grok seat) | x-ai grok chain (`openrouter-bridge/ask.sh --grok`) | latest xAI flagship, self-healing fallback; also a strong agentic-tool-loop executor (see `examples/grok.md`) |
| Cheap diverse panel | openrouter fusion (GLM+DeepSeek) | non-OAI/Anthropic/Google/xAI architecture diversity |
| Video / multimodal / 1M-ctx dumps / non-English | gemini (REST) | the moat; Claude can't do video |

## Typical response time
Measured once 2026-06-13 (a few runs, median - reference only; not re-run every verify). `verify.sh` prints a live `SECS` column (single run by default). **Scales with output length, image resolution, video/audio duration, and context size.**
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
1. `_model-cache/update.sh [gemini|openai|all]` - deterministic: pulls the live model list, diffs vs the snapshot, prints **NEW / REMOVED / CHANGED**.
2. Web-research **only** the flagged models (capability + pricing + one best-practice sample) and edit the provider file. If nothing changed → just refresh pricing.
2b. Any flagged model that could change a **Delegation roles** row (above): re-verify that row and its date. Skills depend on this table instead of hardcoding names.
3. `update-models all` → re-research every model; `update-models <ids>` → only those.

`.snap-gemini.tsv` / `.snap-openai.txt` = machine snapshots (diff basis). `.updated` = last refresh timestamp - **if it's older than ~30-60 days, run `update.sh` before trusting ids/pricing** (the lineups drift).

## Verify (prove models actually work - E2E)
`_model-cache/verify.sh` calls one real model per capability and prints a PASS/FAIL table (don't trust the cache; run it):
- `verify.sh --cheap` - text liveness only (gemini text+lite, openai text, openrouter), ~free
- `verify.sh` - + image, tts, realtime audio (both), codex - ~10-15¢
- `verify.sh --full` - + veo video, lyria music, deep-research, YouTube video-analysis - ~$0.50-1, minutes
- **single run by default** (saves credits). Add `--repeat N` to average the fast endpoints over N runs (manual latency benchmarking - `SECS` then shows median + min-max); paid-gen stays 1×.

Helpers: `realtime_gemini.py` / `realtime_openai.py` (raw-websocket text→WAV clients), `lib.sh` (key resolver + `wav_ok`). Last full run 2026-06-13: **13/13 PASS**.

## Keys (resolved by `lib.sh`: env → `~/.zshrc` export → keychain)
Stored in macOS **keychain** (`gemini-api-key`, `openai-api-key`, `openrouter-api-key`); `lib.sh resolve_key` derives the service name. `GEMINI_API_KEY` (paid, REST + Live API) · `OPENAI_API_KEY` (codex/realtime/responses) · `OPENROUTER_API_KEY` (fallback). First keychain read may pop a macOS access prompt - click **Always Allow** so scripts read non-interactively.
