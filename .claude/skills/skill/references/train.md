# TRAIN engine: optimize a skill (or any workflow text) against evidence, not taste

Evidence base: `research/2026-09-02/report.md` (SkillOpt paper + code, GitHub issues, 65 videos, two live pilots on this machine). Skills and SOPs are text; text can be trained. The tool matters less than the gate: every accepted change must beat the previous version on tasks the optimizer never saw, judged by something other than the model that wrote it.

## Step 0: routing gate (answer before running anything)

```
What is the artifact?
  description / trigger  -> run_loop (Anthropic skill-creator), section A
  skill body or SOP with an EXACT checker and >= 60 tasks -> SkillOpt trainer, section C
  skill body or SOP judged by rubric/taste -> pairwise judge loop, section D (or GEPA)
  "is the skill worth its tokens at all?" -> with/without ablation, section B
Do you have tool parity (the optimizer's replay can run the same commands the live skill runs)?
  no -> fix that first, or the skill learns to NARRATE work (gbrain issue 4119, SkillOpt issue 155)
Is the task repeated often enough to amortize ~300 agent calls per run?
  no -> hand-edit, forward-test, stop
```

Named ban: **the nightly self-editor**. SkillOpt-Sleep (mines `~/.claude` transcripts, proposes edits) stays OFF. Test: `crontab -l | grep -c skillopt` prints 0 and no `--auto-adopt` exists anywhere in the repo. Negative example: our dry-run mined this session's own request as its single task and "accepted" 0.15 to 0.985 on a held-out set of one.

## A. Descriptions: `run_loop.py` (official, gated, on the Claude subscription)

Location: `~/.claude/plugins/marketplaces/claude-plugins-official/plugins/skill-creator/skills/skill-creator/scripts/run_loop.py`. Needs Python 3.10+ (`/opt/homebrew/bin/python3.11`; system 3.9 fails on `str | None`).

1. Write 20 queries: 12 should-trigger (concrete, multi-step, no skill name), 8 near misses owned by sibling skills. Write 10 MORE as a sealed set that the loop never sees, same 6/4 ratio.
2. **Isolate the trigger test from user-level skills; never move a live skill.** The harness installs the candidate as a temporary command `<name>-skill-<hash>` in the nearest `.claude/commands` and only counts a hit on that exact name; the installed original wins every trigger and recall reads 0% for every candidate. `scripts/train_desc.sh` handles it: a PATH shim adds `--setting-sources project` to every `claude -p` (user skills do not load, keychain auth still works, verified 2026-09-02), run from a scratch project whose `.claude/commands` receives the candidate. Named ban: moving or renaming anything under `~/.claude/skills` during a run (a dot-prefixed rename still loads; parallel sessions see the skill vanish).
3. Run:
```bash
bash ~/.claude/skills/skill/scripts/train_desc.sh <skill-dir> eval.json sealed.json <work-dir> sonnet
```
It scores the original on the sealed set, runs `run_loop` (5 iterations, 3 runs per query, 60/40 split), scores the best candidate on the sealed set, and lints for dashes.
4. Lint the winner BEFORE scoring it: no em dash, under 1024 chars (`spec.md`), third person. Lint failure = reject, do not trim and rescore (a trimmed text was never evaluated). The optimizer inserted an em dash on one run and a 1139-char description on another; it does not know the house rules.
5. Accept only if sealed passes rise by 2 or more out of 10; one query is the noise band we measured.

Known ceiling, measured 2026-09-02: headless `claude -p` consults a skill on about 1 run in 3 for a real trigger query, on Sonnet AND Opus, with the correct description installed. Near-miss precision is reliable (near 100%); should-trigger recall is mostly noise at 3 runs per query. Consequences: expect REJECT to be the normal outcome; use this section only when a skill demonstrably under-fires in real sessions; treat the interactive session as the real test and this harness as a regression guard against over-triggering.

`run_loop`'s "test" split is re-scored every iteration and used for selection, so it is a validation set. Only the sealed set is a test. Do not chase recall with pushier prose past the point where near misses start firing.

## B. Is the skill worth it: `claude plugin eval` with/without ablation

Present in Claude Code 2.1.258 (early access). It scores, it never rewrites. Use it as the forward-test standard for behavior-heavy skills:
```bash
claude plugin eval init --bare <case>            # prompt.md + graders/*.md under evals/
claude plugin eval <skill-dir> --ablation with-without --runs 3 --judge-model haiku --max-cost-usd 5 --json results.json
```
Graders: regex, `tool_used`, `file_exists`, llm judge (2-of-3 votes), baseline. The executor never sees the assertions (self-grading inflated skill A/B scores by about 60 points in a 92-eval study). Report the delta AND the token cost; a skill that doubles tokens for a 2-point gain is a cut candidate.

## C. Bodies with an exact checker: SkillOpt trainer on the Codex subscription

