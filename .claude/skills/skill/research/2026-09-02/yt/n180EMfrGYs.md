## SkillOpt: How Microsoft Rewrites skills.md Files To Boost LLM Agents 25%, AwesomeFOSS
URL: https://www.youtube.com/watch?v=n180EMfrGYs  Date: 20260602  Views: 769  Duration: 9:17
Class: REGURGITATION
### Gemini analysis
### 1. Classification
**REGURGITATION** - The video is an AI-narrated summary that recites the GitHub README, repository structure, and published paper metrics verbatim without performing live hands-on runs, independent evals, or novel analysis.

---

### 2. Information Not in Paper / README
*The video is pure REGURGITATION; there are no independent experimental results, token costs, or reproduction runs.*
* **08:53**: Briefly mentions pairing SkillOpt outputs with NVIDIA SkillSpectre (a skill security/risk scanner) as an external workflow suggestion.

---

### 3. Claims About What SkillOpt is GOOD At
* **Improving agent task performance across benchmarks** (01:03, 05:30, 07:06): Achieves double-digit accuracy gains across 52 evaluated cells (+23.5 on GPT-5.5 direct chat, +24.8 in Codex CLI, +19.1 in Claude Code, +57.5 on SpreadsheetBench). *(Evidence: Benchmark / Paper claims)*
* **Cross-model and cross-harness transferability** (04:34, 07:35): Markdown skills optimized on smaller models or direct chat reportedly transfer to larger models or agentic CLI harnesses (Codex CLI, Claude Code) without retraining. *(Evidence: Benchmark / Paper claims)*
* **Non-destructive optimization** (00:46, 01:34, 04:28): Constrains modifications to bounded `add`, `delete`, and `replace` edits to prevent prompt degradation or context bloat (resulting in compact 300-2,000 token markdown skills). *(Evidence: Benchmark / Paper claims)*
* **Provider & harness flexibility** (02:57, 03:54): Out-of-the-box support for Azure OpenAI, Anthropic Claude, local Qwen via vLLM, and agent CLI wrappers (Claude Code CLI, Codex CLI). *(Evidence: Repository feature listing)*

---

### 4. Claims About What SkillOpt is BAD At / Where It Breaks
* **Ablation failure / instability without gating** (07:50-08:04): Disabling bounded edits, the rejection buffer, or held-out validation gating causes the optimizer to stall or destructively rewrite the entire skill file. *(Evidence: Benchmark / Ablation claim from paper)*
* *Note:* The video presents no real-world breakage tests, cost ceilings, or failure modes outside the paper's internal ablation study.

---

### 5. Adjacent Methods
*N/A (This video focuses exclusively on SkillOpt, not an adjacent framework).*

---

### 6. Application to Non-Verifiable Tasks & Non-Coding Workflows
* The video mentions generalized document and reasoning benchmarks (SearchQA, ALFWorld, DocVQA, SpreadsheetBench) at **03:12** and **03:45**, but does **not** provide guidance or evaluation mechanisms for open-ended non-verifiable tasks (such as copywriting, SOP generation, or qualitative research).

---

### 7. Quality Signal & Credibility
* **Low / Regurgitation Channel**: The creator uses automated text-to-speech over README screen recordings and a scripted terminal graphic (05:55) rather than executing genuine terminal benchmarks or showing live rollout logs.
### Comments (first-hand, corrections, disagreements)
none substantive (no comments on video)
