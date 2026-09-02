# Fable 5.1 on API, Agent SDK, and subagent bodies: you own the system prompt

Load this ONLY for API/SDK harness work or custom subagent authoring. For Claude Code sessions, prompting.md is the guide; the harness already ships most of these instructions there.

Official facts from platform.claude.com (models/fable-5-1/{overview,whats-new,migration-guide}, prompt-engineering/prompting-claude-fable-5-1, effort, refusals-and-fallback), accessed 2026-09-02. Fable 5.1 released 2026-09-01. Snippets are verbatim.

## Contents
- Who needs this
- Model ids, limits, prices
- Breaking changes vs Fable 5 (and Opus 5)
- Beta headers that matter
- The snippet set (assemble your system prompt)
- Per-turn snippets (turn-scoped system messages)
- send_to_user tool
- API config that pairs with the prompt
- Agent SDK shortcut
- Claude Code subagent bodies

## Who needs this

| Surface | Default system prompt | Verdict |
|---|---|---|
| Raw Messages API | None | Add everything below |
| Agent SDK | "a minimal prompt that covers tool calling but omits Claude Code's coding guidelines, response style, and project context" | Add below, or use the preset |
| Claude Code custom subagents (`.claude/agents/*.md`) | Only the agent body + basic environment details, NOT the full Claude Code prompt | Put the relevant snippets in the body |

## Model ids, limits, prices

