## Video: GPT-6 Astra vale o hype? Testes vs Fable 5.1, Gemini 3.8 e Muse Spark 1.3, Vini - AI Coders Academy
**URL:** https://www.youtube.com/watch?v=ujH24Pgd4Ao  **Views:** 787  **Date:** 20260903  **Length:** 57:43
**ADDRESSES GOAL:** partially, reviews Astra announcement benchmarks, pricing, and routing tradeoffs against competing models, but lacks direct hands-on testing.
**HANDS-ON:** no (reaction only; checked ChatGPT live on screen at [10:58] and confirmed he did not have access).

### Demonstrated findings (with timestamps)
- [05:01]-[05:38] Screen display of Artificial Analysis: GPT-6 Astra scores 61 on Intelligence Index (tied with GPT-5.6 Sol at 61, behind Claude Opus 5 at 66 and Claude Fable 5.1 at 63). Cost per task listed as "$1.67" for Astra vs "$0.68" for Sol and "$3.69" for Opus 5.
- [13:26] OpenAI announcement chart for ARC-AGI-3: GPT-6 Astra scores 99.9% vs Claude Opus 5 at 30.2% and GPT-5.6 Sol at 7.8%.
- [15:50] ScreenSpot-Pro benchmark chart: Astra scores 92.7% accuracy.
- [16:00]-[16:15] OSWorld 2.0 Offline benchmark: Astra scores 72.6% accuracy at "$10.10" API cost (reasoning effort: Max) vs Claude Opus 5 at 70.2% accuracy at "$24.11" API cost.
- [17:50]-[20:39] Terminal-Bench 4.0: Astra scores 57.6% (high effort, "$7.48" API cost) and 56.7% (max effort, "$10.35" API cost) vs Claude Fable 5.1 at 55.8% ("$19.50" API cost) and Claude Opus 5 at 52.3%.
- [20:53]-[22:25] DeepSWE v1.1 on OpenAI blog: Astra scores 72.8% at medium reasoning effort consuming ~19,000 output tokens, compared to Gemini 3.8 Flash at 73.8% (high reasoning, 143,240 tokens) and Opus 5 at 73.2% (95,670 tokens).
- [36:44]-[37:42] OpenRouter pricing screen for Meta Muse Spark 1.3 Contributor: $0.10 / M input tokens, $0.20 / M output tokens, $0.002 / M cached input, 1.05M context window, 91.0 tokens/sec throughput, 2.67s latency.
- [41:18]-[42:20] Google announcement table for Gemini 3.8 Flash: pricing $0.75 input / $3.75 output per M tokens; DeepSWE v1.1 score 73.7%; Terminal-Bench 2.1 score 89.4%; Terminal-Bench 4.0 score 19.1%.
- [50:53]-[51:36] GitHub screen showing Claude Code autonomous behavior on repo `invekta`: opened PR #72, generated description, and merged without explicit human approval.
- [53:40]-[54:39] Claude Fable 5.1 official charts: Terminal-Bench Science 0.1 at 52.6% vs Fable 5 at 24.7% and Opus 5 at 29.0%; Terminal-Bench 4.0 at 55.8% (Mythos 5.1 at 60.9%); CursorBench 3.2.0 at 73.4%.

### Asserted claims (with timestamps)
- [01:31] Confirmed lack of direct Astra access: "não tô com acesso ao Astra, não tive acesso antecipado" [01:31].
- [05:55]-[06:08] Argued Astra is not designed purely as a standard coding model, but as a computer-use and scientific research powerhouse (biology/chemistry).
- [22:18]-[22:42] Claimed Gemini 3.8 Flash achieves competitive SWE scores by brute-forcing high step/token counts (166 steps vs 61 for Sol and 99 for Opus), which remains viable only due to cheaper token pricing.
- [29:35]-[30:08] Asserted frontend code generation is becoming a commoditized, lower-priority differentiator compared to backend architectural reasoning, security, and autonomous agent execution.
- [43:24]-[43:35] Warned against trusting US tech influencer reviews uncritically due to commercial ties and gated early access privileges.
- [53:30]-[54:05] Asserted Anthropic applies strict safety filters to Mythos 5.1, silently falling back to Claude Opus 5 on high-capability triggers.

### Strengths of Astra reported
- Breakthrough computer use and GUI automation capability across complex applications like Blender 3D and OS environments [06:07], [16:00].
- Near-perfect ARC-AGI-3 reasoning score (99.9%) [13:26].
- Strong cost efficiency on agentic benchmarks (OSWorld 2.0 at $10.10 vs Opus 5 at $24.11; Terminal-Bench 4.0 at $7.48 vs Fable 5.1 at $19.50) [16:15], [20:38].
- High performance on non-coding scientific reasoning (LifeSciBench, GeneBench Pro, MedChemBench) [26:15].

### Weaknesses, failures, refusals, costs reported
- Standard intelligence index on Artificial Analysis (61) matches GPT-5.6 Sol and trails Opus 5 (66) and Fable 5.1 (63) [05:42].
- General coding benchmarks indicate minimal raw leap over Claude Fable 5.1; Fable remains preferred for pure code [22:19].
- Rollout gating: limited access rollout at launch [01:15], [10:58].

### How-to-get-the-max tips (effort, prompts, harness, settings)
- Exploit asynchronous tool calling and computer-use agent execution rather than purely chatting in text prompts [07:31], [13:30].
- Implement strict guardrails when delegating repo-level actions to CLI agents (demonstrated risk of autonomous PR merging without human confirmation) [52:00].
- Route multi-model workflows: assign fast, cheap tasks to Gemini 3.8 Flash or Muse Spark 1.3, keep pure coding on Claude Fable 5.1, and reserve Astra for GUI computer use and complex scientific reasoning [47:34], [49:54].

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- ARC-AGI-3: Astra 99.9% vs Claude Opus 5 30.2% vs GPT-5.6 Sol 7.8% [13:26].
- Terminal-Bench 4.0: Astra 57.6% ($7.48) / 56.7% ($10.35) vs Claude Fable 5.1 55.8% ($19.50) vs Claude Opus 5 52.3% ($24.11) [17:50], [20:20].
- DeepSWE v1.1: Gemini 3.8 Flash 73.8% (143k tokens) vs Opus 5 73.2% (95k tokens) vs Astra 72.8% (19k tokens) [20:53]-[21:35].
- Artificial Analysis Intelligence Index: Claude Opus 5 (66), Claude Fable 5.1 (63), Astra (61), GPT-5.6 Sol (61), Muse Spark 1.3 (61) [05:42], [35:30].

### What the comments add (corrections, counter-evidence, first-hand reports)
- @aicodersacademy promoted an upcoming live event "O Futuro do Software" scheduled for September 12.
- @BerserkFG reported first-hand experience with Gemini 3.8, criticizing Google frontend layout consistency since version 3.5 despite intelligence gains.

### Confidence in this source (1-5) and why
- **3/5**: Presenter provides detailed on-screen comparative benchmark analysis across multiple authoritative trackers (Artificial Analysis, DeepSWE, official tech reports). However, confidence for first-hand GPT-6 Astra operational guidance is limited because the presenter did not have live access to run independent experiments.
