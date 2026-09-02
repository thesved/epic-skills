## 1. TLDR

- SkillOpt trains a Markdown skill, not model weights. A stronger optimizer model studies scored target-model trajectories, proposes bounded text edits, and commits only selection-split improvements. Deployment uses the frozen target plus `best_skill.md`, with no optimizer calls ([paper, Sections 2 and 3](https://arxiv.org/abs/2605.23904v2)).
- The published study reports SkillOpt best or tied-best in all 52 evaluated model, harness, and benchmark cells against the strongest available baseline in each cell. This is an author-run point-estimate claim, not independent replication ([paper, Table 1](https://arxiv.org/pdf/2605.23904v2)).
- On GPT-5.5 direct chat, average score rose from 58.8 to 82.3, a 23.5-point gain. Codex CLI and Claude Code averaged gains of 24.8 and 19.1 points across five supported benchmarks ([paper, Table 1](https://arxiv.org/pdf/2605.23904v2)).
- Default research runs use 4 epochs, 40 rollouts per step, reflection minibatches of 8, 16 analysts, a 4-to-2 cosine textual learning-rate schedule, and 20 longitudinal examples per epoch boundary ([paper, Appendix C](https://arxiv.org/pdf/2605.23904v2); [current base config](https://github.com/microsoft/SkillOpt/blob/main/configs/_base_/default.yaml)).
- Published training consumed 20.8M to 213.8M tokens per benchmark. Dollar cost and fixed wall-clock time are not found ([paper, Table 6](https://arxiv.org/pdf/2605.23904v2)).
- It is best suited to repeated tasks with automatic verifiers and a representative held-out selection split. Subjective, one-off, or highly heterogeneous work falls outside its strongest stated case ([paper, Appendix B](https://arxiv.org/pdf/2605.23904v2)).
- Version 0.2.0 added SkillOpt-Sleep, an offline transcript-harvest, mining, replay, consolidation, gate, and human-adoption workflow ([v0.2.0 release](https://github.com/microsoft/SkillOpt/releases/tag/v0.2.0)).
- ArXiv v2 corrected Table 4: two GPT-5.4-to-GPT-5.4 entries presented as transfers in v1 became blanks because no cross-model transfer occurred. No other substantive change was found in a direct v1/v2 comparison ([v1](https://arxiv.org/abs/2605.23904v1); [v2](https://arxiv.org/abs/2605.23904v2)).

## 2. Mechanism, precisely

The target model is frozen and performs the task. A separate optimizer model reads target trajectories and edits the skill. A trajectory may include prompts, tool calls, observations, command output, final answers, verifier feedback, and benchmark context. The skill is injected as system or developer text for direct chat, or installed as persistent procedural memory for CLI agents ([paper, Sections 2 and 3](https://arxiv.org/pdf/2605.23904v2)).

The data roles are strict: training trajectories generate edits, the selection split gates them, and the test split is reserved for final reporting. Each optimizer step:

1. Runs a rollout batch under the current skill.
2. Separates successes and failures into reflection minibatches. Failure reflections propose corrective rules; success reflections identify behavior to preserve.
3. Hierarchically merges suggestions, with failures prioritized.
4. Emits atomic patches: `append`, `insert_after`, `replace`, or `delete`.
5. Ranks patches and clips them to the textual learning rate, the maximum edits applied that step.

Schedules are `constant`, `linear`, `cosine`, or optimizer-controlled `autonomous`. The default starts at 4 edits and decays to a floor of 2 with cosine scheduling ([paper, Appendix C](https://arxiv.org/pdf/2605.23904v2); [configuration reference](https://github.com/microsoft/SkillOpt/blob/main/docs/reference/config.md)).

`train.batch_size` is rollouts per accumulation round, `gradient.minibatch_size` is examples per reflection call, `train.accumulation` runs multiple separately reflected rollout batches before one merged update, and `train.num_epochs` repeats training over the sampled split.

The validation rule is exact: “an edit is accepted only when it strictly improves a held-out validation score.” Candidate score must be greater than current score, so a tie is rejected. The same frozen target, harness, selection examples, and configured gate metric are used. The best skill is updated only when an accepted candidate also exceeds the prior best ([paper, Section 2.3](https://arxiv.org/pdf/2605.23904v2)).

Rejected edits can enter an epoch-local buffer containing their failure pattern, patch, and score drop. Later optimizer calls see this negative evidence; the buffer resets each epoch.

From the second epoch, the slow update compares the prior and current epoch-end skill on shared training examples, grouping improvements, regressions, persistent failures, and stable successes. The optimizer writes protected longitudinal guidance. The paper describes validation of this candidate; the current code defaults `slow_update_gate_with_selection: false`, so slow guidance is unconditional unless enabled. Meta-skill memory instead summarizes useful and rejected editing patterns for the optimizer. It is never deployed.

After training, `best_skill.md` is the accepted skill with the highest selection score. Only then is it evaluated on test and deployed as static text beside the unchanged target model. No test result selects the skill ([paper, Algorithm 1](https://arxiv.org/pdf/2605.23904v2)).

## 3. Every config knob with its default (from configs/_base_ and docs/reference)

Grouped entries below preserve every shipped base or reference knob. Empty means environment or backend fallback; `null` means unset ([base YAML](https://github.com/microsoft/SkillOpt/blob/main/configs/_base_/default.yaml); [reference](https://github.com/microsoft/SkillOpt/blob/main/docs/reference/config.md)).

| Knob(s) | Default |
|---|---|
| `model.backend`; `optimizer`; `target` | `azure_openai`; `gpt-5.5`; `gpt-5.5` |
| `optimizer_backend`; `target_backend`; `reasoning_effort` | `openai_chat`; `openai_chat`; `medium` |
| `rewrite_reasoning_effort`; `rewrite_max_completion_tokens` | empty; `64000` |
| `codex_exec_path`; `sandbox`; `profile`; `reasoning_effort`; `approval_policy` | empty, effective `codex`; empty, effective `workspace-write`; empty; empty; empty, effective `never` |
| `codex_exec_use_sdk`; `network_access`; `web_search` | `null`; `null`; `null` |
| `claude_code_exec_path`; `profile`; `use_sdk`; `effort`; `max_thinking_tokens` | `claude`; empty; `auto`; `medium`; `16384` |
| `cursor_exec_path`; `cursor_exec_sandbox` | empty, effective `cursor-agent`; empty, effective `enabled` |
| `copilot_exec_path`; `home`; `allow_all_tools` | empty, effective `copilot`; empty; `null`, effective off |
| `copilot_chat_optimizer_model`; `target_model`; `timeout` | empty; empty; `null` |
| `codex_trace_to_optimizer`; `claude_trace_to_optimizer` | `true`; `true` |
| Shared `azure_openai_endpoint`; `api_version`; `api_key`; `auth_mode`; `ad_scope`; `managed_identity_client_id` | empty; `2024-12-01-preview`; empty; empty, effective `azure_cli`; Cognitive Services `.default` scope; empty |
| Optimizer and target `*_azure_openai_*` counterparts | empty, except API version and scope as above |
| Shared, optimizer, target `qwen_chat_thinking_mode` | empty, effective `server_default` |
| Qwen `base_url`, `api_key`, `temperature`, `timeout_seconds`, `max_tokens`, legacy `enable_thinking`, including role overrides | exact defaults not found, environment/server-defined |
| `minimax_region`; `base_url`; `api_key`; `model` | empty, effective `global_en`; empty; empty; `MiniMax-M3` |
| `minimax_temperature`; `max_tokens`; `enable_thinking` | `"0.7"`; `"8000"`; `"false"` |
| Optimizer and target `minimax_base_url`; `minimax_api_key` | empty |
| `train.num_epochs`; `train.train_size`; `train.steps_per_epoch` | `4`; `0`, derive; runtime-derived |
| `train.batch_size`; `accumulation`; `seed` | `40`; `1`; `42` |
| `gradient.minibatch_size`; `merge_batch_size`; `analyst_workers`; `failure_only` | `8`; `8`; `16`; `false` |
| `optimizer.learning_rate`; `min_learning_rate`; `lr_scheduler`; `lr_control_mode` | `4`; `2`; `cosine`; `fixed` |
| `skill_update_mode` | `patch` |
| `use_slow_update`; `slow_update_samples`; `slow_update_gate_with_selection`; `longitudinal_pair_policy` | `true`; `20`; `false`; `mixed` |
| `use_meta_skill`; `use_skill_aware_reflection`; `skill_aware_appendix_source`; `skill_aware_consolidate_threshold` | `true`; `false`; `both`; `0`, disabled |
| `evaluation.use_gate`; `gate_metric`; `gate_mixed_weight` | `true`; `hard`; `0.5` |
| `use_semantic_density`; `semantic_density_weight`; `leading_words` | `false`; `0.05`; built in |
| `sel_env_num`; `test_env_num`; `eval_test` | `0`, full split; `0`, full split; `true` |
| `env.name`; `skill_init`; `split_dir`; `data_path`; `split_output_dir` | empty |
| `env.split_mode`; `split_ratio`; `split_seed` | `ratio`; benchmark/default, no global value documented; `42` |
| `env.exec_timeout`; `env.out_root` | `120` seconds; CLI-generated |
| Deprecated `codex_exec_full_auto` | accepted but ignored |
| Codex path/sandbox aliases documented in the reference | inherit canonical value; canonical spelling wins |

## 4. Custom-task recipe as documented

Create an environment package, loader, rollout/scorer, adapter, config, and seed skill ([new benchmark guide](https://github.com/microsoft/SkillOpt/blob/main/docs/guide/new-benchmark.md)):

```bash
mkdir -p skillopt/envs/docfaithful
touch skillopt/envs/docfaithful/__init__.py
```

- `skillopt/envs/docfaithful/dataloader.py`: subclass `SplitDataLoader`; implement `load_split_items`, and `load_raw_items` when using ratio splitting.
- `rollout.py`: execute the target and `_score` it. The result must contain `id`, `hard`, and `soft`; `hard` is binary or a float in `[0,1]`, and `soft` is in `[0,1]`. Persist `predictions/<id>/conversation.json`, otherwise reflection lacks the trajectory.
- `adapter.py`: subclass `EnvAdapter`; build training and evaluation environments, implement rollout and task typing, and reuse inherited reflection where possible.
- Register the adapter in both `scripts/train.py` and `scripts/eval_only.py`.
- Write `configs/docfaithful/default.yaml` and the Markdown file referenced by `env.skill_init`.

Run exactly:

```bash
python scripts/train.py --config configs/docfaithful/default.yaml
```

`split_dir` requires separate `train/`, `val/`, and `test/` inputs. `ratio` uses three positive integer weights, a deterministic seed, and disjoint train, selection, and test sets. Documentation examples use `2:1:7`; no universal ratio is configured. A documented minimum dataset size is not found. The current allocation algorithm first makes all three default-ratio splits nonempty at 6 records, but that is an implementation consequence, not a sufficiency recommendation.

## 5. Harnesses

| Harness | Execution and skill placement | Authentication |
|---|---|---|
| Direct chat | One model completion per task, skill prepended to instructions | Provider credentials: Azure API key, Azure CLI or managed identity, OpenAI-compatible key, Qwen or MiniMax credentials |
| Codex CLI | `codex exec`, task workspace plus installed/generated `SKILL.md`; optional trace returned to optimizer | Installed authenticated Codex CLI. ChatGPT subscription login can supply CLI access; no separate SkillOpt API key is required |
| Claude Code CLI | Installed CLI invoked with `claude -p`; target-only exec harness or `claude_chat` client | Claude CLI login, including subscription login; `ANTHROPIC_API_KEY` is optional CLI authentication, not a direct SkillOpt Anthropic client |

The [plugins directory](https://github.com/microsoft/SkillOpt/blob/main/plugins/README.md) promises: Claude Code marketplace commands, skills, hooks, and schedulers; a Codex user-level skill and shared runner; a GitHub Copilot MCP exposing seven Sleep actions; Cursor project-native command and skill integration; Devin MCP tools plus transcript conversion; and an OpenClaw reference adaptation. OpenClaw is explicitly not a drop-in runnable plugin and documents porting gaps. Real backends use their installed authenticated CLI and its subscription or provider budget; `mock` and `handoff` need no provider key. Cursor support in the current commit postdates the v0.2.0 release.

The official project page describes the [demo video](https://youtu.be/JUBMDTCiM0M) as a short overview of rollout, reflection, editing, validation, and export. A retrievable YouTube-description text and publication date were not found.

## 6. SkillOpt-Sleep (v0.2.0)

The [v0.2.0 release](https://github.com/microsoft/SkillOpt/releases/tag/v0.2.0), dated 2026-07-02, added a decoupled `skillopt-sleep` CLI:

1. Harvest recent sessions.
2. Mine recurring successes, failures, preferences, and candidate rules.
3. Replay representative tasks under current and proposed memory.
4. Consolidate accepted evidence into a proposed skill and long-term memory.

The release supports preference-aware scoring for accuracy, tokens, and latency, multi-rollout contrastive reflection, optional experience replay or “dreaming,” slow-update memory, and a three-way train/selection/test gate.

The v0.2-era integrations read Claude history and project JSONL under `~/.claude/history.jsonl` and `~/.claude/projects/...`, plus Codex archived-session JSONL under `~/.codex/archived_sessions/`. The current commit additionally documents Cursor, Copilot, Pi, OpenCode, and VS Code sources, so those must not be attributed retroactively to v0.2.0.

Current defaults write state to `~/.skillopt-sleep/state.json`, stage proposals under `<project>/.skillopt-sleep/staging/<timestamp>/`, and manage a Claude skill at `~/.claude/skills/skillopt-sleep-learned/SKILL.md` plus project `CLAUDE.md`. Staging includes proposed skill and memory files, reports, manifests, and evidence JSONL ([Sleep documentation](https://github.com/microsoft/SkillOpt/blob/main/docs/sleep/README.md)).

Metric acceptance and human adoption are separate. The gate marks a proposal accepted only after selection improvement. `auto_adopt` defaults to `false`; live files remain untouched until the user runs adoption, which copies the selected proposal and backs up prior content. Human review can therefore reject a metrically accepted proposal.

## 7. Cost

Published benchmark accounting ([paper, Table 6](https://arxiv.org/pdf/2605.23904v2)):

| Benchmark | Initial/final skill tokens | Committed edits | Training tokens | Tokens per score point |
|---|---:|---:|---:|---:|
| SearchQA | 16 / 857 | 4 | 213.8M | 37.9M |
| SpreadsheetBench | 224 / 1,995 | 4 | 21.4M | 0.6M |
| OfficeQA | 145 / 883 | 1 | 20.8M | 1.1M |
| DocVQA | 81 / 959 | 3 | 188.2M | 46.4M |
| LiveMathBench | 154 / 379 | 1 | 23.2M | 3.6M |
| ALFWorld | 516 / 1,321 | 2 | 59.3M | 15.9M |

Dollar cost is not found. Fixed wall-clock time is not found. Documentation says runtime varies with provider latency, model, worker count, and dataset. The median final skill is about 920 tokens and requires no optimizer inference after deployment ([paper, Section 4.4](https://arxiv.org/pdf/2605.23904v2)).

For Sleep, the docs recommend starting with a small batch, for example `--batch-size 4 --limit 10`, inspecting harvest counts, using `mock` first, and remembering that a real-backend dry run still spends model budget. The current `max_tokens_per_night` default is 400,000, but the CLI documentation says hard token, elapsed-time, and dollar enforcement is not provided.

## 8. Results

Main results are `final score (+absolute gain)` from [paper Table 1](https://arxiv.org/pdf/2605.23904v2):

| Target/harness | SearchQA | Sheet | Office | DocVQA | LiveMath | ALFWorld |
|---|---:|---:|---:|---:|---:|---:|
| GPT-5.5 chat | 87.3 (+9.6) | 80.7 (+38.9) | 72.1 (+39.0) | 91.2 (+12.4) | 66.9 (+29.3) | 95.5 (+11.9) |
| GPT-5.4 chat | 83.1 (+6.2) | 62.5 (+21.1) | 62.8 (+12.8) | 91.2 (+13.6) | 44.0 (+7.2) | 91.0 (+15.6) |
| GPT-5.4-mini | 80.2 (+4.3) | 47.5 (+11.4) | 48.8 (+26.7) | 90.9 (+19.5) | 32.8 (+18.1) | 85.8 (+12.7) |
| GPT-5.4-nano | 74.8 (+19.0) | 42.5 (+19.0) | 50.0 (+33.7) | 80.2 (+49.4) | 27.2 (+4.0) | 69.4 (+35.1) |
| GPT-5.2 | 83.1 (+11.2) | 57.1 (+18.9) | 56.4 (+21.5) | 89.6 (+16.5) | 36.0 (+15.2) | 85.1 (+16.4) |
| Qwen3.5-4B | 71.2 (+3.1) | 23.9 (+14.6) | 29.7 (+15.2) | 89.0 (+2.1) | 52.0 (+29.6) | 81.3 (+50.7) |
| Qwen3.6-35B-A3B | 80.3 (+7.6) | 47.5 (+9.3) | 47.1 (+1.2) | 91.4 (+3.8) | 41.6 (+10.4) | 82.1 (+22.4) |
| GPT-5.5 Codex | 87.3 (+5.5) | 85.0 (+57.5) | 51.1 (+12.8) | 92.2 (+5.0) | 78.4 (+43.2) | not evaluated |
| GPT-5.5 Claude Code | 85.9 (+4.0) | 80.4 (+58.3) | 71.5 (+13.9) | 90.1 (+3.5) | 56.5 (+15.7) | not evaluated |

Across 52 cells, SkillOpt beats or ties the strongest available human-written skill, one-shot LLM skill, Trace2Skill, TextGrad, GEPA, or EvoSkill result. It does not mean every baseline ran in every cell. ALFWorld was omitted from CLI harnesses because it requires persistent embodied interaction.

Ablations on SearchQA, SpreadsheetBench, and OfficeQA ([paper, Table 2](https://arxiv.org/pdf/2605.23904v2)): autonomous learning rate costs 1.3, 5.7, and 7.3 points versus default; no learning-rate control costs 2.5, 1.8, and 4.0; removing rejected-edit memory costs 1.6, 4.6, and 2.4; removing meta-skill costs 2.0, 1.8, and 3.2; removing both meta and slow updates costs 0.8, 22.5, and 1.6.

Transfer is positive in all actual cross-model rows ([paper, Table 4](https://arxiv.org/pdf/2605.23904v2)): GPT-5.5 skills give GPT-5.4 gains of 10.7 and 10.4 points on SpreadsheetBench and LiveMath; GPT-5.4 skills give GPT-5.5 gains of 34.6 and 27.2; GPT-5.5 skills give GPT-5.4-mini gains of 12.8 and 17.9; mini skills give GPT-5.5 gains of 26.4 and 21.6.

## 9. Stated limitations and boundaries, verbatim

Appendix B says applicability is strongest with “automatic verifiers.” It cautions that the method “may be less attractive for one-off tasks.” The remaining stated boundaries, paraphrased closely, are:

- Open-ended, subjective, multidimensional, or expensive-to-score tasks require a reliable human or model-based evaluator.
- Training adds target rollouts and optimizer calls, even though deployment is cheap.
- SkillOpt learns one portable skill, not a compositional skill library; one skill can be insufficient for highly heterogeneous domains.
- A skill can encode distribution-specific heuristics, so transfer must be checked on held-out tasks.

It is explicitly not weight fine-tuning, online weight learning, inference-time optimizer use, or automatic skill-library construction ([paper, Appendices A and B](https://arxiv.org/pdf/2605.23904v2)). SkillOpt-Sleep is offline and, by default, does not modify live memory without adoption. The OpenClaw material is a reference port, not production-ready integration. Current docs also warn that transcript-derived prompts sent to a real backend are not guaranteed secret-free.

## 10. Unstated

- Independent replication of the paper’s 52-cell result is not found in official material. Confidence intervals, statistical tests, and multi-seed variance are not reported. The later Sleep study explicitly uses one seed and treats differences below 1.5 percentage points as noise ([Microsoft repo blog, 2026-07-14](https://github.com/microsoft/SkillOpt/blob/main/blog/skillopt-sleep-self-evolution.md)).
- Every selected benchmark has an automatic checker: exact match, executable spreadsheet comparison, native QA scoring, multiple-choice or answer verification, or environment success. Evidence for subjective creative, preference-heavy, or unverifiable work is not presented.
- Dollar cost, fixed wall-clock cost, carbon cost, Goodhart or verifier-gaming analysis, and comparison with Anthropic skill-creator evaluations are not found.
- The paper’s split documentation is inconsistent: Table 2 says `4:1:5`, while Appendix C describes `2:1:7`. Current docs avoid a universal default.
- The current project page contains older Codex and Claude harness aggregates that differ from final paper Table 1. The paper and its v2 tables are the stronger source.
- The Microsoft Research blog’s expanded 499-result analysis is descriptive, includes 358 gate/skill-aware-reflection summaries and 141 consolidation results, and acknowledges incomplete cells and confounding. It is not an independent causal validation ([Microsoft Research blog](https://www.microsoft.com/en-us/research/blog/skillopt-agent-skills-as-trainable-parameters/)).
- VentureBeat, The Decoder, and Synced are secondary coverage. They do not independently establish the official benchmark claims.

## 11. Sources

1. [ArXiv paper v2](https://arxiv.org/abs/2605.23904v2), 2026-05-25, mechanism, experiments, costs, ablations, transfer, limitations, and corrected Table 4.
2. [ArXiv paper v1](https://arxiv.org/abs/2605.23904v1), 2026-05-22, version-diff comparison.
3. [Microsoft Research blog](https://www.microsoft.com/en-us/research/blog/skillopt-agent-skills-as-trainable-parameters/), 2026-06-30, official overview and expanded analysis.
4. [SkillOpt project page](https://microsoft.github.io/SkillOpt/), accessed 2026-09-02, official summary, result presentation, and demo description.
5. [Repository at commit db46cd9](https://github.com/microsoft/SkillOpt/tree/db46cd9), 2026-08-29, README, CHANGELOG, docs, blog, configs, and plugins.
6. [v0.1.0 release](https://github.com/microsoft/SkillOpt/releases/tag/v0.1.0), 2026-06-02, initial public research release.
7. [v0.2.0 release](https://github.com/microsoft/SkillOpt/releases/tag/v0.2.0), 2026-07-02, SkillOpt-Sleep release scope.
8. [Official demo video](https://youtu.be/JUBMDTCiM0M), date not found, visual workflow; description taken from the official project page.
9. [VentureBeat](https://venturebeat.com/orchestration/microsofts-open-source-skillopt-automatically-upgrades-ai-agent-skills-without-touching-model-weights), 2026-06-11, secondary coverage only.
10. [The Decoder](https://the-decoder.com/microsofts-skillopt-boosts-gpt-5-5-by-using-nothing-but-a-trained-markdown-file/), 2026-06-13, secondary coverage only.
11. [Synced](https://mp.weixin.qq.com/s/pMlyj3a3KOh8L7cIHClRXA), date not found, secondary coverage only.