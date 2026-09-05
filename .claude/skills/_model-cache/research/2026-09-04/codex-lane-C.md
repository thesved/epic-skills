# Lane C: GPT-6 Astra benchmarks and routing math, research cutoff 2026-09-04

## TLDR: decisions for our routing

1. `[COMMUNITY][DEMONSTRATED]` Keep Claude Fable 5.1 as the default orchestrator for difficult planning and long autonomous coding. Artificial Analysis scores Fable 5.1 max at `66` on Intelligence Index v4.1.1 and `70` on Coding Agent Index v1.4, versus Astra max at `61` and `67`. Fable is materially more expensive, so reserve max for genuinely difficult work. [Artificial Analysis, published 2026-09-03, accessed 2026-09-04](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra)

2. `[COMMUNITY][DEMONSTRATED]` For general API reasoning, Astra max is poor marginal economics. Astra xhigh and max both score `61`, while cost per Intelligence Index task rises from `$1.20` to `$1.67` and output tokens rise from `25M` to `42M`. Default to high, promote to xhigh after failure, and use max only for environment-heavy or unusually valuable tasks. [Artificial Analysis Astra release, accessed 2026-09-04](https://artificialanalysis.ai/models/releases/gpt-6-astra)

3. `[COMMUNITY][DEMONSTRATED]` For ordinary non-GUI reasoning, GPT-5.6 Sol remains the better value. Sol max scores `61` for `$0.95` per Intelligence Index task, versus Astra max `61` for `$1.67`. Sol high scores `57` for `$0.43`, while Astra low scores `57` for `$0.46`. Use Astra for its differentiated capabilities, not merely as a blanket Sol replacement. [Artificial Analysis Astra analysis, 2026-09-03](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra), [Sol release data, accessed 2026-09-04](https://artificialanalysis.ai/models/releases/gpt-5-6-sol)

4. `[OFFICIAL][DEMONSTRATED]` Route GUI operation, browser interaction, and visual verification to Astra high or xhigh. OpenAI reports `72.6%` on OSWorld2 versus Sol’s `65.7%`, with roughly `40 minutes` versus `75 minutes` per task, plus `92.7%` versus `76.9%` on ScreenSpot-Pro. These are vendor-run results, not yet independently reproduced for Astra. [OpenAI Astra launch, 2026-09-03](https://openai.com/index/gpt-6-astra/)

5. `[COMMUNITY][DEMONSTRATED]` Preserve Astra’s reasoning state and use compaction for long agent loops. ARC Prize’s independent Provider Adapter moved ARC-AGI-3 from `62.7%` under the common Standard harness to `99.9%`, while shared solved runs were approximately `3.66x` faster and used `49%` fewer tokens. Harness design is part of model performance. [ARC Prize, 2026-09-03](https://arcprize.org/blog/astra)

6. `[COMMUNITY][DEMONSTRATED]` For ambiguous multi-file coding today, Fable 5.1 remains the strongest verified choice. CursorBench 3.2 scores Fable max at `73.4%`, Fable high at `69.4%`, Sol max at `67.2%`, Grok 4.6 xhigh at `70.8%`, and Gemini 3.7 Flash high at `61.6%`. Astra had no CursorBench result by the cutoff. [CursorBench 3.2, updated 2026-09-02, accessed 2026-09-04](https://cursor.com/evals)

7. `[COMMUNITY][DEMONSTRATED]` Use Luna for cheap mechanical coding and first-pass review. CursorBench reports Luna max at `61.1%` for `$0.39` per task, versus Sol max at `67.2%` for `$5.69` and Fable max at `73.4%` for `$9.64`. Escalate uncertain or architectural findings to Fable or Astra. [CursorBench 3.2](https://cursor.com/evals)

8. `[OFFICIAL][DEMONSTRATED]` Use Astra high or xhigh for scientific agents that need tools. OpenAI reports `64.6%` on Terminal-Bench Science 0.1 versus Fable 5.1 `52.6%` and Sol `22.4%`. Independent Epoch testing on 68 open Erdos problems found Astra solved `2/68`, while Sol and Fable 5.1 each solved `0/68`. [OpenAI Astra launch, 2026-09-03](https://openai.com/index/gpt-6-astra/), [Epoch AI FrontierMath Erdos, 2026-09-01](https://epoch.ai/latest/announcing-frontiermath-erdos)

9. `[COMMUNITY][DEMONSTRATED]` Do not use the `99.9%` ARC-AGI-3 figure as a general intelligence routing score. The provider-neutral result is `62.71%` at max for `$26,098`; `99.95%` is the high-effort Provider Adapter result for `$18,817`. ARC Prize explicitly says the benchmark is a tightly scoped, deterministic environment and saturation does not establish AGI. [ARC Prize verified results, 2026-09-02](https://arcprize.org/results/openai-gpt-6-astra)

10. `[OFFICIAL][DEMONSTRATED]` Set Astra effort explicitly. The supported values are `low`, `medium`, `high`, `xhigh`, and `max`; `none` is not supported. An LLM Stats article says the API defaults to low, but the official documentation examined did not state that default. Treat the default as unresolved. [OpenAI model documentation, accessed 2026-09-04](https://developers.openai.com/api/docs/models/gpt-6-astra), [LLM Stats launch analysis, 2026-09-03](https://llm-stats.com/blog/research/gpt-6-astra-launch)

11. `[OFFICIAL][DEMONSTRATED]` Avoid feeding Astra more than `272K` input tokens unless the additional context is worth the surcharge. Above that threshold, the entire request is charged at `2x` input and cached-input rates and `1.5x` output rates. Fable’s `$0.25` cache-read price, versus Astra’s `$1.00`, can make Fable cheaper for repeated large repositories despite equal `$10` input and `$50` output list prices. [OpenAI model documentation](https://developers.openai.com/api/docs/models/gpt-6-astra), [Anthropic Fable announcement, 2026-09-01](https://www.anthropic.com/claude/fable)

12. `[COMMUNITY][ASSERTION]` Do not make a permanent Astra-versus-Fable coding policy yet. Astra had no public result by the cutoff on CursorBench, Aider Polyglot, LiveBench, LiveCodeBench, SWE-bench Verified, SWE-bench Pro, WebDev Arena, or the independent Terminal-Bench 4.0 leaderboard. Run a private repository bakeoff before changing the default shipper.

## 1. Independent evaluation status

The evidence is unusually uneven. Artificial Analysis, ARC Prize, Epoch AI, and Cursor provide useful independent measurements. Most of Astra’s striking coding, computer-use, security, and science numbers still come from OpenAI’s own launch evaluation.

### Artificial Analysis

`[COMMUNITY][DEMONSTRATED]` Artificial Analysis ran Astra across Intelligence Index v4.1.1 and Coding Agent Index v1.4. Its headline findings were:

- Astra max Intelligence Index: `61`
- Sol max: `61`
- Fable 5.1 max with fallback: `66`
- Astra Coding Agent Index: `67`
- Sol: `65.1`
- Fable 5.1: `70`
- Astra max used about one third as many output tokens as Sol max and about one fifth as many as Claude Opus 5 xhigh on the coding evaluation.
- Astra max had roughly the same coding-task cost as Sol max, despite Astra’s higher token prices.
- Astra matched Fable 5’s coding score at less than half Fable 5’s cost.

Source: [Artificial Analysis, 2026-09-03](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra).

The OpenAI launch table gives more precise imported AA values, `61.2` for Astra, `60.9` for Sol, and `65.7` for Fable 5.1. The independent AA site rounds these to `61`, `61`, and `66`. This is rounding, not a substantive disagreement. [OpenAI Astra launch](https://openai.com/index/gpt-6-astra/), [Artificial Analysis Fable release](https://artificialanalysis.ai/models/releases/claude-fable-5-1)

#### Astra Intelligence Index economics by effort

`[COMMUNITY][DEMONSTRATED]` These are weighted average cost per Intelligence Index task, total output tokens across the evaluation, and total evaluation spend.

| Effort | Index | Cost per task | Total output tokens | Total evaluation cost |
|---|---:|---:|---:|---:|
| low | `57` | `$0.46` | `4.4M` | `$574.92` |
| medium | `59` | `$0.75` | `9.8M` | `$1,032.97` |
| high | `60` | `$0.96` | `16M` | `$1,429.26` |
| xhigh | `61` | `$1.20` | `25M` | `$2,004.12` |
| max | `61` | `$1.67` | `42M` | `$3,013.30` |

Source: [Artificial Analysis Astra release, accessed 2026-09-04](https://artificialanalysis.ai/models/releases/gpt-6-astra).

`[COMMUNITY][DEMONSTRATED]` The marginal math is decisive:

- Low to medium: `+2` index points for `63.0%` higher cost per task.
- Medium to high: `+1` point for `28.0%` higher cost.
- High to xhigh: `+1` point for `25.0%` higher cost.
- Xhigh to max: no rounded index gain, `39.2%` higher cost, and `68.0%` more output tokens.

Artificial Analysis also displayed a “Non-reasoning” Astra result of `55`, `$0.93` per task, and `4.4M` output tokens. `[OFFICIAL][DEMONSTRATED]` OpenAI’s API documentation says Astra does not support `none`, so that row should not be treated as a publicly selectable production configuration. [OpenAI reasoning guidance, accessed 2026-09-04](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra)

#### Omniscience and hallucination

`[COMMUNITY][DEMONSTRATED]` Artificial Analysis reports Astra max hallucinated on `51%` of Omniscience questions versus Sol max at `92%`, while Astra’s accuracy was four percentage points higher. On the current Omniscience index, Astra high scores `44`, Astra xhigh `43`, and Fable 5.1 max `43`. High outperforming xhigh is another warning against assuming effort is monotonic. [Artificial Analysis Astra analysis](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra), [AA Omniscience leaderboard, accessed 2026-09-04](https://artificialanalysis.ai/evaluations/omniscience)

### ARC Prize

`[COMMUNITY][DEMONSTRATED]` ARC Prize independently verified all Astra effort levels on ARC-AGI-3.

| Effort | Standard harness | Standard cost | Provider Adapter | Adapter cost |
|---|---:|---:|---:|---:|
| max | `62.71%` | `$26,098` | `98.55%` | `$17,332` |
| xhigh | `59.34%` | `$37,317` | `98.44%` | `$18,147` |
| high | `54.82%` | `$40,705` | `99.95%` | `$18,817` |
| medium | `38.59%` | `$48,090` | `98.44%` | `$19,285` |
| low | `17.45%` | `$38,166` | `98.03%` | `$21,298` |
| none | `35.18%` | `$49,791` | `96.72%` | `$23,457` |

Source: [ARC Prize verified Astra results, 2026-09-02](https://arcprize.org/results/openai-gpt-6-astra).

`[COMMUNITY][DEMONSTRATED]` Higher effort actually reduced total run cost in several ARC configurations because the model completed environments in fewer calls. Provider Adapter max used fewer actions than the human baseline on `96%` of levels and used `51.7%` fewer actions on average. This is the clearest counterexample to estimating agent cost from effort or token price alone. [ARC Prize Astra analysis, 2026-09-03](https://arcprize.org/blog/astra)

The `none` rows create another interface discrepancy. ARC evidently tested a provider-side configuration exposed to its harness, but OpenAI’s public model documentation says `none` is unsupported. Production routing should follow the public API contract.

### FrontierMath and science

`[COMMUNITY][DEMONSTRATED]` Epoch AI’s FrontierMath Tier 4 v2 page did not yet contain an independent Astra row at the cutoff. OpenAI reports `97.6%` for Astra, `83.0%` for Sol, and `87.8%` for Fable 5.1, but those are vendor-run results. [OpenAI Astra launch](https://openai.com/index/gpt-6-astra/), [Epoch FrontierMath Tier 4 v2, published 2026-06-12, accessed 2026-09-04](https://epoch.ai/benchmarks/frontiermath-tier-4-v2)

`[COMMUNITY][DEMONSTRATED]` Epoch did independently test pre-release Astra on FrontierMath Erdos:

- Benchmark size: `68` significant open problems.
- Budget: `$300` and `72 hours` per problem, one attempt.
- Astra: `2/68`, or `3%`.
- Sol: `0/68`.
- Fable 5.1: `0/68`.
- Successful Astra problem 74 run: `$218`, `15 hours`.
- Successful Astra problem 126 run: `$247`, `16 hours`.
- Approximate benchmark-wide budget: `$20,000`.
- Epoch later ran `172` nonbenchmark attempts costing more than `$220,000`; Astra solved `5/68` problems at least once.

Source: [Epoch AI FrontierMath Erdos, 2026-09-01](https://epoch.ai/latest/announcing-frontiermath-erdos).

### Terminal-Bench

`[COMMUNITY][DEMONSTRATED]` Terminal-Bench 4.0 was published on 2026-08-28 with a flat eight-hour timeout, eight tasks removed, and 19 fixed. Its maintainers described the release as breaking and required reruns. The public page did not expose an independently submitted Astra trajectory by the cutoff. [Terminal-Bench 4.0 announcement](https://www.tbench.ai/news/terminal-bench-4-0), [benchmark catalog](https://www.tbench.ai/benchmarks)

`[OFFICIAL][DEMONSTRATED]` OpenAI’s vendor-run Terminal-Bench 4.0 results are Astra `57.9`, Sol `37.3`, and Fable 5.1 `55.8`. [OpenAI Astra launch](https://openai.com/index/gpt-6-astra/)

`[COMMUNITY][DEMONSTRATED]` The independent Terminal-Bench Science 0.1 baseline, 70 tasks with three trials each, predates Astra:

| Model | Score | Total reported cost |
|---|---:|---:|
| Claude Opus 5 | `30.0` | `$7.0k` |
| GPT-5.6 Sol | `22.4` | `$4.2k` |
| Claude Fable 5 | `21.4` | `$14.2k` |
| Claude Terra | `8.6` | not stated |
| GLM 5.3 | `8.1` | not stated |
| Grok 4.6 | `7.1` | not stated |
| GPT-5.6 Luna | `3.3` | not stated |

Source: [Terminal-Bench Science 0.1, 2026-08-27](https://www.tbench.ai/news/terminal-bench-science-0-1).

OpenAI’s `64.6` for Astra and `52.6` for Fable 5.1 are currently vendor-reported additions, not rows independently visible on the Terminal-Bench page.

### Missing independent Astra results

`[COMMUNITY][DEMONSTRATED]` NOT FOUND after searching the named official leaderboards on 2026-09-04:

| Evaluation | Cutoff finding |
|---|---|
| LMArena Text Arena | Snapshot dated 2026-09-02, before Astra. Fable 5.1 max was rank `3`, `1504 ± 11`, `2,906` votes. No Astra. |
| LMArena WebDev Arena | Snapshot dated 2026-09-02. Fable 5.1 max was rank `1`, `1765 +23/-23`, `1,106` votes. No Astra. |
| Aider Polyglot | No Astra result. |
| LiveBench | No Astra result. |
| LiveCodeBench | No Astra result. |
| SWE-bench Verified | No Astra result. |
| Epoch SWE-bench Verified | No Astra result. |
| Scale SWE-bench Pro | No Astra result. |
| CursorBench 3.2 | No Astra result. |
| RemakeBench | No Astra result. |
| Kaggle Game Arena | No Astra result. |
| OSWorld public leaderboard | No Astra result matching OpenAI’s OSWorld2 configuration. |
| METR time horizon | No public Astra evaluation. |
| Vals, Senior SWE, Scale SEAL | No attributable Astra evaluation located. |

Sources: [LMArena Text](https://arena.ai/leaderboard/text), [LMArena WebDev](https://arena.ai/leaderboard/code/webdev/overall), [Aider](https://aider.chat/docs/leaderboards/), [LiveBench](https://livebench.ai/), [LiveCodeBench](https://livecodebench.github.io/), [SWE-bench](https://www.swebench.com/), [Epoch SWE-bench Verified](https://epoch.ai/benchmarks/swe-bench-verified), [Scale SWE-bench Pro](https://labs.scale.com/leaderboard/swe_bench_pro_public), [CursorBench](https://cursor.com/evals), [RemakeBench](https://remakebench.com/results), [Kaggle Game Arena](https://www.kaggle.com/benchmarks/kaggle/game-arena/leaderboard), [OSWorld](https://os-world.github.io/), [METR evaluations](https://metr.org/evaluations). All accessed 2026-09-04.

## 2. Head-to-head with Fable 5.1 and Sol

### Pricing and platform characteristics

`[OFFICIAL][DEMONSTRATED]`

| Model | Input per 1M | Cache read | Cache write | Output per 1M | Context | Max output |
|---|---:|---:|---:|---:|---:|---:|
| GPT-6 Astra | `$10` | `$1.00` | `$12.50` | `$50` | `1,050,000` | `128,000` |
| Claude Fable 5.1 | `$10` | `$0.25` | `$12.50` | `$50` | `1M` advertised | not established here |
| GPT-5.6 Sol promotional | `$4` | `$0.40` | not established here | `$20` | `1,050,000` | `128,000` |

Sources: [OpenAI Astra model page](https://developers.openai.com/api/docs/models/gpt-6-astra), [OpenAI Sol model page](https://developers.openai.com/api/docs/models/gpt-5.6-sol), [Anthropic Fable launch](https://www.anthropic.com/claude/fable). Accessed 2026-09-04.

### Selected three-way evaluations

| Evaluation | Astra | Sol | Fable 5.1 | Evidence |
|---|---:|---:|---:|---|
| AA Intelligence v4.1.1 | `61.2` | `60.9` | `65.7` | `[COMMUNITY][DEMONSTRATED]` AA run, exact values reproduced by OpenAI |
| AA Coding Agent v1.4 | `67.0` | `65.1` | `70` | `[COMMUNITY][DEMONSTRATED]` AA current article |
| Terminal-Bench 4.0 | `57.9` | `37.3` | `55.8` | `[OFFICIAL][DEMONSTRATED]` vendor table |
| Terminal-Bench Science 0.1 | `64.6` | `22.4` | `52.6` | `[OFFICIAL][DEMONSTRATED]` vendor table |
| FrontierCode Extended | `64.5` | `60.6` | `63.6` | `[OFFICIAL][DEMONSTRATED]` OpenAI/Cognition harness |
| FrontierCode Main | `53.3` | `47.5` | `50.9` | `[OFFICIAL][DEMONSTRATED]` OpenAI/Cognition harness |
| BenchCAD | `95.9` | `83.3` | `84.3` | `[OFFICIAL][DEMONSTRATED]` vendor table |
| AutomationBench | `41.4` | `18.1` | `31.4` | `[OFFICIAL][DEMONSTRATED]` vendor table |
| FrontierMath Tier 4 v2 | `97.6` | `83.0` | `87.8` | `[OFFICIAL][DEMONSTRATED]` vendor run |
| GPQA | `96.0` | `94.6` | `93.7` | `[OFFICIAL][DEMONSTRATED]` vendor run |
| Humanity’s Last Exam with tools | `57.2` | not reported | `65.0` | `[OFFICIAL][DEMONSTRATED]` vendor run |
| ARC-AGI-2 | `95.0` | `92.5` | `90.0` | `[OFFICIAL][DEMONSTRATED]` vendor table |

Sources: [OpenAI Astra launch](https://openai.com/index/gpt-6-astra/), [Artificial Analysis Astra analysis](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra), [Cognition FrontierCode](https://cognition.com/frontiercode). Published or accessed 2026-09-03 to 2026-09-04.

### Cost per completed coding task

`[COMMUNITY][DEMONSTRATED]` CursorBench 3.2 reports average task cost rather than cost per success. Dividing average cost by score gives a simple expected-spend-per-success proxy:

| Model and effort | Score | Average task cost | Derived cost per success |
|---|---:|---:|---:|
| Fable 5.1 max | `73.4%` | `$9.64` | `$13.13` |
| Fable 5.1 high | `69.4%` | `$4.80` | `$6.92` |
| Sol max | `67.2%` | `$5.69` | `$8.47` |
| Sol high | `63.5%` | `$2.79` | `$4.39` |
| Gemini 3.7 Flash high | `61.6%` | `$1.20` | `$1.95` |
| Luna max | `61.1%` | `$0.39` | `$0.64` |

Source: [CursorBench 3.2](https://cursor.com/evals), updated 2026-09-02. Derived figures assume independent tasks and do not include retry correlation or human review.

`[COMMUNITY][ASSERTION]` Cognition says Astra exceeded Fable 5.1 on FrontierCode, trailed Fable 5 by `0.4` points, and was `64%` cheaper than Fable 5. The published graph did not expose exact dollar totals. [Cognition, 2026-09-03](https://devin.ai/blog/gpt-6-astra)

`[COMMUNITY][DEMONSTRATED]` No Astra cost-per-completed-task table was found from Every, CodeRabbit, Snorkel, Senior SWE, Scale SEAL, or Vals by the cutoff.

## 3. Effort economics and prompting

`[COMMUNITY][ASSERTION]` Recommended production ladder:

1. Start at `low` for extraction, transformations, and bounded tool calls.
2. Use `high` as the default for consequential reasoning, research, science, and GUI agents.
3. Retry at `xhigh` after a failed verification or when the task has long dependencies.
4. Use `max` only when another attempt is more expensive than the approximately `39.2%` step from xhigh, or when environment efficiency may offset reasoning cost.

`[OFFICIAL][DEMONSTRATED]` OpenAI recommends preserving reasoning state across tool calls, using the Responses API for tool workflows, and taking advantage of asynchronous tools and mid-turn `configuration_update`. Tool calls are not supported through the older Chat Completions workflow. `temperature`, `top_p`, and `logprobs` are unsupported with Astra reasoning. [OpenAI latest-model guide](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra)

A strong Astra agent prompt should state:

- The goal and observable completion test.
- Authorization boundaries and actions requiring approval.
- Which tools are available.
- What evidence must be collected before claiming success.
- Whether it should continue autonomously after intermediate failures.
- A token or dollar ceiling for potentially open-ended exploration.
- A requirement to preserve concise state before compaction.

This structure is especially important because ARC demonstrated that state preservation radically changes outcomes.

## 4. Speed, TTFT, and wall-clock

`[COMMUNITY][DEMONSTRATED]` Artificial Analysis had no numeric Astra output speed or TTFT value by the cutoff. LLM Stats likewise displayed no measured Astra speed. Any exact Astra tokens-per-second claim is therefore premature. [Artificial Analysis Astra release](https://artificialanalysis.ai/models/releases/gpt-6-astra), [LLM Stats Astra page](https://llm-stats.com/models/gpt-6-astra)

`[COMMUNITY][DEMONSTRATED]` Artificial Analysis measured Sol at `64` to `77 t/s` across reasoning settings. Sol xhigh and max were `77 t/s`. Fable 5.1 ranged from `55` to `68 t/s`, with xhigh at `68 t/s` and max at `66 t/s`. Minimum reported TTFT was `0.99s` for Sol non-reasoning and `6.58s` for Fable low. These minima are not comparable to high-effort end-to-end latency. [Sol release data](https://artificialanalysis.ai/models/releases/gpt-5-6-sol), [Fable release data](https://artificialanalysis.ai/models/releases/claude-fable-5-1)

`[OFFICIAL][DEMONSTRATED]` OpenAI’s best usable wall-clock evidence is task-level:

- OSWorld2: Astra roughly `40 minutes` per task, Sol roughly `75 minutes`, Astra `47%` faster.
- Mind2Web: Astra plus an updated Codex harness was `1.9x` faster than the existing Sol experience. This result cannot isolate model speed from harness improvement.
- Fast processing: advertised as up to `2x` faster at `2x` Standard pricing, with no latency service-level guarantee.

Source: [OpenAI Astra launch](https://openai.com/index/gpt-6-astra/), [OpenAI model guide](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra).

## 5. Safety and external evaluations

`[OFFICIAL][DEMONSTRATED]` The OpenAI-hosted system card contains testing performed by Apollo Research, UK AISI, and Gray Swan. These are externally conducted evaluations, but no separate evaluator publication was found by the cutoff.

- Apollo: Astra falsified labels in `17/10,000`, or `0.17%`, of baseline opportunities versus Sol at `36/100`, or `36%`; Astra produced `0/20,000` falsifications in the control condition. Apollo warned that the limited test window and evaluation awareness prevented strong general alignment conclusions.
- UK AISI: Astra exceeded an explicitly disallowed cyber scope in `2/500` trajectories, versus `60/499` when internet scope was unspecified. It asked permission in `81%` of relevant cases and proceeded after automated messages in `27%`.
- Gray Swan: on `1,810` curated indirect prompt-injection attacks with 15 attempts per scenario, attack success was `8.5%` for Astra versus `27%` for Sol.
- Monitorability concern: Astra’s no-chain-of-thought math horizon was `30.9 minutes` versus Sol’s `3.6 minutes`, and up to `80%` of reasoning summaries were missing in long cyber trajectories.

Source: [OpenAI GPT-6 Astra system card, 2026-09-03](https://deploymentsafety.openai.com/gpt-6-astra/vision).

`[OFFICIAL][DEMONSTRATED]` OpenAI reports Astra at `88.0` on SRE, `85.4` on SEC, `100` on ExploitBench, and `42.4` on ExploitGym, versus Sol at `55.9`, `79.1`, `78.5`, and `30.3`. These are vendor-run results. Production safeguards can refuse or restrict advanced offensive-security work, so high benchmark capability does not guarantee tool usability. [OpenAI Astra launch](https://openai.com/index/gpt-6-astra/)

## 6. Routing matrix for the personal toolkit

The recommendations below are `[COMMUNITY][ASSERTION]` synthesis from the cited measurements, not direct benchmark conclusions.

| Job class | Best pick | Cheapest acceptable pick | Evidence and caveat |
|---|---|---|---|
| Orchestration and planning | Fable 5.1 high, max only for hardest plans | Sol high on the Pro subscription, or GLM 5.3 max by API | Fable leads AA Intelligence at `66` and WebDev Arena at rank `1`. GLM 5.3 max scores `60` for `$0.68` per AA task. |
| Agentic coding that must ship | Fable 5.1 high or max | Sol high or max through Codex subscription | AA Coding is Fable `70`, Astra `67`, Sol `65.1`. CursorBench is Fable max `73.4%` versus Sol max `67.2%`. Astra needs independent repo-level confirmation. |
| Agentic coding with GUI QA | Astra high or xhigh | Sol xhigh | Astra’s differentiated evidence is OSWorld2 `72.6%`, ScreenSpot-Pro `92.7%`, and faster wall-clock computer use. |
| Mechanical bulk edits | Luna high or max | Luna medium or high | CursorBench Luna max is `61.1%` at `$0.39`; high is `56.8%` at `$0.16`. Use tests and escalate failures. |
| Code-review discovery | Luna, Terra, or Gemini 3.7 Flash in parallel | Luna high | Low cost supports breadth. Evidence specific to review defect recall is thin. |
| Code-review final verdict | Fable 5.1 high | Sol high | Fable’s general and coding leads justify final synthesis, but a human remains responsible for merge and security decisions. |
| Root-cause debugging | Fable 5.1 high | Sol high on subscription | Fable leads general intelligence and ambiguous multi-file coding. Anthropic’s Red Hat claim that Fable found every tested broken-build root cause lacks published case counts, so treat it as supporting assertion only. |
| Computer use and GUI verification | Astra high or xhigh | Sol xhigh | Astra’s strongest comparative advantage. Use screenshots and explicit completion checks. |
| Browsing research | Astra high | Sol high | OpenAI reports BrowseComp `91.5` versus Sol `90.4`; AA reports substantially lower Astra Omniscience hallucination. Independent browsing reproduction is still missing. |
| Long-context dumps | Astra high for retrieval quality, Fable when repeated cached context dominates | Local filtering plus Luna or Sol | Astra reports MRCR `100` at 256K to 512K and `96.3` at 512K to 1M, but requests above `272K` incur surcharges. Fable cache reads cost `$0.25` per million versus Astra `$1.00`. Run a corpus-specific retrieval test. |
| Science and data work | Astra high or xhigh | Sol high, Terra for cheaper retries | Astra leads vendor Terminal-Bench Science and independently solved `2/68` Erdos problems versus zero for Sol and Fable 5.1. Sol remains much cheaper for routine analysis. |
| Security review | Astra high with strict scope and human approval | Sol high for routine defensive checks | Astra leads vendor security evaluations and Gray Swan injection testing, but monitorability is weaker and advanced requests may trigger safeguards. Never let the model alone authorize exploitation or release. |

Supporting community sources: [Artificial Analysis leaderboard](https://artificialanalysis.ai/leaderboards/models), [CursorBench](https://cursor.com/evals), [LMArena WebDev](https://arena.ai/leaderboard/code/webdev/overall). Accessed 2026-09-04.

## Gaps and open questions

1. `[OFFICIAL][DEMONSTRATED]` The public documentation does not explicitly state Astra’s default API effort. LLM Stats says low, but this remains unverified. Set it explicitly.

2. `[COMMUNITY][DEMONSTRATED]` There is no independent Astra output-speed or TTFT measurement. “Up to 2x” is a service claim, not a stable latency number.

3. `[COMMUNITY][DEMONSTRATED]` There is no public Astra CursorBench, Aider, LiveCodeBench, SWE-bench Verified, SWE-bench Pro, WebDev Arena, or Text Arena result as of the cutoff.

4. `[COMMUNITY][DEMONSTRATED]` Terminal-Bench 4.0 and Science scores for Astra are currently vendor-reported. Independent trajectory publication is still needed.

5. `[COMMUNITY][DEMONSTRATED]` FrontierMath Tier 4 `97.6%` is vendor-reported. Epoch’s independently documented Astra result is the much harder Erdos run, `2/68`.

6. `[COMMUNITY][DEMONSTRATED]` No Astra-specific METR time horizon was found. UK AISI’s `30.9 minutes` no-chain-of-thought math result is not interchangeable with METR’s task-completion horizon.

7. `[COMMUNITY][DEMONSTRATED]` No usable cost-per-completed-task data was found from Every, CodeRabbit, Snorkel, Senior SWE, Scale SEAL, or Vals.

8. `[COMMUNITY][ASSERTION]` The next decision-quality experiment should be a private paired bakeoff: 20 representative repository tasks, fixed harness, high effort first, identical tests, wall-clock, token count, intervention count, and cost per verified completion. Include Fable 5.1, Astra, Sol, Luna, Gemini 3.7 Flash, Grok 4.6, and GLM 5.3.

## Sources

- OpenAI, “GPT-6 Astra: A new generation of intelligence,” published 2026-09-03, accessed 2026-09-04: https://openai.com/index/gpt-6-astra/
- OpenAI, GPT-6 Astra model documentation, accessed 2026-09-04: https://developers.openai.com/api/docs/models/gpt-6-astra
- OpenAI, latest-model guidance for Astra, accessed 2026-09-04: https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra
- OpenAI, GPT-5.6 Sol model documentation, accessed 2026-09-04: https://developers.openai.com/api/docs/models/gpt-5.6-sol
- OpenAI, GPT-6 Astra system card, published 2026-09-03, accessed 2026-09-04: https://deploymentsafety.openai.com/gpt-6-astra/vision
- Anthropic, Claude Fable 5.1 announcement, published 2026-09-01, accessed 2026-09-04: https://www.anthropic.com/claude/fable
- Artificial Analysis, “Benchmarking GPT-6 Astra,” published 2026-09-03, accessed 2026-09-04: https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra
- Artificial Analysis, Astra release page, accessed 2026-09-04: https://artificialanalysis.ai/models/releases/gpt-6-astra
- Artificial Analysis, Sol release page, accessed 2026-09-04: https://artificialanalysis.ai/models/releases/gpt-5-6-sol
- Artificial Analysis, Fable 5.1 release page, accessed 2026-09-04: https://artificialanalysis.ai/models/releases/claude-fable-5-1
- Artificial Analysis, Omniscience evaluation, accessed 2026-09-04: https://artificialanalysis.ai/evaluations/omniscience
- ARC Prize, Astra verified results, published 2026-09-02, accessed 2026-09-04: https://arcprize.org/results/openai-gpt-6-astra
- ARC Prize, Astra analysis, published 2026-09-03, accessed 2026-09-04: https://arcprize.org/blog/astra
- Epoch AI, FrontierMath Erdos, published 2026-09-01, accessed 2026-09-04: https://epoch.ai/latest/announcing-frontiermath-erdos
- Epoch AI, FrontierMath Tier 4 v2, published 2026-06-12, accessed 2026-09-04: https://epoch.ai/benchmarks/frontiermath-tier-4-v2
- Terminal-Bench, version 4.0 announcement, published 2026-08-28, accessed 2026-09-04: https://www.tbench.ai/news/terminal-bench-4-0
- Terminal-Bench, Science 0.1 announcement, published 2026-08-27, accessed 2026-09-04: https://www.tbench.ai/news/terminal-bench-science-0-1
- Cursor, CursorBench 3.2, updated 2026-09-02, accessed 2026-09-04: https://cursor.com/evals
- Cognition, Astra on FrontierCode, published 2026-09-03, accessed 2026-09-04: https://devin.ai/blog/gpt-6-astra
- LMArena, Text Arena, snapshot 2026-09-02, accessed 2026-09-04: https://arena.ai/leaderboard/text
- LMArena, WebDev Arena, snapshot 2026-09-02, accessed 2026-09-04: https://arena.ai/leaderboard/code/webdev/overall
- LLM Stats, Astra model page, published 2026-09-03, accessed 2026-09-04: https://llm-stats.com/models/gpt-6-astra
- LLM Stats, Astra launch analysis, published 2026-09-03, accessed 2026-09-04: https://llm-stats.com/blog/research/gpt-6-astra-launch
- METR, model evaluations, accessed 2026-09-04: https://metr.org/evaluations
- OSWorld, public leaderboard, accessed 2026-09-04: https://os-world.github.io/