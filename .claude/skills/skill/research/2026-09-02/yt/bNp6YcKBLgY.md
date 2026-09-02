## Hermes Agent Crash Course: Self-Evolving Skills, Memory, GEPA & Scaling to 10 Agents, Akshay Pachaar
URL: https://www.youtube.com/watch?v=bNp6YcKBLgY  Date: 20260528  Views: 6896  Duration: 48:10
Class: ADJACENT
### Gemini analysis
### 1. Classification & Rationale
**ADJACENT**
The video is an end-to-end masterclass and live implementation walkthrough of Nous Research's **Hermes Agent** architecture, demonstrating its 3-tier memory system, runtime self-evolving skills loop, automated skill library pruning (Curator), and offline **GEPA** (Genetic-Pareto Prompt Evolution) optimization instead of Microsoft SkillOpt.

---

### 2. Information Beyond the SkillOpt Paper / Hands-On Concrete Details
* **Cost & Compute Metrics for GEPA Optimization [24:06, 25:54]:** Runs fully on CPU using API calls (no GPUs required), costing **$2-$10 per optimization run**, outperforming RL/GRPO by evaluating natural language feedback over execution traces without modifying model weights.
* **Exact Context Window Token Budgets [11:27, 12:25, 14:40, 15:53]:**
  * Tier 1 Memory: Fixed snapshot loaded every turn (~900 tokens total), divided into `MEMORY.md` (capped at 2,200 characters) and `USER.md` (capped at 1,375 characters) [11:33].
  * Progressive Skill Disclosure: Level 0 catalog injects only YAML metadata (~100 tokens total for ~687 skills); Level 1 loads the full `SKILL.md` (~2k tokens); Level 2 dynamically fetches scripts/reference files only on demand [15:10-16:25].
  * Tier 2 Search: SQLite + FTS5 full-text keyword search across CLI/Telegram history costing ~150 tokens per search call; auto-consolidates at 80% capacity [12:30, 13:04].
* **Hard Guardrails & Limits [08:11, 08:26]:** Implements a **90-turn hard cap** per task shared with subagents to prevent runaway execution loops, retry cascades, and credit burning.
* **Commands Run & Configs Tested [26:14, 34:02, 35:26, 35:44, 45:20]:**
  * Installation: `curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash` [26:14]
  * Creating isolated agent profiles: `hermes profile create designer` and `designer setup` [35:15-35:44]
  * Managing & pinning skills: `hermes skills install merger-model`, `hermes curator pin <skill>` (prevents garbage collection) [22:33, 34:02], and adding external GitHub skill taps: `hermes skills tap add <user>/<repo>` [45:20].

---

### 3. Claims About SkillOpt (or GEPA / Hermes Equivalent) ,  Strengths
* **Zero Model Weight Modification [00:41, 24:33]:** Optimizes text-space prompts and agent playbooks directly, achieving higher sample efficiency than GRPO with significantly fewer rollouts (evidence: benchmark/paper, ICLR 2026 GEPA paper).
* **Automated Few-Shot Skill Distillation [17:15, 37:40-39:40]:** Converts multi-step trial-and-error executions into permanent, reusable `SKILL.md` files that short-circuit future runs (evidence: demo).
* **Multi-Skill Bundles [46:00-47:10]:** Groups interdependent skills (e.g., Code Review + TDD + PR workflow) under a single YAML entry point to execute complex SOPs deterministically (evidence: demo).

---

### 4. Claims About SkillOpt / Evolution Weaknesses & Failure Modes
* **Context Clutter & Near-Duplicate Skill Proliferation [19:20-19:55]:** As agents create skills autonomously over months, dozens of overlapping or near-duplicate skills bloat context and degrade LLM routing accuracy (evidence: opinion/empirical observation).
* **Stale Playbooks [20:45-21:15]:** Automated skills break as upstream tool APIs or project conventions change, necessitating continuous pruning cycles (evidence: opinion/empirical observation).
* **Mitigation Mechanism (The Curator) [20:00-22:45]:** Solves this via a two-stage garbage collector:
  1. Deterministic Rule: Flags skills unused for >30 days as stale, archives skills unused for >90 days (stored in a `.tar.gz` snapshot for 1-command rollback) [20:49, 23:01].
  2. LLM Judge Review: Tests passing skills, proposes patches, or consolidates near-duplicates into unified skills [21:15-22:15].

---

### 5. Alternative Mechanism: GEPA vs. SkillOpt
* **Mechanism [24:55-25:05, 45:54]:**
  1. Reads execution trace errors from failed runs.
  2. Uses Pareto-sampled evolutionary mutations where a reflection LLM edits specific prompt modules.
  3. Evaluates candidates against synthetic/historical test cases with LLM-as-a-judge rubrics and strict constraint gates (max tokens, formatting consistency).
* **Evidence [24:06, 24:30]:** Validated in ICLR 2026; beats RL/GRPO baselines by up to 10 points with 35x fewer rollouts.
* **Comparison to SkillOpt for SKILL.md Optimization:** GEPA optimizes prompt modules and agent execution prompts through offline evolutionary search creating pull requests (PR) rather than dynamically re-writing skills inline during run-time.

---

### 6. Application to Non-Coding Tasks & Non-Verifiable Workflows
* **Visual & Design System Extraction [37:05-42:55]:** Demonstrated creating a dedicated `Designer` agent by feeding it 4 image banners; the agent extracted styling principles (color palette `#F4ECEC`, 5:2 aspect ratio, hand-drawn typography, sticky-note callouts) and compiled a full `design_system.md` and `generate_banner.py` tool.
* **Financial Modeling & Research [11:12, 34:50-35:55]:** Demonstrated out-of-the-box skills for `3-statement-model`, `lbo-model`, and `merger-model` spreadsheet generation, alongside automated arXiv/web trend research synthesis (`Pulse` researcher bot).

---

### 7. Quality Signal & Speaker Credibility
High hands-on credibility. The speaker (Akshay Pachaar) authored deep-dive architectural analyses on X/articles, directly executed CLI installations live on macOS terminal, integrated Claude Code OAuth and OpenRouter API, configured Telegram bots in real-time, and demonstrated generated output artifacts [00:00-48:10].
### Comments (first-hand, corrections, disagreements)
- @jesusmachado8127: "How are you using the Claude subscription with Hermes? Is that not against Anthropic's TOS?" (concern/potential TOS conflict flagged by viewer, unanswered in comments)
- @nandunatekar: "Hey, on the contrary, I have a Claude Pro plan and not Claude Max subscription like you had in the video! Question: Do you know that if I can still use Claude code to setup my Hermes agent with the Claude Pro plan? FYI: I am using Hermes Desktop app that is much simpler (though setting up Hermes[...]" (first-hand setup question, raises Pro vs Max plan compatibility gap not addressed in video)
- @inkognito8020: "This was a fantastic video. Thanks a lot. Just had a q: Regarding L1 and L2 of progressive disclosure of skills. Is there any case where L1 would be loaded and L2 not be loaded? I am guessing L1 is loaded after the agent decides that it needs to execute the skill and L2 is how to execute the skill[...]" (technical clarifying question on the progressive-disclosure mechanism, not resolved in comments)
