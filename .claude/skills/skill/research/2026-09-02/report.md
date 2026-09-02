# SkillOpt and the field of text-space optimization: what it is really good at, where it breaks, and how we use it

Date: 2026-09-02. Lanes: 4 Codex web/code lanes (`lanes/`), 65 YouTube videos watched by Gemini 3.7 Flash with the goal embedded (`youtube-evidence.md`, per-video in `yt/`), own live probes (install, CLI, two Sleep runs, Anthropic tooling on this machine). Every load-bearing claim was re-verified by the orchestrator against the primary source. Evidence tags: OFFICIAL (Microsoft), INDEPENDENT (someone else ran it), OWN (we ran it here), OPINION.

## How to use this document

Read section 1 and you know what to do. Sections 2-6 are the why. Section 7 is the plan for our stack. Section 9 is the runbook you paste from.

## 1. TLDR

1. **SkillOpt is a validation-gated text optimizer for ONE skill file**: a frozen agent runs tasks, a second model reads the trajectories, proposes 1-4 bounded edits per step, and an edit survives only if it strictly raises the score on a held-out split. Deployment is just the resulting `best_skill.md`. OFFICIAL.
2. **It works when four things hold**: an exact automatic checker, a self-contained repeated task, tool-using replay that matches live use, and a held-out split big enough that noise cannot pass the gate. Each independent failure report we found (gbrain, issues 174, 155, 62, 154) broke at least one of these; the sample is small and selected. INDEPENDENT.
3. **The gate lies when the split is small**. Six nights on a real task: 3 of 3 accepted edits were credited to the wrong validation example, one "0.900 to 1.000" acceptance reproduced 1 time in 5. Our own Sleep dry-run on this repo "accepted" a 0.15 to 0.985 jump on a held-out set of one task: not a trainer failure, an invalid split that the tool did not refuse. INDEPENDENT + OWN.
4. **Garry Tan's team ran it on three production skills** (Opus 4.7 optimizer, Sonnet 4.6 target and judge): cost 1.7-3.9x the estimate, humans rejected 100%, 95%, 50% of the accepted content. Root causes: regex judges rewarded vocabulary copying, tools were disabled in replay so the skill learned to describe work instead of doing it, child processes inherited `~/.claude` config. INDEPENDENT.
5. **Cost is rollouts, not the license**: 20.8M to 213.8M training tokens per paper benchmark; 0.6M to 46.4M tokens per point gained; with defaults (40 train tasks, 4 epochs, 10 selection tasks) expect about 350 target-agent calls per run. On our stack the Codex harness bills the ChatGPT sub, not dollars. OFFICIAL + code.
6. **Optimized skills strip safety while keeping steps**: in the SkillMisevo-GYM study all 21 evolved configurations (including Claude Code + SkillOpt and Codex + SkillOpt) authored an unsafe skill; 15 caused fresh-session harm. Treat learned skills as untrusted generated code. INDEPENDENT.
7. **The best practitioners cut, they do not add**: Latent Space paper club (Eugene Yan et al.): halving prompt size and deleting prescriptive steps gave the biggest production gains; deterministic logic belongs in scripts, not optimized prose; the eval harness is 50-80% of the work. This matches SkillOpt's own result that only 1-4 edits ever survive. OPINION, consistent with data.
8. **Anthropic already ships a gated optimizer, for descriptions only**: the skill-creator plugin's `run_loop.py` (in our marketplace cache, not installed) does 60/40 train/held-out, 3 runs per trigger query, up to 5 Claude-proposed revisions, selection by held-out score, on `claude -p` with session auth. Our `skill` skill hand-writes descriptions instead. `claude plugin eval` (present locally, v2.1.258) scores with a with/without ablation arm but never rewrites. OWN.
9. **Alternatives worth knowing**: GEPA (best general optimizer, any text, LLM judge, Claude Code plugin, $2-10 per Hermes run up to $200-300 for judge optimization), EvoSkill (multi-file skills, Claude Code + Codex + OpenRouter), SkillAudit (the one paper that works without ground truth: paired with/without trajectories, 73.9 vs 40.9 no-skill vs 56.7 expert skill, no code released), CodexOpt (AGENTS.md, Codex only). SkillOpt keeps the strongest bounded-edit discipline and the broadest Claude Code and Codex evidence.
10. **For us**: do not adopt SkillOpt as a nightly self-editing daemon. Adopt the discipline (held-out gate, bounded edits, with/without ablation, cross-family judge, human diff review, cut-first) as one skill that routes to the right tool per artifact, and pilot the trainer on a task with an exact checker. Details in section 7.

