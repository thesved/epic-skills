## Setting up Skill Issues: Generate Evals and Optimize Agent Skills, Bauplan
URL: https://www.youtube.com/watch?v=jhkaH2-zY4g  Date: 20260803  Views: 28  Duration: 3:28
Class: ADJACENT
### Gemini analysis
### 1. Classification
**ADJACENT** (also a **TUTORIAL**): The video demonstrates setting up and running `skill-issues`, a tooling workflow using **GEPA** (not Microsoft SkillOpt) to generate benchmark datasets and optimize `SKILL.md` files against an evaluation harness [01:13, 03:02].

---

### 2. Video-Specific Content & Hands-On Details
* **Setup & Environment [00:10-01:10]:** Uses `just` task runner (`just install` creates venv and installs ~50 Python packages including `pydantic`, `litellm`, `modal`, `fastapi`, `boto3`) [00:25]. Requires API keys for OpenAI/Anthropic via LiteLLM and Modal credentials (`MODAL_TOKEN_ID`, `MODAL_TOKEN_SECRET`) for cloud execution [00:53, 01:13].
* **Synthetic Benchmark Generation [01:30-02:23]:**
  * Command: `just generate bauplan_lakehouse -n 3` [02:08].
  * Uses `anthropic/claude-3-5-sonnet` to generate synthetic benchmark tasks across difficulty tiers (easy, medium, hard) with attempts logged [02:14-02:22].
* **Optimization Execution [02:50-03:26]:**
  * Command: `just optimize bauplan_lakehouse bauplan-safe-ingestion` [02:51].
  * Configurable flags shown in help output [03:02]: `--dataset-entries`, `--max-metric-calls`, `--parallel/--no-parallel`, `--test-frac`, `--split-seed`, `--test-repeats`, `--resume-dir`, `--primary-only`.
  * Splits dataset (e.g., 25 train / 16 val / 16 test) and starts remote worker evaluation on Modal [03:16-03:26].

---

### 3. Claims about What SkillOpt is GOOD at
* **N/A:** The video does not evaluate SkillOpt; it showcases GEPA-driven optimization of domain-specific `SKILL.md` documentation (specifically `bauplan-safe-ingestion` for data lakehouses) [02:51].

---

### 4. Claims about What SkillOpt is BAD at / Failure Modes
* **N/A:** SkillOpt is not discussed or run.

---

### 5. Mechanism of the Alternative (GEPA / `skill-issues`)
* **Task Generation:** Automatically creates evaluation datasets with ground-truth test cases per domain using LLMs (`claude-3-5-sonnet`) broken into difficulty buckets [01:36, 02:14].
* **Optimization Harness:** Uses GEPA to iteratively mutate and evaluate candidate `SKILL.md` files against isolated execution environments (via Modal cloud workers and domain API endpoints) [00:48, 03:02, 03:17].
* **Comparison to SkillOpt:** While SkillOpt targets agent code/skill graph execution traces, GEPA in `skill-issues` focuses on prompt/markdown-level skill optimization (`SKILL.md`) evaluated against structured unit test/lakehouse task harnesses [01:13, 02:51].

---

### 6. Non-Verifiable Tasks / Non-Coding Workflows
* **Not directly addressed:** The demo relies strictly on verifiable task harnesses with deterministic domain APIs (`bauplan_lakehouse` API keys and endpoints) to compute evaluation metrics [02:33, 03:02].

---

### 7. Quality Signal
* **High practical credibility:** The author built/maintains the `skill-issues` repository, demonstrates real terminal CLI interactions, inspects configuration schemas, and triggers active cloud runs [00:10-03:27].
### Comments (first-hand, corrections, disagreements)
none substantive (no comments in prefetched data)
