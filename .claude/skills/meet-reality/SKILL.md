---
name: meet-reality
description: >
  Empirical work loop. Bans ivory-tower research: touch reality first,
  deduce, research only named gaps, forward test on fresh case, loop until
  reality stops correcting you. Unfamiliar domain: optional grounding
  research pass first (/deep-research), all output tagged untested theory,
  reality still decides. Learnings kept on a level ladder from highest
  meta to minute specifics; only the ends are fixed, the levels between
  are drafted per domain and the ladder itself revises as reality
  teaches. Use when researching a topic, designing
  workflows / tools / skills / recipes, or drawing conclusions from data.
  Triggers: "meet reality", "reality check", "reality first", "don't
  research blindly", /meet-reality.
argument-hint: "<what to figure out>"
---

One idea: reality is the teacher, research is the tutor you call with a specific question. Never conclude from reading alone.

```
[L0 GROUNDING, optional, all READ]
      │
TOUCH REALITY -> DEDUCE -> gap? RESEARCH the gap -> FORWARD TEST -> UPDATE DRAFT -> LOOP
      ▲                                                                       │
      └──────────── until 2 fresh touches in a row change nothing ────────────┘
```

## What counts as reality

Inspectable NOW: run the code, open real examples (real forms, real repos, real sessions, real listings), real data / logs / analytics, drive the live page (/chrome), time yourself doing the task, build a tiny probe.

NOT reality: docs, blog posts, papers, benchmarks, model prior, "best practice". Those = research. Research explains what reality showed. Never substitutes.

(Evidence, strongest first: real measurement > live simulation > benchmark/prior > reasoned hypothesis. Top 2 = reality. Rest = research. Same ladder as godview skill.)

## Rules (binding)

1. **Reality first.** First action touches a real artifact, OR runs the L0 grounding pass if its gate passes (see below). Zero artifacts reachable -> build tiny probe or ask user for one. "Let me research the landscape first" without the L0 gate = banned opening. Research INSTEAD of touching = always banned.
2. **Research needs a ticket.** Only against a named question reality raised. Log it: `reality showed X -> researching Y`. Two research batches with no reality touch between = violation. Stop, touch reality.
3. **Tag every conclusion:** SEEN (observed directly) / TESTED (forward-tested) / READ (research only) / GUESS. READ and GUESS = provisional. Test them or ship them labeled.
4. **Forward test on FRESH case.** Apply conclusion to a real case NOT used to derive it. Derivation case can't be test case. Population fully enumerated (census task)? Fresh = out-of-population case with prediction logged BEFORE running it; predict -> run -> compare.
5. **Living draft.** Deliverable (conclusions / workflow / tool / skill) updates every loop, not written once at the end. Draft wrong early beats draft late.
6. **Learn at every altitude.** Draft carries a level ladder. Only the two ends are fixed: top = highest meta (why this at all, what counts as reality here, success criteria), bottom = minute specifics. Levels between, their names, count, order = drafted by YOU for THIS domain on first iteration. Ladder is itself draft: any iteration may add / split / merge / rename / reorder levels, logged like any other learning. Every loop line tags moved levels by their ladder names (`[-]` = none). Bans: (a) importing a stock ladder (frame/method/fact, strategy/tactics, or any preset) instead of deriving one from the domain; (b) bottom-feeding = only lowest level moves 5 iterations in a row -> forced climb: re-test every higher level AND the ladder itself, log verdict even if `held`.
7. **Exit.** Converged = two consecutive fresh reality touches change nothing at ANY level, ladder included. Exit log carries a ladder verdict: `held` or `changed: <what>`. Budget hit early -> ship, mark untested parts READ/GUESS.

## L0 grounding pass (optional opening)

Blank map -> figuring everything out from zero wastes touches on dead ends. One upfront research pass buys orientation. But it buys THEORY, not findings: it grounds the loop, it never replaces it.

Gate (need at least one, else skip straight to reality; skip is logged: `L0: skipped, gate not met (<why>)`):
- Can't name 3 real artifacts to touch, or don't know what "reality" even is for this domain.
- First touches are expensive or irreversible (money, prod, long runs), wrong probe burns real budget.
- User asked for research / deep-research upfront.

Rules:
1. **One batch.** Quick search or /deep-research, sized to the task. Output = map of where reality lives + candidate hypotheses H1..Hn. EVERY item tagged READ (untested theory, not yet verified by reality).
2. **Log it:** `L0 grounding: <sources> -> H1..Hn (all READ, untested)`. No L0 line in the loop log = grounding claims don't exist.
3. **Next action = reality touch.** L0 -> more research = violation (ivory tower with extra steps). Rule 2 still applies after L0: later research needs a reality-raised ticket.
4. **Every H gets a verdict.** By exit each grounding hypothesis is CONFIRMED (promoted to SEEN/TESTED), KILLED (reality contradicted it), or shipped labeled UNTESTED. An H that silently became a conclusion = overfitting on research, the exact thing this skill bans.
5. **Reality outranks grounding.** Conflict between an H and a touch -> touch wins, no "but the research said".

## Batch mode (5000 items? process 1)

Rules / prompts / tools / workflow = soft artifacts, never specs written upfront. Reality hardens them.

1. Pilot item 1 with draft artifacts. Bad or surprising result -> amend artifacts, re-run same item until happy.
2. Next item. EVERY item allowed to rewrite artifacts (rule, prompt, tool, workflow itself).
3. Artifacts unchanged K items in a row -> hardened. K scales with N (10 items -> K=2, 5000 -> K~10).
4. Bulk-run the rest with hardened artifacts. Spot-check random sample of output.
5. Any spot-check surprise reopens loop: amend, re-run affected slice. Ship = artifacts + output, both reality-anchored.

## Falsifiable test

Output carries loop log: numbered iterations, each = reality touched + what changed + which ladder levels moved. No loop log = skill not run.

## Examples

Input: "figure out what makes typeform openers convert" (real task from typeform skill work)
Output = conclusions + this loop log:

<!-- skill-lint: ignore placeholder-example -->
```
L0 grounding: /deep-research form openers -> H1 yes/no hook, H2 progress bar lifts completion (all READ, untested)
L1 opened real forms 1-5 -> ladder for this domain: audience-psych / form-strategy / opener-pattern / wording. H1 confirmed: all open w/ yes/no hook (SEEN) [opener-pattern]; H2 KILLED, 3/5 top forms have no bar (SEEN) [form-strategy]
L2 drop-off data contradicts L1 on mobile -> ladder changed: wording split into desktop-wording / mobile-wording; ticket: research mobile linebreaks (READ)
L3 tested rule on form 6 (fresh) -> held, reworded (TESTED) [desktop-wording]
L4 form 7 -> no change [-]. L5 form 8 -> no change [-]. Ladder verdict: held (post-L2 shape). CONVERGED, no level moved 2x.
```

Not: 2h websearch -> 10-page synthesis -> recommendations, real thing never opened.
Yes: open 5 real X -> pattern -> 10 min research on the one gap -> rule -> test on fresh X -> revise -> converge.