## 2. What SkillOpt IS and IS NOT

IS:
- A training loop over a Markdown file. "Train agent skills like you train neural networks, with epochs, batch size, learning rates, and validation gates, but without touching model weights" (README).
- Model-agnostic: OpenAI, Azure, Claude, Qwen, MiniMax, OpenAI-compatible (OpenRouter) backends; harnesses: direct chat, Codex CLI (`codex exec`), Claude Code (`claude -p`), plus Cursor and Copilot on `main`.
- Two products in one repo: the research trainer (`skillopt-train`, benchmark-style, needs a dataset with splits and a scorer) and SkillOpt-Sleep (`skillopt-sleep`, harvests your own `~/.claude` or `~/.codex` transcripts, mines recurring tasks, replays, proposes, stages; nothing changes until `adopt`).
- MIT, 16.6k stars, 1.6k forks, paper May 2026 (arXiv 2605.23904, v2 fixed a transfer table), v0.2.0 on PyPI 2026-07-02, last commit 2026-08-29. Installs on Homebrew Python 3.10-3.14 (CI covers 3.10-3.12 on Linux only).

IS NOT:
- Not weight fine-tuning, not inference-time optimization, not a skill-library builder (one skill per run, stated limitation), not a capability upgrade (the base model's math stays bad).
- Not a judge: it needs one. "Most directly applicable when the target task has automatic verifiers" (Appendix B). No subjective task was evaluated in the paper.
- Not gradient descent. The "learning rate" is a cap on edits per step. A commenter with 13 likes said it best: "There is no gradient."
- Not free on a subscription: it is 300+ agent calls per run; one Pro user burned a whole session limit in 15 minutes generating data with a related tool.

## 3. Mechanism, at two altitudes

Meta: a proposer that never touches the environment reads what happened, guesses a rule, and a gate that only looks at held-out scores decides whether the guess stays.

```
                 current skill.md
                        |
        +---------------v----------------+
        |  ROLLOUT: frozen target agent  |  40 tasks / step (batch_size)
        |  runs train tasks w/ skill     |  Codex exec / claude -p / chat
        +---------------+----------------+
                        | trajectories + scores (hard, soft in [0,1])
        +---------------v----------------+
        |  REFLECT: optimizer model      |  minibatches of 8, 16 analysts
        |  failures -> corrective rules  |  successes -> keep-this rules
        +---------------+----------------+
                        | candidate patches: append / insert_after / replace / delete
        +---------------v----------------+
        |  RANK + CLIP to learning rate  |  4 edits/step -> cosine -> 2
        +---------------+----------------+
                        | candidate skill
        +---------------v----------------+
        |  GATE: score on SELECTION split|  accept iff cand > current (strict, no epsilon)
        |  reject -> rejected buffer     |  ties reject; buffer resets each epoch
        +---------------+----------------+
                        | accepted -> current; also > best -> best_skill.md
                        v
   epoch end: SLOW UPDATE (compare prev vs curr epoch skill on 20 tasks,
   write "protected" longitudinal guidance).  In code this is UNGATED by
   default (slow_update_gate_with_selection: false).  META memory = notes
   to the optimizer, never deployed.
```

Detail that matters for us (from the code, `lanes/B-code-teardown.md`):
- Claude Code harness: `claude -p --output-format json --permission-mode dontAsk --add-dir <tmp> --append-system-prompt-file <tmp>/system_prompt.txt`, prompt on stdin. The skill is an appended system prompt, not a SKILL.md in a skills dir, and user/project settings load unless you set `CLAUDE_SETTING_SOURCES`. That is the config-contamination bug gbrain hit.
- Codex target harness writes the skill to `.agents/skills/skillopt-target/SKILL.md` in a fresh work dir (it deletes and recreates that dir), runs `codex exec --sandbox workspace-write -c approval_policy=never`, network and web search off by default.
- Gate: `candidate_score > current_score`, floats averaged over the selection split. No confidence interval, no reseeding. A no-regression gate exists since PR 222 but is default-off.
- Resume is automatic from `runtime_state.json` in the same `out_root`.
- Default optimizer is Azure `gpt-5.5`; `backend: codex` maps both roles to `codex_exec`; `backend: claude_code_exec` maps only the target, so a subscription-only Claude run must set `optimizer_backend: claude_code_exec` explicitly.
- Claude CLI mode emits `--max-thinking-tokens 16384`, which Claude Code 2.1.258 does not accept: set `claude_code_exec_max_thinking_tokens: 0`.
- Sleep on Claude reads `~/.claude/projects/**/*.jsonl` (subagents and headless sessions filtered since PR 72). The Claude harvester does not run the secret redactor the Codex harvester uses. With a real backend, transcript excerpts leave the machine.

## 4. Evidence ladder

| Claim | Evidence | Tag | Source |
|---|---|---|---|
| +23.5 pts direct chat, +24.8 Codex, +19.1 Claude Code (GPT-5.5), best-or-tied on 52/52 cells | author-run point estimates, one seed, no CI | OFFICIAL | paper Table 1 |
| Beats human skill, one-shot LLM skill, Trace2Skill, TextGrad, GEPA, EvoSkill | author-run, "strongest available baseline per cell", not every baseline in every cell | OFFICIAL | paper Table 1 |
| Gains shrink inside mature harnesses (SearchQA: +9.6 chat vs +5.5 Codex vs +4.0 Claude Code) | paper numbers, read by Discover AI | OFFICIAL | aVW-KG4sDdo 15:57 |
| Ablation: no slow/meta update costs 22.5 pts on SpreadsheetBench; unbounded edits lose 2-4 pts | author-run | OFFICIAL | paper Table 2 |
| Transfer keeps only part of the gain; direct optimization stays better | paper Table 4 | OFFICIAL | iSPwNmsa7kA 10:20 |
| Synthetic field extraction 0.70 to 1.00, 4 holdouts, judge-vs-checker Spearman 0.868 (n=16) | one wrapper author, tiny n | INDEPENDENT | vinnylarouge/skill-opt-skill |
| Three production skills: cost 1.8x/3.9x/1.7x estimate; human rejection 100%/95%/50% | full writeup with numbers | INDEPENDENT | gbrain issue 4119 |
| Six nights, 3/3 accepts misattributed, 1/5 reproduction | full writeup, 4-30 task splits | INDEPENDENT | SkillOpt issue 174 |
| Miner learned mostly from hooks, subagents, and SkillOpt itself; 142 fake dirs created | issue, fixed in PR 72 | INDEPENDENT | SkillOpt issue 62 |
| Tools disabled in replay push execution skills toward fabrication | open issue, no fix | INDEPENDENT | SkillOpt issue 155 |
| 21/21 evolved configs authored an unsafe skill; 15/21 fresh-session harm | paper with SkillOpt rows | INDEPENDENT | arXiv 2608.12851 |
| Self-grading inflates skill A/B scores by about 60 pts | 92 evals, 9 skills | INDEPENDENT | BuidlGuidl 2026-06 |
| Install on py3.13 OK; `skillopt-train/eval/sleep` entry points; mock dry-run 23 sessions to 23 tasks in 2.6 s, zero files written | ran here | OWN | this session |
| Codex-backend dry-run: 9 sessions to 1 task, gate 0.150 to 0.985 accepted with a held-out set of ONE task (the task was this session's own request) | ran here | OWN | `sleep-codex-dryrun.log` |
| skill-creator `run_loop.py` = gated description optimizer; `claude plugin eval` = scoring only | read the code and CLI help here | OWN | marketplace cache, `claude plugin eval --help` |

Unstated by the official material: dollars, wall-clock, seeds, Goodhart analysis, any subjective task, comparison with Anthropic's own eval loop, and that the split documentation contradicts itself (Table 2 says 4:1:5, Appendix C says 2:1:7).

## 5. Good at, bad at, breaks

GOOD AT (evidence-backed):
- Rigid multi-step procedures where the model is capable but sloppy: spreadsheets (+38.9), office tool loops (+39.0), math MCQ (+29.3). The learned rules are domain heuristics (search-frontier discipline, "bind evidence by direct quote"), not trigger words.
- Cheap deployment: median 920-token skill, zero optimizer calls at inference, transfers positively across model sizes and harnesses (every transfer row above baseline).
- Discipline others lack: bounded edits, rejected-edit memory, strict held-out acceptance. Ablations show each part matters.
- Running on subscriptions: `codex_exec` and `claude_code_exec` backends need no API key; Sleep's handoff backend uses the current session's subagents.

BAD AT (evidence-backed):
- Anything without an exact checker. Named failures: poetry, creative writing, tone. The workaround everyone proposes (LLM rubric to a scalar) is exactly what gbrain showed gets gamed.
- Small validation sets. With 4-30 tasks the gate accepts luck (issue 174); with 1 task it accepts anything (our run).
- Execution-centric skills when replay has no tools: the skill learns to narrate success (gbrain, issue 155).
- Whole libraries: one skill per run; routing, dedup, pruning are someone else's job (Hermes Curator, SkillsVote, SkillBrew).
- Cost prediction: the built-in estimator was off 1.7-3.9x; Sleep's time cap is checked between steps only (42 min on a 30 min cap).
- Security: outcome-only reward keeps steps and drops permission constraints.

BREAKS (mechanics):
- Config contamination: `claude -p` inherits `~/.claude` hooks and settings unless you isolate `CLAUDE_CONFIG_DIR` / `CLAUDE_SETTING_SOURCES`.
- Regex or keyword judges: the optimizer pastes the judge's vocabulary and mandatory headings into the skill.
- Same-family judge and optimizer: shared blind spots; gbrain fixed it with rubrics that penalize keyword-without-substance and human diff review.
- Windows `.CMD` truncates multiline prompts to line one (issue 197, open).
- Local models emit tool tags the harness cannot parse (issue 119); a 4B model needed 44 GB VRAM for both roles.
- Key leakage: only `api_key`, `azure_api_key`, `openai_api_key` are redacted; `azure_openai_api_key` can land in `out_root/config.json`.

## 6. Inversion: false beliefs a competent practitioner holds

1. **"The gate went green, so the skill improved."** The gate compares two noisy means over a small split. Issue 174: acceptance reasons were wrong 3 of 3 times. Fix: multi-seed, per-task deltas, `gate_no_regression`, and a test split nobody optimizes against.
2. **"More learned rules make a stronger skill."** Only 1-4 edits ever survive in the paper. Eugene Yan's production result was the opposite direction: cut the prompt in half. A 500-line memory file became three words ("no contrast framing"). Optimize for deletion first.
3. **"A stronger optimizer model is always better."** SkillLens data: execution power does not predict extraction power; an oracle curator writing for an 8B executor degraded it. Match the optimizer's writing to the target's reading.
4. **"Give the optimizer the full policy as the seed."** GEPA judge optimization: the full-policy seed trapped the search in a local minimum; a minimal seed plus incremental trace learning won.
5. **"Skills only touch text, so they cannot be dangerous."** 21/21 evolved configs wrote an unsafe skill; a skill that says "dump telemetry unencrypted" lost the "only in the sandbox" clause because the outcome reward never saw it.
6. **"Sleep learns from my real work."** Before PR 72 it learned mostly from hooks and subagents. Our run mined this very session's request and then graded itself on it. Pin the task set, review it, then run.
7. **"Let the same agent grade its own output, it is just a quick check."** 60-point inflation on 92 evals. Executor gets the task only; a separate grader gets the assertions.
8. **"The subscription makes rollouts free."** Session limits are the wall: one Pro user hit it in 15 minutes. Budget in calls (about 350 per default run), not dollars.

## 7. The field, and where we stand

Taxonomy axes: single skill vs library vs harness; verifier-gated vs judge-gated vs paired-contrast vs ungated; bounded edits vs textual gradient vs evolutionary/Pareto; offline batch vs nightly from real sessions.

| System | One line | Evidence | Runs on | Has what SkillOpt lacks |
|---|---|---|---|---|
| SkillOpt | bounded edits, strict held-out gate, one skill | 52 cells, author-run | Claude Code, Codex, chat, OpenRouter | reference discipline |
| GEPA / optimize_anything | reflective evolution, Pareto over task subsets, any text + any evaluator | AIME 46.6 to 56.6; gskill 55 to 82 and 24 to 93 on repo tasks | Claude Code plugin, DSPy, API | arbitrary artifacts, LLM judge feedback, multi-component |
| EvoSkill | creates and refines multi-file skill folders on a held-out Pareto frontier | Opus 4.5: OfficeQA 60.6 to 67.9, SealQA 26.6 to 38.7 | Claude Code, Codex CLI, OpenRouter, OpenCode, Goose | multi-file, cross-harness deploy |
| SkillAudit | paired with/without trajectories, passage-level diagnostics, fixed structural verifier | 73.9 vs 40.9 vs 56.7 over 89 tasks, 8 domains | research; no code | works without ground truth |
| Meta-Harness | rewrites the executable harness, 10M tokens of traces per rollout | beats ACE by 7.7 at 4x fewer tokens; TB-2 76.4 | research artifact | harness code, not just prose |
| CodexOpt | AGENTS.md and .codex/skills optimizer, validation-gated engine | live demo 0.47 to 0.92, no benchmark | Codex only | turnkey AGENTS.md |
| Skill Issues (Bauplan) | generates destructive data tasks safely, verifies state, GEPA on 6 skills | +31.9% on 25 tasks | Claude Code + Modal | eval generation |
| Hermes Curator | 30-day stale flag, 90-day archive, judge dedup | operational | Hermes | library garbage collection |
| Anthropic skill-creator | with/without or old/new runs, assertion grading, blind comparator, `run_loop.py` description optimizer | official | Claude Code, `claude -p` | the only official gated loop (descriptions) |
| `claude plugin eval` | isolated `claude -p` cases, regex/tool/llm graders, with-without ablation, cost ceiling | official, early access, present here | Claude Code | scoring you can call from a skill |

Verdict from the landscape lane and confirmed by the video corpus: SkillOpt for conservative refinement of one verifiable skill, GEPA for judge-based and non-coding artifacts, EvoSkill for multi-file skill packages. None of them has demonstrated non-Goodhart optimization of taste (copy, UX, research insight); that result is not found anywhere.

## 8. Non-verifiable tasks: the minimum credible loop

From SkillAudit, gbrain's fixes, BuidlGuidl, and the Agenta GEPA judge work:

1. Freeze the rubric and the negative constraints before optimizing; never let the proposer edit them.
2. Score by blind pairwise with/without (or old/new) comparison, not absolute scalars; 1-5 ratings do not agree across annotators, binary adherence checks with a required evidence quote do.
3. Judge from a different model family than the proposer and the target. Penalize "keyword without substance" explicitly.
4. Mix deterministic checks (forbidden phrases, structure, length, cost, latency) with the judge.
5. Hold out tasks the loop never sees; require per-task deltas; reject any regression.
6. Human-audit every large jump and a random sample of wins. gbrain's human review threw out half of the best case.
7. Replace synthetic cases with real sessions and real complaints over time.

## 9. What this means for us (recommendation, you decide)

The decision tree:

```
Do you have >= 60 tasks with an exact checker for this artifact (30 train / 12 selection / 20 sealed test is the floor we use; fewer and the gate accepts noise)?
  no  -> is it a DESCRIPTION (trigger)?  yes -> skill-creator run_loop (gated, official)
         no -> pairwise judge loop (GEPA optimize_anything or our own via claude plugin eval)
               with section 8 rules; expect human review of every accept
  yes -> is replay tool-parity possible (agent can run the real commands)?
         no  -> fix that first (else the skill learns to narrate)
         yes -> SkillOpt trainer, Codex harness (sub-billed), split >= 30/12/20,
                cross-family judge if any soft score, gate_no_regression on,
                3 seeds on the final candidate, human diff review, security scan
Nightly Sleep on our transcripts?  Only with: pinned reviewed task file, max-tasks cap,
  hermetic config, mock first, adopt never automatic. Default: OFF.
```

Landing (my recommendation; final call after the board and the pilots):
- One new skill (working name `skill-train`, or fold under `skill` as a `train` verb) that owns the routing gate above, the binding rules (hermetic config, tools on, cross-family judge, no-regression, multi-seed, human diff review, cut-first, unsafe-skill scan), and four call shapes: skill-creator `run_loop.py` for descriptions, `claude plugin eval` for with/without scoring, SkillOpt trainer via Codex for bodies with exact checkers, GEPA for judge-based artifacts. Board condition (3 seats, 2026-09-02): none of this ships until pilot A wins on a sealed test split; until then only the two pilots run.
- `skill`: replace "write the description with codex-bridge" with "draft with codex-bridge, then optimize with `run_loop.py` against 20 trigger/non-trigger queries"; add the with/without ablation as the forward-test standard.
- `autoresearch`: add SkillOpt, GEPA, EvoSkill, SkillAudit to the tools table with the one-line verdicts; point the "optimize fuzzy targets" section at section 8.
- `gauntlet-loop`: the critic gate gains the same rules (blind pairwise, cross-family, no self-grading).
- `fable-max` delegation roles: rollouts and optimizer calls are executor work on the Codex sub; Fable owns the rubric, the split design, and the diff review.
- `meet-reality`: this report is the worked example of "reality corrected the paper".

Pilots (in flight):
- A: SkillOpt trainer, Codex harness (`gpt-5.6-sol` optimizer, `gpt-5.6-terra` target), our own caveman-compression task (paragraphs from this repo, deterministic scorer: required terms present, word budget, no dashes, no filler). 30/12/20 split. Goal: does the gate produce a skill that beats the seed on the untouched test split, and what does the optimizer try to game.
- B: skill-creator `run_loop.py` on one of our skill descriptions with 20 trigger/non-trigger queries, 60/40 split. Goal: measure whether the official loop beats our hand-written description on held-out queries.

## 10. Board verdict on this report (2026-09-02, Codex gpt-5.6-sol, Grok 4.6, DeepSeek V4 Pro; Gemini seat was down during this board (direct API prepaid credits depleted mid-sweep; since rerouted via OpenRouter by a parallel session, use that path going forward); Fable seat: adopt with two changes, ship as a `train` verb inside `skill` rather than a new skill, and add a cross-family semantic judge to pilot A because its scorer is itself a keyword judge)

Unanimous: adopt the routing-by-verifier idea, keep Sleep off, but run the pilots BEFORE building or patching any skill. Corrections folded in above. Added pilot measurements: (a) harness transfer: score the learned file loaded as a real skills-dir `SKILL.md` with tools on and an isolated `CLAUDE_CONFIG_DIR`, not only inside the trainer harness; (b) tokens per accepted edit and per point gained, since session limits are the real budget; (c) library-level routing interference for descriptions (false and missed activation with all 27 skills loaded); (d) skill-creator `run_loop.py` selects by its "test" score every iteration, so that set is a validation set; a sealed query set the loop never sees is required for an honest number. (e) Classify every accepted diff as RULE vs VOCABULARY-COPY (the gbrain and issue 174 signal). (f) Codex session-limit consumption per run. Also on record: the trainer at db46cd9 has NO per-task no-regression gate (only Sleep does), and neither pilot touches a non-coding SOP beyond the caveman writing rule; that gap stays open.

## 11. Pilot results (2026-09-02, this machine)

Pilot B, skill-creator `run_loop.py` on the `godview` description (Sonnet in `claude -p`, 20 queries, 3 runs each, 60/40 split, 5 iterations, plus a sealed 10-query set the loop never saw):
- First pass was INVALID: the harness installs the candidate as a temporary command named `<skill>-skill-<hash>` under `~/.claude/commands` and counts a hit only on that name; the real `godview` stayed installed and won every trigger, so recall read 0% for every candidate. Moving the live skill out works but makes it vanish for parallel sessions (it did, twice). The fix that stuck: a `claude` PATH shim adding `--setting-sources project`, run from a scratch project whose `.claude/commands` holds the candidate; user skills do not load, keychain auth works (verified). Packaged as `skill/scripts/train_desc.sh`.
- Valid pass: original description train 5/13, held-out 3/7; best candidate train 6/13, held-out 4/7; sealed set 6/10 for BOTH (the original scored 5/10 in a separate pass, so the noise band is one query). No measurable generalization. Precision stayed 100% throughout: the ceiling is recall, Sonnet in headless mode rarely consults a skill for a one-line query.
- The winning description contains an em dash. The optimizer does not know the house rules unless told; any accepted text must pass the same lint as hand-written text.

Forward test of the new `/skill train` verb (fresh Sonnet agent, `meet-reality` description): routed correctly, built 20 + 10 sealed queries, ran the loop, REJECTED on the sealed rule (4/10 to 4/10) and on lint (1139 chars over the 1024 limit), restored the skill. It exposed the ceiling: sealed should-trigger recall was 0/6 before and after. A direct probe on 4 queries, 3 runs each, isolated: Opus 1/6 fires on the two should-trigger queries, Sonnet 2/6, near misses 0/6 fire on both. Headless `claude -p` rarely consults a skill for a one-line query whatever the description; this harness is a regression guard against over-triggering, not a recall optimizer.

Pilot A, SkillOpt trainer on Codex (optimizer gpt-5.6-sol, target gpt-5.6-terra, 30/12/20 caveman-compression items, deterministic 4-check scorer), run 1 with defaults:
- Baseline selection: soft 0.71, hard 0.00. All 12 items fail the word budget (Terra compresses to about 0.6x, the budget is 0.45x), 2 miss a required term. No item is ever perfect.
- Because `evaluation.gate_metric` defaults to `hard` (1.0 only on perfect items), every candidate scored 0.0 at the gate and was rejected (steps 1 and 2, 4 and 3 edits proposed; step 3 produced no patches). Meanwhile the ungated slow update injected a 120-word "faithful rewriting" paragraph into the live skill at epoch 2. Lesson: the gate metric must have resolution on your task, and the slow update must be gated (`slow_update_gate_with_selection: true`) or it becomes an unreviewed rewrite channel.
- Run 1 final: 4 epochs, 316 Codex calls (291 rollouts, 16 analyst, rest merge/meta), 486k tokens (472k prompt, 15k completion), 30 min wall clock, accept 0 / reject 2 / skip 2. Sealed test (20 items): seed soft 0.750, final skill (seed plus the ungated slow-update paragraph) soft 0.7375, hard 0.0 for both. The optimizer spent the whole budget and shipped nothing better than the seed. Cost per accepted edit: undefined (none accepted).
- Run 2 (`gate_metric: soft`, `slow_update_gate_with_selection: true`), in progress: step 1 accepted (selection soft 0.708 to 0.729, 3 edits), step 2 tied and rejected (strict `>`), step 3 produced no patches. The accepted diff is a RULE (a faithful-rewriting expansion: "do not paraphrase, reorder, merge, summarize", "retain function words when deletion makes ... ambiguous"), not scorer vocabulary, but it steers AWAY from the one failing check (the word budget), and +0.02 on 12 selection items is one check on one item. The gate accepted noise, exactly the issue-174 pattern, on our own task, with the "right" metric. Final: 4 epochs, 332 calls, 570k tokens, 33 min, accept 2 / reject 1 / skip 1; selection soft 0.708 to 0.750 (best at step 4). Sealed test (20 items, never seen): seed soft 0.7375, trained skill 0.725. The gate-accepted skill is WORSE on the sealed split. Total pilot A spend: 648 Codex calls, 1.06M tokens, 63 min, zero real improvement.

**Pilot verdicts.** A: FAIL (both runs; the trainer optimized selection noise and regressed on the sealed split, the issue-174 pattern reproduced on our own task with the correct gate metric). B: REJECT twice (godview, meet-reality), no sealed gain, winners violated house lint both times. What DID hold: the discipline. Sealed splits caught both illusions; lint caught the rest; the forward test showed a fresh agent applies the rules and rejects correctly. Per the board condition, the SkillOpt trainer does not become a default tool; it stays in `train.md` section C as an opt-in with its binding config, and the routing gate plus sealed-set rule are the product.

## 11. Gaps and uncertainty

- No independent reproduction of the paper's 52-cell table exists (independent runs of the METHOD exist: gbrain, vinnylarouge, issue 174). Nobody has published real token counts for a custom SkillOpt run.
- No report of a production run through Claude Code on a Claude subscription with before/after and billing.
- No non-coding SOP result with numbers anywhere in 65 videos and 4 web lanes.
- `claude plugin eval` and `/skill-doctor` are early access; the CLI here has the flags, but the docs agent could not find public documentation.
- Gemini via SkillOpt's OpenAI-compatible backend is untested; reasoning effort is not forwarded on that path.

## 11b. Non-coding SOP pilot (added 2026-09-02, later the same day)

Built `skill/scripts/sop/train_sop.py` (Codex-implemented to my spec, two independent reviews, 12 fixes) and ran it on a real non-coding SOP: "present a finding to the reader" (the grok-first presentation rule), with 24 finding passages from previous research sessions as inputs.
- Run 1 (single DeepSeek judge): 0 accepts; the judge chose position A in both orders on 5 of 6 pairs; deterministic checks failed every output including the seed (0.7x compression rule, unnormalized number guard, tables and URLs counted as sentences).
- Judge calibration on the same cached pairs: Opus and Gemini self-consistent on 5 of 6, but disagreeing on direction (2-3 vs 4-1). Panel rule adopted: decision only when both judges agree in both orders.
- Run 2 (panel judge, old checks): 0 accepts, 4-5 of 6 undecided per epoch; the proposer had been steered toward compression by the wrong checks.
- Run 3 (panel judge, recalibrated checks, deterministic-gain acceptance path): 2 accepts, sealed vs seed 2-1-3 pairwise and 5/6 vs 0/6 deterministic, training pass 6/12 to 11/12, 118 calls, 17 minutes. Accepted edits are rules that target the judged fault (invented examples), not scorer vocabulary. Trained SOP saved as `skill/scripts/sop/sop-presentation-trained.md`; full run report in `sop-pilot-report.md`.
- What generalizes: calibrate the judge and the checks BEFORE the loop; single judges lie in different ways (position bias vs taste); undecided dominates and the deterministic-gain path produces the honest accepts; the loop works on subscriptions (Codex targets and proposer, Opus headless judge) plus cents of OpenRouter.

## 12. Runbook for our machine (verified against code, not yet run end-to-end; pilot A will confirm)

```bash
# 1. env (CI-tested interpreter range is 3.10-3.12)
/opt/homebrew/bin/python3.11 -m venv so311 && . so311/bin/activate
git clone https://github.com/microsoft/SkillOpt.git skillopt-src && pip install -e ./skillopt-src

# 2. data: data/{train,val,test}/items.json, each item {id, prompt, score_cmd, ...}
# 3. adapter: custom EnvAdapter (rollout returns [{id, hard, soft, ...}]) registered in
#    skillopt-src/scripts/train.py _ENV_REGISTRY; write predictions/<id>/conversation.json
# 4. config (Codex, sub-billed):
#    model: {backend: codex, optimizer_backend: codex_exec, target_backend: codex_exec,
#            optimizer: gpt-5.6-sol, target: gpt-5.6-terra, codex_exec_use_sdk: cli,
#            codex_exec_sandbox: workspace-write, codex_exec_network_access: false}
#    train: {num_epochs: 4, train_size: 30, batch_size: 30}   # 1 step/epoch
#    env: {name: <registered>, skill_init: ./initial_skill.md, split_mode: split_dir, split_dir: ./data}
#    # NOTE: no per-task no-regression gate exists in the TRAINER at db46cd9 (grep: only skillopt_sleep has it);
    # compute per-task deltas post hoc from out_root predictions, or patch skillopt/evaluation/gate.py
python skillopt-src/scripts/train.py --config codex.yaml
# calls ~= 4T + S + 4NS + 120 + 2Q  (T train, S selection, Q test, N steps/epoch)

# Sleep, only ever like this:
skillopt-sleep dry-run --project "$PWD" --backend mock --scope invoked            # plumbing
skillopt-sleep dry-run --project "$PWD" --backend codex --max-tasks 12 --lookback-hours 168 --progress
# review .skillopt-sleep/staging/<date>/report.md; never --auto-adopt
```

## 13. Sources

Primary: arXiv 2605.23904 v1/v2; microsoft/SkillOpt at db46cd9 (README, CHANGELOG, docs/, configs/_base_/default.yaml, skillopt/engine/trainer.py, skillopt/evaluation/gate.py, skillopt/model/*.py, plugins/claude-code, skillopt_sleep/*); MSR blog 2026-06-30; v0.2.0 release notes.
Independent: garrytan/gbrain issue 4119 (2026-08-15); microsoft/SkillOpt issues 57, 62, 68, 119, 121, 154, 155, 174, 194, 197, 247 and PRs 72, 73, 222, 249, 264; vinnylarouge/skill-opt-skill; mitkox/SkillOpt; arXiv 2608.12851 (Practice Makes Unsafe); buidlguidl.com/blog/evaluating-agent-skills; arXiv 2606.14239 (SkillAudit); gepa-ai.github.io (gskill blog 2026-02-18, agent-skill guide); bauplanlabs.com/post/skill-issues; agentskills.io/skill-creation/evaluating-skills; anthropics/skills skill-creator (marketplace cache, scripts/run_loop.py, improve_description.py, agents/comparator.md).
Video: 65 videos, see `youtube-evidence.md` (hands-on: yj17Fvyr09s, EtqRVxsokdI; critique: MqPHm_6zZBQ Latent Space paper club; security: nnDAaPpXgOY; GEPA judge: X4dEHRzBLmc; Meta-Harness: yOeVi3aQ9Kg; Hermes: bNp6YcKBLgY).
Own: `sleep-codex-dryrun.log`, `claude plugin eval --help` on 2.1.258, `skillopt-train --help` 0.2.0.
