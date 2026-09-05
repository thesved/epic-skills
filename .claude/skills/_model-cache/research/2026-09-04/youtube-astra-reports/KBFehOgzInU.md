## Video: GPT-6 Astra发布：为什么先给有限组织？ 2026-09-04 07:22, AGI_Ananas
**URL:** https://www.youtube.com/watch?v=KBFehOgzInU  **Views:** 0  **Date:** 20260904  **Length:** 6:58
**ADDRESSES GOAL:** partially, provides detailed breakdown of official benchmarks, API pricing formulas, rollout gates, refusal boundaries, and comparisons against Claude Fable 5.1 and GPT-5.6 Sol, but relies on official announcement slides rather than personal terminal runs.
**HANDS-ON:** no (reaction only)

### Demonstrated findings (with timestamps)
The presenter did not demonstrate live code execution or a personal bill on screen. The presenter displayed static tables and graphics citing official announcement documents ("OpenAI 官方发布页", "OpenAI 163 秒官方演示", "Anthropic 官方定价说明", "Artificial Analysis", "Linux.do"):
- [00:03] Release schedule table showing initial limited org access on September 3, followed by ChatGPT Plus, Pro, Business, Enterprise, API, and AWS.
- [01:26] Benchmark charts displaying OSWorld Astra task latency and accuracy numbers.
- [02:14] Artificial Analysis Intelligence Index score comparison card.
- [03:07] MRCR retrieval evaluation graphic across 512k to 1M token contexts.
- [03:55] Science workflow benchmark slides (Terminal-Bench Science and FrontierMath Tier 4).
- [04:32] Preparedness Framework Cyber capability and unauthorized action risk evaluation cards.
- [05:16] API pricing breakdown card comparing GPT-6 Astra with Claude Fable 5.1.
- [05:51] Structural architecture diagram showing Anthropic's single base engine split into Fable 5.1 and Mythos 5.1.

### Asserted claims (with timestamps)
- [00:16] Workspace administrators on Business and Enterprise tiers must manually toggle on Astra Pro in workspace settings; it is disabled by default at launch.
- [00:50] Citing OpenAI's 163-second demo video, Astra performs continuous computer use loops: observing screen, deciding action, executing across apps, and verifying results.
- [02:05] Astra's primary breakthrough is execution speed on complex computer workflows and scientific reasoning, not raw text generation improvements.
- [02:48] Differences in benchmark scores (like Artificial Analysis composite) stem from differing harness setups, tool availability, effort tiers, and safety refusals.
- [03:26] Codex integrates an experimental searchable history context manager that persists working notes across context windows while archiving older tool outputs.
- [04:47] Public releases of Astra will automatically refuse high-tier vulnerability exploitation tasks, prompt for manual human confirmation in ChatGPT/Codex on defensive security actions, or terminate API calls.
- [05:24] Astra Fast mode offers up to 2.5x generation speed at 2.0x standard token price.
- [05:51] Anthropic uses a single base engine for Claude 5.1, routing general Pro/Max/API users to Fable 5.1 with strict guardrails while reserving Mythos 5.1 for audited defense and life science partners.

### Strengths of Astra reported
- Task Completion Latency: Completes OSWorld tasks in approximately 40 minutes per item, compared to ~75 minutes for GPT-5.6 Sol [01:35].
- Computer Use & Desktop Workflow: Achieved 72.6% on OSWorld Astra and 59.3% on Agent's Last Exam [01:30].
- Professional Workflows: Scored 41.4% on AutomationBench and 95.9% on BenchCAD [01:44].
- Long Context Needle Retrieval: Scored 96.3% on MRCR in the 512k to 1M token range (vs 73.8% for GPT-5.6 Sol) [03:14].
- Science & Advanced Math: Scored 64.6% on Terminal-Bench Science and 97.6% on FrontierMath Tier 4 [04:03].
- Mathematical Discovery: Cited assisting in reducing the prime gap upper bound from 240 to 186 [04:16].
- Offensive Cyber Capability: Scored 100% on ExploitBench and discovered 2 previously unknown zero-day vulnerabilities in evaluation [04:41].
- Safety Guardrail Conformance: 0% boundary transgression rate during evaluation runs (compared to 48% for unconstrained GPT-5.6 Sol) [05:04].

