## Video: GPT 6 Astra, RandomTechAce
**URL:** https://www.youtube.com/watch?v=LOjFUbF0DbU **Views:** 1 **Date:** 20260903 **Length:** 4:15
**ADDRESSES GOAL:** partially, contains official benchmark tables, pricing, system prompts, and harness notes from the release page but lacks third-party real-world testing.
**HANDS-ON:** no (reaction only, silent screen recording scrolling through OpenAI's announcement post).

### Demonstrated findings (with timestamps)
* **0:38 - 0:48:** Scroll of OpenAI announcement text highlighting ARC-AGI-3 (99.9%), FrontierMath Tier 4 (98%), and ExploitBench (100%).
* **0:50 - 1:16:** Charts for Terminal-Bench Science 0.1, ARC-AGI-3, FrontierMath Tier 4, ExploitGym honeypot, and Agents' Last Exam.
* **1:27 - 1:29:** BenchCAD cost and accuracy curve showing 95.9% mean voxel IoU.
* **1:44 - 1:49:** Side-by-side UI demo showing GPT-5.6 Sol versus GPT-6 Astra asking clarifying questions before building a site.
* **2:05 - 2:08:** Terminal-Bench 4.0 accuracy vs API cost curves.
* **2:25 - 2:27:** ExploitBench score curves comparing Astra to GPT-5.6 Sol.
* **2:35 - 2:45:** Safety graphs showing computer-use misalignment rate (2.4%), circumvention of auto-review (0.0%), and capability hallucination rate.
* **2:48 - 3:01:** Availability and API pricing details on screen.
* **3:05 - 3:48:** Full benchmark summary tables across Professional, Coding, Academic, Science/Health, Cybersecurity, and Alignment.
* **3:55 - 4:08:** Footnotes showing harness configurations, prompt instructions, and evaluation setups.

### Asserted claims (with timestamps)
* **0:38:** OpenAI claims Astra is the "world's most intelligent and aligned model."
* **1:16:** Text asserts Astra uses approximately 65% fewer output tokens than Claude Opus 5 on Agents' Last Exam.
* **1:17:** Text asserts Astra achieves higher computer-use performance on OSWorld 2.0 in "about 47% less time per task than GPT-5.6 Sol".
* **1:20:** Text asserts Codex harness update yields a "1.9x faster task completion compared to the current GPT-5.6 Sol experience".
* **1:29:** BenchCAD API cost is asserted to be "approximately 43% lower than Sol and 96% lower than Fable 5.1".
* **2:28:** OpenAI asserts Astra discovered and used "two previously unknown zero-day vulnerabilities" during evaluation.
* **2:43:** Text asserts Astra is "three times less likely than GPT-5.6 Sol to make inaccurate representations about its capabilities".

### Strengths of Astra reported
* **High Reasoning and Math:** 97.6% on FrontierMath Tier 4 (v2) and 96.0% on GPQA Diamond.
* **Autonomous Coding and Tool Use:** 57.7% on Terminal-Bench 4.0, 74.1% on DeepSWE v1.1, and 64.5% on FrontierCode 1.1 Extended.
* **Efficiency:** Completes tasks with fewer tokens and lower runtime latency compared to GPT-5.6 Sol and Claude models.
* **Alignment and Boundary Awareness:** 0.0% circumvention rate on Auto-Review denials; asks clarifying questions instead of making incorrect assumptions.

### Weaknesses, failures, refusals, costs reported
* **Strict Refusals:** Refuses advanced cybersecurity tasks such as proof-of-concept exploit creation without OpenAI Daybreak access (2:29).
* **Monitoring Pauses:** Safety checks may pause or stop execution in API, Codex, or ChatGPT if suspicious activity is detected (2:47).
* **Standard Pricing:** $10 per million input tokens and $50 per million output tokens (3:00).
* **Fast Mode Pricing:** 2x standard price ($20/M input, $100/M output) for up to 2.5x speed (3:00).

### How-to-get-the-max tips (effort, prompts, harness, settings)
* **API Model ID:** Available via API as `gpt-6-astra` and on Amazon Bedrock (3:00).
* **Footnote 1 Harness:** Use the responses API harness to match evaluation performance on interactive tasks (4:06).
* **Footnote 9 System Prompt:** Add the Codex developer prompt snippet: *"Avoid creating excessive test files. Create a new test file only when required by repository conventions or when no existing file is a suitable home. Avoid unrelated cleanup and unnecessary complexity. Reuse suitable existing utilities. Read relevant repository instructions and inspect nearby code, tests, documentation, and CI. Follow established conventions. The goal is clean, mergeable code."* (3:58).

### Comparisons vs Fable 5.1 / Sol / others (numbers)
* **Terminal-Bench 4.0:** Astra 57.7% vs Sol 37.3% vs Claude Fable 5.1 55.8% (3:24).
* **FrontierCode 1.1 Extended:** Astra 64.5% vs Sol 60.6% vs Claude Fable 5.1 63.6% (3:21).
* **FrontierMath Tier 4 (v2):** Astra 97.6% vs Sol 83.0% vs Claude Fable 5.1 87.8% (3:29).
* **ARC-AGI-3:** Astra 99.9% vs Sol 7.8% vs Claude Opus 5 30.2% (0:54, 4:08).
* **BenchCAD:** Astra 95.9% vs Sol 83.3% vs Claude Fable 5.1 84.3% (3:07).
* **AutomationBench:** Astra 41.4% vs Sol 18.1% vs Claude Fable 5.1 31.4% (3:07).
* **Computer Use Misaligned Outcome Rate:** Astra 2.4% vs Claude Fable 5.1 9.5% vs Claude Opus 5 11.5% (2:36).

### What the comments add (corrections, counter-evidence, first-hand reports)
* No comments are present on this video.

### Confidence in this source (1-5) and why
* **2/5:** The video contains authentic first-party release documentation and official benchmark figures, but contains zero independent testing, narration, or practical verification.
