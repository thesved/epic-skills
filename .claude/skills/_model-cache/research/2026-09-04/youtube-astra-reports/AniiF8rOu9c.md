## Video: GPT-6 Astra blew away every one of my benchmarks, How I AI
**URL:** https://www.youtube.com/watch?v=AniiF8rOu9c  **Views:** 5355  **Date:** 20260903  **Length:** 32:20
**ADDRESSES GOAL:** yes, provides extensive hands-on workflow demonstrations of GPT-6 Astra across complex browser use, software engineering, 3D asset generation, and multi-agent coordination.
**HANDS-ON:** yes (ChatGPT early access, Codex Mac desktop app / CLI, Chrome browser automation)

---

### Demonstrated findings (with timestamps)
- **[01:06 - 03:08] Official Benchmark Slides shown on screen:**
  - ARC-AGI-3: 98.6%
  - FrontierMath Tier 4 (v2): 97.6% (GPT-6 Astra) vs 83.0% (GPT-5.6 Sol)
  - ExploitBench: 100%
  - AutomationBench: 41.4% (GPT-6 Astra) vs 18.1% (GPT-5.6 Sol) (slide notes: "Astra more than doubles Sol's reported score here... 62% lower cost")
  - DeepSWE v1.1: 73.0% (GPT-6 Astra) vs 70.8% (GPT-5.6 Sol)
- **[03:10] Pricing & Access Tier Card shown on screen:**
  - Input: $10 per 1M tokens
  - Output: $50 per 1M tokens
  - Speed: "Up to 2.5x speed" (Fast mode)
  - Rollout: Phased to Daybreak enterprise customers first, rolling out to ChatGPT Plus, Pro, Business, Enterprise, and API (OpenAI and AWS).
- **[05:48 - 08:50] Autonomous Node-Based Workflow Configuration (Attio CRM via Chrome):**
  - Presenter gave Codex natural language instructions to configure a complex node-graph CRM workflow in Chrome.
  - Codex autonomously launched Chrome, manipulated node blocks, set schema variables (`owner`, `reason`, `needs_review`, `email_to`, `email_subject`, `email_body`), wired Slack routing, and configured conditional paths hands-free.
- **[09:10 - 15:20] Browser-Based Multi-Step Creative Pipeline (Flora AI Canvas):**
  - Codex took raw headshots, opened Flora inside Chrome, navigated an intricate node graph, configured `GPT Image 2` generation nodes with custom aspect ratios and lighting prompts, batch-processed images, and returned finished thumbnail assets to Slack.
- **[13:14 - 14:18] Full-Stack Autonomous QA & Debugging Run (Codex):**
  - Codex terminal run titled "Stabilize main chat errors" logged a duration of `1h 46m 47s`.
  - Executed 1,452 unit/typecheck tests, opened the preview branch in Chrome, inspected console/network error logs, diagnosed streaming persistence race conditions, fixed TipTap editor conflicts, and generated clean PR git diffs (+52 / -1, +53 / -3).
- **[15:41 - 18:35] Autonomous Product Intelligence & Auto-Wiki Generation:**
  - Astra ingested unstructured data from Intercom, Linear, Granola, and GitHub to build a complete customer feedback intelligence engine and an interactive product wiki exposed via MCP.
- **[18:44 - 20:30] Hardware Hacking & Reverse Engineering (Divoom Ditoo Mini 2):**
  - Astra reverse-engineered the proprietary Bluetooth pixel protocol, built a local web UI (`minitoo / Live Studio`) at `127.0.0.1:8165`, and created a CLI tool to stream dynamic pixel animations, live podcast status, and text notifications directly to the physical device.
- **[23:33 - 26:03] Native Desktop App Development (Codex AIM Messenger):**
  - Astra built a fully functional 1990s AOL Instant Messenger clone in 33 minutes and 38 seconds (`Worked for 33m 38s`, `+52,702` LOC changes) that hooks into the Codex backend to manage multiple concurrent agent threads as buddy list contacts.
- **[25:45 - 28:51] Complex 3D Asset & Game Generation:**
  - Astra scripted Blender to produce rigged 3D character models and built interactive 3D web applications (`Barbie Fashion Designer` and `Kidkin` 3D isometric world with WASD / keyboard navigation) in single zero-shot/one-shot prompts.
- **[29:00 - 29:25] Direct Design Tool Automation (Figma via Browser Use):**
  - Codex autonomously manipulated Figma in Chrome to composite generated photos, typography, and badges into polished YouTube thumbnail variants.

---

