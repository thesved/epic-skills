## CodexOpt: Optimize AGENTS.md and SKILL.md for Codex with GEPA-Inspired Feedback, Superagentic AI
URL: https://www.youtube.com/watch?v=EtqRVxsokdI  Date: 20260318  Views: 56  Duration: 1:41
Class: HANDS-ON
### Gemini analysis
### 1. Classification
**HANDS-ON** (with **ADJACENT** tooling) ,  The video demonstrates an end-to-end hands-on execution of `codexopt`, a CLI tool optimizing agent instruction files (`AGENTS.md` and `.codex/skills/**/SKILL.md`) using rule-based heuristics and the GEPA reflection engine.

---

### 2. Hands-On Results, Commands, Artifacts & Numbers (Not in SkillOpt Paper)
* **Concrete Workflow Demonstrated** [00:23-01:28]:
  * **Heuristic Agent Optimization**:
    ```bash
    codexopt --config codexopt.gepa.example.yaml optimize agents --engine heuristic --file AGENTS.md
    ```
    * Output: 1 file inspected, 1 improved, delta = +0.1200, heuristic applied: `dedupe_identical_lines` [00:23].
  * **Heuristic Skill Optimization**:
    ```bash
    codexopt --config codexopt.gepa.example.yaml optimize skills --engine heuristic --glob ".codex/skills/**/SKILL.md"
    ```
    * Output: 3 files inspected, 2 improved, average delta = 0.1900 (`ensure_frontmatter` delta +0.5700; `dup-lines` delta +0.0000; `verbose-review` delta +0.0000) [00:25].
  * **Dry-Run Inspection**:
    ```bash
    codexopt apply --kind agents --dry-run
    codexopt apply --kind skills --dry-run
    ```
    * Validates candidate changes without mutating source files [00:30-00:40].
  * **GEPA Reflection Optimization Run**:
    ```bash
    codexopt --config codexopt.gepa.example.yaml optimize agents \
      --engine gepa \
      --reflection-model gemini/gemini-2.5-pro \
      --max-metric-calls 2 \
      --file AGENTS.md
    ```
    * **Scores & Metrics**:
      * Baseline evaluation score: 0.4700 [00:54].
      * Iteration 1 candidate score: 0.9200 (delta = +0.4500) [00:56, 01:12].
      * Wall-clock execution time for Iteration 1: ~15 seconds [00:52-01:07].
      * Budget parameter: `max_metric_calls: 2` (or up to 120/200 in config) [00:19, 00:54, 01:38].
* **Generated Artifacts Inspected** [01:06-01:20]:
  * `.codexopt/runs/<timestamp>/optimize.json`: Stores candidate diffs, baseline score, candidate score, delta, and reflection trace.
  * `.codexopt/runs/<timestamp>/scan.json`: Structured AST/heuristic scan detecting `contradictions`, `duplicate_nonempty_line_count`, `word_count`, `token_estimate`, and metadata flags (`has_constraints`, `has_output_contract`, `has_trigger_phrase`).
  * `.codexopt/runs/state.json`: Tracking pointer `latest_optimize_agents_run`.

---

### 3. What the Demonstrated Approach is GOOD at
* **Deterministic Linting & Deduplication** (Demo) [00:23-00:38]: Quickly catches duplicate rules, missing YAML frontmatter, and conflicting prompt instructions before invoking expensive LLM calls.
* **Instruction Structuring & Role Specialization** (Demo) [00:58-01:03, 01:25-01:27]: GEPA rewrites messy bullet points in `AGENTS.md` into highly structured sections (`Core Principles`, `Workflow: Analyze & Plan -> Write Tests -> Implement -> Verify`, `Code Style`, and standard unified diff `Output Format`).
* **Safety & Auditability via Dry-Run / State Tracking** (Demo) [00:30-00:40, 01:06-01:20]: Decouples optimization from application, staging runs in `.codexopt/runs/` with rollbacks and `--dry-run` checks.

---

### 4. What it is BAD at or Where it Breaks
* **Evaluation Bottleneck / Overfitting on Tiny Eval Sets** (Demo/Benchmark) [00:54, 01:34]: Evaluated against 1/1 example (`tasks.md` / `issues.md`), meaning high scores (0.47 -> 0.92) can reflect narrow evaluation fitting rather than broad generalization.
* **Direct Iteration Control Limitations** (Tooling Constraint) [01:38]: The CLI exposes budget tuning via `--max-metric-calls` rather than direct generation iterations, falling back to heuristic execution if the reflection model is unavailable.
* **Static Prompt Evaluation vs. Dynamic Runtime Tool Loops** (Benchmark) [01:34]: As noted in the documentation, current evidence-aware instruction optimization scores criteria against issue feedback rather than full interactive multi-turn agent execution runs.

---

### 5. Mechanism of the Alternative (GEPA / CodexOpt)
* **Rule-Based Pre-Scan & Static Scoring**: Scans markdown assets for structure (`scan.json` tracking frontmatter, token length, duplicate lines, contradictory directives) [01:15].
* **Reflection-Driven Mutation Loop (GEPA Engine)**: Passes baseline scores, error evidence (`tasks.md`, `issues.md`), and current prompt text to a reflection LLM (`gemini-2.5-pro`) to propose structural prompt mutations [00:19, 00:52, 01:00].
* **Metric Budget Search & Gated Apply**: Retains Pareto-improving candidates above a minimum delta threshold (`min_apply_delta: 0.01`), archiving diffs to JSON before applying to production `AGENTS.md` / `SKILL.md` files [00:20, 01:12, 01:30].

---

### 6. Application to Non-Verifiable Tasks and Non-Coding SOPs
* **Applicability via Evidence / Criteria Shaping** [00:18, 01:34]: The engine accepts generic feedback and task files (`tasks.md`, `issues.md`) to define qualitative rubric constraints.
* **Structural Hygiene for SOPs** [00:25, 01:15]: The AST scanner inspects trigger phrases, body length, output contracts, and contradictions, which directly transfers to operational playbooks, research guidelines, and copy styleguides.

---

### 7. Quality Signal
* **High credibility for CLI/GEPA execution**: The speaker directly shares their screen executing raw shell commands on a real local Git repository (`codexopt-demo`), inspecting intermediate JSON runtime artifacts, score logs, and markdown output diffs.
### Comments (first-hand, corrections, disagreements)
none substantive (comments array empty)
