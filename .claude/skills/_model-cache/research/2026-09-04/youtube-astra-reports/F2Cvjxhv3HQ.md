## Video: 【速報】GPT-6 Astra登場 異次元のベンチスコア ダントツの最強モデル, AI Jitan Lab
**URL:** https://www.youtube.com/watch?v=F2Cvjxhv3HQ  **Views:** 2314  **Date:** 20260903  **Length:** 22:08
**ADDRESSES GOAL:** partially, provides comprehensive launch benchmark figures, API costs, harness configurations, and refusal/safety parameters, but lacks live execution tests.
**HANDS-ON:** no (reaction only to OpenAI official blog and Artificial Analysis data)

### Demonstrated findings (with timestamps)
- [01:51] Displayed official benchmark comparison table contrasting GPT-6 Astra against GPT-5.6 Sol, Claude Fable 5.1, Claude Fable 5, Claude Opus 5, and Gemini 3.8 Flash.
- [02:10] Displayed Terminal-Bench Science 0.1 graph showing Astra at 64.6% vs Fable 5.1 at 52.6% across API cost.
- [02:44] Displayed Terminal-Bench 4.0 graph showing Astra at 57.9% ($7.50 API cost) vs Fable 5.1 at 55.8% ($19.50 API cost) and Opus 5 at 52.3%.
- [03:10] Displayed AutomationBench graph showing Astra at 41.4% vs Fable 5.1 at 31.4%.
- [03:22] Displayed BenchCAD graph showing Astra at 95.9% vs Sol at 83.3% and Fable 5.1 at 84.3%.
- [03:49] Displayed DeepSWE v1.1 token efficiency graph showing Astra reaching 0.73 score with ~26k output tokens, whereas Opus 5 requires ~64k tokens for 0.73.
- [04:07] Displayed OSWorld 2.0 (Offline) graph showing Astra achieving 72.6% in ~40 min vs Sol at 65.7% in ~75 min and Opus 5 at 70.2%.
- [05:29] Displayed computer usage benchmark table showing Astra at 59.3% on Agents' Last Exam vs Opus 5 at 55.5%.
- [05:50] Displayed ScreenSpot-Pro graph showing Astra at 92.7% vs Sol at 76.9%.
- [06:02] Displayed BrowseComp graph showing Astra at 91.5% vs Opus 5 at 90.8% and Sol at 90.4%.
- [06:13] Displayed ARC-AGI-3 chart showing Astra at 99.9% vs Opus 5 at 30.2% and Sol at 7.8%.
- [06:37] Displayed reasoning table showing FrontierMath Tier 4 (97.6% Astra vs 87.8% Fable 5.1) and ARC-AGI-2 (95.0% Astra vs 90.0% Fable 5.1).
- [07:01] Displayed GPQA Diamond graph showing Astra at 96.0% (and 94.9% in low-cost mode) vs Sol at 94.6%.
- [07:24] Displayed HealthBench Professional table showing Astra at 63.4% vs Sol at 60.5%, Fable 5 at 60.9%, and Fable 5.1 at 56.6%.
- [07:43] Displayed MRCR long-context retrieval table showing Astra at 100.0% (256k to 512k tokens) and 96.3% (512k to 1M tokens) vs Sol at 91.5% and 73.8%.
- [08:07] Displayed benchmark rows where Astra loses, including Artificial Analysis Intelligence Index (Astra 61.2 vs Fable 5.1 65.7) and Humanity's Last Exam with tools (Astra 57.2% vs Fable 5.1 65.0%).
- [08:49] Displayed FrontierCode table showing FrontierCode Extended (Astra 64.5% vs Fable 5 64.9%) and FrontierCode Main (Astra 53.3% vs Fable 5 53.5%).
- [09:11] Displayed Artificial Analysis Coding Agent Index v1.4 graph showing Astra at 67.0 vs Opus 5 at 68.1 and Fable 5 at 67.2.
- [15:39] Displayed cybersecurity evaluation table showing ExploitBench (Astra 100.0% vs Sol 78.5%), ExploitGym (Astra 42.4% vs Sol 30.3%), SRE-Bench (Astra 88.0% 1-attempt, 99.2% 4-attempts vs Sol 55.9% / 68.7%), and SEC-Bench Pro (Astra 85.4% vs Sol 79.1%).
- [17:58] Displayed alignment table showing untoward action rate on adversarial computer tasks at 2.4% for Astra vs 9.5% for Fable 5.1 and 22.0% for Sol.
- [18:34] Displayed auto-review circumvention chart showing Astra at 0.00% vs Sol at 0.29%.
- [19:04] Displayed ExploitGym honeypot chart showing Astra at 0.0% unauthorized targeting vs Sol at 48.2% without guardrails.
- [19:20] Displayed capability hallucination graph showing Astra error rate dropping to 4.2% vs Sol at 12.2%.
- [20:38] Displayed third-party Artificial Analysis overall ranking chart placing Astra in 5th place (Score: 61) behind Fable 5.1 (66), Opus 5 (63), and Fable 5 (62). Coding agent ranking shows Astra in Codex at 67 (5th) vs Fable 5.1 in Claude Code at 70 (1st).

