# OpenRouter, generic fallback route

Verified 2026-07-12 (`verify.sh` PASS: `google/gemini-3.1-flash-lite` via OpenRouter → routed via Google). One OpenAI-compatible endpoint that proxies **many providers** (OpenAI, Google, Anthropic, Meta, Mistral, …) behind a single key, use it as a **generic fallback** when a primary provider route throttles, errors, or a model id is regionally unavailable.

**Key:** `OPENROUTER_API_KEY` (in `~/.zshrc`, `sk-or-…`), resolved via `_model-cache/lib.sh`.

## Call (OpenAI Chat Completions-compatible)
```bash
curl -s https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" -H 'content-type: application/json' \
  -d '{"model":"<provider/model>","messages":[{"role":"user","content":"…"}]}' \
  | jq -r '.choices[0].message.content'
```
- **Model id = `provider/model`**, e.g. `openai/gpt-5.5`, `google/gemini-3.5-flash`, `anthropic/claude-opus-4.8`, `openai/gpt-5.4-mini`, `google/gemini-3.1-flash-lite` (cheap). List: `GET https://openrouter.ai/api/v1/models` (no key needed) → `.data[].id`.
- **Early-access arbitrage: OpenRouter can serve models the direct API still gates**: when a headline model 403s direct, check here first. `openai/gpt-5.6-sol`/`-terra`/`-luna` (each ±`-pro`, 1.05M ctx; sol $5/$30, terra $2.50/$15, luna $1/$6) live here; **for 5.6 prefer codex CLI OAuth (sub-billed), use this route for `-pro`/API-key needs**. Facts + cautions → `openai.md`.
- Response includes `provider` (which upstream actually served it). Optional headers `HTTP-Referer` / `X-Title` for app attribution.
- Streaming, tools, and most OpenAI params pass through. Some providers drop unsupported fields silently.

## When to use as fallback
1. Primary route fails (provider throttle, 429, credits, regional block) → retry the same logical model via `provider/model` on OpenRouter.
2. You want a model you don't hold a direct key for (e.g. an Anthropic or Meta model) without a second account.
3. Cost arbitrage / provider routing, OpenRouter can auto-pick the cheapest healthy upstream.

## Cost
Pass-through upstream pricing **+ a small OpenRouter margin**; credits are prepaid on the OpenRouter account. For steady high-volume on one provider, a direct key is cheaper; OpenRouter wins on breadth + resilience. Check live per-model price in the `/models` response (`.data[].pricing`).

## Caveats
- Not every upstream model/feature is mirrored (image-gen, realtime audio, TTS, video are usually **direct-only**: OpenRouter is chat/text-first). Fall back here for **text/reasoning**, not for media endpoints.
- Latency adds one proxy hop.

## Many models on one question = many calls
Fire one call per model, in parallel, and compare the answers yourself (that is what `/board` does). One seat hanging or returning empty then costs you that seat, not the whole answer, and you keep every raw answer instead of a synthesis you cannot audit.

Other `openrouter/*` meta-routers (live): `openrouter/auto` (picks one best model), `openrouter/pareto-code` (cost/quality code router), `openrouter/free` (free-tier only), plus betas `owl-alpha`, `bodybuilder`.

