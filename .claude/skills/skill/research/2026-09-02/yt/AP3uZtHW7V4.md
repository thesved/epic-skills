## SkillCoach: Self-Evolving Rubrics for Evaluating and Enhancing Agentic Skill-Use, Praveen Govindaraj
URL: https://www.youtube.com/watch?v=AP3uZtHW7V4  Date: 20260711  Views: 35  Duration: 5:49
Class: ADJACENT
### Gemini analysis
### 1. Classification
**ADJACENT**
This video is a paper summary of **SkillCoach** (*SkillCoach: Self-Evolving Rubrics for Evaluating and Enhancing Agentic Skill-Use*, arXiv 2607.01874), an alternative/complementary framework focused on trajectory-level process evaluation, distractor-robust skill selection, and self-evolving rubrics rather than Microsoft SkillOpt.

---

### 2. Information Not in the SkillCoach Paper / README
* **Pure Regurgitation / Slide Deck Overview:** The video presents zero new code execution, terminal sessions, or original empirical benchmarks beyond reciting the figures and tables directly from the arXiv paper.
* **No Hands-on Implementation:** No installation commands, token cost telemetry, or practical debugging logs are shown.
* **General Commentary (04:47-05:35):** The speaker provides high-level narrative takeaways emphasizing that enterprises must test how many distractor skills an agent can handle before retrieval/selection collapses.

---

### 3. Claims About What the System (SkillCoach) is GOOD at
* **Process-Level Diagnosis across 4 Meta-Abilities (02:03-02:23):** Diagnoses not just final output, but whether an agent performed accurate skill selection, key-step following, multi-skill composition, and error reflection (Evidence: Benchmark & Framework Design).
* **Self-Evolving Evaluation Rubrics (03:01-03:24):** Iteratively refines evaluation criteria via real rollouts, arbitration, and hard/soft gating, increasing gold-keypoint coverage from 71.56% to 83.70% and reducing hallucination to 0.00% (Evidence: Benchmark Table 2).
* **Data Curation for SFT (03:24-03:57):** Filtering training trajectories using evolved rubrics (R-best) boosts downstream model performance, e.g. Qwen3.5-9B accuracy increases from 18.0% to 32.0% under distractor settings (Evidence: Benchmark Table 4).

---

### 4. Claims About System Weaknesses / Where Skill Usage Breaks
* **Distractor Sensitivity & Skill Selection Collapse (04:00-04:46):** Even frontier models (GPT-5.5, Opus 4.7, Gemini 3.1 Pro) experience severe degradation and eventual total performance collapse when distractor/semantically overlapping skills in the library scale toward 50,000+ items (Evidence: Benchmark Figure 4).
* **Misleading Outcome-Only Verification (00:35-01:15, 01:42-02:02):** Agents frequently guess answers or skip mandatory operational procedures while still passing superficial outcome verifiers, generating brittle execution traces (Evidence: Motivating Trajectory Examples).

---

### 5. Mechanism of Alternative (SkillCoach) vs. SkillOpt
* **Mechanism:**
  1. *Rollout & Trajectory Logging (02:42-03:00):* Executes agent tasks in environments populated with gold and semantically confusing distractor skills, capturing the full step-by-step trace.
  2. *LLM Judge & Arbitration Loop (03:01-03:23):* An LLM evaluates traces against 4 meta-abilities; an arbitration module updates candidate rubric patches via acceptance gating.
  3. *Rubric-Filtered Fine-Tuning (03:24-03:57):* High-quality trajectories passing both outcome verification and process rubrics are filtered to fine-tune smaller models.
* **Evidence:** Benchmark comparisons across frontier models (DeepSeek-V4, Claude Opus 4.7, GPT-5.5, Gemini-3.1-Pro, Qwen3.5) across 18 training and 10 testing tasks (03:40-04:13).
* **Comparison to SkillOpt for the Goal:**
  * *SkillOpt* focuses on *optimizing the text prompt/code of the skill itself* (improving `SKILL.md` instructions and tool definitions).
  * *SkillCoach* focuses on *evaluating and training the agent's meta-ability to select and execute existing skills* in large libraries with distractors. It provides the process verification rubrics needed to evaluate whether skill text modifications actually improve procedural adherence.

---

### 6. Non-Verifiable Tasks & Non-Coding Workflows
* **Cross-Domain Task Inventory (01:21-01:31, 05:12-05:35):** Evaluates tasks across Office Productivity (offer letter generation, PDF table conversion), Business/Financial Analytics (SEC financial reports, DCF analysis), Environmental/Scientific workflows (NWS flood detection, earthquake calculation), and Information Retrieval.
* **Procedural Compliance for SOPs (01:21-02:02):** Directly applies to non-verifiable business workflows by enforcing intermediate step compliance (e.g., policy checks, validation sequences) via rubric criteria rather than relying on automated code unit tests.

---

### 7. Quality Signal
* **Low / Paper Summarizer:** The narrator is an automated AI voice channel summarizing figures directly from the arXiv PDF without running independent code, showing terminal output, or sharing repository reproduction logs.
### Comments (first-hand, corrections, disagreements)
none substantive (no comments in prefetched data)
