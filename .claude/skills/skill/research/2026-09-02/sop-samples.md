# Same finding, three SOPs (sealed input 01.md)

Read the outputs, decide with your own eyes which reads best. Source passage first.

## Source

# Claude Fable 5

Most capable widely released Anthropic model. GA on Claude API, Bedrock, Claude Platform on AWS,
Google Cloud, Microsoft Foundry from 2026-06-09. Reliable knowledge cutoff Jan 2026. [S1]

Drive it well
- Adaptive thinking is always on and cannot be turned off. `output_config.effort` is the only real dial. [S1][S4]
- Start at `high` (the default). `xhigh` for the most capability-sensitive work, `medium`/`low` for routine.
  Docs claim low-effort Fable 5 often beats `xhigh` on prior models. [S4]
- `max_tokens` is a hard limit on total output, thinking plus response text. At `high`/`xhigh` set it large
  or you truncate mid-answer. [S4]
- Min cacheable prompt 512 tokens, same as Opus 5. [S5]

Strongest: raw capability, long-horizon agents, 1M context at flat pricing.
Weakest: $50/MTok output is 5x Sonnet 5 and 40x Luna. Slowest latency tier in the lineup. [S1][S2]

Gotchas
- Uses the Opus 4.7 tokenizer: the same text produces roughly 30% more tokens than pre-4.7 models. A
  price comparison against Sonnet 4.6 or older on a per-dollar basis understates Fable/Opus 5 cost by
  about 30%. This is the single most under-noticed cost item in the lineup. [S1][S2]
- `thinking.type: "enabled"` (classic extended thinking) is NOT supported. Only adaptive thinking. [S1]

## Output under seed v2 (your corrected taste, hand-written)

Claude Fable 5 is Anthropic’s strongest widely released model, best for capability-sensitive long-horizon agents with 1M-context flat pricing, but expensive and slow.

**Availability:** Claude Fable 5 became generally available June 9, 2026 through Claude API, Amazon Bedrock, Claude Platform on AWS, Google Cloud, and Microsoft Foundry. Reliable knowledge cutoff: January 2026.

**Control:** Adaptive thinking, automatic internal reasoning, is always enabled and cannot be disabled. `output_config.effort` is the only practical quality-versus-speed control.

| Setting | Meaning | Use |
|---|---|---|
| `high` | Default reasoning effort | Start here for most work. |
| `xhigh` | Maximum reasoning effort | Use for capability-sensitive tasks, for example complex agent planning. |
| `medium` or `low` | Reduced reasoning effort | Use for routine tasks, for example straightforward extraction or classification. |

**Efficiency:** Low-effort Fable 5 often beats `xhigh` effort on prior models, according to documentation. Example: try `low` for a simple support-ticket routing task before paying for `xhigh`.

**Token limit:** `max_tokens` caps total generated tokens, meaning thinking plus visible response text. Set it high at `high` or `xhigh`, otherwise generation can truncate mid-answer.

```text
max_tokens
├─ adaptive thinking tokens
└─ response tokens
```

**Caching:** Minimum cacheable prompt length is 512 tokens, matching Opus 5. Example: a 400-token system prompt alone cannot meet this cache threshold.

**Cost and latency:** Output costs $50 per MTok, five times Sonnet 5 and forty times Luna. Latency is slowest in Anthropic’s lineup.

**Tokenizer cost trap:** Fable 5 uses the Opus 4.7 tokenizer, so identical text produces roughly 30% more tokens than pre-4.7 models. A per-dollar comparison with Sonnet 4.6 or older therefore understates Fable or Opus 5 cost by about 30%.

```text
Same input text
├─ Pre-4.7 model: baseline tokens
└─ Fable 5:      ~30% more tokens
                 → ~30% higher token-metered cost
```

**Compatibility:** `thinking.type: "enabled"`, classic extended thinking, is unsupported. Use adaptive thinking with `output_config.effort` instead.

## Output under trained v1 (machine, old rubric: never invent examples)

Claude Fable 5 is Anthropic’s most capable widely released model, best for raw capability, long-horizon agents, and 1M context at flat pricing, but it is the slowest tier and has costly output. It became GA on Claude API, Bedrock, Claude Platform on AWS, Google Cloud, and Microsoft Foundry on 2026-06-09; its reliable knowledge cutoff is Jan 2026. [S1]

Use `output_config.effort` to control capability because adaptive thinking is always on and cannot be disabled. Start at `high`, the default; use `xhigh` for the most capability-sensitive work and `medium` or `low` for routine work, with docs claiming low-effort Fable 5 often beats `xhigh` on prior models. [S1][S4]

```
effort → thinking + response text → max_tokens hard limit
high/xhigh                     → set max_tokens large
```

Set `max_tokens` large at `high` or `xhigh`, because it limits total output, including thinking and response text, and can truncate an answer mid-response. The minimum cacheable prompt is 512 tokens, the same as Opus 5. [S4][S5]

Budget for `$50/MTok` output, which is 5x Sonnet 5 and 40x Luna. The Opus 4.7 tokenizer produces roughly 30% more tokens for the same text than pre-4.7 models, so per-dollar comparisons with Sonnet 4.6 or older understate Fable or Opus 5 cost by about 30%. [S1][S2]

Use adaptive thinking only: `thinking.type: "enabled"` is unsupported. [S1]

## Output under seed v1 (original hand-written)

Claude Fable 5 fits highest-stakes, long-horizon agent work, but its output cost and latency make it poor default for routine tasks.

Why: adaptive thinking is always enabled, 1M context has flat pricing, and raw capability leads Anthropic’s widely released lineup. Example: use Fable 5 for an agent that must analyze a large codebase and complete a multi-step migration. [S1][S4]

| Decision | Meaning | Example |
|---|---|---|
| Choose Fable 5 | Buy maximum capability | Complex autonomous engineering agent |
| Avoid as default | Output costs $50 per million tokens and latency is slowest in lineup | High-volume support summarization |
| Start `effort: high` | `output_config.effort` controls adaptive-thinking effort | Standard complex analysis |
| Use `effort: xhigh` selectively | Spend more reasoning capacity only when outcome sensitivity justifies it | Safety-critical deployment review |
| Use `medium` or `low` for routine work | Lower effort can still exceed prior-model `xhigh` performance | Formatting structured reports |

Cost risk is higher than headline per-token comparisons suggest: Fable 5 uses the Opus 4.7 tokenizer, which produces roughly 30% more tokens than pre-4.7 models. Example: a workload measured as 1M older-model tokens may bill closer to 1.3M Fable tokens. [S1][S2]

```text
Prompt + context
       |
       v
Adaptive thinking, always on
       |
       v
output_config.effort
       |
       +--> low / medium: routine work
       +--> high: default, complex work
       +--> xhigh: capability-sensitive work
```

Set `max_tokens` generously at `high` or `xhigh`: it caps both thinking and visible response text. Example: a 2,000-token limit can cut off an agent while it is still reasoning. [S4]

Integration limits matter: classic extended thinking, `thinking.type: "enabled"`, is unsupported. Use adaptive thinking through `output_config.effort` instead. [S1]

Claude Fable 5 became generally available on Claude API, Bedrock, Claude Platform on AWS, Google Cloud, and Microsoft Foundry on 2026-06-09; reliable knowledge cutoff is January 2026. [S1]
