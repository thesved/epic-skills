## Self Evolving AI Skills w/ GPT-5.5 (SkillOpt), Discover AI
URL: https://www.youtube.com/watch?v=aVW-KG4sDdo  Date: 20260526  Views: 3985  Duration: 26:23
Class: REGURGITATION
### Gemini analysis
### 1. Classification
**REGURGITATION** - The video is a slide-by-slide paper walk-through of Microsoft's *SkillOpt* (arXiv:2605.23904) and *SkillLens* (arXiv:2605.23899) papers, reading directly from the paper's figures and benchmark tables without executing code or presenting independent experimental data.

---

### 2. Information NOT in the Paper / README
*The video is pure REGURGITATION of the published paper materials and figures.*
- **Personal Reflection (20:01-20:54):** Speaker questions whether SkillOpt is merely optimizing harness syntax formatting rather than acquiring deep structural reasoning, concluding the teacher model injects procedural domain knowledge into Markdown instructions.
- **Teaser / Upsell (25:20-26:14):** Mentions a separate members-only video covering broader end-to-end "AI Harness Optimization" (optimizing prompts, memory, tools, and workflows together beyond single skill files).

---

### 3. Claims About What SkillOpt is GOOD At
- **Outperforming existing text-space prompt/skill optimizers across standard agent benchmarks (12:44-12:54, 16:47-17:10):** Clears baselines including Human Skills, LLM direct generation, Trace2Skill, TextGrad, and GEPA on benchmarks like SearchQA (87.3%), SpreadsheetBench (80.7%), OfficeQA (72.1%), DocVQA (91.2%), LiveMath (66.9%), and ALFWorld (95.5%). *(Evidence: Benchmark from paper Table)*
- **Cross-model and cross-harness skill transfer (19:17-19:58):** Exported `best_skill.md` artifacts transfer across different base LLMs (e.g., +15.2 on LiveMath transferring GPT-5.4 skill to GPT-5.4-nano) and across agent harnesses (e.g., +31.8 transferring Codex-trained SpreadsheetBench skill to Claude Code). *(Evidence: Benchmark from paper Table)*
- **High efficiency / low edit count (17:33-19:14):** Massive performance gains are achieved with minimal text updates (e.g., +39.0 points on OfficeQA from just 1 accepted atomic edit; LiveMath improved with 1 edit; DocVQA with 3 edits). *(Evidence: Benchmark / Table 6 from paper)*

---

### 4. Claims About What SkillOpt is BAD At / Where It Breaks
- **Isolated Optimizer / No Direct Environment Execution (06:14-06:30, 22:38-23:19):** The optimizer LLM only inspects serialized text traces/error logs offline and never directly executes in or interacts with the sandbox environment or validation split. *(Evidence: Opinion / Architectural limitation from paper design)*
- **Diminishing gains in mature harnesses (15:57-16:29):** Net improvements are much smaller when tested inside specialized harnesses like OpenAI Codex CLI (+5.5%) or Anthropic Claude Code (+4.0%) compared to direct zero-harness chat settings (+9.6% on SearchQA, +31.8% on SpreadsheetBench). *(Evidence: Benchmark from paper Table)*
- **Local batch drift risk (10:20-10:50):** Fast minibatch-only reflection steps can miss systemic regression or drift, requiring a separate epoch-wise slow/meta-reflection loop across adjacent epochs. *(Evidence: Benchmark / Methodology explanation from paper)*

---

### 5. Adjacent Methods Mentioned
- **GEPA / VISTA (17:15-17:30):** Mentioned as a baseline genetic prompt-evolution approach from UC Berkeley/MIT, which SkillOpt beats across all 6 evaluated benchmark tasks.
- **SkillLens / From Raw Experience to Skill Consumption (arXiv:2605.23899) (23:45-25:19):** Companion systematic study analyzing the 3-stage lifecycle of model-generated skills (Experience Generation -> Skill Extraction -> Skill Consumption) and what causes skills to succeed or fail.

---

### 6. Non-Verifiable Tasks / Non-Coding Workflows
- **SearchQA & OfficeQA benchmarks (21:18-21:58):** Highlights rules learned for non-coding/QA tasks, such as inferring canonical answer entity types from question wording (SearchQA) or treating Oracle-parsed documents as primary evidence while locking table coordinates (OfficeQA).
- The video does not present custom empirical trials on subjective copy, open-ended research, or non-technical SOP optimization outside the paper's 6 academic benchmarks.

---

### 7. Quality Signal & Credibility
**Low-Medium:** The presenter did not run code, demo a terminal, or share independent benchmark logs; the video is entirely a narrated walkthrough of figures and tables from arXiv preprints 2605.23904 and 2605.23899.
### Comments (first-hand, corrections, disagreements)
- @bjmay67, opinion with reasoning on skill self-optimization: "Seems the growing consensus is that LLMs "intrinsically know" how to prompt/instruct themselves better than we humans do. This makes sense, as their vernacular and associative understanding will be different than the average person's. Yet, even if they could devise their own optimal prompts/instruc" (cut off in source).
- @JoshuaC0rbit, first-hand application: "It's funny because I was just reading this paper and Incorporated some of the things it mentioned into it and then fixed a bunch of others. And then your video comes up in my feed. Great work as always."
