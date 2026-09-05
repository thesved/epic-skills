## Video: Fable 5.1 Could Not Beat GPT Astra: Even 97.5% on ARC-AGI Not Enough, AI That Works
**URL:** https://www.youtube.com/watch?v=DcrU4gFOv_U  **Views:** 1860  **Date:** 20260903  **Length:** 14:17
**ADDRESSES GOAL:** partially, it details Astra's leaked benchmark capabilities, defensive cyber gating under Daybreak Blue, refusal statistics, and direct qualitative comparisons against Claude Fable 5.1 and GPT-5.6 Sol.
**HANDS-ON:** no (reaction only to announcement blog posts, policy whitepapers, and third-party benchmark posts on X)

---

### Demonstrated findings (with timestamps)
- [01:16] Screen displays an X post by Dan McAlteer listing Fable 5.1 optimizations:
  1. "Set effort to 'low'"
  2. "Run '/claude-api cost-optimize'"
  3. "Run '/claude-api prompt-audit'"
  4. "Change effort mid-conversation w/o cache hit"
  5. "Update Fable 5.1 API config w/ 'claude-api migrate'"
- [01:35] Screen displays an X post by Aiden Scott showing usage stats: "Using Fable 5.1 took approximately 45 min of coding in 3 chats to hit my 5 hour session limit & 38% of my weekly Fable use. This is on a 20x pro plan." Current session at 100% used (resets in 4 hr 1 min), weekly all models 21% used, Fable only 38% used.
- [02:29] Screen displays Anthropic pricing documentation table:
  - Cache reads reduced 75% from $1.00 per million tokens to $0.25 per million tokens.
  - Base input remains $10 per million tokens.
  - Base output remains $50 per million tokens.
  - Cache writes remain $12.50 per million tokens (5-minute TTL) and $20.00 per million tokens (1-hour TTL).
  - Indexed cost for typical workload is 25% lower (indexed cost 75 vs 100 on Fable 5).
  - Indexed cost for highly agentic workload is up to 45% lower (indexed cost 55 vs 100 on Fable 5).
- [04:04] Screen displays an X post by VibCoded comparing complex voxel bottle scene generation:
  - Claude Fable 5.1 cost: $4.60 (created ~1,700 animated ocean columns, ship, lighthouse, palm island, shipwreck, seagulls, fish, rain, lightning, sea serpent).
  - ChatGPT GPT-5.6 Sol cost: $3.60.
- [05:35] Screen displays BridgeMind CursorBench benchmark results table:
  - Claude Fable 5.1 Max: 73.4% pass rate, $9.64 cost per task, 72,060 tokens per task, 70 steps per task.
  - Claude Fable 5: 70.5% pass rate, $17.32 cost per task, 111,349 tokens per task, 93 steps per task (Fable 5.1 showed 30% fewer tokens, half the price, twice as efficient).
- [06:20] Screen displays OpenAI official post "Path to Astra: critical capabilities and frontier safeguards" (dated September 1, 2026):
  - Astra reached "Critical" threshold under OpenAI Preparedness Framework for cybersecurity.
  - Jailbreak testing refusal rate: Astra refused 91.5% of prohibited cyber requests versus 59% for GPT-5.6 Sol [07:07].
  - Gated offensive access managed via "Daybreak Blue" program for vetted defensive partners [07:28].
- [07:35] Screen displays verbatim post on X from Sam Altman (@sama on September 1, 2026): "Astra has been done training for a while now and is a significant step forward in both capabilities and alignment... Astra is very good and we are excited to see what people will build with it."
- [09:18] Screen displays Gemini 3.8 Flash benchmark and pricing summary:
  - DeepSWE v1.1: 73.7%
  - Terminal-bench 2.1: 89.4%
  - HLE-Verified: 54.9%
  - Pricing through Dec 2026: $0.75 per 1M input tokens, $3.75 per 1M output tokens (doubling on January 1, 2027).

---

