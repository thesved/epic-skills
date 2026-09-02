## An AI Rewrote Its Own Instructions Thousands of Times ,  Only 1 to 4 Edits Survived, Neural Stack - Software | AI | Open Source
URL: https://www.youtube.com/watch?v=eM2qQUIm_lk  Date: 20260715  Views: 101  Duration: 8:49
Class: REGURGITATION
### Gemini analysis
### 1. Classification
**REGURGITATION** ,  The video is an animated overview summarizing the findings, architecture, and release notes of the Microsoft Research SkillOpt paper along with editorial commentary, without running live benchmarks or demonstrating hands-on execution.

---

### 2. Information Not in the Paper/README
*The video is primarily an editorial summary of the paper and repository; novel content is limited to high-level conceptual framing:*
* **Additive vs. Subtractive Bias Framing (05:00-05:50):** Argues that human prompt/skill authors suffer from constant rule accumulation, whereas SkillOpt's power is that rejection and pruning act as the primary engine of quality.
* **Heuristic for Prompt Crafting (07:34-08:21):** Suggests human practitioners treat "deletion as an edit" and force every line in `CLAUDE.md` / `SKILL.md` to prove its worth against held-out test cases.
* **Task Logic vs. Model Hacks (06:30-06:49):** Postulates that text edits surviving cross-model transfer represent underlying domain logic rather than model-specific trigger words.

---

### 3. What SkillOpt is GOOD at
* **Benchmark Performance Gains:** Pushed a 6-benchmark direct chat average from 58.8% to 82.3% (+23.5 points) using GPT-4 / GPT-5-class models (00:44-01:00; *Evidence: Benchmark cited from paper*).
* **Tool-Use / Data Tasks:** Achieved a +38.9 point gain on SpreadsheetBench (41.8% to 80.7%) (04:07-04:15; *Evidence: Benchmark cited from paper*).
* **Broad Superiority Over Prior Methods:** Achieved best or tied-best performance in all 52 evaluated configurations across 6 benchmarks, 7 target models, and 3 harnesses, outperforming TextGrad and EvoSkill (03:48-04:27; *Evidence: Benchmark cited from paper*).
* **Portability / Transferability:** Output skills (`best_skill.md`, median ~920 tokens) generalize across different model sizes and execution harnesses without retraining weights (06:03-06:24; *Evidence: Benchmark / Opinion*).

---

### 4. What SkillOpt is BAD at / Failure Modes
* **Extremely High Proposal Rejection Rate:** The optimizer generates thousands of candidate edits, but the strict gatekeeper throws away the overwhelming majority because they fail held-out validation; only 1-4 edits survive into final skill files (00:23-00:29, 04:40-04:52; *Evidence: Paper statistics / Analysis*).

---

### 5. Mechanism of Alternative (ADJACENT)
*N/A (Video classified as REGURGITATION).*

---

### 6. Non-Verifiable Tasks & Non-Coding Workflows
* References SpreadsheetBench (spreadsheet/data workflows) (04:07).
* Mentions applying the philosophy to general instruction files like `CLAUDE.md`, system prompts, and custom skill docs (01:13-01:18, 07:34-07:44), but does not discuss scoring methods for subjective/non-verifiable domains (e.g., copywriting or qualitative SOPs).

---

### 7. Quality Signal
* Content creator presents clear conceptual analysis and motion graphics covering paper metrics, but displays no live terminal runs, actual debugging, or independent empirical tests.
### Comments (first-hand, corrections, disagreements)
- @ShortStuff-q6j (2 likes): "Nice. thank you for the information" ,  praise, not substantive.
