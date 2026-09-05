# Lane D: Operating Muse Spark 1.3, Contributor, and Muse Glimmer 30B, research cutoff 2026-09-05

Tags used below:

- `[OFFICIAL]` means Meta, OpenRouter, a framework owner, or the repository owner.
- `[COMMUNITY]` means an independent measurement, third-party catalog, or user report.
- `[DEMONSTRATED]` means the behavior was measured, reproduced, shown in logs, or exposed in machine-readable metadata.
- `[ASSERTION]` means the source states it without a reproducible measurement.

## TLDR: decisions for our routing

1. **Route ordinary, non-sensitive execution to Contributor, but never send secrets, proprietary source, customer data, or unreleased material to it.** OpenRouter lists Contributor at $0.10 per million input tokens, $0.20 output, and $0.002 cached input, while the standard tier is $1.25, $4.25, and $0.15 respectively. OpenRouter describes Contributor traffic as eligible to improve Meta products. [OFFICIAL][ASSERTION] [OpenRouter comparison](https://openrouter.ai/compare/meta/muse-spark-1.3/meta/muse-spark-1.3-contributor), no publish date visible, accessed 2026-09-05. [COMMUNITY][ASSERTION] [Vercel release-note mirror](https://traceary.com/vercel/2026-09-02-muse-spark-1-3-now-available-on-ai-gateway), published 2026-09-02, accessed 2026-09-05.

2. **Use standard Spark for private work, final verification, and any prompt whose reuse by Meta would be unacceptable.** A third-party route document explicitly says standard traffic is not used to train Meta models, while Contributor exchanges lower prices for improvement use. The exact OpenRouter data-retention contract was not found, so treat this as a routing rule, not a legal conclusion. [COMMUNITY][ASSERTION] [Empirio Spark documentation](https://docs.empiriolabs.ai/models/muse-spark-1-3), published 2026-09-02, accessed 2026-09-05. [COMMUNITY][ASSERTION] [Vercel release-note mirror](https://traceary.com/vercel/2026-09-02-muse-spark-1-3-now-available-on-ai-gateway), published 2026-09-02, accessed 2026-09-05.

3. **Use `reasoning: {"effort":"low"}` for routine tool loops, `high` for implementation, and `xhigh` only for hard planning or review.** The best-supported Spark values are `minimal`, `low`, `medium`, `high`, and `xhigh`; the documented default is `medium`, reasoning remains enabled, and `max` was still awaiting additional Meta safety testing at release. [OFFICIAL][ASSERTION] [Meta Spark 1.3 announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05. [COMMUNITY][ASSERTION] [Empirio Spark documentation](https://docs.empiriolabs.ai/models/muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

4. **Budget reasoning inside `max_tokens`, not in addition to it.** OpenRouter bills reasoning tokens at the output-token rate, and Meta’s local Glimmer recipe demonstrates that a request that exhausts the ceiling during reasoning can return empty content with `finish_reason: "length"`. [OFFICIAL][ASSERTION] [OpenRouter reasoning guide](https://openrouter.ai/docs/guides/best-practices/reasoning-tokens), no publish date visible, accessed 2026-09-05. [OFFICIAL][DEMONSTRATED] [Meta llama.cpp recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), current recipe accessed 2026-09-05.

5. **Do not depend on undocumented Spark cache thresholds or TTLs. Keep prefixes byte-stable and verify every hit in `usage.prompt_tokens_details.cached_tokens`.** OpenRouter documents automatic provider caching and the usage field, but publishes no Meta-specific minimum prefix, TTL, or explicit `cache_control` contract for either Spark tier. [OFFICIAL][ASSERTION] [OpenRouter prompt-caching guide](https://openrouter.ai/docs/guides/best-practices/prompt-caching), no publish date visible, accessed 2026-09-05.

6. **Use `json_schema` with `strict: true` for machine-consumed output, but canary every schema feature before production.** OpenRouter documents JSON Schema routing and response healing, but no public Spark 1.3 matrix establishes enforcement of recursion, numeric bounds, integer enums, or ignored keywords. [OFFICIAL][ASSERTION] [OpenRouter structured-output guide](https://openrouter.ai/docs/guides/features/structured-outputs), no publish date visible, accessed 2026-09-05. [OFFICIAL][ASSERTION] [OpenRouter response healing](https://openrouter.ai/docs/guides/features/plugins/response-healing), no publish date visible, accessed 2026-09-05.

7. **Start tool loops sequentially, then enable parallel calls only after a harness-specific canary.** OpenRouter’s generic tool interface supports streamed calls, forced calls, and `parallel_tool_calls`, while its model metadata for Spark lists `tools` and `tool_choice` but not `parallel_tool_calls`; a separate Spark route asserts parallel calls are supported. [OFFICIAL][ASSERTION] [OpenRouter tool-calling guide](https://openrouter.ai/docs/guides/features/tool-calling), no publish date visible, accessed 2026-09-05. [COMMUNITY][ASSERTION] [Empirio Spark documentation](https://docs.empiriolabs.ai/models/muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

8. **Treat the advertised 1,048,576-token context as a ceiling, not a tested working set.** Meta describes Spark as a long-context agent that tracks prior results and conflicting inputs, but no public OpenRouter measurement was found at 200K, 500K, or 1M for Spark 1.3. [OFFICIAL][ASSERTION] [Meta Spark 1.3 announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05. [OFFICIAL][ASSERTION] [Meta Muse product page](https://ai.meta.com/llama?via=aivyx), no publish date visible, accessed 2026-09-05.

9. **Complete OpenRouter’s 18+ preference before scheduling Spark jobs, and do not interpret it as identity verification or permission to expose Contributor data.** The supplied live probes returned HTTP 403 with `"This model requires you to complete the following before use: 18+ age confirmation. Confirm at https://openrouter.ai/settings/preferences."` and `missing_attestation_types: ["age_18plus"]`; OpenRouter’s catalog visibly marks multiple Muse routes 18+, while Meta’s Glimmer card says the model is not intended for download or use by people under 18. The precise legal or retention meaning of the attestation is not publicly documented. [COMMUNITY][DEMONSTRATED] [OpenRouter Muse catalog](https://openrouter.ai/models?input_modalities=image%2Ctext), live probe and catalog accessed 2026-09-05. [OFFICIAL][ASSERTION] [Meta Glimmer model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), released 2026-08, accessed 2026-09-05.

10. **Use Spark through raw OpenRouter Chat Completions when validating capabilities, then put it behind coding harnesses.** Claude Code’s OpenRouter integration explicitly warns that Claude Code is optimized for Anthropic models and may not work correctly with other providers. [OFFICIAL][ASSERTION] [OpenRouter Claude Code guide](https://openrouter.ai/docs/cookbook/coding-agents/claude-code-integration), no publish date visible, accessed 2026-09-05.

11. **Use llama.cpp with Meta’s official GGUF as the default local Glimmer stack on Apple silicon.** Meta’s recipe verifies text, vision, reasoning separation, and tool calling on Apple silicon, with a 17 GB quant for a 24 GB target and a roughly 20 GB dynamic quant for a 32 GB target. [OFFICIAL][DEMONSTRATED] [Meta llama.cpp recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), current recipe accessed 2026-09-05.

12. **Prefer the 17 GB Glimmer quant for 24 GB Macs, the dynamic quant for 32 GB or more, and leave headroom for KV cache at long context.** The official model card targets 24 GB and 32 GB respectively, while a 64 GB M4 Max benchmark reached 41.6 GB peak memory at 64K context. [OFFICIAL][DEMONSTRATED] [Meta Glimmer model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), released 2026-08, accessed 2026-09-05. [COMMUNITY][DEMONSTRATED] [OMLX M4 Max benchmark](https://omlx.ai/benchmarks/performance/3x5co2bo), published 2026-08-24, accessed 2026-09-05.

13. **Keep Glimmer’s `<|eom|>` out of the stop set and enable the embedded Jinja template.** Meta documents `<|eom|>` as a continuation separator, not a terminal stop; stopping on it collapses reasoning and multi-tool turns. [OFFICIAL][DEMONSTRATED] [Meta agent-loop recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/agentic-fundamentals/README.md), current recipe accessed 2026-09-05.

14. **Use local Glimmer for repeated private loops, not because it universally beats the cloud route.** OpenRouter costs $0.30 per million input tokens and $1.10 per million output tokens, while local inference has no per-token provider fee but consumes already-purchased hardware, memory, time, and power. [OFFICIAL][ASSERTION] [OpenRouter Glimmer comparison](https://openrouter.ai/compare/x-ai/grok-4.6/meta/muse-glimmer-30b), no publish date visible, accessed 2026-09-05. [OFFICIAL][ASSERTION] [LM Studio Glimmer launch](https://lmstudio.ai/blog/muse-glimmer), published 2026-08-10, accessed 2026-09-05.

## Access gate, route identity, and Meta-source verification

### What Meta confirms

Meta says Spark 1.3 was released on 2026-09-02 for Muse Code and Meta Model API, improves long-horizon agent work, preserves long instructions better, asks clarifying questions, recognizes when it is stuck, and uses roughly 20 percent fewer tool calls and 25 percent fewer tokens than Spark 1.2 in Meta engineers’ comparisons. [OFFICIAL][ASSERTION] [Meta Spark 1.3 announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

Meta’s product page confirms native perception of video, images, and documents, plus long-horizon coding and agentic positioning. [OFFICIAL][ASSERTION] [Meta Muse product page](https://ai.meta.com/llama?via=aivyx), no publish date visible, accessed 2026-09-05.

Meta does not publish the OpenRouter route IDs, OpenRouter prices, OpenRouter cache-read prices, 943,718-token output cap, single-provider routing field, or the OpenRouter parameter list on either Meta page. Those OpenRouter-specific facts therefore remain verified by OpenRouter, not independently verified by Meta. [OFFICIAL][ASSERTION] [Meta Spark 1.3 announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05. [OFFICIAL][ASSERTION] [OpenRouter model API documentation](https://openrouter.ai/docs/api/api-reference/models/get-models), no publish date visible, accessed 2026-09-05.

No qualitative conflict was found between Meta’s description and the supplied OpenRouter route metadata. There is, however, a presentation conflict inside OpenRouter: a model-page rendering surfaced a free-price label during the sweep, while OpenRouter’s comparison data and route metadata give $1.25 input and $4.25 output for standard Spark. Use the API metadata and billing dashboard as authoritative for a live request. [OFFICIAL][DEMONSTRATED] [OpenRouter Spark model page](https://openrouter.ai/meta/muse-spark-1.3), published 2026-09-02, accessed 2026-09-05. [OFFICIAL][ASSERTION] [OpenRouter comparison](https://openrouter.ai/compare/meta/muse-spark-1.3/meta/muse-spark-1.3-contributor), no publish date visible, accessed 2026-09-05.

### The 18+ attestation

The supplied 2026-09-05 live probe produced this exact error for both Spark routes:

```text
This model requires you to complete the following before use: 18+ age confirmation. Confirm at https://openrouter.ai/settings/preferences.
```

The accompanying metadata was:

```json
{"missing_attestation_types":["age_18plus"]}
```

This demonstrates an account-level prerequisite in OpenRouter’s routing layer, before model inference. It does not demonstrate that OpenRouter performed identity verification, that Meta received an age attribute, or that accepting it changes Contributor data-use terms. [COMMUNITY][DEMONSTRATED] [OpenRouter Muse catalog](https://openrouter.ai/models?input_modalities=image%2Ctext), live probe and catalog accessed 2026-09-05.

A plausible reason is Meta’s model-family age restriction. The Glimmer card states verbatim: `"The model is not intended to be downloaded by or used by individuals under the age of 18."` It then assigns deployers responsibility for assessing and mitigating use by minors. This is direct evidence of Meta’s age policy for Glimmer, but the public Spark pages do not explicitly say that this clause causes OpenRouter’s Spark attestation. [OFFICIAL][ASSERTION] [Meta Glimmer model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), released 2026-08, accessed 2026-09-05.

OpenRouter’s catalog also displayed 18+ badges for Muse Spark 1.1 and Muse Image during the sweep. The full set of models carrying `age_18plus`, and the attestation’s storage, expiry, revocation, or provider-disclosure semantics, were not publicly documented. [OFFICIAL][DEMONSTRATED] [OpenRouter Muse catalog](https://openrouter.ai/models?input_modalities=image%2Ctext), accessed 2026-09-05.

Operational action:

1. Visit `https://openrouter.ai/settings/preferences`.
2. Read the current attestation text.
3. Confirm only if truthful.
4. Retry a minimal request.
5. Record the model, upstream provider, response status, and usage fields.
6. Keep Contributor privacy approval separate from age confirmation.

## 1. Reasoning controls in practice

### Recommended control map

| Work type | Spark effort | Glimmer local strength | Reason |
|---|---:|---:|---|
| Classification, extraction, trivial edits | `minimal` or `low` | `low` | Minimize paid or local reasoning. |
| Routine coding and tool loops | `low` or `medium` | `low` or `medium` | Preserve enough planning without long hidden prefixes. |
| Multi-file implementation | `high` | `high` | Meta recommends higher reasoning for complex coding and agentic work. |
| Independent review or difficult debugging | `xhigh` | `xhigh` | Reserve the largest budget for tasks with material error cost. |

The model-specific recommendation to use high or xhigh for complex, coding, and agentic work appears in Meta’s Glimmer model card. Applying the same routing pattern to Spark is an operational inference, not an official Spark tuning prescription. [OFFICIAL][ASSERTION] [Meta Glimmer model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), released 2026-08, accessed 2026-09-05.

### Accepted values and default

OpenRouter’s gateway accepts a generic reasoning vocabulary containing `none`, `minimal`, `low`, `medium`, `high`, `xhigh`, and `max`, and exposes per-model `supported_efforts`, `default_effort`, `default_enabled`, and `mandatory` fields where populated. [OFFICIAL][ASSERTION] [OpenRouter reasoning guide](https://openrouter.ai/docs/guides/best-practices/reasoning-tokens), no publish date visible, accessed 2026-09-05.

For Spark 1.3 specifically, independent route documentation identifies `minimal`, `low`, `medium`, `high`, and `xhigh`, gives `medium` as the default, and says reasoning cannot be turned off. [COMMUNITY][ASSERTION] [Empirio Spark documentation](https://docs.empiriolabs.ai/models/muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

Meta said on launch day that previously available reasoning modes were available and that max reasoning would arrive after additional safety testing. Therefore do not equate OpenRouter’s generic `max` enum with confirmed Spark 1.3 support. [OFFICIAL][ASSERTION] [Meta Spark 1.3 announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

No public OpenRouter response showing Spark’s live `supported_efforts`, `default_effort`, or exact error for an unsupported effort was found.

### Preferred OpenRouter call

[OFFICIAL][ASSERTION] OpenRouter documents `reasoning.effort` as the primary shape and `reasoning_effort` as equivalent shorthand. They must not be supplied with different values. [OpenRouter Python request reference](https://openrouter.ai/docs/client-sdks/python/api-reference/chat), no publish date visible, accessed 2026-09-05.

```bash
curl https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta/muse-spark-1.3",
    "messages": [
      {
        "role": "system",
        "content": "Execute the task. Use tools for external facts. Return only the requested deliverable."
      },
      {
        "role": "user",
        "content": "Review this plan and identify the three highest-risk assumptions."
      }
    ],
    "reasoning": {
      "effort": "high",
      "exclude": false
    },
    "max_tokens": 8192,
    "temperature": 0.2
  }'
```

Contributor uses the same call with:

```json
"model": "meta/muse-spark-1.3-contributor"
```

The shorthand form is:

```json
{
  "reasoning_effort": "high",
  "include_reasoning": true
}
```

Do not send both forms unless their values agree. [OFFICIAL][ASSERTION] [OpenRouter Python request reference](https://openrouter.ai/docs/client-sdks/python/api-reference/chat), no publish date visible, accessed 2026-09-05.

### Can reasoning be hidden or disabled?

`"reasoning": {"exclude": true}` tells OpenRouter to omit reasoning material from the response while allowing the model to reason. Legacy `"include_reasoning": false` maps to exclusion, while `true` requests reasoning inclusion. [OFFICIAL][ASSERTION] [OpenRouter reasoning guide](https://openrouter.ai/docs/guides/best-practices/reasoning-tokens), no publish date visible, accessed 2026-09-05.

That is not the same as disabling reasoning. The strongest model-specific evidence says Spark reasoning is always on and `none` is unavailable. [COMMUNITY][ASSERTION] [Empirio Spark documentation](https://docs.empiriolabs.ai/models/muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

OpenRouter returns reasoning only when the upstream provider supplies it. A supported `include_reasoning` parameter therefore proves that the request field is recognized, not that readable Spark traces will always be returned. [OFFICIAL][ASSERTION] [OpenRouter reasoning guide](https://openrouter.ai/docs/guides/best-practices/reasoning-tokens), no publish date visible, accessed 2026-09-05.

The supplied Glimmer probe demonstrated a visible trace with 98 reasoning tokens and a 1.2-second response for a one-word answer through DeepInfra. The Spark probes could not determine trace behavior because the age gate rejected them before inference. [COMMUNITY][DEMONSTRATED] [OpenRouter Glimmer comparison](https://openrouter.ai/compare/x-ai/grok-4.6/meta/muse-glimmer-30b), model route accessed 2026-09-05.

### Billing and the `max_tokens` trap

OpenRouter counts reasoning tokens as completion tokens and bills them at the output rate. [OFFICIAL][ASSERTION] [OpenRouter reasoning guide](https://openrouter.ai/docs/guides/best-practices/reasoning-tokens), no publish date visible, accessed 2026-09-05.

Meta’s llama.cpp test used one fixed agentic prompt and measured 1,811 completion tokens at default or high, 752 at medium, and 256 at low. The test did not measure xhigh. [OFFICIAL][DEMONSTRATED] [Meta llama.cpp recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), current recipe accessed 2026-09-05.

The same recipe warns that when the ceiling is reached during reasoning, visible `content` can be empty and `finish_reason` can be `"length"`. [OFFICIAL][DEMONSTRATED] [Meta llama.cpp recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), current recipe accessed 2026-09-05.

Practical budgets:

- Use at least 1,024 completion tokens for a tool-decision smoke test.
- Use 4,096 to 8,192 for ordinary implementation.
- Use 16,384 or more for high and xhigh long-form work.
- Detect empty content plus `finish_reason: "length"` and retry at a lower effort or larger budget.

These are operating recommendations derived from Meta’s measured 256, 752, and 1,811-token local runs, not published Spark limits. [COMMUNITY][ASSERTION] [Meta llama.cpp recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), current recipe accessed 2026-09-05.

In multi-turn tool loops, preserve the returned `reasoning_details` exactly rather than reconstructing them. OpenRouter says those details carry provider-specific state needed for correct continuation. [OFFICIAL][ASSERTION] [OpenRouter reasoning guide](https://openrouter.ai/docs/guides/best-practices/reasoning-tokens), no publish date visible, accessed 2026-09-05.

## 2. Caching

### Decision

Assume prefix caching is opportunistic and automatic, keep the stable prefix identical, and audit usage. Do not build correctness, latency SLOs, or budget enforcement around a presumed hit.

OpenRouter says most provider caching activates automatically, but its public caching guide does not document a Meta-specific minimum prefix, TTL, cache-write charge, or explicit-control behavior. [OFFICIAL][ASSERTION] [OpenRouter prompt-caching guide](https://openrouter.ai/docs/guides/best-practices/prompt-caching), no publish date visible, accessed 2026-09-05.

The separate prices prove that OpenRouter can bill cache reads on both Spark tiers, but price metadata alone does not establish how or when a cache entry is created. [OFFICIAL][ASSERTION] [OpenRouter comparison](https://openrouter.ai/compare/meta/muse-spark-1.3/meta/muse-spark-1.3-contributor), no publish date visible, accessed 2026-09-05.

### What to keep stable

Put these items at the front and keep them byte-for-byte unchanged:

1. System prompt.
2. Tool definitions, including order.
3. Repository map or durable reference material.
4. Long documents or transcripts.
5. Session history up to the cache boundary.
6. The small, changing user request last.

This ordering follows OpenRouter’s generic prefix-caching guidance. It is not a published Meta-specific prefix algorithm. [OFFICIAL][ASSERTION] [OpenRouter prompt-caching guide](https://openrouter.ai/docs/guides/best-practices/prompt-caching), no publish date visible, accessed 2026-09-05.

### Usage fields

Inspect:

```json
{
  "usage": {
    "prompt_tokens": 120000,
    "prompt_tokens_details": {
      "cached_tokens": 100000
    },
    "cache_write_tokens": 0,
    "completion_tokens": 2500,
    "reasoning_tokens": 1400
  }
}
```

OpenRouter documents `prompt_tokens_details.cached_tokens` for reads and `cache_write_tokens` where the provider reports cache writes. Field presence and completeness remain provider-dependent. [OFFICIAL][ASSERTION] [OpenRouter usage accounting](https://openrouter.ai/docs/cookbook/administration/usage-accounting), no publish date visible, accessed 2026-09-05.

### Explicit `cache_control`

The generic OpenRouter content-part shape is:

```json
{
  "role": "system",
  "content": [
    {
      "type": "text",
      "text": "Large stable prefix here",
      "cache_control": {
        "type": "ephemeral"
      }
    }
  ]
}
```

OpenRouter documents explicit `cache_control` for selected providers, not for Meta Spark. Spark’s supplied supported-parameter list also omits `cache_control`. Do not assume the field creates a Spark cache entry. [OFFICIAL][ASSERTION] [OpenRouter prompt-caching guide](https://openrouter.ai/docs/guides/best-practices/prompt-caching), no publish date visible, accessed 2026-09-05.

### Contributor behavior

No separate Contributor caching protocol was found. The same model envelope is advertised, with only the price and data-use arrangement differing. [COMMUNITY][ASSERTION] [Vercel release-note mirror](https://traceary.com/vercel/2026-09-02-muse-spark-1-3-now-available-on-ai-gateway), published 2026-09-02, accessed 2026-09-05.

A Spark 1.2 Contributor user reported a roughly five-minute effective cache despite expecting 24 hours, with apparent invalidations. That report concerns 1.2, is anecdotal, and does not establish 1.3 behavior. [COMMUNITY][DEMONSTRATED] [OpenClaw cache report](https://www.reddit.com/r/openclaw/comments/1vudz9x/muse_spark_12_contributor_cache_not_working_well/), published 2026-08-21, accessed 2026-09-05.

## 3. Structured outputs

### Decision

Use `json_schema` for contracts and `json_object` only when any valid object is acceptable. Validate again client-side.

OpenRouter describes `json_object` as JSON mode and `json_schema` as schema-constrained output. It documents `strict: true`, `required`, and `additionalProperties: false` in its examples. [OFFICIAL][ASSERTION] [OpenRouter structured-output guide](https://openrouter.ai/docs/guides/features/structured-outputs), no publish date visible, accessed 2026-09-05.

No Spark 1.3-specific public test was found for:

- Integer enums.
- `minimum` and `maximum`.
- Recursive `$ref`.
- Nested `additionalProperties: false`.
- All-properties-required behavior.
- Unsupported keyword rejection.
- Silent keyword removal.
- Streaming schema adherence.
- Schema size limits.

### Copy-paste schema canary

This request deliberately exercises integer enums, bounds, required properties, nested additional-property rejection, and recursion. A successful response is evidence only for the endpoint tested.

```bash
curl https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta/muse-spark-1.3",
    "messages": [
      {
        "role": "user",
        "content": "Return a root task with priority 2 and one child with priority 1."
      }
    ],
    "response_format": {
      "type": "json_schema",
      "json_schema": {
        "name": "task_tree",
        "strict": true,
        "schema": {
          "$defs": {
            "node": {
              "type": "object",
              "properties": {
                "name": {"type": "string"},
                "priority": {
                  "type": "integer",
                  "enum": [1, 2, 3],
                  "minimum": 1,
                  "maximum": 3
                },
                "children": {
                  "type": "array",
                  "items": {"$ref": "#/$defs/node"}
                }
              },
              "required": ["name", "priority", "children"],
              "additionalProperties": false
            }
          },
          "$ref": "#/$defs/node"
        }
      }
    },
    "temperature": 0,
    "max_tokens": 2048
  }'
```

[OFFICIAL][ASSERTION] The outer `response_format` shape follows OpenRouter’s documented interface. [OpenRouter structured-output guide](https://openrouter.ai/docs/guides/features/structured-outputs), no publish date visible, accessed 2026-09-05.

Run four checks:

1. Parse the response as JSON.
2. Validate it with the same client-side schema.
3. Ask for an impossible value and confirm rejection or correction.
4. Add an unsupported keyword and observe whether the API rejects or ignores it.

### `json_object` shape

```json
{
  "response_format": {
    "type": "json_object"
  }
}
```

With JSON object mode, explicitly tell the model to return JSON. This mode does not promise a particular object structure. [OFFICIAL][ASSERTION] [OpenRouter structured-output guide](https://openrouter.ai/docs/guides/features/structured-outputs), no publish date visible, accessed 2026-09-05.

### Response healing

OpenRouter’s response-healing plugin can repair malformed non-streaming `json_object` and `json_schema` responses, but it does not repair output truncated by the token limit. [OFFICIAL][ASSERTION] [OpenRouter response healing](https://openrouter.ai/docs/guides/features/plugins/response-healing), no publish date visible, accessed 2026-09-05.

```json
{
  "plugins": [
    {
      "id": "response-healing"
    }
  ]
}
```

Use healing only as a final parser guard. Keep client-side schema validation because repaired syntax does not prove semantic correctness.

## 4. Tool calling

### Supported request and response format

OpenRouter uses OpenAI-compatible function declarations. The model proposes calls in `message.tool_calls`; the client executes them and returns one `role: "tool"` message per call using its `tool_call_id`. [OFFICIAL][ASSERTION] [OpenRouter tool-calling guide](https://openrouter.ai/docs/guides/features/tool-calling), no publish date visible, accessed 2026-09-05.

```bash
curl https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta/muse-spark-1.3",
    "messages": [
      {
        "role": "system",
        "content": "Use the supplied tool for current weather. Never guess a tool result."
      },
      {
        "role": "user",
        "content": "What is the weather in Kuala Lumpur?"
      }
    ],
    "tools": [
      {
        "type": "function",
        "function": {
          "name": "get_weather",
          "description": "Get current weather for a city.",
          "parameters": {
            "type": "object",
            "properties": {
              "city": {"type": "string"},
              "units": {
                "type": "string",
                "enum": ["celsius", "fahrenheit"]
              }
            },
            "required": ["city"],
            "additionalProperties": false
          }
        }
      }
    ],
    "tool_choice": {
      "type": "function",
      "function": {"name": "get_weather"}
    },
    "parallel_tool_calls": false,
    "reasoning": {"effort": "low"},
    "max_tokens": 2048
  }'
```

### `tool_choice`

OpenRouter documents:

```json
{"tool_choice":"auto"}
```

```json
{"tool_choice":"none"}
```

```json
{
  "tool_choice": {
    "type": "function",
    "function": {"name":"get_weather"}
  }
}
```

The broader OpenAI-compatible schema also contains `"required"`, but OpenRouter warns that stricter values vary by model. Test before relying on it. [OFFICIAL][ASSERTION] [OpenRouter tool-calling tutorial](https://openrouter.ai/blog/tutorials/tool-calling/), published 2026-08, accessed 2026-09-05.

### Parallel calls

OpenRouter’s generic default is true for most models, and `parallel_tool_calls: false` requests one call at a time. [OFFICIAL][ASSERTION] [OpenRouter tool-calling guide](https://openrouter.ai/docs/guides/features/tool-calling), no publish date visible, accessed 2026-09-05.

Spark’s supplied OpenRouter supported-parameter list does not contain `parallel_tool_calls`, while independent Spark documentation says its default is true. Treat that as a canary item. [COMMUNITY][ASSERTION] [Empirio Spark documentation](https://docs.empiriolabs.ai/models/muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

For reliability, begin with `false`. If enabling parallel calls:

- Accumulate every call by array index.
- Wait for the stream to finish.
- Execute all calls.
- Append one tool result for every call ID.
- Preserve returned reasoning details.
- Only then request the next model turn.

OpenRouter warns that streaming tool arguments arrive as fragments and must not be executed before complete assembly. [OFFICIAL][ASSERTION] [OpenRouter tool-calling tutorial](https://openrouter.ai/blog/tutorials/tool-calling/), published 2026-08, accessed 2026-09-05.

### Framework fit and known breakages

| Harness or SDK | Evidence and operating consequence |
|---|---|
| OpenAI SDK | OpenRouter officially supports retargeting `base_url` to `https://openrouter.ai/api/v1` and changing the model ID. No Spark 1.3-specific OpenAI SDK defect was found. [OFFICIAL][ASSERTION] [OpenRouter migration guide](https://openrouter.ai/docs/cookbook/get-started/migrate-to-openrouter), no publish date visible, accessed 2026-09-05. |
| Vercel AI SDK | OpenRouter recommends `@openrouter/ai-sdk-provider` while retaining `generateText`, `streamText`, and tools. No Spark 1.3-specific Vercel defect was found. [OFFICIAL][ASSERTION] [OpenRouter migration guide](https://openrouter.ai/docs/cookbook/get-started/migrate-to-openrouter), no publish date visible, accessed 2026-09-05. |
| LangChain | OpenRouter lists LangChain as an integration, but no Spark 1.3-specific tool failure was found. [OFFICIAL][ASSERTION] [OpenRouter multimodal documentation index](https://openrouter.ai/docs/guides/overview/multimodal/overview), no publish date visible, accessed 2026-09-05. |
| LiteLLM | A LiteLLM change for Spark 1.2 added model support and addressed `reasoning_effort` 400 behavior and pricing. This is evidence of prior adapter lag, not a demonstrated 1.3 defect. [COMMUNITY][DEMONSTRATED] [LiteLLM pull request 36717](https://github.com/BerriAI/litellm/pull/36717), published 2026-08, accessed 2026-09-05. |
| Pydantic AI | OpenRouter lists PydanticAI as an integration. No Muse-specific issue was found. Validate tool argument models locally even when the provider reports structured calls. [OFFICIAL][ASSERTION] [OpenRouter multimodal documentation index](https://openrouter.ai/docs/guides/overview/multimodal/overview), no publish date visible, accessed 2026-09-05. |
| OpenCode | A 2026-09-04 issue reproduces intermittent `"Invalid upload request"` failures for OpenCode’s own `muse-spark-1.3-contributor-free` route on Windows, while another model streamed correctly. This is not the paid OpenRouter route, but it shows model-specific transport sensitivity. [COMMUNITY][DEMONSTRATED] [OpenCode issue 47237](https://github.com/anomalyco/opencode/issues/47237), published 2026-09-04, accessed 2026-09-05. |
| Cline | Cline officially supports OpenRouter through its provider selector. Its public instructions expose provider, key, model, and optional base URL fields. No Spark 1.3-specific breakage was found. [OFFICIAL][ASSERTION] [Cline OpenRouter guide](https://docs.cline.bot/provider-config/openrouter), no publish date visible, accessed 2026-09-05. |
| Roo Code | No Muse-specific public issue or profile was found. Use the generic OpenRouter provider and run the tool canary above before real work. |
| Kilo Code | A 2026-07-16 issue says a custom OpenAI-compatible provider did not automatically discover `/v1/models`, requiring manual model entry. Kilo later shipped Muse-specific system-prompt work for earlier Spark versions. [COMMUNITY][DEMONSTRATED] [Kilo issue 12273](https://github.com/Kilo-Org/kilocode/issues/12273), published 2026-07-16, accessed 2026-09-05. [OFFICIAL][ASSERTION] [Kilo releases](https://github.com/Kilo-Org/kilocode/releases), accessed 2026-09-05. |
| Aider | Aider officially accepts OpenRouter models as `openrouter/<provider>/<model>` and exposes `--reasoning-effort`. No Muse-specific failure was found. [OFFICIAL][ASSERTION] [Aider OpenRouter guide](https://aider.chat/docs/llms/openrouter.html), no publish date visible, accessed 2026-09-05. [OFFICIAL][ASSERTION] [Aider options](https://aider.chat/docs/config/options.html), no publish date visible, accessed 2026-09-05. |
| Cursor | No public Spark 1.3 profile or reproducible Muse-specific tool issue was found. Use Cursor’s OpenRouter or OpenAI-compatible path only after a forced-tool canary. |
| Windsurf | No public Spark 1.3 profile or reproducible Muse-specific tool issue was found. |
| Zed | No public Spark 1.3 profile or reproducible Muse-specific tool issue was found. |
| Claude Code via OpenRouter | OpenRouter supports an Anthropic-compatible gateway, but explicitly says Claude Code is optimized for Anthropic models and may not work correctly with other providers. [OFFICIAL][ASSERTION] [OpenRouter Claude Code guide](https://openrouter.ai/docs/cookbook/coding-agents/claude-code-integration), no publish date visible, accessed 2026-09-05. |
| Codex CLI | Codex accepts custom providers, but current official configuration uses the Responses wire API. Older Muse reports show fallback model metadata warnings that can degrade behavior. Validate context, tools, and reasoning after every Codex upgrade. [OFFICIAL][ASSERTION] [OpenAI Codex configuration reference](https://developers.openai.com/codex/config-reference/), accessed 2026-09-05. [COMMUNITY][DEMONSTRATED] [Awesome Muse Spark compatibility notes](https://github.com/accretional/awesome-muse-spark/blob/main/README.md), accessed 2026-09-05. |

A direct Meta tool smoke test for Spark 1.2 showed that a 256-token completion ceiling could be consumed by roughly 220 reasoning tokens before the tool call appeared; raising it to 1,024 fixed the smoke test. This is an older-model report, but it supports avoiding tiny tool budgets. [COMMUNITY][DEMONSTRATED] [JCode issue 817](https://github.com/1jehuang/jcode/issues/817), published 2026-08-05, accessed 2026-09-05.

## 5. Multimodal input through OpenRouter

### Capability boundary

The supplied OpenRouter metadata lists text, image, video, file, and audio input for both Spark routes. Meta’s current product page explicitly promotes video, images, and documents. [OFFICIAL][ASSERTION] [Meta Muse product page](https://ai.meta.com/llama?via=aivyx), no publish date visible, accessed 2026-09-05.

Audio is conflicted. Meta’s Spark 1.3 announcement includes an audio-editing demonstration, while independent API documentation says audio input is unsupported on the 1.3 checkpoint. Test audio before committing a workflow. [OFFICIAL][DEMONSTRATED] [Meta Spark 1.3 announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05. [COMMUNITY][ASSERTION] [Empirio Spark documentation](https://docs.empiriolabs.ai/models/muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

### Image, URL

```json
{
  "role": "user",
  "content": [
    {"type": "text", "text": "Describe this screenshot."},
    {
      "type": "image_url",
      "image_url": {
        "url": "https://example.com/screenshot.png"
      }
    }
  ]
}
```

### Image, base64 data URI

```json
{
  "role": "user",
  "content": [
    {"type": "text", "text": "Read the error message."},
    {
      "type": "image_url",
      "image_url": {
        "url": "data:image/png;base64,BASE64_DATA"
      }
    }
  ]
}
```

OpenRouter documents PNG, JPEG, WebP, and GIF, and recommends placing text before the image. [OFFICIAL][ASSERTION] [OpenRouter image guide](https://openrouter.ai/docs/guides/overview/multimodal/image-understanding), no publish date visible, accessed 2026-09-05.

### Video, direct URL

```json
{
  "role": "user",
  "content": [
    {"type": "text", "text": "Summarize the actions in chronological order."},
    {
      "type": "video_url",
      "video_url": {
        "url": "https://example.com/clip.mp4"
      }
    }
  ]
}
```

### Video, base64

```json
{
  "role": "user",
  "content": [
    {"type": "text", "text": "Find the first visible UI error."},
    {
      "type": "video_url",
      "video_url": {
        "url": "data:video/mp4;base64,BASE64_DATA"
      }
    }
  ]
}
```

OpenRouter documents MP4, MPEG, MOV, and WebM and says video input is currently API-only. [OFFICIAL][ASSERTION] [OpenRouter video guide](https://openrouter.ai/docs/guides/overview/multimodal/videos), no publish date visible, accessed 2026-09-05.

### YouTube

The content-part shape is still `video_url`:

```json
{
  "type": "video_url",
  "video_url": {
    "url": "https://www.youtube.com/watch?v=VIDEO_ID"
  }
}
```

OpenRouter documents YouTube-only URL behavior for Gemini on AI Studio. It does not document YouTube fetching for Meta’s upstream Spark route. Do not assume a YouTube URL works with Spark. [OFFICIAL][ASSERTION] [OpenRouter video guide](https://openrouter.ai/docs/guides/overview/multimodal/videos), no publish date visible, accessed 2026-09-05.

### Audio

Audio uses raw base64, not a data URI:

```json
{
  "role": "user",
  "content": [
    {"type": "text", "text": "Transcribe this audio and list uncertain words."},
    {
      "type": "input_audio",
      "input_audio": {
        "data": "RAW_BASE64_DATA",
        "format": "wav"
      }
    }
  ]
}
```

Direct audio URLs are not supported by OpenRouter’s Chat Completions audio shape. Common gateway formats include WAV, MP3, AIFF, AAC, OGG, FLAC, M4A, PCM16, and PCM24, but support varies by provider. [OFFICIAL][ASSERTION] [OpenRouter audio guide](https://openrouter.ai/docs/guides/overview/multimodal/audio), no publish date visible, accessed 2026-09-05.

OpenRouter warns that very long audio may exceed an upstream 60-second timeout and recommends splitting it. This is gateway guidance, not a published Spark duration limit. [OFFICIAL][ASSERTION] [OpenRouter speech-to-text guide](https://openrouter.ai/docs/guides/overview/multimodal/stt), no publish date visible, accessed 2026-09-05.

### PDF, direct URL

```json
{
  "model": "meta/muse-spark-1.3",
  "messages": [
    {
      "role": "user",
      "content": [
        {"type": "text", "text": "Extract the obligations and deadlines."},
        {
          "type": "file",
          "file": {
            "filename": "contract.pdf",
            "file_data": "https://example.com/contract.pdf"
          }
        }
      ]
    }
  ],
  "plugins": [
    {
      "id": "file-parser",
      "pdf": {
        "engine": "native"
      }
    }
  ]
}
```

### PDF, base64

```json
{
  "type": "file",
  "file": {
    "filename": "document.pdf",
    "file_data": "data:application/pdf;base64,BASE64_DATA"
  }
}
```

OpenRouter supports `native`, `cloudflare-ai`, and `mistral-ocr`. `cloudflare-ai` is free, `mistral-ocr` costs $2 per 1,000 pages, and native processing is charged as model input tokens. If no engine is selected, OpenRouter tries native first and otherwise uses Mistral OCR. [OFFICIAL][ASSERTION] [OpenRouter PDF guide](https://openrouter.ai/docs/guides/overview/multimodal/pdfs), no publish date visible, accessed 2026-09-05.

Mistral OCR forwards at most eight extracted images per PDF while preserving extracted text. Reusing returned file annotations can avoid repeated parsing charges. [OFFICIAL][ASSERTION] [OpenRouter PDF guide](https://openrouter.ai/docs/guides/overview/multimodal/pdfs), no publish date visible, accessed 2026-09-05.

### Limits and pricing gaps

No public Spark 1.3 OpenRouter source was found for maximum:

- Image count.
- Image bytes or pixels.
- Video bytes, duration, frame rate, or resolution.
- Audio bytes or duration.
- PDF bytes or pages under native processing.
- Request-body bytes after base64 expansion.
- Video price per minute.
- Audio price per minute.

OpenRouter says multimedia is generally charged as input tokens according to duration, resolution, or provider conversion, but it does not publish Spark-specific per-minute rates. [OFFICIAL][ASSERTION] [OpenRouter multimodal overview](https://openrouter.ai/docs/guides/overview/multimodal/overview), no publish date visible, accessed 2026-09-05.

No reproducible Spark 1.3 OpenRouter 400 response for a particular image, video, audio, or PDF shape was found. The audio capability conflict makes audio the first format to canary after clearing the age gate.

## 6. Long context

### What is established

OpenRouter exposes a 1,048,576-token context and a 943,718-token maximum output in its route metadata, as supplied in the task. Meta describes Spark as sustaining long threads, tracking prior results, and resolving messy or conflicting sources. [OFFICIAL][ASSERTION] [Meta Spark 1.3 announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

Meta’s Spark 1.1 announcement described active context management around a 1M context, including planning, subagents, and compaction. That is older-model evidence and does not benchmark 1.3 through OpenRouter. [OFFICIAL][ASSERTION] [Meta Spark 1.1 announcement](https://ai.meta.com/blog/introducing-muse-spark-meta-model-api/), published 2026-07-09, accessed 2026-09-05.

### What is not established

No public test was found showing successful Spark 1.3 OpenRouter requests at 200K, 500K, or 1M tokens. No measured TTFT, end-to-end latency, retrieval accuracy, needle score, request-byte ceiling, or degradation curve was found at those sizes.

The enormous advertised maximum output should not be interpreted as output available in addition to a full 1M prompt. A third-party route guide states that prompt and completion share the context budget, but no Meta or OpenRouter Spark-specific statement was found. [COMMUNITY][ASSERTION] [LLMTR Muse Spark guide](https://llmtr.com/docs/en/gateway/meta-muse-spark/), no publish date visible, accessed 2026-09-05.

### Input-cost table

These calculations use the supplied OpenRouter rates and exclude output, web search, OCR, and retries. [OFFICIAL][ASSERTION] [OpenRouter comparison](https://openrouter.ai/compare/meta/muse-spark-1.3/meta/muse-spark-1.3-contributor), no publish date visible, accessed 2026-09-05.

| Fresh input | Standard | Standard cached | Contributor | Contributor cached |
|---:|---:|---:|---:|---:|
| 200K tokens | $0.25 | $0.03 | $0.02 | $0.0004 |
| 500K tokens | $0.625 | $0.075 | $0.05 | $0.001 |
| 1M tokens | $1.25 | $0.15 | $0.10 | $0.002 |

At one million input tokens plus 100K output tokens, standard costs $1.675 and Contributor costs $0.12 before caching or tools. These are arithmetic results from the listed token rates. [COMMUNITY][DEMONSTRATED] [OpenRouter comparison](https://openrouter.ai/compare/meta/muse-spark-1.3/meta/muse-spark-1.3-contributor), no publish date visible, accessed 2026-09-05.

### Recommended long-context qualification

After clearing the age gate, run the same deterministic retrieval suite at:

1. 32K.
2. 128K.
3. 200K.
4. 500K.
5. 900K.
6. The largest request OpenRouter accepts below 1,048,576.

For every run, record:

- Serialized request bytes.
- Prompt tokens.
- Cached tokens.
- Reasoning tokens.
- TTFT.
- Total latency.
- Output tokens.
- Needle position and correctness.
- Provider.
- HTTP status and error metadata.

Do not mix base64 media into this text qualification because base64 expansion and media tokenization confound the context test.

## 7. Sampling and prompting

### Sampling

No official Spark 1.3 temperature or `top_p` recommendation was found. Meta’s local Glimmer generation configuration defaults to non-sampling behavior, and Meta’s llama.cpp smoke tests use temperature zero. [OFFICIAL][DEMONSTRATED] [Meta llama.cpp recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), current recipe accessed 2026-09-05.

Operational defaults:

- Coding, tools, extraction, JSON: `temperature: 0` to `0.2`.
- Design exploration: `temperature: 0.4` to `0.7`.
- Leave `top_p` at 1 unless deliberately testing it.
- Leave `top_k` unset.
- Leave `repetition_penalty` at 1 unless a measured repetition problem exists.
- Change one sampler at a time.

These are conservative operating recommendations, not Meta-published Spark settings. They follow Meta’s deterministic Glimmer examples and reduce confounding during qualification. [COMMUNITY][ASSERTION] [Meta llama.cpp recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), current recipe accessed 2026-09-05.

### System prompt shape

```text
You are an execution agent.

Goal:
<one concrete outcome>

Evidence policy:
Use tools for current facts, external state, and any claim not established by the supplied context.
Never invent a tool result.
If a tool fails, report the exact failure and try one safe alternative.

Constraints:
<short numbered constraints>

Deliverable:
<exact artifact or response shape>

Progress:
For work longer than three tool calls, send one concise progress update.
Otherwise work silently.

Stop condition:
Stop immediately when the deliverable is complete and verified.
Do not add a recap, suggestions, or optional next steps.

Blocked condition:
If a missing choice would materially change the result, ask one concise question.
```

Meta says Spark 1.3 was trained to ask for clarification on ambiguity, seek user help when stuck, confirm consequential actions, and adapt between frequent updates and silent work. The prompt above gives those behaviors explicit operating boundaries. [OFFICIAL][ASSERTION] [Meta Spark 1.3 announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

### Make it stop early

Use all four controls together:

```text
Return only the requested artifact.
Maximum length: 400 words.
Do not explain your process.
Do not add a recap or next steps.
Stop when all acceptance tests pass.
```

Also reduce effort and `max_tokens`. Meta says 1.3 is already less verbose and uses fewer unnecessary turns than 1.2, but explicit stop conditions still make the harness contract testable. [OFFICIAL][ASSERTION] [Meta Spark 1.3 announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

### Make it continue

```text
Continue until every numbered requirement has a corresponding verified result.
Maintain a checklist internally.
Do not conclude while any requirement is unverified.
If context pressure appears, compact completed evidence and continue from the remaining checklist.
```

This leverages Meta’s claimed long-thread and instruction-preservation improvements. [OFFICIAL][ASSERTION] [Meta Spark 1.3 announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

### Force tools instead of guessing

For one mandatory tool, use a named `tool_choice`. For any-tool-required behavior, test `"required"` first because model support varies. [OFFICIAL][ASSERTION] [OpenRouter tool-calling tutorial](https://openrouter.ai/blog/tutorials/tool-calling/), published 2026-08, accessed 2026-09-05.

Also state:

```text
Current external facts are not present in the prompt.
You must call the appropriate tool before answering.
If the tool cannot verify the fact, say "not verified".
```

### Prevent padding

Use a fixed response contract:

```text
Return exactly:
1. Decision, one sentence.
2. Evidence, at most three bullets.
3. Risk, one sentence.

No introduction.
No conclusion.
No repeated facts.
No optional suggestions.
```

A community report says Glimmer can turn each tool call into a disproportionately large research exercise. That concerns Glimmer, not Spark 1.3, but supports explicit scope and stop clauses for the distilled family. [COMMUNITY][ASSERTION] [LocalLLaMA overthinking report](https://www.reddit.com/r/LocalLLaMA/comments/1vlhdu7/muse_glimmer_overthinking_like_crazy/), published 2026-08, accessed 2026-09-05.

## 8. Latency and throughput

### Spark 1.3 measurements found

Artificial Analysis measured the Meta-hosted Spark 1.3 xhigh route at about 149.9 output tokens per second. The same page exposed different first-chunk and first-answer figures, roughly 42.49 and 55.83 seconds, indicating differing metric definitions. This is Meta’s direct route, not a demonstrated OpenRouter run. [COMMUNITY][DEMONSTRATED] [Artificial Analysis Spark 1.3 xhigh provider page](https://artificialanalysis.ai/models/muse-spark-1-3-xhigh/providers), accessed 2026-09-05.

A separate catalog reported roughly 82.5 output tokens per second for Contributor on 2026-09-04, but did not expose an effort-specific breakdown or a reproducible request corpus. [COMMUNITY][DEMONSTRATED] [The Known Good Contributor page](https://www.theknowngood.com/models/meta-muse-spark-1-3-contributor/), updated 2026-09-04, accessed 2026-09-05.

No reliable OpenRouter Spark 1.3 TTFT and output-rate table was found for minimal, low, medium, high, and xhigh.

### Older OpenRouter proxy, not a 1.3 result

OpenRouter’s Spark 1.2 page displayed recent-provider percentiles around 100 tokens per second at P50 and TTFT around 2.61 seconds at P50, with substantially larger tail latency. It also showed nonzero tool and structured-output error rates and approximately 98 percent availability for the displayed window. These are 1.2 route metrics and must not be reported as 1.3 performance. [OFFICIAL][DEMONSTRATED] [OpenRouter Spark 1.2 page](https://openrouter.ai/meta/muse-spark-1.2), published 2026-08-05, accessed 2026-09-05.

### Supplied live Glimmer probe

The supplied Glimmer probe completed through DeepInfra in 1.2 seconds and returned 98 visible reasoning tokens for a one-word answer. It demonstrates that hidden work can dominate a trivial answer, but one request cannot establish TTFT, throughput, or route variance. [COMMUNITY][DEMONSTRATED] [OpenRouter Glimmer comparison](https://openrouter.ai/compare/x-ai/grok-4.6/meta/muse-glimmer-30b), model route accessed 2026-09-05.

### Rate limits and retries

OpenRouter says paid variants have no platform-level request cap of the kind applied to free variants, but requests remain subject to upstream capacity and DDoS protection. It does not publish a fixed paid Spark requests-per-minute limit. [OFFICIAL][ASSERTION] [OpenRouter limits](https://openrouter.ai/docs/api_reference/limits), no publish date visible, accessed 2026-09-05.

Creating more keys does not increase account-wide capacity. Credit limits are per key where configured, while platform rate capacity is governed globally. [OFFICIAL][ASSERTION] [OpenRouter limits](https://openrouter.ai/docs/api_reference/limits), no publish date visible, accessed 2026-09-05.

On 429, OpenRouter recommends exponential backoff and honoring `Retry-After`. Provider-side failures may be retried against another provider before reaching the client. [OFFICIAL][ASSERTION] [OpenRouter limits](https://openrouter.ai/docs/api_reference/limits), no publish date visible, accessed 2026-09-05.

Spark’s supplied metadata names only Meta as its upstream provider. Therefore provider failover within the same Spark route may be unavailable, although model-level fallbacks can still be configured. This is an inference from the route metadata and OpenRouter’s fallback description. [COMMUNITY][ASSERTION] [OpenRouter provider-selection guide](https://openrouter.ai/docs/guides/routing/provider-selection), no publish date visible, accessed 2026-09-05.

If a 429 occurs after streaming begins, OpenRouter sends an SSE error event with `finish_reason: "error"` because the HTTP status has already been sent. [OFFICIAL][ASSERTION] [OpenRouter limits](https://openrouter.ai/docs/api_reference/limits), no publish date visible, accessed 2026-09-05.

Recommended retry policy:

```text
HTTP 400: do not retry unchanged. Inspect parameter or multimodal shape.
HTTP 403 with age_18plus: complete the preference, then retry once.
HTTP 408 or transport timeout: retry with jitter, maximum two attempts.
HTTP 429: honor Retry-After, then exponential backoff with jitter.
HTTP 5xx before streaming: retry twice.
SSE finish_reason error: discard the partial turn unless the application can prove idempotence.
Tool side effect uncertain: inspect external state before retrying.
```

The status-specific policy is an operational recommendation built around OpenRouter’s documented 429 and streaming behavior. [COMMUNITY][ASSERTION] [OpenRouter limits](https://openrouter.ai/docs/api_reference/limits), no publish date visible, accessed 2026-09-05.

## 9. Agent harness fit

### Which harnesses visibly ship Muse support

Meta ships Spark 1.3 through Muse Code. [OFFICIAL][ASSERTION] [Meta Spark 1.3 announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

OpenCode’s own service visibly added a `muse-spark-1.3-contributor-free` entry, and a public issue demonstrates the route being selected in OpenCode Desktop. That is OpenCode service support, not proof that every OpenRouter OpenCode combination works. [COMMUNITY][DEMONSTRATED] [OpenCode issue 47237](https://github.com/anomalyco/opencode/issues/47237), published 2026-09-04, accessed 2026-09-05.

Cline documentation supports OpenRouter generally, but no 1.3-specific profile was found. [OFFICIAL][ASSERTION] [Cline OpenRouter guide](https://docs.cline.bot/provider-config/openrouter), no publish date visible, accessed 2026-09-05.

Kilo has shipped Muse-specific prompting for earlier versions and may require manual model entry for custom providers. [OFFICIAL][ASSERTION] [Kilo releases](https://github.com/Kilo-Org/kilocode/releases), accessed 2026-09-05. [COMMUNITY][DEMONSTRATED] [Kilo issue 12273](https://github.com/Kilo-Org/kilocode/issues/12273), published 2026-07-16, accessed 2026-09-05.

No confirmed built-in Spark 1.3 profile was found for Aider, Cursor, Windsurf, Zed, Roo, LangChain, Pydantic AI, or Codex CLI.

### Claude Code via OpenRouter

OpenRouter’s Anthropic-compatible base URL is `https://openrouter.ai/api`, without `/v1`. It requires `ANTHROPIC_AUTH_TOKEN`, and `ANTHROPIC_API_KEY` must be explicitly empty for local interactive use. [OFFICIAL][ASSERTION] [OpenRouter Claude Code guide](https://openrouter.ai/docs/cookbook/coding-agents/claude-code-integration), no publish date visible, accessed 2026-09-05.

```bash
export OPENROUTER_API_KEY="sk-or-..."
export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
export ANTHROPIC_AUTH_TOKEN="$OPENROUTER_API_KEY"
export ANTHROPIC_API_KEY=""
export CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY="1"

export ANTHROPIC_DEFAULT_FABLE_MODEL="meta/muse-spark-1.3"
export ANTHROPIC_DEFAULT_OPUS_MODEL="meta/muse-spark-1.3"
export ANTHROPIC_DEFAULT_SONNET_MODEL="meta/muse-spark-1.3"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="meta/muse-spark-1.3-contributor"
export CLAUDE_CODE_SUBAGENT_MODEL="meta/muse-spark-1.3-contributor"

claude
```

If Claude Code has a cached Anthropic login, run `/logout`, restart it, and verify `/status`. OpenRouter warns that credential conflicts can appear as model-not-found errors. [OFFICIAL][DEMONSTRATED] [OpenRouter Claude Code guide](https://openrouter.ai/docs/cookbook/coding-agents/claude-code-integration), no publish date visible, accessed 2026-09-05.

What can break:

- Non-Anthropic reasoning-block translation.
- Tool-result formatting.
- Model discovery.
- Context metadata.
- Claude-specific system prompts.
- Compact or subagent behavior.
- The age gate before any model turn.

OpenRouter explicitly limits its compatibility guarantee to Anthropic first-party models in Claude Code. [OFFICIAL][ASSERTION] [OpenRouter Claude Code guide](https://openrouter.ai/docs/cookbook/coding-agents/claude-code-integration), no publish date visible, accessed 2026-09-05.

### OpenCode

OpenCode has a built-in OpenRouter provider. The model name includes both the OpenCode provider prefix and the OpenRouter model ID. [OFFICIAL][ASSERTION] [OpenCode provider documentation](https://opencode.ai/docs/providers), updated 2026-09-04, accessed 2026-09-05.

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "openrouter/meta/muse-spark-1.3",
  "provider": {
    "openrouter": {
      "options": {
        "apiKey": "{env:OPENROUTER_API_KEY}"
      },
      "models": {
        "meta/muse-spark-1.3": {
          "name": "Muse Spark 1.3",
          "limit": {
            "context": 1048576,
            "output": 943718
          }
        },
        "meta/muse-spark-1.3-contributor": {
          "name": "Muse Spark 1.3 Contributor",
          "limit": {
            "context": 1048576,
            "output": 943718
          }
        }
      }
    }
  }
}
```

Canary direct OpenRouter before blaming OpenCode. A 2026-09-04 OpenCode service issue showed intermittent invalid-upload failures for the free Contributor route. [COMMUNITY][DEMONSTRATED] [OpenCode issue 47237](https://github.com/anomalyco/opencode/issues/47237), published 2026-09-04, accessed 2026-09-05.

### Cline

Cline’s supported setup is UI-based:

```text
API Provider: OpenRouter
OpenRouter API Key: sk-or-...
Model: meta/muse-spark-1.3
Use custom base URL: off
```

For cheap, non-sensitive tasks:

```text
Model: meta/muse-spark-1.3-contributor
```

These fields match Cline’s official OpenRouter setup. [OFFICIAL][ASSERTION] [Cline OpenRouter guide](https://docs.cline.bot/provider-config/openrouter), no publish date visible, accessed 2026-09-05.

What can break:

- The model may not appear until Cline refreshes its catalog.
- Cline’s system prompt may provoke unnecessary tool calls.
- Small completion budgets can be consumed by reasoning.
- Multimodal uploads may be translated differently from raw OpenRouter.

Only the provider-selection procedure is officially documented; the failure possibilities are qualification targets, not demonstrated Cline 1.3 bugs.

### Aider

```bash
export OPENROUTER_API_KEY="sk-or-..."
aider \
  --model openrouter/meta/muse-spark-1.3 \
  --reasoning-effort high
```

Contributor:

```bash
aider \
  --model openrouter/meta/muse-spark-1.3-contributor \
  --reasoning-effort low
```

Aider officially uses `openrouter/<provider>/<model>` and supports `--reasoning-effort`. [OFFICIAL][ASSERTION] [Aider OpenRouter guide](https://aider.chat/docs/llms/openrouter.html), no publish date visible, accessed 2026-09-05. [OFFICIAL][ASSERTION] [Aider options](https://aider.chat/docs/config/options.html), no publish date visible, accessed 2026-09-05.

If Aider treats the model as unknown, provide a model metadata file containing the context, output cap, and prices. Aider exposes `--model-metadata-file` for unknown models. [OFFICIAL][ASSERTION] [Aider options](https://aider.chat/docs/config/options.html), no publish date visible, accessed 2026-09-05.

### Codex CLI custom provider

Current Codex configuration supports named custom providers with `base_url`, `env_key`, retry settings, and the Responses wire API. [OFFICIAL][ASSERTION] [OpenAI Codex configuration reference](https://developers.openai.com/codex/config-reference/), accessed 2026-09-05.

Add to `~/.codex/config.toml`:

```toml
model = "meta/muse-spark-1.3"
model_provider = "openrouter"
model_context_window = 1048576
model_reasoning_effort = "high"

[model_providers.openrouter]
name = "OpenRouter"
base_url = "https://openrouter.ai/api/v1"
env_key = "OPENROUTER_API_KEY"
wire_api = "responses"
request_max_retries = 4
stream_max_retries = 5
stream_idle_timeout_ms = 300000
```

Then:

```bash
export OPENROUTER_API_KEY="sk-or-..."
codex
```

For a one-off model:

```bash
codex \
  -c 'model_provider="openrouter"' \
  -c 'model="meta/muse-spark-1.3-contributor"' \
  -c 'model_reasoning_effort="low"'
```

OpenRouter’s Codex example confirms the `/api/v1` base and `[model_providers.openrouter]` section, while OpenAI documents the current provider keys and Responses transport. [OFFICIAL][ASSERTION] [OpenRouter coding-agent cookbook](https://openrouter.ai/docs/cookbook/coding-agents/automatic-code-review), no publish date visible, accessed 2026-09-05. [OFFICIAL][ASSERTION] [OpenAI Codex configuration reference](https://developers.openai.com/codex/config-reference/), accessed 2026-09-05.

What can break:

- OpenRouter’s Responses adapter may not expose every Chat Completions-only feature identically.
- Codex may fall back to generic model metadata.
- Reasoning effort values supported by Codex and Spark may not perfectly overlap.
- Codex’s own tool grammar may expose provider parser weaknesses.
- The age attestation can fail before the agent starts.

A community compatibility note recorded the warning `"Model metadata for muse-spark-1.1 not found. Defaulting to fallback metadata; this can degrade performance and cause issues."` That concerns Spark 1.1, but it is the concrete precedent for verifying metadata. [COMMUNITY][DEMONSTRATED] [Awesome Muse Spark compatibility notes](https://github.com/accretional/awesome-muse-spark/blob/main/README.md), accessed 2026-09-05.

## 10. Muse Glimmer 30B local on an Apple-silicon Mac

### Exact repositories

| Format | Repository | Published size and status |
|---|---|---|
| BF16 safetensors | `meta-models/Muse-Glimmer-30B` | 59.6 GB repository, with roughly 29.8B parameters. [OFFICIAL][DEMONSTRATED] [Meta BF16 files](https://huggingface.co/meta-models/Muse-Glimmer-30B/tree/main), released 2026-08, accessed 2026-09-05. |
| Official GGUF | `meta-models/Muse-Glimmer-30B-GGUF` | 16.8 GB 17 GB K-quant, 19.7 GB dynamic K-quant, 1.4 GB vision projector, 1.6 GB DFlash draft. [OFFICIAL][DEMONSTRATED] [Meta GGUF files](https://huggingface.co/meta-models/Muse-Glimmer-30B-GGUF), released 2026-08, accessed 2026-09-05. |
| MLX collection | `mlx-community` Muse Glimmer collection | Community conversions include 4-bit, 5-bit, 6-bit, 8-bit, BF16, MXFP4, MXFP8, and NVFP4 variants. [COMMUNITY][DEMONSTRATED] [MLX community collection](https://huggingface.co/collections/mlx-community/muse-glimmer), accessed 2026-09-05. |
| MLX 8-bit | `mlx-community/Muse-Glimmer-30B-8bit` | About 33.4 GB. [COMMUNITY][DEMONSTRATED] [MLX 8-bit repository](https://huggingface.co/mlx-community/Muse-Glimmer-30B-8bit), accessed 2026-09-05. |
| MLX BF16 | `mlx-community/Muse-Glimmer-30B-bf16` | About 59.6 GB. [COMMUNITY][DEMONSTRATED] [MLX BF16 repository](https://huggingface.co/mlx-community/Muse-Glimmer-30B-bf16), accessed 2026-09-05. |

Meta releases Glimmer under Apache 2.0 and describes it as a roughly 29.6B dense model distilled from Spark for autonomous local agents, with text and image input, 131,072-token context, reliable tool use, and controllable reasoning effort. [OFFICIAL][ASSERTION] [Meta Glimmer model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), released 2026-08, accessed 2026-09-05.

Glimmer does not support audio. Meta says video was not explicitly optimized and can be processed as individual frames rather than as a native Spark-style video stream. [OFFICIAL][ASSERTION] [Meta Glimmer model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), released 2026-08, accessed 2026-09-05.

### RAM guidance

| Mac unified memory | Recommendation |
|---:|---|
| 24 GB | Use the 17 GB K-quant, text-first, moderate context. Meta targets this quant at 24 GB. [OFFICIAL][ASSERTION] [Meta Glimmer model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), released 2026-08, accessed 2026-09-05. |
| 32 GB | Use the dynamic K-quant if quality matters, or the 17 GB quant for more KV headroom. Meta targets the dynamic quant at 32 GB. [OFFICIAL][ASSERTION] [Meta Glimmer model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), released 2026-08, accessed 2026-09-05. |
| 64 GB | Both GGUFs are comfortable at ordinary contexts; 64K context can still push peak memory above 40 GB. [COMMUNITY][DEMONSTRATED] [OMLX M4 Max benchmark](https://omlx.ai/benchmarks/performance/3x5co2bo), published 2026-08-24, accessed 2026-09-05. |
| 96 GB or more | BF16 becomes plausible with operating-system and runtime headroom. Meta’s BF16 checkpoint is about 59.6 GB, while its Transformers recipe observed roughly 60 GB before broader system overhead. [OFFICIAL][DEMONSTRATED] [Meta BF16 files](https://huggingface.co/meta-models/Muse-Glimmer-30B/tree/main), released 2026-08, accessed 2026-09-05. [OFFICIAL][DEMONSTRATED] [Meta agent-loop recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/agentic-fundamentals/README.md), current recipe accessed 2026-09-05. |
| 128 GB to 192 GB | BF16 plus long context and larger working sets has practical headroom, but no published Apple benchmark was found proving full 131K-context performance at these capacities. |

Do not size from weight files alone. Vision projector, runtime allocations, temporary buffers, and KV cache add memory.

### Measured Apple-silicon throughput

Meta measured M4 Max at 23.7 tokens per second without DFlash and 37.8 with DFlash, batch one, greedy decoding, using ExecuTorch. Meta measured M5 Max at 26.6 and 50.2 tokens per second respectively. [OFFICIAL][DEMONSTRATED] [Meta Glimmer model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), released 2026-08, accessed 2026-09-05.

A separate 64 GB M4 Max, 40-core benchmark of a 4-bit MLX build reported approximately:

- 1K context: 187.7 prompt tokens per second, 41 generation tokens per second, 17.7 GB peak.
- 4K context: 224.5 prompt tokens per second, 64.1 generation tokens per second, 18.2 GB peak.
- 8K context: 30.3 generation tokens per second, 19.4 GB peak.
- 16K context: 19.7 generation tokens per second, 22.1 GB peak.
- 32K context: 21 generation tokens per second, 28.1 GB peak.
- 64K context: 127.7 prompt tokens per second, 19.6 generation tokens per second, 41.6 GB peak.

[COMMUNITY][DEMONSTRATED] [OMLX M4 Max benchmark](https://omlx.ai/benchmarks/performance/3x5co2bo), published 2026-08-24, accessed 2026-09-05.

No hardware-identified M2 Max, M2 Ultra, M3 Max, M3 Ultra, M4 Ultra, or 192 GB measurement reliable enough for inclusion was found.

### Runtime recommendation

1. **llama.cpp:** first choice for a scriptable Apple-silicon OpenAI endpoint, because Meta directly verifies its GGUF, vision projector, ATEM tool parser, Jinja template, and reasoning separation. [OFFICIAL][DEMONSTRATED] [Meta llama.cpp recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), current recipe accessed 2026-09-05.

2. **LM Studio Bionic:** first choice for a GUI and easy local API. LM Studio launched Glimmer support in partnership with Meta and exposes an OpenAI-compatible server on port 1234. [OFFICIAL][ASSERTION] [LM Studio Glimmer launch](https://lmstudio.ai/blog/muse-glimmer), published 2026-08-10, accessed 2026-09-05.

3. **MLX-VLM:** attractive for Apple-native experimentation and structured-output support, but the Glimmer conversions are community artifacts and version compatibility has moved quickly. [COMMUNITY][ASSERTION] [MLX-VLM repository](https://github.com/Blaizzy/mlx-vlm), accessed 2026-09-05.

4. **vLLM:** use for BF16 Linux GPU serving, not as the default Apple-silicon runtime. Meta’s recipe estimates about 60 GB for BF16 and documents native reasoning and tool parsers. [OFFICIAL][DEMONSTRATED] [Meta vLLM recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/vllm.md), current recipe accessed 2026-09-05.

5. **Ollama:** do not make it the primary path until its exact Glimmer template and tool parser pass canaries. Meta’s early quickstart marked Ollama and LM Studio validation as pending, while LM Studio subsequently announced support. [OFFICIAL][ASSERTION] [Meta quickstart](https://github.com/meta-models/meta-oss-cookbook/blob/main/quickstart/README.md), current recipe accessed 2026-09-05. [OFFICIAL][ASSERTION] [LM Studio Glimmer launch](https://lmstudio.ai/blog/muse-glimmer), published 2026-08-10, accessed 2026-09-05.

### Copy-paste llama.cpp installation and serving

Meta’s official recipe requires llama.cpp master because Glimmer support landed after the then-current tagged release. [OFFICIAL][DEMONSTRATED] [Meta llama.cpp recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), current recipe accessed 2026-09-05.

```bash
python3 -m pip install -U huggingface_hub

hf download meta-models/Muse-Glimmer-30B-GGUF \
  --local-dir ./muse-glimmer \
  --include "muse-glimmer-30B-kquant-17gb.gguf" \
  --include "mmproj-kquant.gguf" \
  --include "dflash-kquant.gguf"

git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp

cmake -B build \
  -DGGML_METAL=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLAMA_BUILD_UI=OFF \
  -DLLAMA_USE_PREBUILT_UI=OFF

cmake --build build \
  -j"$(sysctl -n hw.ncpu)" \
  --target llama-server llama-cli llama-mtmd-cli
```

Move or reference the downloaded model directory, then serve:

```bash
./build/bin/llama-server \
  -m ../muse-glimmer/muse-glimmer-30B-kquant-17gb.gguf \
  --mmproj ../muse-glimmer/mmproj-kquant.gguf \
  -ngl 99 \
  -c 131072 \
  -np 1 \
  --host 127.0.0.1 \
  --port 8080 \
  --api-key local-muse \
  --jinja \
  --reasoning-format deepseek \
  --chat-template-kwargs '{"reasoning_strength":"low"}'
```

For speculative decoding, add:

```text
-md ../muse-glimmer/dflash-kquant.gguf
--spec-type draft-dflash
-ngld 99
--spec-draft-n-max 4
```

Meta documents `-np 1` because llama.cpp divides the configured total context among slots. [OFFICIAL][DEMONSTRATED] [Meta llama.cpp recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), current recipe accessed 2026-09-05.

Smoke test:

```bash
curl -s --noproxy '*' \
  http://127.0.0.1:8080/v1/chat/completions \
  -H "Authorization: Bearer local-muse" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "muse-glimmer",
    "messages": [
      {
        "role": "user",
        "content": "What is 17 * 23? Return only the integer."
      }
    ],
    "temperature": 0,
    "max_tokens": 1024,
    "chat_template_kwargs": {
      "reasoning_strength": "low"
    }
  }'
```

### LM Studio endpoint

LM Studio’s local server starts with:

```bash
lms server start
```

Its default port is 1234 and the API is OpenAI Chat Completions compatible. Download Glimmer from the Bionic model catalog first. [OFFICIAL][ASSERTION] [LM Studio Glimmer launch](https://lmstudio.ai/blog/muse-glimmer), published 2026-08-10, accessed 2026-09-05.

```bash
curl http://127.0.0.1:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "YOUR_LOADED_MUSE_GLIMMER_ID",
    "messages": [
      {"role": "user", "content": "Return exactly: ready"}
    ],
    "temperature": 0,
    "max_tokens": 1024
  }'
```

### MLX-VLM endpoint

MLX-VLM documents this server form and exposes OpenAI-compatible chat and Responses endpoints. Glimmer-specific loading should be verified against the installed MLX-VLM release. [COMMUNITY][ASSERTION] [MLX-VLM repository](https://github.com/Blaizzy/mlx-vlm), accessed 2026-09-05.

```bash
python3 -m pip install -U mlx-vlm

mlx_vlm.server \
  --model mlx-community/Muse-Glimmer-30B-4bit
```

Then call:

```bash
curl http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mlx-community/Muse-Glimmer-30B-4bit",
    "messages": [
      {"role": "user", "content": "Return exactly: ready"}
    ],
    "temperature": 0,
    "max_tokens": 1024
  }'
```

A prior MLX-VLM issue showed `/v1/models` returning an empty list even when a model was loaded; that issue was later closed through follow-up changes. Use `/health` and an actual completion, not model enumeration alone, to establish readiness. [COMMUNITY][DEMONSTRATED] [MLX-VLM issue 1133](https://github.com/Blaizzy/mlx-vlm/issues/1133), published 2026-05-06, older source, accessed 2026-09-05.

A newer issue reports an Anthropic-compatible `/v1/messages` crash when an assistant tool-call turn has null text content. Prefer the OpenAI-compatible `/v1/chat/completions` path for Glimmer tools until the installed version is confirmed fixed. [COMMUNITY][DEMONSTRATED] [MLX-VLM issue 1785](https://github.com/Blaizzy/mlx-vlm/issues/1785), published 2026-08, accessed 2026-09-05.

### Chat template and reasoning quirks

Glimmer uses recipient-scoped channels:

- `to=self` for reasoning.
- `to=<tool>.<fn>` for tools.
- `to=user` for the final answer.

`<|eom|>` ends a message while allowing the turn to continue. `<|eot|>` and `<|end_of_text|>` end the turn. [OFFICIAL][DEMONSTRATED] [Meta agent-loop recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/agentic-fundamentals/README.md), current recipe accessed 2026-09-05.

Tool calls use Meta’s ATEM block format internally. llama.cpp and vLLM parse that into ordinary OpenAI `tool_calls` when configured with Meta’s recipe. [OFFICIAL][DEMONSTRATED] [Meta agent-loop recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/agentic-fundamentals/README.md), current recipe accessed 2026-09-05.

llama.cpp does not implement `reasoning_effort` for Glimmer. Use:

```json
{
  "chat_template_kwargs": {
    "reasoning_strength": "low"
  }
}
```

Supported documented strengths are `low`, `medium`, `high`, and `xhigh`, and the embedded template defaults to `high`. [OFFICIAL][DEMONSTRATED] [Meta llama.cpp recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), current recipe accessed 2026-09-05.

`--reasoning-format deepseek` places reasoning in `message.reasoning_content` and keeps final `message.content` clean. [OFFICIAL][DEMONSTRATED] [Meta llama.cpp recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), current recipe accessed 2026-09-05.

### Local tool-call canary

```bash
curl -s --noproxy '*' \
  http://127.0.0.1:8080/v1/chat/completions \
  -H "Authorization: Bearer local-muse" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "muse-glimmer",
    "messages": [
      {
        "role": "user",
        "content": "Use get_weather for Paris. Do not answer from memory."
      }
    ],
    "tools": [
      {
        "type": "function",
        "function": {
          "name": "get_weather",
          "description": "Get current weather.",
          "parameters": {
            "type": "object",
            "properties": {
              "city": {"type": "string"},
              "units": {
                "type": "string",
                "enum": ["celsius", "fahrenheit"]
              }
            },
            "required": ["city"],
            "additionalProperties": false
          }
        }
      }
    ],
    "tool_choice": "auto",
    "temperature": 0,
    "max_tokens": 2048,
    "chat_template_kwargs": {
      "reasoning_strength": "low"
    }
  }'
```

Meta’s recipe demonstrates a `finish_reason: "tool_calls"` result and a parsed OpenAI-style call when these server flags are used. [OFFICIAL][DEMONSTRATED] [Meta llama.cpp recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), current recipe accessed 2026-09-05.

### Local versus OpenRouter

OpenRouter’s Glimmer route costs $0.30 per million input tokens and $1.10 per million output tokens. [OFFICIAL][ASSERTION] [OpenRouter Glimmer comparison](https://openrouter.ai/compare/x-ai/grok-4.6/meta/muse-glimmer-30b), no publish date visible, accessed 2026-09-05.

Arithmetic examples:

| Workload | OpenRouter token charge |
|---|---:|
| 1M input, 100K output | $0.41 |
| 10M input, 1M output | $4.10 |
| 100M input, 10M output | $41.00 |

These figures exclude cache discounts, retries, and any provider-specific extras. [COMMUNITY][DEMONSTRATED] [OpenRouter Glimmer comparison](https://openrouter.ai/compare/x-ai/grok-4.6/meta/muse-glimmer-30b), no publish date visible, accessed 2026-09-05.

Use local when:

- The Mac already exists.
- Prompts are private.
- Work is repeated enough to justify setup.
- Roughly 20 to 60 generated tokens per second is acceptable on measured M4 Max configurations.
- You can maintain the template and runtime.

Use OpenRouter when:

- Burst concurrency matters.
- No local setup is desired.
- Large context would pressure unified memory.
- A provider’s optimized serving is worth the token charge.
- Local model or runtime qualification is incomplete.

No defensible power-cost or hardware-amortization break-even point was found.

## 11. Operating card

1. **Clear the 18+ OpenRouter preference before putting Spark into an unattended queue.** [COMMUNITY][DEMONSTRATED] [OpenRouter Muse catalog](https://openrouter.ai/models?input_modalities=image%2Ctext), accessed 2026-09-05.

2. **Send sensitive or proprietary work only to standard Spark, never Contributor.** [COMMUNITY][ASSERTION] [Vercel release-note mirror](https://traceary.com/vercel/2026-09-02-muse-spark-1-3-now-available-on-ai-gateway), published 2026-09-02, accessed 2026-09-05.

3. **Use Contributor for disposable, public, synthetic, or explicitly approved execution.** [OFFICIAL][ASSERTION] [OpenRouter comparison](https://openrouter.ai/compare/meta/muse-spark-1.3/meta/muse-spark-1.3-contributor), accessed 2026-09-05.

4. **Set reasoning explicitly so upstream defaults cannot silently change task economics.** [OFFICIAL][ASSERTION] [OpenRouter reasoning guide](https://openrouter.ai/docs/guides/best-practices/reasoning-tokens), accessed 2026-09-05.

5. **Start ordinary agent loops at low or medium effort.** [COMMUNITY][ASSERTION] [Empirio Spark documentation](https://docs.empiriolabs.ai/models/muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

6. **Reserve high and xhigh for multi-file coding, difficult diagnosis, planning, and review.** [OFFICIAL][ASSERTION] [Meta Glimmer model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), released 2026-08, accessed 2026-09-05.

7. **Do not send Spark `max` until the live model metadata confirms it.** [OFFICIAL][ASSERTION] [Meta Spark 1.3 announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

8. **Treat `exclude` as trace suppression, not reasoning disablement.** [OFFICIAL][ASSERTION] [OpenRouter reasoning guide](https://openrouter.ai/docs/guides/best-practices/reasoning-tokens), accessed 2026-09-05.

9. **Give tool turns at least 1,024 completion tokens during qualification.** [COMMUNITY][DEMONSTRATED] [JCode issue 817](https://github.com/1jehuang/jcode/issues/817), published 2026-08-05, accessed 2026-09-05.

10. **Detect empty content plus `finish_reason: "length"` as reasoning-budget exhaustion.** [OFFICIAL][DEMONSTRATED] [Meta llama.cpp recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), accessed 2026-09-05.

11. **Preserve `reasoning_details` unchanged across tool turns.** [OFFICIAL][ASSERTION] [OpenRouter reasoning guide](https://openrouter.ai/docs/guides/best-practices/reasoning-tokens), accessed 2026-09-05.

12. **Keep system prompts, tools, and durable context byte-stable at the prefix.** [OFFICIAL][ASSERTION] [OpenRouter prompt-caching guide](https://openrouter.ai/docs/guides/best-practices/prompt-caching), accessed 2026-09-05.

13. **Count a cache hit only when `cached_tokens` says it happened.** [OFFICIAL][ASSERTION] [OpenRouter usage accounting](https://openrouter.ai/docs/cookbook/administration/usage-accounting), accessed 2026-09-05.

14. **Do not depend on a Spark cache TTL that OpenRouter does not publish.** [OFFICIAL][ASSERTION] [OpenRouter prompt-caching guide](https://openrouter.ai/docs/guides/best-practices/prompt-caching), accessed 2026-09-05.

15. **Use strict JSON Schema, then validate the returned object locally.** [OFFICIAL][ASSERTION] [OpenRouter structured-output guide](https://openrouter.ai/docs/guides/features/structured-outputs), accessed 2026-09-05.

16. **Use response healing only for non-streaming malformed JSON, never as a truncation fix.** [OFFICIAL][ASSERTION] [OpenRouter response healing](https://openrouter.ai/docs/guides/features/plugins/response-healing), accessed 2026-09-05.

17. **Force a named tool when external verification is mandatory.** [OFFICIAL][ASSERTION] [OpenRouter tool-calling guide](https://openrouter.ai/docs/guides/features/tool-calling), accessed 2026-09-05.

18. **Keep parallel tool calls disabled until the harness passes a multi-call canary.** [OFFICIAL][ASSERTION] [OpenRouter tool-calling guide](https://openrouter.ai/docs/guides/features/tool-calling), accessed 2026-09-05.

19. **Assemble streamed tool-call deltas completely before executing them.** [OFFICIAL][ASSERTION] [OpenRouter tool-calling tutorial](https://openrouter.ai/blog/tutorials/tool-calling/), published 2026-08, accessed 2026-09-05.

20. **Canary audio, YouTube, and large media instead of trusting the modality badge alone.** [OFFICIAL][ASSERTION] [OpenRouter multimodal overview](https://openrouter.ai/docs/guides/overview/multimodal/overview), accessed 2026-09-05.

21. **Use base64 data URIs for local images and video, but raw base64 for audio.** [OFFICIAL][ASSERTION] [OpenRouter multimodal overview](https://openrouter.ai/docs/guides/overview/multimodal/overview), accessed 2026-09-05.

22. **Select the PDF parser explicitly when cost or OCR behavior matters.** [OFFICIAL][ASSERTION] [OpenRouter PDF guide](https://openrouter.ai/docs/guides/overview/multimodal/pdfs), accessed 2026-09-05.

23. **Qualify 200K, 500K, and 900K contexts before calling the route 1M-ready.** [OFFICIAL][ASSERTION] [Meta Spark 1.3 announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

24. **Use temperature zero for tool, JSON, and deterministic coding canaries.** [OFFICIAL][DEMONSTRATED] [Meta llama.cpp recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), accessed 2026-09-05.

25. **Give Spark an exact deliverable, stop condition, and blocked condition.** [OFFICIAL][ASSERTION] [Meta Spark 1.3 announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

26. **Retry 429s with jitter and honor `Retry-After`.** [OFFICIAL][ASSERTION] [OpenRouter limits](https://openrouter.ai/docs/api_reference/limits), accessed 2026-09-05.

27. **Verify external side effects before retrying a failed agent turn.** [OFFICIAL][ASSERTION] [OpenRouter tool-calling guide](https://openrouter.ai/docs/guides/features/tool-calling), accessed 2026-09-05.

28. **Run local Glimmer with llama.cpp master, `--jinja`, and `--reasoning-format deepseek`.** [OFFICIAL][DEMONSTRATED] [Meta llama.cpp recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), accessed 2026-09-05.

29. **Never put `<|eom|>` in Glimmer’s stop set.** [OFFICIAL][DEMONSTRATED] [Meta agent-loop recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/agentic-fundamentals/README.md), accessed 2026-09-05.

30. **Use `chat_template_kwargs.reasoning_strength` locally, not `reasoning_effort`.** [OFFICIAL][DEMONSTRATED] [Meta llama.cpp recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), accessed 2026-09-05.

## Not found after searching

The following were not found in a public Meta or OpenRouter source by the cutoff:

1. **Spark-specific OpenRouter reasoning metadata response:** exact `supported_efforts`, `default_effort`, `default_enabled`, and `mandatory` fields for both 1.3 IDs. Queries included `"meta/muse-spark-1.3" "default_effort"`, `"muse-spark-1.3" "reasoning_effort" OpenRouter`, and OpenRouter model API searches.

2. **Unsupported reasoning-value behavior:** exact HTTP code and error string for `reasoning.effort: "none"`, `"max"`, or an invalid string on either Spark route. Queries included `"Muse Spark 1.3" unsupported reasoning effort error`, `"reasoning_effort none" "muse-spark-1.3"`, and `"reasoning effort max" Meta Spark 1.3`.

3. **Spark trace behavior through OpenRouter:** a successful 1.3 response demonstrating whether `include_reasoning: true` returns readable reasoning, encrypted details, summaries, or nothing. The supplied probe stopped at the age gate.

4. **Meta-specific cache minimum and TTL:** no official minimum prefix, entry TTL, cache-write cost, invalidation policy, or explicit `cache_control` support for either Spark tier. Queries included `"muse-spark-1.3-contributor" cache`, `"Muse Spark prompt cache TTL"`, `"Meta Model API cache_control Muse Spark"`, and `"OpenRouter Meta prompt cache minimum tokens"`.

5. **Contributor-specific cache semantics:** no evidence that Contributor has a different cache lifetime or creation rule from standard, beyond its lower cache-read price.

6. **Spark JSON Schema conformance matrix:** no 1.3 test covering integer enums, numeric bounds, recursive `$ref`, nested `additionalProperties`, unsupported keywords, silent keyword removal, or schema-size limits. Queries included `"Muse Spark 1.3" JSON schema structured output`, `"muse-spark recursion json_schema"`, and `"Muse Spark additionalProperties minimum maximum"`.

7. **Spark 1.3 framework issues for most stacks:** no reproducible model-specific issue was found for the OpenAI SDK, Vercel AI SDK, LangChain, Pydantic AI, Cline, Roo, Aider, Cursor, Windsurf, or Zed. Searches combined each framework name with `"Muse Spark 1.3"`, `"meta/muse-spark-1.3"`, `tool_calls`, `reasoning`, `400`, and `OpenRouter`.

8. **A stable built-in 1.3 profile in every coding agent:** only Muse Code and OpenCode service evidence was found. No public built-in profile confirmation was found for Aider, Cursor, Windsurf, Zed, Roo, Claude Code, or Codex CLI.

9. **Spark-specific multimedia limits:** no official maximum image count, video duration, audio duration, file size, pixel limit, PDF page limit for native mode, or total request-body size. Queries included `"Muse Spark 1.3 video limit"`, `"Muse Spark audio duration"`, `"OpenRouter Muse Spark file size 400"`, and `"Meta Model API Spark PDF pages"`.

10. **Spark video and audio per-minute prices:** OpenRouter documents generic token-based multimedia charging, not a Spark-specific minute rate.

11. **YouTube support on Meta’s Spark upstream:** OpenRouter’s YouTube documentation is specific to Gemini AI Studio.

12. **Reproducible Spark multimedia 400s:** no exact public Spark 1.3 OpenRouter 400 error was found for image, video, audio, or PDF calls.

13. **OpenRouter 1M qualification:** no successful public 1.3 request at 200K, 500K, or 1M, no request-size ceiling, and no needle-in-a-haystack curve. Queries included `"Muse Spark 1.3" 1M context test`, `"muse-spark-1.3" 500K latency`, `"OpenRouter Muse Spark 200K"`, and `"Muse Spark needle context"`.

14. **Effort-by-effort OpenRouter latency:** no consistent TTFT, output tokens per second, reasoning tokens, and end-to-end table for minimal, low, medium, high, and xhigh.

15. **A fixed paid Spark rate limit:** no per-key or per-minute numeric cap was published. OpenRouter documents only general upstream capacity and platform protection.

16. **Precise age-attestation semantics:** no public document explained storage duration, revocation, verification method, legal jurisdiction, data shared with Meta, or the full list of gated models. Queries included `"site:openrouter.ai age_18plus"`, `"missing_attestation_types age_18plus"`, `"OpenRouter 18+ attestation policy"`, and `"Meta Muse Spark under 18 terms"`.

17. **Spark-specific Meta terms causing OpenRouter’s gate:** the Glimmer model card contains an under-18 clause, but the public Spark 1.3 announcement does not connect that clause to OpenRouter.

18. **Apple performance across the requested hardware set:** no trustworthy, hardware-identified M2 Max, M2 Ultra, M3 Max, M3 Ultra, M4 Ultra, or 192 GB result was found. Queries combined those chip names with `"Muse Glimmer"`, `tok/s`, `llama.cpp`, `MLX`, and `benchmark`.

19. **Full 131K local Glimmer speed and memory on Apple silicon:** the clearest independent benchmark stopped at 64K.

20. **Local power-cost break-even:** no measured watts-per-token comparison was found, so a hardware or electricity break-even against OpenRouter’s $0.30 and $1.10 rates cannot be stated.

## Sources

- [Meta, Introducing Muse Spark 1.3](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.
- [Meta, Muse product page](https://ai.meta.com/llama?via=aivyx), no publish date visible, accessed 2026-09-05.
- [Meta, Introducing Muse Spark 1.1 and Meta Model API](https://ai.meta.com/blog/introducing-muse-spark-meta-model-api/), published 2026-07-09, accessed 2026-09-05.
- [Meta, initial Muse Spark announcement](https://ai.meta.com/blog/introducing-muse-spark-msl/), published 2026-04-08, older source, accessed 2026-09-05.
- [Meta, Muse Glimmer 30B model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), released 2026-08, accessed 2026-09-05.
- [Meta, Muse Glimmer BF16 files](https://huggingface.co/meta-models/Muse-Glimmer-30B/tree/main), released 2026-08, accessed 2026-09-05.
- [Meta, Muse Glimmer GGUF repository](https://huggingface.co/meta-models/Muse-Glimmer-30B-GGUF), released 2026-08, accessed 2026-09-05.
- [Meta, llama.cpp Glimmer recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/llama-cpp.md), current recipe accessed 2026-09-05.
- [Meta, vLLM Glimmer recipe](https://github.com/meta-models/meta-oss-cookbook/blob/main/inference-server/vllm.md), current recipe accessed 2026-09-05.
- [Meta, Glimmer quickstart](https://github.com/meta-models/meta-oss-cookbook/blob/main/quickstart/README.md), current recipe accessed 2026-09-05.
- [Meta, Glimmer agentic fundamentals](https://github.com/meta-models/meta-oss-cookbook/blob/main/agentic-fundamentals/README.md), current recipe accessed 2026-09-05.
- [OpenRouter, Spark 1.3 model page](https://openrouter.ai/meta/muse-spark-1.3), published 2026-09-02, accessed 2026-09-05.
- [OpenRouter, Spark standard and Contributor comparison](https://openrouter.ai/compare/meta/muse-spark-1.3/meta/muse-spark-1.3-contributor), accessed 2026-09-05.
- [OpenRouter, Muse catalog](https://openrouter.ai/models?input_modalities=image%2Ctext), accessed 2026-09-05.
- [OpenRouter, Glimmer comparison and pricing](https://openrouter.ai/compare/x-ai/grok-4.6/meta/muse-glimmer-30b), accessed 2026-09-05.
- [OpenRouter, Spark 1.2 route metrics](https://openrouter.ai/meta/muse-spark-1.2), published 2026-08-05, accessed 2026-09-05.
- [OpenRouter, reasoning guide](https://openrouter.ai/docs/guides/best-practices/reasoning-tokens), no publish date visible, accessed 2026-09-05.
- [OpenRouter, prompt-caching guide](https://openrouter.ai/docs/guides/best-practices/prompt-caching), no publish date visible, accessed 2026-09-05.
- [OpenRouter, usage accounting](https://openrouter.ai/docs/cookbook/administration/usage-accounting), no publish date visible, accessed 2026-09-05.
- [OpenRouter, structured outputs](https://openrouter.ai/docs/guides/features/structured-outputs), no publish date visible, accessed 2026-09-05.
- [OpenRouter, response healing](https://openrouter.ai/docs/guides/features/plugins/response-healing), no publish date visible, accessed 2026-09-05.
- [OpenRouter, tool calling](https://openrouter.ai/docs/guides/features/tool-calling), no publish date visible, accessed 2026-09-05.
- [OpenRouter, tool-calling tutorial](https://openrouter.ai/blog/tutorials/tool-calling/), published 2026-08, accessed 2026-09-05.
- [OpenRouter, Python Chat request reference](https://openrouter.ai/docs/client-sdks/python/api-reference/chat), no publish date visible, accessed 2026-09-05.
- [OpenRouter, image understanding](https://openrouter.ai/docs/guides/overview/multimodal/image-understanding), no publish date visible, accessed 2026-09-05.
- [OpenRouter, video inputs](https://openrouter.ai/docs/guides/overview/multimodal/videos), no publish date visible, accessed 2026-09-05.
- [OpenRouter, audio inputs](https://openrouter.ai/docs/guides/overview/multimodal/audio), no publish date visible, accessed 2026-09-05.
- [OpenRouter, speech-to-text](https://openrouter.ai/docs/guides/overview/multimodal/stt), no publish date visible, accessed 2026-09-05.
- [OpenRouter, PDF inputs](https://openrouter.ai/docs/guides/overview/multimodal/pdfs), no publish date visible, accessed 2026-09-05.
- [OpenRouter, multimodal overview](https://openrouter.ai/docs/guides/overview/multimodal/overview), no publish date visible, accessed 2026-09-05.
- [OpenRouter, provider selection](https://openrouter.ai/docs/guides/routing/provider-selection), no publish date visible, accessed 2026-09-05.
- [OpenRouter, API limits](https://openrouter.ai/docs/api_reference/limits), no publish date visible, accessed 2026-09-05.
- [OpenRouter, model-list API](https://openrouter.ai/docs/api/api-reference/models/get-models), no publish date visible, accessed 2026-09-05.
- [OpenRouter, Claude Code integration](https://openrouter.ai/docs/cookbook/coding-agents/claude-code-integration), no publish date visible, accessed 2026-09-05.
- [OpenRouter, automatic code review cookbook](https://openrouter.ai/docs/cookbook/coding-agents/automatic-code-review), no publish date visible, accessed 2026-09-05.
- [OpenRouter, migration guide](https://openrouter.ai/docs/cookbook/get-started/migrate-to-openrouter), no publish date visible, accessed 2026-09-05.
- [OpenAI, Codex configuration reference](https://developers.openai.com/codex/config-reference/), accessed 2026-09-05.
- [OpenCode, provider documentation](https://opencode.ai/docs/providers), updated 2026-09-04, accessed 2026-09-05.
- [OpenCode issue 47237](https://github.com/anomalyco/opencode/issues/47237), published 2026-09-04, accessed 2026-09-05.
- [Cline, OpenRouter configuration](https://docs.cline.bot/provider-config/openrouter), no publish date visible, accessed 2026-09-05.
- [Aider, OpenRouter guide](https://aider.chat/docs/llms/openrouter.html), no publish date visible, accessed 2026-09-05.
- [Aider, options reference](https://aider.chat/docs/config/options.html), no publish date visible, accessed 2026-09-05.
- [Kilo issue 12273](https://github.com/Kilo-Org/kilocode/issues/12273), published 2026-07-16, accessed 2026-09-05.
- [Kilo releases](https://github.com/Kilo-Org/kilocode/releases), accessed 2026-09-05.
- [LiteLLM pull request 36717](https://github.com/BerriAI/litellm/pull/36717), published 2026-08, accessed 2026-09-05.
- [JCode issue 817](https://github.com/1jehuang/jcode/issues/817), published 2026-08-05, accessed 2026-09-05.
- [Awesome Muse Spark compatibility notes](https://github.com/accretional/awesome-muse-spark/blob/main/README.md), accessed 2026-09-05.
- [Empirio, Muse Spark 1.3 documentation](https://docs.empiriolabs.ai/models/muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.
- [LLMTR, Muse Spark gateway guide](https://llmtr.com/docs/en/gateway/meta-muse-spark/), no publish date visible, accessed 2026-09-05.
- [Vercel Spark 1.3 release-note mirror](https://traceary.com/vercel/2026-09-02-muse-spark-1-3-now-available-on-ai-gateway), published 2026-09-02, accessed 2026-09-05.
- [Artificial Analysis, Spark 1.3 xhigh providers](https://artificialanalysis.ai/models/muse-spark-1-3-xhigh/providers), accessed 2026-09-05.
- [The Known Good, Spark Contributor](https://www.theknowngood.com/models/meta-muse-spark-1-3-contributor/), updated 2026-09-04, accessed 2026-09-05.
- [OpenClaw, Spark 1.2 Contributor cache report](https://www.reddit.com/r/openclaw/comments/1vudz9x/muse_spark_12_contributor_cache_not_working_well/), published 2026-08-21, accessed 2026-09-05.
- [LocalLLaMA, Glimmer overthinking report](https://www.reddit.com/r/LocalLLaMA/comments/1vlhdu7/muse_glimmer_overthinking_like_crazy/), published 2026-08, accessed 2026-09-05.
- [LM Studio, Run Muse Glimmer locally](https://lmstudio.ai/blog/muse-glimmer), published 2026-08-10, accessed 2026-09-05.
- [MLX community Muse Glimmer collection](https://huggingface.co/collections/mlx-community/muse-glimmer), accessed 2026-09-05.
- [MLX community Glimmer 8-bit](https://huggingface.co/mlx-community/Muse-Glimmer-30B-8bit), accessed 2026-09-05.
- [MLX community Glimmer BF16](https://huggingface.co/mlx-community/Muse-Glimmer-30B-bf16), accessed 2026-09-05.
- [MLX-VLM repository](https://github.com/Blaizzy/mlx-vlm), accessed 2026-09-05.
- [MLX-VLM issue 1133](https://github.com/Blaizzy/mlx-vlm/issues/1133), published 2026-05-06, older source, accessed 2026-09-05.
- [MLX-VLM issue 1785](https://github.com/Blaizzy/mlx-vlm/issues/1785), published 2026-08, accessed 2026-09-05.
- [OMLX M4 Max Glimmer benchmark](https://omlx.ai/benchmarks/performance/3x5co2bo), published 2026-08-24, accessed 2026-09-05.