### Asserted claims (with timestamps)
- [00:11] The gap between Claude Fable 5.1 and leaked GPT Astra checkpoints on identical complex generative tasks "is not even close."
- [00:41] Within a 48-hour window, OpenAI, Anthropic, and Google each released restricted/locked-down sibling models (OpenAI Astra/Daybreak Blue, Anthropic Mythos 5.1, Google Gemini 3.8 Flash Cyber).
- [03:38] AI Appreciator asserted on X that GPT-5.6 Sol remains superior to Fable 5.1 for pure "nuts-and-bolts engineering."
- [05:07] Quoting community tester Lentils, Astra's outputs produce fully interactive 3D voxel worlds with Vulkan renderers, C++20 code, custom lighting, and embedded audio from a single prompt, outpacing Fable 5.1.
- [08:06] Leaked internal OpenAI evals claim Astra scored a perfect result on ExploitBench and autonomously discovered two zero-day vulnerabilities in hardened systems during exploit chain tests.
- [08:27] Prediction markets are pricing Astra's public release within days with very high confidence.

---

### Strengths of Astra reported
- Multi-step 3D environment synthesis: generates fully interactive, navigable voxel worlds in C++20/Vulkan with audio and physics from single prompts [05:07, 05:21].
- Autonomous cyber offensive reasoning: capable of finding zero-day vulnerabilities and constructing end-to-end exploit chains without human intervention [06:44, 08:08].
- High alignment and safety robustness: 91.5% refusal rate against malicious cyber exploit requests compared to 59% on GPT-5.6 Sol [07:07].

---

### Weaknesses, failures, refusals, costs reported
- Extreme refusals on security tasks: Astra rejects 91.5% of potentially sensitive cyber requests for standard users due to Critical Preparedness rating [07:07].
- Heavy access gating: Autonomous zero-day discovery and exploit capabilities are strictly withheld from general ChatGPT/API tiers and locked behind the Daybreak Blue vetted defender program [07:23, 07:28].
- High resource burn across frontier generation: Similar to Fable 5.1 eating 5-hour quotas in 45-52 minutes [01:18], deep reasoning frontier models drain usage limits rapidly.

---

### How-to-get-the-max tips (effort, prompts, harness, settings)
- Effort settings: Dial reasoning effort down to "low" during iterative or routine engineering passes to conserve rate limits [01:16, 01:48].
- Cache management: Leverage prompt caching aggressively (Fable 5.1 cache reads at $0.25/M tokens save 25% to 45% per session), and modify effort settings mid-session only when cache invalidation can be avoided [01:16, 02:32].
- Workflow routing: Run prompt audits (`/claude-api prompt-audit`) and optimization commands (`/claude-api cost-optimize`) to minimize token context bloat in autonomous loops [01:16].

---

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- Cybersecurity refusal rate:
  - GPT-6 Astra: 91.5% [07:07]
  - GPT-5.6 Sol: 59.0% [07:07]
- Benchmark pass rates (CursorBench):
  - Claude Fable 5.1 Max: 73.4% ($9.64/task, 72,060 tokens/task, 70 steps/task) [05:35]
  - Claude Fable 5: 70.5% ($17.32/task, 111,349 tokens/task, 93 steps/task) [05:35]
- Benchmark pass rates (DeepSWE v1.1):
  - Gemini 3.8 Flash: 73.7% [09:18]
- Single-prompt 3D generation cost:
  - Claude Fable 5.1: $4.60 [04:04]
  - GPT-5.6 Sol: $3.60 [04:04]
- Pricing per 1M tokens (API):
  - Claude Fable 5.1: $10.00 input, $50.00 output, $0.25 cache read [02:32]
  - Gemini 3.8 Flash (Introductory): $0.75 input, $3.75 output ($1.50 / $7.50 after Dec 2026) [09:42, 09:51]

---

### What the comments add (corrections, counter-evidence, first-hand reports)
- @jamiefyahshawnscafe2592 criticizes the presenter's sensationalist framing ("Nobody this Nobody that why you all sound the same how you know Nobody else is talking about it") regarding the claim that other channels missed the synchronized safety lockouts.

---

### Confidence in this source (1-5) and why
- **3/5**: The presenter aggregates verified primary announcements (OpenAI's Path to Astra document, Anthropic pricing and safety releases, Google Gemini 3.8 announcements) alongside reputable developer benchmark screenshots. However, the presenter did not possess direct hands-on API access to Astra and relies on secondary reports and leaks for Astra's specific output benchmarks.
