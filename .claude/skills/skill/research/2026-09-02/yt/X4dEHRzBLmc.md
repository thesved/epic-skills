## Judge the Judge: Building LLM Evaluators That Actually Work with GEPA ,  Mahmoud Mabrouk, Agenta AI, AI Engineer
URL: https://www.youtube.com/watch?v=X4dEHRzBLmc  Date: 20260410  Views: 7913  Duration: 40:51
Class: ADJACENT
### Gemini analysis
### 1. Classification
**ADJACENT** ,  The video is a hands-on technical workshop demonstrating prompt optimization using **GEPA** (*Generalized Evolutionary Prompt Architect* via the `optimize_anything` library) on Tau-bench customer service agent traces rather than Microsoft SkillOpt.

---

### 2. Hands-On Results, Numbers, Errors, and Comparisons (Not in Paper/README)
* **Dataset & Setup [14:00, 23:50]:** Evaluates an airline customer support agent from Tau-bench against complex airline policy adherence (14 available tools, cancellation/modification rules). Uses 592 total traces: 480 training (299 compliant / 181 non-compliant), 112 validation (69 compliant / 43 non-compliant).
* **Baseline Naive Judge Results [28:11, 28:30]:**
  * Overall Accuracy: **61.6%**
  * Compliant Recall: **98.6%** (F1: 76%)
  * Non-Compliant Recall: **2.3%** (F1: 4%)
  * Failure mode: naive judge suffered severe 98% "presume compliant" rubber-stamping bias, lacked specific policy rule definitions.
* **GEPA Optimized Judge Results [32:52, 33:19]:**
  * Validation Accuracy: **62.5% to 76.8% (+14.3 points)** (or 74.5% in initial val pass [32:52]).
  * Training Accuracy: **62.3% to 71.5% (+9.2 points)**.
  * Pareto Frontier Accuracy across training pool: **100%** (a candidate existed for every failure mode, though merging into one prompt was harder).
  * Non-Compliant Detection: Precision improved from 0% to **68%**, Recall from 2.3% to **64%** (F1: 66%); bias reduced from 98% to 64% compliant [33:01].
* **Costs & Compute Budget [22:42, 38:28, 40:01]:**
  * Optimization runs took **30-60 minutes to several hours** (200-300 iterations per experiment).
  * Cost **$200-$300** in API tokens per experiment due to long input context across multi-turn conversation traces.
* **Model Combinations & Failures [34:49, 35:28]:**
  * Running **GPT-4o for both Reflector and Judge completely failed** to learn complex policy logic.
  * Best combination: **Grok (Judge) + Gemini (Reflection LLM)**, with **GPT-4o-mini** also performing well at lower cost.

---

### 3. Claims About What the Approach is GOOD At
* **Extracting Implicit Rules from Failure Traces [29:09, 32:28]:** Highly effective at converting unstructured human error explanations into concrete, bulleted policy rubrics (evidence: hands-on benchmark/demo).
* **Eliminating Bias in LLM Evaluators [32:58]:** Drastically reduces naive positive/negative bias by codifying explicit exception criteria into prompts (evidence: hands-on benchmark).

---

### 4. Claims About BAD Performance / Failure Modes
* **High Token Cost on Long Traces [38:28]:** Trajectory evaluations pass thousands of tokens per sample, rapidly burning through hundreds of dollars (evidence: hands-on trial).
* **Struggles with Candidate Merging [34:43, 36:59]:** While GEPA achieved 100% coverage on the Pareto frontier across disparate prompt candidates, synthesizing them into a single global rubric proved challenging (evidence: hands-on experiment).
* **Counter-Intuitive Seed Failure [37:40]:** Giving the LLM the full policy text upfront trapped it in a local minimum; starting with a minimal seed prompt and letting it learn incrementally from annotated traces yielded better results (evidence: opinion with experimental backing).
* **Failure with Weak Reflection LLMs [34:55]:** Small or insufficiently reasoning models fail to infer why a policy violation occurred from trace diffs (evidence: hands-on trial).

---

### 5. Alternative Mechanism (GEPA / `optimize_anything`) vs. SkillOpt
* **Mechanism:**
  1. *Reflective Mutation*: Takes failed evaluations with human reasoning annotations and uses a Reflection LLM to propose updated prompt rubrics [16:05, 29:10].
  2. *Mini-Batch & Pareto Filtering*: Evaluates candidates on mini-batches and maintains a Pareto frontier of non-dominated candidates per task/edge-case [17:30, 18:01].
  3. *System-Aware Merge*: Merges rule fragments from complementary Pareto candidates into unified prompts across generations [17:10, 20:09].
* **Evidence:** Live Jupyter notebook running `optimize_anything` on 592 Tau-bench airline compliance traces [22:26].
* **Comparison to SkillOpt Goal:** SkillOpt focuses on mutating modular skill code/markdown files (`SKILL.md`) in agent environments via trajectory feedback; GEPA optimizes prompt rubrics and SOPs via evolutionary Pareto search. GEPA is particularly well-suited for tuning meta-evaluators, system prompts, and SOP guidelines where multi-objective trade-offs exist.

---

### 6. Application to Non-Verifiable / Non-Coding Tasks
* **Natural Language Policy Adherence [08:11, 10:28]:** The entire case study is a non-coding SOP compliance task (airline refund/cancellation rules, customer verification, transfer etiquette).
* **Binary vs. Scalar Scoring [11:06]:** For subjective or policy-based tasks, 1-5 scalar ratings fail to correlate across annotators. Converting evaluation into binary adherence checks supported by required reasoning snippets makes optimization feasible [11:15, 12:12].

---

### 7. Quality Signal
High credibility: Mahmoud Mabrouk is co-founder/CEO of Agenta (open-source LLMOps); demonstrated working code in a live SSH/Jupyter environment, detailed failed experiments, shared quantitative metrics and token cost realities.
### Comments (first-hand, corrections, disagreements)
- none substantive. Three comments total: two praise ("One of the best lectures on LLM as a Judge and GEPA" - @raj-nq8ke; "that opening joke would have crushed irl" - @alexqmcd) and one third-party paraphrase/summary of the talk (@frostcs) that restates the video's own content rather than adding first-hand experience, corrections, or disagreement.
