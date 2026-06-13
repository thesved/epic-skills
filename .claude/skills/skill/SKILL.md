---
name: skill
description: Creates, changes, reviews, and doctors Claude Code skills. Use this whenever the user asks to make a new skill, modify an existing skill, audit a skill, improve triggering, write a SKILL.md, add examples, validate frontmatter, fix bloat, or diagnose why a skill does not auto-trigger. It is intentionally pushy for skill authoring and maintenance work because skill requests are easy to under-trigger.
argument-hint: new <idea> | change <name> | review <name> | doctor <name>
---

# Skill

Build and assess Claude Code skills with minimal structure, real examples, and reliable triggering.

A skill is a directory with `SKILL.md`. The frontmatter `name` and `description` are preloaded; the body loads only when the skill triggers; bundled `references/`, `scripts/`, `assets/` files load only on demand. The `description` is the only auto-trigger surface, so treat it as first-class.

## Start here

Pick the verb from the request. Read only the references a verb names; do not load them all.

| Verb | Engine | Use |
| --- | --- | --- |
| `new <idea>` | BUILD | Create a skill from scratch |
| `change <name>` | ASSESS then BUILD | Improve an existing skill |
| `review <name>` | ASSESS | Read-only audit |
| `doctor <name>` | ASSESS (triggering lens) | Diagnose why it will not auto-fire |

- `references/spec.md`: frontmatter fields, limits, structure rules (the ground truth)
- `references/authoring.md`: the BUILD engine
- `references/rubric.md`: the ASSESS engine (two gates, then findings)
- `references/triggering.md`: description writing, trigger-query design, collision check
- `references/anti-patterns.md`: named anti-patterns, fixes, a before/after bloat cut
- `scripts/validate.py`: deterministic linter (run it, do not re-derive its checks)
- `scripts/scaffold.sh`: create a new skill directory from `assets/SKILL.template.md`

## Standing rules (apply to every verb)

- **Default to the simplest skill that works.** Most skills are one `SKILL.md`, a short body, one real example, no references, no scripts. Earn every reference file, script, or phase section by answering "does the target task need this?". The skill you write is almost always simpler than this one; do not mirror this structure.
- **Examples are a gate, not a suggestion.** Every skill you create or change must carry an `## Examples` block with at least one real Input to Output pair taken from the interview. Never use placeholders like `foo` or `example.com`.
- **No em dashes** in any skill you write or edit. Use commas, parentheses, or colons.
- **Draft prompt-heavy text with codex-bridge, sanity-check with the board.** Descriptions and trigger phrasing decide whether a skill ever fires, so do not hand-write them solo. See `references/triggering.md`.
- **Findings quote the offending line and name the fix.** Never emit a bare score or vague note.
- Hard limits live in `references/spec.md`. Validate with `scripts/validate.py` rather than eyeballing.

## `/skill new <idea>`

BUILD from an empty prior (`references/authoring.md`).

1. **Triage.** Should this even be a skill? If it is one `CLAUDE.md` line, a manual-only command, or a non-reusable one-off, say so and stop.
2. **Get the example first.** Elicit one real input and the exact expected output. It defines the output shape. If the user cannot give one, the skill is premature; say so.
3. **Draft the minimum** `SKILL.md` that produces that output. Default to a single file.
4. **Write the description with codex-bridge** (`references/triggering.md`): pushy, concrete, third person.
5. **Enforce the examples gate** and run `scripts/validate.py` plus the trigger-query check.
6. Show the result and the validation outcome.

## `/skill change <name>`

ASSESS, then BUILD with the existing skill as the prior.

1. Reverse-engineer intent from the current files; interview only the gaps that block a correct edit.
2. Refactor toward clarity: dedupe repeated ideas, regroup related logic, fix spacing and structure, tighten the description, add examples if missing, strip em dashes. Split into `references/` only if the body would exceed 500 lines.
3. Run `scripts/validate.py`, then before/after trigger-query checks so a refactor never lowers the trigger match (regression safety).
4. If it is already optimal, say "nothing to do" and stop. Otherwise show a diff.

## `/skill review <name>`

ASSESS, read-only (`references/rubric.md`). Write no files.

1. **Gate 1, triggering:** the description fires on should-trigger queries and stays quiet on near misses.
2. **Gate 2, output:** the body can produce the expected output from its own example.
3. If either gate fails the skill is **broken**, regardless of polish. Then report findings as `solid` / `weak` / `broken`, each quoting a line and naming the fix.
4. Run the collision check (`references/triggering.md`): load sibling skill descriptions, report trigger-phrase overlap.

## `/skill doctor <name>`

ASSESS with the triggering lens (`references/triggering.md`). Check in order:

1. `disable-model-invocation`: if set, the skill can never auto-fire. This is the first answer.
2. Description quality: what plus when, trigger terms, third person, pushiness.
3. Missing key terms from likely user requests.
4. The 1536-char listing cap on combined description and `when_to_use`.
5. Collisions with sibling skills.

Propose fixed frontmatter. Do not rewrite the whole skill unless asked.

## Examples

Input: "make a skill that turns a Jira ticket URL into a git branch name"
Output: triage (reusable, has clear intent, so yes a skill); ask for one real ticket URL and the exact branch name wanted; draft a single-file SKILL.md whose body is the minimum mapping plus that one example; write the description with codex-bridge; run `scripts/validate.py` and the trigger-query check; report the result.

<!-- skill-lint: ignore placeholder-example -->

