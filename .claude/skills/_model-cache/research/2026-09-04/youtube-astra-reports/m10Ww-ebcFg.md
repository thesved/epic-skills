## Video: 【既に賛否両論】『GPT-6 Astra』が 発表！性能も圧倒的でサイバー性能が大幅向上！解説します, まさおAIじっくり解説ch
**URL:** https://www.youtube.com/watch?v=m10Ww-ebcFg  **Views:** 12  **Date:** 20260903  **Length:** 13:29
**ADDRESSES GOAL:** partially, provides official benchmark numbers, early tester quotes, and pricing comparisons vs Fable 5.1 and Sol, but lacks original hands-on testing.
**HANDS-ON:** no (reaction only; presenter states at 00:08 that Pro plan users cannot access Astra yet on launch day)

### Demonstrated findings (with timestamps)
The presenter did not run live model invocations, showing only slides and official web pages:
- [01:45-02:18] Scrolled OpenAI official launch post showing AutomationBench and Terminal-Bench graphs.
- [02:44-03:44] Displayed Artificial Analysis Intelligence Index page showing Astra at 61 index score and $1.67 cost per task.
- [03:51-04:36] Displayed comparison slide plots for Terminal-Bench 4.0, ExploitBench, BenchCAD, and GPQA Diamond.
- [06:01-06:14] Displayed ARC-AGI-3 leaderboard slide detailing test condition costs.
- [07:17-07:36] Displayed Codex side-by-side prompt execution slide comparing Sol vs Astra question workflows.

### Asserted claims (with timestamps)
- [00:08] Launch day general/Pro tier access was not open; immediate access was restricted to select enterprise partners (Daybreak) [07:42].
- [03:28, 07:41] Pricing asserted from spec tables: Standard mode is $10 input / $50 output per 1M tokens (2.5x of Sol, identical to Claude Fable 5.1). Fast mode is $20 input / $100 output per 1M tokens.
- [06:14-06:40] ARC-AGI-3 99.9% score requires state-retention mode costing roughly $360 per game (standard measurement yields 62.7%).
- [07:20-07:33] In Codex CLI, Astra asks clarifying questions without halting task execution, proceeding with plausible assumptions if unanswered.
- [09:09-09:29] Internal reasoning token structure ("recurrent depth") processes thoughts internally without text CoT tokens, increasing token efficiency but complicating chain-of-thought monitoring.
- [10:04-10:55] Quoted early tester impressions:
  - Theo (t3.gg): "史上最も賢い。癖と粗さもあるが、時にAGIの片鱗を感じる"
  - Matt Shumer: "バックエンドとPC操作はFable 5より上。見た目と3D素材はClaudeが上。速度は遅い"
  - Dan Shipper (Every): "Solから大きな進歩。いらつく癖があり、最上位ではFableに届かない"

### Strengths of Astra reported
- **Cybersecurity & Exploits:** ExploitBench reached 100% vs Sol's 78.5% [04:23, 06:06]; discovered 2 zero-days during internal evaluation [08:37].
- **Computer & Terminal Use:** OSWorld 2.0 at 72.6% vs Sol 65.7% and Fable 5.1 70.2% [05:21, 06:48]; Terminal-Bench 4.0 at 57.7% vs Sol 37.3% and Fable 5.1 55.8% [03:51].
- **Engineering CAD:** BenchCAD achieved 95.9% vs Fable 5.1 84.3% at 86% lower estimated API cost [04:36].
- **Token Efficiency:** Higher task accuracy achieved with significantly fewer output tokens compared to Fable 5.1 [01:48-02:04].
- **Permission Discipline:** Honeypot out-of-scope actions dropped from 48.2% (Sol) to 0.0% (Astra) [08:40]; Codex auto-review circumvention dropped from 0.3% to 0.0% [08:40].

### Weaknesses, failures, refusals, costs reported
- **Composite Benchmark Deficits:** Artificial Analysis Intelligence Index is 61.2, essentially flat vs Sol (60.9) and trailing Fable 5.1 (65.7) [05:23, 06:48].
- **Academic Reasoning Gaps:** Humanity's Last Exam scored 57.2% vs Sol 65.0% and Fable 5.1 63.8% [06:48].
- **High Price:** 2.5x cost increase over Sol ($10/$50 per 1M tokens) [07:41].
- **Output Inspection & Drift:** Internal recurrent reasoning hides CoT text, raising safety and alignment inspection concerns [09:09-09:54].
- **Speed & Frontend Quality:** Testers reported slow baseline execution speed and inferior visual/3D frontend styling compared to Claude [10:36-10:45].

### How-to-get-the-max tips (effort, prompts, harness, settings)
- **Codex Non-Blocking Inquiries:** Take advantage of Astra continuing work while asking questions; user intervention is only needed for critical branching [07:20].
- **Token Budget Routing:** Route repetitive terminal operations, CAD generation, and backend coding to Astra to leverage high accuracy at lower output token consumption [01:48, 04:36].
- **Harness Verification:** For high-difficulty evaluation, ARC-AGI-3 style stateful memory harnesses drastically raise performance over zero-state prompts, albeit at higher run cost ($360/game) [06:14-06:40].

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- **API Cost (per 1M tokens):** Astra standard $10/$50; Sol 2.5x cheaper; Fable 5.1 $10/$50 (identical) [07:41].
- **Artificial Analysis Intelligence Index:** Astra 61.2, Sol 60.9, Fable 5.1 65.7 [05:23, 06:48].
- **Terminal-Bench 4.0:** Astra 57.7%, Fable 5.1 55.8%, Sol 37.3% [03:51].
- **OSWorld 2.0:** Astra 72.6%, Sol 65.7%, Fable 5.1 70.2%, Claude Opus 5 70.2% [05:21, 06:48].
- **DeepSWE v1.1:** Astra 74.1%, Sol 72.7%, Fable 5.1 67.4% [06:48].
- **FrontierMath Tier 4:** Astra 97.6%, Sol 83.0%, Fable 5.1 87.8%, Claude Opus 5 73.2% [02:29, 06:48].
- **Humanity's Last Exam:** Astra 57.2%, Sol 65.0%, Fable 5.1 63.8%, Claude Opus 5 63.6% [06:00, 06:48].
- **ARC-AGI-3:** Astra 99.9% (stateful, $360) / 62.7% (standard), Sol 7.8%, Claude Opus 5 30.2% [06:01-06:14].
- **BenchCAD:** Astra 95.9%, Fable 5.1 84.3% [04:36].
- **GPQA Diamond:** Astra 96.0%, Sol 94.6%, Fable 5.1 93.7%, Claude Opus 5 92.6% [04:36, 06:00].
- **ExploitBench:** Astra 100%, Sol 78.5%, Claude Opus 5 70.0% [04:23, 06:06].

### What the comments add (corrections, counter-evidence, first-hand reports)
- User @usayas1331 reports preferring Astra due to superior cost-performance over Fable, noting practical availability issues accessing Fable despite subscribing to both.
- User @JS-hg2vn highlights semantic drift as the main operational bottleneck requiring improvement.
- User @helvetica4605 notes that modern frontier models no longer need to beat competitors on every single metric to remain useful.
- User @sinoda1114 comments on the intense competition during release week.

### Confidence in this source (1-5) and why
**2/5.** The presenter had zero hands-on access to the model at recording time, functioning purely as a second-hand aggregator of OpenAI launch slides, Artificial Analysis leaderboards, and initial X/Twitter reactions. Accurate for quoted day-1 metrics, but provides no independent empirical validation.
