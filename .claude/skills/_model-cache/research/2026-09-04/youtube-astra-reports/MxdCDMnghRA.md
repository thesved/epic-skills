## Video: 페이블 박살내버린 GPT-6 아스트라..ㄷㄷ 벤치 실화냐 AGI 99.9% Exploit 100% FrontierMath 98%.., 성공지식백과
**URL:** https://www.youtube.com/watch?v=MxdCDMnghRA  **Views:** 287  **Date:** 20260903  **Length:** 5:53
**ADDRESSES GOAL:** partially, reviews official benchmark figures, pricing, and third-party early access demos, but contains no original testing or harness execution.
**HANDS-ON:** no (reaction only)

### Demonstrated findings (with timestamps)
- **Official Benchmark Table (01:48):**
  - Terminal-Bench Science 0.1: GPT-6 Astra 64.6%, GPT-5.6 Sol 22.4%, Claude Fable 5.1 52.6%
  - AutomationBench: GPT-6 Astra 41.4%, GPT-5.6 Sol 18.1%, Claude Fable 5.1 31.4%
  - FrontierMath Tier 4 (v2): GPT-6 Astra 97.6%, GPT-5.6 Sol 83.0%, Claude Fable 5.1 87.8%
  - Terminal-Bench 4.0: GPT-6 Astra 57.9%, GPT-5.6 Sol 37.3%, Claude Fable 5.1 55.8%
  - HealthBench Professional (length-adjusted): GPT-6 Astra 63.4%, GPT-5.6 Sol 60.5%, Claude Fable 5.1 58.1%
  - BenchCAD: GPT-6 Astra 95.9%, GPT-5.6 Sol 83.3%, Claude Fable 5.1 84.3%
  - ARC-AGI-3: GPT-6 Astra 99.9%, GPT-5.6 Sol 7.8%, Claude Fable 5.1 "-" (Claude Opus 5 shown at 30.2% at 00:08)
- **AutomationBench Settings Tooltip (00:41, 00:52):** GPT-6 Astra "Reasoning effort: Max", "Cost: $1.77", "Accuracy: 41.4%".
- **ExploitGym Honeypot Benchmark (01:12):** Lower is better. GPT-5.6 Sol at 49.2% exploit rate vs GPT-6 Astra at 0.0%.
- **OpenAI Developer Pricing & Specs (04:15 - 04:22):**
  - Input: $10.00 / 1M tokens
  - Cached Input: $1.00 / 1M tokens
  - Cache Writes: $12.50 / 1M tokens
  - Output: $50.00 / 1M tokens
  - Context Window: 1,050,000 context window
  - Max Output Tokens: 128,000 max output tokens
  - Knowledge Cutoff: Apr 30, 2026
  - Long prompt pricing notice: "Prompts with more than 375K input tokens are priced as 2x input and cache rates and 1.5x output for the full request."
- **Social Early-Access Demos (02:36 - 03:36):**
  - Angry Tom: Manhattan Unreal Engine 5 walkthrough generation (02:36).
  - Matthew Berman: 5-day continuous execution City Clone and Fall Guys clone (02:52).
  - Tom Krcha / Max Weinbach: 3D Blender mesh reconstructions running at 60 fps (03:02, 03:21).
  - Peter Gostev: 3D open world adventure game generation (03:14).

### Asserted claims (with timestamps)
- **AGI Proximity (00:11, 02:28):** Presenter asserts ARC-AGI-3 score of 99.9% indicates the model understands broad contextual logic and prose puzzles near human level.
- **Rollout Gating (03:37 - 03:55):** Presenter states Astra is restricted to select partner organizations initially, expanding to Plus, Pro, Business, Enterprise, and API users over subsequent days.
- **Voice Preference (05:19 - 05:30):** Presenter claims OpenAI staff utilize voice input because spoken thought flows faster than typing when directing Astra.

### Strengths of Astra reported
- Exceptional ARC-AGI-3 (99.9%) and FrontierMath Tier 4 reasoning (97.6% - 98%).
- Complete resistance to unintended exploit tasks (0.0% exploit rate on ExploitGym).
- High-fidelity 3D modeling and code generation (95.9% BenchCAD; direct Blender and Unreal Engine 5 generation).
- Large 1,050,000 token context window with 128,000 output capacity.

### Weaknesses, failures, refusals, costs reported
- Pricing is 2.5x higher than GPT-5.6 Sol ($10/$50 per 1M tokens vs Sol).
- Surcharge penalty on long contexts: requests over 375K input tokens trigger 2x input and 1.5x output billing rates.
- Strict safety gating and delayed rollout creating public frustration among ChatGPT Pro subscribers.

### How-to-get-the-max tips (effort, prompts, harness, settings)
- **Reasoning Effort Setting:** Maximum benchmark accuracy on complex automation tasks requires `Reasoning effort: Max` (00:52).
- **Context Management:** Keep total context below 375,000 tokens to avoid the 2x input / 1.5x output rate penalty (04:21).
- **Modality:** Leverage voice input for rapid context staging and high-speed thought translation (05:22).

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- **AutomationBench:** Astra 41.4% vs Claude Fable 5.1 31.4% vs GPT-5.6 Sol 18.1%.
- **FrontierMath Tier 4 (v2):** Astra 97.6% vs Fable 5.1 87.8% vs Sol 83.0%.
- **Terminal-Bench Science 0.1:** Astra 64.6% vs Fable 5.1 52.6% vs Sol 22.4%.
- **Terminal-Bench 4.0:** Astra 57.9% vs Fable 5.1 55.8% vs Sol 37.3%.
- **BenchCAD:** Astra 95.9% vs Fable 5.1 84.3% vs Sol 83.3%.
- **ARC-AGI-3:** Astra 99.9% vs Claude Opus 5 30.2% vs Sol 7.8% (Fable 5.1 unlisted).
- **ExploitGym:** Astra 0.0% vs Sol 49.2%.
- **Pricing:** Astra costs $10 input / $50 output per 1M tokens, matching Claude Fable 5.1 tier pricing.

### What the comments add (corrections, counter-evidence, first-hand reports)
- @success_wiki notes the official blog was temporarily taken down during recording, referencing the safety system card at deploymentsafety.openai.com/gpt-6-astra.
- @dongchanshin1945 claims ARC-AGI is a test where non-human top models previously scored below 1%.
- @콩창섭 raises concerns that guardrails and safety filtering have become overly aggressive.
- @닉값-p1e highlights that Astra costs 2.5x more than GPT-5.6 Sol, questioning usability limits on standard $20 subscriptions.

### Confidence in this source (1-5) and why
**2/5.** The creator had zero hands-on access to the model, ran no real-world harness tests, and only read public release tables, pricing cards, and curated Twitter demo clips. Useful solely for verbatim OpenAI documentation figures.
