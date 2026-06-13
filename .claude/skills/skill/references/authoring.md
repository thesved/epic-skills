# BUILD engine: how to write a crisp skill

Used by `new` (empty prior) and `change` (existing prior). Same engine, same quality bar; only the starting point differs.

## Contents
- Triage first
- Example first
- Write the minimum
- Earn complexity
- Degrees of freedom
- Finish

## Triage first

Not every request should be a skill. Stop and recommend the lighter option when:
- it is one fact or rule, which belongs in `CLAUDE.md`,
- it is a one-off with no reuse,
- there is no identifiable intent to trigger on (then it can only be a manual `/command`, so set `disable-model-invocation: true`).

A skill-creator that sometimes says "do not make a skill" is more trustworthy than one that always ships one.

## Example first

Get one real input and the exact expected output before writing any instructions. The example defines the output shape that every instruction then serves. If the user cannot produce one real example, the skill is premature; say so and stop.

The example is also a gate: the finished skill must contain an `## Examples` block with at least one real Input to Output pair, drawn from this interview. No placeholders (`foo`, `example.com`, `<your text>`). Synthetic examples are allowed only if labelled and based on the real shape.

## Write the minimum

Write the smallest body that reliably produces the example output. Then stop. The model's instinct is to pad a skill with phases, golden rules, and reference files because those look thorough; resist it. The skill you are writing is almost always simpler than the `skill` skill itself.

Default output: a single `SKILL.md`, a short body, one example, zero reference files, zero scripts.

## Earn complexity

Add structure only against a concrete need, and say why in one line:
- a reference file: only when detail is large and not always needed, and only one level deep.
- a script: only when work is deterministic, repetitive, or fragile (then it is more reliable and saves tokens). Scripts solve rather than punt, name their constants, use forward-slash paths.
- a phase/checklist section: only for genuinely multi-step fragile workflows.

If a generated skill exceeds roughly 150 lines or adds more than one reference file, justify each excess explicitly.

## Degrees of freedom

Match precision to fragility. Prose steps when many approaches are valid and context decides. Exact scripts with "run this, do not modify" when the operation is fragile and must be consistent. Do not over-constrain an open task or under-constrain a fragile one.

Write standing instructions, not one-time narration: a skill body stays in context across turns, so phrase rules as things that always apply.

## Finish

Write the description with `codex-bridge` (see `triggering.md`). Run `scripts/validate.py`. Run the trigger-query check. For `change`, run it before and after and confirm the trigger match did not drop (regression safety), and if nothing improves, say "nothing to do". Show the result, the changed paths, and the validation outcome.
