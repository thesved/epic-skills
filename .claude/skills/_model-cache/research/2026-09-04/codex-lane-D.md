# Lane D: GPT-6 Astra harness mechanics, research cutoff 2026-09-04

*Method: I used the OpenAI Docs skill to prioritize first-party model, API, Codex, and safety references. Unless stated otherwise, every linked page was accessed 2026-09-04.*

## TLDR: decisions for our routing

1. **Install Codex CLI 0.153.1 or later before requesting Astra.** `[OFFICIAL][DEMONSTRATED]` OpenAI's 0.153.1 hotfix backported the `gpt-6-astra` model catalog entry, model instructions, policy, and unified execution configuration. Invoke it with `codex -m gpt-6-astra` or `codex exec -m gpt-6-astra`. No bare `gpt-6` alias is documented. [OpenAI Codex PR 42605, published 2026-09-03](https://github.com/openai/codex/pull/42605), [Codex models documentation, accessed 2026-09-04](https://learn.chatgpt.com/docs/models)

2. **Route only the hardest long-horizon coding, research, computer-use, and document-production jobs to Astra.** `[OFFICIAL][ASSERTION]` OpenAI positions Astra for those workloads and claims it can use fewer output tokens and lower total cost per difficult task, but no universal cost-per-task benchmark proves that claim. Its raw API prices are `$10.00` input, `$1.00` cached input, `$12.50` cache write, and `$50.00` output per 1 million tokens, exactly `2.5x` GPT-5.6 Sol's `$4.00` input and `$20.00` output rates. [Astra model reference, accessed 2026-09-04](https://developers.openai.com/api/docs/models/gpt-6-astra), [latest-model guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra)

3. **Start Astra at `high` for frontier work, fall back to `medium` or `low` for easier jobs, and reserve `xhigh` or `max` for proven hard cases.** `[OFFICIAL][DEMONSTRATED]` The API accepts exactly `low`, `medium`, `high`, `xhigh`, and `max`. It does not accept `none`. No official Astra API default effort was found. Codex's displayed `Medium` default is a Codex product setting, not proof of the raw API default. [Astra model reference, accessed 2026-09-04](https://developers.openai.com/api/docs/models/gpt-6-astra), [Codex models documentation, accessed 2026-09-04](https://learn.chatgpt.com/docs/models)

4. **Treat Codex Ultra as a harness mode, not a sixth Astra API effort.** `[OFFICIAL][DEMONSTRATED]` Ultra maps wire-level reasoning to `max` and permits proactive subagent delegation under Codex's multi-agent v2 behavior. There is no Astra API value named `ultra` and no stable `--ultra` flag documented. Where account and catalog eligibility permit, the configuration form is `-c model_reasoning_effort=ultra`. [Codex models documentation, accessed 2026-09-04](https://learn.chatgpt.com/docs/models), [Codex multi-agent tests, accessed 2026-09-04](https://github.com/openai/codex/blob/main/codex-rs/core/tests/suite/multi_agent_mode.rs)

