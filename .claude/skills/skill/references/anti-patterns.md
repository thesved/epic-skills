# Anti-patterns and fixes

Named failure modes in skills, each with the fix. `validate.py` catches the mechanical ones; the rest are judgment.

| Anti-pattern | Why it hurts | Fix |
| --- | --- | --- |
| Vague description ("helps with files") | Will not trigger; Claude cannot tell when to use it | Rewrite with what + when + real trigger terms (`triggering.md`) |
| First/second person description | Injected into the system prompt; wrong point of view hurts discovery | Third person: "Generates X" not "I help with X" |
| Bloat: phases, golden rules, long preamble for a simple task | Wastes context every turn; buries the actual instruction | Cut to the minimum that produces the example. Default to one file |
| Re-explaining what Claude knows | Pure token cost | Delete it. Assume Claude is smart |
| Repetition / scattered logic | The same idea stated in three places drifts out of sync | State each idea once, group related logic |
| No examples | Instructions alone give inconsistent output | Add a real Input to Output pair (the examples gate) |
| ALL-CAPS MUST / NEVER everywhere | Reads as nagging, no understanding | Explain WHY once; the model follows reasons better than shouts |
| Offering many options ("use X or Y or Z") | Decision paralysis | Give one default plus an escape hatch |
| Deeply nested references | Claude partial-reads and misses content | Keep references one level deep from SKILL.md |
| Hardcoded absolute paths | Breaks at other install locations | Use `${CLAUDE_SKILL_DIR}` and forward slashes |
| Time-sensitive info ("before August, use ...") | Goes stale and wrong | State the current way; put old ways in a collapsed "old patterns" note |
| Em dashes | House rule; reads as AI slop | Use commas, parentheses, colons |
| Over-broad `allowed-tools` | Grants tools the skill never uses | Grant only what it calls |
| Paragraphs for a workflow | Ordered actions buried in prose get skipped; the model will not reliably run a sequence it must parse out of a paragraph | Numbered steps, each a verb-first atomic action, with an explicit Gate or stop-condition where one applies |
| Aspirational rule for must-hold behavior | "Make it visual", "be thorough", "actually look" read fine and change nothing; the model satisfies them cosmetically | Named ban plus falsifiable test plus a concrete negative example (the Binding dimension in `rubric.md`) |

## Before/after: the bloat cut

The single most common failure is a meta-thorough skill for a small task. Cut it.

Before (47 lines for a commit-message skill): a "Philosophy" section, 6 "golden rules", a 4-phase workflow, and an anti-patterns appendix, none of which the task needs.

After (the whole skill):
```
---
name: commit-msg
description: Writes a conventional-commit message from the staged diff. Use when the user asks for a commit message or to commit staged changes.
---

Read the staged diff with `git diff --cached`. Write one conventional-commit line, `type(scope): summary`, then a short body if the change is non-trivial.

## Examples
Input: staged diff adding JWT login endpoint and token middleware
Output:
feat(auth): add JWT login endpoint and token validation
```

Same behavior, a tenth of the size, and it actually triggers.
