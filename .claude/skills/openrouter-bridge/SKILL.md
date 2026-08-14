---
name: openrouter-bridge
description: >-
  Query any model on OpenRouter (one OpenAI-compatible key fronting 300+ models:
  GLM, DeepSeek, Qwen, Kimi, Llama, Mistral, plus OpenAI/Anthropic/Google).
  Use as a generic text/reasoning fallback when a primary provider throttles, to
  reach a model you hold no direct key for, or for cost arbitrage on bulk work.
  Triggers: "openrouter", "open router", "GLM", "DeepSeek", "Qwen", "Kimi",
  "Grok", "xAI", "ask grok", "ask openrouter", "route via openrouter", "cheap
  model", "fallback model". The /board skill uses this for its Grok and
  open-family seats.
argument-hint: '<prompt> | -m <model> <prompt> | --grok <prompt> | smoke (check key+endpoint)'
---

# OpenRouter - one key, 300+ models

One OpenAI-compatible endpoint proxying many providers behind a single prepaid key. This skill is a thin seat helper; **model ids, pricing, and call shape live in `~/.claude/skills/_model-cache/openrouter.md`** - read it before picking models, never hardcode ids in callers.

**Auth**: key `OPENROUTER_API_KEY` (`sk-or-...`), resolved via `_model-cache/lib.sh` (env -> `~/.zshrc` -> keychain `openrouter-api-key`). Keychain-safe: works when the session env has no key. First keychain read may prompt - click **Always Allow**.

## Modes

| Mode | Command | What it does |
|------|---------|--------------|
| plain | `bash openrouter-bridge/ask.sh <file-or-stdin>` | one model, default `z-ai/glm-5.2`. Override per call with `-m provider/model`, or session-wide with `OPENROUTER_MODEL`. |
| grok | `bash openrouter-bridge/ask.sh --grok <file-or-stdin>` | xAI seat, self-healing chain: latest flagship direct → US-proxy retry on region-block → prior flagship fallback (notes the substitution). Mechanics + envs documented in the `ask.sh` header; model facts in the cache. The /board Grok seat. |
| smoke | `bash openrouter-bridge/smoke.sh` | cheap single-model ping; verifies key + endpoint. |
| conv | `bash openrouter-bridge/conv.sh new\|msg\|show\|ls\|rm` | multi-turn conversation with persisted history (see below). |

Briefing comes from the file arg if it exists, else stdin.

## Multi-turn / steering (`conv.sh`)

The API is stateless: NO mid-generation steering exists. The honest equivalent of messaging a running sub-agent is chunked turns over a persisted messages file - every turn boundary is a steering point. Verified 2026-08-13 (turn-2 recall exact).

```bash
C=~/.claude/skills/openrouter-bridge/conv.sh
echo "<task chunk 1>" | bash $C new <name> -m provider/model   # creates ~/.openrouter-conv/<name>/
echo "<follow-up / correction>" | bash $C msg <name>            # full history re-sent, context kept
bash $C show <name> | ls | rm <name>
```
- Full history is re-billed each turn - prefer models with cache-read pricing for long chains; chunk autonomous work at natural checkpoints so every boundary can steer.
- A failed turn appends nothing (retry `msg` safely); raw responses kept as `rN.json` for diagnosis (`finish_reason`, `usage`).
- Need to redirect a LONG generation: run it in the background with `"stream":true`, kill curl, salvage the partial into the history marked `[aborted]`, re-send. Aborted tokens are billed; the server keeps nothing.
- For codex executors a REAL mid-turn channel exists: `codex-bridge/steer/steer.sh` (see that skill).

## Multiple models = multiple calls
Want several families on one question? Fire one `-m` call per model, in the BACKGROUND, and compare the answers yourself. That is what `/board` does; it keeps every seat's raw answer, and one slow or empty seat cannot take the others down with it.
```bash
bash openrouter-bridge/ask.sh -m z-ai/glm-5.2            /tmp/brief > /tmp/a.txt 2>&1 &
bash openrouter-bridge/ask.sh -m deepseek/deepseek-v4-pro /tmp/brief > /tmp/b.txt 2>&1 &
```

## When to use vs a direct provider
- **Use** when a primary route fails (429/credits/regional), you want a model you hold no direct key for, or for cost arbitrage.
- **Skip** for media (image-gen, realtime audio, TTS, video are usually direct-only - OpenRouter is chat/text-first) and for steady high-volume on one provider (a direct key is cheaper; OpenRouter adds a small margin + one proxy hop).

## Empty answer: what it is NOT, and how to diagnose it (measured 2026-08-03)

Seats occasionally return `http=200 finish=stop` with NO text, and the same seat can also hang past
10 minutes on the same brief. Three plausible causes were tested and **all three are ruled out**:

- **Not a token cap.** `ask.sh` sends no `max_tokens` at all.
- **Not a refusal.** The identical prompt (which asked which survey techniques are manipulative) sent
  by raw curl to the same model returned 6550 chars of content plus 2255 reasoning tokens.
- **Not "reasoning ate the answer".** grok-4.5 and deepseek-v4-pro both returned normal content
  alongside their reasoning on a raw call.

So an empty seat is a transient upstream/routing artifact. Diagnose in this order: (1) `smoke.sh`,
(2) re-send by RAW curl and print `.choices[0].message.content|length`, `.message.reasoning|length`,
`.usage.completion_tokens_details.reasoning_tokens` and `finish_reason` - the status line now prints
`content=Nch reasoning=Ntok` for exactly this reason, (3) if the raw call works, retry the seat or
switch model; do not conclude "the model refused". Run long seats in the BACKGROUND with your own
timeout: a hang in the foreground is indistinguishable from a slow answer.

**Do not set a default `max_tokens`.** On a reasoning model a low cap is spent on thinking and returns
`finish_reason=length` with EMPTY content - which looks exactly like the refusal you would then chase.
Cap output only when you genuinely want a short answer, and check `finish_reason` when you do.

## See also
- `_model-cache/openrouter.md` - call shape, live model/pricing lookup
- `/board` - uses this for the Grok seat (`--grok`) and the open-family seats (`-m`)
- `/gemini-bridge`, `/codex-bridge` - the other board seats
