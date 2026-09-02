# Lane D report: the harness around Claude Fable 5.1

Research cutoff: **2026-09-02, Asia/Bangkok**  
Evidence window: **2026-08-25 through 2026-09-02**, with older material used only for comparison.

## Evidence notation

- **OFFICIAL**: Anthropic documentation, release notes, or Anthropic-maintained repositories.
- **UNOFFICIAL**: community-maintained extraction or analysis.
- **DIRECT**: directly visible in a specification, prompt extraction, release artifact, or changelog.
- **ASSERTION**: claimed behavior or quality difference that was not independently reproduced here.
- Documentation without a publication date is marked **accessed 2026-09-02**.

## TLDR: the 10 decisions that matter most

1. **Claude Code 2.1.257 is the first public release that names Fable 5.1; 2.1.258 is the latest release found.** The `fable` tier now normally selects Fable 5.1, but Anthropic says the Claude apps gateway temporarily leaves the `fable` and `best` aliases on Fable 5. Select `claude-fable-5-1` explicitly when model identity matters.  
   **[OFFICIAL | DIRECT | 2026-09-01]** Quote: “Added support for Fable 5.1.” [Claude Code v2.1.257](https://github.com/anthropics/claude-code/releases/tag/v2.1.257)

2. **Fable 5.1 supports all five effort levels: `low`, `medium`, `high`, `xhigh`, and `max`. Its default is `high`.** Fable is not Claude Code’s account-wide default tier, however. Current Claude Code defaults depend on plan and environment and favor Opus 5 or Sonnet 5.  
   **[OFFICIAL | DIRECT | accessed 2026-09-02]** Quote: “Default effort is high.” [Claude Code model configuration](https://code.claude.com/docs/en/model-config)

3. **Changing `/effort` still invalidates the Claude Code prompt cache.** Claude Code includes effort in its cache key and recomputes the request after an effort change. The new API per-message effort mechanism is different: it was specifically designed to change effort without invalidating the preserved prefix.  
   **[OFFICIAL | DIRECT | accessed 2026-09-02]** Quote: “Changing effort recomputes the full request.” [Claude Code prompt caching](https://code.claude.com/docs/en/prompt-caching)

4. **Fable 5.1 can issue fewer parallel tool calls unless prompted explicitly.** Anthropic says implicit long research loops may degrade to one tool call per turn. Add a batching instruction that requests every presently independent item in one response.  
   **[OFFICIAL | ASSERTION | 2026-09-01]** Quote: “parallel tool calling may be more variable.” [What is new in Fable 5.1](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1)

5. **Treat the conversation as append-only.** Editing, removing, or reordering earlier messages, changing the top-level system prompt or tools, or changing fetched URL bytes can invalidate thinking and the cache. Appending new messages, moving cache markers, and server-side compaction remain safe.  
   **[OFFICIAL | DIRECT | 2026-09-01]** Quote: “Preserve the conversation as an append-only log.” [Fable 5.1 migration guide](https://platform.claude.com/docs/en/models/fable-5-1/migration-guide)

6. **Forced tool selection is not supported.** `tool_choice` values `any` and named `tool` produce HTTP 400 on Fable 5.1. Use `auto` with strict tools or structured outputs when a valid structured result is mandatory.  
   **[OFFICIAL | DIRECT | 2026-09-01]** Quote: `tool_choice: type "tool" and "any" are not supported` [What is new in Fable 5.1](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1)

7. **Fable 5.1 thinking is always adaptive and is forward-incompatible with older models.** Fable 5.1 can consume older thinking blocks, but older models cannot consume Fable 5.1 thinking. The API silently removes unreadable thinking during an older-model fallback unless transformation diagnostics are enabled.  
   **[OFFICIAL | DIRECT | 2026-09-01]** Quote: “Older models cannot read Fable 5.1 thinking blocks.” [Fable 5.1 migration guide](https://platform.claude.com/docs/en/models/fable-5-1/migration-guide)

8. **Prompt-cache economics are unchanged but the defaults are easy to misstate.** Fable 5.1 cache reads cost **$0.25 per million tokens** and the minimum cacheable prefix is **512 tokens**. Claude subscription traffic inside plan gets a one-hour TTL for the main conversation. API key, usage-credit, cloud-provider, subagent, workflow, fork, and compaction traffic default to five minutes unless configured otherwise.  
   **[OFFICIAL | DIRECT | 2026-09-01 or accessed 2026-09-02]** Quote: “Cache read: $0.25 / MTok.” [Fable 5.1 overview](https://platform.claude.com/docs/en/models/fable-5-1/overview), [Claude Code prompt caching](https://code.claude.com/docs/en/prompt-caching)

9. **The output ceiling is 128K, but current Anthropic SDKs require streaming above 21,333 requested output tokens.** This is client-side validation, not a lower model limit. For `xhigh` and `max`, Anthropic recommends leaving substantial room, commonly at least 64K when using task budgets.  
   **[OFFICIAL | DIRECT | 2026-09-01 or accessed 2026-09-02]** Quote: “Maximum output: 128K tokens.” [Fable 5.1 overview](https://platform.claude.com/docs/en/models/fable-5-1/overview), [Extended thinking](https://platform.claude.com/docs/en/build-with-claude/thinking)

10. **There are two distinct fallback systems.** Fable 5.1 server-side safety fallback can route biology refusals to Opus 5 and cyber refusals to Opus 4.8. Claude Code’s `--fallback-model` handles availability failures and is separately configurable. Do not describe these as one feature.  
    **[OFFICIAL | DIRECT | 2026-09-01 or accessed 2026-09-02]** Quote: `fallbacks: "default"` [What is new in Fable 5.1](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1), [Claude Code model configuration](https://code.claude.com/docs/en/model-config)

---

# 1. Claude Code release timeline

These are all public Claude Code release-feed entries found from 2026-08-25 through the research cutoff. No public feed entries were found for 2.1.244, 2.1.249, or 2.1.253 through 2.1.256. Version 2.1.255 appears in later regression language and minimum-version documentation, but I found no separate public release-feed entry for it.

| Version | UTC release date | Relevant changes |
|---|---:|---|
| 2.1.243 | 2026-08-25 05:13 | Added cache TTL controls, model pricing configuration, model plus effort visibility in `/tasks`, Ultracode selection fixes, background-subagent wake behavior, partial `maxTurns` handling, and automatic continuation for truncated noninteractive output. |
| 2.1.245 | 2026-08-25 05:13 | Crash fix; no relevant Fable, model, effort, goal, cache, subagent, workflow, Ultracode, or memory change found. |
| 2.1.246 | 2026-08-25 22:31 | Added workflow-restart confirmation, reduced auto-mode prompt size, and capped idle `/goal` evaluation check-ins. |
| 2.1.247 | 2026-08-26 23:06 | Added cost optimization to `/claude-api`; made subagents use the session fallback chain after a first-call 404; gave `--agent` compaction its own prompt; improved noninteractive continuation and MCP failure visibility. |
| 2.1.248 | 2026-08-27 22:12 | Added `--restricted`, experimental per-agent cache TTL, cache-rendering fixes, ScheduleWakeup cache preservation, smaller workflow prompts, dynamic `/loop`, and privacy/security improvements to Ultrareview. |
| 2.1.250 | 2026-08-28 00:49 | Bug fixes only; no focal harness change found. |
| 2.1.251 | 2026-08-28 18:19 | Added model-switch hooks, subagent streaming, prompt-cache detail in `/cost`, per-model `/effort` persistence, cache-cost handling on resume, and changed `CLAUDE_CODE_SUBAGENT_MODEL` to act as a default rather than an unconditional override. |
| 2.1.252 | 2026-08-31 19:46 | Four fixes; no substantive Fable 5.1 feature entry found. |
| 2.1.257 | 2026-09-01 17:53 | Added Fable 5.1; made it the normal Fable-tier model; added forced subagent model selection; added session-only effort changes; fixed several cache and truncated-subagent cases; made forks cache-preserving; documented the temporary Claude apps gateway alias exception. |
| 2.1.258 | 2026-09-01 22:33 | Follow-up fixes, including a 2.1.255 regression; no additional Fable 5.1 feature entry found. |

## 1.1 Entries that materially affect `fable-max`

### 2.1.243: TTL, pricing, effort visibility, Ultracode

**[OFFICIAL | DIRECT | 2026-08-25]**

Short release quote: “Added `promptCacheTtl` and `subagentPromptCacheTtl` settings.”  
Source: [Claude Code v2.1.243](https://github.com/anthropics/claude-code/releases/tag/v2.1.243)

Relevant consequences:

- API and cloud-provider users can request a one-hour main-agent TTL while leaving subagents at five minutes.
- Custom `modelPricing` lets cost reporting understand nonstandard routing or gateways.
- `/tasks` exposes each task’s model and effort.
- Ultracode-selection handling was corrected.
- Noninteractive sessions can continue after output truncation.

**What the operating guide should say now:** Set cache TTLs separately for the lead agent and subagents; inspect `/tasks` to confirm that spawned work is using the intended model and effort.

### 2.1.246: `/goal` evaluator check-ins

**[OFFICIAL | DIRECT | 2026-08-25]**

Quote: “maximum of 3 idle check-ins per goal.”  
Source: [Claude Code v2.1.246](https://github.com/anthropics/claude-code/releases/tag/v2.1.246)

Current `/goal` documentation says check-ins occur after approximately 30 minutes, then one hour, then two hours, with no further idle evaluations until the user interacts.

**What the operating guide should say now:** `/goal` does not guarantee unlimited unattended evaluation. Design workflows to finish or emit actionable state within three idle checks.

### 2.1.247: subagent fallback and compaction

**[OFFICIAL | DIRECT | 2026-08-26]**

Quote: “subagents now use the session model fallback chain.”  
Source: [Claude Code v2.1.247](https://github.com/anthropics/claude-code/releases/tag/v2.1.247)

A subagent receiving a first-call 404 can move through the session availability fallback chain. An agent-selected compaction can use that agent’s own compaction prompt.

**What the operating guide should say now:** Configure availability fallback at the session level and assume it affects subagents. Treat compaction prompts as part of each agent’s operating configuration.

### 2.1.248: agent cache TTL and workflow prompt size

**[OFFICIAL | DIRECT | 2026-08-27]**

Quote: “Added `experimental.cacheTtl` agent frontmatter.”  
Source: [Claude Code v2.1.248](https://github.com/anthropics/claude-code/releases/tag/v2.1.248)

The release also reduced the workflow prompt from roughly 5.7K to 1K tokens and corrected cache loss when resuming scheduled work.

**What the operating guide should say now:** Long-lived specialist agents can declare a cache TTL, but cache policy must be evaluated separately for main sessions, subagents, and workflows.

### 2.1.251: per-model effort and subagent model semantics

**[OFFICIAL | DIRECT | 2026-08-28]**

Quote: “save your default effort level per model.”  
Source: [Claude Code v2.1.251](https://github.com/anthropics/claude-code/releases/tag/v2.1.251)

Additional direct release evidence:

- `CLAUDE_CODE_SUBAGENT_MODEL` became a default that agent configuration can override.
- Subagent streaming and prompt-cache reporting in `/cost` were added.
- pre- and post-model-switch hooks became available.
- Resume hooks gained visibility into recache costs.

**What the operating guide should say now:** Persist an explicit Fable 5.1 effort default. If subagent model consistency is mandatory, ordinary `CLAUDE_CODE_SUBAGENT_MODEL` is insufficient on its own.

### 2.1.257: Fable 5.1 launch integration

**[OFFICIAL | DIRECT | 2026-09-01]**

Quote: “Added support for Fable 5.1.”  
Source: [Claude Code v2.1.257](https://github.com/anthropics/claude-code/releases/tag/v2.1.257)

Directly relevant changes:

- Fable 5.1 became the default model behind the normal Fable tier.
- Fable 5.1 receives the 1M context window and new pricing.
- `CLAUDE_CODE_SUBAGENT_MODEL_FORCE=1` forces subagents, teammates, and workflow agents onto `CLAUDE_CODE_SUBAGENT_MODEL`, ignoring ordinary per-agent selections.
- `/effort s` and `--effort` can apply only to the current session.
- Forks preserve cache state.
- Truncated subagent streams automatically continue.
- Remote Control Bash and background-advisor cache problems were fixed.
- The Claude apps gateway temporarily leaves `fable` and `best` on Fable 5, so explicit model selection is required there.

**What the operating guide should say now:** Require Claude Code 2.1.257 or later, use the explicit Fable 5.1 model ID behind the Claude apps gateway, and use the force environment variable only when uniform subagent routing is intentional.

### 2.1.258: stabilization

**[OFFICIAL | DIRECT | 2026-09-01]**

Quote: “Fixed regressions introduced in v2.1.255.”  
Source: [Claude Code v2.1.258](https://github.com/anthropics/claude-code/releases/tag/v2.1.258)

**What the operating guide should say now:** Pin at least 2.1.258 rather than stopping at the initial 2.1.257 integration release.

Full feed: [Anthropic Claude Code release feed](https://raw.githubusercontent.com/anthropics/claude-code/main/feed.xml)

---

# 2. Claude Code model, effort, fast mode, and fallback

## 2.1 Model selection

**[OFFICIAL | DIRECT | accessed 2026-09-02]**

Claude Code recognizes the `fable` tier, but its normal account defaults are plan-dependent Opus 5 or Sonnet 5 selections. Fable 5.1 becoming the “default Fable model” does not mean Claude Code globally defaults every user to Fable.

Quote: “The `fable` alias uses the latest Fable model.”  
Source: [Claude Code model configuration](https://code.claude.com/docs/en/model-config)

**What the operating guide should say now:** Use `/model fable` for normal interactive use and the exact `claude-fable-5-1` identifier for reproducible runs, especially through gateways.

## 2.2 Effort levels

**[OFFICIAL | DIRECT | accessed 2026-09-02]**

Fable 5.1 supports:

- `low`
- `medium`
- `high`
- `xhigh`
- `max`

The default is `high`. Claude Code exposes effort through `/effort`, `--effort`, environment or settings configuration, and agent frontmatter.

Quote: “Fable 5.1: low, medium, high, xhigh, max.”  
Source: [Claude Code model configuration](https://code.claude.com/docs/en/model-config)

**What the operating guide should say now:** Use `high` as the general-purpose default, `xhigh` for difficult repository work, and `max` only when additional latency and output capacity have been budgeted.

## 2.3 Does `/effort` invalidate the cache?

**Yes in Claude Code.**

**[OFFICIAL | DIRECT | accessed 2026-09-02]**

Claude Code’s cache key includes the model and effort level. Changing `/effort` therefore creates an initial miss and recomputes the full request.

Quote: “The cache is keyed by model and effort.”  
Source: [Claude Code prompt caching](https://code.claude.com/docs/en/prompt-caching)

This differs from the new Fable 5.1 API mechanism. With beta `mid-conversation-output-config-2026-07-01`, a role `system` message can carry `output_config.effort` for subsequent turns without invalidating the preserved prefix.

**What the operating guide should say now:** Keep `/effort` stable inside a Claude Code session. On a custom API harness, use per-message output configuration when effort must change mid-conversation.

## 2.4 Ultracode

**[OFFICIAL | DIRECT | accessed 2026-09-02]**

Ultracode is a Claude Code orchestration mode exposed through `/effort ultracode`. It sends `xhigh` model effort while enabling additional workflow behavior. `ultracode` is not a sixth Fable API effort value.

Quote: “Ultracode uses xhigh effort.”  
Source: [Claude Code model configuration](https://code.claude.com/docs/en/model-config)

No launch-window evidence was found that Ultracode is exclusive to Fable 5.1.

**What the operating guide should say now:** Describe Ultracode as Claude Code orchestration layered over `xhigh`, not as an API effort level or a Fable-only capability.

## 2.5 Fast mode

**[OFFICIAL | DIRECT | accessed 2026-09-02]**

Fast mode is documented for Opus 5 and Opus 4.8, not Fable 5.1.

Quote: “Claude Opus 5 and Claude Opus 4.8 support fast mode.”  
Source: [Choosing a Claude model](https://platform.claude.com/docs/en/about-claude/models/choosing-a-model)

Claude Code may offer to switch models when `/fast` is requested on an unsupported model.

**What the operating guide should say now:** Do not present `/fast` as accelerated Fable. Staying on Fable and using fast mode are currently mutually exclusive operating choices.

## 2.6 Fallback mechanics

### Safety-category server fallback

**[OFFICIAL | DIRECT | 2026-09-01]**

With the `server-side-fallback-2026-07-01` beta and `fallbacks: "default"`:

- Fable 5.1 biology-category fallback target: Opus 5.
- Fable 5.1 cyber-category fallback target: Opus 4.8.
- The original request is not billed before output.
- Anthropic describes a fallback credit that offsets cache-switching cost.

Quote: “Permitted fallback targets are Opus 4.8 and Opus 5.”  
Source: [What is new in Fable 5.1](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1)

### Availability fallback

**[OFFICIAL | DIRECT | accessed 2026-09-02]**

Claude Code’s `--fallback-model` and session fallback chain address model availability, not category-specific refusals. As of 2.1.247, the chain can also be used by subagents after a first-call 404.

**What the operating guide should say now:** Give safety fallback and availability fallback different headings, configuration examples, and failure expectations.

---

# 3. API mechanics that changed for Fable 5.1

## 3.1 Model IDs

**[OFFICIAL | DIRECT | 2026-09-01]**

| Platform | Documented ID |
|---|---|
| Claude API | `claude-fable-5-1` |
| Claude Platform on AWS | `claude-fable-5-1` |
| Amazon Bedrock | `anthropic.claude-fable-5-1` |
| Google Cloud Vertex AI | `claude-fable-5-1` |
| Microsoft Foundry | `claude-fable-5-1` |

Source: [Fable 5.1 overview](https://platform.claude.com/docs/en/models/fable-5-1/overview)

The new provider table does not show a dated suffix or a legacy Bedrock `:0` InvokeModel identifier.

**Legacy Bedrock InvokeModel ID:** **NOT FOUND** in the Fable 5.1 model page.

The Bedrock integration documentation says Claude Code 2.1.255 or newer is required for Fable 5.1. The public Claude Code release feed first announces Fable 5.1 in 2.1.257.

**[OFFICIAL | DIRECT | accessed 2026-09-02]**  
Source: [Claude Code with Amazon Bedrock](https://platform.claude.com/docs/en/build-with-claude/claude-in-amazon-bedrock)

**What the operating guide should say now:** Use the documented provider IDs exactly. For Claude Code, set the practical minimum to 2.1.257 and recommend 2.1.258.

## 3.2 Context and output

**[OFFICIAL | DIRECT | 2026-09-01]**

- Context window: 1M tokens.
- Maximum output: 128K tokens.
- Minimum cacheable prefix: 512 tokens.
- Adaptive thinking: always enabled.
- Prefill: unsupported.
- Non-default sampling parameters: rejected with HTTP 400.

Quote: “1M token context window” and “128K maximum output.”  
Source: [Fable 5.1 overview](https://platform.claude.com/docs/en/models/fable-5-1/overview)

**What the operating guide should say now:** Remove any Fable 5-era limits below 1M input or 128K output, but keep explicit streaming and cost controls.

## 3.3 Streaming threshold

**[OFFICIAL | DIRECT | accessed 2026-09-02]**

Anthropic SDKs require streaming when `max_tokens` exceeds 21,333. This protects long-running connections and is not the model’s maximum-output limit. The API streams Server-Sent Events.

Quote: “Streaming is required when `max_tokens` is greater than 21,333.”  
Sources: [Extended thinking](https://platform.claude.com/docs/en/build-with-claude/thinking), [Streaming Messages](https://platform.claude.com/docs/en/build-with-claude/streaming)

Anthropic separately recommends the Message Batches API when thinking may exceed roughly 32K tokens.

**What the operating guide should say now:** Default to streaming for serious Fable work. Never request 128K output through a synchronous SDK convenience method.

## 3.4 Thinking compatibility and append-only history

**[OFFICIAL | DIRECT | 2026-09-01]**

Fable 5.1 accepts older thinking blocks. The reverse is not true. An older fallback model cannot consume Fable 5.1 thinking, so the API removes incompatible blocks unless transformation diagnostics are requested.

Changes that invalidate earlier thinking or the associated cache include:

- editing, deleting, or reordering earlier user or assistant turns;
- injecting or removing ephemeral reminder messages inside the earlier prefix;
- changing the leading system prompt;
- changing tool definitions;
- changing bytes returned from URL content.

Changes documented as safe include:

- appending new messages;
- deleting the oldest complete thinking run;
- moving cache-control markers;
- changing outer request parameters such as `max_tokens`;
- server-side context editing or compaction.

Conversation-binding enforcement applies to new accounts created on or after 2026-08-31. Mythos 5.1 does not enforce the binding check, although edited history can still miss the cache.

**What the operating guide should say now:** Persist messages and thinking blocks exactly as returned. Put changing reminders at the end of the conversation or use the turn-scoped system mechanism.

## 3.5 Per-message effort

**[OFFICIAL | DIRECT | 2026-09-01]**

Beta header:

```text
mid-conversation-output-config-2026-07-01
```

A role `system` message can set an `output_config` that applies from the following user turn onward. The migration guide says this preserves cache reuse across effort changes.

**What the operating guide should say now:** On the API, prefer per-message effort changes over changing the top-level request-level effort after a cached conversation has begun.

## 3.6 Turn-scoped system instructions

**[OFFICIAL | DIRECT | 2026-09-01]**

Beta header:

```text
mid-conversation-system-clear-at-2026-08-21
```

The instruction can use:

```json
{"clear_at": "next_user_message"}
```

Anthropic warns that revising an earlier system message invalidates thinking. New turn-scoped instructions should be appended, and earlier copies should remain byte-identical.

**What the operating guide should say now:** Use expiring system messages for one-turn steering. Never rewrite an earlier system message to simulate expiry.

## 3.7 Thinking display updates

**[OFFICIAL | DIRECT | 2026-09-01]**

Beta header:

```text
thinking-display-updates-2026-08-18
```

Without the beta, thinking blocks can be present but have empty display text. Anthropic also says Fable 5.1 naturally emits fewer progress updates than Fable 5.

**[OFFICIAL | ASSERTION | 2026-09-01]**

**What the operating guide should say now:** Enable display updates when visible progress is required, and separately instruct the model when progress reports should be emitted.

## 3.8 Forced tool use

**[OFFICIAL | DIRECT | 2026-09-01]**

The documented error is:

```text
tool_choice: type "tool" and "any" are not supported for this model.
```

`auto` and `none` are unchanged. Strict tools or structured outputs are the supported ways to guarantee schema-valid output.

**What the operating guide should say now:** Delete any Fable 5 examples that rely on named or forced `tool_choice`.

## 3.9 Task budgets

**[OFFICIAL | DIRECT | accessed 2026-09-02]**

Task budgets are a Fable 5.1 API beta enabled with:

```text
task-budgets-2026-03-13
```

Properties:

- API only; not supported by Claude Code or Cowork.
- Soft planning signal, unlike the hard `max_tokens` output limit.
- Minimum total budget: 20K tokens.
- Changing the budget mid-conversation invalidates the cache.
- The budget should be set once, not decremented and resent by the client.
- For `xhigh` or `max`, Anthropic recommends at least 64K `max_tokens`.
- No remaining-budget response field is exposed.

Quote: “Task budgets are not supported in Claude Code.”  
Source: [Task budgets](https://platform.claude.com/docs/en/build-with-claude/task-budgets)

**What the operating guide should say now:** Include task budgets only in the API chapter. For Claude Code, use `/goal`, agent `maxTurns`, workflow structure, and user-side cost limits instead.

---

# 4. Cache behavior and pricing

## 4.1 Fable 5.1 rates

**[OFFICIAL | DIRECT | 2026-09-01]**

| Token category | Price per million tokens |
|---|---:|
| Input | $10.00 |
| Output | $50.00 |
| 5-minute cache write | $12.50 |
| 1-hour cache write | $20.00 |
| Cache read | $0.25 |
| Batch | 50 percent of normal input/output rates |

Source: [Fable 5.1 overview](https://platform.claude.com/docs/en/models/fable-5-1/overview)

The request’s “cache read /bin/zsh.25” appears to be a shell-expansion or transcription error. The documented value is **$0.25 per million cache-read tokens**.

**What the operating guide should say now:** Treat long stable prefixes as extremely valuable. At Fable prices, repeated cache hits are much cheaper than even ordinary input.

## 4.2 Claude Code TTL defaults

**[OFFICIAL | DIRECT | accessed 2026-09-02]**

| Traffic | Default TTL |
|---|---:|
| Claude subscription, in-plan main conversation | 1 hour |
| API key or usage-credit main conversation | 5 minutes |
| Bedrock, Vertex, Foundry main conversation | 5 minutes |
| Subagents | 5 minutes |
| Workflows | 5 minutes |
| Forks and compaction | 5 minutes unless otherwise configured |

Claude Code 2.1.242 or newer is required for the current TTL settings.

Relevant configuration keys include:

- `promptCacheTtl`
- `subagentPromptCacheTtl`
- equivalent environment-variable controls
- per-agent experimental `cacheTtl` frontmatter from 2.1.248

Source: [Claude Code prompt caching](https://code.claude.com/docs/en/prompt-caching)

**What the operating guide should say now:** Do not say “Claude Code uses one-hour caching” without qualification. One hour is an in-plan subscription-main-agent default, not a universal default.

## 4.3 Cache invalidators specific to the harness

**[OFFICIAL | DIRECT | accessed 2026-09-02]**

Claude Code identifies model and effort as cache-key dimensions. Fast mode also changes request metadata and causes an initial miss. Model switches, mutable prompt prefixes, and changing tool or MCP definitions can likewise require recomputation.

**What the operating guide should say now:** Perform model, effort, tool, MCP, and system-prompt selection before loading large repository context.

---

# 5. Tool batching and behavioral prompt changes

These are Anthropic’s Fable 5.1 behavior claims, not independent benchmark results.

## 5.1 Parallel tool calls

**[OFFICIAL | ASSERTION | 2026-09-01]**

Anthropic says Fable 5.1 may issue one tool call per turn inside implicitly long loops, increasing round trips and wall time without necessarily lowering result quality. When several fetches are named explicitly, parallelism is more reliable.

Recommended official nudge:

> “First privately list what you need next; then request every item that doesn't depend on another's result in this one response.”

Source: [Prompting Fable 5.1](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1)

**What the operating guide should say now:** Add a short dependency-aware batching instruction to research, browsing, repository search, and multi-file inspection prompts.

## 5.2 Low-effort retrieval

**[OFFICIAL | ASSERTION | 2026-09-01]**

Anthropic says low effort may stop retrieval earlier and needs a more explicit search-depth instruction.

**What the operating guide should say now:** Do not use `low` for exhaustive research unless the prompt specifies breadth, source count, recency, and stopping criteria.

## 5.3 File-editing behavior

**[OFFICIAL | ASSERTION | 2026-09-01]**

Fable 5.1 is described as more likely to rewrite a whole file when a localized edit would suffice.

**What the operating guide should say now:** In editing prompts, say to make the smallest coherent patch, preserve unrelated lines, and inspect the diff before reporting success.

## 5.4 Citation and quotation behavior

**[OFFICIAL | ASSERTION | 2026-09-01]**

Anthropic says Fable 5.1 may reproduce source passages without clearly marking them as quotations.

**What the operating guide should say now:** Require quotation marks, source attribution, and a separation between verbatim evidence and paraphrase.

## 5.5 Completion persistence

The current Fable 5.1 guide retains the instruction:

> “Do not stop because the context or session is long.”

**[OFFICIAL | DIRECT | 2026-09-01]**  
Source: [Prompting Fable 5.1](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1)

**What the operating guide should say now:** Keep an explicit finish-the-task instruction for long Claude Code and API runs.

---

# 6. `/goal` and evaluator behavior

**[OFFICIAL | DIRECT | accessed 2026-09-02]**

The current goal evaluator has three possible conclusions:

- goal not yet met;
- goal met;
- goal impossible.

The evaluator normally uses a small, fast model, documented as Haiku by default. It receives the transcript but no tools. Background work defers evaluation. Unrecoverable authorization, credit, context-overflow, or model-unavailable conditions clear the goal.

The idle schedule is approximately:

1. 30 minutes;
2. one hour;
3. two hours;
4. no additional idle check until user interaction.

Source: [Claude Code goals](https://code.claude.com/docs/en/goal)

**Fable-specific evaluator model change:** **NOT FOUND.**

**New Fable-specific evaluator rubric:** **NOT FOUND.**

**What the operating guide should say now:** A Fable-led goal can be evaluated by another model. Persist tool-backed verification in the transcript so the evaluator can see it.

---

# 7. Subagents and workflows

## 7.1 Main prompt inheritance

**[OFFICIAL | DIRECT | accessed 2026-09-02]**

Claude Code documentation says subagents receive their custom system prompt plus environment context, rather than simply inheriting the main agent’s full prompt.

Source: [Claude Code subagents](https://code.claude.com/docs/en/sub-agents)

This matters because a Fable-specific main-agent instruction does not automatically become part of a custom subagent’s prompt unless Claude Code injects it separately or the agent definition repeats it.

**What the operating guide should say now:** Put critical batching, verification, persistence, and output-format rules into each custom subagent definition.

## 7.2 Subagent model forcing

**[OFFICIAL | DIRECT | 2026-09-01]**

From 2.1.257:

```text
CLAUDE_CODE_SUBAGENT_MODEL_FORCE=1
```

forces subagents, teammates, and workflow agents onto the model named by `CLAUDE_CODE_SUBAGENT_MODEL`. Without the force flag, the model variable acts as a default and can be overridden by per-agent configuration or spawn choices.

**What the operating guide should say now:** Use ordinary defaulting for heterogeneous teams. Use forced Fable routing only when consistency outweighs specialist model selection.

## 7.3 Fable-specific subagent documentation

A literal Fable 5.1 section was not found in the current subagent documentation.

**Fable 5.1-specific subagent policy:** **NOT FOUND.**

The applicable changes come from general model selection, effort, cache, fallback, and 2.1.257 model-forcing mechanics.

---

# 8. Agent SDK changes

## 8.1 Python Agent SDK

**[OFFICIAL | DIRECT | accessed 2026-09-02]**

Launch-window versions found:

| Python SDK | Bundled Claude Code |
|---|---|
| 0.2.145 | 2.1.247 |
| 0.2.146 | 2.1.248 |
| 0.2.147 | 2.1.250 |
| 0.2.148 | 2.1.251 |
| 0.2.149 | 2.1.252 |
| 0.2.150 | 2.1.257 |
| 0.2.151 | 2.1.258 |

Sources: [Python Agent SDK changelog](https://raw.githubusercontent.com/anthropics/claude-agent-sdk-python/main/CHANGELOG.md), [PyPI release history](https://pypi.org/project/claude-agent-sdk/#history)

No explicit “Fable 5.1” SDK changelog item was found. Python support appears to arrive transitively with the bundled Claude Code 2.1.257 in SDK 0.2.150.

**What the operating guide should say now:** Require Python Agent SDK 0.2.150 or newer for the first bundled Fable 5.1-aware CLI, and prefer 0.2.151.

## 8.2 TypeScript Agent SDK

**[OFFICIAL | DIRECT | accessed 2026-09-02]**

The current TypeScript line reached 0.3.258 and tracks Claude Code 2.1.258 parity. The preceding 0.3.257 release includes 2.1.257 parity and adds `thinkingTokens` accounting.

Sources: [TypeScript Agent SDK changelog](https://raw.githubusercontent.com/anthropics/claude-agent-sdk-typescript/main/CHANGELOG.md), [npm package](https://www.npmjs.com/package/@anthropic-ai/claude-agent-sdk)

No new Fable 5.1-specific model type or literal changelog entry was found.

**What the operating guide should say now:** Require TypeScript Agent SDK 0.3.257 or later, preferably 0.3.258, and pass the explicit model string where reproducibility matters.

## 8.3 The `claude_code` preset

**[OFFICIAL | DIRECT | changelog history, accessed 2026-09-02]**

The Agent SDK does not implicitly grant the complete Claude Code harness merely because the underlying model is Fable 5.1. The Claude Code system-prompt preset remains opt-in, for example through the documented preset object. Tool presets are separately configurable.

**Launch-window change to the `claude_code` preset itself:** **NOT FOUND.**

**What the operating guide should say now:** Explicitly enable the Claude Code system-prompt and tool presets when API-based agents are intended to behave like Claude Code. Updating the model ID alone is not equivalent.

---

# 9. Claude Code system-prompt extraction

## 9.1 Provenance and latest available extraction

The newest Piebald-AI extraction found is **Claude Code 2.1.257**, dated 2026-09-01. The repository describes its content as extracted from the compiled Claude Code distribution. It is one public release behind Claude Code 2.1.258.

**[UNOFFICIAL | DIRECT EXTRACTION | 2026-09-01]**

Quote: “current as of Claude Code v2.1.257.”  
Source: [Piebald-AI prompt repository README](https://github.com/Piebald-AI/claude-code-system-prompts)

This is useful direct extraction evidence, but it is not an Anthropic-published system-prompt specification.

## 9.2 Fable-specific sections in the newest extraction

The clearest explicitly model-specific item is the Fable 5.1 identity section. A second compiled-binary extraction identifies a Fable 5.1 prompt bundle containing or activating guidance for:

- Fable 5.1 model identity;
- writing and communication style;
- delivering the complete requested work;
- turn and progress updates;
- parallel tool batching;
- Bash output audience and readability;
- silent-turn reminders;
- Bash-first behavior;
- thinking-display updates.

**[UNOFFICIAL | DIRECT EXTRACTION | 2026-09-01]**  
Sources: [Piebald-AI changelog](https://github.com/Piebald-AI/claude-code-system-prompts/blob/main/CHANGELOG.md), [compiled-bundle extraction](https://gist.github.com/safzanpirani/6c6c9d811dc27f16d7b0f59816596a88)

The extraction also reports that Fable 5.1 receives a distinct bundle capability not assigned identically to Fable 5.

**What the operating guide should say now:** Treat Claude Code’s model-specific bundle as helpful baseline steering, but repeat mission-critical rules in user, project, and subagent prompts.

## 9.3 Changes since Claude Code 2.1.201

Piebald’s changelog says 2.1.201 itself had no system-prompt change.

### New after 2.1.201: Fable 5.1 identity

**[UNOFFICIAL | DIRECT EXTRACTION | 2026-09-01]**

Version 2.1.257 adds Fable 5.1 identity and adjusts platform availability language. It also removes an outdated “most intelligent” characterization from the older Fable 5 identity.

**Guide consequence:** Update all identity-sensitive examples and model detection logic to recognize 5.1.

### New after 2.1.201: reporting outcomes

**[UNOFFICIAL | DIRECT EXTRACTION | 2026-08-28]**

Version 2.1.251 adds an outcome-reporting instruction. A representative line is:

> “Claims about results, completion, or verification must rest on observed results.”

Source: [Piebald-AI reporting-outcomes prompt](https://raw.githubusercontent.com/Piebald-AI/claude-code-system-prompts/main/system-prompts/system-prompt-reporting-outcomes.md)

**Guide consequence:** Keep tool-backed verification requirements, but know Claude Code now supplies a general outcome-verification reminder itself.

### New after 2.1.201: memory updates and session context

**[UNOFFICIAL | DIRECT EXTRACTION | 2026-08-28]**

The 2.1.251 extraction records new or revised memory-update and session-context prompt material.

**Guide consequence:** Avoid duplicating generic memory-maintenance prose. Reserve project instructions for what should be remembered and where it belongs.

### Existing before 2.1.201: autonomous persistence

The autonomous-operation prompt was introduced before the comparison baseline, around 2.1.169. Therefore it is not a Fable 5.1 launch addition.

**[UNOFFICIAL | DIRECT EXTRACTION | date predates 2026-08-25]**

**Guide consequence:** Do not attribute Claude Code’s general keep-working behavior to Fable 5.1.

### Existing before 2.1.201: communication and progress style

General communication-style and progress-update instructions also predate 2.1.201.

**Guide consequence:** The launch-period change is primarily Fable 5.1’s lower natural progress frequency and the thinking-display beta, not the existence of progress guidance.

### Existing before 2.1.201: parallel tool calls

A general parallel-tool-call instruction existed before 2.1.201. The new issue is that Fable 5.1 may need stronger, dependency-explicit wording for implicit loops.

**Guide consequence:** Strengthen the instruction rather than claiming tool batching was newly invented in 2.1.257.

## 9.4 Old Fable 5 prompt patterns versus the 5.1 guide

### “Audit claims” line

The older Fable 5 page included:

> “Before reporting progress, audit each claim against a tool result from this session.”

**[OFFICIAL | DIRECT | older comparison source]**  
Source: [Prompting Fable 5](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5)

That exact sentence was not found in the new public Fable 5.1 prompting page. Claude Code’s new reporting-outcomes prompt supplies a closely related rule.

**What the operating guide should say now:** Retain the audit rule for high-integrity work, even though the public 5.1 guide phrases verification differently.

### “Context anxiety” line

The older guide said:

> “You have ample context remaining.”

The exact phrase was not found on the current Fable 5.1 page. The new page retains the same operational intent through “Do not stop because the context or session is long.”

**What the operating guide should say now:** Replace model-reassurance language with a direct instruction to finish the task and use available context.

### Self-verification cadence

The older Fable 5 page proposed:

> “Establish a method for checking your own work at an interval of [X].”

The exact cadence template was not found in the new Fable 5.1 page or as a dedicated newest Piebald prompt section.

**Removal from Claude Code itself:** **NOT FOUND.**

The 5.1 guide also says existing Fable 5 prompts should generally continue to work.

**What the operating guide should say now:** Keep explicit verification cadence when the workflow benefits from checkpoints. Do not claim Anthropic has deprecated it.

### Tool batching

The older generic batching guidance remains useful, but the new 5.1 guide adds a more explicit dependency-aware formulation because parallel tool use can be less reliable in implicit loops.

**What the operating guide should say now:** Upgrade generic “parallelize tools” wording to the official “list needs, then request every independent item” formulation.

---

# 10. Claude API release notes during the window

All platform release-note entries found between 2026-08-25 and 2026-09-02:

## 2026-09-01

**[OFFICIAL | DIRECT | 2026-09-01]**

Fable 5.1 launch, including:

- new model and provider IDs;
- 1M context and 128K output;
- all five effort levels;
- per-message output configuration;
- turn-scoped system instructions;
- thinking display updates;
- server-side fallback;
- task budgets;
- new forced-tool restrictions;
- new thinking compatibility and binding rules;
- cache and pricing details.

Source: [Claude API release notes](https://platform.claude.com/docs/en/release-notes/overview)

## 2026-08-27

**[OFFICIAL | DIRECT | 2026-08-27]**

- Stable client SDK support for files and skills moved out of earlier beta namespaces.
- Personal and service-account key management changes.

**What the operating guide should say now:** Refresh imports and beta headers in any harness that combines Fable with Files or Skills APIs.

## 2026-08-26

**[OFFICIAL | DIRECT | 2026-08-26]**

- Compliance API session endpoints became generally available.
- Additional local-transcript surfaces entered beta.
- Admin API support expanded into the Anthropic CLI and SDKs.

**What the operating guide should say now:** Compliance or administrative tooling can track sessions without relying solely on local Claude Code transcript files.

## Dates with no platform entry found

- 2026-08-25: **NOT FOUND**
- 2026-08-28: **NOT FOUND**
- 2026-08-29: **NOT FOUND**
- 2026-08-30: **NOT FOUND**
- 2026-08-31: **NOT FOUND**
- 2026-09-02 by research cutoff: **NOT FOUND**

---

# 11. Recommended replacement text for `fable-max`

A concise current operating block would read:

```markdown
Use Claude Code 2.1.258 or later and select `claude-fable-5-1`
explicitly when routing through a gateway.

Default to `high` effort. Use `xhigh` or `max` only with sufficient
latency and output budget. Keep `/effort` stable during a Claude Code
session because effort changes invalidate the prompt cache.

Treat message history as append-only. Preserve thinking blocks exactly.
Append transient instructions instead of editing earlier messages.

Before using tools, privately identify everything needed next and request
every item that does not depend on another result in the same response.

Use `tool_choice: auto`; Fable 5.1 does not support forced `any` or named
tool choices. Use strict tools or structured outputs for schema guarantees.

Stream requests above 21,333 `max_tokens`. The model supports 128K output,
but the SDK streaming rule still applies.

Task budgets are API-only. `/goal` is the Claude Code persistence mechanism,
but its idle evaluator checks are capped at three between user messages.

Fast mode is not available on Fable 5.1. Server-side safety fallback and
Claude Code availability fallback are separate mechanisms.

For custom subagents, repeat critical batching, persistence, and verification
instructions. Use `CLAUDE_CODE_SUBAGENT_MODEL_FORCE=1` only when every agent
must run on the configured subagent model.
```

---

# 12. Explicit NOT FOUND findings

- A public Claude Code 2.1.255 release entry: **NOT FOUND**.
- Fable 5.1 support for Claude fast mode: **NOT FOUND; official docs restrict fast mode to Opus 5 and Opus 4.8.**
- A Fable-specific `/goal` evaluator or Fable-specific evaluator rubric: **NOT FOUND**.
- Task budgets inside Claude Code: **NOT FOUND; officially unsupported.**
- A launch-window change to the Agent SDK `claude_code` preset: **NOT FOUND**.
- A literal Fable 5.1 entry in the Python Agent SDK changelog: **NOT FOUND**.
- A literal Fable 5.1 entry in the TypeScript Agent SDK changelog: **NOT FOUND**.
- A legacy Bedrock InvokeModel identifier ending in `:0`: **NOT FOUND** on the Fable 5.1 provider page.
- Proof that the old self-verification cadence was removed from Claude Code: **NOT FOUND**.
- A Claude Code 2.1.258 system-prompt extraction from Piebald at the cutoff: **NOT FOUND; newest extraction is 2.1.257.**
- Independent reproduction of Anthropic’s behavioral claims about parallelism, retrieval depth, progress frequency, or whole-file rewrites: **NOT PERFORMED**.

# Full source list

## Official Anthropic documentation

- [Claude Fable 5.1 overview](https://platform.claude.com/docs/en/models/fable-5-1/overview), published 2026-09-01.
- [What is new in Claude Fable 5.1](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1), published 2026-09-01.
- [Claude Fable 5.1 migration guide](https://platform.claude.com/docs/en/models/fable-5-1/migration-guide), published 2026-09-01.
- [Prompting Claude Fable 5.1](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02.
- [Prompting Claude Fable 5](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5), older comparison source, accessed 2026-09-02.
- [Claude API release notes](https://platform.claude.com/docs/en/release-notes/overview), accessed 2026-09-02.
- [Prompt caching pricing](https://platform.claude.com/docs/en/about-claude/pricing), accessed 2026-09-02.
- [Extended thinking](https://platform.claude.com/docs/en/build-with-claude/thinking), accessed 2026-09-02.
- [Streaming Messages](https://platform.claude.com/docs/en/build-with-claude/streaming), accessed 2026-09-02.
- [Task budgets](https://platform.claude.com/docs/en/build-with-claude/task-budgets), accessed 2026-09-02.
- [Choosing a Claude model](https://platform.claude.com/docs/en/about-claude/models/choosing-a-model), accessed 2026-09-02.
- [Claude Code with Amazon Bedrock](https://platform.claude.com/docs/en/build-with-claude/claude-in-amazon-bedrock), accessed 2026-09-02.
- [Claude Fable 5.1 claude.ai system prompt release note](https://platform.claude.com/docs/en/release-notes/system-prompts/claude-fable-5-1), published 2026-09-01. This is a Claude app prompt, not the Claude Code prompt.

## Official Claude Code documentation and releases

- [Claude Code model configuration](https://code.claude.com/docs/en/model-config), accessed 2026-09-02.
- [Claude Code prompt caching](https://code.claude.com/docs/en/prompt-caching), accessed 2026-09-02.
- [Claude Code goals](https://code.claude.com/docs/en/goal), accessed 2026-09-02.
- [Claude Code subagents](https://code.claude.com/docs/en/sub-agents), accessed 2026-09-02.
- [Claude Code release feed](https://raw.githubusercontent.com/anthropics/claude-code/main/feed.xml), accessed 2026-09-02.
- [Claude Code v2.1.243](https://github.com/anthropics/claude-code/releases/tag/v2.1.243), 2026-08-25.
- [Claude Code v2.1.245](https://github.com/anthropics/claude-code/releases/tag/v2.1.245), 2026-08-25.
- [Claude Code v2.1.246](https://github.com/anthropics/claude-code/releases/tag/v2.1.246), 2026-08-25.
- [Claude Code v2.1.247](https://github.com/anthropics/claude-code/releases/tag/v2.1.247), 2026-08-26.
- [Claude Code v2.1.248](https://github.com/anthropics/claude-code/releases/tag/v2.1.248), 2026-08-27.
- [Claude Code v2.1.250](https://github.com/anthropics/claude-code/releases/tag/v2.1.250), 2026-08-28.
- [Claude Code v2.1.251](https://github.com/anthropics/claude-code/releases/tag/v2.1.251), 2026-08-28.
- [Claude Code v2.1.252](https://github.com/anthropics/claude-code/releases/tag/v2.1.252), 2026-08-31.
- [Claude Code v2.1.257](https://github.com/anthropics/claude-code/releases/tag/v2.1.257), 2026-09-01.
- [Claude Code v2.1.258](https://github.com/anthropics/claude-code/releases/tag/v2.1.258), 2026-09-01.

## Official Agent SDK sources

- [Python Claude Agent SDK changelog](https://raw.githubusercontent.com/anthropics/claude-agent-sdk-python/main/CHANGELOG.md), accessed 2026-09-02.
- [Python Claude Agent SDK release history](https://pypi.org/project/claude-agent-sdk/#history), accessed 2026-09-02.
- [TypeScript Claude Agent SDK changelog](https://raw.githubusercontent.com/anthropics/claude-agent-sdk-typescript/main/CHANGELOG.md), accessed 2026-09-02.
- [TypeScript Claude Agent SDK on npm](https://www.npmjs.com/package/@anthropic-ai/claude-agent-sdk), accessed 2026-09-02.

## Unofficial extraction sources

- [Piebald-AI Claude Code system prompts](https://github.com/Piebald-AI/claude-code-system-prompts), newest extracted version 2.1.257, accessed 2026-09-02.
- [Piebald-AI extraction changelog](https://github.com/Piebald-AI/claude-code-system-prompts/blob/main/CHANGELOG.md), accessed 2026-09-02.
- [Piebald-AI reporting-outcomes prompt](https://raw.githubusercontent.com/Piebald-AI/claude-code-system-prompts/main/system-prompts/system-prompt-reporting-outcomes.md), accessed 2026-09-02.
- [Claude Code 2.1.257 compiled-bundle extraction](https://gist.github.com/safzanpirani/6c6c9d811dc27f16d7b0f59816596a88), accessed 2026-09-02.