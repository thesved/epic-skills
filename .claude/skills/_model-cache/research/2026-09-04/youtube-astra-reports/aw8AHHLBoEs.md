## Video: GPT-6 Astra Just Dropped, Here's Everything It Can Do, Omar Flores | AI & Automation
**URL:** https://www.youtube.com/watch?v=aw8AHHLBoEs  **Views:** 0  **Date:** 20260904  **Length:** 7:08
**ADDRESSES GOAL:** partially, because while the presenter does not test the model firsthand, he reviews OpenAI's official release announcement, benchmark charts showing cost and reasoning effort settings, harness updates, and safety pause behaviors.
**HANDS-ON:** no (reaction only to OpenAI blog post, announcement video, and news briefs).

---

### Demonstrated findings (with timestamps)
The presenter showed OpenAI blog materials, promotional clips, and an Excalidraw canvas on screen:
* **[00:11]** Excalidraw note quoting Greg Brockman calling Astra a "generational leap" and the arrival of AGI, stating it was trained on "more than 100,000 GPUs at its Stargate site in Texas."
* **[01:08 - 01:41]** Screenshot of OpenAI Preparedness Framework and ExploitBench chart (June to August 2026) showing Astra reaching nearly 100% success rate as output tokens increase, compared to GPT-5.6 Sol staying low. Text displayed: "If the misalignment monitor pauses a task, users in ChatGPT or Codex may be asked to review the action before continuing. When using other surfaces like API, the task will stop immediately."
* **[01:45, 02:08]** OpenAI blog page introducing GPT-6 Astra, stating rollout to "all ChatGPT Plus, Pro, Business, and Enterprise users, as well as through the OpenAI API and AWS."
* **[04:18 - 04:22]** Interactive chart for **Terminal-Bench Science 0.1**: Hover tooltip for GPT-6 Astra displays `Model: GPT-6 Astra`, `Resolution rate: 64.6%`, `reasoning effort: Max`, `API Cost: $26.20`.
* **[04:24 - 04:40]** Interactive chart for **ARC-AGI-3**: Shows GPT-6 Astra at 99.9%, Claude Opus 5 at 30.2%, and GPT-5.6 Sol at 7.8%. Footnote text states: "The average human tester scored 48%. GPT-6 Astra was evaluated with our response API harness, which better reflects real-world performance than the original benchmark harness... With this harness, we estimate Sol would score in the ballpark of ~30%."
* **[04:42 - 04:49]** **FrontierMath Tier 4 (v2)** chart: Astra achieves 98% accuracy. Claude Fable 5.1 tooltip shows `Score: 87.8%`. Text visible: "Astra is our most aligned model... As one way that we test this, we built a new evaluation informed by the Hugging Face Incident... Compared to GPT-5.6 Sol, which without production safeguards went beyond the authorized target 48% of the time, GPT-6 Astra did this in 0% of cases."
* **[04:51 - 05:08]** **Terminal-Bench 4.0** chart: Text states Astra reaches 57.9% compared to 37.3% for GPT-5.6 Sol and 55.6% for Claude Fable 5.1 ("at approximately 9% and 63% lower estimated API cost per task, respectively").
* **[05:09 - 05:32]** **AutomationBench** chart: Astra scores 41.4%, compared with 31.4% for Claude Fable 5.1 and 26.9% for Claude Opus 5.
* **[05:34 - 05:50]** Excalidraw comparison table showing multiple benchmarks across GPT-6 Astra, GPT-5.6 Sol, Claude Fable 5.1, Claude Fable 5, Claude Opus 5 (high), and Gemini 3.5 Flash. Handwritten text on canvas: "Pricing is double that of GPT 5.6 Sol. Right".
* **[06:39]** Blog text on Codex harness: "Alongside Astra, we are also updating the Codex harness to significantly improve the speed of computer use. Combined with Astra's efficiency, this translates to a 1.9x faster task completion compared to the current GPT-5.6 Sol experience, on the Mind2Web benchmark."
* **[06:42]** **BenchCAD** chart showing Astra reaching a 95.9% geometric-overlap score at "43% lower than Sol and 86% lower than Fable 5.1 in the configurations shown."
* **[06:50]** Blog text on collaboration: "When instructions leave room for interpretation, GPT-6 Astra is better from previous models at making the right call... In Codex, it can ask asynchronously while continuing work that doesn't depend on your reply..."

