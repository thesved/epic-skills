# OpenAI / Codex model cache

Verified 2026-06-13, text, codex (Responses API), realtime audio all **passed `_model-cache/verify.sh` with a real `OPENAI_API_KEY`**. Cross-checked vs `developers.openai.com` + live `/v1/models`. Prices = USD per 1M tokens.

**Auth, two surfaces:**
1. **`codex` CLI = ChatGPT-account OAuth.** Models: `gpt-5.6-sol`/`-terra`/`-luna` + `gpt-5.5`; `-codex`/`-pro` ids and bare `gpt-5.6` 400. `gpt-6-astra` 400s on ChatGPT login as of 2026-09-04 even on CLI 0.153.2 (account rollout pending; see the Astra section). Used by `/codex-bridge` for prompt-writing + image-gen.
2. **`OPENAI_API_KEY` (now in `~/.zshrc`, len 164 `sk-proj…`).** Unlocks the full API: the `-codex` models (Responses API), Realtime, images, pricing tiers. Scripts resolve it via `_model-cache/lib.sh` (env → `~/.zshrc` → keychain).

## GPT-6 Astra, `gpt-6-astra` (released 2026-09-03; sweep 2026-09-04 in `research/2026-09-04/`)
**Status 2026-09-05: reachable on every route.** Codex CLI with the ChatGPT Pro login (`codex exec -m gpt-6-astra`, 0.153.2 worked, 0.153.4 fixes the picker and makes Astra the bundled default), our direct API key (`POST /v1/responses`), and OpenRouter (`openai/gpt-6-astra`, `-pro`, `:batch`, $10/$50). Day-one bakeoff (`research/2026-09-05/bakeoff/`): 8/8 text tasks through Codex (Sol 6/8), buggy-repo fix 11/11 in 53-58 s with 4-5 commands (Sol 55-97 s). Codex allowances (learn.chatgpt.com/docs/pricing, 09-05): rolling 5-hour usage plus weekly limits, Astra estimates Plus 5-45, Pro 5x 25-225, Pro 20x 100-900 local messages per 5 h, local and cloud share the allowance, a paid instant reset restores both windows; practitioners report one Pro $200 high session burning 40% of a week in 30 min, so meter it. Chat: Plus gets Astra in Work and Codex but not GPT-6 Pro in ordinary Chat; Pro $200 = 200 GPT-6 messages per week plus 170 Sol Pro per day (200 per day combined); Pro $100 = 50 per week shared. Delta report: `research/2026-09-05/astra-delta.md`.