### Asserted claims (with timestamps)
- [00:43] Official blog claims GPT-6 Astra is "the world's smartest and most aligned model" across 6 domains.
- [01:36] OpenAI official post on X asserted: "Whatever can be done on a computer, Astra does it for you. Fast."
- [02:26] Estimated API cost of Astra on Terminal-Bench Science is roughly 31% cheaper than Fable 5.1.
- [02:56] Terminal-Bench 4.0 execution cost for Astra is 9% cheaper than Sol and 63% cheaper than Fable 5.1.
- [03:32] BenchCAD cost is 43% cheaper than Sol and 86% cheaper than Fable 5.1.
- [05:12] Codex CLI harness updates allow Astra to complete Mind2Web tasks 1.9x faster than Sol.
- [05:41] Astra consumes approximately 65% fewer output tokens than Opus 5 on Agent Last Exam tasks.
- [06:26] Footnote 1 notes ARC-AGI-3 99.9% score was achieved using a custom Responses API harness with 2 parameter adjustments.
- [10:12] Footnote 2 clarifies that all official benchmark table scores represent maximum effort settings.
- [10:50] Pricing is set at $10 / 1M input tokens and $50 / 1M output tokens on direct API and Amazon Bedrock.
- [11:17] Fast Mode offers up to 2.5x speed at 2x price markup.
- [11:26] Zero Data Retention (ZDR) and confidential monitoring features are available for enterprise/eligible API users.
- [12:35] Model features proactive clarification: asks targeted questions only on ambiguous steps that alter outcomes while continuing execution in parallel.
- [13:08] Codex CLI introduces a new context compaction mechanism saving search notes rather than overwriting context windows.
- [13:27] Enterprise partner Jane Street noted fewer rework cycles to reach production quality; Higgsfield AI claimed complex workflows required up to 20% fewer tokens.
- [17:18] Public API model refuses exploit creation and offensive payloads; defense features are gated under the Daybreak program.
- [19:35] System card admits chain-of-thought monitoring legibility decreased compared to Sol due to shorter reasoning traces.

### Strengths of Astra reported
- Leading efficiency: matches or beats top models using 20% to 65% fewer output tokens.
- Strong OS/computer operation capabilities (72.6% OSWorld Offline, 92.7% ScreenSpot-Pro).
- Math and scientific reasoning (97.6% FrontierMath Tier 4, 96.0% GPQA Diamond, 64.6% Terminal-Bench Science).
- Large context reliability: 96.3% MRCR needle retrieval at 1M tokens.
- Resilient task adherence: maintains original objective when given mid-task user edits.
- Low safety violation rate: 0.00% review circumvention, 0.0% out-of-bounds honeypot targeting.

### Weaknesses, failures, refusals, costs reported
- Artificial Analysis composite benchmarks place Astra 5th (61) behind Claude Fable 5.1 (66) and Claude Opus 5 (63).
- Coding agent score in Claude Code (Fable 5.1 at 70) beats Astra in Codex CLI (67).
- Losses on broad human knowledge benchmarks: Humanity's Last Exam with tools is 57.2% vs Fable 5.1 at 65.0%.
- Base API price is 2.5x higher than GPT-5.6 Sol ($10/$50 vs $4/$20 per 1M tokens); Fast Mode doubles cost ($20/$100).
- Standard public API refuses exploit generation, reverse engineering vulnerability POCs, and unverified penetration actions.
- Reasoning visibility decreased: monitorability of reasoning chains declined relative to Sol.

