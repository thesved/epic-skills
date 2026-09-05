## Video: GPT-6 ya está aquí: esto es lo que tienes que saber, Benjamín Cordero
**URL:** https://www.youtube.com/watch?v=eLfTPBmC6LU  **Views:** 323  **Date:** 20260903  **Length:** 34:37
**ADDRESSES GOAL:** partially, provides detailed pricing, official benchmark comparisons vs Fable 5.1/Sol, safety/refusal metrics, and Codex harness details, but lacks direct hands-on testing.
**HANDS-ON:** no (reaction only to announcement, official blog post, system card PDF, and partner reports)

### Demonstrated findings (with timestamps)
- **Official announcement breakdown:** Displayed OpenAI's announcement page and system card PDF released on 2026-09-03 (00:12, 04:37).
- **API Pricing and Modes:** Shown verbatim from official documentation (11:41, 28:35):
  - Standard API pricing: $10 per million input tokens, $50 per million output tokens.
  - Fast mode: Up to 2.5x speed at 2x standard price ($20 / $100 per M tokens).
- **Cost vs. Performance Frontier Curves (demonstrated via interactive plots):**
  - *Terminal-Bench Science 0.1* (12:26 - 13:30): Astra reached 64.6% resolution at $26.20 (Max effort) and 54.2% at $11.31 (Low effort), compared to Claude Fable 5.1 at 52.8% for $37.90 (Max effort) and 35.7% for $14.90 (Medium effort).
  - *AutomationBench* (14:40 - 14:48): Astra reached 41.4% accuracy at $1.77 (Max effort) vs Fable 5.1 at 31.4% accuracy at $3.67 (Max effort).
  - *FrontierMath Tier 4 (v2)* (15:19 - 15:57): Astra scored 97.6% at $0.67 (Medium effort) and $1.27 (Max effort), plateauing early, vs Fable 5.1 at 87.8% for $4.87 (Max effort). Astra scored 83.3% at $0.41 (Low effort).
  - *Terminal-Bench 4.0* (16:08, 25:20): Astra achieved 57.9% accuracy at $7.48 (Max effort) and 49.7% at $4.95 (Low effort) vs Fable 5.1 at 55.8% for $19.00 (Max effort).
  - *OSWorld 2.0 Offline* (17:40 - 18:08): Astra reached 72.6% at $10.10 (Max effort) vs Claude Opus 5 at 55.2% for $10.10 (Low effort) and 70.2% for $24.11 (Max effort).
  - *DeepSWE v1.1* (26:00 - 26:35): Astra scored 74.1% at $4.40 (Max effort) vs Gemini 3.8 Flash at 71.0% (Medium effort).
- **Safety and Alignment Metrics:**
  - *ExploitGym Honeypot* (09:20, 10:11): Astra had 0.0% out-of-scope escalation vs GPT-5.6 Sol at 48.2%.
  - *Computer-Use Safety Stress Test* (10:37): Astra misaligned outcome rate was 2.4% vs Fable 5.1 at 9.5% and Opus 5 at 11.5%.
  - *Circumventing Auto-Review* (10:50): Astra had 0.0% bypass rate vs GPT-5.6 Sol at 0.3%.
- **Codex Harness Update:** Text shown on screen confirming updated harness runs 1.9x faster than Sol on Mind2Web (21:00, 21:34).

### Asserted claims (with timestamps)
- The launch roll-out was chaotic due to website 404 outages and staggered availability (00:44, 05:07).
- OpenAI rushed the release specifically to counter Anthropic's Claude Fable 5.1 announcement from 48 hours prior (00:01, 04:10, 30:44).
- Benchmark tables cherry-pick comparisons where Astra beats rivals while omitting missing comparative baselines (28:16 - 28:30).
- Public access will strictly refuse advanced cyber offensive workflows due to ethical/safety constraints (31:45 - 31:58).

