## EvoAgentX Talk: SkillOS: Learning Skill Curation for Self-Evolving Agents, EvoAgentX
URL: https://www.youtube.com/watch?v=SdX0nX9mXgs  Date: 20260608  Views: 106  Duration: 1:02:22
Class: ADJACENT
### Gemini analysis
### 1. Classification
**ADJACENT** - The video is an academic presentation and Q&A by first author Siru Ouyang (UIUC/Google Cloud) presenting **SkillOS** (*Learning Skill Curation for Self-Evolving Agents*, arXiv 2605.06614), an alternative RL-based framework for streaming skill curation and evolution.

---

### 2. Information NOT in SkillOpt Paper / New Empirical Findings
* **Curator Execution Wall-Clock Bottleneck (57:21-57:55):** A single RL training step takes **10-20 minutes** on ALFWorld because the environment executor must roll out an entire group of streaming tasks (approx. 10 sequential tasks) between curator updates.
* **Skill Operation Distribution Dynamics (17:55, 34:00-35:30):** Early in RL training, `insert` operations dominate (~80%); midway through, the model shifts toward `update` (~30-40%) to refine and consolidate existing skills, while `delete` remains low (~5%) throughout training.
* **Curator-Executor Model Capacity Mismatch (23:45-25:55, 34:10-35:55):** Using an overpowered oracle curator (Gemini-2.5-Pro) to generate skills for a smaller executor (Qwen3-8B) caused performance degradation due to a capability gap (the 8B executor lacked the reasoning ability to execute high-level abstractions formulated by Gemini).
* **Task Grouping Requirement (18:00-18:50, 50:10-51:00):** Random task ordering during RL training produces sparse reward signals; grouping semantically related tasks into multi-task batches during training is critical for GRPO convergence (ablation drops success rate from 61.2% to 57.5%).

---

### 3. Claims About What SkillOpt Is GOOD At
* *N/A directly to SkillOpt.* Regarding text-space skill optimization in general (evidence: benchmark & demo, 23:25-26:45): Modular text/Markdown skill repositories allow frozen executors to achieve **+2% to +14% success rate gains** across sequential agentic environments without fine-tuning model weights.

---

### 4. Claims About What Text-Space / Prompt Optimizers Break At
* **Reward Hacking via Verbatim Copying (20:50-21:20):** Without an explicit length/conciseness penalty reward, LLM skill curators degrade into simply copying raw episode trajectories into Markdown files, collapsing skill induction into bloated in-context demonstrations.
* **Retrieval Scaling Bottleneck (37:21-38:50):** As a skill repository grows past dozens/hundreds of Markdown files, in-context curation fails; standard dense/BM25 retrieval struggles to locate relevant compound skills.

---

### 5. Mechanism of SkillOS (ADJACENT Alternative)
* **Modular Decoupling:** Separates a small, trainable 8B **Skill Curator** from a frozen downstream **Agent Executor** (e.g., Qwen3-32B or Gemini-2.5-Pro) that interacts with tools/environments (10:50-11:30).
* **Tool-Based Skill Operations:** The curator modifies a flat directory of `skill_*.md` files via structured JSON function calls: `new_skill_insert`, `skill_update`, and `skill_delete` (14:50-15:45).
* **Reinforcement Learning via GRPO:** Trains the curator using Group Relative Policy Optimization on a composite reward: task outcome success + format validity + skill quality (evaluated by a 32B judge LLM rubric) + length conciseness penalty (17:55-21:30).
* **Comparison to SkillOpt:** While SkillOpt performs search/optimization over prompt configurations for specific workflows, SkillOS trains an online lifelong curator model via RL to continuously maintain, rewrite, and prune a Markdown skill store during streaming execution.

---

### 6. Non-Verifiable Tasks & Non-Coding Workflows
* **LLM-as-a-Judge for Non-Binary Objectives (20:15-20:40):** SkillOS evaluates skill quality using a 32B LLM judge scoring against rubrics (clarity, applicability, absence of redundancy) when strict environmental success signals are indirect or delayed.
* **Application to General Agentic Environments (22:30-24:35, 36:20-37:20):** Validated on household planning (ALFWorld) and web shopping (WebShop). Skills induce generalized meta-strategies such as fallback recovery ("check alternative locations if item is missing"), failure-mode error handling, and state verification.

---

### 7. Quality Signal
* **High Credibility:** Primary research author (Siru Ouyang) presenting original experimental results, ablation metrics, failure mode distributions, and architecture details from a published Google Cloud/UIUC collaboration.
### Comments (first-hand, corrections, disagreements)
none substantive (comments array empty in prefetched metadata)