5. **Use Responses API, not Chat Completions, for serious Astra agents.** `[OFFICIAL][DEMONSTRATED]` Both endpoints accept Astra, but OpenAI says Astra tool calling requires Responses. Responses also exposes persisted reasoning, computer use, hosted shell, MCP, tool search, asynchronous tools, mid-turn steering, and configuration updates. [Astra model reference, accessed 2026-09-04](https://developers.openai.com/api/docs/models/gpt-6-astra), [latest-model guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra)

6. **Set `max_output_tokens` generously because it covers hidden reasoning and visible output together.** `[OFFICIAL][DEMONSTRATED]` If the budget is exhausted during reasoning, the response can end with `status: "incomplete"` and `incomplete_details.reason: "max_output_tokens"` before producing useful visible text. OpenAI recommends starting with at least `25,000` tokens when exploring reasoning workloads. [Reasoning guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/reasoning)

7. **Exploit explicit prompt caching only for stable prefixes of at least 1,024 tokens.** `[OFFICIAL][DEMONSTRATED]` Use `prompt_cache_key`, `prompt_cache_options: {"mode":"explicit","ttl":"30m"}`, and up to four `prompt_cache_breakpoint` markers. Exact prefix identity matters. Changing the model, tool order or schema, `parallel_tool_calls`, structured-output schema, effort, verbosity, or context-management configuration can invalidate reuse. A model migration from Sol to Astra necessarily misses the old cache. [Prompt caching guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/prompt-caching)

8. **On ChatGPT plans, monitor actual remaining allowance rather than treating published ranges as quotas.** `[OFFICIAL][DEMONSTRATED]` OpenAI publishes estimated Astra local-message ranges per five-hour period: Plus `3 to 30`, Pro 5x `15 to 150`, Pro 20x `60 to 600`, and Standard Business `3 to 30`. Weekly limits may also apply. Use `/status` or the usage dashboard. [Codex pricing documentation, accessed 2026-09-04](https://learn.chatgpt.com/docs/pricing)

9. **Do not route Astra through OpenRouter, Bedrock, Vercel, Cursor, Windsurf, Cline, Copilot, or aider yet unless the provider's live catalog proves the model exists.** `[OFFICIAL][DEMONSTRATED]` As of the cutoff, an OpenRouter lookup for the expected `openai/gpt-6-astra` slug was not available, AWS pricing had no Astra row, and no official Astra listing was found for the other named products. Azure Microsoft Foundry is the only independently documented third-party route beginning rollout, through a Limited Access Program. [OpenRouter model catalog, accessed 2026-09-04](https://openrouter.ai/models/), [AWS Bedrock pricing, accessed 2026-09-04](https://aws.amazon.com/bedrock/pricing/), [Microsoft Foundry announcement, published 2026-09-03](https://azure.microsoft.com/en-us/blog/gpt-6-astra-frontier-intelligence-for-work-now-available-in-microsoft-foundry/)

10. **Prompt Astra with explicit autonomy, delegation, stopping, testing, and output-style rules.** `[OFFICIAL][ASSERTION]` OpenAI warns that Astra asks more clarifying questions, is unusually sensitive to `AGENTS.md` and skills, may delegate less unless told when to delegate, may over-test, and tends toward detailed formatting and recurring phrases. The orchestrator should spell out expected initiative, subagent count, verification depth, and concise output shape. [latest-model guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra)

## 1. Codex CLI

### Version and model selection

`[OFFICIAL][DEMONSTRATED]` The first concrete Codex release evidence for Astra is `0.153.1`, released 2026-09-03. OpenAI PR 42605 says the hotfix backported an API-supported but hidden Astra catalog entry, prompts, policies, and `unified_exec`. The visible default model remained unchanged. Consequently, the safe minimum is:

```text
codex 0.153.1
model = "gpt-6-astra"
```

[Codex 0.153.1 release, published 2026-09-03](https://github.com/openai/codex/releases/tag/rust-v0.153.1), [OpenAI Codex PR 42605, published 2026-09-03](https://github.com/openai/codex/pull/42605)

`[OFFICIAL][DEMONSTRATED]` The documented selector is `codex -m gpt-6-astra`. The bare identifier `gpt-6` is not listed as an alias. No official test or documented error proves that `gpt-6` returns HTTP 400, so the exact result is **NOT FOUND after searching the Codex model catalog, Astra model reference, API error documentation, and Codex GitHub issues**. By contrast, the current model guide explicitly says the `gpt-5.6` alias routes to `gpt-5.6-sol`, so the premise that bare `gpt-5.6` necessarily returns 400 is not true in the documented current API. [Codex models documentation, accessed 2026-09-04](https://learn.chatgpt.com/docs/models), [latest-model guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra)

### Effort and Ultra

`[OFFICIAL][DEMONSTRATED]` Raw Astra accepts `low`, `medium`, `high`, `xhigh`, and `max`. Codex displays Low, Medium, High, Extra High, Max, and Ultra. Ultra is Codex-side orchestration: tests show its outbound reasoning effort becomes `max`, while Codex injects proactive delegation instructions when multi-agent mode v2 is active. In older multi-agent mode it does not inject the proactive instruction. [Astra model reference, accessed 2026-09-04](https://developers.openai.com/api/docs/models/gpt-6-astra), [Codex multi-agent tests, accessed 2026-09-04](https://github.com/openai/codex/blob/main/codex-rs/core/tests/suite/multi_agent_mode.rs)

Practical configuration:

```toml
model = "gpt-6-astra"
model_reasoning_effort = "high"

[features]
multi_agent = true
```

For eligible product configurations, `-c model_reasoning_effort=ultra` selects the Codex harness behavior. There is no public Responses API field that requests Ultra or automatic Codex subagents. [Codex configuration schema, accessed 2026-09-04](https://raw.githubusercontent.com/openai/codex/main/codex-rs/core/config.schema.json)

### Searchable notes and context management

`[OFFICIAL][DEMONSTRATED]` Codex 0.153 introduced an experimental context feature that replaces repeated single-summary compaction with token-budget-aware context management, history notes, and searchable earlier context. Enable it with:

```toml
[features]
context_management = true

[context_management]
experimental_mode = true
```

The feature is documented for Plus, Pro, and Pro Lite users authenticated through ChatGPT. It is off by default. [Codex 0.153.0 release, published 2026-09-03](https://github.com/openai/codex/releases/tag/rust-v0.153.0), [Codex configuration reference, accessed 2026-09-04](https://learn.chatgpt.com/docs/config-file/config-reference)

`[OFFICIAL][DEMONSTRATED]` PR 42385 describes token-budget context, history notes, and a `new_context` mechanism. It excludes custom providers, provider credentials, non-Codex endpoints, and temporary structured threads. [OpenAI Codex PR 42385, merged 2026-09-02](https://github.com/openai/codex/pull/42385)

`[OFFICIAL][DEMONSTRATED]` **NOT FOUND after searching the configuration reference, release notes, PR 42385, and non-interactive documentation:** no documented user-visible filesystem directory for the notes, and no definitive statement that every `codex exec` invocation uses them. Persistent resumable exec threads appear eligible, but an invocation using temporary structured-thread behavior, such as schema-constrained temporary execution, may be excluded. That final sentence is an inference from the exclusion documented in PR 42385, not an explicit guarantee.

### `codex exec` changes from 0.152 through 0.155

`[OFFICIAL][DEMONSTRATED]` Version 0.152.0, published 2026-09-01, added credential refresh in TUI and exec, including Bedrock; generic rate-limit banner actions for usage, credits, reset, and plans; shell timeouts beyond one hour in app-server; and `mcp_servers.<id>.tool_output_token_limit`. It also changed the planning tool to disabled by default, recoverable with `tools.update_plan.enabled=true`. [Codex 0.152.0 release, published 2026-09-01](https://github.com/openai/codex/releases/tag/rust-v0.152.0)

`[OFFICIAL][DEMONSTRATED]` Version 0.153.0 added compressed-rollout support to `codex exec resume`, plugin management, `tui.auto_recap=false`, app-server reconnection, nullable `model` and `reasoningEffort` metadata, and an early Plus or Team warning when less than half of the approximately five-hour allowance remains. It moved `disable_paste_burst` under `tui.disable_paste_burst`, while retaining fallback for the old key. [Codex 0.153.0 release, published 2026-09-03](https://github.com/openai/codex/releases/tag/rust-v0.153.0)

`[OFFICIAL][DEMONSTRATED]` Current non-interactive documentation exposes stdin prompts with `codex exec -`, `-o` or `--output-last-message`, `--output-schema`, `--ephemeral`, `--ignore-user-config`, `--ignore-rules`, and `--json`. Current source additionally exposes `--strict-config`, `--color`, and `--skip-git-repo-check`. The source labels `--full-auto` as a removed compatibility trap. The release that introduced every individual flag was not established from the 0.152 and 0.153 notes. [Non-interactive mode documentation, accessed 2026-09-04](https://learn.chatgpt.com/docs/non-interactive-mode), [Codex exec CLI source, accessed 2026-09-04](https://github.com/openai/codex/blob/main/codex-rs/exec/src/cli.rs)

`[OFFICIAL][DEMONSTRATED]` Stable release pages for `0.154.0` and `0.155.0` returned 404 at the cutoff. Therefore there are no stable 0.154 or 0.155 exec changes to report. Pre-release artifacts are not sufficient evidence for production instructions. [Codex 0.154.0 release URL, checked 2026-09-04](https://github.com/openai/codex/releases/tag/rust-v0.154.0), [Codex 0.155.0 release URL, checked 2026-09-04](https://github.com/openai/codex/releases/tag/rust-v0.155.0)

### Usage limits and banner

`[OFFICIAL][DEMONSTRATED]` Published Astra estimates per five-hour period are:

| Plan label | Estimated local messages |
|---|---:|
| Plus | `3 to 30` |
| Pro 5x | `15 to 150` |
| Pro 20x | `60 to 600` |
| Standard Business | `3 to 30` |

Weekly limits may apply. These are estimates, not guaranteed request quotas, because usage varies with task complexity and context. Check `/status` or the dashboard before routing an expensive run. [Codex pricing documentation, accessed 2026-09-04](https://learn.chatgpt.com/docs/pricing)

`[OFFICIAL][DEMONSTRATED]` Codex credits price Astra at `250` input credits, `25` cached-input credits, and `1,250` output credits per 1 million tokens. ChatGPT Fast applies a `2.5x` Astra Standard credit multiplier. This differs from the API Fast multiplier of `2x`. No Astra-specific wording for the rate-limit banner was found. The verified banner work is generic rate-limit action routing, plus the 0.153 early-warning behavior. [Codex pricing documentation, accessed 2026-09-04](https://learn.chatgpt.com/docs/pricing), [Codex 0.152.0 release, published 2026-09-01](https://github.com/openai/codex/releases/tag/rust-v0.152.0)

### App-server and steering

`[OFFICIAL][DEMONSTRATED]` `codex app-server` supports `turn/steer` during an active turn. `expectedTurnId` must match the active turn, steering fails when no turn is active, and steering does not create a new `turn/started` event. Turn-level configuration overrides are not accepted through steering. The protocol is model-neutral, and 0.153.1 gives app-server an Astra catalog entry, but no Astra-specific steering conformance test was found. [Codex app-server documentation, accessed 2026-09-04](https://learn.chatgpt.com/docs/app-server), [OpenAI Codex PR 42605, published 2026-09-03](https://github.com/openai/codex/pull/42605)

`[COMMUNITY][DEMONSTRATED]` A Windows report against 0.152 showed `--ignore-user-config` with read-only sandboxing rejecting every command with the exact message `rejected: blocked by policy`, while the process exited with code `0`. Reported workarounds were removing `--ignore-user-config` or adding `-c windows.sandbox="elevated"`. This is not Astra-specific, but it can silently corrupt unattended `codex exec` results. [Codex issue 42172, published 2026-09-02](https://github.com/openai/codex/issues/42172)

## 2. Responses API

### Model envelope and pricing

`[OFFICIAL][DEMONSTRATED]` Astra has a `1,050,000` token context window, `128,000` maximum output tokens, and an April 30, 2026 knowledge cutoff. Standard prices per 1 million tokens are `$10.00` input, `$1.00` cached input, `$12.50` cache write, and `$50.00` output. Above `272,000` input tokens, the whole request receives `2x` input and cache pricing and `1.5x` output pricing. Batch and Flex are `50%` of Standard. API Fast is `2x`. [Astra model reference, accessed 2026-09-04](https://developers.openai.com/api/docs/models/gpt-6-astra)

A basic standard-tier cost formula is:

```text
cost =
  uncached_input_tokens / 1,000,000 * $10.00
+ cached_input_tokens / 1,000,000 * $1.00
+ cache_write_tokens / 1,000,000 * $12.50
+ output_tokens / 1,000,000 * $50.00
```

For example, `10,000` uncached input tokens plus `2,000` output tokens costs exactly `$0.20`, before tools and service-tier multipliers. This is arithmetic derived from the official tariff.

### Full relevant request shape

`[OFFICIAL][DEMONSTRATED]` The relevant Responses shape is:

```json
{
  "model": "gpt-6-astra",
  "input": [],
  "instructions": "Optional developer instruction",
  "reasoning": {
    "effort": "high",
    "mode": "standard",
    "summary": "auto",
    "context": "all_turns"
  },
  "text": {
    "verbosity": "medium",
    "format": {
      "type": "json_schema",
      "name": "result",
      "strict": true,
      "schema": {
        "type": "object",
        "properties": {},
        "required": [],
        "additionalProperties": false
      }
    }
  },
  "service_tier": "default",
  "prompt_cache_key": "application-routing-v1",
  "prompt_cache_options": {
    "mode": "explicit",
    "ttl": "30m"
  },
  "tools": [
    {"type": "web_search"},
    {"type": "file_search", "vector_store_ids": ["vs_..."]},
    {"type": "code_interpreter", "container": {"type": "auto"}},
    {"type": "shell", "environment": {"type": "container_auto"}},
    {"type": "computer"},
    {"type": "tool_search"},
    {
      "type": "mcp",
      "server_label": "internal",
      "server_url": "https://example.com/mcp",
      "require_approval": "always"
    }
  ],
  "parallel_tool_calls": true,
  "max_tool_calls": 20,
  "max_output_tokens": 25000,
  "store": false,
  "previous_response_id": "resp_...",
  "include": ["reasoning.encrypted_content"],
  "stream": true
}
```

[Responses create reference, accessed 2026-09-04](https://developers.openai.com/api/reference/cli/resources/responses/methods/create), [shell guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/tools-shell), [computer-use guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/tools-computer-use), [tool-search guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/tools-tool-search), [MCP guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/tools-connectors-mcp)

Important constraints:

- `[OFFICIAL][DEMONSTRATED]` There is no top-level `reasoning_context` field. The current field is `reasoning.context`, with documented values including `auto`, `all_turns`, and `current_turn`. [Responses create reference, accessed 2026-09-04](https://developers.openai.com/api/reference/cli/resources/responses/methods/create)

- `[OFFICIAL][DEMONSTRATED]` `reasoning.mode` can be `standard` or inherited `pro` behavior. This is independent of `reasoning.effort`. [latest-model guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra)

- `[OFFICIAL][DEMONSTRATED]` `previous_response_id` cannot be combined with a `conversation` object. With `store:false` or Zero Data Retention, request `include:["reasoning.encrypted_content"]` and replay the encrypted item when continuing. [Responses create reference, accessed 2026-09-04](https://developers.openai.com/api/reference/cli/resources/responses/methods/create)

- `[OFFICIAL][DEMONSTRATED]` The generic API schema lists `auto`, `default`, `flex`, `fast`, `priority`, and `ultrafast` service tiers. Astra supports Standard, Flex, Fast, and Priority subject to account and region. `ultrafast` is not documented for Astra. Fast and Priority are unavailable with EU data residency, and Astra Fast has no published latency SLA. [latest-model guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra)

- `[OFFICIAL][DEMONSTRATED]` Supported `include` values include `web_search_call.action.sources`, `code_interpreter_call.outputs`, `computer_call_output.output.image_url`, `file_search_call.results`, `message.input_image.image_url`, and `reasoning.encrypted_content`. The generic schema also exposes `message.output_text.logprobs`, but Astra's migration guide says to remove it. [Responses create reference, accessed 2026-09-04](https://developers.openai.com/api/reference/cli/resources/responses/methods/create), [latest-model guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra)

### Deprecated or unsupported fields

`[OFFICIAL][DEMONSTRATED]` Remove `temperature`, `top_p`, and `top_logprobs` when migrating a Responses request to Astra. For Chat Completions, also remove `logprobs`. Replace deprecated `prompt_cache_retention` with `prompt_cache_options.ttl: "30m"`. The generic `user` field is deprecated in favor of `safety_identifier` and `prompt_cache_key`. `truncation` is also marked deprecated in the current Responses schema. [latest-model guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra), [Responses create reference, accessed 2026-09-04](https://developers.openai.com/api/reference/cli/resources/responses/methods/create)

### Tooling, streaming, Batch, and structured output

`[OFFICIAL][DEMONSTRATED]` Supported Responses tools include web search, file search, image generation, code interpreter, hosted shell, apply patch, skills, computer use, MCP, and tool search. Asynchronous tool calls are new for Astra and later. Mark a custom or function tool with `async:true`, then return its original `call_id`. Hosted built-in tools are not async tools. OpenAI advises against combining async tools with `parallel_tool_calls` in multi-agent workflows. [Astra model reference, accessed 2026-09-04](https://developers.openai.com/api/docs/models/gpt-6-astra), [async tool-calling guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/async-tool-calling)

`[OFFICIAL][DEMONSTRATED]` Common streaming events are `response.created`, `response.output_text.delta`, `response.output_text.done`, `response.completed`, and `error`. Astra can also emit safety event `safety.alert.created`. [Streaming Responses guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/streaming-responses), [misalignment monitoring guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/safety-checks/misalignment-monitoring)

`[OFFICIAL][DEMONSTRATED]` Batch supports both `/v1/responses` and `/v1/chat/completions`, uses a `24h` completion window, requires one model per input file, and receives the documented `50%` Astra discount. [Batch guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/batch), [Astra model reference, accessed 2026-09-04](https://developers.openai.com/api/docs/models/gpt-6-astra)

`[OFFICIAL][DEMONSTRATED]` Strict structured output uses `text.format.type:"json_schema"` and `strict:true`. The root must be an object, root-level `anyOf` is forbidden, all fields must be listed in `required`, nullable fields should use a union with `null`, and objects need `additionalProperties:false`. A refusal or incomplete response may not conform to the schema, so consumers must inspect response status before parsing. [Structured Outputs guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/structured-outputs)

### Safety and gated-feature errors

`[OFFICIAL][DEMONSTRATED]` Cybersecurity enforcement can return the exact code `cyber_policy`, including during streaming. Misalignment enforcement can return HTTP `403`, type `invalid_request_error`, and code `misalignment_policy_violation`. OpenAI says not to retry that error. Safety-record lookup can return `safety_alert_not_found`. [Cybersecurity checks guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/safety-checks/cybersecurity), [misalignment monitoring guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/safety-checks/misalignment-monitoring)

`[OFFICIAL][DEMONSTRATED]` Automatic misalignment stopping covers persisted-reasoning, WebSocket, and compaction workflows. Plain Responses traffic is monitored but not automatically stopped in the same way, and Chat Completions is not covered by this system. [Misalignment monitoring guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/safety-checks/misalignment-monitoring)

`[OFFICIAL][DEMONSTRATED]` **NOT FOUND after searching the model reference, Trusted Access announcement, API error guide, cyber guide, and safety guide:** an exact error string for an account that lacks Trusted Access or another Astra-specific entitlement.

## 3. Migration from GPT-5.6 Sol

`[OFFICIAL][DEMONSTRATED]` Preserve the effective Sol effort when it is supported. Map Sol `none` or minimal behavior to Astra `low`; Astra has no `none`. Keep request-level effort unchanged when using mid-conversation `configuration_update`, because changing the request-level effort changes the prompt-cache identity. [latest-model guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra)

`[OFFICIAL][DEMONSTRATED]` Astra supports a `configuration_update` input item over supported stateful flows, allowing reasoning effort changes during a conversation while retaining cache eligibility if the outer request-level effort stays fixed. Mid-turn steering is available over WebSocket. [latest-model guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra)

`[OFFICIAL][ASSERTION]` Prompt changes should be behavioral, not ceremonial:

- Tell Astra whether to ask questions or proceed under reasonable assumptions.
- Tell it explicitly when to delegate and how many subagents are useful.
- Define the required testing depth and stopping condition.
- Specify output formatting and concision.
- Treat `AGENTS.md`, skills, and tool descriptions as high-impact instructions.

OpenAI reports that Astra is more sensitive to these controls than GPT-5.6. [latest-model guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra)

`[OFFICIAL][DEMONSTRATED]` Cache invalidation is expected on migration. Prompt caching requires an exact prefix and includes the model, tool definitions and order, `parallel_tool_calls`, schema, effort, verbosity, and context-management configuration. Astra also has a different model key from Sol. [Prompt caching guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/prompt-caching)

`[COMMUNITY][ASSERTION]` **NOT FOUND after searching same-day Codex GitHub issues, OpenAI community posts, Reddit, and provider discussions:** a credible reproducible report of Astra-specific tool-call regressions, refusal-category changes, stopped-working prompt patterns, or a measured cache-invalidation surprise. Most same-day posts were impressions without request bodies, logs, bills, or controlled comparisons and should not drive routing.

## 4. Third-party routes

| Route | Status at cutoff | Exact evidence and cost |
|---|---|---|
| OpenRouter | Not listed | `[OFFICIAL][DEMONSTRATED]` No `openai/gpt-6-astra` catalog entry was found. OpenRouter normally uses `author/model` slugs and returns 404 for a missing model. Underlying inference has no markup, but credit purchases carry `5.5%` with an `$0.80` minimum. BYOK is free for the first `1M` requests per month, then charged `5%` of provider cost. [Model API documentation](https://openrouter.ai/docs/guides/overview/models), [OpenRouter FAQ](https://openrouter.ai/docs/faq) |
| AWS Bedrock | Announced for coming days, not priced or cataloged | `[OFFICIAL][DEMONSTRATED]` Astra was announced as following over the next days, but AWS's pricing page had no Astra row. Model ID, regions, and price are **NOT FOUND**. [AWS Bedrock pricing](https://aws.amazon.com/bedrock/pricing/), [OpenAI Astra announcement discussion, published 2026-09-03](https://community.openai.com/) |
| Microsoft Foundry | Limited rollout began 2026-09-03 | `[OFFICIAL][DEMONSTRATED]` Standard Global short-context rates are `$10` input, `$1` cached input, `$12.50` cache write, `$50` output. Long-context rates are `$20`, `$2`, `$25`, `$75`. Standard US Data Zone short rates are `$11`, `$1.10`, `$13.75`, `$55`; long rates are `$22`, `$2.20`, `$27.50`, `$82.50`, all per 1 million tokens. Exact deployment model ID and region list were not supplied. [Microsoft announcement, published 2026-09-03](https://azure.microsoft.com/en-us/blog/gpt-6-astra-frontier-intelligence-for-work-now-available-in-microsoft-foundry/) |
| Vercel AI Gateway | Astra not found | `[OFFICIAL][DEMONSTRATED]` Vercel supports OpenAI-compatible Responses generally and advertises zero inference markup, but no Astra catalog or changelog entry was found. The generic free tier is `$5/month` of usage. [Vercel pricing, accessed 2026-09-04](https://vercel.com/docs/ai-gateway/pricing), [Responses support announcement](https://vercel.com/changelog/ai-gateway-supports-openais-responses-api) |
| Cursor | Astra not found | `[OFFICIAL][DEMONSTRATED]` No official Astra listing was found. Cursor says selected models consume their underlying API list price, effectively `1.0x`, with plan allowances applying first. Current plan labels include Pro `$20`, Pro Plus `$70`, and Ultra `$400`. [Cursor pricing documentation, accessed 2026-09-04](https://docs.cursor.com/account/pricing) |
| Windsurf | Not found | `[OFFICIAL][DEMONSTRATED]` No Astra model ID, availability date, or multiplier was found on official Windsurf or Cognition model pages. Cognition announced Astra as coming to Devin, but that is not evidence of Windsurf availability. [Devin Astra announcement, published 2026-09-03](https://devin.ai/blog/gpt-6-astra) |
| Cline | Not found | `[OFFICIAL][DEMONSTRATED]` Cline can use OpenRouter generally, but no Astra-specific entry or cost multiplier was found. OpenRouter itself lacked the model at the cutoff. [Cline OpenRouter documentation, accessed 2026-09-04](https://docs.cline.bot/provider-config/openrouter), [OpenRouter catalog](https://openrouter.ai/models/) |
| GitHub Copilot | Not found | `[OFFICIAL][DEMONSTRATED]` No Astra model listing, preview announcement, premium-request multiplier, or release date was found in GitHub Copilot's official supported-model documentation. |
| Claude Code | Cannot use Astra as its core model | `[OFFICIAL][DEMONSTRATED]` Claude Code's `--model` selector accepts Claude model names and aliases. Its LLM gateway support is for Claude models behind Anthropic-compatible infrastructure. Claude Code could invoke an external Codex or REST command as a tool, but that is not Claude Code running Astra as its own model. [Claude Code CLI reference](https://docs.anthropic.com/en/docs/claude-code/cli-usage), [Claude Code LLM gateway guide](https://docs.anthropic.com/en/docs/claude-code/llm-gateway) |
| aider | Conditional, unverified | `[OFFICIAL][DEMONSTRATED]` aider accepts provider-prefixed model names and OpenAI API keys, but no Astra metadata or verified Astra invocation was found. `aider --model openai/gpt-6-astra` is therefore conditional and unverified. [aider model documentation](https://aider.chat/docs/troubleshooting/models-and-keys.html) |

## 5. Agents SDK and agent framework

`[OFFICIAL][DEMONSTRATED]` **NOT FOUND after searching openai-agents-python, openai-agents-js, their documentation, examples, release notes, and repository text:** Astra-specific model settings, handoff guidance, or computer-use examples. Existing Python documentation still demonstrates GPT-5.6 Sol and accepts arbitrary model strings through the Responses-backed model provider. [OpenAI Agents Python configuration](https://openai.github.io/openai-agents-python/config/), [Agents Python quickstart](https://openai.github.io/openai-agents-python/quickstart)

`[OFFICIAL][DEMONSTRATED]` Existing framework mechanisms remain applicable: agents as tools, handoffs, parallel orchestration with `asyncio.gather`, hosted tools, and computer use. These are framework features, not proof that every Astra feature has dedicated SDK plumbing. [Agents orchestration guide](https://openai.github.io/openai-agents-python/multi_agent/), [Agents tools guide](https://openai.github.io/openai-agents-python/tools/)

`[OFFICIAL][DEMONSTRATED]` No public Agents SDK API named Ultra was found. Codex Ultra is a Codex harness behavior. Astra's API-level asynchronous tools and configuration updates are separate Responses primitives, while Agents SDK handoffs remain framework orchestration.

## 6. Copy-paste shell one-liners

### A. Codex exec, Astra, high effort, prompt from stdin, report output

**VERIFIED-BY-DOCS**, syntax and model selection are documented. Actual success still depends on account rollout and Codex 0.153.1 or later.

```sh
printf '%s\n' 'YOUR PROMPT' | codex exec -m gpt-6-astra -c model_reasoning_effort=high -o report.md -
```

[Codex models documentation, accessed 2026-09-04](https://learn.chatgpt.com/docs/models), [non-interactive mode documentation, accessed 2026-09-04](https://learn.chatgpt.com/docs/non-interactive-mode)

### B. Responses API, high effort, explicit caching, strict structured output

**VERIFIED-BY-DOCS**, provided the account has Astra API access. The stable cached prefix should be at least `1,024` tokens for caching eligibility.

```sh
curl https://api.openai.com/v1/responses -H "Authorization: Bearer $OPENAI_API_KEY" -H "Content-Type: application/json" -d '{"model":"gpt-6-astra","input":[{"role":"developer","content":[{"type":"input_text","text":"STABLE REUSABLE POLICY PREFIX OF AT LEAST 1024 TOKENS","prompt_cache_breakpoint":{"mode":"explicit"}}]},{"role":"user","content":[{"type":"input_text","text":"Assess this task and return the routing decision."}]}],"reasoning":{"effort":"high","mode":"standard","summary":"auto","context":"all_turns"},"text":{"verbosity":"medium","format":{"type":"json_schema","name":"routing_decision","strict":true,"schema":{"type":"object","properties":{"route":{"type":"string"},"rationale":{"type":"string"}},"required":["route","rationale"],"additionalProperties":false}}},"prompt_cache_key":"routing-v1","prompt_cache_options":{"mode":"explicit","ttl":"30m"},"max_output_tokens":25000,"store":false,"include":["reasoning.encrypted_content"],"service_tier":"default"}'
```

[Responses create reference, accessed 2026-09-04](https://developers.openai.com/api/reference/cli/resources/responses/methods/create), [prompt caching guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/prompt-caching), [structured outputs guide, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/structured-outputs)

### C. OpenRouter Responses, once a real Astra ID exists

**UNVERIFIED.** `openai/gpt-6-astra` was not listed at the cutoff. Do not put this into production until `GET /api/v1/model/openai/gpt-6-astra` succeeds and reports the required parameters.

```sh
curl https://openrouter.ai/api/v1/responses -H "Authorization: Bearer $OPENROUTER_API_KEY" -H "Content-Type: application/json" -d '{"model":"openai/gpt-6-astra","input":[{"role":"user","content":[{"type":"input_text","text":"Assess this task and return the routing decision."}]}],"reasoning":{"effort":"high"},"text":{"format":{"type":"json_schema","name":"routing_decision","strict":true,"schema":{"type":"object","properties":{"route":{"type":"string"},"rationale":{"type":"string"}},"required":["route","rationale"],"additionalProperties":false}}},"max_output_tokens":25000}'
```

`[OFFICIAL][DEMONSTRATED]` OpenRouter's `X-OpenRouter-Cache: true` is whole-response caching for identical requests, defaulting to `300` seconds, and is not the same as OpenAI prompt-prefix caching. Do not assume OpenAI's `prompt_cache_options` pass through until the Astra endpoint metadata confirms it. [OpenRouter Responses reference](https://openrouter.ai/docs/api/api-reference/responses/create-responses), [OpenRouter response-caching guide](https://openrouter.ai/docs/guides/features/response-caching)

## Gaps and open questions

1. `[OFFICIAL][DEMONSTRATED]` The exact raw API default reasoning effort for Astra is not documented.
2. `[OFFICIAL][DEMONSTRATED]` No documented bare `gpt-6` alias or exact 400 response was found.
3. `[OFFICIAL][DEMONSTRATED]` No exact Trusted Access entitlement error string was found.
4. `[OFFICIAL][DEMONSTRATED]` Codex searchable-note filesystem location and definitive non-interactive eligibility rules were not published.
5. `[OFFICIAL][DEMONSTRATED]` Stable Codex 0.154.0 and 0.155.0 did not exist at the cutoff URLs.
6. `[OFFICIAL][DEMONSTRATED]` AWS model ID, regions, and prices were not published.
7. `[OFFICIAL][DEMONSTRATED]` OpenRouter had no verified Astra slug, provider, or price.
8. `[OFFICIAL][DEMONSTRATED]` Vercel, Cursor, Windsurf, Cline, GitHub Copilot, and aider had no verified Astra launch listing.
9. `[COMMUNITY][DEMONSTRATED]` No credible same-day community benchmark supplied controlled Sol-versus-Astra tool traces, billing evidence, or reproducible refusal comparisons.
10. `[OFFICIAL][DEMONSTRATED]` No Agents SDK Ultra API or Astra-specific Agents SDK example was published.

## Sources

All accessed 2026-09-04 unless a publication date is stated.

- OpenAI, [GPT-6 Astra model reference](https://developers.openai.com/api/docs/models/gpt-6-astra)
- OpenAI, [latest-model guide for Astra](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra)
- OpenAI, [Responses create reference](https://developers.openai.com/api/reference/cli/resources/responses/methods/create)
- OpenAI, [Reasoning guide](https://developers.openai.com/api/docs/guides/reasoning)
- OpenAI, [Prompt caching guide](https://developers.openai.com/api/docs/guides/prompt-caching)
- OpenAI, [Structured Outputs guide](https://developers.openai.com/api/docs/guides/structured-outputs)
- OpenAI, [Streaming Responses guide](https://developers.openai.com/api/docs/guides/streaming-responses)
- OpenAI, [Batch guide](https://developers.openai.com/api/docs/guides/batch)
- OpenAI, [Async tool-calling guide](https://developers.openai.com/api/docs/guides/async-tool-calling)
- OpenAI, [Shell tool guide](https://developers.openai.com/api/docs/guides/tools-shell)
- OpenAI, [Computer-use guide](https://developers.openai.com/api/docs/guides/tools-computer-use)
- OpenAI, [Tool-search guide](https://developers.openai.com/api/docs/guides/tools-tool-search)
- OpenAI, [MCP guide](https://developers.openai.com/api/docs/guides/tools-connectors-mcp)
- OpenAI, [Cybersecurity checks guide](https://developers.openai.com/api/docs/guides/safety-checks/cybersecurity)
- OpenAI, [Misalignment monitoring guide](https://developers.openai.com/api/docs/guides/safety-checks/misalignment-monitoring)
- OpenAI, [Astra safety overview, published 2026-09-03](https://openai.com/index/safety-overview-gpt-6-astra/)
- OpenAI, [Codex models documentation](https://learn.chatgpt.com/docs/models)
- OpenAI, [Codex pricing documentation](https://learn.chatgpt.com/docs/pricing)
- OpenAI, [Codex configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference)
- OpenAI, [Codex non-interactive mode](https://learn.chatgpt.com/docs/non-interactive-mode)
- OpenAI, [Codex app-server documentation](https://learn.chatgpt.com/docs/app-server)
- OpenAI, [Codex 0.152.0 release, published 2026-09-01](https://github.com/openai/codex/releases/tag/rust-v0.152.0)
- OpenAI, [Codex 0.153.0 release, published 2026-09-03](https://github.com/openai/codex/releases/tag/rust-v0.153.0)
- OpenAI, [Codex 0.153.1 release, published 2026-09-03](https://github.com/openai/codex/releases/tag/rust-v0.153.1)
- OpenAI, [Codex PR 42605, published 2026-09-03](https://github.com/openai/codex/pull/42605)
- OpenAI, [Codex PR 42385, merged 2026-09-02](https://github.com/openai/codex/pull/42385)
- OpenAI, [Codex exec CLI source](https://github.com/openai/codex/blob/main/codex-rs/exec/src/cli.rs)
- OpenAI, [Codex multi-agent tests](https://github.com/openai/codex/blob/main/codex-rs/core/tests/suite/multi_agent_mode.rs)
- OpenAI, [Codex configuration schema](https://raw.githubusercontent.com/openai/codex/main/codex-rs/core/config.schema.json)
- Community, [Codex issue 42172, published 2026-09-02](https://github.com/openai/codex/issues/42172)
- Microsoft, [Astra in Microsoft Foundry, published 2026-09-03](https://azure.microsoft.com/en-us/blog/gpt-6-astra-frontier-intelligence-for-work-now-available-in-microsoft-foundry/)
- AWS, [Amazon Bedrock pricing](https://aws.amazon.com/bedrock/pricing/)
- OpenRouter, [model catalog](https://openrouter.ai/models/)
- OpenRouter, [model API documentation](https://openrouter.ai/docs/guides/overview/models)
- OpenRouter, [Responses API reference](https://openrouter.ai/docs/api/api-reference/responses/create-responses)
- OpenRouter, [response caching](https://openrouter.ai/docs/guides/features/response-caching)
- OpenRouter, [FAQ and fees](https://openrouter.ai/docs/faq)
- Vercel, [AI Gateway pricing](https://vercel.com/docs/ai-gateway/pricing)
- Cursor, [pricing documentation](https://docs.cursor.com/account/pricing)
- Anthropic, [Claude Code CLI reference](https://docs.anthropic.com/en/docs/claude-code/cli-usage)
- Anthropic, [Claude Code LLM gateway guide](https://docs.anthropic.com/en/docs/claude-code/llm-gateway)
- aider, [models and keys documentation](https://aider.chat/docs/troubleshooting/models-and-keys.html)
- OpenAI, [Agents Python configuration](https://openai.github.io/openai-agents-python/config/)
- OpenAI, [Agents Python quickstart](https://openai.github.io/openai-agents-python/quickstart)
- OpenAI, [Agents orchestration guide](https://openai.github.io/openai-agents-python/multi_agent/)
- OpenAI, [Agents tools guide](https://openai.github.io/openai-agents-python/tools/)