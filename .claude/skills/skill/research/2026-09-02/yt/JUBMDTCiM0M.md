## SkillOpt - Controllable Text-Space Optimization for Agent Skills, zisu Huang
URL: https://www.youtube.com/watch?v=JUBMDTCiM0M  Date: 20260524  Views: 18877  Duration: 1:37
Class: REGURGITATION
### Gemini analysis
### 1. Classification
**REGURGITATION**  
This video is an animated promotional slide deck summarizing the core concepts, training loop, and benchmark figures directly from the SkillOpt paper with no external hands-on testing or independent commentary.

---

### 2. Information Not in Paper / README
*The video is pure REGURGITATION of the SkillOpt paper figures and concepts.*
- **[00:30-00:59]** Visualizes the deep learning analogy (parameters → `skill.md`, gradient → edit direction, validation → held-out gate) and the dual-rate (fast/slow field) optimization loop.
- **[01:00-01:23]** Summarizes benchmark gains across 6 tasks (SearchQA, SpreadsheetBench, OfficeQA, DocVQA, LiveMath, ALFWorld), stating SkillOpt won or matched 52/52 evaluations against baselines like TextGrad and GEPA.
- **[01:24-01:32]** Displays transferability metrics across models (+5.6 pts to mini/nano), agent harnesses (+29.4 pts between Claude Code and Codex), and fresh benchmarks (+2.3 pts).

---

### 3. Claims About What SkillOpt is GOOD at
- **Cross-Harness Transferability [01:26]**: A single optimized `best_skill.md` transfers across agent frameworks (e.g., jumps between Claude Code and Codex/GPT-5.5 with an average +29.4 pt gain). *(Evidence: Benchmark)*
- **Cross-Model Downscaling [01:25]**: Skills optimized on frontier models (e.g., GPT-5.4) improve performance when executed by smaller models (GPT-5.4-mini, GPT-5.4-nano) by an average of +5.6 pts. *(Evidence: Benchmark)*
- **Outperforming Prior Text-Space Optimizers [01:10-01:23]**: Outperforms TextGrad, GEPA, Trace2Skill, zero-shot LLM skills, and human-written skills across structured tool/multimodal/reasoning benchmarks (SpreadsheetBench +51.7%, OfficeQA +68.1%, DocVQA +80.1%, LiveMath +42.9%, ALFWorld +86.0%). *(Evidence: Benchmark)*
- **Controlled, Bounded Iteration [00:18-00:40, 01:01-01:09]**: Prevents destabilizing semantic jumps via bounded edit budgets, minibatch reflections, and held-out rejection gates. *(Evidence: Benchmark / Conceptual diagram)*

---

### 4. Claims About What SkillOpt is BAD at or Where It Breaks
- **Former / Baseline Text-Space Optimizers [00:30-00:35]**: Highlights that unconstrained text optimization methods suffer from brittle initialization, large uncontrolled semantic jumps, and getting stuck in suboptimal local minima (SkillOpt positions itself as fixing these via bounding and gating). *(Evidence: Opinion / Qualitative claim)*
- *Note:* The video does not disclose failure cases, compute costs, or operational limits of SkillOpt itself.

---

### 5. Alternative / Adjacent Methods Mentioned
- **Baselines Compared [01:10-01:23]**: TextGrad, GEPA, Trace2Skill, LLM Skill, and Human Skill.
- **Comparison [01:11-01:23]**: SkillOpt claims superior stability and accuracy, matching or beating all compared methods across 52 evaluated cells (mean over 7 target models).

---

### 6. Non-Verifiable Tasks & Non-Coding Workflows
- **Non-Coding Tasks [00:06-00:15, 01:14-01:22]**: Demonstrates application to general knowledge search (`SearchQA`), document visual question answering (`DocVQA`), office document management (`OfficeQA`), interactive household tasks (`ALFWorld`), and math (`LiveMath`).
- **Optimization Requirement [00:46-00:54, 01:01-01:09]**: Relies on a quantitative validation check (`held-out test score` gate) to accept/reject edits, meaning subjective or non-verifiable tasks require a scoring proxy or LLM judge to function within this loop.

---

### 7. Quality Signal
**High production official summary; zero independent validation.** The video is an official Microsoft Research animated teaser illustrating paper diagrams; it does not execute live CLI commands, show raw terminal logs, or provide external critiques.
### Comments (first-hand, corrections, disagreements)
- @ElijahLynn (0 likes), first-hand practice comparison: "Can't wait to give this a try, skill improvement so far for me has been dispatching fable sub as adverserail reviewers, but no measurable outcome to test gate against. Love that you and your team spent the time to make skill improvement a measurable thing!\n\nTrain the procedure, not the model! Beauti" (comment truncated in source data)
- @bravelion9702 (0 likes), practical question: "How about a frontend wrapper to upgrade skills? is that possible to do?"
- @RafaelGuimarães-t2f (0 likes), practical question: "Where can we find ready skills ?😅"
- none of the remaining comments (duffer004, eidermauricio, airxperimentboom, jonouchi1989, bura_3) are substantive: praise or one-word reactions only
