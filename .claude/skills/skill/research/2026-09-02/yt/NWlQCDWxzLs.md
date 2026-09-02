## プロンプトやSkillの自動最適化【技術解説】, 数理の弾丸
URL: https://www.youtube.com/watch?v=NWlQCDWxzLs  Date: 20260606  Views: 10752  Duration: 48:56
Class: REGURGITATION
### Gemini analysis
### 1. Classification
**REGURGITATION** - The video is a slide-based academic paper explainer reviewing GEPA (Agrawal+ 2025) and SkillOpt (Yang+ 2026) directly from their published figures and ablation tables, followed by conceptual discussion.

---

### 2. Information Not in the SkillOpt Paper / README
* **Pure REGURGITATION** of paper figures/tables, but the hosts provide practical operational commentary:
  * **Need for Pre-Experiments / Pilot Runs (39:05, 41:17-42:12):** Small-sample pilot runs are essential before full optimization loops to understand LLM failure quirks and calibrate meta-prompts, avoiding runaway prompt inflation.
  * **Practical Hook Automation Idea (40:00-40:30):** Suggests running a post-session hook in agent frameworks (like Claude Code) to evaluate the session transcript and propose incremental prompt/skill diffs rather than full offline optimization.
  * **Sub-Agent Decomposition over Monolithic Prompts (46:05-47:05):** Recommends scoping automated optimization to modular, single-responsibility sub-agents (e.g., search fetcher, slide maker) rather than a monolithic main agent prompt to keep evaluation rubrics tractable.

---

### 3. What SkillOpt is GOOD At
* **Multi-Benchmark Skill Optimization across Agent Frameworks (33:12-35:15):** Achieves top benchmark scores across tasks (SearchQA, Spreadsheet, OfficeQA, DocVQA, LiveMath, ALFWorld) across different agent harnesses (Codex harness, Claude Code harness, Direct chat) using GPT-5.5 *(Benchmark from Yang+ 2026 paper)*.
* **Controlled Exploration via Learning-Rate Limits (35:48-36:18, 37:38-37:58):** Capping the number of skill edits per step (lr=4) prevents destructive over-editing and outperforms unconstrained dynamic learning rates *(Benchmark ablation)*.
* **Failure-Aware Editing via Rejected Buffer & Meta-Optimization (36:28-37:35):** Retaining rejected proposals in a short-term buffer prevents repeating bad modifications, while epoch-level meta-skill updating refines the optimizer itself *(Benchmark ablation)*.

---

### 4. What SkillOpt is BAD At / Where It Breaks
* **Non-Verifiable Everyday Tasks (39:28-39:50):** Fails to apply out-of-the-box to everyday assistant tasks lacking formal teacher data, unit tests, or clear programmatic evaluation rubrics *(Host Opinion / Critique)*.
* **Severe Overfitting Without Validation Sets (42:14-42:47):** Optimizing purely against a training dataset D causes severe overfitting, where the LLM inserts brittle, dataset-specific tokens that degrade general performance unless checked against a separate hold-out validation set D_val *(Host Commentary / Paper Principle)*.
* **Prompt Bloat / Hallucinated Specificity (41:50-42:10, 42:50-43:08):** Unchecked LLM-as-optimizer models tend to output excessively long, bloated instructions or memorize transient session quirks if prompt update constraints are omitted *(Host Opinion)*.

---

### 5. Alternative Mechanism: GEPA (Reflective Prompt Evolution)
* **Mechanism (08:40-14:30, 15:30-18:30):**
  1. Evaluates candidate prompt variants across training samples and generates reflective feedback.
  2. Uses **Pareto Front selection** across multiple problem dimensions to retain diverse, non-dominated prompt candidates (avoiding local optima).
  3. Explores prompts via a **tree-structured search** rather than a single trajectory, pruning dominated prompts while maintaining evolutionary branches.
* **Evidence (21:34-23:36):** Matches or outperforms DeepSeek GRPO reinforcement learning on HotpotQA and IFBench with drastically fewer rollouts (e.g., 678 rollouts for GEPA vs. 24,000 for GRPO on IFBench).
* **Comparison to SkillOpt (29:05-30:08, 32:20-33:40):** GEPA optimizes free-form system/task prompts; SkillOpt adapts GEPA's core reflective loop specifically to structured agent skill files (`SKILL.md`), adding gradient descent analogies (learning rate clipping, rejection buffer, epoch meta-optimization).

---

