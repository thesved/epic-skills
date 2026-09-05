## Video: GPT-6 Astra: The 98.6% Benchmark Everyone Is Misreading, AI CITY
**URL:** https://www.youtube.com/watch?v=2p8XiEFcvC8 **Views:** 3 **Date:** 20260903 **Length:** 5:23
**ADDRESSES GOAL:** partially, provides official benchmark numbers, harness details, and safety refusal stats from launch documents, but lacks hands-on testing or practical API integration walkthroughs.
**HANDS-ON:** no (reaction and analysis of press releases, launch briefings, and benchmark reports only)

### Demonstrated findings (with timestamps)
* No live executions, code demonstrations, or API runs were demonstrated on screen. The video consists entirely of slide summaries and commentary over graphics.

### Asserted claims (with timestamps)
* [0:34] Greg Brockman framed the launch in an Axios briefing as a "generational leap" and concluded with the words "Welcome to the AGI era".
* [0:58] Reported viral benchmark scores: ARC-AGI-3 at 98.6% (compared to 7.8% for GPT-5.6 Sol).
* [1:04] ExploitBench reported at 100%.
* [1:08] FrontierMath T4 v2 reported at 97.6%.
* [1:11] DeepSWE v1.1 reported at 74.1%.
* [1:16] SREBench reported at 99.2%.
* [1:18] AutomationBench reported at 41.4%.
* [1:30] OpenAI's ARC-AGI-3 score utilized a "responses API harness that preserves reasoning between turns and compacts long context".
* [2:00] OpenAI officially classified Astra at the "Critical Cyber" capability threshold.
* [2:11] In an internal evaluation of 20 high-severity V8 cases, Astra achieved a higher code-execution rate than GPT-5.6 Sol while consuming fewer output tokens.
* [2:27] In expert-led "Daybreak Blue" testing, Astra discovered two previously unknown vulnerabilities in a hardened browser, chained a sandbox-to-host escape, and escalated privileges from unprivileged user to root.
* [2:58] Safety evaluations report a 91.5% refusal rate on cyber jailbreaks, compared to 59% for GPT-5.6 Sol.
* [3:18] Partner testing by Playco reported generating 3 themed game prototypes from one gray-box foundation, with most working on the first attempt and requiring 50% fewer manual fixes than the previous model.
* [3:30] An internal Astra version generated formal arguments for 10 advances across mathematics and theoretical computer science into checkable Lean certificates based on human-prepared manuscripts.
* [3:50] Axios reported agentic toolchain capability across KiCad (circuit board layout), Unity (scene generation), Blender and FreeCAD (mechanical modeling), and drafting a W-2 tax return.
* [4:02] Staged rollout: Limited Daybreak organizations receive access first, with ChatGPT and API access rolling out in subsequent days; not yet active in the public API catalog on September 3, 2026.

### Strengths of Astra reported
* Massive reasoning and math capability: 98.6% ARC-AGI-3, 97.6% FrontierMath T4 v2, and formalization into Lean certificates.
* Autonomous cyber capability: 100% ExploitBench, zero-day discovery, and exploit chaining in sandbox environments.
* High software engineering efficiency: 74.1% DeepSWE v1.1, 99.2% SREBench, and 50% fewer manual fixes in game prototyping.
* Lower token usage: Uses fewer output tokens than GPT-5.6 Sol on complex V8 vulnerability analysis.

### Weaknesses, failures, refusals, costs reported
* Aggressive safety gating: 91.5% refusal rate on cyber-related tasks in default production setups.
* Baseline comparison inflation: The 98.6% ARC-AGI-3 score relies heavily on OpenAI's state-preserving responses harness, whereas comparison baselines scored 13.3% to 38.3% under different harness conditions.
* Production vs Daybreak disparity: Extreme offensive cyber capabilities were only accessible in Daybreak Blue configurations, not in standard production tiers.
* Unsupervised long-task reliability remains unproven independently outside curated launch benchmarks.

### How-to-get-the-max tips (effort, prompts, harness, settings)
* Harness design is critical: Use an agent harness (like OpenAI's responses API architecture) that preserves reasoning state between turns and implements automated long-context compaction to match benchmark-level reasoning.
* Direct tool integration: Point Astra directly to native tool environments (such as CAD/Unity/CLI environments) rather than using standard chat wrappers.

### Comparisons vs Fable 5.1 / Sol / others (numbers)
* ARC-AGI-3: GPT-6 Astra at 98.6% vs GPT-5.6 Sol at 7.8%.
* Cyber Jailbreak Refusals: GPT-6 Astra at 91.5% vs GPT-5.6 Sol at 59%.
* Code Execution / Token Usage: GPT-6 Astra showed higher execution rates and lower token consumption than GPT-5.6 Sol on 20 V8 cases.
* Software Prototyping: Astra required 50% fewer manual fixes than the previous OpenAI model.
* Claude Fable 5.1: Not mentioned in this video.

### What the comments add (corrections, counter-evidence, first-hand reports)
* No comments were present on the video at the time of review.

### Confidence in this source (1-5) and why
* Score: 2/5
* Why: The video is an automated secondary news summary reciting launch day marketing materials and press briefings (Axios, OpenAI announcements). It contains zero hands-on verification, no direct benchmarks run by the creator, and no original tooling or pricing data.
