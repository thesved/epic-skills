# OpenAI / Codex model cache

Verified 2026-06-13 - text, codex (Responses API), realtime audio all **passed `_model-cache/verify.sh` with a real `OPENAI_API_KEY`**. Cross-checked vs `developers.openai.com` + live `/v1/models`. Prices = USD per 1M tokens.

**Auth - two surfaces:**
1. **`codex` CLI = ChatGPT-account OAuth.** Models: `gpt-5.6-sol`/`-terra`/`-luna` + `gpt-5.5`; `-codex`/`-pro` ids and bare `gpt-5.6` 400. Used by `/codex-bridge` for prompt-writing + image-gen.
2. **`OPENAI_API_KEY` (now in `~/.zshrc`, len 164 `sk-proj…`).** Unlocks the full API: the `-codex` models (Responses API), Realtime, images, pricing tiers. Scripts resolve it via `_model-cache/lib.sh` (env → `~/.zshrc` → keychain).

## Text / reasoning
**GPT-5.6 family** (**Sol/Terra/Luna = flagship/balanced/cheap tiers**; `-pro` = same model with `reasoning.mode:"pro"`). **Route: codex CLI OAuth (sub-billed, see codex section) > OpenRouter (`openai/gpt-5.6-sol` etc., per-token, for `-pro`/scripts/structured output) > direct API (still preview-gated for us, use `gpt-5.5`; retest `/v1/models` ~mid-July 2026).**
| id | in | cached | out | use |
|---|---|---|---|---|
| `gpt-5.6-sol` | 5.00 | 0.50 | 30.00 | **new flagship** (1.05M ctx / 128k out, cutoff 2026-02); agentic/terminal coding, computer use; long-ctx tier $10/$45 |
| `gpt-5.6-terra` | 2.50 | - | 15.00 | **value pick**: ~5.5-class at half price |
| `gpt-5.6-luna` | 1.00 | - | 6.00 | fast/cheap tier |
| `gpt-5.5` | 5.00 | 0.50 | 30.00 | prior flagship; **still the direct-API workhorse until 5.6 opens there** |
| `gpt-5.5-pro` | 30.00 | 3.00 | 180.00 | hardest reasoning (old-style separate pro) |
| `gpt-5.4` / `-mini` / `-nano` | 2.50/0.75/0.20 | | 15/4.5/1.25 | cheaper general / cost / cheapest |

5.6 new knobs (developers.openai.com latest-model guide): `reasoning_effort` gains **`max`**; `reasoning.mode:"pro"`; **Ultra mode** (parallel subagent spawning, beta - the Terminal-Bench 88.8→91.9 lift); `reasoning_context: all_turns` (persists reasoning across turns); programmatic tool calling; explicit prompt caching. Prompting → `examples/openai.md`.
**CAUTION (METR predeployment eval, 2026-06-26): Sol's reward-hacking rate = highest METR ever measured on a public model** (exfiltrated hidden test suites, gamed checks). Sandbox it; never accept its own test results as evidence; OpenAI's agentic bench numbers not independently reproduced.

On the **`codex` CLI (ChatGPT login)**: `-m gpt-5.6-sol` / `-terra` / `-luna` (bare `gpt-5.6` 400s - always the full tier id). Effort: `-c model_reasoning_effort=none..max`. Prompt via stdin, `--skip-git-repo-check` outside a repo. Fallback `gpt-5.5`. A 400 "not supported" = wrong id or codex CLI < 0.144.0 (update via `volta install @openai/codex@latest`), not a bad prompt. Verified 2026-07-10.

