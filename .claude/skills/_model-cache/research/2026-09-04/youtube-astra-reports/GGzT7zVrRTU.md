## Video: GPT-6 Astra Is Finally Here (And It’s REALLY Good), Matt Wolfe
**URL:** https://www.youtube.com/watch?v=GGzT7zVrRTU  **Views:** 240  **Date:** 20260903  **Length:** 19:32
**ADDRESSES GOAL:** partially, provides benchmarks, cost estimates, and real-time demonstrations of computer use and code execution, but lacks specific routing tips for hybrid Claude Code/OpenRouter stacks.
**HANDS-ON:** yes (ChatGPT / Codex CLI desktop interface with computer use enabled)

### Demonstrated findings (with timestamps)
- [05:28] **BuseyBench SVG Generation:** Generated an SVG portrait scoring 7.1 (Rank #1) at "Ultra reasoning / max mode", taking 9 minutes, consuming 63,858 tokens, with an estimated cost of $1.94.
- [07:33] **MegaBonk 3D Game Generation:** Created a playable 3D Three.js action game with 3 selectable classes (Knight, Ranger, Mage), weapons, enemies, leveling UI, and sound in 8 minutes from a single prompt.
- [09:12] **Interactive Showcase Web App (Orbis):** Codex generated a full interactive 3D planetary simulation in 38 seconds, allowing real-time parameter tweaking (sunlight, sea level, rainfall) and procedural terrain modification.
- [11:33] **Blender Computer Use:** Operated Blender directly via computer use to generate a 3D humanoid wolf figure (8 minutes), rigged it with a 50-bone skeleton and looping idle animation (6m 07s), and generated a running animation (18s).
- [13:23] **Unreal Engine 5 Game Generation:** Automated Unreal Engine over 35 minutes to create an interactive forest level ("Whisperwood") with foliage, ponds, lighting, and an imported playable animated wolf character.

### Asserted claims (with timestamps)
- [00:37] Matt asserted he received early access directly prior to general public availability.
- [01:08] Asserted rollout roadmap: limited organizations on Day 1, rolling out over coming days to ChatGPT Plus, Pro, Business, Enterprise, OpenAI API, and AWS.
- [04:26] Claimed the model feels significantly smarter than GPT-5.6 in subjective coding workflows despite benchmark closeness on the Artificial Analysis Index.
- [15:19] Shared Matt Shumer's X post asserting Astra built a full Manhattan environment in Unreal Engine over one week, as well as a multi-agent emergent conversational environment.

### Strengths of Astra reported
- Exceptional computer use capabilities, navigating desktop tools like Blender and Unreal Engine 5 autonomously.
- Fast execution speed on complex web development (38s for full interactive 3D web apps; 8m for multi-class 3D Three.js games).
- Strong spatial coding and SVG generation (1st place on BuseyBench with a 7.1 score).
- Near-perfect benchmark saturation on ARC-AGI-2 (99.9%), FrontierMath Tier 4 (97.6%), and GPQA Diamond (96.0%).

### Weaknesses, failures, refusals, costs reported
- Output animation in Blender was slightly "wonky" around hip/hammer movement on single-shot prompts [12:31, 12:44].
- Slight performance gap on DeepSWE v1.1 (74.1%) relative to Meta Muse Spark 1.3 (75.4%) [02:48].
- Cost per task on Artificial Analysis Index is $1.67 per task, higher than GPT-5.6 Sol ($1.38), though significantly cheaper than Claude Fable 5.1 ($3.49) [05:08].
- Gated rollout: Not immediately accessible to all users on release day [01:19].

### How-to-get-the-max tips (effort, prompts, harness, settings)
- **Settings:** Use max effort / "Ultra reasoning" mode for high-complexity visual coding and SVG generation [07:00].
- **Prompting:** Specify rendering engines explicitly (e.g., "3D game", "Three.js", "Unreal Engine") to prevent default fallback to basic 2D scripts [07:20].
- **Harness:** Leverage desktop computer use integration via Codex to automate end-to-end multi-step application tasks (rigging, scene assembly, compiling) without manual asset export [11:38, 13:23].

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- **ARC-AGI-2:** Astra 99.9% vs Sol 7.8% vs Fable 5.1 20.1% vs Opus 5 30.2% [03:40].
- **Terminal Bench Science 0.1:** Astra 64.6% vs Sol 22.4% vs Fable 5.1 52.8% vs Opus 5 30.0% [03:24].
- **Terminal Bench 4.0:** Astra 57.7% vs Sol 37.3% vs Fable 5.1 55.8% vs Opus 5 52.3% [02:04].
- **DeepSWE v1.1:** Astra 74.1% vs Sol 72.7% vs Fable 5.1 67.4% vs Opus 5 73.7% vs Gemini 3.8 Flash 73.9% vs Muse Spark 1.3 75.4% [02:04, 02:48].
- **AutomationBench:** Astra 41.4% vs Sol 18.1% vs Fable 5.1 31.4% vs Opus 5 17.4% [01:58].
- **Artificial Analysis Intelligence Index:** Astra 61.2 vs Sol 60.9 vs Fable 5.1 65.7 vs Opus 5 63.1 [04:04].
- **Cost per Intelligence Task:** Astra $1.67 vs Sol $1.38 vs Fable 5.1 $3.49 [05:08].
- **BuseyBench:** Astra 7.1 (#1) vs Fable 5.1 7.0 (#2) vs Gemini 3.7 Flash 6.6 (#3) [05:35].

### What the comments add (corrections, counter-evidence, first-hand reports)
- **Gating & Tier Access:** User @kikorino notes Astra is restricted to the $100 tier and unavailable on standard $20 Plus subscriptions.
- **Verification Skepticism:** User @zome59 claims the model selector was pixelated in Codex UI, alleging GPT-5.6 may have been active during parts of the video.
- **Cost Calculations:** User @Gai-i5x calculated that high-volume enterprise usage at Astra rates ($10/M uncached input, $1/M cached input, $50/M output) would equate to massive billing over extended agentic runs.
- **Benchmark Discrepancies:** User @AK__Productions points out that on Artificial Analysis Intelligence Index, Astra (61) matches GPT-5.6 Sol (61) and trails Fable 5.1 Max (66).

### Confidence in this source (1-5) and why
**4/5.** The presenter demonstrates live, timed runs inside Codex and third-party software (Blender, browser) with verifiable token telemetry. A point is deducted because several game world showcases rely on unverified third-party X video clips rather than direct local reproduction.
