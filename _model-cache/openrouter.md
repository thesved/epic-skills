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
