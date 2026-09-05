## Video: OpenAI正式发布GPT-6 Astra！最强AI大模型登场！ARC-AGI-3得分冲到99.9%【Vic TALK第1790期】, Vic TALK
**URL:** https://www.youtube.com/watch?v=y38Zii9zfWw  **Views:** 0  **Date:** 20260903  **Length:** 13:16
**ADDRESSES GOAL:** partially, provides a high-level overview of OpenAI official launch blog post benchmarks, API pricing, token efficiency, and computer use capability demos without hands-on testing or actionable prompting configurations.
**HANDS-ON:** no (reaction only; reading OpenAI announcement blog post and community posts)

### Demonstrated findings (with timestamps)
The presenter did not execute live code or run independent evaluations on Astra. The screen displays OpenAI announcement blog posts, official benchmark charts, and launch demo clips:
- [00:14, 01:49, 08:06] OpenAI official benchmark table displayed on screen comparing GPT-6 Astra, GPT-5.6 Sol, and Claude Fable 5.1 across multiple evaluations.
- [00:35, 04:14] Video clips from OpenAI blog showing KiCad PCB circuit board layout generated in 15 seconds.
- [02:30, 02:40] Screen capture of a community post by Matt Shumer showcasing multi-agent autonomous game simulation using Astra.
- [04:38] Video clips of financial modeling in Excel, Form 1040 filling, and 3D environment exploration in Blender / Unreal Engine 5.
- [09:08, 09:12] Official chart showing computer use safety stress test / misaligned outcome rate.
- [09:27, 09:35] Official chart showing hallucination rate reduction across solution tokens.
- [10:18] API pricing table and availability card shown on screen.

### Asserted claims (with timestamps)
- [00:03, 01:18] Presenter asserts Astra is currently the strongest AI model worldwide ("这是目前全世界最强的大模型... 卧槽，太强了").
- [00:25, 02:27] Presenter asserts ARC-AGI-3 score of 99.9% indicates GPT-6 has essentially achieved AGI.
- [05:56] Presenter claims Astra's capability in generating presentations, spreadsheets, and legal documents exceeds human knowledge workers with 5 years of experience.
- [07:38] Presenter states he is not a software engineer, so he cannot evaluate coding directly and relies on benchmark charts.
- [10:09, 10:59] Presenter states Astra has not yet rolled out to his account, and he will make detailed tutorials after using it for a few days ("目前呢，整个GPT-6还没有进行推送... 等后面它推送我自己用几天之后再跟大家去做一个详细的教程").
- [11:39, 11:43] Presenter claims GPT-6 puts OpenAI a full generation ahead of Anthropic.

### Strengths of Astra reported
- ARC-AGI-3 benchmark: 99.9% [00:18, 03:20].
- FrontierMath Tier 4 (v2): 97.6% [00:15].
- Terminal-Bench Science 0.1: 64.6% [00:15, 02:07].
- BenchCAD: 95.9% geometric overlap score [00:15, 05:48].
- Terminal-Bench 4.0: 57.9% [00:15].
- AutomationBench: 41.4% [00:15].
- HealthBench Professional (length-adjusted): 63.4% [00:15].
- ExploitBench: 100% [08:38].
- ExploitGym honeypot error / out-of-scope exploit rate: 0.0% [03:30].
- OSWorld 2.0 task latency: Astra solves tasks in 47% less time than GPT-5.6 Sol, scoring 72.6% at roughly 40 minutes per task [00:35, 04:08].
- Mind2Web task speed: 1.9x faster than GPT-5.6 Sol [04:38].
- Financial modeling speed in Excel: 4x faster than human champions [04:41].
- Rapid multi-modal design: PCB layout completed in 15 seconds [04:29].
- Token consumption efficiency: Uses 60% to 70% fewer tokens per task than GPT-5.6 Sol [10:33].
- Hallucination reduction: Dropped from 18%-10% in GPT-5.6 Sol down to 5%-1% in Astra [09:35].
- Misaligned outcome safety rate: 2.4% under safety stress testing [09:14].