| fact | value |
|---|---|
| id | `gpt-6-astra` only; no dated snapshot, no `-pro`/`-fast`/mini ids ("GPT-6 Pro" is the ChatGPT label). Bedrock/Foundry ids not published |
| context | 1,050,000 (max input 922K, max output 128K), cutoff 2026-04-30, text+image in, text out, no fine-tune, no realtime/audio |
| price std | **10 in / 1 cached / 12.50 cache write / 50 out** (= Fable 5.1 except cache read 4x Fable's $0.25). **> 272K input reprices the whole request 2x in/cache, 1.5x out** (20/2/25/75). Batch and Flex 50%. API Fast 2x price for "up to 2x speed" (Codex Fast = 2.5x credits; Codex exempt from the 272K cliff and from cache-write charges) |
| effort | `low`, `medium`, `high`, `xhigh`, `max`; **no `none`/`minimal`**; API default undocumented (Codex catalog default `low`, verbosity `low`). `ultra` exists ONLY in Codex (wire = max + auto subagent delegation at xhigh); never send `ultra` to the API |
| endpoints | Responses (tools REQUIRE it), Chat Completions (text only, no misalignment monitor), Batch. `reasoning.mode:"pro"`, `reasoning.context:"all_turns"`, `text.verbosity`, `service_tier: fast\|priority\|flex`, `async:true` tools, `configuration_update` input item (change effort mid-conversation without breaking cache), `prompt_cache_options:{mode:"explicit",ttl:"30m"}` (30m is the only TTL and the default; cache write $12.50/M) + up to 4 `prompt_cache_breakpoint`. Removed: `temperature`, `top_p`, `logprobs`, `prompt_cache_retention` |
| rate limits | Tier 1 500 RPM / 500K TPM ... Tier 5 15K RPM / 40M TPM; Free tier unsupported |
| Codex | CLI >= 0.153.0 (official floor), 0.153.4 recommended (`-m gpt-6-astra`; 0.153.0 made child agents inherit the root `service_tier`, issue 42665); Codex context window 272K (max 872K); `features.context_management.experimental_mode = true` in `~/.codex/config.toml` = notes + searchable history instead of compaction (ChatGPT Plus/Pro/Pro Lite sign-in only, Codex backend only, off by default, "default for Astra in coming weeks"); non-blocking clarifying questions; estimated local messages per 5h: Plus 3-30, Pro 5x 15-150, Pro 20x 60-600 |
| safety | Preparedness **Critical** for cyber. Standard Astra refuses PoC exploit creation; secure review and patching allowed. Daybreak Blue = `gpt-daybreak-blue-latest` (= 5.6 Sol), Red = `gpt-daybreak-red-latest` (`gpt-5.6-cyber`); "reduced refusals aren't available on Astra for most Daybreak customers". Runtime misalignment monitor: **API task STOPS** (`403 misalignment_policy_violation`, do not retry; `cyber_policy`; stream event `safety.alert.created`), ChatGPT/Codex pause for review instead. ZDR for eligible API customers |

Benchmarks that matter for routing (official max-at-any-effort unless noted): Terminal-Bench 4.0 57.9 (Fable 5.1 55.8, Sol 37.3); Terminal-Bench-Science 64.6 (52.6); DeepSWE 74.1 (Fable 5.1 67.4, Opus 5 73.7, Gemini 3.8 Flash 73.8); OSWorld 2.0 72.6 at ~40 min/task (Sol 65.7 at ~75, Opus 5 70.2); BrowseComp 91.5; AutomationBench 41.4 (Fable 5.1 31.4); FrontierMath T4 97.6; HLE w/ tools 57.2 (**Fable 5.1 65.0**). Independent (AA 09-03): Intelligence Index 61 = Sol, Fable 5.1 66; Coding Agent Index 67 (Fable 5.1 70, Opus 5 68); **Agentic sub-index 51 vs Sol 58**; hallucination 51% (Sol 92%); cost per index task medium $0.75 / high $0.96 / xhigh $1.20 / max $1.67 (Sol max $0.95, Fable 5.1 max $3.76); tokens 1/3 of Sol max on coding. ARC-AGI-3: 62.7% standard harness, 99.9% only with OpenAI's state-preserving Responses adapter (harness > effort). Practitioner telemetry (Theo/Ben, weeks of pre-release Codex use): user-correction rate Astra 11.3% of threads, Sol 11.6%, Fable 5 7.0%; shell failures per 100 commands Astra 7.5, Sol 12.9, Fable 2.1; up to 4x slower than Fable on simple asks (verification loops). Prompting and routing card → `examples/openai.md`.

## Text / reasoning
**GPT-5.6 family** (**Sol/Terra/Luna = flagship/balanced/cheap tiers**; `-pro` = same model with `reasoning.mode:"pro"`). **Route: codex CLI OAuth (sub-billed, see codex section) > OpenRouter (`openai/gpt-5.6-sol` etc., per-token, for `-pro`/scripts/structured output) > direct API (still preview-gated for us, use `gpt-5.5`; retest `/v1/models` ~mid-July 2026).**
| id | in | cached | out | use |
|---|---|---|---|---|
| `gpt-5.6-sol` | 4.00 | 0.40 | 20.00 | **flagship, price CUT 2026-08-21** (was 5/0.50/30; promo held through at least 2026-11-21; >272k prompt = 2x in / 1.5x out; cache write 1.25x; OpenRouter lists $2/$10 with cache read $0.20 on 2026-09-02) (1.05M ctx / 128k out, cutoff 2026-02); agentic/terminal coding, computer use |
| `gpt-5.6-terra` | 2.50 |, | 15.00 | **value pick**: ~5.5-class at half price |
| `gpt-5.6-luna` | 1.00 |, | 6.00 | fast/cheap tier |
| `gpt-5.5` | 5.00 | 0.50 | 30.00 | prior flagship; **still the direct-API workhorse until 5.6 opens there** |
| `gpt-5.5-pro` | 30.00 | 3.00 | 180.00 | hardest reasoning (old-style separate pro) |
| `gpt-5.4` / `-mini` / `-nano` | 2.50/0.75/0.20 | | 15/4.5/1.25 | cheaper general / cost / cheapest; **pulled from Codex CLI (ChatGPT login) 2026-08-31** → use gpt-5.6-terra / -luna |

5.6 new knobs (developers.openai.com latest-model guide): `reasoning_effort` gains **`max`**; `reasoning.mode:"pro"`; **Ultra mode** (parallel subagent spawning, beta, the Terminal-Bench 88.8→91.9 lift); `reasoning_context: all_turns` (persists reasoning across turns); programmatic tool calling; explicit prompt caching. Prompting → `examples/openai.md`.
**CAUTION (METR predeployment eval, 2026-06-26): Sol's reward-hacking rate = highest METR ever measured on a public model** (exfiltrated hidden test suites, gamed checks). Sandbox it; never accept its own test results as evidence; OpenAI's agentic bench numbers not independently reproduced.

On the **`codex` CLI (ChatGPT login)**: `-m gpt-5.6-sol` / `-terra` / `-luna` (bare `gpt-5.6` 400s, always the full tier id). Effort: `-c model_reasoning_effort=none..max`. Prompt via stdin, `--skip-git-repo-check` outside a repo. Fallback `gpt-5.5`. Codex CLI 0.153.2 installed 2026-09-04 (0.153.x = hidden Astra catalog entry, Guardian, context-management flag; 0.152: 0.149-0.152 added task mentions, MCP/plugin fixes, credential refresh, rate-limit banners, long shell timeout); `npm i -g @openai/codex` to update. A 400 "not supported" = wrong id or codex CLI < 0.144.0 (update via `volta install @openai/codex@latest`), not a bad prompt. Verified 2026-07-10.

## CODEX models (agentic coding), **Responses API + API key only**
Live ids (`/v1/models`): `gpt-5.3-codex` (latest), `gpt-5.2-codex`, `gpt-5.1-codex-max`, `gpt-5.1-codex`, `gpt-5.1-codex-mini`, `gpt-5-codex`. **There is NO `gpt-5.5-codex`.** They are **not chat models**: `chat/completions` 400s ("use v1/responses"). Call:
```bash
curl -s https://api.openai.com/v1/responses -H "Authorization: Bearer $OPENAI_API_KEY" -H 'content-type: application/json' \
  -d '{"model":"gpt-5.3-codex","input":"<task>"}' | jq -r '.output_text // .output[].content[].text'
```
~$1.75 in / $14 out (5.3-codex). Use for heavy agentic coding when you want OpenAI's coder via the key; the `codex` CLI (OAuth) covers the interactive path.

## REALTIME AUDIO, `gpt-realtime-2.1` (GA, WebSocket; refreshed 2026-07-09)
Speech-to-speech / text→audio. **Client: `_model-cache/realtime_openai.py`** (raw `websockets`; **E2E-verified with `gpt-realtime-2.1-mini` 2026-07-09**, protocol unchanged). URL `wss://api.openai.com/v1/realtime?model=gpt-realtime-2.1`, header `Authorization: Bearer $OPENAI_API_KEY`, **NO `OpenAI-Beta` header on GA**.
| id | status | notes |
|---|---|---|
| `gpt-realtime-2.1` | **GA, default** (shipped 2026-07-06) | **128k ctx / 32k out** (old GA was 32k/4k); configurable reasoning effort; better alphanumerics, interruption, noise handling; text+audio+image in |
| `gpt-realtime-2.1-mini` | GA, **price-performance pick** | audio **$10 in / $20 out**, text $0.60/$2.40; ~1.3-1.7x Gemini Live output cost with GPT-class tool use |
| `gpt-realtime` (snap `-2025-08-28`), `-2`, `-1.5`, `-mini` | GA, superseded | all still live in `/v1/models` (verified); playground reportedly still defaults to `-2`, so pass explicit ids |
| `gpt-realtime-translate` / `-whisper` | GA | streaming translate / transcribe, billed per minute: **$0.034/min / $0.017/min** |
| `GPT-Live-1` / `-1-mini` | **ChatGPT only, API waitlist** (announced 2026-07-08) | full-duplex (listens while speaking), replaces Advanced Voice Mode; delegates reasoning to GPT-5.5 in background; expect a NEW duplex API shape, form: openai.com/form/gpt-live-1-in-the-api/ |
Flow (unchanged in 2.1): `session.update` (**`format` is an OBJECT** `{"type":"audio/pcm","rate":24000}`, `output_modalities:["audio"]`, `voice`) → `conversation.item.create` (input_text) → **`response.create`** (mandatory) → collect `response.output_audio.delta` (base64 PCM16 24kHz) until `response.done`. Pricing (`gpt-realtime-2.1`): **audio $32 in / $64 out**, text $4 in / **$24 out** (was $16 on old GA), cached $0.40 per 1M. Latency: p95 cut ≥25% vs `-2` (official claim). Browser → ephemeral `ek_` token via `POST /v1/realtime/client_secrets`. `websockets`<13 uses `extra_headers`, ≥13 `additional_headers`. Reasoning-effort session field name unverified, check the realtime guide before relying on it.

## IMAGE
| id | notes |
|---|---|
| `gpt-image-2` (snap `-2026-04-21`) | **default** |
| `gpt-image-1.5` | native transparency (`--background transparent`) |
| `gpt-image-1-mini`, `chatgpt-image-latest` | cheaper / chatgpt alias |
| ~~`gpt-image-1`~~ | **shutdown 2026-10-23** |
Pricing (`gpt-image-2`): 8.00 img-in / 5.00 text-in / 30.00 img-out per 1M; per-image 1024² ~$0.006 low / $0.053 med / $0.211 high. Codex CLI built-in tool works on OAuth; or `/v1/images/generations` with the key. Save path hardcoded to `~/.codex/generated_images/…` (CLI), `cp` it out.

## Why Codex for PROMPT-writing
GPT-5.5 is tuned for outcome-first, contractual prompts: goal → numbered hard constraints → exact answer shape; strips Opus's conversational defaults. More spec-like briefings → crisper execution from the target model.