### Weaknesses, failures, refusals, costs reported
- Modest Gain in General Text Benchmarks: Artificial Analysis Composite Intelligence index is 61.2, only 0.3 points above GPT-5.6 Sol (60.9) and behind Claude Fable 5.1 (65.7) [02:18].
- Coding Agent Index: Scored 67.0 on coding agent index, trailing Fable 5.1 (67.2) and Claude Opus 5 (68.1) [02:27].
- Safety Refusals & Interventions: High-risk security actions trigger mandatory human confirmation in ChatGPT/Codex or immediate API halts [04:53].
- Base Pricing: Standard API rate is $10.00 / 1M input tokens and $50.00 / 1M output tokens [05:18].
- Fast Mode Surcharge: Running Fast mode (up to 2.5x speed) costs 2x standard price ($20.00 input / $100.00 output per 1M tokens) [05:25].
- Lacks Anthropic's Deep Cache Discount: Fable 5.1 offers prompt cache reads at $0.25 / 1M tokens (up to 45% cost reduction in agentic loops), creating a structural cost disadvantage for Astra in iterative token-heavy workflows [05:30].

### How-to-get-the-max tips (effort, prompts, harness, settings)
- Enterprise Workspace Activation: Admins must explicitly enable Astra Pro inside the admin portal as it defaults to off [00:20].
- Context Management in Codex: Utilize the new experimental context memory architecture to store scratchpad notes in the immediate prompt while offloading raw tool outputs into searchable history [03:28].
- Routing Heuristics: Route terminal data analysis, multi-application computer GUI tasks, and complex math/science workflows to Astra; route raw coding agent tasks and high-cache repetitive prompt workflows to Claude Fable 5.1 [02:05, 05:41].

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- OSWorld Astra Accuracy & Latency: Astra 72.6% (~40 min/task) vs GPT-5.6 Sol 65.7% (~75 min/task) [01:34].
- Agent's Last Exam: Astra 59.3% [01:30].
- AutomationBench: Astra 41.4% vs Claude Fable 5.1 31.4% [01:44].
- BenchCAD: Astra 95.9% vs Claude Fable 5.1 84.3% [01:46].
- Terminal-Bench 4.0: Astra 57.7% vs Claude Fable 5.1 55.8% [01:56].
- Artificial Analysis Composite Intelligence Index: Claude Fable 5.1 (65.7) vs Astra (61.2) vs GPT-5.6 Sol (60.9) [02:18].
- Coding Agent Index: Claude Opus 5 (68.1) vs Claude Fable 5.1 (67.2) vs Astra (67.0) [02:27].
- MRCR 512k-1M Context Range: Astra 96.3% vs GPT-5.6 Sol 73.8% [03:14].
- Terminal-Bench Science: Astra 64.6% vs Claude Fable 5.1 52.6% [04:03].
- FrontierMath Tier 4: Astra 97.6% vs Claude Fable 5.1 87.8% [04:09].
- Cyber ExploitBench: Astra 100% [04:41].
- Unauthorized Action / Transgression Rate: Astra 0% vs GPT-5.6 Sol 48% [05:04].
- API Base Price: Astra $10 / $50 per 1M tokens vs Claude Fable 5.1 $10 / $50 per 1M tokens [05:18]. Cache read for Fable 5.1 is $0.25 / 1M tokens [05:31].

### What the comments add (corrections, counter-evidence, first-hand reports)
No user comments were present or provided for this video.

### Confidence in this source (1-5) and why
3 out of 5. The video provides a clear, structured aggregation of launch data, pricing parameters, and official benchmark comparisons between Astra, Sol, and Fable 5.1. However, the creator had no hands-on access and only synthesized published marketing materials and benchmark sheets.