## CODEX models (agentic coding) - **Responses API + API key only**
Live ids (`/v1/models`): `gpt-5.3-codex` (latest), `gpt-5.2-codex`, `gpt-5.1-codex-max`, `gpt-5.1-codex`, `gpt-5.1-codex-mini`, `gpt-5-codex`. **There is NO `gpt-5.5-codex`.** They are **not chat models** - `chat/completions` 400s ("use v1/responses"). Call:
```bash
curl -s https://api.openai.com/v1/responses -H "Authorization: Bearer $OPENAI_API_KEY" -H 'content-type: application/json' \
  -d '{"model":"gpt-5.3-codex","input":"<task>"}' | jq -r '.output_text // .output[].content[].text'
```
~$1.75 in / $14 out (5.3-codex). Use for heavy agentic coding when you want OpenAI's coder via the key; the `codex` CLI (OAuth) covers the interactive path.

## REALTIME AUDIO - `gpt-realtime-2.1` (GA, WebSocket; refreshed 2026-07-09)
Speech-to-speech / text→audio. **Client: `_model-cache/realtime_openai.py`** (raw `websockets`; **E2E-verified with `gpt-realtime-2.1-mini` 2026-07-09**, protocol unchanged). URL `wss://api.openai.com/v1/realtime?model=gpt-realtime-2.1`, header `Authorization: Bearer $OPENAI_API_KEY`, **NO `OpenAI-Beta` header on GA**.
| id | status | notes |
|---|---|---|
| `gpt-realtime-2.1` | **GA, default** (shipped 2026-07-06) | **128k ctx / 32k out** (old GA was 32k/4k); configurable reasoning effort; better alphanumerics, interruption, noise handling; text+audio+image in |
| `gpt-realtime-2.1-mini` | GA, **price-performance pick** | audio **$10 in / $20 out**, text $0.60/$2.40; ~1.3-1.7x Gemini Live output cost with GPT-class tool use |
| `gpt-realtime` (snap `-2025-08-28`), `-2`, `-1.5`, `-mini` | GA, superseded | all still live in `/v1/models` (verified); playground reportedly still defaults to `-2`, so pass explicit ids |
| `gpt-realtime-translate` / `-whisper` | GA | streaming translate / transcribe, billed per minute: **$0.034/min / $0.017/min** |
| `GPT-Live-1` / `-1-mini` | **ChatGPT only, API waitlist** (announced 2026-07-08) | full-duplex (listens while speaking), replaces Advanced Voice Mode; delegates reasoning to GPT-5.5 in background; expect a NEW duplex API shape, form: openai.com/form/gpt-live-1-in-the-api/ |
Flow (unchanged in 2.1): `session.update` (**`format` is an OBJECT** `{"type":"audio/pcm","rate":24000}`, `output_modalities:["audio"]`, `voice`) → `conversation.item.create` (input_text) → **`response.create`** (mandatory) → collect `response.output_audio.delta` (base64 PCM16 24kHz) until `response.done`. Pricing (`gpt-realtime-2.1`): **audio $32 in / $64 out**, text $4 in / **$24 out** (was $16 on old GA), cached $0.40 per 1M. Latency: p95 cut ≥25% vs `-2` (official claim). Browser → ephemeral `ek_` token via `POST /v1/realtime/client_secrets`. `websockets`<13 uses `extra_headers`, ≥13 `additional_headers`. Reasoning-effort session field name unverified - check the realtime guide before relying on it.

## IMAGE
| id | notes |
|---|---|
| `gpt-image-2` (snap `-2026-04-21`) | **default** |
| `gpt-image-1.5` | native transparency (`--background transparent`) |
| `gpt-image-1-mini`, `chatgpt-image-latest` | cheaper / chatgpt alias |
| ~~`gpt-image-1`~~ | **shutdown 2026-10-23** |
Pricing (`gpt-image-2`): 8.00 img-in / 5.00 text-in / 30.00 img-out per 1M; per-image 1024² ~$0.006 low / $0.053 med / $0.211 high. Codex CLI built-in tool works on OAuth; or `/v1/images/generations` with the key. Save path hardcoded to `~/.codex/generated_images/…` (CLI) - `cp` it out.

## Why Codex for PROMPT-writing
GPT-5.5 is tuned for outcome-first, contractual prompts: goal → numbered hard constraints → exact answer shape; strips Opus's conversational defaults. More spec-like briefings → crisper execution from the target model.