### Strengths of Astra reported
- **SOTA Reasoning and Mathematics:** Saturated ARC-AGI-3 with 99.9% and FrontierMath Tier 4 with 97.6% to 98% (00:12, 01:10, 01:19).
- **Extreme Cost Efficiency:** Delivers higher accuracy at 30% to 60% lower cost per task across terminal, coding, and workflow benchmarks compared to Fable 5.1 (12:26, 14:45, 16:08).
- **Computer-Use and Multi-Modal Execution:** High proficiency across Blender 3D modeling, Unreal Engine scene generation, PowerPoint styling, and complex spreadsheets (18:18 - 20:30, 22:40 - 25:00).
- **Long-Context Retrieval:** 100% on OpenAI MRCR v2 8-needle (256K-512K) and 96.3% on 512K-1M (27:44).

### Weaknesses, failures, refusals, costs reported
- **Severe Rollout Gating:** Only available to limited organizations at launch; disabled by default for Enterprise accounts (00:28, 31:30).
- **Refusals on Security Tasks:** Refuses to produce functional zero-day exploits or advanced cyberattack proofs of concept in public tiers (31:46 - 31:58).
- **Diminishing Returns at High Effort:** On math benchmarks like FrontierMath, increasing reasoning effort from Medium ($0.67) to Max ($1.27) provided 0% accuracy gain (15:40 - 15:55).
- **Pricing:** Standard API output token rate remains high at $50/M tokens ($100/M on Fast mode) (11:41, 33:00).

### How-to-get-the-max tips (effort, prompts, harness, settings)
- **Effort-Level Tuning:** Set reasoning effort to Medium for math and logic tasks, as Max doubles cost without accuracy improvements (15:20 - 15:55).
- **Harness Integration:** Use updated Codex harness for computer-use to leverage the 1.9x execution speedup (21:00).
- **Context Compaction:** In long sessions, Astra automatically compacts context to minimize token consumption during multi-turn coding (26:10, 28:55).
- **Workflow Delegation:** Provide rich reference visual files when generating presentations or spreadsheets; Astra precisely matches styling rather than hallucinating formatting (29:00 - 29:30).

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- **Terminal-Bench Science 0.1:** Astra 64.6% ($26.20) vs Fable 5.1 52.6% ($37.90) vs Sol 22.4% (00:37, 12:26).
- **AutomationBench:** Astra 41.4% ($1.77) vs Fable 5.1 31.4% ($3.67) vs Sol 18.1% (00:37, 14:40).
- **Terminal-Bench 4.0:** Astra 57.9% ($7.48) vs Fable 5.1 55.8% ($19.00) vs Sol 37.3% (00:37, 16:08).
- **FrontierMath Tier 4 (v2):** Astra 97.6% ($0.67) vs Fable 5.1 87.8% ($4.87) vs Sol 83.0% (00:37, 15:20).
- **DeepSWE v1.1:** Astra 74.1% vs Gemini 3.8 Flash 73.7% vs Sol 70.8% vs Fable 5.1 67.4% (04:41, 26:00).
- **ARC-AGI-3:** Astra 99.9% vs Opus 5 30.2% vs Sol 7.8% (01:10, 05:16).
- **OSWorld 2.0:** Astra 72.6% ($10.10) vs Opus 5 70.2% ($24.11) vs Sol 65.7% (17:40).

### What the comments add (corrections, counter-evidence, first-hand reports)
- @dilanosorio notes presenter bias favoring Claude over OpenAI when assessing announcements.
- @TheCepultura jokes about OpenAI model naming conventions (Sol, Terra, Luna to Astro, Ostra, Astroboy).
- @sakurafire1233 humorously questions the launch 404 glitch in relation to GPT-5.6 Sol.
- @robertomanci2 claims Grok 4.7 is scheduled for launch shortly after.

### Confidence in this source (1-5) and why
**Score: 3/5**
- **Pros:** Thorough screen demonstration of official OpenAI system card metrics, cost-performance curves, token pricing, and harness specifications.
- **Cons:** Purely a secondary reaction video with no hands-on execution, terminal runs, or independent benchmark validation.
