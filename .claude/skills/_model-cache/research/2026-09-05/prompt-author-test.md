# Prompt-author test, 2026-09-05: who should write the executor prompt?

Question (plan step M): the user's tacit claim that OpenAI models write tighter, better-structured executor prompts than the Fable orchestrator. Test before binding.

## Method
- 3 real Fable-authored delegated prompts pulled from session logs (2026-08-23 three.js startup perf brainstorm, 2026-08-26 dishwasher fit research, 2026-08-28 survey-coding harness implementation, 1.6k-8.5k chars each).
- gpt-5.6-sol rewrote each (`codex exec`, medium effort): "concise, well structured, every constraint preserved, nothing added or dropped, output only the prompt".
- Blind judging, labels P1/P2, BOTH presentation orders, two seats: Gemini (gemini-bridge ask.sh) and Opus 5 (Claude subagent). Rubric: clarity for a literal reader + fidelity (name any dropped or added constraint). Length not rewarded.
- Real-run pair on a fresh bounded task (slugkit: 3 failing edge-case tests, stdlib only, one file allowed): A = raw Fable spec through plain `codex exec`, B = the same spec compiled by Sol inside the codex-runner agent, then executed.

## Results
| pair | Gemini o1 | Gemini o2 | Opus o1 | Opus o2 |
|---|---|---|---|---|
| perf brainstorm | Sol | Sol | Sol | Sol |
| dishwasher research | Sol | Sol | Sol | Sol |
| harness implementation | Sol | Sol | Sol | Sol |

12/12 for the Sol rewrite, no position bias (verdict flipped with the order every time). Opus fidelity notes: Sol dropped only rationale prose and framing ("wants the scene to feel instant", "hard-won", a stale-cache rationale sentence), added small disambiguations consistent with the spec (`force=True` bypasses cache, "non-empty quote", a per-category "nothing found" restating a global rule). Nothing numeric, no path, no rule lost.

Real-run pair: A and B both passed 5/5, both touched only `slugkit/__init__.py`, near-identical implementations (word-accumulate vs candidate-string loop). On a small, well-specified task the compile step changed nothing measurable; its value is the clarity margin on long prompts, where the judges found Fable's run-on paragraphs and nested parentheticals the misread risk.

## Verdict (binds delegation.md)
Fable writes the SPEC (goal, acceptance, must-not-touch, verify, permitted initiative). The runner has Sol compile the spec into the executor prompt and checks nothing was dropped (Sol drops rationale; keep the WHY line in the spec if the executor needs it). Fable does not hand-polish executor prompts.

Files: `prompt-author-test/` keeps the perf pair (original, Sol rewrite, both Gemini verdicts). The dishwasher and harness pairs hold personal and business detail and stay out of the repo (session logs and the scratchpad have them). Opus verdicts are in the session transcript only.
