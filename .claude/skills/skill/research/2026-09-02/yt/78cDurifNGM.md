## A trained text file just beat Claude Code (SkillOpt Results) - Part 2, VECTOR & LOOP
URL: https://www.youtube.com/watch?v=78cDurifNGM  Date: 20260807  Views: 3  Duration: 12:07
Class: REGURGITATION
### Gemini analysis
### 1. Classification
**REGURGITATION** ,  The video is an audiovisual breakdown explaining the findings, benchmark figures, ablations, and theoretical limitations published directly in the SkillOpt paper without running new live code or independent benchmarks.

---

### 2. Delta from Paper & README
This video is pure **REGURGITATION** of the paper's data and concepts.
* Visually animates the paper's empirical results (52/52 benchmark cells, ablation tables, token costs per point of gain).
* Highlights the cross-harness counter-intuitive result (Codex-trained skill outperforming native Claude Code-trained skill: 81.8 vs 80.4).
* Summarizes the 4 paper-stated boundary conditions into clear visual cards.

---

### 3. Claims: What SkillOpt is GOOD At
* **Universal Empirical Superiority Across Harnesses & Models (Benchmark)** [00:34-02:42]: Won or tied 52 out of 52 evaluated cells across 7 target models, 6 benchmarks, and 3 execution harnesses (Direct Chat, Codex CLI, Claude Code CLI), beating a best-of-baseline oracle by +5.4 points.
* **Massive Uplift for Small/Nano Models (Benchmark)** [02:43-03:27]: Supplies procedural knowledge that small models lack; GPT-5.4-nano gained an average of +26.7 points, and Qwen-3.5-4B jumped from 9.3 to 23.9 on SpreadsheetBench and +50.7 on ALFWorld.
* **Cross-Model & Cross-Harness Skill Transferability (Benchmark)** [03:28-05:35]: Skills tuned on one model or harness transfer cleanly; a Codex-trained SpreadsheetBench skill dropped into Claude Code scored 81.8, beating Claude Code's native in-domain optimization (80.4).
* **Synthesizing Procedural State Machines (Policy Synthesis) (Benchmark)** [05:36-06:16]: Converts unstructured prompting into formal execution policies (e.g., adding object identity tracking, search memory, progress locks, and loop breakers in ALFWorld).
* **Zero Inference Overhead (Benchmark/Design)** [09:32-10:08, 10:48-11:05]: Heavy optimizer compute runs strictly offline; deployed artifacts are compact text files (379 to 1,995 tokens) adding zero extra LLM roundtrips at runtime.

---

### 4. Claims: What SkillOpt is BAD At / Where It Breaks
* **Non-Verifiable / Subjective Tasks (Design Constraint)** [10:09-10:26]: Complete failure mode if an automated verifier/exact-match score is absent; "The Gate" requires held-out numerical evaluation to reject bad edits, without a verifier, the optimization loop has no spine.
* **Single Skill Scope (Architecture Limitation)** [10:35-10:41]: Optimizes one monolithic task file at a time; cannot autonomously organize, route, or maintain large heterogeneous skill libraries with disjoint domains.
* **Upfront Training Token Consumption (Cost)** [10:27-10:34, 10:48-11:05]: Training requires significant rollout compute (0.6M tokens per point gained on SpreadsheetBench; 1.1M tokens/pt on OfficeQA), making it cost-ineffective unless the skill is executed repeatedly in production.
* **Catastrophic Failure Without Cross-Epoch Memory (Ablation Failure)** [07:33-08:18, 08:30-08:39]: Disabling the optimizer meta-skill and slow update (momentum) caused SpreadsheetBench performance to collapse by 22.5 points (77.5 to 55.0); dropping the rejected-edit buffer alone loses 4.6 points.

---

### 5. Adjacent Methods
* **N/A** (Video is classified as REGURGITATION; does not evaluate GEPA, Meta-Harness, Hermes, or MUSE).

---

### 6. Application to Non-Verifiable Tasks & Non-Coding Workflows
* **Explicit Prohibition for Non-Verifiable Tasks** [10:09-10:26]: The speaker explicitly warns that for open-ended copy, general research quality, or tasks lacking objective verifiers, SkillOpt cannot function as designed because "The Gate" will have no ground truth to compare against.
* **Non-Coding Structured Workflows** [01:30-01:40, 05:36-06:16]: Demonstrated to work effectively on structured office/operational tasks with definitive answers (SpreadsheetBench, OfficeQA, SearchQA, and embodied state tracking like ALFWorld), turning workflow SOPs into strict rule-based policies.

---

### 7. Quality Signal
* **Low-to-Medium (Paper Synthesizer)**: The presenter created high-production motion graphics strictly summarizing the paper's ablation tables, transfer matrices, and benchmark statistics, but did not execute live terminal commands or demonstrate an independent implementation.
### Comments (first-hand, corrections, disagreements)
none (no comments present in prefetched data)
