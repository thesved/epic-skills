VERDICT: Pairwise best vs seed lost (2-3-1); det_pass best 3/6, seed 1/6; best does not beat seed.

# Sealed result

| Comparison | Wins | Losses | Undecided | Det pass |
|---|---:|---:|---:|---:|
| Best vs seed | 2 | 3 | 1 | 3/6 |
| Seed reference |  |  |  | 1/6 |

| Sealed input | Winner | Best det | Seed det | Loser fault |
|---|---|:---:|:---:|---|
| 20.md | best | fail | fail | opus: B repeats the same facts (token efficiency, Qwen's vision/262k/Apache) in both table and prose while dropping GLM 5.3's lack of native vision, so it is longer yet less complete, and its prose paragraphs lead with the model name rather than the point. \| gemini: Bloated repetition between the summary table and the surrounding body paragraphs. |
| 08.md | best | fail | fail | opus: Horizontal front-loading fails , most lines open with the repeated subject "DeepSeek V4 Pro is/has/varies…", so the first five words carry no message, and the ASCII diagram just repeats the pinned-provider sentence that follows it. \| gemini: Repeated "DeepSeek V4 Pro" at the start of most paragraphs, ruining horizontal front-loading and scannability. |
| 09.md | undecided | pass | fail | panel-disagree |
| 01.md | seed | fail | fail | opus: Prose paragraphs bury key facts mid-line and drop the docs claim that low-effort Fable 5 often beats `xhigh` on prior models; no scannable first-words path. \| gemini: Presentation A dropped key source facts including 1M flat pricing and low-effort benchmark claims. |
| 04.md | seed | pass | fail | opus: Every bullet opens with the same bolded label, so scanning first words yields "Anthropic Message Batches…" six times instead of each line's actual point , and no line ever says what a batch *is*. \| gemini: Repeated identical bullet headers prevented horizontal front-loading, failing the first-five-words scan test. |
| 21.md | seed | pass | pass | opus: A saves the authoritative Anthropic quote for its last line instead of front-loading it, and never states the source's point that the same effort label means different computation across models. \| gemini: Included awkward meta-commentary explaining what was missing from the supplied source text. |

# Epochs

| Epoch | Train det | Selection current det | Candidate det | W | L | U | Accepted | Calls T/P/J | Seconds |
|---:|---:|---:|---:|---:|---:|---:|:---:|---:|---:|
| 1 | 7/12 | 3/6 | 5/6 | 3 | 0 | 3 | yes | 18/1/12 | 286.26 |
| 2 | 11/12 | 5/6 | 6/6 | 0 | 4 | 2 | no | 18/1/12 | 245.19 |
| 3 | 11/12 | 5/6 | 5/6 | 3 | 1 | 2 | no | 6/1/12 | 175.63 |
| 4 | 11/12 | 5/6 | 6/6 | 0 | 4 | 2 | no | 6/1/12 | 208.94 |

# Accepted diffs

## Epoch 1

```diff
--- sop_v0.md
+++ sop_v1.md
@@ -5,7 +5,9 @@
 Pair what a thing is called with what it means from first principles, in the same sentence or the next one.
 Give a short concrete example for every hard or abstract idea, and two or three diverse examples for the ideas that matter most. Prefer examples from the source; an invented example is fine when marked as illustrative ("for example, say ...") and its mechanism is right.
 Keep source facts exact: numbers, names, dates, claims stay as the source states them. Never present an invented detail as a source fact.
-Terse: drop articles, fillers, pleasantries, repetition; keep technical terms exact.
+Copy every source-attributed number exactly as written, including units, precision, and abbreviations. Do not convert, expand, calculate, combine, or infer a number unless the source states that result; if a calculation is essential, mark it as illustrative.
+Use only evidence needed to support the opening conclusion and teach its hard ideas. Remove repeated facts, source-summary inventory, decorative headings, and examples that do not add a distinct mechanism or situation; keep technical terms exact.
 No em dash or en dash. Commas, colons, parentheses instead.
 Short paragraphs: at most three sentences each. Prefer bullets and small tables over prose.
+Choose one compact structure, prose, bullets, or a small table, unless a second structure adds new information. Do not restate prose in a table or sketch.
 Draw an ASCII sketch when a flow, dependency, or structure is clearer drawn than described.
```


# Rejected operations

| Epoch | Reason | Operations |
|---:|---|---|
| 2 | selection acceptance rule failed | `[{"op": "replace", "anchor": "Keep source facts exact: numbers, names, dates, claims stay as the source states them. Never present an invented detail as a source fact.", "text": "Keep source facts exact: preserve every attributed number, unit, precision, abbreviation, name, date, and claim unchanged. Do not convert, calculate, combine, or infer source facts; mark essential calculations and invented details as illustrative."}, {"op": "delete", "anchor": "Copy every source-attributed number exactly as written, including units, precision, and abbreviations. Do not convert, expand, calculate, combine, or infer a number unless the source states that result; if a calculation is essential, mark it as illustrative.", "text": ""}, {"op": "replace", "anchor": "Use only evidence needed to support the opening conclusion and teach its hard ideas. Remove repeated facts, source-summary inventory, decorative headings, and examples that do not add a distinct mechanism or situation; keep technical terms exact.", "text": "Keep only evidence that changes, supports, or explains the opening conclusion. Delete secondary specifications, source inventory, repeated support, decorative headings, and any example that adds no distinct mechanism or situation; keep necessary technical terms exact."}]` |
| 3 | selection acceptance rule failed | `[{"op": "replace", "anchor": "Use only evidence needed to support the opening conclusion and teach its hard ideas. Remove repeated facts, source-summary inventory, decorative headings, and examples that do not add a distinct mechanism or situation; keep technical terms exact.", "text": "Keep the smallest sufficient case for the opening conclusion: the decisive evidence, plain meanings for necessary technical terms, and required teaching examples. Delete secondary specifications, exhaustive source inventory, repeated support, caveats that do not change the decision, and examples that add no distinct mechanism or situation."}, {"op": "insert_after", "anchor": "Choose one compact structure, prose, bullets, or a small table, unless a second structure adds new information. Do not restate prose in a table or sketch.", "text": "Stop when the conclusion is proved and its hard ideas are understandable. Keep a sentence only if removing it would weaken the conclusion, evidence, meaning, or required examples."}]` |
| 4 | selection acceptance rule failed | `[{"op": "replace", "anchor": "Give a short concrete example for every hard or abstract idea, and two or three diverse examples for the ideas that matter most. Prefer examples from the source; an invented example is fine when marked as illustrative (\"for example, say ...\") and its mechanism is right.", "text": "Give one short concrete example for each hard idea the conclusion depends on. Add a second or third only when it teaches a distinct situation needed to understand that idea. Prefer source examples; mark invented ones as illustrative (\"for example, say ...\") and keep their mechanism right."}, {"op": "replace", "anchor": "Use only evidence needed to support the opening conclusion and teach its hard ideas. Remove repeated facts, source-summary inventory, decorative headings, and examples that do not add a distinct mechanism or situation; keep technical terms exact.", "text": "Build the smallest sufficient case for the opening conclusion. Keep only decisive evidence, meanings needed to understand it, and examples that teach distinct situations. Cut secondary specifications, exhaustive source inventory, repeated support, decorative headings, and caveats that do not change the conclusion; keep necessary technical terms exact."}, {"op": "insert_after", "anchor": "Short paragraphs: at most three sentences each. Prefer bullets and small tables over prose.", "text": "Keep each bullet to one main claim and its direct support. If a bullet accumulates unrelated strengths, complaints, specifications, or anecdotes, retain only those necessary to prove or explain its opening claim."}]` |

# Totals

Target calls: 66
Proposer calls: 4
Judge calls: 60
Wall time: 1143.59 seconds
