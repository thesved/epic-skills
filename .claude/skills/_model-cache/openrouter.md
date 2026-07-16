# OpenRouter - generic fallback route

Verified 2026-07-12 (`verify.sh` PASS: `google/gemini-3.1-flash-lite` via OpenRouter → routed via Google). One OpenAI-compatible endpoint that proxies **many providers** (OpenAI, Google, Anthropic, Meta, Mistral, …) behind a single key - use it as a **generic fallback** when a primary provider route throttles, errors, or a model id is regionally unavailable.

**Key:** `OPENROUTER_API_KEY` (in `~/.zshrc`, `sk-or-…`), resolved via `_model-cache/lib.sh`.

## Call (OpenAI Chat Completions-compatible)
```bash
curl -s https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" -H 'content-type: application/json' \
  -d '{"model":"<provider/model>","messages":[{"role":"user","content":"…"}]}' \
  | jq -r '.choices[0].message.content'
```
- **Model id = `provider/model`**, e.g. `openai/gpt-5.5`, `google/gemini-3.5-flash`, `anthropic/claude-opus-4.8`, `openai/gpt-5.4-mini`, `google/gemini-3.1-flash-lite` (cheap). List: `GET https://openrouter.ai/api/v1/models` (no key needed) → `.data[].id`.
- **Early-access arbitrage: OpenRouter can serve models the direct API still gates** - when a headline model 403s direct, check here first. `openai/gpt-5.6-sol`/`-terra`/`-luna` (each ±`-pro`, 1.05M ctx; sol $5/$30, terra $2.50/$15, luna $1/$6) live here; **for 5.6 prefer codex CLI OAuth (sub-billed), use this route for `-pro`/API-key needs**. Facts + cautions → `openai.md`.
- Response includes `provider` (which upstream actually served it). Optional headers `HTTP-Referer` / `X-Title` for app attribution.
- Streaming, tools, and most OpenAI params pass through. Some providers drop unsupported fields silently.

## When to use as fallback
1. Primary route fails (provider throttle, 429, credits, regional block) → retry the same logical model via `provider/model` on OpenRouter.
2. You want a model you don't hold a direct key for (e.g. an Anthropic or Meta model) without a second account.
3. Cost arbitrage / provider routing - OpenRouter can auto-pick the cheapest healthy upstream.

## Cost
Pass-through upstream pricing **+ a small OpenRouter margin**; credits are prepaid on the OpenRouter account. For steady high-volume on one provider, a direct key is cheaper; OpenRouter wins on breadth + resilience. Check live per-model price in the `/models` response (`.data[].pricing`).

## Caveats
- Not every upstream model/feature is mirrored (image-gen, realtime audio, TTS, video are usually **direct-only** - OpenRouter is chat/text-first). Fall back here for **text/reasoning**, not for media endpoints.
- Latency adds one proxy hop.

## Fusion - panel+judge deliberation router (verified live 2026-06-25)
`openrouter/fusion` turns one prompt into a small multi-model deliberation: a **panel** of 1-8 models answers in parallel (web search + fetch enabled), then a **judge** model compares them (consensus / contradictions / coverage gaps / unique insights / blind spots) and writes the final answer. A "mini board" in a single API call. Same Chat-Completions endpoint; pricing is **dynamic** (`-1` in `/models`) - billed as the sum of the underlying calls, ≈4-5× one completion at the default 3-model panel.

Two ways to invoke (panel + judge are fully configurable both ways):
```bash
# A) model alias + plugins (simplest)
curl -s https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" -H 'content-type: application/json' \
  -d '{"model":"openrouter/fusion",
       "messages":[{"role":"user","content":"…"}],
       "plugins":[{"id":"fusion",
                   "analysis_models":["z-ai/glm-5.2","deepseek/deepseek-v4-pro"],
                   "model":"z-ai/glm-5.2"}]}' \
  | jq -r '.choices[0].message.content'
# B) server tool on your own outer model: {"model":"~anthropic/claude-opus-latest",
#    "tools":[{"type":"openrouter:fusion","parameters":{"analysis_models":[…],"model":"<judge>"}}]}
```
Plugin/param keys: `analysis_models` (panel, 1-8, default `~anthropic/claude-opus-latest` + `~openai/gpt-latest` + `~google/gemini-pro-latest`); `model` (judge, runs at temp 0, also writes the final answer when using `openrouter/fusion`); `preset` (`general-high` / `general-budget` auto-configures panel+judge); `max_tool_calls` (1-16, default 8); `reasoning`/`temperature`/`max_completion_tokens` forwarded to inner calls. Panel/judge **cannot recursively call fusion** (`x-openrouter-fusion-depth` guard). With the server-tool form the outer model decides when to fire it; `"tool_choice":"required"` forces it.

