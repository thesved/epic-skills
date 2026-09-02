## SkillOpt Lifts GPT-5.5 Accuracy by 23.5 Points, Claude Coder
URL: https://www.youtube.com/watch?v=voApGrmYO6Q  Date: 20260826  Views: 16  Duration: 5:08
Class: REGURGITATION
### Gemini analysis
### 1. Classification
**REGURGITATION** ,  The video is an animated high-level summary restating the core concepts, architecture diagrams, and benchmark claims directly from the Microsoft Research SkillOpt paper and repository README without running new experiments.

---

### 2. Information Not in Paper / README
The video is pure **REGURGITATION**.
* **Zero new empirical benchmarks or logs:** Only restates the paper’s reported GPT-5.5 average accuracy improvements across direct chat (+23.5), Codex agent loop (+24.8), and Claude Code (+19.1) [02:44].
* **Standard README instructions:** The install and train command snippet shown [03:54] is taken directly from the project's documentation.
* **No original troubleshooting:** Does not include custom test runs, actual dollar costs, wall-clock timing runs, or uncovered bugs/fixes.

---

### 3. Claims About What SkillOpt is GOOD At
* **Agentic loop optimization (+24.8 points on Codex loop vs. +19.1 on Claude Code / +23.5 on chat):** Outperforms static prompts and shows higher relative lift within agentic execution loops than plain single-turn chat *(Evidence: Benchmark/Paper report)* [02:44 - 03:09].
* **Consistent benchmark dominance across target models:** Claimed best or tied in all 52 evaluated cells across 6 benchmarks, 7 target models, and 3 harness environments against TextGrad, GEPA, and EvoSkill *(Evidence: Benchmark/Paper report)* [03:11 - 03:32].
* **Zero inference-time compute overhead:** Optimizes purely into a single standalone Markdown file (`best_skill.md`), requiring zero auxiliary calls or runtime scaffolding once deployed *(Evidence: Benchmark/Paper claim)* [03:33 - 03:53].
* **Crash resilience and controlled exploration:** Resumes runs automatically from output directories and applies cosine learning rate schedules to bound text edits per step *(Evidence: Benchmark/Paper claim)* [01:44, 04:03].

---

### 4. Claims About What SkillOpt is BAD At / Where It Breaks
* **Extremely heavy training compute/cost:** Training requires running batches of 40 tasks across 4 epochs with LLM-evaluated rollouts on every candidate step *(Evidence: Opinion/Paper analysis)* [04:15 - 04:26].
* **Lack of out-of-the-box domain datasets:** The repository ships without pre-packaged task datasets, requiring users to handcraft structured train/validation/test splits *(Evidence: Opinion/Repo observation)* [04:27 - 04:36].
* **Author-selected baseline bias:** Reported gains are measured exclusively against unprompted/no-skill baselines on the authors' chosen benchmarks rather than verified by third parties *(Evidence: Critique/Opinion)* [04:37 - 04:47].

---

### 5. Mechanism of Alternative (ADJACENT)
*N/A ,  Video is classified as REGURGITATION.*

---

### 6. Application to Non-Verifiable Tasks / Non-Coding Workflows
* **Not addressed:** The video focuses strictly on coding agents (Codex agent loop, Claude Code) and programmatic benchmark tasks, offering no evaluation criteria or implementation strategies for open-ended research, copywriting, or subjective SOP refinement.

---

### 7. Quality Signal & Credibility
**Low / Synthetic overview:** The creator did not execute code live, show terminal logs, or share independent evaluation data, presenting only scripted voiceover slides reflecting the paper's claims.
### Comments (first-hand, corrections, disagreements)
none substantive
