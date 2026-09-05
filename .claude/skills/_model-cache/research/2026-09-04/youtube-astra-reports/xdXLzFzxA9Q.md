## Video: ASTRA IS HERE (GPT-6 RELEASED), Matthew Berman
**URL:** https://www.youtube.com/watch?v=xdXLzFzxA9Q  **Views:** 33763  **Date:** 20260903  **Length:** 14:17
**ADDRESSES GOAL:** partially, provides official benchmark numbers, pricing, browser automation speedruns, and frontend game generation examples, but lacks CLI harness integration details or cost-per-task breakdowns.
**HANDS-ON:** yes (ChatGPT / Web UI and custom agent harness)

### Demonstrated findings (with timestamps)
- [00:31] Official Benchmark Matrix displayed on screen:
  - ARC-AGI-3: Astra 98.6% vs GPT-5.6 Sol 7.0%, Gemini 3.8 Flash 30.2%
  - FrontierMath Tier 4 (v2): Astra 97.6% vs Claude Fable 5.1 87.0%, GPT-5.6 Sol 83.0%, Claude Opus 5 87.0%, Gemini 3.8 Flash 73.2%
  - Agent's Last Exam: Astra 59.3% vs GPT-5.6 Sol 52.7%, Claude Opus 5 48.7%, Gemini 3.8 Flash 52.7%
  - AutomationBench: Astra 41.4% vs Claude Fable 5.1 31.4%, GPT-5.6 Sol 18.1%, Gemini 3.8 Flash 26.9%, Claude Opus 5 17.4%
  - BenchCAD: Astra 95.9% vs Claude Fable 5.1 84.3%, GPT-5.6 Sol 83.3%, Gemini 3.8 Flash 82.1%, Claude Opus 5 67.5%
  - DeepSWE v1.1: Astra 73.0% vs Gemini 3.8 Flash 73.7%, GPT-5.6 Sol 70.8%, Claude Opus 5 69.9%, Claude Fable 5.1 67.4%
  - Terminal-Bench Science 0.1: Astra 64.6% vs Claude Fable 5.1 52.6%, Gemini 3.8 Flash 29.0%, Claude Opus 5 24.7%, GPT-5.6 Sol 22.4%
  - GPQA Diamond: Astra 96.0% vs Gemini 3.8 Flash 95.3%, Claude Fable 5.1 93.7%, Claude Opus 5 92.6%, GPT-5.6 Sol 94.6%
  - GeneBench Pro: Astra 37.8% vs GPT-5.6 Sol 28.7%
  - MedChemBench (internal): Astra 49.1% vs GPT-5.6 Sol 47.4%
  - HealthBench Professional (length-adjusted): Astra 63.4% vs GPT-5.6 Sol 60.5%, Claude Opus 5 60.9% [57.5%], Claude Fable 5.1 56.6%, Gemini 3.8 Flash 52.1%
  - ExploitBench: Astra 100.0% vs Claude Opus 5 70%, GPT-5.6 Sol 5.5%
  - SRE-Bench (four attempts): Astra 99.2% vs GPT-5.6 Sol 68.7%
  - Auto-review circumvention (lower is better): Astra 0% vs GPT-5.6 Sol 0.20%
- [03:49] Alignment evaluation table displayed: "Staying within the authorized task" shows GPT-5.6 Sol went beyond target 48.2% of the time vs GPT-6 Astra at 0%.
- [05:26] Pricing card displayed: "$10 per million input tokens", "$50 per million output tokens", Fast mode: "up to 2.5x the speed at 2x the Standard price".
- [06:01] "Little Planet" interactive 3D WebGL world generated from a two-sentence prompt.
- [08:12] "Ratstronaut" playable multiplayer game recreated from a single prompt.
- [08:49] 7 mini isometric biomes rendered in 3D without asset clipping.
- [09:22] "Afterhours" fully navigable 3D city environment rendered entirely using ASCII characters.
- [10:00] "Newhaven" complex 3D SimCity clone created over a continuous 5-day agent execution run.
- [11:47] Screen recordings of browser actions: Excalidraw workflow constructed in 35.8s [12:13], eBay 3-card comparison finished in 1:38.7 [12:31], Kyoto trip route created in Google Maps in 1:23.4 [12:53].

### Asserted claims (with timestamps)
- [00:10] Presenter claims early access and extensive hands-on testing.
- [02:46] Quoted OpenAI blog: "It also sets a new frontier on computer and browser use, handling the most demanding professional work with unmatched speed, accuracy, and judgment."
- [03:41] Asserted OSWorld 2.0 performance is "about 7% better and 50% faster" than GPT-5.6 Sol.
- [04:46] Quoted research claims that Astra lowered the prime gap bound from 240 to 186 and updated an 80-year-old large-gap bound formula.
- [05:54] Claimed rollouts target ChatGPT Plus, Pro, Business, and Enterprise tiers over coming days, starting with Daybreak access.

### Strengths of Astra reported
- Exceptional spatial comprehension and 3D web asset construction.
- Rapid execution speed during browser interaction and visual data gathering.
- Flawless task constraint adherence (0% out-of-bounds actions).
- Frontier benchmark leadership in mathematics, CAD creation, and cybersecurity simulation.

### Weaknesses, failures, refusals, costs reported
- Standard API pricing is high: $10/M input, $50/M output; Fast mode increases token rate to 2x ($20/M input, $100/M output).
- DeepSWE v1.1 score (73.0%) was outperformed by Gemini 3.8 Flash (73.7%).
- Default session length tends to pause or complete around 30 minutes without specific steering.
- Default styling leans heavily toward repetitive flat designs and forest green/pastel palettes.
- Natural text generation retains an artificial prose structure ("AI smell").

### How-to-get-the-max tips (effort, prompts, harness, settings)
- Use `/goal` commands or explicit duration prompts to extend execution beyond the default 30-minute boundary [10:38, 13:09].
- Provide strict styling overrides to prevent the model from defaulting to muted green and pastel color palettes [13:33].
- Route multi-step web scraping and visual UI workflows directly through its native browser execution harness [11:47].

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- FrontierMath Tier 4: Astra 97.6% vs Fable 5.1 87.0% vs Sol 83.0%.
- BenchCAD: Astra 95.9% vs Fable 5.1 84.3% vs Sol 83.3%.
- DeepSWE v1.1: Gemini 3.8 Flash 73.7% vs Astra 73.0% vs Sol 70.8% vs Fable 5.1 67.4%.
- Terminal-Bench Science: Astra 64.6% vs Fable 5.1 52.6% vs Sol 22.4%.
- ExploitBench: Astra 100.0% vs Sol 5.5%.
- Task boundary adherence: Astra 0% failure vs Sol 48.2% failure.

### What the comments add (corrections, counter-evidence, first-hand reports)
- @MikeWoot65 highlights that the DeepSWE improvement over GPT-5.6 Sol is only 2.2 percentage points (73% vs 70.8%).
- @BlackShardStudio notes graphical flaws in the 3D demo, specifically inside-out UV mapped ice crystals at 6:45.
- @breopa-i4e emphasizes Gemini 3.8 Flash matching or beating Astra on key coding metrics.
- Multiple users express skepticism over benchmark reproducibility, API costs during long runs, and delayed consumer rollouts.

### Confidence in this source (1-5) and why
3/5. Matthew Berman demonstrates verified hands-on runs of custom 3D web environments and official metrics, but mixes promotional partner content without publishing raw code harnesses, exact API token bills, or side-by-side terminal evals.