**Benchmark (OpenRouter DRACO, 100 deep-research tasks, blog "fusion-beats-frontier", 2026):** best fused panel 69.0% > every solo model (Fable 5 65.3, DeepSeek-V4-Pro 60.3, GPT-5.5 60.0, Opus 4.8 58.8); a **budget panel** (Gemini-3-Flash + Kimi-K2.6 + DeepSeek-V4-Pro) hit 64.7% - within ~1% of Fable 5 at ~50% cost. Even self-pairing Opus gained +6.7pts. Use Fusion for research / high-stakes / compare-and-contrast; skip for simple lookups, code-gen (style drift), creative writing (voice dilution).

**Caveat - triangulation:** some 3rd-party guides (e.g. digitalapplied.com) say Fusion is "web UI only, no API yet." **Outdated** - the API + `plugins` config above is live and verified. The `openrouter.ai/labs/fusion` playground also exists for interactive panel building.

Other `openrouter/*` meta-routers (live): `openrouter/auto` (picks one best model), `openrouter/pareto-code` (cost/quality code router), `openrouter/free` (free-tier only), plus betas `owl-alpha`, `bodybuilder`.

**Grok / xAI on OpenRouter** (`x-ai/`, verified live 2026-07-09, in/out per 1M tok): `grok-4.5` ($2.00/$6.00, cached-in $0.50, **latest flagship, released 2026-07-08**, 500k context (down from 4.3's 1M), text+image in, reasoning_effort low/med/high + tools + structured_outputs pass through OpenRouter; xAI's smartest by a wide margin: Artificial Analysis index 54 = #4 overall behind Fable 5 (60), Opus 4.8 (56), GPT-5.5 (55); **#1 of 28 on agentic tool use**; headline trait = token efficiency, ~16k output tok/SWE-Bench-Pro task vs ~67k Opus 4.8, so the 2.4x output price partly cancels. **EU REGION-BLOCKED as of 2026-07-09** (xAI 403 "not available in your region"; block follows the CLIENT IP - OpenRouter egresses from a Cloudflare edge near you - so a US proxy fixes it; press says EU access "expected mid-July"). **Seat default**; the self-healing chain (direct → US-proxy retry → 4.3 fallback) lives in `openrouter-bridge/ask.sh`, mechanics documented in its header; E2E-verified via proxy 2026-07-09, served `x-ai/grok-4.5-20260708`. **How to drive it - route-to/away, effort dial, param traps, caching, prompt patterns → [`examples/grok.md`](examples/grok.md)**), `grok-4.3` ($1.25/$2.50, 1M ctx, prior flagship, the chain's fallback; smoke-tested OK 2026-07-09), `grok-build-0.1` ($1.00/$2.00, 2026-05, fast agentic-coding specialty, NOT a generalist), `grok-4.20` + `grok-4.20-multi-agent` ($1.25/$2.50, superseded). Re-check `x-ai/*` in `/models` when the seat errors; xAI rotates ids. `~x-ai/grok-latest` alias (live 2026-07) tracks the newest flagship - self-updating alternative for `OPENROUTER_GROK_MODEL` if pin-drift bites again.

**Kimi / Moonshot on OpenRouter** (`moonshotai/`, verified live 2026-07-16, in/out per 1M tok): `kimi-k3` ($3.00/$15.00, cache-read $0.30, **released 2026-07-15**, 1M ctx, 2.8T-param open-weight multimodal reasoner, largest open model to date; reasoning MANDATORY, only effort `max`, no `temperature`/`top_p`; day-zero 3rd-party: GDPval-AA v2 1687 = above Opus 4.8 Max, below Fable 5 Max / GPT-5.6 Sol Max; AA-Briefcase 1527 #2 behind Fable 5 Max; no AA index yet. Single upstream (Moonshot) with launch-window 429 waves, retry w/ backoff; E2E via ask.sh OK 2026-07-16. Priced Sonnet-tier = 3-5x other Chinese opens, reasoning-token bloat reported on K2 lineage. **Board/fusion: opt-in high-stakes panel upgrade, NOT default; flip conditions + drive-it details → [`examples/kimi.md`](examples/kimi.md)**), `kimi-k2.7-code` ($0.75/$3.50, coding specialist, AA coding 60.8 / agentic 29.6), `kimi-k2.6` ($0.95/$4.00, prior generalist flagship; price drifted up from $0.66/$3.41).

**Latest GLM family on OpenRouter** (`z-ai/`, in/out per 1M tok): `glm-5.2` ($0.95/$3.00, newest flagship), `glm-5.1` ($0.98/$3.08), `glm-5` ($0.60/$1.92), `glm-5-turbo`/`glm-5v-turbo` ($1.20/$4.00), `glm-4.7` ($0.40/$1.75), `glm-4.7-flash` ($0.06/$0.40, cheapest), `glm-4.5-air` ($0.13/$0.85). **Cheap, strong, non-OAI/Anthropic/Google** board-diversity picks: `deepseek/deepseek-v4-pro` ($0.435/$0.87, beats GPT-5.5+Opus solo on DRACO), `deepseek/deepseek-v4-flash` ($0.09/$0.18), `minimax/minimax-m2.5` ($0.15/$0.90), `qwen/*`, `mistralai/mistral-large-2512` ($0.50/$1.50). Kimi picks moved to the Moonshot block above.
