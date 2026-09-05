## Video: GPT-6 Leaked, Claude Limits CUT 17%, and a Free 770B Model - I Verified All of It, Hyperautomation Labs
**URL:** https://www.youtube.com/watch?v=ANzH714zY_w **Views:** 5863 **Date:** 20260831 **Length:** 10:22
**ADDRESSES GOAL:** partially, covers the pre-release leaks, safety pause history, and unverified demo outputs of GPT-6 Astra alongside Claude routing adjustments, but predates Astra's public release.
**HANDS-ON:** no (reaction and leak analysis only for GPT-6 Astra; hands-on demonstrated only for Claude Code probe and Tencent HY4 via OpenRouter).

---

### Demonstrated findings (with timestamps)
* **[01:08 - 01:55] Claude Code limit math:** Demonstrated the calculation of Anthropic's policy shift: baseline 100 raised by 50% temporary boost to 150; transitioning on September 14 to a permanent 25% over baseline (125), which equals a "17% reduction" vs current limits.
* **[02:00 - 02:44] The 1.2 Rule for Claude Code:** Displayed terminal calculation formula `/usage weekly % * 1.2` to determine if usage will exceed limits post-September 14.
* **[03:36 - 04:19] Live Claude Checkpoint Probe:** Ran a terminal prompt on `probe-lab` asking: `"when exactly did Claude Opus 4.6 release? if you don't know, say so."` Output showed Claude Opus 5 refusing knowledge (cutoff January 2026), followed by a JSON check confirming routed model `claude-opus-5`.
* **[06:45 - 07:15] Tencent HY4 Model Specs:** Displayed Hugging Face model card for Tencent `hy4-preview`: 770B total parameters, 49B active per token (MoE), 1M+ context window, Apache 2.0 license.
* **[07:16 - 07:45] Live Tencent HY4 Coding Test:** Ran a real run on a failing sliding window rate limiter test (`node limiter.test.js`). Routed to `tencent/hy4-preview` on OpenRouter. The model fixed `<` to `<=` in 16.9s wall clock time, consuming 996 tokens (866 reasoning) for a total cost of $0.0026.
* **[08:06 - 08:26] OpenRouter Pricing Table for Tencent HY4:** Displayed live OpenRouter rates of $0.834 / 1M input tokens and $2.501 / 1M output tokens with 1M context.

---

### Asserted claims (with timestamps)
* **[04:30 - 05:09] GPT-6 Astra Leak Details:** Asserted that Astra finished internal dogfooding and is accessible to select OpenAI partners under the name "ultima-alpha" and checkpoint `mozaik-alpha-fdm`, with a rumored launch window of the first week and a half of September.
* **[05:58 - 06:15] OpenAI Aug 7 Statement on Astra:** Asserted that OpenAI stated Astra showed "significant advances in agentic coding and cybersecurity," triggering preliminary evaluations near highest cyber capability thresholds.
* **[06:16 - 06:40] OpenAI Aug 18 Frontier Pause:** Asserted OpenAI slowed frontier training with a "reported two-week reinforcement-learning pause while strengthening safeguards."
* **[02:45 - 03:23] Claude Leaked Checkpoints:** Reported community rumors that internal Anthropic checkpoints `claude-marshmallow-eap` corresponds to Opus 5.1 and `claude-melon-eap` corresponds to Fable 5.1.

---

### Strengths of Astra reported
* **[05:11 - 05:45] Unverified Leaked Demos:** Leaked partner posts claim Astra generated one-shot complex interactive projects, including:
  * Full voxel world with working mini-map and HUD from a single prompt.
  * Interactive bicycle builder with live geometry and drivetrain math.
  * Minecraft-style 3D clone with crafting, shaders, and 2D mini-game.
  * First-person dungeon crawler game.
  * High-fidelity SVG vector art (game controllers, detailed portraits).
* **[06:00 - 06:15] Frontier Capabilities:** OpenAI internal statements claim significant jumps in agentic coding autonomy and cybersecurity reasoning.

---

### Weaknesses, failures, refusals, costs reported
* **[04:35 - 04:45, 05:46 - 05:54] Unverifiable Nature:** No verified public access or verified pricing available at the time of recording (August 31, 2026); presenter emphasizes every output must be treated as "reportedly" true until verified.
* **[06:16 - 06:40] High Risk / Safety Gating:** Safety tripwires on cybersecurity and autonomous execution led OpenAI to pause RL training for two weeks to implement stricter safety rails.

---

### How-to-get-the-max tips (effort, prompts, harness, settings)
* **[03:24 - 03:48] Model Verification Probe Harness:** Use knowledge-cutoff boundary probes without web search to detect silently upgraded backend checkpoints in agentic CLI harnesses (e.g., querying post-cutoff specific release dates).
* **[02:10 - 02:40] Managing Rate Limits Across Toolkit:**
  * Score under 80 after 1.2 multiplication: Keep workflow unchanged.
  * Score 80 to 100: Optimize by delegating grunt work to smaller models, tightening context, and batching large runs.
  * Score over 100: Route overflow tasks to external providers (Tencent HY4, Codex CLI, or GLM plans).

---

### Comparisons vs Fable 5.1 / Sol / others (numbers)
* **[04:52 - 04:58] Astra vs GPT-5.6 Sol:** Leaked tester claims on X assert that Astra on Max model tends to think a lot more than Sol, with higher attention to detail.
* **[02:45 - 03:10] Claude Model Lineup:** Mentions Claude Opus 5.1 (Marshmallow) and Claude Fable 5.1 (Melon) early access rumors.
* **[07:16 - 08:16] Cost Comparison Benchmark (Tencent HY4 Preview):** 
  * Parameters: 770B total / 49B active MoE vs proprietary models.
  * OpenRouter Pricing: $0.834 / 1M input, $2.501 / 1M output.
  * Real task cost: $0.0026 for a 17-second automated bug fix with 866 reasoning tokens.

---

### What the comments add (corrections, counter-evidence, first-hand reports)
* No technical additions or counter-benchmarks exist in the top comments; user comments consist solely of keyword automation triggers ("PROBE") and a humorous remark misreading the title as "GTA 6".

---

### Confidence in this source (1-5) and why
* **Score: 3/5**
* **Reason:** The presenter is transparent about distinguishing verified facts from rumors and shows live code demonstrations for Claude Code and Tencent HY4. However, the video was recorded before GPT-6 Astra was released, so all Astra details rely on secondary leaks from social media rather than direct hands-on testing.
