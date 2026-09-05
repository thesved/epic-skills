## Video: OpenAI launches GPT-6 Astra and says it may mark the beginning of the "AGI era", Jorebza
**URL:** https://www.youtube.com/watch?v=37_MTEJFs6o  **Views:** 0  **Date:** 20260903  **Length:** 6:36
**ADDRESSES GOAL:** partially, provides official benchmark figures, pricing, and harness updates from OpenAI announcement, but lacks hands-on testing or independent workflow evaluation.
**HANDS-ON:** no (reaction only, scrolling OpenAI announcement webpage)

### Demonstrated findings (with timestamps)
* 00:55 - 01:17: Webpage display of benchmark charts for Terminal-Bench Science 0.1, ARC-AGI-3, FrontierMath Tier 4 (v2), Terminal-Bench 4.0, and AutomationBench.
* 01:18 - 01:22: ExploitGym honeypot chart showing 0.0% unauthorized scope penetration for Astra vs 48.2% for GPT-5.6 Sol.
* 01:27 - 01:41: ScreenSpot-Pro and OSWorld 2.0 Offline graphs displayed.
* 03:08: Partner quote displayed from Cognition (Silas Alberti, SVP Research) integrating Astra into Devin harness.
* 03:41 - 03:47: Pricing text displayed on webpage: "$10 per million input tokens and $50 per million output tokens."
* 05:07 - 05:14: Webpage charts for FrontierCode 1.1 Extended, DeepSWE v1.1, and Database Migration Tasks.
* 05:15 - 05:18: Webpage text showing Codex harness update replacing lossy context compaction with new retrieval method.
* 05:46 - 05:54: Evaluation charts for ExploitBench, ExploitGym, and SRE-Bench.
* 06:14 - 06:33: Comprehensive summary benchmark table displayed covering Computer Use, Professional, Coding, Academic, Science, Cybersecurity, Alignment, Long Context, and Abstract Reasoning.

### Asserted claims (with timestamps)
* 00:23 - 00:31: Greg Brockman asserted during a private press meet that availability of Astra marks entry into the "AGI era."
* 00:33 - 00:41: Internal versions solved 10 longstanding open problems in mathematics and theoretical computer science.
* 00:52 - 01:01: First model classified by OpenAI as reaching "critical cybersecurity capability threshold" under its Preparedness Framework.
* 01:15 - 01:23: Scored 98.6% on ARC-AGI-3 (table lists 99.9% high compute / ~48% real-world estimate) vs 7.8% for GPT-5.6 Sol and 30.2% for Claude Opus 5.
* 01:29 - 01:45: FrontierMath Tier 4 (v2) score of 97.6% vs 83.0% (Sol), 87.8% (Claude Fable 5.1), and 73.2% (Opus 5).
* 01:46 - 01:58: GPQA Diamond score of 96.0% vs 95.3% (Gemini 3.8 Flash) and 94.6% (Sol).
* 02:02 - 02:14: DeepSWE v1.1 score of 74.1% vs 73.7% (Gemini 3.8 Flash) and 70.8% (Sol).
* 02:18 - 02:28: Terminal-Bench Science 0.1 score of 64.6% vs 52.6% (Fable 5.1) and 22.4% (Sol).
* 02:30 - 02:39: Agent's Last Exam score of 59.3% vs 53.8% (Sol) and 53.8% (Opus 5).
* 02:42 - 02:50: AutomationBench score of 41.4% vs 31.4% (Fable 5.1) and 18.1% (Sol).
* 03:13 - 03:25: Full cybersecurity offensive capabilities restricted to trusted defenders via OpenAI Daybreak program.
* 06:08 - 06:11: API model ID designated as `gpt-6-astra`, available on Azure OpenAI and AWS Bedrock. Fast mode offers up to 2.5x speed at 2x standard price.

### Strengths of Astra reported
* Top tier agentic coding, computer use, and complex STEM reasoning.
* 1.5x faster task execution speed in Codex harness compared to GPT-5.6 Sol.
* Substantial safety alignment: 0.0% Honeypot exploit rate, 3x fewer capability hallucinations than GPT-5.6 Sol, and 0.00% auto-review circumvention.
* Advanced visual document styling, CAD generation (BenchCAD 96.9%), and multi-step OS workflows.

### Weaknesses, failures, refusals, costs reported
* API Cost: $10.00 / 1M input tokens, $50.00 / 1M output tokens (matching Claude Fable 5.1, significantly pricier than GPT-5.6 Sol). Fast mode costs 2x standard price.
* Access Gating: Full cyber capability restricted to enterprise Daybreak participants.
* Refusals: Stricter refusal filters for offensive cybersecurity and proof-of-concept exploits.
* Extra runtime monitoring: API tasks subject to extra monitoring and automated pausing if classifiers detect unauthorized behaviors.

### How-to-get-the-max tips (effort, prompts, harness, settings)
* Codex Harness: Update Codex config to enable new non-lossy context retrieval, preventing degradation caused by older context compaction methods (05:15).
* Computer Use: Leverage updated Codex harness and ChatGPT Desktop App for high-speed agentic OS automation (00:50, 02:44).
* Fast Mode: Use Fast Mode in API for 2.5x speedup when latency is critical (06:11).

### Comparisons vs Fable 5.1 / Sol / others (numbers)
* ARC-AGI-3: Astra 99.9% (reported 98.6%) | Fable 5.1 N/A | Opus 5 30.2% | Sol 7.8%
* FrontierMath Tier 4 (v2): Astra 97.6% | Fable 5.1 87.8% | Sol 83.0% | Opus 5 73.2%
* Terminal-Bench Science 0.1: Astra 64.6% | Fable 5.1 52.6% | Sol 22.4% | Opus 5 30.2%
* AutomationBench: Astra 41.4% | Fable 5.1 31.4% | Opus 5 26.9% | Sol 18.1%
* Agent's Last Exam: Astra 59.3% | Fable 5.1 48.7% | Opus 5 53.8% | Sol 53.8%
* DeepSWE v1.1: Astra 74.1% | Fable 5.1 69.3% | Gemini 3.8 Flash 73.7% | Sol 70.8%
* GPQA Diamond: Astra 96.0% | Fable 5.1 93.7% | Gemini 3.8 Flash 95.3% | Sol 94.6%
* Pricing: Astra ($10/$50 per 1M) matches Claude Fable 5.1 ($10/$50), higher than Sol.

### What the comments add (corrections, counter-evidence, first-hand reports)
* No comments were available on the video.

### Confidence in this source (1-5) and why
* 2/5: Automated voice narration reading an official blog post. It provides direct, verbatim documentation and benchmark numbers from OpenAI, but provides zero independent testing, hands-on user verification, or multi-model routing experience.
