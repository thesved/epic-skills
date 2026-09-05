---
name: think
description: >-
  Escalate hard thinking up a ladder (fresh Opus/Sonnet seat, then a Fable subagent or GPT-6 Astra via codex-runner, then /board) - planning, reviewing risky changes, or
  when stuck. Triggers: "think", "think harder", "second opinion", "stuck",
  "are you sure".
argument-hint: plan <task> | review <path|pr> | debug <symptom> | decide <question>
---

Think carefully for yourself, ultrathink, from first principles. We aim for Apple-level delight, think through the option tree carefully and meticulously, so NO hacking please.

Get help, cheap first, then climb (instruct helpers to use as many web searches as they need):

1. Fresh eyes on a cheap seat: an Opus or Sonnet subagent with a clean context and only the facts. Fresh context catches as much as a smarter model does.
2. Tricky, ambiguous, cross-cutting, or the cheap seat disagrees with you: `Agent(model: "fable")` (shares the 50% weekly Fable cap) or GPT-6 Astra through a `codex-runner` agent (`-m gpt-6-astra`, burns the ChatGPT Pro allowance fast). Both are fine when slowing down is faster; meter them.
3. Cross-family, bias-free second eye, or an irreversible decision: `/board`.

Examples of what earns step 2 (our taste, not an exhaustive list): planning a graph of work, a second check on something important, brainstorming a way out, being stuck, confirming or refuting a diagnosis, a fresh-eyes plan check, a taste verdict, experiment or eval design. Verification sandwiches (before/after checks) start at step 1 and climb only when the cheap seat cannot settle it.

Sub-covered families stay native: Claude models as Claude subagents, OpenAI models through the codex CLI, never via OpenRouter unless the user approved it in this session.

## debug mode, Iron Law

**NO FIX WITHOUT ROOT CAUSE FIRST.** Symptom-patching = whack-a-mole; every non-root fix makes the next bug harder to find. Four phases:

1. **Investigate**: read errors fully, find what changed (regression => root cause is in the diff), reproduce deterministically before any hypothesis.
2. **Analyze**: trace to the actual cause, not the surface.
3. **Hypothesize**: state the root cause + why the fix addresses it.
4. **Implement**: fix the cause, add a regression test.

Recurring bugs in the same area = architectural smell; fix structurally.

## review mode, trust-boundary bug classes

Hunt the bugs that pass CI then blow up in prod. Per finding: P-level + confidence + `file:line` + one-line cause.

- **SQL & data safety**: injection via string interpolation, missing parameterization.
- **LLM-output trust boundary**: model output used as code/SQL/shell/HTML without validation.
- **Conditional side effects**: effects that fire (or skip) only on one branch.
- **Race conditions & concurrency**: shared-state transitions, check-then-act, unguarded async.
- **Shell injection**: unescaped input into commands.
- **Enum & value completeness**: new enum/status/tier value not handled everywhere. REQUIRES reading code OUTSIDE the diff: grep sibling values, read those files.
- **N+1 queries, resource leaks, swallowed errors.**
