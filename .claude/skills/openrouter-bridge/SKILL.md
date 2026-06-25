---
name: openrouter-bridge
description: >-
  Query any model on OpenRouter (one OpenAI-compatible key fronting 300+ models:
  GLM, DeepSeek, Qwen, Kimi, Llama, Mistral, plus OpenAI/Anthropic/Google) and
  drive OpenRouter Fusion - a panel+judge multi-model deliberation router that
  fans a prompt across several models and synthesizes a single best answer.
  Use as a generic text/reasoning fallback when a primary provider throttles, to
  reach a model you hold no direct key for, for cost arbitrage, or as a self-
  contained "mini board in one call" via Fusion. Triggers: "openrouter", "open
  router", "fusion", "model fusion", "openrouter/fusion", "GLM", "DeepSeek",
  "Qwen", "Kimi", "ask openrouter", "route via openrouter", "panel in one call",
  "cheap model", "fallback model". The /board skill uses this as its 4th seat.
argument-hint: '<prompt> | --fusion <prompt> | smoke (check key+endpoint)'
---

# OpenRouter - one key, 300+ models, + Fusion deliberation

One OpenAI-compatible endpoint proxying many providers behind a single prepaid key. This skill is a thin seat helper; **model ids, pricing, call shape, and the Fusion spec live in `~/.claude/skills/_model-cache/openrouter.md`** - read it before picking models, never hardcode ids in callers.

**Auth**: key `OPENROUTER_API_KEY` (`sk-or-...`), resolved via `_model-cache/lib.sh` (env -> `~/.zshrc` -> keychain `openrouter-api-key`). Keychain-safe: works when the session env has no key. First keychain read may prompt - click **Always Allow**.

## Modes

| Mode | Command | What it does |
|------|---------|--------------|
| plain | `bash openrouter-bridge/ask.sh <file-or-stdin>` | one model, default `z-ai/glm-5.2`. Override `OPENROUTER_MODEL=provider/model`. |
| fusion | `bash openrouter-bridge/ask.sh --fusion <file-or-stdin>` | `openrouter/fusion`: panel answers in parallel (web search on) -> judge synthesizes one answer. |
| smoke | `bash openrouter-bridge/smoke.sh` | cheap single-model ping; verifies key + endpoint (NOT fusion - that fans out paid calls). |

Briefing comes from the file arg if it exists, else stdin.

## Fusion (the panel-in-one-call)

`openrouter/fusion` runs N panel models (1-8) in parallel, then a judge model compares them (consensus / contradictions / coverage gaps / unique insights / blind spots) and writes the final answer. ~4-5x the cost of one completion at the default 3-model panel; billed as the sum of the underlying calls (dynamic pricing). OpenRouter's own DRACO benchmark: a fused panel beat every solo frontier model, and a budget panel landed within ~1% of top-tier at ~50% cost (see cache doc for figures).

**Panel + judge are env-overridable** (defaults chosen for max architecture diversity vs the rest of the board - all non-OpenAI/Anthropic/Google):
```bash
OPENROUTER_FUSION_PANEL="z-ai/glm-5.2,deepseek/deepseek-v4-pro"   # csv, 1-8 models
OPENROUTER_FUSION_JUDGE="z-ai/glm-5.2"                            # synthesizer that writes the answer
bash openrouter-bridge/ask.sh --fusion /tmp/brief
```
Add a 3rd panel model (e.g. `moonshotai/kimi-k2.6`) for more robustness at more cost. Use Fusion for research / high-stakes / compare-and-contrast prompts; skip it for simple lookups, code-gen (style drift), and creative writing (voice dilution).

## When to use vs a direct provider
- **Use** when a primary route fails (429/credits/regional), you want a model you hold no direct key for, for cost arbitrage, or you want Fusion's one-call panel.
- **Skip** for media (image-gen, realtime audio, TTS, video are usually direct-only - OpenRouter is chat/text-first) and for steady high-volume on one provider (a direct key is cheaper; OpenRouter adds a small margin + one proxy hop).

## See also
- `_model-cache/openrouter.md` - call shape, Fusion config, live model/pricing lookup
- `/board` - uses this as the 4th (Fusion) seat
- `/gemini-bridge`, `/codex-bridge` - the other board seats
