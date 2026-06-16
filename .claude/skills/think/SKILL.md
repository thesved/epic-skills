---
name: think
description: >-
  Escalate hard thinking to Opus - planning, reviewing risky changes, or
  when stuck. Triggers: "think", "think harder", "second opinion", "stuck",
  "are you sure".
argument-hint: plan <task> | review <path|pr> | debug <symptom> | decide <question>
---

Think carefully for yourself, ultrathink, from first principles. We aim for Apple-level delight, think through the option tree carefully and meticulously, so NO hacking please.

Get help: instruct your helpers to use as many websearch as they need

- Invoke `Opus` subagent as many times as needed:
  - most senior model
  - best architect and at spotting subtle details and connections
- Use `/board` skill and ask for help from other agents

## debug mode - Iron Law

**NO FIX WITHOUT ROOT CAUSE FIRST.** Symptom-patching = whack-a-mole; every non-root fix makes the next bug harder to find. Four phases:

1. **Investigate** - read errors fully, find what changed (regression => root cause is in the diff), reproduce deterministically before any hypothesis.
2. **Analyze** - trace to the actual cause, not the surface.
3. **Hypothesize** - state the root cause + why the fix addresses it.
4. **Implement** - fix the cause, add a regression test.

Recurring bugs in the same area = architectural smell; fix structurally.

## review mode - trust-boundary bug classes

Hunt the bugs that pass CI then blow up in prod. Per finding: P-level + confidence + `file:line` + one-line cause.

- **SQL & data safety** - injection via string interpolation, missing parameterization.
- **LLM-output trust boundary** - model output used as code/SQL/shell/HTML without validation.
- **Conditional side effects** - effects that fire (or skip) only on one branch.
- **Race conditions & concurrency** - shared-state transitions, check-then-act, unguarded async.
- **Shell injection** - unescaped input into commands.
- **Enum & value completeness** - new enum/status/tier value not handled everywhere. REQUIRES reading code OUTSIDE the diff: grep sibling values, read those files.
- **N+1 queries, resource leaks, swallowed errors.**
