---
name: meet-reality
description: >
  Empirical work loop. Bans ivory-tower research: touch reality first,
  deduce, research only named gaps, forward test on fresh case, loop until
  reality stops correcting you. Use when researching a topic, designing
  workflows / tools / skills / recipes, or drawing conclusions from data.
  Triggers: "meet reality", "reality check", "reality first", "don't
  research blindly", /meet-reality.
argument-hint: "<what to figure out>"
---

One idea: reality is the teacher, research is the tutor you call with a specific question. Never conclude from reading alone.

```
TOUCH REALITY -> DEDUCE -> gap? RESEARCH the gap -> FORWARD TEST -> UPDATE DRAFT -> LOOP
      ▲                                                                       │
      └──────────── until 2 fresh touches in a row change nothing ────────────┘
```

## What counts as reality

Inspectable NOW: run the code, open real examples (real forms, real repos, real sessions, real listings), real data / logs / analytics, drive the live page (/chrome), time yourself doing the task, build a tiny probe.

NOT reality: docs, blog posts, papers, benchmarks, model prior, "best practice". Those = research. Research explains what reality showed. Never substitutes.

(Evidence, strongest first: real measurement > live simulation > benchmark/prior > reasoned hypothesis. Top 2 = reality. Rest = research. Same ladder as godview skill.)

## Rules (binding)

1. **Reality first.** First action touches a real artifact. Zero artifacts reachable -> build tiny probe or ask user for one. "Let me research the landscape first" = banned opening.
2. **Research needs a ticket.** Only against a named question reality raised. Log it: `reality showed X -> researching Y`. Two research batches with no reality touch between = violation. Stop, touch reality.
3. **Tag every conclusion:** SEEN (observed directly) / TESTED (forward-tested) / READ (research only) / GUESS. READ and GUESS = provisional. Test them or ship them labeled.
4. **Forward test on FRESH case.** Apply conclusion to a real case NOT used to derive it. Derivation case can't be test case.
5. **Living draft.** Deliverable (conclusions / workflow / tool / skill) updates every loop, not written once at the end. Loop may change conclusions AND method AND tools. Draft wrong early beats draft late.
6. **Exit.** Converged = two consecutive fresh reality touches change nothing. Budget hit early -> ship, mark untested parts READ/GUESS.

## Batch mode (5000 items? process 1)

Rules / prompts / tools / workflow = soft artifacts, never specs written upfront. Reality hardens them.

1. Pilot item 1 with draft artifacts. Bad or surprising result -> amend artifacts, re-run same item until happy.
2. Next item. EVERY item allowed to rewrite artifacts (rule, prompt, tool, workflow itself).
3. Artifacts unchanged K items in a row -> hardened. K scales with N (10 items -> K=2, 5000 -> K~10).
4. Bulk-run the rest with hardened artifacts. Spot-check random sample of output.
5. Any spot-check surprise reopens loop: amend, re-run affected slice. Ship = artifacts + output, both reality-anchored.

## Falsifiable test

Output carries loop log: numbered iterations, each = reality touched + what changed. No loop log = skill not run.

```
L1 opened real forms 1-5 -> pattern: all open w/ yes/no hook (SEEN)
L2 drop-off data contradicts L1 on mobile -> ticket: research mobile linebreaks (READ)
L3 tested rule on form 6 (fresh) -> held, reworded (TESTED)
L4 form 7 -> no change. L5 form 8 -> no change. CONVERGED.
```

Not: 2h websearch -> 10-page synthesis -> recommendations, real thing never opened.
Yes: open 5 real X -> pattern -> 10 min research on the one gap -> rule -> test on fresh X -> revise -> converge.
