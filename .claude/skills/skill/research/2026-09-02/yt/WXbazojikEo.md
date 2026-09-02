## MUSE-Autoskill: Self-Evolving Agents via Skill Creation, Memory, Management, and Evaluation (May 202, AI Paper Slop
URL: https://www.youtube.com/watch?v=WXbazojikEo  Date: 20260529  Views: 113  Duration: 23:43
Class: ADJACENT
### Gemini analysis
### 1. Classification
**ADJACENT** ,  The video does not discuss Microsoft SkillOpt; instead, it provides an AI-narrated summary of ByteDance and RIT's paper *MUSE-AutoSkill: Self-Evolving Agents via Skill Creation, Memory, Management, and Evaluation* (May 2026).

---

### 2. Information Beyond the SkillOpt Paper / README
* The video contains **no new empirical runs by the creators**; it is an AI podcast breakdown summarizing the MUSE-AutoSkill paper.
* **Relevant data points from MUSE-AutoSkill for skill architecture:**
  * **Distillation Token Cost:** Synthesizing a reusable skill package takes ~383,000 tokens during one-time distillation (18:31).
  * **Runtime Savings:** Post-skill execution reduces median latency by 273 seconds and saves ~85,000 tokens per task (18:45-18:51).
  * **Cache Efficiency:** Catalog routing (injecting a concise YAML index and lazy-loading via `read_skill`) achieves ~58.5% prompt-cache absorption (17:49-19:07).
  * **Skill Anatomy:** Agent-generated `SKILL.md` interface files averaged 326 lines (2.2x longer than human-authored median of 146 lines) because models explicitly specified schemas, edge cases, and failure modes (13:54-14:12).

---

### 3. Claims About What SkillOpt Is GOOD At
* **N/A:** SkillOpt is not mentioned in this video.

---

### 4. Claims About What SkillOpt Is BAD At
* **N/A:** SkillOpt is not mentioned in this video.

---

### 5. ADJACENT Alternative: MUSE-AutoSkill Mechanism & Comparison

#### Mechanism (3 Bullets):
* **5-Stage Skill Lifecycle:** Unifies skill creation (delegated to a sub-agent `Skill Creator`), evaluation (isolated sandbox execution of generated `tests/`), memory management, evaluation, and refinement (closed-loop automated patch on traceback failure) (01:25, 06:15-07:45).
* **Skill-Level Memory (`.memory.md`):** Appends localized runtime notes, caveats, and failure quirks to individual skill directories, surfaced alongside `SKILL.md` upon invocation without polluting the global context window (08:35-09:05).
* **Adaptive DAG Context Compression & Catalog Routing:** Manages conversation history as an immutable DAG with Level 1 node-level summarization (>15k tokens) and Level 2 chain compression (>180k tokens, pinning first/last 5 turns), while skills are indexed in a lightweight YAML catalog and lazy-loaded (09:20-10:55, 17:35-18:10).

#### Evidence:
* **Benchmark (SkillsBench 51 tasks, GPT-5.5 backbone):**
  * Vanilla agent: 53.19% (12:31).
  * Human reference skills: 68.40% (12:47).
  * MUSE self-created skills: 87.94% accuracy on the 35 achievable tasks (60.35% overall macro-average across all 51) (13:24-13:28).
  * **Cross-Agent Zero-Shot Portability:** Transferring raw MUSE skill directories directly to Hermes boosted zero-shot performance from 47.89% to 58.40% (+10.51 pp lift), closing 79% of the gap to human skills (16:30-16:48).

#### Comparison to SkillOpt for Power Users:
* **Optimization Space:** SkillOpt performs iterative text-space meta-prompt/skill optimization driven by validation feedback. MUSE synthesizes entire multi-file skill packages (`SKILL.md`, `scripts/`, `tests/`, `.memory.md`) directly from successful execution trajectories.
* **Failure Modes:** MUSE suffers from a "Phase 1 cold-start bottleneck" -- if the model cannot solve the task zero-shot, no trajectory exists to distill (19:33-20:25) -- and can overfit rigid procedural parameters (e.g., PID tuning constants) to simulator noise (20:48-21:26).

---

### 6. Application to Non-Verifiable Tasks & Non-Coding Workflows
* **Document Processing & Ops:** Tested on SkillsBench domains including `Doc Processing` (SEC financial reporting, regulatory parsing) and `Ops & Planning` (cloud routing diagnostics) (14:45-14:55, 20:11).
* **Structuring SOPs / `SKILL.md`:** The audit revealed that effective reusable skills require:
  1. Rigid, explicit input/output schemas (14:31).
  2. Documented edge cases and branch failure modes rather than relying on assumed LLM context (14:21-14:40).
  3. Decoupling the high-level interface description (for catalog selection) from verbose procedural guidelines (lazy-loaded on demand) (17:49-18:10).

---

### 7. Quality Signal
* **Low / Synthetic (Regurgitation of Adjacent Paper):** AI-generated dialogue reciting paper figures, charts, and tables without independent execution, CLI demonstrations, or original source code validation.
### Comments (first-hand, corrections, disagreements)
none substantive
