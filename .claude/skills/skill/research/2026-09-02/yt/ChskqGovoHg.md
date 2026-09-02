## This Open Source Repo Just Solved Claude Code's #1 Problem, Chase AI
URL: https://www.youtube.com/watch?v=ChskqGovoHg  Date: 20260605  Views: 381550  Duration: 13:24
Class: ADJACENT
### Gemini analysis
### 1. Classification
**ADJACENT** ,  The video does not discuss Microsoft SkillOpt; instead, it provides an in-depth walkthrough, installation tutorial, and benchmark demo of **Graphify**, an open-source tool for building structured code and documentation knowledge graphs to optimize token usage and context retrieval in AI coding agents (Claude Code, Codex, Cursor).

---

### 2. Information Not in the SkillOpt Paper (Hands-On Results & Benchmarks)
* **Real-World Extraction Benchmark (08:12-08:26):** Ran `/graphify .` on the open-source repository `open-design`.
  * **Wall-clock time:** 6 minutes.
  * **Corpus analyzed:** 203 files.
  * **Graph output:** 1,907 nodes, 3,447 edges, 109 communities, 99% extracted, generating ~118k output tokens.
* **Direct Comparison Test (09:49-11:04):** Asked Claude Code the query *"trace how a design request flows from the web app to a coding agent and back"*:
  * **Without Graphify (Grep/Explore Agents):** Spawned 2 explore agents consuming ~150k tokens + 50k main session tokens = **~200k tokens total** (10:38-10:50).
  * **With Graphify (Graph Query):** Traversed pre-built knowledge graph using **~80k tokens** (~60% token reduction / 40% of baseline cost) (10:55-11:03).
* **Workflows & Commands Shown (05:56-07:35, 11:37-11:58):**
  * `graphify install` / `graphify install --project --platform <codex|claude|cursor>` (registers tool as a reusable skill).
  * `graphify hook install` (creates pre-commit hooks to deterministically update AST graphs at zero API cost).
  * `graphify --raw -obsidian` (exports knowledge graph directly to an Obsidian markdown vault).

---

### 3. Claims About What SkillOpt is GOOD At
* **None:** SkillOpt is not mentioned in this video.

---

### 4. Claims About What SkillOpt is BAD At
* **None:** SkillOpt is not mentioned in this video.

---

### 5. Mechanism of the Alternative (Graphify) & Comparison
* **Mechanism:**
  1. **Pass 1 (Deterministic AST, No LLM):** Uses Tree-sitter across 25+ languages to extract functions, classes, imports, and call graphs locally at zero API cost (02:01-02:31).
  2. **Pass 2 (Multimodal Transcription):** Runs local `faster-whisper` on audio/video files to convert speech to searchable text (02:32-02:44).
  3. **Pass 3 (Semantic LLM Extraction):** Uses LLM calls (Claude) only on markdown, PDFs, documentation, and images to infer cross-document relationships and assign confidence ratings (02:45-03:12).
* **Evidence:** Live hands-on demonstration on the `open-design` codebase showing token consumption drop from 200k to 80k on complex architectural tracing queries (10:11-11:04).
* **Comparison to SkillOpt:** While SkillOpt focuses on iterative prompt/skill optimization via execution feedback and textual gradients, Graphify optimizes agent execution context ahead-of-time through structural and semantic graph indexing, drastically reducing exploratory sub-agent token overhead.

---

### 6. Non-Coding Workflows and Non-Verifiable Tasks
* **Markdown & Document Repositories (03:55-04:10):** Graphify can ingest arbitrary non-code repositories (PDFs, markdown SOPs, policy docs, research papers).
* **Obsidian Knowledge Vaults (04:05-04:11, 07:30-07:38):** Can convert unstructured research folders into a structured Obsidian graph wiki without full vector-RAG infrastructure.
* **Structured vs. Fuzzy Retrieval (04:21-05:21):** Speaker notes that while GraphRAG relies on vector similarity for broad policy/prose questions ("What does policy say about X?"), Graphify combines deterministic AST relations with light LLM semantic clustering for exact relationship queries ("What connects A to B?").

---

