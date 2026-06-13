# ASSESS engine: two gates, then findings

Used by `review` and `doctor`. The point is a verdict that predicts real behavior, not a number. No 0-10 scores; scores invite gaming three cosmetic dimensions to hide one fatal one.

## Step 1: two PASS/FAIL gates

Run these first. If either fails, the skill is **BROKEN**, full stop, and the polish below does not matter.

**Gate 1, triggering.** Generate 5 should-trigger queries and 5 should-not near misses (see `triggering.md`), then judge whether this `description` fires correctly on each. Report the confusion matrix. A skill that will not fire on its own use cases is broken. (Skip for `user-invocable: false` or `disable-model-invocation` skills, and say why.)

**Gate 2, output.** Take the skill's own `## Examples` input and check the body can produce the stated expected output. If there is no example, that is itself a broken gate: the skill cannot be verified.

## Step 2: findings (only if both gates pass)

Rate each dimension `solid` / `weak` / `broken`. Three levels the model can actually tell apart, unlike ten. Every finding MUST quote the offending line and name the concrete fix. A finding without a quote and a fix is theater; drop it.

| Dimension | `solid` looks like |
| --- | --- |
| Conciseness | Body adds only what Claude does not already know. No re-explaining basics, no narration of why. |
| Structure | Related logic grouped; clean heading hierarchy; readable spacing. One idea stated once, not scattered. |
| Examples | At least one real Input to Output pair; no placeholders. |
| Progressive disclosure | Detail that is not always needed lives in references one level deep, not inlined. |
| Degrees of freedom | Prose where many approaches work; scripts where work is fragile or deterministic. |
| Scripts (if any) | Solve rather than punt; named constants; forward-slash paths; clear execute-vs-read intent. |
| Tool scope | `allowed-tools` grants only what the skill uses. |
| House style | No em dashes. No ALL-CAPS MUST without a reason next to it. |

## Output shape

Lead with the gate result (`BROKEN: ...` or `both gates pass`). Then the findings, worst first, each as: `dimension: level - "quoted line" -> fix`. End with the single highest-leverage change. For `review`, never edit files. For `doctor`, see `triggering.md`.
