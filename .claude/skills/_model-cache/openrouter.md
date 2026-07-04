# OpenRouter - generic fallback route

Verified 2026-06-13 (`verify.sh` PASS: `google/gemini-2.5-flash-lite` via OpenRouter → routed via Google). One OpenAI-compatible endpoint that proxies **many providers** (OpenAI, Google, Anthropic, Meta, Mistral, …) behind a single key - use it as a **generic fallback** when a primary provider route throttles, errors, or a model id is regionally unavailable.

**Key:** `OPENROUTER_API_KEY` (in `~/.zshrc`, `sk-or-…`), resolved via `_model-cache/lib.sh`.

## Call (OpenAI Chat Completions-compatible)
```bash
curl -s https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" -H 'content-type: application/json' \
  -d '{"model":"<provider/model>","messages":[{"role":"user","content":"…"}]}' \
  | jq -r '.choices[0].message.content'
```
- **Model id = `provider/model`**, e.g. `openai/gpt-5.5`, `google/gemini-3.5-flash`, `anthropic/claude-opus-4.8`, `openai/gpt-5.4-mini`, `google/gemini-2.5-flash-lite` (cheap). List: `GET https://openrouter.ai/api/v1/models` (no key needed) → `.data[].id`.
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

**Grok / xAI on OpenRouter** (`x-ai/`, verified live 2026-07-04, in/out per 1M tok): `grok-4.3` ($1.25/$2.50, **latest flagship reasoning model**, 1M context, text+image in; the /board Grok seat via `openrouter-bridge/ask.sh --grok`, override `OPENROUTER_GROK_MODEL`), `grok-build-0.1` ($1.00/$2.00, 2026-05, fast agentic-coding specialty, NOT a generalist), `grok-4.20` + `grok-4.20-multi-agent` ($1.25/$2.50, superseded). Re-check `x-ai/*` in `/models` when the seat errors; xAI rotates ids.

**Latest GLM family on OpenRouter** (`z-ai/`, in/out per 1M tok): `glm-5.2` ($0.95/$3.00, newest flagship), `glm-5.1` ($0.98/$3.08), `glm-5` ($0.60/$1.92), `glm-5-turbo`/`glm-5v-turbo` ($1.20/$4.00), `glm-4.7` ($0.40/$1.75), `glm-4.7-flash` ($0.06/$0.40, cheapest), `glm-4.5-air` ($0.13/$0.85). **Cheap, strong, non-OAI/Anthropic/Google** board-diversity picks: `deepseek/deepseek-v4-pro` ($0.435/$0.87, beats GPT-5.5+Opus solo on DRACO), `deepseek/deepseek-v4-flash` ($0.09/$0.18), `moonshotai/kimi-k2.6` ($0.66/$3.41), `minimax/minimax-m2.5` ($0.15/$0.90), `qwen/*`, `mistralai/mistral-large-2512` ($0.50/$1.50).