### 7. Quality Signal
* **High credibility on tool execution:** Demonstrates hands-on terminal commands, runs live token-tracking benchmarks in Claude Code, and walks through raw graph visualizer outputs.
### Comments (first-hand, corrections, disagreements)
- @SulsaCikkectuve (0 likes), correction on headline number: "Great walkthrough! One number worth flagging: the \"up to 70x\" token savings doesn't match the demo ,  it shows ~80K tokens with the graph vs ~200K without, which is about 2.5x (you're paying ~40% of the cost). You even call 70x \"on the high side.\" 2.5x is a solid, honest win on its own; the 70x just " (comment truncated in source data)
- @sfil_sfil (4 likes), first-hand comparison: "Given a try to graphify before claude-mem. Graphify lost in my usecase (grep replace, auto capture+inject layer). But got interesting results with graphify cross-repo: ast over 30 repos -> wiki export per repo -> cross connection to architecture doc. Resulted pretty close to reality, but again, neve" (truncated)
- @jason_v12345 (59 likes), disagreement citing Claude Code's own creator: "I recall the creator of Claude Code himself, Boris Cherny, said that they had started with indexing the codebase but they realized early on that the models were so good at grepping that it was better to let them use that instead. I would think, too, that since codebases change frequently, that any t" (truncated)
- @Tuderble-pb6mg (34 likes), skeptical take: "Every day there's a dozen new memory tools like this released. If they worked, Anthropic and Openai would have integrated them already. The main issue is that Unlike Grep, because The graph isn't a perfect representation of the code the agent must take it with a grain of salt, and any inconsistencie" (truncated)
- @matthewwoodard9810 (8 likes), first-hand build experience: "I built this same thing about a year and a half ago. I actually built like 6 different versions, since then. The issue is that your graph becomes obsolete almost immediately. It can't update and ingest changes fast enough to keep up with a good human coder, much less the rate the coding agents make " (truncated)
- @curiousgeorge7515 (1 like), first-hand usage report: "I've been using it for weeks, but it doesn't save a lot of tokens. Perhaps with a huge code base. I think there's a better way. I ask to make a plan with a reference section of all relevant files and tools for the plan (how to do the tools calls, some older AI's trip over the simple stuff). I tell i" (truncated)
- @PwrSrg (0 likes), bug report: "I tried this in both Cursor and Codex and all I ever get is \"error: no LLM API key found\" - even though it is supposed to be LOCAL ONLY. 🤔"
- @DonatoEspera (185 likes), correction/comparison: "Modern IDE already has graph feature plus abstract syntax tree and doing what graphify does even before AI era. In fact, AI harness plugins like copilot, codex, claude, etc, leverage it to get your codebase context without token use. The IDE like vscode and  JetBrains IDE keep the graph updated as c" (truncated)
- @prabhatkumarsahu1512 (0 likes), limitation report: "Config files , yaml etc are not parsed as no ast exists so graphify fails in production bases for that have deployment configs which aren't mapped"
- @bh-on-youtube (26 likes), cost concern: "Repos can update many times per day.  Constant re-indexing get expensive vs ad-hoc grep."
- @jamesbennett-l4s (4 likes), disagreement re: staleness cost: "Wouldn't this quickly get stale in a large code base with many developers? Especially, if each developer is using agentic development. You'd have to constantly update it burning tokens that you'd be saving from having the graph. Seems like you'd end up with a net neutral or very low net positive."
- @vladyslav1 (0 likes), bug report: "Tried installing it and it said my codebase was too large, confusing"
- @ArhamBafna (1 like), bug report: "Is it just me or does running graphify install NOT INSTALL ITS SKILL TO '...\.agents\skills' for other agents to use too?"
- @RenatoKlaric (0 likes), first-hand cost warning: "DON'T run it from the agent to create the initial data - especially if you're on the Claude PRO subscription - one repo, using Sonnet 5, and it used up all session limit in 15 minutes. For those that are on Max or just don't care about token use - go for it, the rest of normal populace use `graphify" (truncated)
- @brentjohnson7196 (1 like), cost warning: "Warning!  The setup burns through tokens like nothing else."
- @ZSteven (0 likes), first-hand failure report: "Well. I tried it out.. First of all. it cannot do all repos. it cannot do most of my repos to be exact :D\nAlso graphify has lots of issues.\n\nAsk you agent to do some A/B testing with same task. (or multiple agents).\nand then ask agent to analyze the results and get token usage."
- @James-ln6li (0 likes), first-hand negative result: "I tried using Graphify with Claude Code and saw no improvement."
- @wouterdobro3864 (0 likes), correction: "5:15 not sure u are comparing the correct things here.\n\nIt seems as if u are describing RAG not graphRAG."
- @hunakosdem (0 likes), question re: possible transcript error: "You had a typo in \"do not use grapihfy\" at https://youtu.be/ChskqGovoHg?t=607 Did it have effect on the results?"
