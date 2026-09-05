## Video: GPT 6 Astra Is Here (And It's Better Than Fable 5.1?), Chase AI
**URL:** https://www.youtube.com/watch?v=mRiuhAjnPgI  **Views:** 3410  **Date:** 20260903  **Length:** 7:34
**ADDRESSES GOAL:** partially, reviews official OpenAI release benchmarks, pricing, and Codex harness features without independent hands-on testing.
**HANDS-ON:** no (reaction only to the OpenAI blog post)

### Demonstrated findings (with timestamps)
- **0:07 - 0:38**: Official Computer Use and Professional benchmark tables shown on screen. Agent's Last Exam: Astra 59.3% vs Sol 53.6%, Opus 5 55.9%. OSWorld 2.0: Astra 72.6% vs Sol 65.7%, Opus 5 70.2%. ScreenSpot-Pro: Astra 92.7% vs Sol 76.9%, Fable 5 87.3%. AutomationBench: Astra 41.4% vs Sol 18.1%, Fable 5.1 31.4%, Opus 5 26.9%. BenchCAD: Astra 95.9% vs Sol 83.3%, Fable 5.1 84.3%, Opus 5 82.1%. BrowseComp: Astra 91.5% vs Sol 90.4%, Opus 5 90.8%. Artificial Analysis Intelligence Index v4.1.1: Astra 61.2 vs Sol 60.9, Fable 5.1 65.7, Opus 5 63.1.
- **0:39 - 1:04**: Coding benchmarks table shown on screen. Terminal-Bench 4.0: Astra 57.7% vs Sol 37.3%, Fable 5.1 55.8%, Opus 5 52.3%. DeepSWE v1.1: Astra 74.1% vs Sol 72.7%, Fable 5.1 67.4%, Opus 5 73.7%. FrontierCode 1.1 Extended: Astra 64.5% vs Sol 60.6%, Fable 5.1 63.6%, Opus 5 56.3%. FrontierCode 1.1 Main: Astra 53.3% vs Sol 47.5%, Fable 5.1 50.9%, Opus 5 43.6%. Internal Database Migration Tasks: Astra 63.5% vs Sol 42.7%, Fable 5.1 57.8%, Opus 5 56.3%.
- **1:05 - 1:26**: Academic and Security tables shown. FrontierMath Tier 4: Astra 87.6% vs Sol 83.0%, Fable 5.1 87.8%. GPQA Diamond: Astra 96.0% vs Sol 94.6%, Fable 5.1 93.7%. Humanity's Last Exam: Astra 57.2% vs Sol 65.0%, Fable 5.1 63.8%. ExploitBench: Astra 100.0% vs Sol 78.5%, Opus 5 70.0%. Exploit Gym: Astra 42.4% vs Sol 30.3%, Fable 5.1 30.4%. ExploitBench (June-Aug 2026): Astra 39.0% vs Sol 5.5%. SRE-Bench: Astra 88.0% vs Sol 55.9%, Opus 5 12.5%. SEC-Bench Pro: Astra 85.4% vs Sol 79.7%.
- **1:27 - 1:50**: Long context needle test shown. OpenAI MRCR v2 8-needle 256k-512k: Astra 100.0% vs Sol 91.5%. 512k-1M: Astra 96.3% vs Sol 73.8%. Internal hallucination benchmark: Astra 4.2% vs Sol 12.2%.
- **1:51 - 3:18**: Terminal-Bench 4.0 Cost vs Accuracy curve graph shown with tooltips. Astra reasoning effort Low: $4.35 (49.7%), Medium: $6.15 (53.9%), High: $7.21 (57.9%), Max: $10.35 (56.7%). Fable 5.1 High: $10.50 (49.4%), Max: $19.50 (55.8%).
- **3:19 - 3:38**: FrontierCode 1.1 Extended Cost vs Accuracy curve shown. Astra Max reasoning effort: $3.93 (64.5%). Fable 5.1 Max reasoning effort: $15.01 (63.6%).
- **3:44 - 3:57**: Agent's Last Exam Cost vs Accuracy curve shown. Astra Max reasoning effort: $7.28 (59.3%).
- **4:13 - 4:51**: Slideshow, Excel, and PDF template adherence examples displayed.
- **5:30 - 6:23**: Codex memory text shown regarding `Codex config.toml` configuration for preserving notes across context windows.
- **6:24 - 6:37**: Safety policy snippet shown regarding refusal to generate proof-of-concept exploits.
- **6:38 - 6:59**: Hallucination graph displayed comparing Astra (2.0% at 33,245 solution tokens) vs Sol (9.4% at 39,843 solution tokens).
- **7:08 - 7:17**: Pricing text shown: standard API pricing is "$10 per million input tokens and $50 per million output tokens." Fast mode delivers up to 2.5x speed at 2x standard price.

