## Video: GPT-6 Astra Just Broke ARC-AGI-3, Fahd Mirza
**URL:** https://www.youtube.com/watch?v=kjbRY5bW3ow  **Views:** 563  **Date:** 20260903  **Length:** 6:39
**ADDRESSES GOAL:** partially, reviews official OpenAI release slides, benchmarks, and cost curves but lacks live testing.
**HANDS-ON:** no (reaction only)

### Demonstrated findings (with timestamps)
- [01:26 - 01:50] OpenAI benchmark graph shows ARC-AGI-3 score for GPT-6 Astra at 99.9%, Claude Opus 5 at 30.2%, GPT-5.6 Sol at 7.8%, and average human tester baseline at 48%.
- [02:01] ExploitGym honeypot safety chart displays successful exploit rate of 48.2% for GPT-5.6 Sol versus 0.0% for GPT-6 Astra.
- [02:37 - 03:02] Accuracy vs API cost curves shown for Agents' Last Exam, ScreenSpot-Pro, and OSWorld 2.0 Offline, placing Astra in the upper-left (higher accuracy, lower cost than Sol).
- [03:03 - 04:10] Pre-rendered demo artifacts shown: Blender/Unreal Engine 5 walkthrough, 3D architectural renders, and a generated kart racing web game.
- [04:12 - 04:30] Side-by-side prompt execution slide: On "Build personal career website", Sol instantly generates code while Astra pauses to ask clarifying questions ("What career or role are you moving into?").
- [04:42] Official coding benchmark comparison table:
  - Terminal Bench 4.0: Astra 57.7%, Sol 37.3%, Claude Fable 5.1 55.8%, Claude Fable 5 42.0%, Claude Opus 5 52.5%, Gemini 3.0 Flash 19.1%.
  - DeepSWE v1.1: Astra 74.1%, Sol 72.7%, Claude Fable 5.1 67.4%, Claude Fable 5 69.9%, Claude Opus 5 73.7%, Gemini 3.0 Flash 73.8%.
  - FrontierCode 1.1 Extended: Astra 64.5%, Sol 60.6%, Claude Fable 5.1 63.6%, Claude Fable 5 64.9%, Claude Opus 5 63.6%, Gemini 3.0 Flash 56.3%.
  - FrontierCode 1.1 Main: Astra 53.5%, Sol 47.5%, Claude Fable 5.1 50.9%, Claude Fable 5 53.5%, Claude Opus 5 53.4%, Gemini 3.0 Flash 43.6%.
  - Internal Database Migration Tasks: Astra 63.9%, Sol 42.7%, Claude Fable 5.1 57.8%, Claude Fable 5 50.3%, Claude Opus 5 62.3%, Gemini 3.0 Flash 43.6%.
  - Artificial Analysis Coding Agent Index v1.4: Astra 67.0, Sol 65.1, Claude Fable 5.1 65.0, Claude Fable 5 67.2, Claude Opus 5 68.1, Gemini 3.0 Flash 61.2.
- [05:30] Official long context and reasoning table:
  - OpenAI MRCR v2 8-needle (256K-512K): Astra 100.0%, Sol 91.5%.
  - OpenAI MRCR v2 8-needle (512K-1M): Astra 96.3%, Sol 73.8%.
  - ARC-AGI-1: Astra 98.5%, Sol 97.5%, Claude Fable 5.1 97.5%, Claude Opus 5 97.5%.
  - ARC-AGI-2: Astra 95.0%, Sol 92.5%, Claude Fable 5.1 90.0%, Claude Opus 5 90.4%.

### Asserted claims (with timestamps)
- [00:02] Presenter asserts Astra can do anything on a computer quickly and unsupervised.
- [00:27] Presenter confirms API rollout is staged and not yet available in his region (Australia).
- [02:22] Presenter claims OpenAI heightened alignment sensitivity due to past safety incidents.
- [04:33] Presenter claims Astra exercises better "judgment" over raw guessing by asking interactive questions.
- [05:16] Presenter asserts pure coding workflows do not justify switching to Astra over existing models, recommending it mainly for general agentic tasks and OS navigation.

### Strengths of Astra reported
- Reasoning breakthrough on ARC-AGI-3 (99.9%).
- Zero exploit acceptance on ExploitGym honeypot (0.0%).
- 1M context needle retrieval retention (96.3% at 512K-1M).
- Lower API token expenditure per accuracy point across OSWorld and Agents' Last Exam.
- Interactive user requirement gathering before execution.

### Weaknesses, failures, refusals, costs reported
- Narrow margins or slight trailing behind Claude Opus 5 on pure coding benchmarks (Artificial Analysis Index: Astra 67.0 vs Opus 5 68.1; FrontierCode Extended: Astra 64.5% vs Fable 5 64.9%).
- Potential interactive latency/delay caused by asking clarification questions instead of immediate execution.
- Staged regional rollout delays access.

### How-to-get-the-max tips (effort, prompts, harness, settings)
- Delegate broad, multi-step computer-use and autonomous environment tasks to Astra rather than isolated code generation.
- Supply high-level goal prompts and allow the model to interactively clarify ambiguous constraints.

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- **Terminal Bench 4.0:** Astra 57.7% vs Fable 5.1 55.8% vs Sol 37.3% vs Opus 5 52.5%.
- **DeepSWE v1.1:** Astra 74.1% vs Sol 72.7% vs Fable 5.1 67.4% vs Opus 5 73.7%.
- **FrontierCode 1.1 Extended:** Astra 64.5% vs Fable 5.1 63.6% vs Sol 60.6% vs Fable 5 64.9%.
- **ARC-AGI-3:** Astra 99.9% vs Claude Opus 5 30.2% vs Sol 7.8%.
- **MRCR v2 512K-1M Context:** Astra 96.3% vs Sol 73.8%.
- **ExploitGym Honeypot:** Astra 0.0% vs Sol 48.2%.

### What the comments add (corrections, counter-evidence, first-hand reports)
- Comments contain general audience banter and off-topic inquiries regarding lightweight voice LLMs and K2 Horizon MoE models; no first-hand Astra performance reports or corrections provided.

### Confidence in this source (1-5) and why
- **2/5**: Presenter explicitly states he does not have hands-on access; all shared figures derive directly from vendor launch slides without independent verification.