**Grok / xAI on OpenRouter** (`x-ai/`, verified live 2026-07-09, in/out per 1M tok): `grok-4.5` ($2.00/$6.00, cached-in $0.50, **latest flagship, released 2026-07-08**, 500k context (down from 4.3's 1M), text+image in, reasoning_effort low/med/high + tools + structured_outputs pass through OpenRouter; xAI's smartest by a wide margin: Artificial Analysis index 54 = #4 overall behind Fable 5 (60), Opus 4.8 (56), GPT-5.5 (55); **#1 of 28 on agentic tool use**; headline trait = token efficiency, ~16k output tok/SWE-Bench-Pro task vs ~67k Opus 4.8, so the 2.4x output price partly cancels. **EU REGION-BLOCKED as of 2026-07-09** (xAI 403 "not available in your region"; block follows the CLIENT IP, OpenRouter egresses from a Cloudflare edge near you, so a US proxy fixes it; press says EU access "expected mid-July"). **Seat default**; the self-healing chain (direct → US-proxy retry → 4.3 fallback) lives in `openrouter-bridge/ask.sh`, mechanics documented in its header; E2E-verified via proxy 2026-07-09, served `x-ai/grok-4.5-20260708`. **How to drive it, route-to/away, effort dial, param traps, caching, prompt patterns → [`examples/grok.md`](examples/grok.md)**), `grok-4.3` ($1.25/$2.50, 1M ctx, prior flagship, the chain's fallback; smoke-tested OK 2026-07-09), `grok-build-0.1` ($1.00/$2.00, 2026-05, fast agentic-coding specialty, NOT a generalist), `grok-4.20` + `grok-4.20-multi-agent` ($1.25/$2.50, superseded). Re-check `x-ai/*` in `/models` when the seat errors; xAI rotates ids. `~x-ai/grok-latest` alias (live 2026-07) tracks the newest flagship, self-updating alternative for `OPENROUTER_GROK_MODEL` if pin-drift bites again.

**Kimi / Moonshot on OpenRouter** (`moonshotai/`, verified live 2026-07-16, in/out per 1M tok): `kimi-k3` ($3.00/$15.00, cache-read $0.30, **released 2026-07-15**, 1M ctx, 2.8T-param open-weight multimodal reasoner, largest open model to date; reasoning MANDATORY, only effort `max`, no `temperature`/`top_p`; day-zero 3rd-party: GDPval-AA v2 1687 = above Opus 4.8 Max, below Fable 5 Max / GPT-5.6 Sol Max; AA-Briefcase 1527 #2 behind Fable 5 Max; no AA index yet. Single upstream (Moonshot) with launch-window 429 waves, retry w/ backoff; E2E via ask.sh OK 2026-07-16. Priced Sonnet-tier = 3-5x other Chinese opens, reasoning-token bloat reported on K2 lineage. **Board: opt-in high-stakes extra seat, NOT default; flip conditions + drive-it details → [`examples/kimi.md`](examples/kimi.md)**), `kimi-k2.7-code` ($0.75/$3.50, coding specialist, AA coding 60.8 / agentic 29.6), `kimi-k2.6` ($0.95/$4.00, prior generalist flagship; price drifted up from $0.66/$3.41).

**The 2026-08 cheap tier** (verified live 2026-08-12, in/out per 1M tok; full writeups in [`research/2026-08-12/`](research/2026-08-12/)). A wave of sub-$0.30 models landed since July. Most of them cannot do the one job they look perfect for, so the verdicts matter more than the prices:
- `deepseek/deepseek-v4-flash-0731` ($0.08/$0.18, cache $0.016, 1M ctx) **the pick of the tier.** AA index 52, 3rd among open weights, 24 endpoints so no single-provider risk, 19 of them do strict schema. The dated slug is both newer AND cheaper than the plain `deepseek-v4-flash` alias (which is the pinned April build, not a floating pointer). Caveat: its index is measured at max reasoning effort, and reasoning bills as output.
- `openai/gpt-5.6-luna` ($0.10/$0.60, 1.05M ctx) OpenAI's cheap tier, strict schema, fast (measured ~12s on a task where others took minutes).
- `nvidia/nemotron-3.5-lightning` ($0.10/$0.25, 262k ctx) ~670 tok/s, OpenMDW-1.1 licence, but AA index 24 is thin. Context is contested (262k on OR vs 1M per AA) and quantisation differs by host.
- `inclusionai/ling-3.0-flash` ($0.021/$0.063) **unusable for structured work**: max output 32,768 and NEITHER `structured_outputs` NOR `response_format` on either provider. Same gap on `meituan/longcat-2.0` (plus a single upstream).
- `qwen/qwen3.7-flash` ($0.03/$0.13) **the price is conditional**: that rate applies below a 32k prompt, above it $0.10/$0.40 and above 256k $0.20/$0.80. No `structured_outputs` on OR despite the model card, 65,536 max output, one provider, P99 ~90s. Closed weights, no technical report.
- `upstage/solar-pro4` ($0.03/$0.12) **not open weights** (API only), the $0.03 is a promotion expiring **2026-09-10** after which list is $0.30/$1.20, and supported languages are Korean, English, Japanese only.
- `minimax/minimax-m3` ($0.30/$1.20) and `google/gemini-3.5-flash-lite` ($0.30/$2.50) are the sane mid rungs; Gemini's `:batch` twin halves it again.

**Gemini ladder on OpenRouter** (every rung has a `:batch` twin at 50% off, all strict-schema capable once you drop integer enums): `gemini-2.5-flash-lite` $0.10/$0.40 (batch $0.05/$0.20, the cheapest capable Gemini), `gemini-3.1-flash-lite` $0.25/$1.50, `gemini-3.5-flash-lite` $0.30/$2.50, `gemini-3.5-flash` $1.50/$9.00, `gemini-3.6-flash` $1.50/$7.50 (current stable flash, released 2026-07-21), `gemini-3.1-pro-preview` $2.00/$12.00 (still the Pro tier, still preview).

**Anthropic and OpenAI flagships are all on OpenRouter too**, which matters for bake-offs: one key and one call shape for `anthropic/claude-fable-5` ($10/$50), `claude-opus-5` ($5/$25, released 2026-07-24), `claude-sonnet-5` ($2/$10, the planned September rise to $3/$15 was cancelled), `claude-haiku-4.5` ($1/$5), `openai/gpt-5.6-sol` ($5/$30), `-terra` ($1/$6), `-luna` ($0.10/$0.60). `claude-opus-4.8` is now priced identically to Opus 5, so there is no cheaper-seat argument left for it. **METR measured `gpt-5.6-sol` with the highest eval-cheating rate of any publicly tested model**: fine as a panel seat, never as the judge of its own work.

**Latest GLM family on OpenRouter** (`z-ai/`, in/out per 1M tok): `glm-5.2` ($0.95/$3.00, newest flagship), `glm-5.1` ($0.98/$3.08), `glm-5` ($0.60/$1.92), `glm-5-turbo`/`glm-5v-turbo` ($1.20/$4.00), `glm-4.7` ($0.40/$1.75), `glm-4.7-flash` ($0.06/$0.40, cheapest), `glm-4.5-air` ($0.13/$0.85). **Cheap, strong, non-OAI/Anthropic/Google** board-diversity picks: `deepseek/deepseek-v4-pro` ($0.435/$0.87, beats GPT-5.5+Opus solo on DRACO), `deepseek/deepseek-v4-flash` ($0.09/$0.18), `minimax/minimax-m2.5` ($0.15/$0.90), `qwen/*`, `mistralai/mistral-large-2512` ($0.50/$1.50). Kimi picks moved to the Moonshot block above.