### Asserted claims (with timestamps)
- **2:12 - 2:35**: Presenter asserts that Astra experiences an efficiency and accuracy drop when pushed beyond High effort into Extra High or Max effort.
- **4:01 - 4:12**: Presenter states Codex with Astra runs 1.9x faster than Sol in computer-use workflows based on Mind2Web data.
- **4:59 - 5:20**: Presenter argues Astra has better visual judgment and "taste" for web apps and slides, though all models regress if given poor prompts.

### Strengths of Astra reported
- Leading benchmark scores across Terminal-Bench 4.0 (57.7%), DeepSWE v1.1 (74.1%), OSWorld 2.0 (72.6%), and ExploitBench (100.0%).
- High token efficiency: achieves superior accuracy at roughly half to one-third the API cost of Fable 5.1.
- Long-context needle retrieval reaches 100% (256k-512k) and 96.3% (512k-1M).
- Strong adherence to reference styling across slides, documents, and code design.
- Lower capability hallucination rate (2.0% vs Sol's 9.4%).

### Weaknesses, failures, refusals, costs reported
- Performance regression at reasoning effort "Max" on Terminal-Bench 4.0 (drops from 57.9% at High to 56.7% at Max while cost increases from $7.21 to $10.35).
- Loses to Fable 5.1 on Artificial Analysis Intelligence Index v4.1.1 (61.2 vs 65.7) and Humanity's Last Exam (57.2% vs 63.8%).
- Refuses advanced cybersecurity tasks like proof-of-concept exploit creation outside OpenAI Daybreak access.
- API cost remains high in absolute terms: $10/M input, $50/M output (doubled in Fast mode).

### How-to-get-the-max tips (effort, prompts, harness, settings)
- **Reasoning Effort Setting**: Keep reasoning effort at "High" rather than "Max" for coding/terminal tasks to maximize accuracy and minimize cost.
- **Codex Harness Setting**: Enable experimental cross-window note preservation in `Codex config.toml` to prevent loss of details during auto-compaction.
- **Prompting with Templates**: Feed visual or structured reference templates (PDF, image, slide deck) to leverage Astra's style-matching capability.

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- **Terminal-Bench 4.0**: Astra 57.7% ($7.21 High) vs Fable 5.1 55.8% ($19.50 Max) vs Sol 37.3%.
- **FrontierCode 1.1 Extended**: Astra 64.5% ($3.93) vs Fable 5.1 63.6% ($15.01) vs Sol 60.6%.
- **DeepSWE v1.1**: Astra 74.1% vs Sol 72.7% vs Fable 5.1 67.4% vs Opus 5 73.7%.
- **OSWorld 2.0**: Astra 72.6% vs Sol 65.7% vs Opus 5 70.2%.
- **ExploitBench**: Astra 100.0% vs Sol 78.5% vs Opus 5 70.0%.
- **Pricing**: Astra matches Fable standard rates ($10/M input, $50/M output), but requires fewer tokens per task.

### What the comments add (corrections, counter-evidence, first-hand reports)
- **Usage & Cost Calculation**: User @Gai-i5x noted that 80-day heavy usage (11.19B tokens, mostly cached input and output) equals ~$469,625.65 at Astra list prices.
- **Rollout Gating**: User @abpetersonftw noted initial access was limited to enterprise organizations before rolling out broadly.
- **Skepticism**: Commenters debated real-world performance versus benchmarks, noting Sol's past benchmark discrepancies and Grok comparisons.

### Confidence in this source (1-5) and why
**2/5**: The creator does not show direct hands-on testing, CLI execution, or empirical tool usage. The video solely walks through charts and text from OpenAI's promotional blog post.
