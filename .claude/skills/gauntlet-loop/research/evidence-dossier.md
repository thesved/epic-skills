# The “Gauntlet Loop” - evidence dossier

Research date: **2026-08-14** (Asia/Bangkok).  
Subject: the prompting/orchestration technique named by Matt Shumer and demonstrated with *Claude of Duty*.  
Evidence policy: primary sources first; practitioner reports are identified as such; claims are not upgraded beyond what the cited source establishes.

> **Chronology correction.** The two X status IDs supplied in the research brief are not from January 2026. Decoding their X snowflakes gives `2026-07-27T19:52:56.301Z` and `2026-07-27T21:41:52.992Z`; X’s own oEmbed endpoint labels both **July 27, 2026**. The demo and prompt posts are from July 25. The event went viral in late July 2026. ([naming post](https://x.com/mattshumer_/status/2081830214384886228), 2026-07-27; [guide post](https://x.com/mattshumer_/status/2081857631254372509), 2026-07-27; [demo post](https://x.com/mattshumer_/status/2081054356405731740), 2026-07-25; [prompt post](https://x.com/mattshumer_/status/2081100592689324502), 2026-07-25.)

> **Verbatim-excerpt constraint.** The full artifacts were retrieved and inspected. This dossier supplies exact short excerpts, cryptographic hashes, line-level decompositions, and direct raw-file links. It does not republish entire non-Reddit pages/files. Long Reddit quotations are reproduced because the source is a public discussion forum; they should still be treated as practitioner testimony, not independently verified fact.

## 1. ORIGIN

### 1.1 Timeline and primary artifacts

1. **Demo.** Shumer posted the game demo on July 25, saying: “Claude Opus 5 one-shotted this game.” He also said everything shown was custom code and no external asset was used. ([X](https://x.com/mattshumer_/status/2081054356405731740), Matt Shumer, 2026-07-25.)
2. **Prompt publication.** Later July 25, Shumer posted the prompt on X; X oEmbed exposes its opening and then truncates it with an ellipsis. ([X](https://x.com/mattshumer_/status/2081100592689324502), Matt Shumer, 2026-07-25.)
3. **Repository.** The public repository’s initial commit is timestamped `2026-07-25T19:28:36Z`; `prompt.md` says it is the entire prompt. ([repository](https://github.com/mshumer/Claude-of-Duty), Matt Shumer, 2026-07-25; [raw prompt](https://raw.githubusercontent.com/mshumer/Claude-of-Duty/main/prompt.md), Matt Shumer, 2026-07-25.)
4. **Naming.** On July 27 Shumer wrote: “I’m officially calling this the Gauntlet Loop.” The same post defines the agent-not the user-as decomposer, then names specialist builders, ruthless blind critics, and a real-world-equivalent pass bar. ([X](https://x.com/mattshumer_/status/2081830214384886228), Matt Shumer, 2026-07-27.)
5. **Guide.** About 109 minutes later, Shumer linked the released guide and said the method worked beyond games. ([X](https://x.com/mattshumer_/status/2081857631254372509), Matt Shumer, 2026-07-27; [guide](https://somethingbig.ai/gauntlet-loop), Matt Shumer, 2026-07-27.)

The naming post’s `t.co` URL resolves to the July 25 prompt post. The guide post’s first `t.co` URL resolves to Shumer’s guide and its second resolves to the original demo. These redirects were retrieved directly on 2026-08-14.

### 1.2 Exact original prompt: retrieval record

Authoritative raw file: <https://raw.githubusercontent.com/mshumer/Claude-of-Duty/main/prompt.md>  
Repository blob view: <https://github.com/mshumer/Claude-of-Duty/blob/main/prompt.md>  
File SHA-256 on retrieval: `4c6d494ebaa6123309bc5e0a29b4ab07cadb279b4376239e02d78e3a240667c2`

Exact opening (25 words):

```text
I want you to build a first-person shooter at the level of the most recent Call of Duty games. It should be utterly perfect, visually beautiful,
```

The remaining two paragraphs, verified against the raw file, contain these exact command/rule phrases in this order: `Fan out sub-agents`; `/loop on each item`; `a separate sub-agent`; `a really harsh critic`; `Don't stop`; `compared with the actual Call of Duty game`; `side by side blind`; `Do this in ThreeJS`; `/loop until it's utterly perfect`; `ultracode`. ([raw prompt](https://raw.githubusercontent.com/mshumer/Claude-of-Duty/main/prompt.md), Matt Shumer, committed 2026-07-25.)

**Cross-check:** The Prompt Index reproduces the same three-paragraph prompt and links back to Shumer’s file. ([The Prompt Index](https://www.thepromptindex.com/ai-loop-engineering-gauntlet-loop-guide.html), 2026-07-29.) Decrypt describes it as three short paragraphs and independently lists the same elements. ([Decrypt](https://decrypt.co/374560/dumbest-ai-prompt-claude-beat-careful-game-design), José Antonio Lanz, 2026-07-28.)

### 1.3 Full practitioner port showing the wording pattern

BoneShaman reported using Shumer’s prompt with “very very mild tweaks,” substituting Crash Bandicoot for Call of Duty. This is the post’s verbatim prompt, including command placement:

```text
/goal
I want you to build a 3D platformer Claude Bandicoot at the level of the Crash Bandicoot game. It should be utterly perfect, visually beautiful, with every single thing done at AAA quality-from textures to physics to anything you could think of.
Fan out sub-agents and have sub-agents tackle each one individually so that the game is utterly perfect. You should
/loop
on each item and have a separate sub-agent check it visually to ensure it looks triple A. That separate sub-agent should be a really harsh critic, and if it doesn't look triple A, it should keep going.
Don't stop until each sub-agent is utterly wowed with the quality when compared with the actual Crash Bandicoot game. It should literally compare them side by side blind and say which one looks better. Do this in ThreeJS.
/loop
until it's utterly perfect. Fan out sub-agents and ultracode.
```

Source: [“Claude Bandicoot - Shumer’s Gauntlet Loop on a 3d Platformer”](https://www.reddit.com/r/ClaudeAI/comments/1v9m76g/claude_bandicoot_shumers_gauntlet_loop_on_a_3d/), u/BoneShaman, 2026-07-29.

### 1.4 Shumer’s later meta-prompt

Shumer’s July 27 guide supplies a reusable meta-prompt. It asks a strong model to select the strongest inspectable comparison; write a short prompt; let the lead agent choose approach and decomposition; create builder/fresh-context-critic pairs; inspect actual output; use blind A/B when possible; return the largest gap; loop until the output wins or the user stops it; maintain a live progress page; and use subagents plus ultracode. ([guide](https://somethingbig.ai/gauntlet-loop), Matt Shumer, 2026-07-27.)

Exact excerpt (25 words):

```text
I want to run a Gauntlet Loop for this goal: [GOAL] Possible references or quality bars: [OPTIONAL REFERENCES] Choose the strongest concrete bar that
```

Direct guide anchor: <https://somethingbig.ai/gauntlet-loop#build-your-own-gauntlet-loop-prompt>

### 1.5 Gist/doc search outcome

- **FOUND:** the official GitHub `prompt.md` above.
- **FOUND:** Shumer’s released guide above.
- **FOUND:** Shumer linked a live horror-novel progress document at `workbench.md/d/52WesXD2rM?...`; the searchable mirror exposes only the shortened URL, and the live document was not reliably retrievable. ([TwStalker mirror of Shumer](https://site.twstalker.com/mattshumer_), mirror captured late July 2026.)
- **NOT FOUND: an additional Shumer-authored gist or standalone prompt document.** Searched the two supplied X posts, their resolved `t.co` targets, Shumer’s profile mirrors, GitHub profile/repository, and queries for `Matt Shumer Gauntlet Loop gist`, `doc`, and `prompt` on 2026-08-14.

## 2. MECHANISM

This section distinguishes the author’s definition from later safety-oriented extensions.

### 2.1 Author-defined algorithm

The July 27 naming post is the most compact definition. In one post Shumer assigns the lead agent the decomposition, one specialist builder and one blind critic per part, and a mandate to pass only against a real-world equivalent. ([X](https://x.com/mattshumer_/status/2081830214384886228), Matt Shumer, 2026-07-27.) The guide expands it into the following operational sequence. ([guide](https://somethingbig.ai/gauntlet-loop), Matt Shumer, 2026-07-27.)

1. **Give a lead agent an outcome and a concrete model of excellence.** The reference must be directly inspectable, not merely an adjective.
2. **Do not prescribe the implementation.** Shumer says the original prompt omitted architecture and a system inventory. His reason: excessive prescription substitutes the user’s route for the model’s judgment.
3. **The agent decomposes the artifact.** It chooses the smallest independently improvable/judgeable parts. Shumer’s game examples include gun, hands, trees, bushes, lighting, movement, enemy behavior, sound, and effects; writing examples include argument, opening, examples, sections, paragraphs, and transitions.
4. **One builder handles each important part.** Independent pieces can run in parallel; decomposition should follow the artifact, not a fixed human checklist.
5. **A separate critic receives fresh context.** Give it the goal, bar, relevant rules, and artifact-but not builder history or explanations.
6. **The critic examines reality.** It inspects pixels, a running product, the rendered page, real tests, or finished prose. It never grades the builder’s summary.
7. **Prefer blind A/B.** Hide which output is which, force a binary preference, and compare directly with the reference.
8. **On rejection, identify the single largest meaningful gap.** Return that gap to the builder rather than issuing diffuse praise or general commentary.
9. **Repeat.** Do not choose an arbitrary third/final round. Continue until the output reaches the bar or the user stops.
10. **Optionally smooth the integrated artifact.** At the end of a major wave, a fresh agent checks consistency and conflicts across separately improved pieces.

### 2.2 Why each rule matters, according to Shumer

| Rule | Author’s stated reason | Source/date |
|---|---|---|
| Goal, not implementation | Prescribing architecture replaces model judgment with the user’s judgment. | [Shumer guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27 |
| A real bar | Vague praise-words are not gradeable; an agent needs something it can inspect and compare. | [Shumer guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27 |
| Bar can be unreachable | Call of Duty kept the run improving past “pretty good for AI”; it supplied direction even though the game never won. | [Shumer guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27; [repo assessment](https://github.com/mshumer/Claude-of-Duty#honest-assessment), 2026-07-25 |
| Small parts | “Improve the game” is too vague; a specific tree/reference comparison is repeatedly attackable. | [Shumer guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27 |
| Builder cannot grade itself | The builder remembers compromises and can justify why work is reasonable; the task needs independent judgment. | [Shumer guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27 |
| Fresh/blind critic | Removing provenance and builder explanation makes the critic act more like an A/B tester and reduces self-approval. | [Shumer guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27 |
| Inspect actual artifact | A builder’s report can be polished while the thing itself is poor; verification must touch pixels/product/tests/prose. | [Shumer guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27 |
| No fixed round count | A high bar leaves more gaps; the game was still improving when Shumer stopped it. | [Shumer guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27 |
| Live progress surface | The user can monitor without interrupting the agent and breaking momentum. | [Shumer guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27 |
| Integration/smoothing pass | Separately optimized pieces can become inconsistent or conflict. | [Shumer guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27 |

### 2.3 Choosing the “real-world equivalent” bar

Shumer’s domain mapping is concrete. For visual games: real Call of Duty screenshots. For websites: leading live sites in the category. For prose: paragraphs demonstrating desired clarity/information compression. For backend engineering: a test suite, latency target, failure-recovery test, security review, or reference implementation. If no bar is known, selecting and defending one becomes part of the task. ([guide](https://somethingbig.ai/gauntlet-loop), Matt Shumer, 2026-07-27.)

The author’s underlying test is inspectability. A reference is not functioning as a bar unless the critic can place the candidate against it or execute a corresponding measurement.

### 2.4 What is core and what is not

- **Core:** split → build → independent judgment → repeat. ([guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27.)
- **Implementation convenience, not definition:** `/loop`, `ultracode`, and Claude Code. Shumer recommends them for this run; RoboNuggets later supplies plain-language substitutions for other agents. ([guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27; [RoboNuggets README](https://github.com/robonuggets/gauntlet-loop), 2026-08-05.)
- **Optional:** final smoothing/integration agent and live status page. ([guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27.)
- **Not a claim that the reference was beaten:** Shumer explicitly says the game did not become better than Call of Duty; the repository says every blind critic selected the real frame. ([guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27; [README](https://github.com/mshumer/Claude-of-Duty#honest-assessment), 2026-07-25.)

## 3. VARIANTS + REIMPLEMENTATIONS

### 3.1 `robonuggets/gauntlet-loop`

Repository: <https://github.com/robonuggets/gauntlet-loop>  
Initial commit: 2026-08-05; author credit: RoboNuggets/Jay E; license: CC BY 4.0.  
README SHA-256: `8ebca72e3e8308c3c7bfb2e3a58128a44e3f1fe89ee2838d8871a12cd50b29c7`  
SKILL.md SHA-256: `6a345a43bf58966c83d50b6caf8be34a3fee725fb3c75778ed33fa206352b835`

Raw files read in full:

- <https://raw.githubusercontent.com/robonuggets/gauntlet-loop/main/README.md>
- <https://raw.githubusercontent.com/robonuggets/gauntlet-loop/main/.claude/skills/gauntlet-loop/SKILL.md>

Exact README excerpt (25 words):

```text
A skill that turns any goal into one short, paste-ready prompt. That prompt makes your agent pick a real quality bar, split the work into small
```

What it changes/adds versus Shumer:

1. **A prompt-generator skill, not the executing method.** It asks for a goal, proposes two or three candidate bars, waits for a choice, then emits one roughly 120-180-word prompt and offers to run it.
2. **Formal bar validation.** The bar must be **named**, **fetchable**, and **comparable**. This is a sharper operational test than the original’s named Call of Duty target.
3. **Taste plus a number.** When a measurable dimension exists, it adds performance/cost/benchmark/pass-rate evidence alongside reference taste.
4. **Binary choice instead of score.** It explicitly says scores drift upward; the critic must pick A or B.
5. **Single largest gap.** The critic returns one correction target per pass.
6. **Portability.** It replaces Claude-specific `/loop` and `ultracode` with plain instructions when used elsewhere.
7. **No default cap.** The skill adds a budget line only if the user supplied one. It retains the original “win or user stops” exit and rejects fixed round counts.
8. **More prescriptive prompt-generation procedure.** Shumer tells a capable model to select the bar; RoboNuggets pauses for a human choice among two or three options.

The SKILL’s domain table uses live named UI, shipped-game footage, a specific published article, a named codebase plus benchmark/tests, an analyst report/paper methods section, or a real comparable deliverable. ([SKILL.md](https://github.com/robonuggets/gauntlet-loop/blob/main/.claude/skills/gauntlet-loop/SKILL.md), RoboNuggets, 2026-08-05.)

### 3.2 The Prompt Index guide

Source: [“AI Loop Engineering in 2026: How to Build a Gauntlet Loop”](https://www.thepromptindex.com/ai-loop-engineering-gauntlet-loop-guide.html), The Prompt Index, 2026-07-29.

Changes versus original:

1. Embeds the Gauntlet pattern in a larger **objective / metric / boundary** framework.
2. Adds explicit time, cost, attempt, permission, safety, uncertainty, and escalation stops.
3. Requires durable state: record changes, evidence, scores, failed approaches, next action, and remaining budget.
4. Warns to parallelize only genuinely independent work and cites Shumer’s repo evidence that coupled visual systems performed worse under broad fan-out.
5. Requires changed strategy after repeated failure, plus plateau detection.
6. Adds integration, accessibility, safety/editorial checks and forbids deployment, spending, credential use, messaging, or irreversible action without approval.
7. Distinguishes a one-run prompt-led Gauntlet from an engineered recurring loop with triggers, state, permissions, recovery, and approvals.

This is safer but materially different from Shumer’s advice not to prescribe a fixed number of rounds. The Prompt Index template permits attempt caps and explicit boundaries.

### 3.3 Something Big guide (author’s own post-hoc formalization)

Source: [“How to Run a Gauntlet Loop”](https://somethingbig.ai/gauntlet-loop), Matt Shumer, 2026-07-27.

Changes versus the July 25 prompt:

- Makes “real, inspectable bar” explicit rather than leaving it implicit in Call of Duty.
- Explains fresh context and hiding builder history.
- Generalizes from visual comparison to tests, latency, recovery, security, reference implementation, and prose.
- Adds a live progress page and optional integration pass.
- Names human stopping criteria: satisfaction, negligible marginal improvement, or compute budget.
- Recommends an agentic harness and says a normal chat will not reproduce the workflow.

### 3.4 Our Nation Online

Source: [“The Gauntlet Loop: The Builder-vs-Critic Prompt Behind Claude’s Viral Game Demo”](https://ournationonline.com/gauntlet-loop-claude-builder-critic-prompt-explained/), Chethan, 2026-08-10.

Changes versus original:

- Recasts the technique as a fusion of orchestrator-workers and evaluator-optimizer patterns.
- Says it works best as a **second pass** after a human-approved MVP, not from a blank page.
- Recommends an explicit time, token, or maximum-round stop.
- Calls it automated QA against a preapproved target rather than an open-ended creation method.
- Warns that the wrong reference yields increasingly polished off-brief work.

Its article links `duolahypercho/gauntlet-loop`, not the requested `robonuggets/gauntlet-loop`. That is a separate repository/fork attribution and should not be silently treated as the same source.

### 3.5 Decrypt

Source: [“The Dumbest-Looking AI Prompt Just Beat Months of Careful Game-Design Prompt Engineering”](https://decrypt.co/374560/dumbest-ai-prompt-claude-beat-careful-game-design), José Antonio Lanz; edited by Guillermo Jimenez, 2026-07-28.

What it contributes/changes:

- Frames the prompt as a reversal of detailed prompt engineering.
- Reports a parallel comparison: Leon Lin’s roughly 20-section, non-subagent, non-ultracode Cursor prompt also made an attractive playable result, but none of the follow-ups ran Shumer’s blind test.
- Reports James Altucher’s “a little over ten hours” and roughly 1.3 million tokens for *Operation Blackout*.
- Adds a contamination/prior-art caveat: FPS camera, movement, and raycasting patterns have long been tutorialized; no build checked whether near-identical training examples contributed.
- Reports Shumer’s actual critic trajectory rather than equating “one prompt” with AAA parity.

### 3.6 Other reimplementations found

1. **RoboNuggets skill**: generates prompts; does not run an engineered state machine. ([GitHub](https://github.com/robonuggets/gauntlet-loop), 2026-08-05.)
2. **`cgraves09/gauntlet`**: applies hill-climbing to an OpenClaw agent’s workspace. It runs a fixed task suite, makes one mutation, reruns/scorers, keeps improvements and discards losses, and records experiments in Git. This is optimizer/eval engineering, not Shumer’s per-artifact specialist-builder/blind-critic prompt. ([GitHub](https://github.com/cgraves09/gauntlet), Chris Graves, repository found 2026-07/08.)
3. **Arcade’s “Gauntlet” workflow**: a user agent explores a service, a second agent rewrites from findings, and a third reruns locked regression scenarios; a different model reviews the final diff. It reports about ten hours to convergence and about 10,000 LOC, and says ten MCP toolkits replaced about two months of work. This is a concrete engineered loop with regression protection, not a blind visual A/B. ([Arcade](https://www.arcade.dev/blog/gauntlet-agents-build-mcp-servers/), author/date displayed July 2026.)
4. **Practitioner prompt template:** u/victorrseloy2 retained Shumer’s superlative language and substitution slots `[THING]`, `[REFERENCE]`, `[TIER]`, `[AREA]`, `[CHECK]`, and `[STACK]`. ([Reddit](https://www.reddit.com/r/aigamedev/comments/1vjv3z8/i_left_claude_code_running_for_24h_it_built_a_3d/), 2026-08-09.)

## 4. RESULTS BEYOND GAMES

Evidence quality is uneven. “Applicable to a domain” is separated from “a named completed use.”

### 4.1 Author-claimed applicability

Shumer explicitly names code, websites, product design, marketing campaigns, writing, and research as applicable whenever output can be inspected and improved. ([guide](https://somethingbig.ai/gauntlet-loop), Matt Shumer, 2026-07-27.) This is an applicability claim, not evidence of completed results in all six domains.

### 4.2 Named or directly documented examples

#### Design / frontend

Siqi Chen reported independently using a similar loop for frontend design/development, with GPT Image 2 concept art as a “northstar,” and called it extremely effective. ([TwStalker mirror of @blader](https://mobile.twstalker.com/blader), post displayed 2026-07-27; exact X status URL/timestamp **NOT FOUND**.) This is a first-person practitioner endorsement, but not a published controlled comparison.

#### Writing

Shumer posted a live Gauntlet run writing a full horror novel and linked a workbench document. ([TwStalker mirror of @mattshumer_](https://site.twstalker.com/mattshumer_), post displayed 2026-07-28.) **Outcome NOT FOUND:** the mirror establishes the running experiment, not a finished novel or quality assessment; the workbench URL was shortened and not reliably retrievable.

The Prompt Index supplies a bounded book template: 45,000 words, approved outline, sourced claims, chapter-level rubrics, no invented sources, maximum five critic rounds per chapter, and human approval before “final.” ([guide](https://www.thepromptindex.com/ai-loop-engineering-gauntlet-loop-guide.html), 2026-07-29.) This is a template, not a result.

#### Research / education - a documented failure

Tomas Kubica used a multi-critic loop to create a one-day Microsoft Foundry workshop. He says it spent **$70** and made polished, correct, pedagogically structured materials-but omitted Azure usage, the essential requirement. His diagnosis: the loop perfected the dimensions its reviewers measured and never touched a real Azure resource. ([“Your company’s most valuable asset…”](https://tomaskubica.cz/en/2026/evals-nejcennejsi-aktivum/), Tomas Kubica, 2026-07-31.)

Short exact excerpts:

```text
Seventy dollars later they presented the result.
```

```text
There was no Azure in it.
```

This is the strongest non-game case found because it reports cost, output character, failure, and root cause.

#### Code / tooling

Arcade reports a three-role loop used to create ten MCP toolkits over a weekend: exploratory user agent, code-rewriting agent, and locked-scenario regression agent, with a separate-model final review. It reports approximately ten hours, approximately 10,000 LOC per overnight convergence run, and a previous team estimate of about two months for ten toolkits. Named services include Google Slides, Fireflies, Insightly, and Datadog. ([Arcade](https://www.arcade.dev/blog/gauntlet-agents-build-mcp-servers/), July 2026.)

This is adjacent to, rather than a literal copy of, Shumer’s loop: it has external scenarios, regression checks, and cross-model review; it does not claim a blind side-by-side real-world-equivalent test.

#### 3D outside the original FPS

A No Man’s Sky/space-exploration practitioner described two ideas: an independent adversarial agent comparing screenshots with AAA titles such as Starfield, explicitly based on Shumer’s *Claude of Duty* prompt, plus Blender MCP so Claude could model assets. The setup involved human feedback on a spaceship model and then persisting learnings as a `blender-hardsurface` skill. ([Reddit thread](https://www.reddit.com/r/singularity/comments/1v8lj7w/someone_made_a_nms_style_exploration_game_in_a/), 2026-07-28.) This is still game-related, but documents transfer from procedural Three.js assets to a Blender-based 3D pipeline.

u/nospoon99 used one generated reference image as the hard bar for a Shenmue-inspired town. At wave ten, environments had improved, but NPC appearance, dialogue, story, and goals remained weak; Godot+Blender progressed more slowly and needed more direction than Three.js. ([Reddit](https://www.reddit.com/r/aigamedev/comments/1vixpx2/the_gauntlet_loop_with_a_reference_image/), u/nospoon99, 2026-08-08.)

#### Marketing

**NOT FOUND: a named completed marketing-campaign case with inspectable before/after evidence.** Searched `"Gauntlet Loop" marketing`, Shumer’s guide/profile mirrors, Reddit, GitHub, and general web results on 2026-08-14. The author and Prompt Index state that the pattern transfers to marketing, but the retrieved corpus did not provide a named completed campaign, cost, rounds, or outcome.

### 4.3 Game replications retained as parameter evidence

Although not “beyond games,” these are the strongest independent operational reports:

- *Claude Bandicoot*: three five-hour Opus 5 Ultracode windows; manual cleanup prompts afterward; stopped by user while still improving. ([Reddit](https://www.reddit.com/r/ClaudeAI/comments/1v9m76g/claude_bandicoot_shumers_gauntlet_loop_on_a_3d/), u/BoneShaman, 2026-07-29.)
- GTA-like prototype: initial loop “failed spectacularly”; additional loops/workflows; 22 hours and 86 agents; structured JSON game state worked better than extracted video frames. ([Reddit](https://www.reddit.com/r/ClaudeAI/comments/1ve7u9r/gta_6_first_attempt_far_from_perfect_but_its/), u/smith2008, 2026-08-03.)
- 3D roguelite: three roughly eight-hour Gauntlet sessions across 24 hours, plus a fourth trailer session; 60k TypeScript LOC and 8.5k documentation LOC; around 40% of Max 20x weekly allowance; reported API-equivalent session-log cost about $1,800. ([Reddit](https://www.reddit.com/r/aigamedev/comments/1vjv3z8/i_left_claude_code_running_for_24h_it_built_a_3d/), u/victorrseloy2, 2026-08-09.)

## 5. CRITICISMS + FAILURE MODES

### 5.1 The original project did not pass its own bar

The repository’s “Honest assessment” is primary evidence. The target was modern Call of Duty; the authors state it did not match. Eleven independent critics produced aggregate rounds `3.59 → 4.14 → 4.05 → 5.05/10`; two shots were “CLOSE,” the others “AMATEUR”; every blind A/B chose the real game. It lists weak hands, procedural-looking materials, mannequin-like enemies, approximate indirect light, and 28-30 FPS at Retina. ([README](https://github.com/mshumer/Claude-of-Duty#honest-assessment), Matt Shumer, 2026-07-25.)

This demonstrates three points:

- Rejection loops can improve without ever reaching the nominal bar.
- A later round can regress (`4.14 → 4.05`).
- “One prompt” describes user interaction count, not one model call, one pass, or bar attainment.

### 5.2 Parallel-agent collisions and local/global inconsistency

The original repository reports a controlled process comparison. Three rounds of six directory-owning agents improved the score only `+0.46` while major defects went `60 → 47 → 66`. One sequential pass with one owner per coupled concern improved `+1.00` and reduced defects `66 → 26`. The stated cause was coupling among tonemapping, sky, and indirect light: isolated agents broke each other’s assumptions. ([README process note](https://github.com/mshumer/Claude-of-Duty#process-note), Matt Shumer, 2026-07-25.)

This directly contradicts naïve “fan out everything” implementations. Parallelism helps only when ownership boundaries are real.

### 5.3 Critic gives the wrong fix; builder follows the metric

The repo says three rounds of critics called the weapon “untextured.” Earlier fixes lowered albedos to fight bright-part complaints, reducing diffuse contribution and worsening the actual defect. The valuable fix came from an agent contradicting the brief and measuring the lighting. ([README process note](https://github.com/mshumer/Claude-of-Duty#process-note), 2026-07-25.)

Failure pattern: repeated criticism is not necessarily correct; a loop can intensify a mistaken diagnosis. Measurement that identifies causal mechanism can outperform another aesthetic complaint.

### 5.4 Wrong bar / omitted essential dimension

Kubica’s $70 workshop is a clean Goodhart-style example: reviewers checked topic, structure, visual design, and pedagogy but not hands-on Azure resource use. The artifact became excellent on the measured axes and unusable for the intended workshop. ([Kubica](https://tomaskubica.cz/en/2026/evals-nejcennejsi-aktivum/), 2026-07-31.)

Our Nation Online makes the same point prospectively: the loop closes the gap against the reference given; it cannot choose the correct reference for the user. It recommends a human-approved MVP first. ([Our Nation Online](https://ournationonline.com/gauntlet-loop-claude-builder-critic-prompt-explained/), 2026-08-10.)

### 5.5 Same-model correlation, “blindness,” and collusion risk

Fresh context removes the builder’s narrative, but it does not make two instances statistically or epistemically independent. A highly upvoted Reddit rebuttal states:

> “Loop engineering” can be useful. This “Gauntlet Loop” is the weaponized-dumb version of it.  
> You have created an effectively unbounded agentic state with:  
> * a moving objective,  
> * critics that can invent new deficiencies every round,  
> * correlated models masquerading as independent review,  
> * no fixed authority boundary,  
> * no stable invariants,  
> * no meaningful cost ceiling,  
> * and no requirement to prove that each iteration preserved what already worked.

The commenter continues:

> “Keep improving until the reference loses” is not a stopping condition either. The critic can always discover another dimension on which the reference wins, redefine what “better” means, and generate the justification for another round. The loop therefore renews its own mandate.

And recommends fixed evidence, bounded scope, invariants, iteration/token limits, rollback, plateau detection, and human approval before objective changes. ([Reddit](https://www.reddit.com/r/ChatGPTPromptGenius/comments/1va6vh6/the_gauntlet_loop_give_ai_a_clear_goal_a_harsh/), anonymous commenter in u/ThePromptIndex thread, 2026-07-30.)

No retrieved source demonstrated explicit builder/critic secret coordination. The empirical concern found is **correlated blind spots and self-reinforcing objectives**, not proven collusion.

**NOT FOUND: a controlled experiment directly measuring “critic-builder collusion” in a Shumer-style Gauntlet Loop.** Searched that phrase and combinations of `critic`, `builder`, `collusion`, `correlated`, and `Gauntlet Loop` on 2026-08-14.

### 5.6 Gaming the bar / Goodhart behavior

The Prompt Index’s failure list says a narrow metric may be passed while damaging the true objective; it recommends multiple guardrails. It also warns about subjective goals, repeated unchanged strategy, context rot, agent collisions, self-reported progress, broad permissions, and absence of budget boundaries. ([Prompt Index](https://www.thepromptindex.com/ai-loop-engineering-gauntlet-loop-guide.html#where-ai-loops-fail), 2026-07-29.)

RoboNuggets identifies a specific hallucination mode: if the reference is not fetchable, the critic invents the comparison and approves the work. It therefore requires named/fetchable/comparable bars. ([README](https://github.com/robonuggets/gauntlet-loop#why-a-bar-and-not-a-rubric), 2026-08-05.)

### 5.7 Cost blowups

Practitioner evidence:

- “My usage on Claude Max 5 went bananas.” The run consumed a full five-hour window in only a couple of hours, roughly one to two waves per window, with each window reported as 10% of weekly usage. ([u/nospoon99](https://www.reddit.com/r/aigamedev/comments/1vixpx2/the_gauntlet_loop_with_a_reference_image/), 2026-08-08.)
- 24-hour roguelite: 40% of Max 20x weekly allowance and approximately **$1,800 API-equivalent** per session logs. ([u/victorrseloy2](https://www.reddit.com/r/aigamedev/comments/1vjv3z8/i_left_claude_code_running_for_24h_it_built_a_3d/), 2026-08-09.)
- GTA experiment: 22 hours, 86 agents; Reddit’s automated thread summary reports about $1,700 API-equivalent, but because that number is from the summary rather than the OP text, it should be treated as lower-confidence. ([thread](https://www.reddit.com/r/ClaudeAI/comments/1ve7u9r/gta_6_first_attempt_far_from_perfect_but_its/), 2026-08-03.)
- James Altucher replication: a little over ten hours and roughly 1.3 million tokens, reported by Decrypt. ([Decrypt](https://decrypt.co/374560/dumbest-ai-prompt-claude-beat-careful-game-design), 2026-07-28.)
- Kubica workshop failure: $70 for an artifact discarded as off-objective. ([Kubica](https://tomaskubica.cz/en/2026/evals-nejcennejsi-aktivum/), 2026-07-31.)

### 5.8 State loss and context compounding

u/Ronar123 reported subagents being killed at the usage limit and uncertainty about costly reconstruction. A commenter’s practitioner diagnosis is useful verbatim:

> the problem is state loss, not the limit itself. 'continue' forces the new context to reconstruct everything from memory, which is lossy and token-heavy. those reconstruction tokens still count against your next window.
>
> what works: have the agent maintain a state file it updates as it goes. what's done, what's next, anything the next session needs to know. when the limit hits, you restart with 'read state.md, resume from step X' and the new context doesn't have to guess. it just reads the file.
>
> the gauntlet pattern specifically piles up context fast because each iteration carries the history of previous ones. keeping state external breaks that compounding.

Source: [r/ClaudeAI](https://www.reddit.com/r/ClaudeAI/comments/1vi86sc/how_to_handle_claude_running_out_of_session/), u/sael-you replying to u/Ronar123, 2026-08-07.

Another commenter reports a job scoped to eight subagents spawning more than 30 because recursive spawning was not forbidden, burning a five-hour window in about 15 minutes. The proposed controls were 2-3 subagents maximum, no recursive spawning, incremental on-disk findings, and an updated loop state file. (Same [thread](https://www.reddit.com/r/ClaudeAI/comments/1vi86sc/how_to_handle_claude_running_out_of_session/), 2026-08-08.)

### 5.9 Weak observation channels

u/smith2008 reports that the first GTA attempt failed, video clips were reduced to frames, and structured JSON representing game state worked “far better.” ([Reddit](https://www.reddit.com/r/ClaudeAI/comments/1ve7u9r/gta_6_first_attempt_far_from_perfect_but_its/), 2026-08-03.) A commenter distinguishes visual-state tasks from logical puzzle correctness: puzzle solvability and win conditions should use a cheap deterministic solver instead of repeated pixel argument. (Same thread, u/Frequent-Ad-836, 2026-08-03.)

Failure pattern: the critic can only optimize what its tools expose. Screenshots are weak for temporal behavior and logic; summaries are weaker still.

### 5.10 Positive and negative practitioner quotes

Positive:

> “Based on Matt Shumer's Gauntlet Loop. Ran the experiment myself. Did a few prompts of clean up to tie it up at the end. I think it would continue to improve, but I burned 3 sets of 5hr windows on Opus 5 Ultracode, and was happy with the conclusion.”  
> - u/BoneShaman, [Reddit](https://www.reddit.com/r/ClaudeAI/comments/1v9m76g/claude_bandicoot_shumers_gauntlet_loop_on_a_3d/), 2026-07-29.

> “The world feels alive, the time passes, npc move, talk, sit, sun goes down, lights turn on etc... It's quite impressive.”  
> - u/nospoon99, [Reddit](https://www.reddit.com/r/aigamedev/comments/1vixpx2/the_gauntlet_loop_with_a_reference_image/), 2026-08-08.

Negative/mixed:

> “The first attempt failed spectacularly. It got stuck after generating little more than a basic 3D world.”  
> - u/smith2008, [Reddit](https://www.reddit.com/r/ClaudeAI/comments/1ve7u9r/gta_6_first_attempt_far_from_perfect_but_its/), 2026-08-03.

> “By wave 7 I started to give it some basic feedback as it kept iterating on the environments and I thought they already look ok, but NPCs looked trash (spoiler: they still do).”  
> - u/nospoon99, [Reddit](https://www.reddit.com/r/aigamedev/comments/1vixpx2/the_gauntlet_loop_with_a_reference_image/), 2026-08-08.

> “A swing and a miss. That camera is awful. Controller and animations look bad. Planar reflections look broken. Style is boring. Lighting is blown out. Mesh geometry is strange.”  
> - u/East_Garbage_1449 on *Claude Bandicoot*, [Reddit](https://www.reddit.com/r/ClaudeAI/comments/1v9m76g/claude_bandicoot_shumers_gauntlet_loop_on_a_3d/), 2026-07-29.

The OP replied that it was a progress share, not AAA, stopped after 15 hours, and was unfinished. That exchange is important: the prompt’s declared acceptance criterion and the human’s actual publication criterion diverged.

### 5.11 When it can underperform a single strong pass

Evidence-backed conditions:

1. **Small/average task:** The Prompt Index says avoid a loop when one careful human pass is cheaper than building and reviewing it. ([guide](https://www.thepromptindex.com/ai-loop-engineering-gauntlet-loop-guide.html#when-not-to-use-a-loop), 2026-07-29.)
2. **Coupled artifact:** original repo evidence favors sequential coherent ownership over six-way parallel directory fan-out. ([README](https://github.com/mshumer/Claude-of-Duty#process-note), 2026-07-25.)
3. **Wrong or unobservable target:** Kubica’s polished but unusable workshop and RoboNuggets’ hallucinated comparisons. ([Kubica](https://tomaskubica.cz/en/2026/evals-nejcennejsi-aktivum/), 2026-07-31; [RoboNuggets](https://github.com/robonuggets/gauntlet-loop#what-breaks-it), 2026-08-05.)
4. **Deterministic logical task:** tests/solvers are cheaper and more reliable than visual critics. ([GTA Reddit discussion](https://www.reddit.com/r/ClaudeAI/comments/1ve7u9r/gta_6_first_attempt_far_from_perfect_but_its/), 2026-08-03.)
5. **Irreversible/high-stakes operation:** broad autonomy is inappropriate when mistakes are costly, sensitive data is exposed, or actual outcomes cannot be observed. ([Prompt Index](https://www.thepromptindex.com/ai-loop-engineering-gauntlet-loop-guide.html#when-not-to-use-a-loop), 2026-07-29.)
6. **Strong detailed prompt alternative:** Decrypt reports Leon Lin obtained a good-looking playable result using a detailed ~20-section prompt, plain Opus 5 high effort, no subagents, and no ultracode. No blind A/B was run, so this is suggestive, not a controlled victory. ([Decrypt](https://decrypt.co/374560/dumbest-ai-prompt-claude-beat-careful-game-design), 2026-07-28.)

### 5.12 Requested community searches

- **Reddit r/ClaudeAI:** FOUND multiple practitioner threads cited above.
- **Reddit r/LocalLLaMA:** **NOT FOUND** a relevant indexed post/comment. Searched `site:reddit.com/r/LocalLLaMA "Gauntlet Loop"` and `"Claude of Duty"` on 2026-08-14.
- **Reddit r/PromptEngineering:** **NOT FOUND** a relevant indexed post/comment. Searched exact technique and demo names on 2026-08-14.
- **Hacker News:** **NOT FOUND** a relevant indexed submission/comment. Searched `site:news.ycombinator.com "Gauntlet Loop"` and `"Claude of Duty"` on 2026-08-14.
- **Lobsters:** **NOT FOUND** a relevant indexed story/comment. Searched `site:lobste.rs` with both terms on 2026-08-14.
- **Blog rebuttals:** FOUND the Kubica case study, Our Nation Online caveats, Prompt Index safeguards, and Decrypt prior-art/contamination caveat.

## 6. PRACTICAL PARAMETERS

### 6.1 Counts, rounds, time, and cost reported

| Run/source | Builder/critic or agent count | Rounds/waves | Time | Cost/usage | Stop condition/result | Source/date |
|---|---:|---:|---:|---:|---|---|
| *Claude of Duty* | “massive fleet”; 11 critics in assessment; one experiment used 6 parallel agents × 3 rounds | score rounds 3.59, 4.14, 4.05, 5.05 | “many hours” | not disclosed | Shumer manually stopped while improving; never beat reference | [guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27; [repo](https://github.com/mshumer/Claude-of-Duty), 2026-07-25 |
| *Operation Blackout* | not reported | not reported | little over 10h | ~1.3M tokens | playable; no reported blind test | [Decrypt](https://decrypt.co/374560/dumbest-ai-prompt-claude-beat-careful-game-design), 2026-07-28 |
| *Claude Bandicoot* | not reported | 3 five-hour windows; manual cleanup | ~15h window total | Max 5x; OP guessed each window ~10% weekly | user happy/stopped; unfinished | [Reddit](https://www.reddit.com/r/ClaudeAI/comments/1v9m76g/claude_bandicoot_shumers_gauntlet_loop_on_a_3d/), 2026-07-29 |
| GTA-like prototype | 86 agents | “several additional loops and workflows” after first failed | 22h | automated summary says ~$1,700 API-equivalent; lower-confidence | still rough; work continued | [Reddit](https://www.reddit.com/r/ClaudeAI/comments/1ve7u9r/gta_6_first_attempt_far_from_perfect_but_its/), 2026-08-03 |
| Reference-image town | multiple, exact count not reported | 10 waves; first 6 unsteered | each five-hour window used in a couple hours; 1-2 waves/window | each window ~10% weekly Max 5 allowance | human steered from wave 7; showcased at wave 10 | [Reddit](https://www.reddit.com/r/aigamedev/comments/1vixpx2/the_gauntlet_loop_with_a_reference_image/), 2026-08-08 |
| 3D roguelite | “as many as it wants”; exact count not reported | 3 prompts × ~8h, fourth trailer session | 24h build | 40% Max 20x weekly; ~$1,800 API-equivalent | human playtest between prompts | [Reddit](https://www.reddit.com/r/aigamedev/comments/1vjv3z8/i_left_claude_code_running_for_24h_it_built_a_3d/), 2026-08-09 |
| Microsoft Foundry workshop | several role critics | not reported | not reported | $70 | discarded; optimized wrong dimensions | [Kubica](https://tomaskubica.cz/en/2026/evals-nejcennejsi-aktivum/), 2026-07-31 |
| Arcade MCP toolkits | user agent + rewrite agent + regression agent + different-model final reviewer | until rough edges converge | ~10h overnight | not reported | convergence + locked scenarios + final review | [Arcade](https://www.arcade.dev/blog/gauntlet-agents-build-mcp-servers/), July 2026 |
| Rodrigo Vieira FPS visual loop | fresh critic per iteration | viewmodels: 6 rounds | not reported | not reported | minimum scores; 16/16 validations | [LinkedIn](https://br.linkedin.com/in/rodrigovieira92/pt), Rodrigo Vieira, page crawled late July 2026; exact post date **NOT FOUND** |

Rodrigo’s reported numbers: viewmodels `3/10 → 7/10` in six rounds; HUD `7.3/10`; audio `7.2/10`; all maps over `7.0`; release passed 16/16 validations. He also says the critic missed an inverted weapon because orientation was absent from the criteria. ([LinkedIn profile/post text](https://br.linkedin.com/in/rodrigovieira92/pt), accessed 2026-08-14; exact publication date not exposed.)

### 6.2 Builder/critic sizing

The original method specifies a builder and separate critic **per important piece**, but no fixed global count. ([X naming post](https://x.com/mattshumer_/status/2081830214384886228), 2026-07-27.) Shumer’s guide explicitly avoids prescribing decomposition/count. ([guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27.)

Evidence suggests three sizing rules:

1. Parallelize independent artifact parts only; keep coupled systems with coherent ownership. ([original repo process note](https://github.com/mshumer/Claude-of-Duty#process-note), 2026-07-25.)
2. Give each critic fresh context and no builder history. ([Shumer guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27.)
3. On constrained plans, cap fan-out and forbid recursive spawning; a practitioner recommends 2-3 max and two on Pro after a 30-agent runaway. ([Reddit limits thread](https://www.reddit.com/r/ClaudeAI/comments/1vi86sc/how_to_handle_claude_running_out_of_session/), 2026-08-08.)

### 6.3 Round policy and convergence

- **Original author:** no arbitrary final round. Stop when satisfied, marginal changes are too small, or compute budget is reached. ([Shumer guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27.)
- **RoboNuggets:** output wins blind A/B or user stops; never fixed N. ([README](https://github.com/robonuggets/gauntlet-loop#how-it-works), 2026-08-05.)
- **Prompt Index:** success, plateau, budget, repeated failure without new strategy, risk, or human-judgment escalation; its writing template allows at most five critic rounds per chapter. ([guide](https://www.thepromptindex.com/ai-loop-engineering-gauntlet-loop-guide.html), 2026-07-29.)
- **Our Nation Online:** set time/token/max-round boundary in advance. ([article](https://ournationonline.com/gauntlet-loop-claude-builder-critic-prompt-explained/), 2026-08-10.)
- **Observed runs:** humans commonly stop far short of the stated external bar because the result is showcaseable or the subscription window is spent.

### 6.4 Choosing a domain bar

| Domain | Bar supported by sources | Required evidence |
|---|---|---|
| Game / 3D / visual | screenshots or footage from a named shipped title | same views/conditions; blind image A/B; gameplay/logic instrumentation separately |
| Website / UI | named live site/campaign at same desktop/mobile viewport | screenshots plus accessibility, interaction, responsive, and performance tests |
| Writing | specific published pieces demonstrating the intended reader outcome | blind/byline-stripped comprehension or clarity choice; fact/outline/continuity checks |
| Backend/code | named implementation plus test/benchmark, or explicit latency/recovery/security target | executable tests, static analysis, performance, failure injection, independent spec review |
| Research | named analyst report or paper methods section | trace every claim to opened sources; coverage/rigor comparison; no invented citations |
| Marketing | named comparable campaign plus measurable funnel target | creative comparison plus conversion/CAC/brand/legal guardrails |
| Education | approved learning objective plus real hands-on task | learner performance and real system interaction, not only presentation polish |

Sources: [Shumer guide](https://somethingbig.ai/gauntlet-loop), 2026-07-27; [RoboNuggets SKILL.md](https://github.com/robonuggets/gauntlet-loop/blob/main/.claude/skills/gauntlet-loop/SKILL.md), 2026-08-05; [Prompt Index](https://www.thepromptindex.com/ai-loop-engineering-gauntlet-loop-guide.html), 2026-07-29; [Kubica](https://tomaskubica.cz/en/2026/evals-nejcennejsi-aktivum/), 2026-07-31.

### 6.5 Minimum practical control set synthesized from evidence

This is a synthesis, not a verbatim Shumer prescription:

1. One explicit objective with immutable invariants.
2. A named, retrievable, comparable external reference and objective measures where possible.
3. Lead-agent decomposition reviewed for coupling.
4. Builder/critic separation; critic sees artifact, not builder story.
5. Blind binary comparison when a real blind A/B can be constructed.
6. Single largest gap returned each round.
7. Regression gates protecting previously passing behavior.
8. Durable state outside chat: current target, completed parts, evidence, failed approaches, next step, budget.
9. Fan-out ceiling and no recursive spawning unless explicitly budgeted.
10. Success, plateau, repeated-failure, time, token/money, permission, risk, and human-escalation stops.
11. One integrated whole-artifact review after local loops.
12. Human final judgment; “critic passed” is evidence, not authority.

## 7. SOURCE LIST

Dates below are publication/post/commit dates when retrievable; “accessed” means no reliable publication date was exposed.

### Primary / author-controlled

1. **Matt Shumer, “Claude Opus 5 one-shotted this game”** - X, 2026-07-25. <https://x.com/mattshumer_/status/2081054356405731740>
2. **Matt Shumer, “Prompt:”** - X, 2026-07-25. <https://x.com/mattshumer_/status/2081100592689324502>
3. **Matt Shumer, “I’m officially calling this the Gauntlet Loop”** - X, 2026-07-27. <https://x.com/mattshumer_/status/2081830214384886228>
4. **Matt Shumer, guide announcement** - X, 2026-07-27. <https://x.com/mattshumer_/status/2081857631254372509>
5. **Matt Shumer, “How to Run a Gauntlet Loop”** - Something Big, 2026-07-27. <https://somethingbig.ai/gauntlet-loop>
6. **Matt Shumer, `mshumer/Claude-of-Duty`** - GitHub, initial commit 2026-07-25. <https://github.com/mshumer/Claude-of-Duty>
7. **Matt Shumer, `prompt.md` blob** - GitHub, 2026-07-25. <https://github.com/mshumer/Claude-of-Duty/blob/main/prompt.md>
8. **Matt Shumer, raw `prompt.md`** - GitHub raw, 2026-07-25. <https://raw.githubusercontent.com/mshumer/Claude-of-Duty/main/prompt.md>
9. **Matt Shumer, `README.md` / honest assessment and process note** - GitHub, 2026-07-25. <https://github.com/mshumer/Claude-of-Duty/blob/main/README.md>

### Requested reimplementations / explanatory articles

10. **RoboNuggets (Jay E), `robonuggets/gauntlet-loop`** - GitHub, 2026-08-05. <https://github.com/robonuggets/gauntlet-loop>
11. **RoboNuggets, raw `README.md`** - GitHub raw, 2026-08-05. <https://raw.githubusercontent.com/robonuggets/gauntlet-loop/main/README.md>
12. **RoboNuggets, raw `.claude/skills/gauntlet-loop/SKILL.md`** - GitHub raw, 2026-08-05. <https://raw.githubusercontent.com/robonuggets/gauntlet-loop/main/.claude/skills/gauntlet-loop/SKILL.md>
13. **The Prompt Index, “AI Loop Engineering in 2026: How to Build a Gauntlet Loop”** - 2026-07-29. <https://www.thepromptindex.com/ai-loop-engineering-gauntlet-loop-guide.html>
14. **José Antonio Lanz; ed. Guillermo Jimenez, “The Dumbest-Looking AI Prompt Just Beat Months of Careful Game-Design Prompt Engineering”** - Decrypt, 2026-07-28. <https://decrypt.co/374560/dumbest-ai-prompt-claude-beat-careful-game-design>
15. **Chethan, “The Gauntlet Loop: The Builder-vs-Critic Prompt Behind Claude’s Viral Game Demo”** - Our Nation Online, 2026-08-10. <https://ournationonline.com/gauntlet-loop-claude-builder-critic-prompt-explained/>
16. **Tomas Kubica, “Your company’s most valuable asset in the AI world is the definition of what good looks like”** - 2026-07-31. <https://tomaskubica.cz/en/2026/evals-nejcennejsi-aktivum/>
17. **Arcade, “We Built 10 MCP Servers in a Weekend With Agents”** - July 2026. <https://www.arcade.dev/blog/gauntlet-agents-build-mcp-servers/>
18. **Chris Graves, `cgraves09/gauntlet`** - GitHub, accessed 2026-08-14. <https://github.com/cgraves09/gauntlet>

### Practitioner/community evidence

19. **u/BoneShaman, “Claude Bandicoot - Shumer’s Gauntlet Loop on a 3d Platformer”** - r/ClaudeAI, 2026-07-29. <https://www.reddit.com/r/ClaudeAI/comments/1v9m76g/claude_bandicoot_shumers_gauntlet_loop_on_a_3d/>
20. **u/ThePromptIndex, “The ‘Gauntlet Loop’: give AI a clear goal…” plus critical comments** - r/ChatGPTPromptGenius, 2026-07-29/30. <https://www.reddit.com/r/ChatGPTPromptGenius/comments/1va6vh6/the_gauntlet_loop_give_ai_a_clear_goal_a_harsh/>
21. **u/smith2008, “GTA 6 first attempt…”** - r/ClaudeAI, 2026-08-03. <https://www.reddit.com/r/ClaudeAI/comments/1ve7u9r/gta_6_first_attempt_far_from_perfect_but_its/>
22. **u/Ronar123 and commenters, “How to handle claude running out of session limits interrupting tasks?”** - r/ClaudeAI, 2026-08-07/08. <https://www.reddit.com/r/ClaudeAI/comments/1vi86sc/how_to_handle_claude_running_out_of_session/>
23. **u/nospoon99, “The Gauntlet Loop with a reference image”** - r/aigamedev, 2026-08-08. <https://www.reddit.com/r/aigamedev/comments/1vixpx2/the_gauntlet_loop_with_a_reference_image/>
24. **u/victorrseloy2, “I left Claude Code running for 24h…”** - r/aigamedev, 2026-08-09. <https://www.reddit.com/r/aigamedev/comments/1vjv3z8/i_left_claude_code_running_for_24h_it_built_a_3d/>
25. **r/singularity discussion, “Someone made a NMS style exploration game in a day with Opus 5”** - 2026-07-28. <https://www.reddit.com/r/singularity/comments/1v8lj7w/someone_made_a_nms_style_exploration_game_in_a/>
26. **Rodrigo Vieira, LinkedIn post text on CS BRASIL loop** - exact post URL/date not exposed; profile source accessed 2026-08-14. <https://br.linkedin.com/in/rodrigovieira92/pt>

### Mirrors used when X pages exposed no body text

27. **Matt Shumer profile mirror** - TwStalker, captured late July 2026; used for the horror-novel post and surrounding chronology. <https://site.twstalker.com/mattshumer_>
28. **Siqi Chen profile mirror** - TwStalker, captured late July 2026; used for frontend-loop testimony. <https://mobile.twstalker.com/blader>

### Retrieval gaps explicitly retained

- Additional Shumer gist/doc: **NOT FOUND**.
- Finished horror-novel output and assessment: **NOT FOUND**.
- Named completed marketing-campaign use: **NOT FOUND**.
- Controlled critic-builder collusion study for this method: **NOT FOUND**.
- Relevant Hacker News, Lobsters, r/LocalLLaMA, and r/PromptEngineering discussions: **NOT FOUND** under exact-name/demo searches as of 2026-08-14.
- Exact X status URL/date for Siqi Chen’s frontend post: **NOT FOUND**; only a profile mirror was retrievable.
- Exact standalone post URL/date for Rodrigo Vieira’s figures: **NOT FOUND**; LinkedIn profile/search extraction exposed the text but not a stable post permalink.
