# DeepSeek V4 Pro 0813 / V4 Flash 0731, drive-it guide

Verified 2026-08-21 (live OpenRouter probe + official api-docs + 24-video sweep + codex web lane; evidence in `../research/2026-08-21/`). Ids: OpenRouter **`deepseek/deepseek-v4-pro-0813`** and **`deepseek/deepseek-v4-flash-0731`** (pinned; the unsuffixed `deepseek/deepseek-v4-pro` / `-flash` on OpenRouter are STILL the April 0423 builds). Direct API: `deepseek-v4-pro` / `deepseek-v4-flash` are rolling aliases that already point at 0813 / 0731. Floating OpenRouter alias: `~deepseek/deepseek-v4-flash-latest` (tilde goes on the AUTHOR: `~deepseek/...`, not the slug).

## Route TO
- **Security / cyber / exploit-style agent tasks**: CyberGym 83.3 (= Fable 5 83.1); 6/6 exploit-task passes at $0.22 total vs Opus 4.8 1/1 at $4.18; runs internal security scans without the refusal-downgrade Claude/GPT show. Cheapest serious second opinion on security code.
- **Deep multi-file debugging / large-codebase navigation / architecture diagnosis** where latency does not matter: Pro finds and fixes multi-service bugs autonomously and self-verifies via headless browser.
- **Huge single-call output**: 384k max output (6x Gemini's 64k).
- **Cache-heavy agent loops**: automatic prefix caching, cache-hit ~3% of miss price; real dashboards show ~90% of spend saved (183.7M of 187.8M tokens were hits).
- **Board open-family seat** (architecture diversity, cheap).
- **Flash 0731**: bulk coding/scaffolding at ~$0.01-0.08 per task; the only model of 8 that shipped a real DB instead of a mock in a dashboard bake-off.

## Route AWAY
- **Anything needing vision**: text-only, hard 404 "No endpoints found that support image input". The `~/.dsh/settings.yaml` `input: [text, image]` trick only flags a CUSTOM provider; it does not give V4 eyes.
- **UI taste / SVG / visual polish**: SVG 5/10, Frontend Arena: Flash is the weakest named model (1586). Use Gemini 3.7 Flash, Sol, or Kimi K3 for looks.
- **Interactive / latency-sensitive work**: 50-90 tok/s, TTFT 1.6-2.9 s, 10k-token answer ~120 s (Gemini 3.7 Flash: 39 s).
- **Game physics / spatial reasoning / CAD manufacturability**: repeated demonstrated failures (collision, spawn logic, overhangs).
- **Strict-schema bulk extraction on OpenRouter**: `structured_outputs` is NOT advertised on the DeepSeek-hosted endpoint (only on Alibaba/Together/Parasail/Cloudflare/Fireworks re-hosts). Probe your schema per provider; live probe 2026-08-21 got valid JSON via Together.
- **Peak hours for bulk** (01:00-04:00 and 06:00-10:00 UTC): direct price doubles; at peak the blended agent cost ($0.69/M) is ABOVE Gemini 3.7 Flash ($0.58/M). Off-peak it is 1.7x cheaper.

## Settings that max it out
| lever | value | why |
|---|---|---|
| reasoning effort | **`high`** (default). `max` only for hard agent benches you can babysit | Max overthinks: 5-10 min reasoning on trivial asks, over-engineers one-line fixes into refactors, and in a 4-task suite Pro High (12.05/20, $0.04, 7:15) beat Pro Max (11.65/20, $0.05, 9:06). Flash: max IS required (4.1 to 6.7/10 jump) |
| effort syntax | Chat Completions: `reasoning_effort` (direct API maps `low`/`medium` to `high`, `xhigh` to `max`; OpenRouter: `reasoning: {effort: ...}` passes through, probe-verified). Anthropic-compatible: `output_config.effort`. Responses API: `reasoning.effort` | levels are really only high/max on the hosted API |
| thinking on/off | `thinking: {type: enabled|disabled}` | disabled = non-thinking price tier on direct API |
| temperature / top_p | do not set in thinking mode (ignored). Self-host/benchmark repro: temp 1.0, top_p 0.95 agentic / 1.0 otherwise | official model card |
| tool loops | **send `reasoning_content` back** with every assistant tool-call message | omitting it = HTTP 400 / broken trajectory (official) |
| JSON | `response_format: {type: json_object}` AND the word "json" in the prompt, plus schema/example in prompt; strict tool args only via `/beta` with every tool `strict: true` | arbitrary response schema enforcement not guaranteed; docs admit occasional empty output |
| provider on OpenRouter | **pin it**. 12 Pro / 30 Flash endpoints, 2x price spread, cache-read up to 10x apart, 10-160 tok/s, quantization fp4/fp8/unknown | Auto routing changes tokenizer counts (19 vs 111 prompt tokens for the same string) and reasoning-token behaviour between calls |
| harness | direct API (or DeepSeek Harness `npx @deepseek-ai/dsh web`, RC, breaking changes) beats proxies: 40/41 vs 37/41 pass and cheaper than OpenCode Zen; "OpenCode lobotomizes it" per practitioners | the 87.9 Terminal-Bench number was produced in DeepSeek Harness Minimal mode at max; neutral harness = ~79 |
| loop guard | always set `max_tokens`/step caps and a wall-clock kill | demonstrated infinite tool-call loops (20 min, manual kill) on both Pro and Flash |
| time of day | batch / bulk OFF-PEAK (10:00-01:00 and 04:00-06:00 UTC) | peak = 2x on every token type |

## Pricing (direct API, per 1M, since 2026-08-16 16:00 UTC)
| model | band | cache hit | cache miss | output |
|---|---|---|---|---|
| Flash | off-peak | $0.007 | $0.22 | $0.66 |
| Flash | peak | $0.014 | $0.44 | $1.32 |
| Pro | off-peak | $0.022 | $0.66 | $1.98 |
| Pro | peak | $0.044 | $1.32 | $3.96 |
Old flat: Flash $0.0028/$0.14/$0.28, Pro $0.003625/$0.435/$0.87. So off-peak output is 2.3x the old price and peak cache-hit is 12x. Most YouTube "$0.435/$0.87" numbers are pre-hike. OpenRouter's DeepSeek-hosted endpoint mirrors the peak/off-peak table by UTC hour; third-party re-hosts are flat ($1.19-1.32 / $3.56-3.96 Pro; $0.065-0.44 / $0.14-1.32 Flash).

**ACCOUNT TRAP (found 2026-08-21): our OpenRouter key cannot reach the DeepSeek first-party endpoint.** `provider.only: ["deepseek"]` returns 404 "No endpoints available matching your guardrail restrictions and data policy". Every DeepSeek call we make lands on a re-host at 1.2-2x the native price and without the native cache tier. Fix = account privacy settings (openrouter.ai/settings/privacy) or per-request `provider: {data_collection: "allow"}`; both are a data-policy decision, user's call.

## Flash vs Pro
AA index 52 vs 53; Pro leads official agent benches (Terminal-Bench 82.7 vs 87.9, DeepSWE 54.4 vs 62.7) but the gap is small in practice and no effort-matched comparison exists. Default: Flash (max) for routine coding, extraction, parallel workers; escalate to Pro (high) for architecture, hard debugging, security review, failed Flash attempts. **Cheap-tier rival after the hike: `openai/gpt-5.6-luna`** (medium = same score and cost as Flash max, faster; Luna max 17.5/20 at $0.10 vs Flash 12.6/20). For bulk structured extraction probe Luna first.

## DeepSeek Harness (dsh)
MIT, RC (0.1.0-rc.8 on 2026-08-21), `npx @deepseek-ai/dsh web`. Presets: Standard, PTC (TypeScript programmatic tool calling), Minimal (bash + str_replace_editor; the benchmark config), Creator. Provider-neutral (deepseek-official, OpenAI, Anthropic, custom gateways). Trajectory replay. Expect breaking changes; not a Claude Code replacement yet.