---

### Asserted claims (with timestamps)
* **[00:28 - 01:05]** Anthropic released Claude Fable 5.1 and Mythos 5.1 on September 1 at 2:00 PM, and OpenAI dropped Astra on September 3 at 4:30 PM right as Grok, Claude, and Cursor were experiencing outages at 11:00 AM.
* **[03:34 - 03:55]** Claimed Astra will change the AI industry forever and represents the largest amount of compute/training ever put into a single model.
* **[05:54 - 06:28]** Speculated that major AI labs coordinate release timing to steal hype from each other.

---

### Strengths of Astra reported
* **High-complexity science and mathematics:** 64.6% resolution rate on Terminal-Bench Science 0.1 at max reasoning effort [04:19], and 98% on FrontierMath Tier 4 [01:45, 04:42].
* **Interactive reasoning:** 99.9% on ARC-AGI-3 using the response API harness [04:25].
* **Terminal and automation agency:** 57.9% on Terminal-Bench 4.0 [04:53] and 41.4% on AutomationBench [05:15].
* **3D CAD modeling:** 95.9% geometric-overlap score on BenchCAD [06:42].
* **Asynchronous execution in Codex:** Can ask user clarifying questions asynchronously while continuing independent tasks in parallel [06:50].

---

### Weaknesses, failures, refusals, costs reported
* **Safety gating and task pausing:** The misalignment monitor will pause tasks if potential unauthorized or cyber activity is flagged. On ChatGPT/Codex surfaces, users must manually confirm to proceed; on the raw API, the task terminates immediately [01:41].
* **Cost:** Terminal-Bench Science 0.1 run at max reasoning cost $26.20 for a single task [04:19]. The presenter's notes state base token pricing is approximately double that of GPT-5.6 Sol [05:35].

---

### How-to-get-the-max tips (effort, prompts, harness, settings)
* **Reasoning Effort Setting:** Peak performance on heavy science tasks requires setting reasoning effort to `Max` (as demonstrated on Terminal-Bench Science 0.1) [04:19].
* **Response API Harness:** Use the new OpenAI response API harness for interactive evaluation and agentic task solving (yielded 99.9% vs ~30% on legacy harness) [04:25].
* **Codex Harness Update:** Leverage the updated Codex harness for computer-use workflows to achieve 1.9x speedup on web/desktop tasks [06:39].
* **Prompting Ambiguity:** Astra is optimized to handle underspecified prompts by inferring intent from context and asking clarifying questions asynchronously rather than stalling [06:50].

---

### Comparisons vs Fable 5.1 / Sol / others (numbers)
* **Terminal-Bench Science 0.1 [04:19]:** GPT-6 Astra: 64.6% vs GPT-5.6 Sol: ~30%, Claude Fable 5.1: ~45%, Claude Opus 5: ~10%.
* **ARC-AGI-3 [04:25]:** GPT-6 Astra: 99.9% vs Claude Opus 5: 30.2% vs GPT-5.6 Sol: 7.8%.
* **FrontierMath Tier 4 (v2) [04:48]:** GPT-6 Astra: 98% vs Claude Fable 5.1: 87.8%.
* **Terminal-Bench 4.0 [04:53]:** GPT-6 Astra: 57.9% vs Claude Fable 5.1: 55.6% vs GPT-5.6 Sol: 37.3% (Astra API cost ~9% lower than Fable 5.1, ~63% lower than Sol).
* **AutomationBench [05:09]:** GPT-6 Astra: 41.4% vs Claude Fable 5.1: 31.4% vs Claude Opus 5: 26.9% vs GPT-5.6 Sol: 18.6%.
* **BenchCAD [06:42]:** GPT-6 Astra: 95.9% (API cost 43% lower than Sol, 86% lower than Fable 5.1).

---

### What the comments add (corrections, counter-evidence, first-hand reports)
* None available (the video has 0 views and no comments provided).

---

### Confidence in this source (1-5) and why
**2/5.** The creator provides zero original hands-on testing, terminal executions, or independent verification. However, the video clearly captures official OpenAI benchmark graphs, tooltip data, safety framework documentation, and harness details directly from OpenAI's blog and release page.
