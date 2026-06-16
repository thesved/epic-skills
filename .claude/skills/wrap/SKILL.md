---
name: wrap
description: Cleanly close out the session so a brand-new one can resume cold - flush todos, consolidate the resume doc, capture durable learnings, resolve ambiguity, prune bloat. Use at the end of a work session, or on "wrap", "wrap up", "close the session", "sign off", "clean close".
---

Close the session so a cold-start agent resumes with zero context loss.

**Two doc targets, different rules. Keep them separate:**
- **CLAUDE.md** (+ resume doc): only the most important, still-true facts, in caveman-terse format (drop articles/filler, tech terms exact). Frontloaded, grouped, scannable. Links to the learnings index.
- **Learnings index** (the project's designated lessons doc, e.g. `LEARNINGS.md`): durable-lessons store. Keep current. CLAUDE.md must link to it.

## Steps
1. **Flush.** Land every open todo, decision, and loose end into the resume doc(s) - nothing important lives only in this chat.
2. **Resume test.** Could a brand-new session continue from the docs alone? Fix every gap. Resolve open ambiguities now; if one can't be resolved, name it and what would settle it.
3. **Learn.** Fold durable, reusable lessons into the learnings index, never into CLAUDE.md. Real signal only; never edit for edit's sake.
4. **Prune.** Cut stale, duplicate, or bloated instructions before they cause context implosion - docs should shrink as often as they grow.
5. **Frontload + group.** Group related info; lead each section AND each line with the key noun/status/action; most important first, top-to-bottom.

## CLAUDE.md gate (run before finishing)
- **Ban: no war stories in CLAUDE.md.** A war story = session narrative, chronology, or debugging play-by-play: past-tense events ("tried X, it failed, then Y"), "we discovered", "spent the afternoon", dates-of-what-happened.
- **Test:** every CLAUDE.md line must be a standing fact or rule still true for the NEXT session, in caveman-terse form. If a line only makes sense as "what happened this session", it FAILS - move the durable takeaway to the learnings index, delete the narrative from CLAUDE.md.
- **Link test:** CLAUDE.md links to the learnings index. Missing -> add it.

Negative example:
- BAD (war story in CLAUDE.md): "Spent the afternoon chasing a flaky auth test; turned out the token clock was 5s skewed, fixed by widening tolerance."
- GOOD (CLAUDE.md, terse fact): "Auth tests: clock-skew tolerance = 5s (flaky below). See [LEARNINGS](LEARNINGS.md)."

End state: lean, grouped, frontloaded CLAUDE.md a stranger acts on cold; war stories and depth in the learnings index, linked.

## Examples
Input: end of a session that fixed a flaky auth test by widening clock-skew tolerance to 5s; CLAUDE.md had grown a paragraph narrating the debugging.
Output:
- CLAUDE.md gate flags the narrative paragraph as a war story; delete it.
- CLAUDE.md keeps one terse line: "Auth tests: clock-skew tolerance = 5s. See [LEARNINGS](LEARNINGS.md)."
- LEARNINGS.md gains the full lesson (symptom, root cause = 5s token clock skew, fix, why 5s).
- Confirm CLAUDE.md links to LEARNINGS.md; add the link if absent.
