## Video: GPT-6-Astra | First impressions, Arena AI
**URL:** https://www.youtube.com/watch?v=GQPi39sjNhU  **Views:** 6076  **Date:** 20260903  **Length:** 33:50
**ADDRESSES GOAL:** partially, provides real hands-on evaluations of Astra reasoning tiers, generation times, and direct side-by-side output comparisons against Claude Fable 5.1 and GPT-5.6 Sol across complex interactive 3D/full-stack artifact generation.
**HANDS-ON:** yes (custom evaluation harness / web generation gallery displaying 54 interactive artifacts generated via Astra API across reasoning tiers)

### Demonstrated findings (with timestamps)
- 00:09: Shows an evaluation gallery of 54 completed interactive full-stack/3D web applications generated across 7 collections.
- 00:20: Demonstrates "London Through Time", a multi-era interactive voxel simulation (Roman AD 120 through 2026) running in a single web file with first-person navigation.
- 01:37: Demonstrates "D-Day Landings - Omaha Beach" generated at reasoning level `Ultra`, showing 3D ocean rendering, animated troop paths, landing craft, and tanks.
- 03:27: Demonstrates "PALIMPSEST - Demo Tour", an open-world 3D first-person game containing multi-scene world switching, interactive mini-games (05:01), and audio narrative.
- 05:34: Demonstrates "Golden Gate Bridge" generated at reasoning level `Max`. Took between 20 to 40 minutes to generate in a single run (05:56).
- 07:13: Demonstrates "Neuschwanstein" castle 3D viewer showing seasonal lighting controls and complex structural geometry.
- 09:05: Demonstrates "X-Ray Cabinet", an interactive continuous cross-section slider transitioning between anatomical skeletal and outer meshes.
- 10:24: Demonstrates "Inside a Leaf", executing multi-scale zoom transitions from whole leaf macro view down to chloroplast atomic structure.
- 14:41: Demonstrates "One Riverbank, 2,000 Years", rendering 5 historical London eras including particle fire simulations during the Great Fire.
- 21:28: Demonstrates dynamic SVG generation ("Pavo"), featuring animated rotating peacock head, responsive eye gaze, and procedural feather unfurling.
- 23:01 - 27:04: Side-by-side comparison of "Rome" generated across 6 reasoning levels (`Low`, `Medium`, `High`, `Extra High`, `Max`, `Ultra`).
- 27:06 - 28:40: Side-by-side comparison of "Sagrada Familia" across reasoning levels (`Low`, `Medium`, `High`, `Extra High`, `Max`, `Ultra`).

### Asserted claims (with timestamps)
- 05:56: Single-shot `Max` reasoning generations consistently take "about 20 to 40 minutes to run" (asserted).
- 07:40: Prior OpenAI models had "egregious", "really bad menus", and "overbearing UI", whereas Astra has refined UI design taste (asserted).
- 16:15: Generating equivalent complex worlds in Claude Fable 5.1 frequently timed out Arena's harness and required extending run timeouts past 4 hours, whereas Astra completes in 20 to 30 minutes (asserted).
- 18:37: Confirms "zero cherry-picking" across shown single-shot demos (asserted).
- 24:18: Astra on `Low` reasoning level outperforms the highest reasoning tiers of GPT-5.5 and older models (asserted).
- 28:23: The `Ultra` reasoning tier is generally not worth the added token cost over `Max`, as `Max` frequently delivers comparable or superior visual coherence (asserted).
- 31:18: GPT-5.6 Sol was clearly behind Claude Fable 5.1, but GPT-6 Astra is fully competitive with and in several aspects superior to Fable 5.1 (asserted).

### Strengths of Astra reported
- Spatial World Modeling: Exceptional global coordination across multi-element 3D scenes (e.g., ships, roads, terrain, and architecture aligning properly without clipping).
- Speed vs. Competition: Executes complex reasoning and deep artifact construction in 20 to 40 minutes at `Max`, compared to 4+ hours for Claude Fable 5.1.
- Frontend Aesthetics: Produces modern, tasteful UI layouts and typography out-of-the-box compared to previous GPT models.
- Low-Tier Viability: `Low` and `Medium` reasoning settings generate highly coherent, functional complex applications without degrading into broken code.

### Weaknesses, failures, refusals, costs reported
- Physics Dynamism: Subtly less fluid dynamic motion and organic character animation (e.g., swimming salmon at 10:06, jumping whales at 20:20) compared to Claude Fable 5.1.
- Visual Glitches: Occasional floating assets (e.g., floating bridge at 07:22, intersecting vehicle meshes at 31:26).
- Diminishing Returns at Ultra: `Ultra` consumes massive output reasoning tokens without reliably beating `Max` in quality or architectural coherence (28:23).
- Generation Latency: Single-prompt runs still require 20 to 40 minutes of compute time on high reasoning tiers.

### How-to-get-the-max tips (effort, prompts, harness, settings)
- Reasoning Setting Selection: Default to `Max` for complex, high-detail full-stack apps. Avoid `Ultra` unless specifically testing frontier boundaries due to steep token cost without clear quality gains.
- Exploit Low Reasoning: Use `Low` or `Medium` for faster, token-efficient scaffolding; their spatial coherence remains strong.
- Multi-scale Coordination Prompts: Frame complex prompts with hierarchical structures (e.g., global maps down to street views, macro scales down to atomic views); Astra handles deep semantic nesting well.
- Long Timeout Harness: Ensure execution harnesses support 45 to 60 minute timeouts for high reasoning requests to prevent dropped connections.

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- Generation Time: Astra `Max` took 20 to 30 minutes on complex architectural landmarks (15:50), whereas Claude Fable 5.1 took >4 hours and hit harness timeouts (16:15).
- Model Standing: GPT-5.6 Sol was noticeably behind Claude Fable 5.1 (31:18). Astra pulls OpenAI level with or ahead of Fable 5.1 in spatial design and UI generation.
- Dynamic Motion: Claude Fable 5.1 remains slightly superior in organic animation and reactive realism (08:12, 10:06).
- Low Tier vs Past Flagships: Astra `Low` reasoning outperforms GPT-5.5 extra high (24:18).

### What the comments add (corrections, counter-evidence, first-hand reports)
- API Parameter Details: User @Spiderjin clarifies that the API reasoning ladder consists of `low`, `medium`, `high`, `xhigh`, and `max` (priced at standard rates, where higher tiers dump more reasoning tokens), confirming that `max` is the optimal ceiling over experimental `ultra`.
- Access and Gating: Users note phased rollout and access restrictions (@PromethorYT, @holgerstegemann338), pointing out that not all Pro tier subscribers received immediate day-one access.
- Comparative Sentiment: Comments validate that Fable 5.1 still retains an edge in procedural realism/movement (@ReeXin), while Astra marks a major architectural step up over Sol 5.6 (@zachary3603).

### Confidence in this source (1-5) and why
**4/5.** Peter Gostev demonstrates extensive, verifiable hands-on screen recordings across dozens of generated applications with direct reasoning tier comparisons. Deducted 1 point because test cases focus primarily on 3D/full-stack visual web apps rather than raw backend code refactoring, test suites, or standard software engineering benchmarks.
