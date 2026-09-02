## Microsoft Just Open-Sourced a Tool for AI Agents (SkillOpt), Codedigipt
URL: https://www.youtube.com/watch?v=BXhCk1ypmK4  Date: 20260712  Views: 1532  Duration: 12:56
Class: REGURGITATION
### Gemini analysis
### 1. Classification
**REGURGITATION** ,  The presenter does not run code or provide novel evaluation; he merely scrolls through Microsoft's official SkillOpt landing page and GitHub README while explaining the diagrammatic concepts using basic analogies.

---

### 2. Information NOT Already in the Paper / README
*The video is pure REGURGITATION.*
- **[03:40-04:43]** Uses a toy workplace analogy (giving an employee an instruction manual vs. expensive full retraining).
- **[07:11-08:55]** Uses a hypothetical 50-problem math test scenario to explain trajectory logging and failure reflection.
- No novel benchmark numbers, code executions, dollar costs, errors, or independent reproduction data are presented.

---

### 3. Claims About What SkillOpt is GOOD At
- **Improving agent performance without fine-tuning weights [00:50-01:40, 02:20-02:40]**: Improves frozen models across benchmarks (+23.5 points on GPT-5.5 direct chat, +24.8 inside Codex agentic loop, +19.1 in Claude Code) by optimizing a compact `best_skill.md` file *(Evidence: Benchmark table from paper/landing page)*.
- **Handling structured, verifiable benchmarks [00:25-00:48, 12:00-12:14]**: Effective across SpreadsheetBench, SearchQA, OfficeQA, DocVQA, LiveMath, and ALFWorld *(Evidence: Benchmark charts from landing page)*.
- **Controlled iterative optimization [05:30-06:35]**: Refining prompt instructions step-by-step (e.g., SpreadsheetBench skill evolution from basic library imports to explicit header inspection and range checks) *(Evidence: Project landing page case study animation)*.

---

### 4. Claims About What SkillOpt is BAD At / Where It Breaks
- **Latency / Response time overhead during evaluation [10:25-11:21]**: Adding verbose procedural rules (e.g., requiring web search or extra verification steps) increases wall-clock execution time, requiring the validation gate to balance accuracy gains against speed penalties *(Evidence: Speaker's conceptual interpretation of gating)*.
- *No practical software crash failure modes, cost breakdowns, or edge-case breakages are demonstrated.*

---

### 5. Adjacent Alternatives Comparison
*N/A - The video is strictly about SkillOpt and does not cover alternative frameworks (GEPA, Meta-Harness, Hermes, etc.).*

---

### 6. Application to Non-Verifiable / Non-Coding Tasks
- **[04:18-04:44]** Shows a generic 3-line non-coding instruction manual (*"1. Always verify names, 2. Double-check calculations, 3. If unsure, ask questions"*), but does not discuss how to construct objective validation gates for subjective or non-verifiable tasks.

---

### 7. Quality Signal & Speaker Credibility
- **Low credibility on deep implementation [00:00-12:55]**: The speaker did not run code, inspect raw config files, or show terminal output; he strictly narrated pre-rendered web graphics and read verbatim text from Microsoft's public project page.
### Comments (first-hand, corrections, disagreements)
- @nazzsankira: "Include how to start using it." (viewer requesting practical setup content the video didn't cover)
- @vv7.7: "Bro theory is good but if you could have show practical usage of SkillOpt it would have been better!!" (confirms video lacks hands-on demonstration, matches Gemini's REGURGITATION classification)
- Remaining comments (@rigveda_2025, @SMITPATEL-x3x, @kvs7720) are praise/spam, no substantive content