### How-to-get-the-max tips (effort, prompts, harness, settings)
- Codex CLI setting: enable experimental context window note preservation via `config.toml` [13:18].
- ARC-AGI-3 / Reasoning: use OpenAI Responses API custom harness with 2 setting adjustments rather than bare chat completions [06:26].
- Prompting: give overarching project context upfront; Astra handles mid-task refinements without forgetting root goals [12:54].
- Enterprise gating: Enterprise workspace admins must manually toggle Astra access in admin settings [10:41].
- Defensive security: apply to the Daybreak access tier to bypass standard vulnerability testing refusals [17:28].
- Cost optimization: use low-effort/low-cost settings for academic reasoning tasks like GPQA Diamond (retains 94.9% accuracy at 37% discount) [07:09].

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- Terminal-Bench Science 0.1: Astra 64.6% vs Fable 5.1 52.6% vs Sol 22.4% [02:10]
- Terminal-Bench 4.0: Astra 57.9% vs Fable 5.1 55.8% vs Opus 5 52.3% [02:44]
- AutomationBench: Astra 41.4% vs Fable 5.1 31.4% vs Opus 5 26.9% [03:10]
- BenchCAD: Astra 95.9% vs Fable 5.1 84.3% vs Sol 83.3% [03:22]
- DeepSWE v1.1: Astra 74.1% vs Gemini 3.8 Flash 73.8% vs Opus 5 73.7% [03:49]
- OSWorld 2.0 Offline: Astra 72.6% vs Opus 5 70.2% vs Sol 65.7% [04:07]
- ARC-AGI-3: Astra 99.9% vs Opus 5 30.2% vs Sol 7.8% [06:13]
- ARC-AGI-2: Astra 95.0% vs Sol 92.5% vs Fable 5.1 90.0% [06:37]
- FrontierMath Tier 4: Astra 97.6% vs Fable 5.1 87.8% vs Sol 83.0% [06:48]
- GPQA Diamond: Astra 96.0% vs Sol 94.6% vs Opus 5 93.7% [07:01]
- HealthBench Professional: Astra 63.4% vs Fable 5 60.9% vs Sol 60.5% vs Fable 5.1 56.6% [07:24]
- Artificial Analysis Intelligence Index: Fable 5.1 65.7 vs Opus 5 63.1 vs Fable 5 62.1 vs Astra 61.2 [08:10]
- Humanity's Last Exam (tools): Fable 5.1 65.0% vs Fable 5 63.8% vs Opus 5 63.6% vs Astra 57.2% [08:31]
- FrontierCode Extended: Fable 5 64.9% vs Astra 64.5% vs Sol 60.6% [08:49]
- FrontierCode Main: Fable 5 53.5% vs Opus 5 53.4% vs Astra 53.3% [08:57]
- Artificial Analysis Coding Agent Index: Fable 5.1 in Claude Code 70 vs Opus 5 68 vs Astra in Codex 67 [21:05]
- API Pricing: Astra ($10/$50 per 1M tokens) equals Fable 5.1 ($10/$50), while Sol is cheaper ($4/$20) [10:50, 11:07]

### What the comments add (corrections, counter-evidence, first-hand reports)
- Disbelief regarding 99.9% ARC-AGI-3 score, suspecting harness overfitting or presentation bias (@宮川あかーん-z7j, @jaeonajiw).
- User skepticism urging patience for third-party developer reviews over vendor announcement slides (@deltacs4934).
- Observations questioning whether Anthropic models (Fable 5.1) retain superior intuitive intent comprehension (@えるふぃ-i9f).
- Preparation for high Pro subscription pricing and usage caps (@monamarusan).

### Confidence in this source (1-5) and why
2/5. The video provides high fidelity reporting of official OpenAI charts and Day 1 Artificial Analysis data, but includes zero hands-on validation, independent API runs, or objective testing.
