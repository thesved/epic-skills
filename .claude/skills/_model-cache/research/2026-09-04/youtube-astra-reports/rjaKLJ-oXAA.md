## Video: GPT-6 Astra Benchmarks: What the Al Industry Won't Tell You, Daniel Jindoo 
**URL:** https://www.youtube.com/watch?v=rjaKLJ-oXAA  **Views:** 1  **Date:** 20260903  **Length:** 19:39
**ADDRESSES GOAL:** partially, provides official and third-party benchmark data comparing Astra to Fable 5.1 and Sol across agentic tasks, but lacks hands-on orchestration workflows.
**HANDS-ON:** no (reaction only to announcement data, despite showing a brief screenshot of an Astra test lab and claiming use limits).

### Demonstrated findings (with timestamps)
- [00:20, 03:08] Displayed benchmark table comparing GPT-6 Astra across multiple evals including ARC-AGI-3, FrontierMath Tier 4, Agents' Last Exam, DeepSWE v1.1, and SRE-Bench.
- [01:42] Played through interactive environment level on ARC-AGI-3 website.
- [07:33, 08:03] Showcased DeepSWE leaderboard showing pass rates, average cost per task, token output, and reasoning effort levels.
- [14:44] Displayed OpenAI launch documentation covering internal circumvention and alignment benchmarks.

### Asserted claims (with timestamps)
- [01:28] Claimed ARC-AGI-3 test rerun yielded "99.9" percent.
- [05:01, 16:09] Asserted that only DeepSWE and Agents' Last Exam are fully trustworthy benchmarks.
- [17:42] Claimed GPT-6 Astra cost equals Claude Fable 5.1 pricing for input and output tokens.
- [18:40] Asserted that test harnesses significantly alter benchmark outcomes, citing Opus 5 reaching 100% on ARC-AGI-3 under custom test harnesses.

### Strengths of Astra reported
- ARC-AGI-3 score of 98.6% (and 99.9% on rerun) [01:21, 01:31].
- FrontierMath Tier 4 (v2) score of 97.6% [02:30].
- Agents' Last Exam score of 59.3% [03:21].
- Terminal-Bench Science 0.1 score of 64.6% [06:06].
- DeepSWE v1.1 score of 74.1% [06:56].
- SRE-Bench (four attempts) score of 99.2% [08:28].
- ExploitBench score of 100.0% [13:41].
- Auto-review circumvention rate of 0% [15:03].

### Weaknesses, failures, refusals, costs reported
- Modest relative gain on DeepSWE over GPT-5.6 Sol (74.1% vs 70.8%, a 4.3% increase) [07:09, 16:24].
- Performance on GeneBench Pro sits at 39.0% [10:02].
- Expensive token pricing on par with Claude Fable 5.1 [17:42, 18:13].
- Rapid quota exhaustion on subscription tiers within 40 minutes [18:18].

### How-to-get-the-max tips (effort, prompts, harness, settings)
- Custom evaluation harnesses alter output quality significantly [18:46].
- Evaluate tasks between local models and frontier cloud models rather than routing all workloads to top-tier models [17:03].

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- ARC-AGI-3: Astra 98.6% vs Sol 7.8% vs Fable 5.1 (High) 30.2% [00:39].
- FrontierMath Tier 4 (v2): Astra 97.6% vs Sol 83.0% vs Fable 5.1 87.8% (High: 87.8%) vs Opus 5 73.2% [00:39].
- GPQA Diamond: Astra 96.0% vs Sol 94.0% vs Fable 5.1 92.7% (High: 92.0%) vs Opus 5 95.3% [00:39].
- Agents' Last Exam: Astra 59.3% vs Sol 52.7% vs Fable 5.1 48.7% (High: 52.7%) vs Opus 5 52.7% [03:08].
- AutomationBench: Astra 41.4% vs Sol 18.1% vs Fable 5.1 31.4% (High: 17.4%) vs Opus 5 26.9% [03:08].
- Terminal-Bench Science 0.1: Astra 64.6% vs Sol 22.4% vs Fable 5.1 52.6% (High: 24.7%) vs Opus 5 29.0% [03:08].
- DeepSWE v1.1: Astra 74.1% vs Sol 70.8% vs Fable 5.1 67.4% vs Opus 5 69.9% vs Gemini 3.8 Flash 73.7% [06:38].
- SRE-Bench: Astra 99.2% vs Sol 68.7% [06:38].
- ExploitBench: Astra 100.0% vs Sol 78.5% vs Opus 5 70% [13:08].

### What the comments add (corrections, counter-evidence, first-hand reports)
- Creator @Jinni_Doo reiterates skepticism of industry evaluations, stating only DeepSWE and Agent's Last Exam are reliable.

### Confidence in this source (1-5) and why
- 3 out of 5. The presenter provides an organized synthesis of published benchmark data across frontier models, but offers no independent empirical testing or hands-on runtime telemetry.
