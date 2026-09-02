# Live probes 2026-09-02

## Gemini agentic video understanding (Interactions API)
Video `Uo9HDJQOVzQ` (20 min), model `gemini-3.7-flash`, same question both modes ("List the 3 tactics the presenter recommends, with timestamps").
- Static `generateContent` with `fileData.fileUri`: promptTokens 113,774 (video 113,751), thoughts 833, candidates 231, total 114,838; 15 s.
- Agentic `POST /v1beta/interactions` with `{model, input:[{type:"video", uri, processing:"agentic"},{type:"text", text}]}`: total 8,393 (thought 7,942, tool-use 123, input 76, output 252); 28 s; steps = processing_call, processing_result, thought, model_output. Same three timestamps (13:10/13:12, 16:04/16:05, 17:10), same content.
- `processing` on a `generateContent` part is rejected: `Unknown name "processing" at 'contents[0].parts[1]'`.
- Raw response saved as `probe-agentic-video.json`. Wired into `gemini-bridge/yt.sh` as `GEMINI_VIDEO=agentic`.

## OpenRouter model list (2026-09-02, `/api/v1/models`)
New since 2026-08-21: `anthropic/claude-fable-5.1` ($10/$50, cache $0.25, `:batch` $5/$25, created 2026-09-01 18:03 UTC), `z-ai/glm-5.3-flash` ($0.075/$0.25, cache $0.015, ctx 1,310,720, created 2026-08-26) + `:batch` + `~z-ai/glm-flash-latest`, `qwen/qwen3.8-flash` ($0.15/$0.47, 1M), `deepseek/deepseek-v4-flash-vision-exp` ($0.22/$0.66, 1M, created 2026-08-21), batch twins for deepseek-v4-pro-0813 / flash-0731 / kimi-k3 / gemma-4 / qwen3.8-2.4t, `tencent/hy4-preview`, `mistralai/devstral-2512`, `inception/mercury-2.5-preview`, `minimax/minimax-m3:free`, `thinkingmachines/inkling*`. OpenAI prices on OR: sol $2/$10 (cache $0.20), terra $2/$12, luna $0.20/$1.20 (August showed $0.10/$0.60). `google/gemini-3.7-flash` still $0.75/$3.75 with cache $0.075 (the "promo ends 08-27" claim was wrong).

## OpenRouter liveness (ask.sh, one-liner asking for model name + image support)
- `z-ai/glm-5.3-flash`: 8 s, 214 reasoning tokens, "OK GLM... primarily text-based, do not accept image input in my standard form".
- `qwen/qwen3.8-flash`: 13 s, 402 reasoning tokens, "I do not accept image input".
- `deepseek/deepseek-v4-flash-vision-exp`: 1 s, 39 reasoning tokens, "OK Claude and yes, I accept image input" (identity hallucination; image support matches the DeepSeek release note).

## Gemini list diff (`update.sh all`)
NEW gemini-3.5-transcribe, gemini-3.5-transcribe-live, gemini-omni-1.1-flash; REMOVED gemini-robotics-er-1.6-preview; 52 models. OpenAI list: no new gpt/image models. `.updated` bumped.

## Codex CLI
Installed 0.146.0; npm latest 0.152.1 (2026-09-01). Not upgraded (user's tool).

## Claude Code
Installed 2.1.258. Live system prompt for `claude-fable-5-1` (this session) contains: autonomous-operation block, Delivering-work block, progress line, writing rules, reporting-outcomes line, context-summarization reassurance, memory format; per-turn injections seen mid-session: batching nudge ("First privately list what you need next...") and the tool-output-visibility note; idle nudge ("The user hasn't heard from you in a while").

## Gemini billing
Prepaid balance hit zero after 93 video analyses (`Your prepayment credits are depleted`). Remaining 11 Fable videos and all 107 GLM videos analyzed via yt-dlp auto-captions (`--extractor-args "youtube:player_client=android"` is required; the default web client returns "The page needs to be reloaded") + `google/gemini-3.7-flash` through the OpenRouter key.
