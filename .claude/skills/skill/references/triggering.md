# Triggering: descriptions, trigger queries, collisions

The `description` is the only thing Claude sees when deciding to auto-load a skill. Most "my skill does not work" problems are triggering problems, not body problems.

## Contents
- Writing a description
- Trigger-query design
- Collision check
- Doctor checklist

## Writing a description

Draft descriptions and other prompt-heavy text with `codex-bridge` (stronger prompt engineer), then sanity-check with the board. Do not hand-write them solo.

A good description:
- Is third person. "Generates commit messages" not "I can help you" or "You can use this".
- States what it does AND when to use it, with the concrete terms a user would actually type.
- Front-loads the main use case (the listing truncates at 1536 chars combined with `when_to_use`).
- Is slightly pushy, because Claude under-triggers skills. Add "Use whenever the user ..." with real trigger phrases.
- Stays under 1024 chars and avoids vague verbs ("helps with", "does stuff").

Good: `Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDFs or when the user mentions forms or document extraction.`

## Trigger-query design

Before claiming a description works, test it. Write 10 queries:
- 5 SHOULD trigger: different phrasings, formal and casual, cases where the user does not name the skill but clearly needs it. Make them concrete and detailed (real file paths, real context), not "format this data".
- 5 SHOULD NOT trigger: near misses in adjacent domains that share keywords but need different tools. Not obviously irrelevant ones; the near misses are what catch over-triggering.

Judge fire/no-fire for each against the description and report the matrix. Fix the description toward the failures, then re-judge. Note: simple one-step tasks may not trigger any skill because Claude just does them; that is expected, not a failure.

## Collision check

A new skill competes with every sibling skill for the same trigger phrases. Load the descriptions of the other installed skills, find ones whose triggers overlap, and report the competition. Differentiate the descriptions so each owns a distinct intent. Collision is a top real-world reason a good skill never fires.

## Doctor checklist (why a skill will not auto-fire)

Check in this order and stop at the first hit:
1. `disable-model-invocation: true` is set. Then it can NEVER auto-fire by design; this is usually the whole answer.
2. `user-invocable: false` plus a user trying to type `/name`: it is Claude-only.
3. Description is vague, first person, or missing the user's actual trigger terms.
4. The combined description + `when_to_use` exceeds 1536 chars and is being truncated past the key terms.
5. A sibling skill collides and wins the trigger.

Propose corrected frontmatter. Do not rewrite the body unless asked.
