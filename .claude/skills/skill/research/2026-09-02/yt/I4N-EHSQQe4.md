## Memento-Skills: Self-Evolving Agents via Read-Write Reflective Learning, Research Paper Review
URL: https://www.youtube.com/watch?v=I4N-EHSQQe4  Date: 20260321  Views: 410  Duration: 6:32
Class: ADJACENT
### Gemini analysis
### 1. Classification
**ADJACENT** ,  The video is an automated NotebookLM deep dive reviewing the *Memento-Skills* paper (a continuous learning/self-evolving agent architecture), not Microsoft SkillOpt.

---

### 2. Information Not in Paper / README
* Pure automated summary of the Memento-Skills paper with zero original hands-on testing, CLI execution, or unreleased benchmarks.
* No independent commands, token cost logs, or failure workarounds are presented beyond the paper's theoretical slides.

---

### 3. Claims About What SkillOpt is GOOD At
* **N/A** ,  Microsoft SkillOpt is not mentioned or evaluated in this video.

---

### 4. Claims About What SkillOpt is BAD At / Breaks
* **N/A** ,  No mention of SkillOpt limitations.

---

### 5. Mechanism & Comparison of Alternative (Memento-Skills)
* **Mechanism**:
  * **Read-Write / Heartbeat Loop [00:48-01:35]**: For each incoming task, a router reads the relevant skill from external memory, executes the workflow via a frozen LLM, receives environment feedback, and writes back updated skill definitions.
  * **Attribution & Rewrite Pipeline [03:54-04:26]**: When an attempt fails, the system performs root-cause skill attribution, proposes targeted prompt/Python code rewrites, and validates modifications via automatically generated unit tests before saving to memory.
  * **Modular Decoupling [02:41-03:43]**: Replaces rigid 30,000-line monolith agent scripts with layered modules (Entry Layer, Orchestration, Tool Dispatcher, and Evolving Skill Memory).
* **Evidence**:
  * **Humanity's Last Exam (HLE) [05:06-05:48]**: +116.2% relative performance gain over 3 optimization rounds (Biology: 30.3% → 60.7%, CS: 19.8% → 46.5%, Math: 30.0% → 51.2%, Physics: 21.1% → 47.4%).
  * **GAIA Benchmark [05:49-06:12]**: 66.0% accuracy vs. 52.3% baseline (+13.7 percentage points).
* **Comparison to SkillOpt for Text-Space Optimization**:
  * Like SkillOpt, Memento-Skills keeps the base LLM frozen and updates external skills/code in text space. However, Memento-Skills relies on dynamic unit-test generation for automated verification during the rewrite loop, whereas SkillOpt uses explicit multi-criteria evaluation and optimization loops across diverse tasks.

---

### 6. Non-Verifiable Tasks & Non-Coding Workflows
* The system evaluates multi-discipline scientific QA (Biology, Physics, Math) on the HLE benchmark [05:23], but the self-refinement loop fundamentally depends on verifiable unit tests [04:14] and deterministic environment feedback [00:58] to prevent regression. No mechanism is shown for subjective/non-verifiable evaluation (e.g., copywriting or general SOP refinement).

---

### 7. Quality Signal
* **Low / Synthetic**: Google NotebookLM AI-generated podcast summarizing academic paper slides; no live code execution or original presenter expertise [06:30].
### Comments (first-hand, corrections, disagreements)
none substantive
