# Lane A report: Claude Fable 5.1 official guidance

**Research cutoff:** 2026-09-02  
**Scope:** Anthropic-controlled sources only, including Claude Platform docs, Claude Code docs and releases, Anthropic’s announcement, and the official system-card index.  
**Evidence labels:** `DEMONSTRATED` means a published specification, API contract, changelog implementation, or reported test with described results. It was not independently reproduced unless explicitly stated. `ASSERTION` means Anthropic’s qualitative recommendation, forecast, or performance characterization. No community claims are used.

## TLDR: 10 decisions for `fable-max`

1. **Replace Fable 5 with `claude-fable-5-1`, but do not make Fable the default for every workload.** Anthropic’s routing advice is to start most workloads on Opus 5, then choose Fable 5.1 for demanding reasoning, long-horizon work, or workloads where Opus 5 at `xhigh` or `max` fails your evals. `[OFFICIAL][ASSERTION]` ([model overview](https://platform.claude.com/docs/en/models/fable-5-1/overview), accessed 2026-09-02; [model-selection guide](https://platform.claude.com/docs/en/about-claude/models/choosing-a-model), accessed 2026-09-02)

2. **Delete any “always high, never xhigh” rule.** Start at `high`, but explicitly test `low`, `medium`, `xhigh`, and `max` again for 5.1. Anthropic says effort names are calibrated per model, `medium` roughly matches Fable 5 at lower cost, and 5.1’s largest gains appear at higher settings. Use `xhigh` or `max` only when your evals show a quality gain. `[OFFICIAL][ASSERTION]` ([Fable 5.1 prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02; [effort guide](https://platform.claude.com/docs/en/build-with-claude/effort), accessed 2026-09-02)

3. **Forced tool choice is a breaking change.** `tool_choice: any` and named `tool` return HTTP 400. Use `auto`, make the prompt explicitly require the tool, and use `strict: true` or structured outputs for schema compliance. `[OFFICIAL][DEMONSTRATED]` ([what’s new](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1), accessed 2026-09-02)

4. **Treat conversation history as append-only.** Return assistant messages exactly as received, including thinking blocks. Changing earlier messages, the original `system` field, or tool definitions can invalidate every later Fable 5.1 thinking block and produce HTTP 400. `[OFFICIAL][DEMONSTRATED]` ([migration guide](https://platform.claude.com/docs/en/models/fable-5-1/migration-guide), accessed 2026-09-02; [prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

5. **Add a parallel-tool nudge to coding-agent loops.** Fable 5.1 can issue one implied independent tool call per turn where Fable 5 batched several. Anthropic’s exact recommended instruction is:  
   > “First privately list what you need next; then request every item that doesn't depend on another's result in this one response.”  
   `[OFFICIAL][DEMONSTRATED]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

6. **Expect less visible narration.** Tool-loop progress arrives in `thinking` blocks, which are empty under the default `thinking.display: "omitted"`. For an API UI, enable `display: "updates"` with beta header `thinking-display-updates-2026-08-18`, render non-empty thinking blocks, and remove prompt language such as “hold all findings for the final response.” `[OFFICIAL][DEMONSTRATED]` ([what’s new](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1), accessed 2026-09-02; [prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

7. **Keep an autonomy and completion instruction.** Fable 5.1 sometimes states its next step or asks permission instead of completing already-authorized work. Anthropic recommends an explicit autonomous-operation block plus a scope block. The opening sentence it says carries most of the effect is:  
   > “You are operating autonomously. The user is not watching in real time and cannot answer questions mid-task, so asking 'Want me to…?' or 'Shall I…?' will block the work.”  
   `[OFFICIAL][ASSERTION]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

8. **The retention restriction remains.** Fable 5.1 and Mythos 5.1 are Covered Models requiring 30-day retention and are generally excluded from ZDR unless Anthropic expressly authorizes an exception. The launch announcement describes a temporary ZDR path for customers eligible for the forthcoming Enterprise Frontier Safeguards, but that is not blanket ZDR availability. `[OFFICIAL][DEMONSTRATED]` ([retention policy](https://platform.claude.com/docs/en/manage-claude/api-and-data-retention), accessed 2026-09-02; [announcement](https://www.anthropic.com/claude-fable-and-mythos-5-1), 2026-09-01)

9. **“Show your reasoning” remains risky if it requests internal chain of thought.** `reasoning_extraction` is an official refusal category for requests asking the model to reproduce internal reasoning. Use adaptive thinking and `thinking.display: "summarized"` for structured reasoning summaries, or ask for conclusions, evidence, and a concise rationale rather than hidden chain of thought. `[OFFICIAL][DEMONSTRATED]` ([refusals and fallback](https://platform.claude.com/docs/en/build-with-claude/refusals-and-fallback), accessed 2026-09-02)

10. **Cache economics materially change long-session strategy.** Input and output remain $10 and $50 per million tokens, but cache reads fall from $1 to $0.25 per million. Anthropic estimates 25% lower cost for typical workloads and as much as 45% for highly agentic workloads, based on four weeks of August 2026 usage. Delay aggressive compaction until your own measurements justify it. `[OFFICIAL][DEMONSTRATED BY ANTHROPIC]` ([pricing](https://platform.claude.com/docs/en/about-claude/pricing), accessed 2026-09-02; [announcement](https://www.anthropic.com/claude-fable-and-mythos-5-1), 2026-09-01; [prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

---

## 1. Model identity, availability, and routing

### Exact identifiers

| Platform | Fable 5.1 | Mythos 5.1 | Evidence |
|---|---|---|---|
| Claude API | `claude-fable-5-1` | `claude-mythos-5-1` | `[OFFICIAL][DEMONSTRATED]` |
| Amazon Bedrock | `anthropic.claude-fable-5-1` | `anthropic.claude-mythos-5-1` | `[OFFICIAL][DEMONSTRATED]` |
| Google Cloud | `claude-fable-5-1` | `claude-mythos-5-1` | `[OFFICIAL][DEMONSTRATED]` |
| Microsoft Foundry | `claude-fable-5-1` | `claude-mythos-5-1` | `[OFFICIAL][DEMONSTRATED]` |
| Claude Platform on AWS | `claude-fable-5-1` | Exact Mythos entry **NOT FOUND** on its model page | `[OFFICIAL][DEMONSTRATED]` |

Sources: [Fable 5.1 overview](https://platform.claude.com/docs/en/models/fable-5-1/overview), accessed 2026-09-02; [Mythos 5.1 overview](https://platform.claude.com/docs/en/models/mythos-5-1/overview), accessed 2026-09-02.

These dateless IDs are fixed snapshots, not evergreen aliases. Anthropic says it does not change the weights or configuration behind an existing 4.6-generation-or-later ID. Serving infrastructure, including routers, classifiers, and sampling logic, can still change. `[OFFICIAL][DEMONSTRATED]` ([model IDs and versioning](https://platform.claude.com/docs/en/about-claude/models/model-ids-and-versions), accessed 2026-09-02)

### Specifications

Fable 5.1 and Mythos 5.1 have a 1 million token default and maximum context window, 128,000 maximum output tokens, always-on adaptive thinking, default API effort `high`, June 2026 reliable-knowledge and training-data cutoffs, and “slower” comparative latency. Fable is active and generally available; Mythos is invitation-only. Retirement is promised no sooner than 2027-09-01. `[OFFICIAL][DEMONSTRATED]` ([Fable overview](https://platform.claude.com/docs/en/models/fable-5-1/overview), accessed 2026-09-02; [Mythos overview](https://platform.claude.com/docs/en/models/mythos-5-1/overview), accessed 2026-09-02)

Fable 5.1 and Mythos 5.1 use the Fable 5 tokenizer introduced with Opus 4.7. Anthropic says identical text is roughly 30% more tokens than on models older than Opus 4.7. `[OFFICIAL][DEMONSTRATED]` ([what’s new](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1), accessed 2026-09-02; [token counting](https://platform.claude.com/docs/en/build-with-claude/token-counting), accessed 2026-09-02)

### Routing policy for `fable-max`

Use this order:

1. Start routine production work on Opus 5.
2. Optimize the prompt and test Opus 5 at higher effort.
3. Route to Fable 5.1 when accuracy matters more than price, the job is long-horizon, or Opus 5 at `xhigh` or `max` fails workload-specific evals.
4. Consider Sonnet 5 or Haiku 4.5 for speed, high volume, or subordinate work that is not intelligence-sensitive. `[OFFICIAL][ASSERTION]` ([choosing a model](https://platform.claude.com/docs/en/about-claude/models/choosing-a-model), accessed 2026-09-02)

This means `fable-max` should be an escalation profile, not a universal “best model everywhere” profile.

---

## 2. Complete API migration delta

### Breaking or invalid request patterns

| Existing behavior | Fable 5.1 behavior | Required change |
|---|---|---|
| `tool_choice: {"type":"any"}` | HTTP 400 | Use `auto`; explicitly instruct the model to call the tool |
| Named forced tool choice | HTTP 400 | Use `auto` plus `strict: true`, or structured outputs |
| `thinking: {"type":"disabled"}` | HTTP 400 at every effort | Remove it; control spend using `effort` |
| Manual `thinking: {"type":"enabled","budget_tokens":N}` | HTTP 400 | Omit `thinking` or send adaptive mode |
| Assistant prefill | HTTP 400 | Replace with system instructions or structured outputs |
| Non-default `temperature`, `top_p`, or `top_k` | HTTP 400 | Remove custom sampling settings |
| Sending Fable 5.1 thinking blocks to an older model | Blocks are dropped | Preserve the model boundary and inspect `input_transformations` if needed |
| Editing the prefix before a retained thinking block | HTTP 400 or block drop | Maintain append-only history |

`[OFFICIAL][DEMONSTRATED]` ([what’s new](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1), accessed 2026-09-02; [migration guide](https://platform.claude.com/docs/en/models/fable-5-1/migration-guide), accessed 2026-09-02)

The exact forced-tool error is:

```text
tool_choice: type "tool" and "any" are not supported for this model.
```

`[OFFICIAL][DEMONSTRATED]` ([what’s new](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1), accessed 2026-09-02)

### Thinking-block compatibility

Fable 5.1 can read preserved thinking from Opus 5, Fable 5, Mythos 5, and earlier models. The reverse is not supported. If a router moves a conversation from Fable 5.1 to an older model, the API removes unsupported thinking blocks; the removed tokens are neither counted nor billed. `[OFFICIAL][DEMONSTRATED]` ([what’s new](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1), accessed 2026-09-02)

Use `thinking-binding-controls-2026-08-01` during migration. With:

```json
{
  "thinking": {
    "block_binding": {
      "prefix_mismatch_behavior": "drop_block"
    }
  }
}
```

the API continues rather than failing and records `prefix_binding_mismatch` in `input_transformations`. The production choice is either strict `"error"` behavior or monitored `"drop_block"` behavior. `[OFFICIAL][DEMONSTRATED]` ([migration guide](https://platform.claude.com/docs/en/models/fable-5-1/migration-guide), accessed 2026-09-02)

Enforcement applies by default to accounts created on or after 2026-08-31. Older accounts can currently receive mismatch telemetry without enforcement, but Anthropic says future models are expected to enforce it universally. `[OFFICIAL][DEMONSTRATED, WITH FUTURE ASSERTION]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

Safe history rules:

- Append each assistant turn exactly as returned, including thinking blocks.
- Do not rewrite or remove prior user, assistant, or system messages.
- Do not rebuild the original `system` or `tools` arrays between turns.
- Use mid-conversation system and tool-change blocks.
- Use server-side compaction or context editing.
- If compacting client-side, replace the entire old history with a summary and retain no old thinking blocks.
- Removing only a leading run of old thinking blocks is valid. Removing a nonleading block invalidates later blocks. `[OFFICIAL][DEMONSTRATED]` ([what’s new](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1), accessed 2026-09-02)

### New beta controls

| Capability | Header | Operational use |
|---|---|---|
| Per-message effort | `mid-conversation-output-config-2026-07-01` | Raise effort for a hard turn and lower it afterward without changing the cached prefix |
| Turn-scoped system message | `mid-conversation-system-clear-at-2026-08-21` | Add temporary high-authority reminders using `clear_at: "next_user_message"` |
| Visible progress updates | `thinking-display-updates-2026-08-18` | Receive readable status text while keeping reasoning hidden |
| Thinking-binding telemetry/control | `thinking-binding-controls-2026-08-01` | Choose error or block-drop behavior and inspect transformations |
| Server-side refusal fallback | `server-side-fallback-2026-07-01` | Retry a safety refusal using default or explicit fallback routing |

`[OFFICIAL][DEMONSTRATED]` ([what’s new](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1), accessed 2026-09-02; [refusals and fallback](https://platform.claude.com/docs/en/build-with-claude/refusals-and-fallback), accessed 2026-09-02)

A cleared turn-scoped message stays in the message array byte-for-byte but stops rendering after the next user message and costs no later input tokens. This preserves both cache matching and thinking validity. `[OFFICIAL][DEMONSTRATED]` ([what’s new](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1), accessed 2026-09-02)

---

## 3. Effort strategy

### Revised recommendation

Anthropic’s exact starting guidance is:

> “Start at the default effort level, `high`, then test the other levels (`low`, `medium`, `xhigh`, and `max`) against your own evals.”

`[OFFICIAL][ASSERTION]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

Recommended `fable-max` policy:

| Workload | Starting effort | Escalation |
|---|---:|---|
| Routine transforms, summaries, straightforward edits | `medium` | Move to `high` if eval quality falls |
| Current-information research | `high` | Use per-message `xhigh` for difficult synthesis |
| Long-running coding, debugging, migrations | `high` | Test `xhigh`; use `max` only on demonstrated hard cases |
| Very long single-response deliverables | `high` | Avoid `xhigh` or `max` unless quality gains justify extra latency and output pressure |
| Latency-sensitive scoped work | `low` | Add an explicit search requirement if freshness matters |

This table is a synthesis of Anthropic’s effort recommendations and documented behavior. `[OFFICIAL][ASSERTION]` ([effort guide](https://platform.claude.com/docs/en/build-with-claude/effort), accessed 2026-09-02; [prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

Effort affects thinking, response text, tool-call frequency, and tool arguments. It is behavioral, not a strict token budget. The same level name does not represent the same amount of computation across models. `[OFFICIAL][DEMONSTRATED]` ([effort guide](https://platform.claude.com/docs/en/build-with-claude/effort), accessed 2026-09-02)

At `low`, Fable 5.1 is less likely to search and more likely to answer from memory. Raise effort for freshness-sensitive turns or add this official verification instruction:

```text
When a query centers on a name you do not confidently recognize, or recognize
from a fast-moving area like AI models and developer tools where the landscape
shifts within months, the name itself is the thing to verify: search before
answering, and include the name as the user wrote it in at least one query
alongside any reformulations.
```

`[OFFICIAL][DEMONSTRATED]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

At `xhigh` and especially `max`, thinking can consume much more of `max_tokens` before a long response begins. Set `max_tokens` for both thinking and final output, and tell the model not to draft the complete deliverable twice. `[OFFICIAL][DEMONSTRATED]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

---

## 4. Prompt changes to make

### Keep or add

#### A. Outcome-oriented task framing

Claude Code’s model guide recommends describing the outcome rather than prescribing every step, giving Fable larger tasks, and using it for ambiguous root-cause investigations, architecture decisions, and long sessions. It also says routine reminders to verify are usually unnecessary because the model verifies more often on its own. `[OFFICIAL][ASSERTION]` ([Claude Code model configuration](https://code.claude.com/docs/en/model-config), accessed 2026-09-02)

A suitable top-level task format is:

```text
Outcome:
[Concrete finished state]

Proof:
[Tests, measurements, artifacts, or inspection that establish completion]

Constraints:
[Scope boundaries, safety limits, compatibility, and files that must not change]

Work autonomously through reversible steps. Stop only for destructive actions
or a scope decision whose alternatives would materially change the result.
```

This wording is a synthesis, not an Anthropic verbatim template. `[OFFICIAL][ASSERTION]` ([Claude Code goal guide](https://code.claude.com/docs/en/goal), accessed 2026-09-02; [Fable prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

#### B. Completion and scope controls

Anthropic recommends telling the model to complete already-authorized reversible work instead of ending with a plan or permission question, while distinguishing implementation requests from requests for diagnosis or assessment. It also recommends explicitly preventing scope creep, unrelated cleanup, and excessive permanent test additions. `[OFFICIAL][ASSERTION]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

Do not shorten this to an unconditional “never ask questions.” Anthropic warns that the autonomy block can make Fable less likely to ask about genuine ambiguity, so retain explicit stop conditions for destructive operations and materially divergent interpretations. `[OFFICIAL][ASSERTION]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

#### C. Targeted editing

Add:

> “The number of tokens used to edit files is best minimized, all else being equal. Therefore, when it will not affect the end result, try to surgically edit a file rather than rewrite the entire thing.”

Anthropic says 5.1 is more likely than Fable 5 to rewrite entire text files for small changes; this instruction brings small and medium changes back toward Fable 5 behavior. `[OFFICIAL][DEMONSTRATED]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

#### D. Tool parallelism

Apply the batching instruction on each tool-result turn, preferably as a turn-scoped system message. Leave earlier copies unchanged. `[OFFICIAL][DEMONSTRATED]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

#### E. Client-side compaction

If custom compaction is unavoidable, tell the summarizer to preserve:

- Problems encountered and their resolutions.
- Options attempted, rejected, or deferred, with reasons.
- User requirements, decisions, constraints, and boundaries exactly.
- Current completion state.
- Remaining work and promises.
- Names, numbers, dates, wording, links, and other hard-to-reconstruct details exactly. `[OFFICIAL][ASSERTION]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

Because Fable 5.1 cache reads are cheaper, Anthropic recommends experimenting with later compaction points instead of assuming early compaction still optimizes total cost and intelligence. `[OFFICIAL][ASSERTION]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

#### F. Multi-agent harnesses

If the harness supports subagents, make spawning asynchronous, return control to the lead immediately, deliver results in later user messages, and provide a separate wait tool. Anthropic reports lower average completion time at similar quality, tokens, and cost when the lead can continue independent work. `[OFFICIAL][DEMONSTRATED BY ANTHROPIC]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

#### G. Vision

For dense charts, filings, PDFs, images, or video, provide access to raw files and crop, zoom, and image-processing tools. Anthropic specifically names PIL and OpenCV; it says a crop-and-enlarge tool supplies most of the benefit if a full container is impractical. `[OFFICIAL][ASSERTION]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

### Remove or revise

- Remove blanket anti-formatting instructions. Fable 5.1 uses less bold, fewer headers, and fewer lists than earlier models. Replace them with conditional formatting guidance. `[OFFICIAL][DEMONSTRATED]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

- If prose becomes dense or affected, use the short official correction:  
  > “Please remove all mannered prose.”  
  `[OFFICIAL][DEMONSTRATED]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

- Add a complete few-shot example for source synthesis. Fable 5.1 is more likely to reproduce retrieved language without marking it as quotation. The example should demonstrate comparison in the model’s own words, with any retained source wording placed in quotation marks. `[OFFICIAL][DEMONSTRATED]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

- Remove “hold all findings for the final response” if users need live updates. `[OFFICIAL][DEMONSTRATED]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

---

## 5. Claude Code configuration

### Minimum version and selection

Fable 5.1 requires Claude Code 2.1.255 or later. Use:

```bash
claude update
claude --model fable
```

or select `/model fable`. The `fable` alias resolves to Fable 5.1 from 2.1.255 onward unless `ANTHROPIC_DEFAULT_FABLE_MODEL` overrides it. Neither Fable model is the account default on any plan or provider. `[OFFICIAL][DEMONSTRATED]` ([Claude Code model configuration](https://code.claude.com/docs/en/model-config), accessed 2026-09-02)

A prior Fable 5 selection in user settings is automatically migrated to the `fable` alias on first direct-API launch under 2.1.255 or later. Project, local, and managed settings pinned to `claude-fable-5` remain pinned. `[OFFICIAL][DEMONSTRATED]` ([Claude Code model configuration](https://code.claude.com/docs/en/model-config), accessed 2026-09-02)

**Gateway exception:** in Claude apps gateway sessions, `fable` and `best` currently remain on Fable 5 because some gateways reject 5.1. Select Fable 5.1 explicitly in `/model` there. `[OFFICIAL][DEMONSTRATED]` ([Claude Code changelog](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md), version 2.1.257, 2026-09-01)

### Effort controls

Claude Code supports `low`, `medium`, `high`, `xhigh`, and `max` for Fable 5.1. The default is `high`. Unlike Fable 5, Fable 5.1 has no first-run “default effort hold,” so configured per-model effort applies normally. `max` is session-only unless set through `CLAUDE_CODE_EFFORT_LEVEL`. `[OFFICIAL][DEMONSTRATED]` ([Claude Code model configuration](https://code.claude.com/docs/en/model-config), accessed 2026-09-02)

Use `/effort`, `--effort`, or `CLAUDE_CODE_EFFORT_LEVEL`. Version 2.1.257 added `s` inside `/effort` for a session-only change. `[OFFICIAL][DEMONSTRATED]` ([Claude Code 2.1.257 release](https://github.com/anthropics/claude-code/releases/tag/v2.1.257), 2026-09-01)

`ultracode` is not a model effort level. It sends `xhigh` and enables Claude Code’s dynamic-workflow orchestration. The `ultrathink` word merely requests deeper reasoning within the active effort level; it does not change the API effort setting. `[OFFICIAL][DEMONSTRATED]` ([Claude Code model configuration](https://code.claude.com/docs/en/model-config), accessed 2026-09-02)

Thinking cannot be disabled on Fable 5.1. The session toggle, `alwaysThinkingEnabled`, `MAX_THINKING_TOKENS=0`, and the fixed-budget override do not disable it. Use effort instead. `[OFFICIAL][DEMONSTRATED]` ([Claude Code model configuration](https://code.claude.com/docs/en/model-config), accessed 2026-09-02)

### `/goal`

For long autonomous tasks, `/goal` adds a completion evaluator after each turn and continues automatically while the goal remains unfinished. State a measurable end condition, evidence of completion, constraints, and any turn or time limit. The evaluator has no tools and sees only information surfaced in the conversation, so ensure tests and proof are reported in model-visible output. `[OFFICIAL][DEMONSTRATED]` ([Claude Code goal guide](https://code.claude.com/docs/en/goal), accessed 2026-09-02)

Idle goals can check long-running background work after 30 minutes, then one hour, then two hours, with at most three automatic check-ins between user messages. `[OFFICIAL][DEMONSTRATED]` ([Claude Code goal guide](https://code.claude.com/docs/en/goal), accessed 2026-09-02; [Claude Code 2.1.246 release](https://github.com/anthropics/claude-code/releases/tag/v2.1.246), 2026-08-25)

### Recent Claude Code changes relevant to `fable-max`

- **2.1.257, 2026-09-01:** Fable 5.1 added as default Fable; session-only effort shortcut; forced subagent-model setting; gateway alias exception; model and effort controls in VS Code. `[OFFICIAL][DEMONSTRATED]` ([release](https://github.com/anthropics/claude-code/releases/tag/v2.1.257), 2026-09-01)

- **2.1.251, 2026-08-28:** model-switch hooks; resume staleness and estimated recache cost; per-session prompt-cache metrics in `/cost`; per-model saved effort; fixes for high-effort thinking combinations and Fable background usage-credit behavior. `[OFFICIAL][DEMONSTRATED]` ([release](https://github.com/anthropics/claude-code/releases/tag/v2.1.251), 2026-08-28)

- **2.1.248, 2026-08-27:** per-agent cache TTL; fix for prompt-cache misses and lost thinking caused by regenerated tool definitions. `[OFFICIAL][DEMONSTRATED]` ([release](https://github.com/anthropics/claude-code/releases/tag/v2.1.248), 2026-08-27)

- **2.1.247, 2026-08-26:** `/claude-api cost-optimize`; subagent fallback-chain handling; correct custom-system-prompt compaction. `[OFFICIAL][DEMONSTRATED]` ([release](https://github.com/anthropics/claude-code/releases/tag/v2.1.247), 2026-08-26)

- **2.1.243, 2026-08-25:** customizable model picker; separate main-agent and subagent cache TTLs; contracted model pricing for `/cost`; model and effort visibility per subagent. `[OFFICIAL][DEMONSTRATED]` ([release](https://github.com/anthropics/claude-code/releases/tag/v2.1.243), 2026-08-25)

### Agent SDK

The Agent SDK uses Claude Code’s loop, context management, tools, and model configuration. Its `model` option accepts a model alias or full ID, and its effort type includes all five Fable 5.1 levels. Subagent definitions accept the `fable` alias. `[OFFICIAL][DEMONSTRATED]` ([Agent SDK overview](https://code.claude.com/docs/en/agent-sdk/overview), accessed 2026-09-02; [Python SDK reference](https://code.claude.com/docs/en/agent-sdk/python), accessed 2026-09-02)

The literal `claude-fable-5-1` was **NOT FOUND** in the Agent SDK overview or Python reference text inspected. Use the full ID because Claude Code’s model configuration supports it, or use `fable` with Claude Code 2.1.255 or later. `[OFFICIAL][DEMONSTRATED]` ([Claude Code model configuration](https://code.claude.com/docs/en/model-config), accessed 2026-09-02)

---

## 6. Refusals, safeguards, and routing

### “Show your reasoning”

Anthropic defines `reasoning_extraction` as:

> “The request asks the model to reproduce its internal reasoning in the response text.”

Therefore, a prompt requesting hidden or verbatim chain of thought can still trigger a safety refusal. Ask for a brief rationale, evidence, assumptions, or summarized reasoning instead. `[OFFICIAL][DEMONSTRATED]` ([refusals and fallback](https://platform.claude.com/docs/en/build-with-claude/refusals-and-fallback), accessed 2026-09-02)

Other documented categories are `cyber`, `bio`, `frontier_llm`, and `general_harms`. A refusal is HTTP 200 with `stop_reason: "refusal"` and may include `stop_details.category`; do not detect it by scanning prose. Discard partial output from midstream refusals. `[OFFICIAL][DEMONSTRATED]` ([refusals and fallback](https://platform.claude.com/docs/en/build-with-claude/refusals-and-fallback), accessed 2026-09-02)

### False-positive changes

Anthropic reports that Fable 5.1’s cyber safeguards cause about 60% fewer interventions per Claude Code session than the previous Fable 5 safeguards, and its newer biology safeguards fire 85% less often on benign elementary-biology and medical requests. These figures are Anthropic’s measurements, not independent validation. `[OFFICIAL][DEMONSTRATED BY ANTHROPIC]` ([announcement](https://www.anthropic.com/claude-fable-and-mythos-5-1), 2026-09-01)

Finding vulnerabilities in source code is now permitted. Penetration testing, exploit generation, binary-based vulnerability scanning, and substantive life-science research can still route to Opus or refuse. `[OFFICIAL][DEMONSTRATED]` ([announcement](https://www.anthropic.com/claude-fable-and-mythos-5-1), 2026-09-01)

Documented false-positive mitigations:

- Ask “Are there any bugs in this program?” instead of “Does this program compile without errors?”
- Explain lesser-known programming languages and provide their documentation.
- Remove base64-encoded tool output from the model context. `[OFFICIAL][DEMONSTRATED]` ([prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02)

### API fallback

For the Claude API, `fallbacks: "default"` with `server-side-fallback-2026-07-01` retries safety declines on Anthropic’s recommended model. It does not handle overloads, rate limits, transport failures, or ordinary server errors. Server-side fallback is unavailable in Message Batches, Bedrock, Google Cloud, and Foundry; use Anthropic SDK fallback middleware there. `[OFFICIAL][DEMONSTRATED]` ([refusals and fallback](https://platform.claude.com/docs/en/build-with-claude/refusals-and-fallback), accessed 2026-09-02)

Check the response’s top-level `model`, `fallback` blocks, and `usage.iterations`; a successful request can have been served by another model. Sticky routing lasts approximately one hour and stores a content hash rather than message content. `[OFFICIAL][DEMONSTRATED]` ([refusals and fallback](https://platform.claude.com/docs/en/build-with-claude/refusals-and-fallback), accessed 2026-09-02)

### Claude Code fallback

Claude Code routes Fable 5.1 biology flags to Opus 5 and cyber flags to Opus 4.8. The session remains on that fallback until the user selects the original model again. Set `switchModelsOnFlag: false` for interactive confirmation; noninteractive and SDK sessions that cannot show the prompt end the turn with a refusal. `[OFFICIAL][DEMONSTRATED]` ([Claude Code model configuration](https://code.claude.com/docs/en/model-config), accessed 2026-09-02)

A repository can trigger fallback on its first request because Claude Code includes `CLAUDE.md`, directory information, and git status. Test with `claude --safe-mode` to determine whether customizations are responsible. `[OFFICIAL][DEMONSTRATED]` ([Claude Code model configuration](https://code.claude.com/docs/en/model-config), accessed 2026-09-02)

---

## 7. Retention and ZDR

The answer for the guide should remain:

> **Fable 5.1 is a 30-day-retention Covered Model and is not generally ZDR-eligible.**

`[OFFICIAL][DEMONSTRATED]` ([retention policy](https://platform.claude.com/docs/en/manage-claude/api-and-data-retention), accessed 2026-09-02)

On the Claude API, an organization or workspace without the required retention receives `400 invalid_request_error`. A ZDR organization can enable 30-day retention for only the workspace that needs Fable while preserving ZDR elsewhere. On Bedrock and Google Cloud, retained data remains within the cloud provider environment. `[OFFICIAL][DEMONSTRATED]` ([retention policy](https://platform.claude.com/docs/en/manage-claude/api-and-data-retention), accessed 2026-09-02)

The phrase “unless expressly authorized by Anthropic” matters. Anthropic’s announcement says customers eligible for Enterprise Frontier Safeguards can receive an interim Fable 5 or 5.1 ZDR exception until EFS becomes available. EFS is planned to store protected data in customer-controlled cloud infrastructure and roll out in phases beginning later in fall 2026. This is a controlled eligibility path, not a general policy reversal. `[OFFICIAL][DEMONSTRATED, WITH FUTURE ASSERTION]` ([announcement](https://www.anthropic.com/claude-fable-and-mythos-5-1), 2026-09-01)

---

## 8. Pricing, caching, and throughput

| Item | Fable 5.1 price |
|---|---:|
| Base input | $10/MTok |
| Output | $50/MTok |
| Five-minute cache write | $12.50/MTok |
| One-hour cache write | $20/MTok |
| Cache read | $0.25/MTok |
| Batch input/output | 50% discount |

`[OFFICIAL][DEMONSTRATED]` ([pricing](https://platform.claude.com/docs/en/about-claude/pricing), accessed 2026-09-02)

The cache-read price is one quarter of Fable 5’s. Anthropic’s 25% typical and 45% highly-agentic savings estimates came from usage-based pricing at default effort over four weeks of August 2026 across Claude Enterprise, Claude Code, and the API. `[OFFICIAL][DEMONSTRATED BY ANTHROPIC]` ([announcement](https://www.anthropic.com/claude-fable-and-mythos-5-1), 2026-09-01)

Fable 5.1 and Fable 5 share one rate-limit pool; Mythos 5.1 and Mythos 5 share a separate pool. In the published tier table, the displayed Fable pool is 1,000 RPM, 500,000 uncached input tokens per minute, and 100,000 output tokens per minute, but actual limits are tier and workspace dependent and should be read from Console or the Rate Limits API. Cached reads do not count toward ITPM for Fable, and a larger `max_tokens` does not reserve OTPM. `[OFFICIAL][DEMONSTRATED]` ([rate limits](https://platform.claude.com/docs/en/api/rate-limits), accessed 2026-09-02)

Practical implication: maximize stable prefix caching for system instructions, tool definitions, repository context, and conversation history. This improves both price and effective input throughput. `[OFFICIAL][ASSERTION]` ([rate limits](https://platform.claude.com/docs/en/api/rate-limits), accessed 2026-09-02)

Neither Fable 5.1 nor Mythos 5.1 supports Priority Tier, although Fable 5 does. `[OFFICIAL][DEMONSTRATED]` ([migration guide](https://platform.claude.com/docs/en/models/fable-5-1/migration-guide), accessed 2026-09-02)

---

## 9. Capability evidence and limits

Anthropic reports these production-safeguard benchmark results:

| Benchmark | Fable 5.1 | Fable 5 | Opus 5 |
|---|---:|---:|---:|
| Terminal-Bench-Science 0.1 | 52.6% | 24.7% | 29.0% |
| Terminal-Bench 4.0 | 55.8% | 42.0% | 52.3% |
| GDPval-AA v2 | 1853 | 1723 | 1824 |
| OSWorld 2.0 strict | 41.7% | 36.1% | 39.6% |
| Humanity’s Last Exam, no tools | 60.9% | 57.8% | 56.6% |
| Humanity’s Last Exam, tools | 65.0% | 63.8% | 63.6% |
| AutomationBench | 31.4% | 17.1% | 26.9% |
| CursorBench 3.2.0 | 73.4% | 70.5% | 70.0% |

`[OFFICIAL][DEMONSTRATED BY ANTHROPIC, NOT INDEPENDENT]` ([announcement](https://www.anthropic.com/claude-fable-and-mythos-5-1), 2026-09-01)

Anthropic says the largest improvements concentrate in long-running coding, multistep research, document and presentation work, long-context synthesis, vision, and computer use. Multilingual performance is reported as roughly unchanged from Fable 5. `[OFFICIAL][ASSERTION]` ([what’s new](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1), accessed 2026-09-02)

Benchmark interpretation requires caution. Anthropic notes that safeguard intervention caused zero scores on some OSWorld and AutomationBench cases, and that other affected cyber and biology tasks were completed by fallback models. `[OFFICIAL][DEMONSTRATED BY ANTHROPIC]` ([announcement](https://www.anthropic.com/claude-fable-and-mythos-5-1), 2026-09-01)

Partner testimonials on the Anthropic launch page are third-party claims hosted by Anthropic. They are therefore `[UNOFFICIAL][ASSERTION]` and were not used as the basis for this guide.

---

## 10. Direct answers to the guide’s disputed points

| Existing proposition | 5.1 verdict | Evidence |
|---|---|---|
| “Use high effort and never xhigh.” | **OBSOLETE.** Start high, test all levels, and use xhigh or max where evals prove value. | `[OFFICIAL][ASSERTION]` [prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02 |
| “Show your reasoning improves results.” | **REWRITE.** Request conclusions, evidence, assumptions, or summarized reasoning. Requests for internal reasoning can trigger `reasoning_extraction`. | `[OFFICIAL][DEMONSTRATED]` [refusal guide](https://platform.claude.com/docs/en/build-with-claude/refusals-and-fallback), accessed 2026-09-02 |
| “Fable requires 30-day retention.” | **STILL TRUE.** | `[OFFICIAL][DEMONSTRATED]` [retention policy](https://platform.claude.com/docs/en/manage-claude/api-and-data-retention), accessed 2026-09-02 |
| “Fable is excluded from ZDR.” | **GENERALLY TRUE, WITH EXPRESSLY AUTHORIZED EXCEPTIONS.** | `[OFFICIAL][DEMONSTRATED]` [retention policy](https://platform.claude.com/docs/en/manage-claude/api-and-data-retention), accessed 2026-09-02 |
| “Forced tool choice is safe.” | **FALSE FOR 5.1.** It returns HTTP 400. | `[OFFICIAL][DEMONSTRATED]` [what’s new](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1), accessed 2026-09-02 |
| “Thinking can be disabled to save money.” | **FALSE.** Use lower effort. | `[OFFICIAL][DEMONSTRATED]` [migration guide](https://platform.claude.com/docs/en/models/fable-5-1/migration-guide), accessed 2026-09-02 |
| “History may be rebuilt between API calls.” | **UNSAFE.** Keep it append-only or strip carried thinking during a complete client-side reset. | `[OFFICIAL][DEMONSTRATED]` [prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02 |
| “Compact early to reduce Fable cost.” | **RETEST.** Cache reads are much cheaper, so later compaction may be the better cost-intelligence tradeoff. | `[OFFICIAL][ASSERTION]` [prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02 |
| “Fable is the default Claude Code model.” | **FALSE.** It must be selected; it is not the account default on any plan or provider. | `[OFFICIAL][DEMONSTRATED]` [model configuration](https://code.claude.com/docs/en/model-config), accessed 2026-09-02 |
| “Fable supports Priority Tier.” | **FALSE FOR 5.1.** | `[OFFICIAL][DEMONSTRATED]` [migration guide](https://platform.claude.com/docs/en/models/fable-5-1/migration-guide), accessed 2026-09-02 |

---

## 11. NOT FOUND and retrieval limitations

- **Exact Claude subscription-plan matrix for Fable 5.1:** **NOT FOUND.** Claude Code says Fable is not the account default on any plan and that availability is checked server-side, but the inspected official pages do not give a complete Free, Pro, Max, Team, and Enterprise availability table. ([Claude Code model configuration](https://code.claude.com/docs/en/model-config), accessed 2026-09-02)

- **Claude Platform on AWS model ID for Mythos 5.1:** **NOT FOUND** on the official Mythos 5.1 model page. The page lists Claude API, Bedrock, Google Cloud, and Microsoft Foundry. ([Mythos 5.1 overview](https://platform.claude.com/docs/en/models/mythos-5-1/overview), accessed 2026-09-02)

- **Independent replication of Anthropic’s benchmark, cost, or false-positive results:** **NOT FOUND in Lane A by definition.** All quantitative results above are Anthropic-published measurements.

- **Full searchable system-card text:** Anthropic officially lists and links the Fable 5.1 and Mythos 5.1 System Card, but the linked 16.4 MB PDF exceeded this retrieval system’s document limit. Page-level contents were therefore **NOT EXTRACTED**, and no secondary summary was substituted. ([official system-card index](https://www.anthropic.com/system-cards), September 2026; [official PDF](https://www-cdn.anthropic.com/0339e6a7c5c7b87f5c07798616dc32c215d14235/Claude%20Fable%205.1%20%26%20Claude%20Mythos%205.1%20System%20Card.pdf), September 2026)

---

## Full official source list

All undated documentation pages were accessed on 2026-09-02.

1. [Claude Fable 5.1 overview](https://platform.claude.com/docs/en/models/fable-5-1/overview), published 2026-09-01.
2. [What’s new in Claude Fable 5.1](https://platform.claude.com/docs/en/models/fable-5-1/whats-new-fable-5-1), accessed 2026-09-02.
3. [Fable 5.1 and Mythos 5.1 migration guide](https://platform.claude.com/docs/en/models/fable-5-1/migration-guide), accessed 2026-09-02.
4. [Prompting Claude Fable 5.1](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), accessed 2026-09-02.
5. [Claude prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices), accessed 2026-09-02.
6. [Claude Mythos 5.1 overview](https://platform.claude.com/docs/en/models/mythos-5-1/overview), published 2026-09-01.
7. [Introducing Claude Fable 5.1 and Claude Mythos 5.1](https://www.anthropic.com/claude-fable-and-mythos-5-1), 2026-09-01.
8. [Models overview](https://platform.claude.com/docs/en/models/overview), accessed 2026-09-02.
9. [Choosing the right model](https://platform.claude.com/docs/en/about-claude/models/choosing-a-model), accessed 2026-09-02.
10. [Model IDs and versioning](https://platform.claude.com/docs/en/about-claude/models/model-ids-and-versions), accessed 2026-09-02.
11. [Effort](https://platform.claude.com/docs/en/build-with-claude/effort), accessed 2026-09-02.
12. [Pricing](https://platform.claude.com/docs/en/about-claude/pricing), accessed 2026-09-02.
13. [Token counting](https://platform.claude.com/docs/en/build-with-claude/token-counting), accessed 2026-09-02.
14. [Rate limits](https://platform.claude.com/docs/en/api/rate-limits), accessed 2026-09-02.
15. [Refusals and fallback](https://platform.claude.com/docs/en/build-with-claude/refusals-and-fallback), accessed 2026-09-02.
16. [API and data retention](https://platform.claude.com/docs/en/manage-claude/api-and-data-retention), accessed 2026-09-02.
17. [Fable 5.1 system prompt](https://platform.claude.com/docs/en/release-notes/system-prompts/claude-fable-5-1), dated 2026-09-01. This applies to claude.ai and Claude apps, not the API.
18. [System-prompt overview](https://platform.claude.com/docs/en/release-notes/system-prompts/overview), accessed 2026-09-02.
19. [Official system-card index](https://www.anthropic.com/system-cards), September 2026.
20. [Official Fable 5.1 and Mythos 5.1 System Card PDF](https://www-cdn.anthropic.com/0339e6a7c5c7b87f5c07798616dc32c215d14235/Claude%20Fable%205.1%20%26%20Claude%20Mythos%205.1%20System%20Card.pdf), September 2026.
21. [Claude Code model configuration](https://code.claude.com/docs/en/model-config), accessed 2026-09-02.
22. [Claude Code goals](https://code.claude.com/docs/en/goal), accessed 2026-09-02.
23. [Claude Code costs](https://code.claude.com/docs/en/costs), accessed 2026-09-02.
24. [Claude Code changelog](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md), accessed 2026-09-02.
25. [Claude Code 2.1.257](https://github.com/anthropics/claude-code/releases/tag/v2.1.257), 2026-09-01.
26. [Claude Code 2.1.251](https://github.com/anthropics/claude-code/releases/tag/v2.1.251), 2026-08-28.
27. [Claude Code 2.1.248](https://github.com/anthropics/claude-code/releases/tag/v2.1.248), 2026-08-27.
28. [Claude Code 2.1.247](https://github.com/anthropics/claude-code/releases/tag/v2.1.247), 2026-08-26.
29. [Claude Code 2.1.246](https://github.com/anthropics/claude-code/releases/tag/v2.1.246), 2026-08-25.
30. [Claude Code 2.1.243](https://github.com/anthropics/claude-code/releases/tag/v2.1.243), 2026-08-25.
31. [Agent SDK overview](https://code.claude.com/docs/en/agent-sdk/overview), accessed 2026-09-02.
32. [Agent SDK Python reference](https://code.claude.com/docs/en/agent-sdk/python), accessed 2026-09-02.