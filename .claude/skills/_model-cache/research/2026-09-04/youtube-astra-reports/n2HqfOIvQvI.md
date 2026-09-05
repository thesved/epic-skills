## Video: OpenAI calls GPT-6 Astra the world's most intelligent model. Its own table says fourth, The Contextian
**URL:** https://www.youtube.com/watch?v=n2HqfOIvQvI  **Views:** 7  **Date:** 20260903  **Length:** 5:05
**ADDRESSES GOAL:** partially, provides official launch benchmarks, API cost curves, harness quirks, and access gating info, but contains no independent live testing.
**HANDS-ON:** no (reaction and analysis of OpenAI's official launch materials and footnotes only)

### Demonstrated findings (with timestamps)
- [00:17] OpenAI launch slide shown with headline scores: FrontierMath Tier 4 at 98%, ARC-AGI-3 at 99.9%, ExploitBench at 100%, and pricing listed at "$10/5 per million tokens" (verbalized as "$10 per million tokens in, $50 out" at 00:32).
- [00:36] Training specs slide: 100,000+ GPUs at Stargate, Texas; models supervised the training of the next model.
- [00:52 - 01:23] Video capture of OpenAI customer story with studio Playco running agent "Playbot" on a Unity game project to generate prototypes and 4K renders.
- [01:24 - 01:43] OpenAI Terminal-Bench 4.0 accuracy vs API cost comparison chart:
  - GPT-6 Astra: 57.7% accuracy at approximately $7 API cost.
  - Claude Fable 5.1: 55.8% accuracy at approximately $19.50 API cost (roughly 3x spend).
- [01:44 - 01:59] Terminal-Bench 4.0 ranking table:
  1. GPT-6 Astra: 57.7%
  2. Claude Fable 5.1: 55.8%
  3. Claude Opus 5: 52.3%
  4. Claude Fable 5: 42.0%
  5. GPT-5.6 Sol: 37.3%
  6. Gemini 3.8 Flash: 19.1%
- [02:16 - 02:30] Artificial Analysis Intelligence Index v4.1.1 table printed in OpenAI materials:
  1. Claude Fable 5.1: 65.7
  2. Claude Opus 5: 63.1
  3. Claude Fable 5: 62.1
  4. GPT-6 Astra: 61.2
  5. GPT-5.6 Sol: 60.9
  6. Gemini 3.8 Flash: 58.7
- [02:31 - 02:51] Additional independent benchmark comparison tables:
  - Coding Agent Index v1.4: Opus 5 (68.1), Fable 5 (67.2), Astra (67.0, 3rd place).
  - Humanity's Last Exam (tools): Fable 5.1 (65.0), Fable 5 (63.8), Opus 5 (63.6), Astra (57.2, 4th place).
- [02:52 - 03:28] Footnotes analyzed:
  - Footnote 1: Two settings changed on the ARC-AGI-3 harness.
  - Footnote 2: OpenAI re-ran Claude models rather than quoting Anthropic's published numbers.
  - Footnote 17: Claude score substituted with Mythos (sibling model with fewer safeguards / turned-down filters).
  - Effort note: "All scores are the maximum at any effort setting."
- [03:53 - 04:12] Cybersecurity evaluation slide:
  - Rated "Critical" on OpenAI's cyber preparedness threshold.
  - Found 2 previously unknown zero-days during eval.
  - Honeypot scope test: Astra had 0.0% breakout rate vs GPT-5.6 Sol at 48.2% breakout rate.
- [04:14 - 04:30] Access gating slide: Astra's top cyber capabilities restricted to vetted defenders via "Daybreak Blue", mirroring Anthropic's "Project Glasswing" for Mythos 5.1.

### Asserted claims (with timestamps)
- [00:01] OpenAI claims GPT-6 Astra is "the world's most intelligent and aligned model", but third-party indices in OpenAI's own announcement table place it fourth behind Claude models.
- [01:13] The value proposition of Astra is not a better chat interface, but an agent that completes long, unmonitored workflows.
- [01:53] On the science terminal test, Astra scored 64.6% against 22.2% for GPT-5.6 Sol.
- [03:33] OpenAI omitted its own economic benchmark, GDPval (created in 2025 across 44 occupations), from the launch page, whereas Anthropic published GDPval scores on September 1.
- [04:31] Greg Brockman closed the launch briefing by stating "Welcome to the AGI era" and expressing that he personally believes AGI is already here.
- [04:44] Astra is cheaper per task than anything Anthropic offers and leads heavily on cybersecurity.

### Strengths of Astra reported
- Exceptional cost efficiency on terminal and coding tasks: Reaches 57.7% on Terminal-Bench 4.0 for ~$7 compared to ~$19.50 for Fable 5.1.
- High specialized benchmark performance: 98% on FrontierMath Tier 4, 99.9% on ARC-AGI-3 (with modified harness), 100% on ExploitBench, and 64.6% on the science terminal test.
- Cyber capability and containment: Rated "Critical", discovered 2 zero-days during evals, and stayed 100% within authority boundaries on the honeypot scope test (0.0% breakout).

### Weaknesses, failures, refusals, costs reported
- General intelligence lags Claude models on independent evaluations: Scores 61.2 on Artificial Analysis Intelligence Index v4.1.1 (behind Fable 5.1 at 65.7, Opus 5 at 63.1, and Fable 5 at 62.1).
- Coding Agent Index placement: Ranks 3rd (67.0) behind Opus 5 (68.1) and Fable 5 (67.2).
- Humanity's Last Exam (tools): Ranks 4th at 57.2 (behind Fable 5.1 at 65.0, Fable 5 at 63.8, and Opus 5 at 63.6).
- Gated access: Top offensive cybersecurity capability is withheld behind the "Daybreak Blue" vetting program.
- Pricing: $10/M input tokens, $50/M output tokens.

### How-to-get-the-max tips (effort, prompts, harness, settings)
- Benchmark scores require maximum reasoning effort: The launch footnotes state that "All scores are the maximum at any effort setting."
- Harness settings matter: The 99.9% ARC-AGI-3 score was achieved only after changing two default harness settings.
- Model routing strategy: Route cost-sensitive, bounded autonomous coding or execution tasks to Astra ($7 vs $19.50 on terminal tasks); keep high-complexity reasoning, broad tool use, and multi-domain exams on Claude Fable 5.1 / Opus 5.

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- **Terminal-Bench 4.0 accuracy:** Astra 57.7% vs Fable 5.1 55.8%, Opus 5 52.3%, Fable 5 42.0%, Sol 37.3%, Gemini 3.8 Flash 19.1%.
- **Terminal-Bench 4.0 cost:** Astra ~$7 vs Fable 5.1 ~$19.50.
- **Artificial Analysis Index v4.1.1:** Fable 5.1 65.7 vs Opus 5 63.1 vs Fable 5 62.1 vs Astra 61.2 vs Sol 60.9 vs Gemini 3.8 Flash 58.7.
- **Coding Agent Index v1.4:** Opus 5 68.1 vs Fable 5 67.2 vs Astra 67.0.
- **Humanity's Last Exam (tools):** Fable 5.1 65.0 vs Fable 5 63.8 vs Opus 5 63.6 vs Astra 57.2.
- **Science Terminal Test:** Astra 64.6% vs GPT-5.6 Sol 22.2%.
- **Honeypot Scope Breakout:** Astra 0.0% vs GPT-5.6 Sol 48.2%.

### What the comments add (corrections, counter-evidence, first-hand reports)
- No comments were present or provided on this upload.

### Confidence in this source (1-5) and why
- **3/5**: The presenter does not conduct live hands-on testing or show custom workflows, but provides precise, critical textual and tabular analysis directly from OpenAI's primary launch disclosures and footnotes.
