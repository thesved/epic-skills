## (Podcast) SkillOpt The Deep Learning Revolution for AI Agent Skills, Eddy Says Hi #EddySaysHi
URL: https://www.youtube.com/watch?v=IMLsGCTlfJo  Date: 20260613  Views: 52  Duration: 20:00
Class: REGURGITATION
### Gemini analysis
### 1. Classification
**REGURGITATION**  
This is an automated Google NotebookLM podcast discussion that summarizes the May 2026 Microsoft research paper on SkillOpt using generated audio over static summary slides, offering no independent implementation, original benchmarks, or novel analysis.

---

### 2. Information Not in the Paper or README
*This video is pure REGURGITATION of the published SkillOpt paper.*
* The hosts use an extended golf-coaching analogy (`14:20`-`14:55`) to explain how SkillOpt applies restrained, surgical procedural adjustments rather than overwhelming an agent with rules.
* The dialogue uses an intern / office filing manual metaphor (`04:05`-`04:35`) to conceptualize how text-space instruction optimization mirrors neural network weight updates.

---

### 3. Claims About What SkillOpt is GOOD At
* **Universal Benchmark Superiority Across Configurations:** Tied or beat all baselines across all 52 evaluated cells combining models, benchmarks, and harnesses (`10:52`-`11:35`, *Benchmark*).
* **Significant Accuracy Lift on Complex Frontier Reasoning:** Produced an average accuracy lift of +23.5 percentage points across 6 benchmarks on GPT-5.5 direct chat (`11:22`-`11:35`, *Benchmark*), including a 29.3-point jump on LiveMathBench via a single procedural rule edit (`12:17`-`13:17`, *Benchmark*).
* **Spreadsheet Manipulation and Forensic Accounting:** Increased SpreadsheetBench performance from 41.8% to 80.7% by learning to inspect workbook structure and write static evaluated values rather than relying on Excel recalculation (`13:17`-`13:45`, *Benchmark*).
* **Embodied and Interactive Agent Navigation:** Successfully generated exploration policies, loop-breakers, and destination memory on the ALFWorld household navigation benchmark (`13:48`-`14:20`, *Benchmark*).
* **Cross-Harness, Cross-Benchmark, and Cross-Model Transferability:** Skills optimized on one harness/model transferred directly to others, such as transferring Codex-optimized skills to Claude Code (+59.7 pt gain on SpreadsheetBench) and transferring GPT-5.4-optimized skills to smaller models like GPT-5.4-nano and Qwen 3.5-4B (`13:17`-`13:35`, `15:39`-`16:50`, *Benchmark*).
* **Zero Additional Inference Cost:** Compresses optimization into a compact, human-auditable markdown file under 2,000 tokens (<1,500 words) without runtime latency or extra model calls at deployment (`11:45`-`12:05`, `15:28`-`16:09`, *Benchmark / Demo*).

---

### 4. Claims About What SkillOpt is BAD At / Where It Breaks
* **Unbounded Prompt Rewriting ("Prompt Collapse" / "Semantic Chaos"):** Without strict edit budgets, unconstrained reflection models make massive semantic jumps, overwrite working rules, and introduce regressions (`02:44`-`03:38`, `06:30`-`06:50`, *Benchmark / Opinion*).
* **Silent Rule Drift and Context Bloat:** Allowing tie scores on validation checks causes skill files to accumulate unhelpful edge-case bloat over successive epochs, degrading model performance over time (`08:24`-`09:02`, *Benchmark / Opinion*).

---

### 5. Alternative Mechanisms (ADJACENT)
*N/A (This video covers SkillOpt directly).*

---

### 6. Application to Non-Verifiable Tasks and Non-Coding Workflows
* **General Procedural SOPs:** The speakers note that SkillOpt treats plain English markdown documents as learnable state for domain-specific company filing rules and workplace procedures (`04:05`-`04:35`, `17:21`-`17:59`).
* **Non-Coding Transfer:** The principles were shown on non-coding benchmarks including symbolic math theorem ranking (LiveMathBench, `12:44`-`13:17`), tabular data analysis (SpreadsheetBench, `13:17`-`13:45`), and simulated household tasks (ALFWorld, `13:48`-`14:20`).

---

### 7. Quality Signal
**Low credibility:** Synthetic AI voices reading an AI-generated summary of the paper; no real terminal sessions, original code execution, or independent testing were performed.
### Comments (first-hand, corrections, disagreements)
none substantive
