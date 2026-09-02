# train_sop: rubric-judged optimization of a workflow SOP (no exact checker)

Mini SkillOpt for judged tasks. A target model applies the SOP to real inputs; a proposer proposes at most 3 bounded edits; a candidate is accepted on a selection split only through a frozen, blind, counterbalanced, cross-family judge panel (Claude Opus + Gemini 3.7 Flash via OpenRouter: a decision exists only when both judges agree in BOTH presentation orders), or through a strictly higher deterministic pass count with zero judged losses. A sealed split is compared to the seed at the end. Every target output is cached by (backend, model, prompt version, SOP, input).

Files: `train_sop.py` (stdlib, Python 3.11), `rubric-presentation.md` (frozen judge rubric, the optimizer never edits it), `sop-seed-presentation.md` (seed SOP for "present a finding"), `judge-panel.sh` / `judge-claude.sh` / `judge-gemini.sh`, `calib.py` (judge calibration on cached pairs).

Run, from an empty work dir containing `sop-seed.md` and `rubric.md`:
```bash
python3.11 train_sop.py build-data            # 24 real inputs from research markdown (edit source_files() for another corpus)
python3.11 train_sop.py run --mock --epochs 2 --out out-mock   # zero spend plumbing test
python3.11 train_sop.py run --epochs 4 --out out --judge "bash judge-panel.sh"
```
Calls per epoch with the panel: 18 target (Codex Terra, sub-billed), 24 judge (12 Opus headless on the Claude sub, 12 Gemini via OpenRouter), 1 proposer (Codex Sol). Sealed: 12 target, 24 judge.

Result (2026-09-02, definitive run, 4 epochs): 2 accepts (epoch 1 deterministic path 3-0-3 with det 3/6 to 5/6; epoch 2 judged 3-2-1 with det 5/6 to 6/6), epochs 3-4 rejected. Sealed vs seed: pairwise 2-1-3, deterministic pass 5/6 vs 0/6; training pass rate 6/12 to 11/12. 54 target + 60 judge + 4 proposer calls, 17 minutes, all on subscriptions plus a few cents of Gemini via OpenRouter. The accepted edits are rules ("treat the source as a closed world ... never invent a scenario", "never make the presentation longer than the source passage", "verify the paragraph limit before returning"), not scorer vocabulary. Trained SOP (rubric v1, superseded): `sop-presentation-trained-v1.md`. Two earlier runs with a single DeepSeek judge and miscalibrated checks accepted nothing (report in `research/2026-09-02/sop-pilot-report.md` and section 11 of the report).

Run v2 (2026-09-03, rubric v2: front-loading first, illustrative examples rewarded, facts exact): 1 accept on the deterministic path, then sealed vs the v2 seed LOST 2-3-1 (det 3/6 vs 1/6). The hand-written v2 seed encodes the owner's taste better than any machine edit found in 4 epochs. Lesson: the loop's value is testing a taste change at scale and catching fabrication and bloat, not out-writing the owner; when the rubric changes, expect the seed to win and treat that as the answer, not a failure. Side-by-side outputs for one sealed input: `research/2026-09-02/sop-samples.md`.

Recommended SOP = `sop-presentation-recommended.md`: the owner's v2 seed plus one machine-found rule (copy numbers exactly, mark any calculation as illustrative). Sealed vs seed v2: judges tied 3-3-0, deterministic 3/6 vs 1/6 (fewer fabrications and less bloat, same taste).

Binding lessons (measured 2026-09-02):
1. Calibrate the judge on cached pairs BEFORE trusting a run (`calib.py`): DeepSeek V4 Pro answered "A" in both orders on 5 of 6 pairs (pure position bias); Opus and Gemini were self-consistent on 5 of 6 but disagreed with each other on direction. Single judges lie; the panel plus both orders is the minimum.
2. Calibrate deterministic checks on SEED outputs first. A 0.7x compression rule failed 18 of 18 good outputs and steered the proposer toward the wrong goal; the number guard needs value normalization (63.4, vs 63.4; 4,000 vs 4000; ignore integers under 20 and list numbering); tables, code fences, and URLs must be excluded from sentence counting.
3. Expect "undecided" to dominate: SOP edits change outputs subtly; the deterministic-gain path (no losses, more inputs passing, no new failure) is where honest accepts come from.
4. The proposer sees only training digests, never selection or sealed inputs; the judge prompt fences the presentations as data.
