VERDICT: Pairwise best vs seed won (2-1-3); det_pass best 5/6, seed 0/6; best beats seed.

# Sealed result

| Comparison | Wins | Losses | Undecided | Det pass |
|---|---:|---:|---:|---:|
| Best vs seed | 2 | 1 | 3 | 5/6 |
| Seed reference |  |  |  | 0/6 |

| Sealed input | Winner | Best det | Seed det | Loser fault |
|---|---|:---:|:---:|---|
| 20.md | seed | fail | fail | opus: A lists jargon and numbers (744B/40B, ExploitBench, `json_schema`) with no plain meaning and no examples , a fact dump with the verdict for each row buried mid-cell. \| gemini: Leaves technical jargon completely unexplained without plain first-principles meanings for a reader with zero background. |
| 08.md | undecided | pass | fail | panel-disagree |
| 09.md | undecided | pass | fail | position-dependent |
| 01.md | best | pass | fail | opus: B fabricates numbers and examples absent from the source (a "2,000-token limit", "1,000 tokens" becoming "about 1,300", "Classify support tickets") while dropping the source's actual 5x-Sonnet-5/40x-Luna cost comparison and the low-effort-beats-prior-`xhigh` claim. \| gemini: Invented concrete examples and numerical illustrations not present anywhere in the source text. |
| 04.md | undecided | pass | fail | panel-disagree |
| 21.md | best | pass | fail | opus: Fabricated content , B's policy table (its four "Meaning"/"Example" rows, e.g. "Reformat supplied notes", "Design migration with competing constraints", plus "verify current pricing") and the flow diagram invent facts absent from the source, whose table body is empty; it also drops `medium` entirely. \| gemini: Hallucinated task examples in the table and text that do not exist in the source. |

# Epochs

| Epoch | Train det | Selection current det | Candidate det | W | L | U | Accepted | Calls T/P/J | Seconds |
|---:|---:|---:|---:|---:|---:|---:|:---:|---:|---:|
| 1 | 6/12 | 3/6 | 5/6 | 3 | 0 | 3 | yes | 6/1/12 | 173.84 |
| 2 | 9/12 | 5/6 | 6/6 | 3 | 2 | 1 | yes | 18/1/12 | 263.24 |
| 3 | 11/12 | 6/6 | 5/6 | 2 | 3 | 1 | no | 18/1/12 | 232.29 |
| 4 | 11/12 | 6/6 | 4/6 | 1 | 2 | 3 | no | 6/1/12 | 168.58 |

# Accepted diffs

## Epoch 1

```diff
--- sop_v0.md
+++ sop_v1.md
@@ -3,8 +3,9 @@
 Lead with the conclusion in the first line. Then the reason. Then the evidence.
 Front-load every section and every line: a reader scanning top to bottom, or left to right, understands without jumping. No forward references ("see below").
 Pair what a thing is called with what it means from first principles, in the same sentence or the next one.
-Give one short real example for every abstract claim.
-Terse: drop articles, fillers, pleasantries; keep technical terms exact.
+Treat the source as a closed world: preserve its exact names, numbers, dates, comparisons, and scope. Delete any claim or detail that cannot be traced to it.
+Ground each abstract claim with a short example already present in the source. If none exists, use only source-stated names, numbers, or cases to make the claim concrete, never invent a scenario.
+Terse without omission: include each decisive fact once, drop repetition, filler, decorative headings, and low-value restatement; keep technical terms exact.
 No em dash or en dash. Commas, colons, parentheses instead.
 Short paragraphs: at most three sentences each. Prefer bullets and small tables over prose.
 Draw an ASCII sketch when a flow, dependency, or structure is clearer drawn than described.
```

## Epoch 2

```diff
--- sop_v1.md
+++ sop_v2.md
@@ -5,7 +5,7 @@
 Pair what a thing is called with what it means from first principles, in the same sentence or the next one.
 Treat the source as a closed world: preserve its exact names, numbers, dates, comparisons, and scope. Delete any claim or detail that cannot be traced to it.
 Ground each abstract claim with a short example already present in the source. If none exists, use only source-stated names, numbers, or cases to make the claim concrete, never invent a scenario.
-Terse without omission: include each decisive fact once, drop repetition, filler, decorative headings, and low-value restatement; keep technical terms exact.
+Compress without omission: include each decision-changing fact once, keep technical terms exact, and remove repetition, filler, decorative headings, and low-value restatement. Never make the presentation longer than the source passage.
 No em dash or en dash. Commas, colons, parentheses instead.
-Short paragraphs: at most three sentences each. Prefer bullets and small tables over prose.
+Keep every prose paragraph to at most three sentences, including paragraphs before and after bullets or tables. Split or convert longer passages into bullets or a small table, then verify the limit before returning the presentation.
 Draw an ASCII sketch when a flow, dependency, or structure is clearer drawn than described.
```


# Rejected operations

| Epoch | Reason | Operations |
|---:|---|---|
| 3 | selection acceptance rule failed | `[{"op": "replace", "anchor": "Keep every prose paragraph to at most three sentences, including paragraphs before and after bullets or tables. Split or convert longer passages into bullets or a small table, then verify the limit before returning the presentation.", "text": "Keep every prose paragraph to at most three sentences, including text before and after bullets or tables. In a final mechanical pass, count each paragraph\u2019s sentences and insert a paragraph break before any fourth sentence; use bullets or a small table when a break would obscure the structure."}]` |
| 4 | selection acceptance rule failed | `[{"op": "replace", "anchor": "Keep every prose paragraph to at most three sentences, including paragraphs before and after bullets or tables. Split or convert longer passages into bullets or a small table, then verify the limit before returning the presentation.", "text": "Limit each prose paragraph to three sentences. Insert a blank line before every fourth sentence, including in prose before and after bullets or tables. Before returning, revise any paragraph that still exceeds the limit."}]` |

# Totals

Target calls: 54
Proposer calls: 4
Judge calls: 60
Wall time: 1037.37 seconds