### Weaknesses, failures, refusals, costs reported
- Standard API pricing: $10 per 1M input tokens, $50 per 1M output tokens [10:18, 10:25].
- Fast API mode: 2.5x speed multiplier charged at 2x base pricing ($20 / $100 per 1M tokens) [10:18].
- Amazon Bedrock prompt cache storage: $50 per 1M tokens cached per month [10:18].
- ChatGPT Pro subscription cost noted as $200+ per month [12:17].
- No user-reported prompt refusals or execution failures covered because presenter lacked live system access.

### How-to-get-the-max tips (effort, prompts, harness, settings)
- [07:53] Configuration tip shown from OpenAI blog documentation: In Codex CLI, set configuration options in `config.toml` to connect to GPT-6 Astra.
- [02:56] Multi-agent simulation prompt tip: Presenter highlighted that a simple prompt describing agent roles enabled persistent autonomous agent interactions in a 3D environment.
- [10:18] Throughput optimization: Use Fast Mode via API for latency-sensitive tasks where 2.5x execution speed is required.

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- **ARC-AGI-3:**
  - GPT-6 Astra: 99.9% [00:18, 03:20]
  - Claude Opus 5: 30.2% [03:20]
  - GPT-5.6 Sol: 7.8% [00:23, 03:20]
- **Terminal-Bench Science 0.1:**
  - GPT-6 Astra: 64.6% [00:15, 02:07]
  - Claude Fable 5.1: 52.6% [00:15, 02:04]
  - GPT-5.6 Sol: 22.4% [00:15]
- **AutomationBench:**
  - GPT-6 Astra: 41.4% [00:15]
  - Claude Fable 5.1: 31.4% [00:15]
  - GPT-5.6 Sol: 18.1% [00:15]
- **FrontierMath Tier 4 (v2):**
  - GPT-6 Astra: 97.6% [00:15]
  - Claude Fable 5.1: 87.8% [00:15]
  - GPT-5.6 Sol: 83.0% [00:15]
- **Terminal-Bench 4.0:**
  - GPT-6 Astra: 57.9% [00:15]
  - Claude Fable 5.1: 55.8% [00:15]
  - GPT-5.6 Sol: 37.3% [00:15]
- **HealthBench Professional (length-adjusted):**
  - GPT-6 Astra: 63.4% [00:15]
  - GPT-5.6 Sol: 60.5% [00:15]
  - Claude Fable 5.1: 58.1% [00:15]
- **BenchCAD:**
  - GPT-6 Astra: 95.9% [00:15, 05:48]
  - Claude Fable 5.1: 84.3% [00:15, 05:48]
  - GPT-5.6 Sol: 83.3% [00:15, 05:48]
- **Safety / Misaligned Outcome Rate:**
  - GPT-6 Astra: 2.4% [09:14]
  - Claude Fable 5.1: 9.5% [09:16]
  - Claude Opus 5: 11.5% [09:17]
- **OSWorld 2.0:**
  - GPT-6 Astra: 72.6% (roughly 40 min/task) [04:08]
  - GPT-5.6 Sol: 65.7% (roughly 75 min/task) [04:08]
- **ExploitGym Honeypot Error Rate:**
  - GPT-6 Astra: 0.0% [03:30]
  - GPT-5.6 Sol: 48.2% [03:35]
- **Token Efficiency:** Astra consumes 60% to 70% fewer tokens per task compared to GPT-5.6 Sol [10:35].
- **API Price Ratio:** Astra standard API is priced 2.5x higher than GPT-5.6 Sol [10:21].

### What the comments add (corrections, counter-evidence, first-hand reports)
- @Shu-TingLiu-f4p reports that rollout access will expand over the coming days ("未來幾天就下放了").
- @GameHomages points out access gating limitations, stating that despite all the marketing, the model is currently restricted to selected enterprise partners only ("哎，说了那么多还是没用，目前只开放给 部分被选中的企业！").

### Confidence in this source (1-5) and why
2 out of 5. The presenter did not have hands-on access to GPT-6 Astra at recording time, did not verify claims independently, and merely re-read OpenAI official marketing blog posts and X slides. Useful only as a structured index of official benchmark numbers and launch pricing.
