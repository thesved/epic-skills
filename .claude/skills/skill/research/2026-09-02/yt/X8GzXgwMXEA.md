## SkillOpt: Optimizer for LLM Agent Skills, AI Research Roundup
URL: https://www.youtube.com/watch?v=X8GzXgwMXEA  Date: 20260525  Views: 874  Duration: 4:09
Class: REGURGITATION
### Gemini analysis
**1. Classification:** **REGURGITATION**
The video is an automated/AI-avatar paper summary that directly reads through the figures, tables, and abstract of the May 2026 Microsoft SkillOpt paper without running the code, providing external benchmarks, or offering novel analysis.

---

**2. Everything NOT in the paper/README:**
*Pure REGURGITATION.* Nothing in this video is new or absent from the paper/README:
* 00:00-04:09: All figures (Fig 1, Fig 2), tables (Table 1, Table 3, Table 4), and metrics shown are direct unedited screenshots from arXiv 2605.23904.
* No independent terminal execution, wall-clock time, dollar cost breakdown, real-world errors, or unique benchmarks are presented.

---

**3. What SkillOpt is GOOD at (per video):**
* **Outperforming baselines across evaluations** [00:30, 01:48]: Won or tied in all 52 benchmark evaluation setups, boosting GPT-5.5 performance by +25 points on average (*Benchmark*).
* **Spreadsheet reasoning & agentic execution** [02:11, 02:20]: Lifted baseline SpreadsheetBench score on GPT-5.5 from 42% to 81% in direct chat and topped agentic coding loops (*Benchmark*).
* **Transferability across models, harnesses, and tasks** [03:10-03:47]:
  * *Cross-model*: Skills optimized on GPT-5.4 successfully transfer to GPT-5.4-mini/nano [03:26] (*Benchmark*).
  * *Cross-harness*: Transferring a spreadsheet skill from Codex CLI to Claude Code achieved 82% performance [03:33] (*Benchmark*).
  * *Cross-benchmark*: Successfully transferred from OlympiadBench to Omni-MATH [03:42] (*Benchmark*).

---

**4. What SkillOpt is BAD at / Where it breaks (per video):**
* **Removing optimization constraints degrades performance** [02:36-03:09]:
  * Without a textual learning-rate budget (unbounded text edits), SpreadsheetBench accuracy drops from 77.5% to 75.7% [02:44] (*Benchmark ablation*).
  * Without the rejected-edit buffer, error repetition degrades results across SearchQA, SpreadsheetBench, and LiveMath [02:51] (*Benchmark ablation*).
  * Without epoch-wise slow meta-updates, SpreadsheetBench plunges from 77.5% to 55.0% [03:00] (*Benchmark ablation*).

---

**5. For ADJACENT videos:**
*N/A (Video focuses strictly on SkillOpt).*

---

**6. Non-verifiable tasks & non-coding workflows:**
* Not discussed in the video. The video only mentions the benchmarks from the paper (SearchQA, DocVQA, LiveMathematicianBench, SpreadsheetBench, LiveMath, OlympiadBench, Omni-MATH, ALFWorld).

---

**7. Quality Signal / Speaker Credibility:**
*Low credibility / AI avatar summary*: The speaker is an AI-generated narrator ("Alex") reading paper slides; no live terminal shown, no original code run, and no hands-on validation performed.
### Comments (first-hand, corrections, disagreements)
none substantive (single comment is generic praise: @SeventhHorror complimenting the channel's production, no first-hand data)