### 6. Non-Verifiable Tasks & Non-Coding Workflows
* **Evaluation Bottleneck (38:40-39:50, 43:30-44:25):** The bottleneck for copywriting, SOPs, or subjective workflows is designing the evaluation rubric; without an accurate LLM judge or deterministic scorer, self-optimization produces poor edits.
* **Synthetic Rubric Calibration (46:25-47:35):** Suggests pre-defining structured rubrics and using human-labeled historical outputs (or Anthropic-style eval rubrics) to score subjective quality before running optimization loops.
* **Data Quality Filtering Use-Case (26:07-27:08):** Cites Microsoft MAI-Thinking-1, which used GEPA on 2,000 human-labeled code/web documents to evolve an automated prompt that filtered 233B tokens of training data for educational value.

---

### 7. Quality Signal
* **Speaker Credibility:** Dr. Funakura (Kyoto University PhD, AI practitioner/author) clearly explains theoretical ML mechanics and cites papers accurately, though he did not execute live code or demo custom CLI benchmarks during the stream.
### Comments (first-hand, corrections, disagreements)
- @かがみ-j5e (1 like): "評価関数の設計そのものが難しいっていう古くから機械学習に伴っていた困難に再び直面する" [You run back into the old, classic ML difficulty: designing the evaluation function itself is hard] - critique/disagreement.
- @sui-douga (3 likes): "これskillの中身ではなく、description部分にフォーカスして最適化するとskillの読み込み精度が向上して、結果としてコンテキストも最適化され、出力が向上するのではと思いました。skillの発動タイミングだけなら評価方法も結果よりも難しくなさそうなので、そのうち試してみようと思います！" [My hunch: optimizing the SKILL's `description` field, not its body, would improve skill-load accuracy and thus context and output; evaluating just the trigger-timing looks easier than evaluating results, plan to try it] - proposed unverified idea, not yet tested.
- @gouldglennherbert2185 (1 like): "監査、審査のように評価項目が変わりにくく、過去の結果を正解データとして使えるようなケースにはこういった最適化手法は有用です。一方、動画でも述べられてますが、AIの特性で局所最適に陥りやすく、人間が頑張ってプロンプトやコンテキストをチューニングした方が結果精度は高くなるので、大幅な工数削減を目的としているような精度要求の厳しいケースだと採用できないです。" [Useful for cases like audits/reviews where eval criteria are stable and past results can serve as ground truth. But AI tends toward local optima; hand-tuned prompts still beat it on precision, so it's not adoptable for high-precision, big-labor-savings use cases] - critique with reasoning.
- @愚神_礼賛 (0 likes): "GEPAの仕組み自体は理解できるのですが、結局はDfeedback&検証セットの品質と、評価用LLMの品質がかなり重要になると思うのですが、これはどのように作成するのでしょうか？...LLMにやらせたいことは定性的なもので、そもそも人間で理想的な問いと回答のセットがたくさん用意できない場合が多く、困っています" [Understand GEPA's mechanism, but the quality of the feedback/validation set and the judge LLM seems critical - how is that built in practice? For qualitative tasks there's often no way to assemble many ideal Q&A pairs] - open gap not answered in video.
- @本山香-z5p (0 likes): "skillOptのミニバッチの評価自体は元のスキルのアウトプットの比較をしないから、エポック単位ではそこを比較してskill更新をするんですかね？ミニバッチ単位の改善の時点で元のskillの結果との比較もするものだと思っていたので。" [If SkillOpt's minibatch eval doesn't compare against the original skill's output, does the epoch-level step do that comparison instead? I'd assumed the minibatch step itself compared against the original skill's results] - technical question/possible gap in the explainer.
- @lxiebq4cx7-0zc4lez2oj (0 likes): "セッション終了後のhookてできなくない？いつ終わるか分からない訳だから。毎ターン毎ターンのhookはあり得るけど" [Isn't a post-session-end hook impossible? You don't know when a session ends. A per-turn hook could work though] - direct correction of the video's "post-session hook" automation suggestion (see analysis point 2).
- @2bym8 (2 likes): "非エンジニアですが、エンジニア向けというより、高学歴理系向けみたいな印象でした！...要するに、複数abテストをして、過剰にいいやつだけを残さずに複数回テストを繰り返して反映、改善を回したらいいよ！だけど、そもそもの正解とはっていうのが難しい分野は使いにくいよ！" [Non-engineer here; felt this was aimed less at engineers and more at highly-educated STEM viewers. My layperson takeaway: run multiple A/B tests, don't just keep the single best result, repeat and improve iteratively - but it's hard to use in domains where "what counts as correct" itself is unclear] - accessibility critique + own paraphrase/interpretation.