### Asserted claims (with timestamps)
- **[00:27]** Claire asserted Astra is "the model in the last six months... that has made me actually feel more ambitious" and solved persistent tasks that Fable and GPT-5.6 Sol failed to solve.
- **[02:12]** Asserted common computer tasks like apartment hunting can drop from 6 hours to under 10 minutes (referencing OpenAI marketing slide).
- **[08:24 - 08:55]** Asserted that because Astra handles complex web UIs natively via computer use, developers do not necessarily need MCPs or CLIs for every external tool if a web UI exists.
- **[16:21]** Asserted that Claude Fable did "insane things with the architecture" on the product intelligence task but failed on final insight synthesis, while GPT-5.6 Sol got stuck on insight quality.
- **[30:48]** Asserted that basic web development / "website vibe coding" is effectively solved, pushing state-of-the-art AI coding to complex 3D game engines, desktop apps, and hardware hacking.
- **[31:15 - 31:25]** Asserted that Astra is "not annoying", feels "kind of slow, but like not too slow", and is becoming her primary daily driver model.

---

### Strengths of Astra reported
- **Complex UI Navigation:** Flawlessly navigates dense canvas and node-graph web applications (Attio, Flora, Figma) without misclicking or losing state.
- **Long-Horizon Engineering QA:** Autonomously runs extended browser debugging sessions (over 1.5 hours continuously), reading console logs, fixing frontend race conditions, and verifying builds.
- **Architectural Synthesis & Data Extraction:** Extracts clean, structured insights from messy real-world data sources (Intercom, GitHub PRs, Linear issues) and generates structured wikis without quality degradation.
- **Hardware Protocol & Low-Level Tooling:** Capable of reverse engineering undocumented peripheral hardware protocols and writing custom Bluetooth/CLI control bridges.
- **Complex 3D Generation:** Generates valid Blender scripts, 3D meshes, textures, and interactive Three.js/isometric WebGL environments from high-level prompts.

---

### Weaknesses, failures, refusals, costs reported
- **Network / Backend 404 Disconnects:** Codex interface exhibited backend connection drops during long sessions (e.g. at timestamp [23:33]: `"unexpected status 404 Not Found: Unknown error, url: https://chatgpt.com/backend-api/app/codex/responses"`).
- **Execution Speed:** Claire noted the reasoning and execution can feel somewhat slow on heavy tasks.
- **High Raw API Cost:** At $10/1M input and $50/1M output, API token costs are substantial for heavy agentic loops compared to smaller utility models.
- **Imperfect Complex 3D Physics:** Mesh generation (such as pants/shoes in the Barbie 3D demo) still requires human aesthetic filtering and has minor polygon/texture artifacts.

---

### How-to-get-the-max tips (effort, prompts, harness, settings)
- **Harness:** Run Astra inside the Codex desktop app with Chrome browser automation enabled to unlock end-to-end autonomous debugging, frontend testing, and canvas tool manipulation.
- **Prompting for Node Graph / Canvas Tools:** Instruct Codex to inspect existing canvas state in Chrome, read available UI elements, and construct workflows directly rather than manually coding API glue.
- **System Integration:** Use Codex hooks to link local CLI notifications to custom desktop or hardware output channels so you can leave multi-hour QA tasks running in the background.

---

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- **FrontierMath Tier 4 (v2):** GPT-6 Astra scored **97.6%** vs GPT-5.6 Sol at **83.0%**.
- **AutomationBench:** GPT-6 Astra scored **41.4%** vs GPT-5.6 Sol at **18.1%** (more than double Sol's automation score at 62% lower comparative evaluation cost).
- **DeepSWE v1.1:** GPT-6 Astra scored **73.0%** vs GPT-5.6 Sol at **70.8%**.
- **Qualitative Coding Benchmark (Auto-Wiki / Product Intelligence):** Claude Fable handled high-level architecture but failed to synthesize quality data; GPT-5.6 Sol failed on insight depth; GPT-6 Astra achieved a clean 90% implementation on one shot and completed it within 3 prompts.
- **3D Barbie Benchmark:** Fable produced flat, distorted 2D/3D approximations with severe proportion flaws; Astra generated fully rigged 3D models in Blender and interactive 3D web apps in a single shot.

---

### What the comments add (corrections, counter-evidence, first-hand reports)
- **Browser/Computer Use Reliability Issues:** User `@its_ohjey` reported that computer use/browser use frequently fails for them, failing mouse movements and silently falling back to curl/terminal workarounds instead of signaling an error.
- **Independent Index Comparison:** User `@MauricioCarlosFernandez` shared Artificial Analysis Intelligence Index figures: Claude Fable 5.1 = 66, Opus 5 = 63, Fable 5 = 62, Muse Spark 1.3 = 62, GPT-6 Astra = 61, GPT-5.6 Sol = 61.
- **Reasoning Level Comparisons:** User `@ozymandias8523` asserted that "Gpt6 astra low is better than gpt 5.6 sol high".
- **Hype vs Reality Skepticism:** User `@vitalinlet` criticized the video as overly promotional influencer content.

---

### Confidence in this source (1-5) and why
**4 / 5**
- **Pros:** Claire Vo provides direct screen recordings of real production repositories, working software projects (ChatPRD, Attio, Flora), actual terminal logs with timestamps, and physical hardware control runs.
- **Cons:** Benchmarks cited at the start are vendor-reported numbers from OpenAI announcement slides rather than an independent controlled benchmark suite.