- `claude-fable-5-1` (Claude API, Google Cloud, Microsoft Foundry, Claude Platform on AWS); `anthropic.claude-fable-5-1` on Bedrock. `claude-mythos-5-1` = same weights, fewer safeguards, Project Glasswing only. Dateless ids are fixed snapshots (weights do not change behind them).
- 1M context (default and max, flat price across the window), 128K max output, adaptive thinking always on, default effort `high`, knowledge cutoff Jun 2026, "slower" latency tier. Same tokenizer as Fable 5 (~30% more tokens than pre-Opus-4.7 models).
- $10 in / $50 out per MTok. Cache write $12.50 (5m) / $20 (1h). **Cache read $0.25** (0.025x base; Fable 5 was $1.00). Batch 50% off. Min cacheable prefix 512 tokens. No Priority Tier on 5.1 (Fable 5 had it).
- Rate limits: Fable 5.1 and Fable 5 share one pool; cached reads do not count toward input-tokens-per-minute; a large `max_tokens` does not reserve output throughput.
- 30-day retention required; not ZDR-eligible unless Anthropic expressly authorizes (Enterprise Frontier Safeguards interim path only). A ZDR org gets `400 invalid_request_error` unless it enables 30-day retention on the workspace that needs Fable.
- Every text output carries a statistical watermark (no extra tokens, undetectable without Anthropic's detection API); files from code execution carry C2PA credentials via the Files API.

## Breaking changes vs Fable 5 (and Opus 5)

| Pattern | Fable 5.1 | Fix |
|---|---|---|
| `tool_choice: {"type":"any"}` or `{"type":"tool","name":...}` | 400 `tool_choice: type "tool" and "any" are not supported for this model.` (also on Batches and token-counting) | `auto` + say in the prompt when the tool applies ("Use the `get_weather` tool to answer"), `strict: true` for schema, or structured outputs |
| `thinking: {"type":"disabled"}` or `budget_tokens` | 400 at every effort | Omit `thinking` (or `{"type":"adaptive"}`); control spend with effort |
| Assistant prefill; non-default temperature/top_p/top_k | 400 | System instructions; structured outputs |
| Fable 5.1 thinking blocks sent to ANY earlier model (Opus 5, Fable 5, ...) | Dropped silently (not billed); reported in `input_transformations` only with `thinking-binding-controls-2026-08-01` | One-way: 5.1 reads everyone's blocks, nobody reads 5.1's. Routers that fall back mid-conversation lose reasoning for those turns |
| Editing anything before a 5.1 thinking block (system, tools, earlier message, per-turn reminder you inject then delete, image bytes that changed) | 400 `The block is bound to a different conversation` on accounts created on/after 2026-08-31; older accounts only log the mismatch unless `thinking.block_binding.prefix_mismatch_behavior` is set. Future models will enforce for everyone | Append-only history. Instructions via mid-conversation system messages, tool changes via `tool_addition`/`tool_removal`, trimming via server-side compaction/context editing. Client-side compaction: replace the whole history with one summary + new user turn, carry no thinking blocks |

Still valid across requests: appending turns, removing a LEADING run of thinking blocks, changing effort/max_tokens/cache_control. The same edits that break binding also restart the prompt cache, so append-only is the cost rule too.

Migration check: run a normal session with header `thinking-binding-controls-2026-08-01` and `prefix_mismatch_behavior: "drop_block"`, log `input_transformations`; empty every turn = clean. In CI set `"error"`. In Claude Code, run `/claude-api migrate this project to claude-fable-5-1` (bundled skill; also `/claude-api prompt-audit` and `/claude-api cost-optimize`).

## Beta headers that matter

| Capability | Header | Use |
|---|---|---|
| Per-message effort (keeps the cache) | `mid-conversation-output-config-2026-07-01` | `{"role":"system","content":[],"output_config":{"effort":"low"}}` anywhere in `messages`; applies from the next user turn. Fable 5 returns 400 on this. Prefer it over changing top-level effort (which restarts the cache AND steers less reliably: earlier replies were written at the old level and the model stays consistent with them) |
| Turn-scoped system message | `mid-conversation-system-clear-at-2026-08-21` | `{"role":"system","clear_at":"next_user_message","content":"..."}`: system authority for one turn, stops rendering after the next user message, stays in the array byte-for-byte (cache + binding safe, zero later input tokens) |
| Progress updates as text | `thinking-display-updates-2026-08-18` | `thinking.display: "updates"`: the short notes 5.1 writes before each tool call come back as non-empty `thinking` blocks; default `"omitted"` returns them empty, so a long turn looks silent |
| Thinking-binding controls | `thinking-binding-controls-2026-08-01` | `prefix_mismatch_behavior: "error" | "drop_block"`, `input_transformations` telemetry |
| Server-side refusal fallback | `server-side-fallback-2026-07-01` | `fallbacks: "default"` (Anthropic's pick per category) or explicit `[{"model":"claude-opus-5"}]`. Permitted targets for 5.1: Opus 4.8 and Opus 5 |

## The snippet set (assemble your system prompt)

Core-law shape first: goal + reason + boundaries + verification means. Then add per need. All quoted text is Anthropic's, from the Fable 5.1 prompting guide unless noted (em dashes in the originals replaced with commas, house style; nothing else changed). Claude Code already ships the ones marked (CC ships) in its own system prompt; do not duplicate those inside Claude Code.

**Finish the whole task (CC ships). Apply both blocks; the first sentence carries most of the effect. Side effect: fewer clarifying questions on ambiguous asks, so list the confirmations you DO want after it.**
> "You are operating autonomously. The user is not watching in real time and cannot answer questions mid-task, so asking 'Want me to…?' or 'Shall I…?' will block the work. For reversible actions that follow from the original request, proceed without asking. Stop only for destructive actions or genuine scope changes the user must decide. Offering follow-ups after the task is done is fine; asking permission before doing the work is not.
>
> Exception: when the user is describing a problem, asking a question, or thinking out loud rather than requesting a change, the deliverable is your assessment. Report your findings and stop. Don't apply a fix until they ask for one.
>
> Before ending your turn, check your last paragraph. If it is a plan, an analysis, a question, a list of next steps, or a promise about work you have not done ('I'll…', 'let me know when…'), do that work now with tool calls. That includes retrying after errors and gathering missing information yourself. Do not stop because the context or session is long. End your turn only when the task is complete or you are blocked on input only the user can provide.
>
> Before running a command that changes system state (such as restarts, deletes, or config edits), check that the evidence actually supports that specific action. A signal that pattern-matches to a known failure may have a different cause."

**Delivering work / scope (CC ships):**
> "The user's request, or the plan they approved, sets the scope, and the scope is the deliverable: don't quietly narrow, widen, or swap it. Read ambiguity the way a careful colleague would: make routine judgment calls yourself, and check in only when different readings would lead to materially different work. If you see a real problem with the task as specified, say so in a sentence or two and keep building under stated assumptions; if the user hears the concern and reaffirms, that is their decision, so deliver the full request.
>
> If a question comes up partway, first do everything that doesn't depend on the answer; then state the assumption you made, or, when going ahead on a wrong guess would be unsafe or would make the work useless, put the question at the end of a turn that also delivers that progress. If one part turns out to be blocked, complete every other part in full and say exactly what you left out and why, the whole task is the deliverable, and scaling it down is the user's call, not yours. A step you have decided on is something to run, not to announce: describing the next step and ending the turn leaves it undone until the user replies.
>
> Keep changes to what the request needs. Something else you notice worth doing, cleanup or documentation the task didn't call for, a change to a file the task didn't require, is a suggestion to make at the end, not a change to make; actions clearly beyond what the ask implies, and risky or destructive ones, still need the user's go-ahead."

**Keep changes and tests to what the task asks for (NOT shipped; Anthropic: unrequested additions and committed test files "drop substantially with no measurable change in task success"):**
> "If, while working or testing, you find a pre-existing bug, a performance concern, or behavior the task doesn't mention, don't fix, optimize or extend it in this change unless the requested behavior cannot work without it; report it as a follow-up in your summary. Where the task is ambiguous, implement the reading its wording and the surrounding code most directly support, state that assumption in your summary, and don't build for the other readings as well. Verify your work however you like; scratch scripts and quick checks need not be kept. Commit tests only where the task asks for them or this repository already keeps tests for this kind of change, sized like the neighboring test files, roughly one focused test per stated behavior, and don't turn scratch checks into additional permanent test files. This is about extras only: implement every behavior the task asks for, completely."

**Prefer targeted edits over whole-file rewrites (NOT shipped; 5.1 rewrites whole files more than Fable 5):**
> "The number of tokens used to edit files is best minimized, all else being equal. Therefore, when it will not affect the end result, try to surgically edit a file rather than rewrite the entire thing."

**Progress updates (CC ships the first line). Also delete any "hold all findings for the final response" line first:**
> "Before you start, say in a line what you're about to do; brief updates while you work help the user follow along. Close with a short recap that stands on its own, what you found, what you did, and what's next, so a reader who only sees the last message has the full picture."

**Search triggering at low effort (NOT shipped; at `low` 5.1 answers from memory instead of searching):**
> "When a query centers on a name you do not confidently recognize, or recognize from a fast-moving area like AI models and developer tools where the landscape shifts within months, the name itself is the thing to verify: search before answering, and include the name as the user wrote it in at least one query alongside any reformulations. This holds even when you have some background on it, partial background is exactly what makes an out-of-date answer sound authoritative, so familiarity is not a reason to skip the search."

**Writing density (prose denser than Fable 5 in places). Short form works; put it in the user message:**
> "Please remove all mannered prose."

**Formatting in chat (5.1 under-formats; DELETE inherited anti-bullet/anti-bold rules, replace with):**
> "Use lists and bullet points when asked to, or when the content is multifaceted enough that they help with clarity. If the person explicitly requests minimal formatting, always format your responses without bullet points, headers, lists, or bold emphasis, as requested. In conversational, personal, or emotional exchanges, keep to plain prose."

**Quoting retrieved sources (5.1 reproduces source passages unmarked; Every also measured 43 invented "quotes" when asked for 8-12): add ONE complete example (request, response, one-sentence rationale) to the system prompt, with `[web_search: ...]` lines renamed to your tool. Then audit every exact quote against source text before delivery.**

**Compaction summary (client-side only; server-side compaction already does this):**
> "Summarize the transcript inside <summary></summary> tags. Include relevant information in the summary such that this conversation will be continued by a new context window without needing to redo work or be reprovided with relevant constraints or context. Be sure to preserve: (1) any difficulties or problems that came up, and how they were handled or resolved; (2) any possibilities, options, or approaches that were raised, tried, or set aside, and why; (3) anything that was asked for, decided, agreed, ruled out, or established as a preference, constraint, or boundary, stated exactly; (4) exactly where things stand now, what has been covered, settled, or completed so far; (5) anything still open, unresolved, promised, or expected to happen next; (6) specific details that would be hard to reconstruct, names, numbers, dates, exact wording, links or references, kept exactly. Be complete on these even at the cost of length; keep everything else concise. Weight the two voices differently: keep what the user said, asked for, shared, or established carefully and close to their own words; your own explanations and reasoning can be condensed much further, to what they concluded or produced, as long as nothing in the six items above is dropped."

**Long deliverables at xhigh/max (the model drafts the whole thing in thinking, then again as output). Run these at `high`; if you must go higher, append to the user message with the real number:**
> "Everything produced in one reply, including any reasoning or drafting it does before the reply, counts toward a single limit of about [max_tokens] tokens. If that limit is reached before the reply is finished, the person receives a cut-off response and has to start over. Composing an entire output or deliverable in full as reasoning and then again as a reply would double the length of the turn without improving the result, so don't do that.
>
> Instead, when the person has asked for a long or effort-intensive deliverable such as a multi-section document, a large table or dataset, or a complete code file, spend extra effort on understanding the request, checking the inputs the answer depends on, settling the structure and other difficult decisions, and otherwise using the reasoning space to reason and the output space to write an output. Usually it is not needed to draft an output multiple times."

**Grounded progress (audit-claims; Anthropic: "nearly eliminated fabricated status reports"; CC ships only the report-faithfully half):**
> "Before reporting progress, audit each claim against a tool result from this session. Only report work you can point to evidence for; if something is not yet verified, say so explicitly. Report outcomes faithfully: if tests fail, say so with the output; if a step was skipped, say that."

**Self-verification cadence (not shipped anywhere; the one Fable 5 gap snippet still open):**
> "Establish a method for checking your own work at an interval of [X] as you build. Run this every [X interval], verifying your work with subagents against the specification."

**Context anxiety (CC ships it now: "you don't need to wrap up early"). API harnesses that surface token counts still need it; better, do not surface counts:**
> "You have ample context remaining. Do not stop, summarize, or suggest a new session on account of context limits. Continue the work."

**Subagents (harness design, not a snippet):** make the spawn tool return immediately, deliver results in a later `user` message, give the lead a separate wait tool. Anthropic: lower average time to completion at similar quality, tokens, and cost. Add one rule from the field: the lead must not edit a file a reviewer subagent is currently inspecting (loop reports, 2026-09-02).

**Vision:** give the model a crop-and-zoom tool (or a container with PIL/OpenCV and the raw files). Anthropic: the crop tool alone delivers most of the uplift; the cookbook has a working `multimodal-crop-tool` definition.

**Memory surface (unchanged):**
> "Store one lesson per file with a one-line summary at the top. Record corrections and confirmed approaches alike, including why they mattered. Don't save what the repo or chat history already records; update an existing note rather than creating a duplicate; delete notes that turn out to be wrong."

BAN carried from the DELETE list: no "show your reasoning" or "reproduce your chain of thought" language (`reasoning_extraction` refusal category; ask for conclusions, evidence, assumptions, or use `thinking.display: "summarized"`), no step-by-step recipes, no token countdowns, no verification nags (provide the verification MEANS), no negative-only constraints where the intent can be stated (`/claude-api prompt-audit` flags "No text inside generated images"-style lines).

## Per-turn snippets (turn-scoped system messages)

Coding and computer-use loops where the next reads are implied, not named: 5.1 may issue ONE tool call per turn where Fable 5 batched. Same answer quality, more round trips. Append this after every tool-result user message as a turn-scoped system message (`clear_at: "next_user_message"`; without the beta, as a text block after the `tool_result` blocks), leave earlier copies in place byte-for-byte:
> "First privately list what you need next; then request every item that doesn't depend on another's result in this one response."

If your UI hides tool output, say so the same way, or the model runs commands "to show" output nobody sees:
> "Only you see that command's output, the user's terminal shows at most a few lines of it. If the user needs to read any of it, put it in your reply."

Claude Code 2.1.258 injects both of these itself.

## send_to_user tool

For content the user must see verbatim mid-run (tool inputs are never summarized). Define the tool AND elicit it; without the system-prompt line Fable rarely calls it.

```json
{
  "name": "send_to_user",
  "description": "Display a message directly to the user. Use this for progress updates, partial results, or content the user must see exactly as written before the task finishes.",
  "input_schema": {
    "type": "object",
    "properties": {
      "message": { "type": "string", "description": "The content to display to the user." }
    },
    "required": ["message"]
  }
}
```

Elicitation line:
> "Between tool calls, when you have content the user must read verbatim (a partial deliverable, a direct answer to their question), call the send_to_user tool with that content. Use send_to_user only for user-facing content, not for narration or reasoning."

With `thinking.display: "updates"` you may not need this at all: render the non-empty `thinking` blocks between `tool_use` blocks as status lines.

## API config that pairs with the prompt

- Omit `thinking` (always on). `display: "updates"` for status lines, `"summarized"` for summaries too; raw chain of thought is never returned.
- `output_config: {effort: "high"}` to start; re-sweep all five levels on YOUR evals (level names are recalibrated per model; 5.1 `medium` ≈ Fable 5 `high`, 5.1 `low` beats Opus/Sonnet on cost per task while scoring higher, per Anthropic). Change effort per message (beta) rather than per request.
- `max_tokens` large at high and above: it caps thinking + text together. Measured (Willison, 2026-09-01, one prompt): low/medium/high ≈ 2k output tokens and $0.10-0.13; xhigh 36.8k tokens, $1.83, 7:51; max 65.9k tokens, $3.30, 13:54. A 64k thinking budget was exhausted with zero output on a hard build (KingBench-style harness, AICodeKing 2026-09-02; Chaen 2026-09-02 hit the 64k output cap three times at `high` on a physics sim). Size for the worst turn, not the average.
- Stream long turns.
- Refusals: HTTP 200 with `stop_reason: "refusal"` and `stop_details.category` in {`cyber`, `bio`, `frontier_llm`, `reasoning_extraction`, `general_harms`}. Not billed if before any output. `fallbacks: "default"` with header `server-side-fallback-2026-07-01`; check top-level `model`, `fallback` blocks, `usage.iterations`; sticky routing ~1h by content hash. Not available on Batches/Bedrock/Vertex/Foundry (use the SDK middleware there). Fallback credit refunds the cache cost of switching. Batch refusals do not mint fallback credit.
- Log per request: returned `model`, effort, cache read/write tokens, reasoning tokens, `input_transformations`, subagent count. Cost per completed TASK is the metric; cost per step misleads (5.1 `max` uses ~1.7x the output tokens of Fable 5 `max`: Artificial Analysis 2026-09-01).

## Agent SDK shortcut

`systemPrompt: {type: "preset", preset: "claude_code"}` gets Claude Code's full prompt (then the CC-shipped snippets are covered); `append` for additions. `model: "fable"` (Claude Code 2.1.255+) or the full id; effort accepts all five levels. CLAUDE.md loading is separate (`settingSources`). Without the preset, assemble from the snippet set.

## Claude Code subagent bodies

Minimum viable set in the agent .md body: finish-the-whole-task (first block at least) + grounded progress + scope/tests + surgical edits + the task's verification means, plus a `model:` pin (see tokens.md). Custom subagents also read CLAUDE.md (except Explore and Plan), so project facts arrive free; behavioral snippets do not. `experimental.cacheTtl: "1h"` in frontmatter for long-lived agents (2.1.248). A Fable-pinned subagent draws from the same weekly Fable cap as the main session.
