## Prompt Engineering is DEAD. (Here's what replaced it), Netsky AI Lab | R&D LLM AI 
URL: https://www.youtube.com/watch?v=4sxEWt512zE  Date: 20251201  Views: 63  Duration: 5:10
Class: ADJACENT
### Gemini analysis
### 1. Classification
**ADJACENT** ,  The video discusses Stanford's DSPy framework and automated prompt optimization (including GEPA / MIPROv2) rather than Microsoft SkillOpt directly.

---

### 2. Video Content & Empirical Data
* **M&A Information Extraction Case Study (03:35 - 04:05):**
  * **Student model:** `Gemini-2.5-flash-lite` | **Teacher/Reflection model:** `OpenAI gpt-4.1`.
  * **Baseline (human expert prompt):** 80.7% exact match score.
  * **Bootstrap FewShot:** 90.7% (+10.0%).
  * **GEPA (light):** 97.8% (+17.1% total gain).
* **Speed/Iteration Claim (03:30):** Claims automated prompt compilation executes optimization cycles that would take a human engineer 1 week in ~10 minutes.
* **Industry Shift Thesis (04:15 - 04:40):** Asserts "Prompt Engineer" is an obsolete title; role transitions to "Flow Engineering" (architecting LangGraph/agent topology and evaluation metrics while leaving prompt generation to compilers).

---

### 3. Claims about SkillOpt (GOOD at)
* *N/A* ,  The video focuses on DSPy and does not cover SkillOpt.

---

### 4. Claims about SkillOpt (BAD at / Breakpoints)
* *N/A* ,  Not covered.

---

### 5. Mechanism of Alternative (DSPy / GEPA / MIPROv2)
* **Declarative Signatures (02:08 - 02:38):** Decouples program logic from text strings; users define input/output signatures and constraints while the framework treats prompts as optimizable parameters.
* **Automated Teleprompter / Optimization Loop (03:07 - 03:29):** Running `.compile()` executes iterations against training data, inspects failure modes, rewrites system instructions, and mines optimal few-shot demonstrations.
* **Comparison to SkillOpt:** DSPy requires structuring pipelines as Python modules with explicit signatures and metric functions; SkillOpt optimizes unstructured/markdown skill files (`SKILL.md`) and tool-calling routines in text space.

---

### 6. Non-Verifiable Tasks & Non-Coding Workflows
* **Teacher/LLM-as-a-Judge Reflection (03:35):** Uses higher-tier teacher models (e.g., GPT-4.1) as automated evaluators/reflection mechanisms when deterministic assertions or unit tests are not viable.
* **Flow & Metric Architecture (04:15 - 04:30):** Shifts human effort to designing task graphs, constraints, and scoring rubrics rather than hand-tuning text.

---

### 7. Quality Signal
* **Low/Medium conceptual overview:** Talking-head presentation featuring screenshots of blog benchmarks and code prompts; no live terminal execution or hands-on code debugging shown.
### Comments (first-hand, corrections, disagreements)
none substantive (comments array empty)
