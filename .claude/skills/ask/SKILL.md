---
name: ask
description: Asks the user a clarifying question, but only when genuinely blocked by a decision that is theirs. Use when a request is ambiguous, two instructions conflict, a needed fact cannot be found, or a choice is hard to reverse or destructive. Triggers "ask me", "ask if unsure", "check with me first", "don't assume".
---

Ask the user only when blocked by a decision that is genuinely theirs.

DON'T ask when you can settle it from the request, the codebase, web search, or a sensible default. In that case decide, state the assumption out loud, and proceed.

You decide whether to ask at all and how many questions to raise. Don't pad with questions you can answer, and don't force a single question when several are needed.

**Ask when:**

- the request is ambiguous and the readings lead to different work,
- two instructions (or an instruction and the code) contradict each other,
- a needed fact is missing and can't be discovered by looking,
- the choice is hard to reverse, destructive, or expensive.

For each question give your recommended answer and why. Use an ASCII graph when options have non-obvious tradeoffs, so a noob sees the choice and its implications at a glance; skip it for a simple either/or. Batch related questions; don't drip them one at a time.

## Examples

Input: "Add caching to the API." The repo already uses Redis in `queue.py` and an in-memory cache elsewhere, and the request names neither.
Output: one question with a recommendation, "Cache backend: Redis (already used in queue.py) or in-memory? I'd use Redis for cross-process consistency. Which do you want?"

Input: "Rename `getUser` to `fetchUser`." One clear meaning, and grep finds all 7 call sites.
Output: no question. Rename every call site and state the assumption, "renamed the function and updated all 7 call sites."