Only when: deterministic scorer, >= 60 items split 30 train / 12 selection / 20 sealed test, tool parity, repeated task. Expect no win by default: on our first task two runs (648 calls) accepted selection noise and regressed on the sealed split. Run it to LEARN what the optimizer tries, keep the seed unless the sealed split moves by more than one item's worth of checks. Setup verified 2026-09-02 (Python 3.11 venv, `pip install -e <clone>`, custom `shellscore` adapter registered in `scripts/train.py`, config in `research/2026-09-02/` and the scratch pilot).

Binding config (each line prevents a failure we hit or read):
- `model.backend: codex`, `optimizer_backend: codex_exec`, `target_backend: codex_exec`, `optimizer: gpt-5.6-sol`, `target: gpt-5.6-terra` (sub-billed, no API key).
- `evaluation.gate_metric: soft` (or `mixed`). Default `hard` is 1.0 only on perfect items; on our task no item was ever perfect, so the gate scored every candidate 0.0 and rejected all of them while the run kept spending.
- `optimizer.slow_update_gate_with_selection: true`. Default false: the epoch-end "slow update" injected a 120-word paragraph into the live skill with no gate.
- `codex_exec_network_access: false`, `codex_exec_web_search: false`, `exec_timeout: 180`, `workers: 4`.
- Hermetic config for Claude targets: `claude -p` inherits `~/.claude` hooks and settings; set `CLAUDE_CONFIG_DIR` to a clean dir or the skill learns your hooks (gbrain).
- Cross-family judge for any soft score; the optimizer copies a same-family judge's vocabulary.
- No per-task no-regression gate exists in the trainer at db46cd9 (only in Sleep). Compute per-task deltas from `out_root/steps/*/selection_eval` yourself; reject a candidate that regresses any selection item.
- Read every accepted diff and classify it RULE or VOCABULARY-COPY. Vocabulary copies (scorer keywords, mandatory headings, fake paths) are gaming; gbrain's humans rejected 50 to 100 percent of accepted edits for this.
- Stop bound: 4 epochs, then decide; budget in calls (about `4T + S + 4NS + 12*slow_update_samples + 2Q`, 300 to 350 with defaults), and watch the Codex session limit, not dollars.

Accept the trained file only if it beats the seed on the sealed test split and the diff reads as rules. Then run section B on it as a real skills-dir `SKILL.md` with tools on; the trainer's harness is not the live harness (Claude path appends a system prompt, Codex path writes a temp `.agents/skills`).

## D. Rubric-judged bodies and SOPs (copy, research quality, ops procedures)

No published system has beaten Goodhart on taste. The minimum loop that survived in practice (SkillAudit paper, gbrain fixes, Agenta GEPA judge work):
1. Freeze the rubric and the negative constraints before optimizing; the proposer never edits them.
2. Blind PAIRWISE old-vs-new (or with-vs-without) on the same task; no absolute 1-5 scores.
3. Judge from a different model family than proposer and target; rubric explicitly penalizes keyword-without-substance.
4. Deterministic checks alongside (forbidden phrases, structure, length, tokens, latency).
5. Sealed tasks; per-task deltas; any regression rejects.
6. Human reads every accepted diff. Cut before add: the largest production gains reported came from halving a prompt, and only 1 to 4 edits survive a full SkillOpt run.
Tooling: GEPA `optimize_anything` (Claude Code plugin `gepa-optimize-anything@gepa`, any evaluator, $2 to $300 per run depending on judge) or a hand-rolled loop over `claude plugin eval` pairwise graders.

## Examples

Input: `/skill train godview` (description)
Output (trace, real run 2026-09-02): 20 queries + 10 sealed written; live `godview` moved to scratch, temp copy optimized with Sonnet, 5 iterations; train recall 8% to 21%, held-out 3/7 to 4/7, sealed 6/10 to 6/10; verdict: no accept (below the 2-query bar), winner also contained an em dash; original description kept, sealed set stored for the next attempt.

Input: `/skill train meet-reality` (forward test by a fresh Sonnet agent, 2026-09-02)
Output (trace): routed to section A; 20 eval + 10 sealed queries with near misses owned by deep-research, godview, gauntlet-loop, autoresearch, wiki, think, board, ask; train 5/13 to 5/13, held-out 3/7 to 4/7, sealed 4/10 to 4/10 (near misses 4/4 quiet both times, should-trigger 0/6 both times); winner was 1139 chars; verdict REJECT on both the sealed rule and the lint; live skill untouched.

Input: `/skill train caveman` with a deterministic scorer (60 paragraphs, required terms + word budget + no dashes + no filler)
Output (trace, run 1): baseline soft 0.71 / hard 0.00 because every rewrite overshot the 0.45x word budget; default `hard` gate rejected all candidates; ungated slow update rewrote the skill anyway. Run 2 with `gate_metric: soft` and a gated slow update: 2 accepts, selection 0.708 to 0.750, sealed test 0.7375 to 0.725 (worse). 648 calls and 1.06M tokens across both runs for no real gain. Verdict: keep the seed; the trainer optimized selection noise. Full trace in `research/2026-09-02/report.md` section 11.
