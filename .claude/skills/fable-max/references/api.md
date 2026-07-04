# Fable 5 on API, Agent SDK, and subagent bodies: you own the system prompt

Load this ONLY for API/SDK harness work or custom subagent authoring. For Claude Code sessions, prompting.md is the guide; the harness already ships these instructions there.

Official snippets from platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5 (accessed 2026-07-04), verbatim.

## Contents
- Who needs this
- The snippet set (assemble your system prompt)
- send_to_user tool
- API config that pairs with the prompt
- Agent SDK shortcut
- Claude Code subagent bodies

## Who needs this

| Surface | Default system prompt | Verdict |
|---|---|---|
| Raw Messages API | None | Add everything below |
| Agent SDK | "a minimal prompt that covers tool calling but omits Claude Code's coding guidelines, response style, and project context" | Add below, or use the preset |
| Claude Code custom subagents (`.claude/agents/*.md`) | Only the agent body + basic environment details, NOT the full Claude Code prompt (official sub-agents doc) | Put the relevant snippets in the body |

## The snippet set (assemble your system prompt)

Core-law shape first: goal + reason + boundaries + verification method. Then add snippets per need:

**Act, don't overplan:**
> "When you have enough information to act, act. Do not re-derive facts already established in the conversation, re-litigate a decision the user has already made, or narrate options you will not pursue in user-facing messages. If you are weighing a choice, give a recommendation, not an exhaustive survey."

**No unrequested tidying (for higher effort):**
> "Don't add features, refactor, or introduce abstractions beyond what the task requires. A bug fix doesn't need surrounding cleanup and a one-shot operation usually doesn't need a helper. Don't design for hypothetical future requirements: do the simplest thing that works well. Only validate at system boundaries (user input, external APIs)."

**Grounded progress (Anthropic: "nearly eliminated fabricated status reports"):**
> "Before reporting progress, audit each claim against a tool result from this session. Only report work you can point to evidence for; if something is not yet verified, say so explicitly. Report outcomes faithfully: if tests fail, say so with the output; if a step was skipped, say that."

**Boundaries, assessment vs action:**
> "When the user is describing a problem, asking a question, or thinking out loud rather than requesting a change, the deliverable is your assessment. Report your findings and stop. Don't apply a fix until they ask for one."

**Autonomous operation (unattended pipelines):**
> "You are operating autonomously. The user is not watching in real time and cannot answer questions mid-task, so asking 'Want me to...?' or 'Shall I...?' will block the work. For reversible actions that follow from the original request, proceed without asking. Before ending your turn, check your last paragraph. If it is a plan, a question, a list of next steps, or a promise about work you have not done, do that work now with tool calls."

**Context anxiety fix (only if your harness surfaces token counts; better: don't surface them):**
> "You have ample context remaining. Do not stop, summarize, or suggest a new session on account of context limits. Continue the work."

**Async subagents:**
> "Delegate independent subtasks to subagents and keep working while they run. Intervene if a subagent goes off track or is missing relevant context."

**Memory surface (give it a markdown file and this format):**
> "Store one lesson per file with a one-line summary at the top. Record corrections and confirmed approaches alike, including why they mattered. Don't save what the repo or chat history already records; update an existing note rather than creating a duplicate; delete notes that turn out to be wrong."

**Self-verification cadence (fresh-context verifiers beat self-critique):**
> "Establish a method for checking your own work at an interval of [X] as you build. Run this every [X interval], verifying your work with subagents against the specification."

**Lead with outcome (comms style):**
> "Lead with the outcome. Your first sentence after finishing should answer 'what happened' or 'what did you find'. Supporting detail and reasoning come after. When you write the summary at the end, drop the working shorthand. Write complete sentences. Spell out terms. Don't use arrow chains or labels you made up earlier."

BAN carried from the DELETE list: no "show your reasoning" language anywhere in the system prompt (triggers `reasoning_extraction` refusal), no step-by-step recipes, no token countdowns, no verification nags (provide the verification MEANS instead).

## send_to_user tool

For content the user must see verbatim mid-run (tool inputs are never summarized). Define the tool AND elicit it; official: without the system-prompt instruction Fable rarely calls it.

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

## API config that pairs with the prompt

- Omit `thinking` entirely: always on; explicit `{type: "disabled"}` returns 400. `display: "summarized"` if you show reasoning summaries.
- `output_config: {effort: "high"}` default; xhigh only capability-critical; lower effort often exceeds prior models' xhigh.
- Stream long turns; `max_tokens` large at high+ effort (it hard-caps thinking + text together).
- Refusal fallback by default: `fallbacks: [{"model": "claude-opus-4-8"}]` with beta header `server-side-fallback-2026-06-01`. Without it a refusal just stops the request. Check `stop_reason` before reading content.
- No prefill, no non-default temperature/top_p/top_k. Min cacheable prefix 512 tokens.

## Agent SDK shortcut

`systemPrompt: {type: "preset", preset: "claude_code"}` gets Claude Code's full prompt (then the snippets are covered, same as Claude Code main); use `append` for additions. CLAUDE.md loading is separate (`settingSources`). Without the preset, assemble from the snippet set above.

## Claude Code subagent bodies

Minimum viable set in the agent .md body: autonomy + grounded progress + no-tidying + the task's verification means, plus a `model:` pin for cost routing (see tokens.md). Custom subagents also read CLAUDE.md (except Explore and Plan), so project facts arrive free; behavioral snippets do not.
