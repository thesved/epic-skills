# Gauntlet Loops: Zero to Hero

Research date 2026-08-14. Sources: full evidence trail in `evidence-dossier.md` (codex web leg, primary sources + community) and `youtube-findings.md` (5 practitioner videos via gemini). Every claim here traces to a dated source in those files unless marked SYNTHESIS (our conclusion from combining evidence).

## How to use this document

Read top to bottom once if new to the technique. Returning users: jump to "The framework" for the anatomy, "Templates" to copy, "Inversion" before any expensive run. The companion SKILL.md operationalizes this guide; this document is the WHY behind every rule there.

**TL;DR thesis:** A gauntlet loop replaces "make it good" with "beat a named real-world thing in a blind test, or keep going." The loop is scaffolding. Five things carry all the value: a real inspectable bar, builders that never grade themselves, critics that see only the artifact, an evidence channel that exposes every axis that matters, and stop bounds you set before launch. Runs are token furnaces ($70 to $1,800 per run documented), so route work into one only when the path to the goal is genuinely unknown and the outcome is worth exploring.

## Background from zero

### What it is

A gauntlet loop is an agent orchestration pattern named by Matt Shumer on 2026-07-27, two days after his "Claude of Duty" demo went viral (a browser FPS built by Claude Opus 5 from a 3-paragraph prompt, custom code, no external assets). Mechanism in one line, from his naming post: "The agent (not you!!) breaks the goal into parts, gives each part a specialist builder and a ruthless blind critic sub-agent, with a mandate to only pass if the generated artifact is better than some real-world equivalent."

It descends from known patterns (generator-critic, evaluator-optimizer, orchestrator-workers) but adds two twists that matter:

- **The bar is a real, fetchable artifact** (actual Call of Duty screenshots), not a rubric or a vibe.
- **The comparison is blind A/B**: labels stripped, critic picks one, no scores.

### What it is NOT

- Not "one prompt, done": Shumer's run took many hours, a fleet of agents, and manual stopping. "One prompt" counts user interactions, not model calls.
- Not a method that beats its bar: Claude of Duty NEVER passed. Eleven critics scored rounds 3.59 → 4.14 → 4.05 → 5.05 out of 10; every blind A/B chose the real game (Shumer's own repo, "Honest assessment", 2026-07-25). The unreachable bar supplied direction, not victory.
- Not self-critique: a model critiquing its own output in the same conversation inflates scores while quality stays flat. The fresh-context separation IS the technique. A chat-UI roleplay replication (Crash Bandicoot clone, 2026-08-09) shipped broken camera math and physics despite days of "harsh critic" language.
- Not a substitute for knowing what you want: the loop closes the gap to the reference you gave it. It cannot pick the right reference for you (Kubica's $70 workshop, below).

### The origin prompt, decoded

Verbatim (mshumer/Claude-of-Duty prompt.md, 2026-07-25):

```
I want you to build a first-person shooter at the level of the most recent
Call of Duty games. It should be utterly perfect, visually beautiful, with
every single thing done at AAA quality-from textures to physics to anything
you could think of.

Fan out sub-agents and have sub-agents tackle each one individually so that
the game is utterly perfect. You should /loop on each item and have a
separate sub-agent check it visually to ensure it looks triple A. That
separate sub-agent should be a really harsh critic, and if it doesn't look
triple A, it should keep going.

Don't stop until each sub-agent is utterly wowed with the quality when
compared with the actual Call of Duty game. It should literally compare them
side by side blind and say which one looks better. Do this in ThreeJS.
/loop until it's utterly perfect. Fan out sub-agents and ultracode.
```

Why each move works (and one that fails):

| Phrase | What it does |
|---|---|
| "at the level of the most recent Call of Duty games" | Names a real bar. The single highest-leverage line. |
| "Fan out sub-agents... tackle each one individually" | Delegates decomposition to the agent. Parts follow the artifact, not a human checklist. |
| "separate sub-agent... really harsh critic" | Role separation. Builder never grades itself. |
| "compare them side by side blind and say which one looks better" | Blind binary A/B. No drifting scores, no self-praise. |
| "Do this in ThreeJS" | The ONLY implementation constraint. Everything else is the agent's judgment. |
| "/loop until it's utterly perfect" | The failure. "Utterly perfect" never terminates by definition; the run needed a manual kill. |

## The framework: 7 components

SYNTHESIS of Shumer's guide (somethingbig.ai/gauntlet-loop, 2026-07-27), the RoboNuggets skill (2026-08-05), Prompt Index guide (2026-07-29), and every documented run.

1. **Goal, not route.** State the outcome and the bar. Do not prescribe architecture, file layout, decomposition, or round counts. Every extra instruction removes a decision the model makes better mid-work.
2. **The bar** (the whole trick, own section below).
3. **Decomposition by the lead agent**, into the smallest pieces improvable AND judgeable on their own, with a coupling check (below).
4. **Builders**, one per important piece. Parallel only where genuinely independent.
5. **Blind critics**, fresh context, one per piece: gets goal + bar + artifact, never the builder's history or explanations. Inspects reality (pixels, running product, test output, finished prose), never a summary. Verdict is binary A/B with labels stripped, plus the SINGLE largest remaining gap sent back to the builder. One gap, not a list: diffuse feedback diffuses the next round.
6. **The loop**: rejected work goes back with the named gap. After each major wave, an integration/smoothing pass by a fresh agent checks cross-piece consistency (separately optimized pieces drift apart).
7. **Stop bounds** (Shumer's version lacks them; every documented run needed a human kill; own section below).

### Why builder/critic separation is load-bearing

The builder remembers its compromises and can argue why the work is reasonable. A fresh critic acts like an A/B tester. Devsplainers (2026-08-07) shows the contrast case: single-model self-grading gave itself "A+" while objective quality stayed flat across most iterations. Our board skill has the same evidence from another angle: two different-architecture reviewers on one diff returned DISJOINT critical bugs; either alone ships the other's bug (2026-07-12).

## The bar is the whole trick

Everything else is scaffolding. Four tests, all must pass (first three from RoboNuggets, fourth is SYNTHESIS from the F1 evidence):

1. **Named.** A specific thing, not a category. "Stripe's pricing page" works; "award-winning SaaS sites" does not.
2. **Fetchable.** The critic can screenshot it, read it, run it, open it. If it cannot obtain the reference, it invents the comparison and approves everything. Most common failure by far.
3. **Comparable.** Both can sit side by side and a judge picks one. Cannot imagine the A/B? Not a bar.
4. **Reachable-hard.** Prefer the hardest bar the agent can genuinely approach. Too easy: loop exits round one. Genuinely unreachable: fine ONLY if you know it (an aspirational compass like Call of Duty keeps improvement pointed), but then the exit is plateau or budget, never "win." The F1 run's model itself predicted a 70s plateau against a 90 target; nobody had encoded that as a stop.

Plus: **taste plus a number.** If a measurable half exists (FPS, load time, test pass rate, word count, latency), name it next to the reference. Taste alone lets the critic wander; a number alone gets Goodharted.

### Sourcing the bar

Learn-from-the-best rule (deep-research): pick who actually wins on the SPECIFIC dimension in question, not who is loudest. Booking prints money; Airbnb is loudest. If unsure, make bar selection part of the task: have the model propose 2-3 candidate bars with a criterion, you pick.

Bars by domain (Shumer + RoboNuggets + Kubica, merged):

| Domain | Bar | Evidence the critic needs |
|---|---|---|
| Game / 3D / visual | screenshots or footage of a named shipped title | same camera/viewpoint captures, blind image A/B, PLUS gameplay/logic instrumentation |
| Website / UI | named live site at the same viewport | screenshots desktop+mobile, plus perf/accessibility/interaction checks |
| Writing | specific published pieces by a named author | byline-stripped comprehension pick, plus fact/continuity checks |
| Code / tooling | named repo + its test suite or benchmark | executable tests, latency, failure injection |
| Research | named analyst report or paper's methods section | claim-to-source trace, coverage comparison, no invented citations |
| Education / workshop | approved objective + real hands-on task | learner actually performs the task on the real system (Kubica's missing axis) |

## The gate-completeness law

**What is not in the critic's gate does not get fixed. It rots while everything else shines.** This is the best-documented failure class:

- F1 replication (2026-08-03): five "harsh art director" critics. Beautiful shadows, sparks, reflections. Cars clipped through barriers, no finish or podium logic. Gameplay was never in the gate.
- Firecrawl racer (2026-08-07): working game, terrible FPS. Performance was not a judging criterion until added mid-run.
- Kubica workshop (2026-07-31): $70, polished, correct, pedagogically structured Microsoft Foundry workshop. "There was no Azure in it." Reviewers measured topic, structure, design, pedagogy. Never "does the learner touch a real Azure resource," the entire point.
- Rodrigo Vieira FPS loop (July 2026): critic passed an inverted weapon model because orientation was absent from the criteria.

The test before launch (SYNTHESIS): **name three ways the artifact could be polished and still be broken or useless. If the gate would pass any of them, add the missing axis.** This is fable-max's Goodhart check applied per-critic.

## The evidence channel

The critic can only optimize what its tools expose. Weak channel, weak loop:

- Screenshots are weak for temporal behavior and logic. GTA replication (2026-08-03): video-frames-to-critic failed; structured JSON game state worked "far better."
- Deterministic logic wants a solver or test, not a vision model arguing about pixels (puzzle solvability, win conditions).
- Same-conditions capture or the A/B is meaningless: same camera position, same viewport, same lighting conditions as the reference (Firecrawl's prompt bakes this in).
- The harness is buildable: the F1 run authored its own 136-tool headless-Chromium/Playwright rig (deterministic screenshots, state extraction, pixel diffs) before critics could work. Budget for "build the measurement rig" as a first-class piece.
- Our typeform live-testing lesson generalizes: static validation passes while the live artifact is broken; walk the real thing. And never infer "it worked" from a plausible side effect; check actual state.

## Critic integrity (beyond fresh context)

Fresh context is necessary, not sufficient. Two instances of the same model share blind spots ("correlated models masquerading as independent review," the sharpest community rebuttal, r/ChatGPTPromptGenius 2026-07-30).

- **Binary A/B, never scores.** Scores drift upward every round (RoboNuggets); score-based runs still regressed between rounds (4.14 → 4.05).
- **Cross-family seats for verdicts that gate shipping.** Board evidence: different architectures catch disjoint defects. One critic-family per lens is fine for cheap rounds; the FINAL pass gets plural independent seats.
- **Calibrate the judge before trusting it** (autoresearch): give the critic the reference against itself once; anything but "tie" means the judge is broken (AA test). Binary low-precision judgments beat fine-grained scales; multi-judge ensembles measurably outperform single judges.
- **Guard the known judge exploits** (autoresearch): verbosity bias, sycophancy, position bias, format gaming. Randomize A/B position every round.
- **The critic can be WRONG, and the loop amplifies it.** Claude of Duty: three rounds of critics called the weapon "untextured"; the obedient fixes made the real defect worse. The fix came from an agent that contradicted the brief and measured the lighting. Give builders standing permission to challenge a diagnosis with a measurement.

## Decomposition and the coupling check

Parallel fan-out is not free quality. Shumer's own controlled comparison (repo process note, 2026-07-25): three rounds of six directory-owning parallel agents moved the score +0.46 while major defects went 60 → 47 → 66. ONE sequential pass with coherent ownership: +1.00, defects 66 → 26. Cause: tonemapping, sky, and indirect light are coupled; isolated agents broke each other's assumptions.

Rule: parallelize only pieces that are genuinely independent; give coupled subsystems one owner and run them sequentially. And cap the fleet: a job scoped to 8 subagents spawned 30+ because recursive spawning was not forbidden, burning a 5-hour window in 15 minutes (r/ClaudeAI, 2026-08-08). Always: explicit fan-out ceiling, no recursive spawning.

## Stop bounds (where we override the original)

Shumer and RoboNuggets both say "never a fixed round count; exit is winning or the user stopping." Half right. No ARBITRARY round count, yes. But every documented run ended by human kill or exhausted subscription window, never by the loop's own judgment, and "the critic can always discover another dimension on which the reference wins... the loop therefore renews its own mandate" (community rebuttal, 2026-07-30). "Utterly perfect" never stops by definition.

Every gauntlet ships with all three exits (SYNTHESIS, aligned with fable-max /goal law: stop bound mandatory):

1. **Win**: the critic picks ours blind (or the measurable target is hit).
2. **Plateau**: K consecutive rounds (default 3) where the blind verdict does not flip and the measurable half does not improve. On plateau: stop and report, or change strategy, never same-strategy retry (autoresearch: repeated unchanged strategy is a named failure mode).
3. **Budget**: token/dollar/hour ceiling named before launch. Real runs for calibration: 19h/$1,226 (F1), 34h/412M tokens (racer), ~$1,800 API-equivalent per 24h session (roguelite), 3 x 5h Opus windows (Bandicoot).

Also protect the floor while chasing the ceiling: **regression gates.** Previously passing behavior gets locked scenarios that every later round must still pass (Arcade's MCP-factory loop; Prompt Index). Rounds regress: 4.14 → 4.05 happened.

## Durable state (loops die of amnesia)

Each iteration carries the history of previous ones; context compounds until the session dies, and "continue" forces lossy, token-heavy reconstruction (r/ClaudeAI, 2026-08-07). The fix, verbatim from the practitioner: "have the agent maintain a state file it updates as it goes... when the limit hits, you restart with 'read state.md, resume from step X'."

State file per run (SYNTHESIS + Prompt Index): current target + bar, frozen piece list, per-piece status and verdict history, evidence pointers, failed approaches (so they are not retried), next action, budget remaining. Freeze the piece list like exhaustive-decipher freezes a manifest: a piece silently vanishing from the loop is how coverage lies. A live progress page (Shumer's workbench.md pattern) lets the human watch without interrupting momentum.

For runs over ~1 hour: a **sentinel** (fable-max): a separate cheap watchdog reads the state file + artifacts every 15-30 min and answers one question: did measurable progress happen? Two stalls in a row: alert or restart. It verifies artifacts, never the loop's self-reported status.

## When to gauntlet (and when not)

The pre-gauntlet ladder (Mansel Scheffel, 2026-08-07, plus Prompt Index "when not to loop"):

1. **Prompt.** One careful pass is cheaper for small or average tasks.
2. **Skill / known path.** The domain has an established pattern (standard web dev, CRUD): use it. Empirical failure case: free-range gauntlet on a normal real-estate site burned 3.1M tokens over 6 hours and shipped an unusable result.
3. **Repair loop.** A builder iterating against a known-good test suite. Right for deterministic targets.
4. **Gauntlet.** Only under **valuable route uncertainty**: the path is genuinely unknown AND worth exploring: novel experiences where taste is the product (games, 3D, distinctive design), open architecture questions, adversarial research synthesis.

Never gauntlet: irreversible or high-stakes actions (deploys, spending, outbound messages), sensitive data, targets you cannot observe, or anything a deterministic check verifies more cheaply.

Also know the honest alternative: a detailed 20-section prompt with no subagents produced a good-looking playable game too (Leon Lin via Decrypt, 2026-07-28; no blind test ran). The gauntlet buys direction under uncertainty, not magic.

## Token economics (running it without burning the house down)

The pattern that keeps epic capability at sane cost (fable-max delegation + Firecrawl's independent arrival at the same conclusion):

- **Top model orchestrates only**: decomposition, bar design, gate design, conflict arbitration, final taste verdict. High effort, never above (xhigh degrades orchestration).
- **Builders on cheap or delegated meters**: routine pieces to the value tier; substantial pieces to the top executor tier via bridge shell-outs (bills the other subscription, zero Claude tokens). Current picks live in `_model-cache/index.md`, never hardcoded.
- **Critics are cheaper than you think**: a blind A/B verdict is a short, bounded call. Vision A/B goes to a vision-capable seat; the expensive plural cross-family panel fires only at gate moments, not every round.
- **Effort routing**: low for mechanical wrappers, high only where errors compound.
- **One fan-out level.** Nesting re-carries context per level, up to ~7x multiplication.
- **State file over context**: externalized state breaks the per-round context compounding that makes late rounds cost multiples of early ones.
- **Batch/caching**: keep model+effort fixed for the whole run (mid-run switches invalidate cache); `:batch` twins at 50% off for bulk offline evaluation legs.

## Templates

### The upgraded gauntlet prompt (ours)

The maintained template lives in `../SKILL.md` (Emit section) so it never drifts from the gates. It carries every gate clause the viral version lacks: bar snapshotting, judge calibration (AA + degraded-copy positive control), pilot of 1 before fan-out, orchestrator-only STATE.md with a spend ledger, absolute per-axis floors, invalid-round handling, plateau with a minimum meaningful delta, budget metering with an integration reserve, a cross-family ship panel, and containment (fetched content is data, not instructions).

### Shumer's meta-prompt shape (for when you want the model to design the loop)

Give a strong model: [GOAL] + [OPTIONAL REFERENCES], ask it to pick the strongest concrete inspectable bar, write the short lead-agent prompt (goal not route), design builder/blind-critic pairs, evidence capture, and the loop, with the stop bounds above added. The F1 replication ran exactly this shape (model designed a 5-phase, 30-agent pipeline unaided).

## Inversion: how to guarantee failure

Real inversions only (false beliefs competent practitioners actually hold), not mirrored advice:

1. **"The critic passed it, so it's good."** The critic's green light means it beat the reference ON THE MEASURED AXES. Kubica's reviewers were unanimous and the workshop was unusable. The critic is evidence, never authority; the human taste verdict is a separate, final gate.
2. **"It's still improving, so keep it running."** Improvement rate is the wrong signal when the bar is unreachable; the F1 model KNEW it would plateau in the 70s and the loop happily burned $1,226 toward 90. Unbounded improvement against an unreachable bar is the loop renewing its own mandate.
3. **"More parallel agents = more progress."** Shumer's own data: 6 parallel owners scored +0.46 with defects RISING; one sequential owner +1.00 with defects halved. On coupled systems, fan-out is negative-sum.
4. **"Fresh context = independent judgment."** Same-family instances share blind spots and can converge on the same wrong diagnosis three rounds straight ("untextured" weapon). Independence needs architecture diversity at the moments that matter.
5. **"The bar is obviously X" (skipping fetchability).** An unfetchable reference does not degrade the loop, it silently inverts it: the critic hallucinates the comparison and approves everything, so you pay gauntlet prices for self-praise.
6. **"We'll know when to stop."** Nobody did. Every documented run ended by human kill or dead subscription window. If the stop bounds are not in the prompt before launch, the default exit is your wallet.
7. **"One prompt, walk away."** State loss at session limits, 30-agent runaways, and stalled phases are documented defaults, not edge cases. No state file + no sentinel = a dead run you discover hours later.

## Common mistakes, quick table

| Do | Don't |
|---|---|
| Named, fetchable, comparable, reachable-hard bar | Category bars, adjective bars ("AAA quality" with no artifact) |
| Binary blind A/B, positions randomized | Scores out of 10 (drift up, still regress) |
| Gate covers function + feel + perf + the actual want | Visual-only critics on interactive artifacts |
| One largest gap back to the builder | A 15-item critique list every round |
| Piece list frozen in a state file | Pieces silently dropped mid-run |
| Win / plateau / budget, all three, in the prompt | "/loop until utterly perfect" as the only exit |
| Top model orchestrates, cheap/delegated meters execute | Max effort on the top model for every builder |
| Sentinel + regression scenarios on long runs | Trusting the loop's own status reports |

## Prioritization: what actually matters

1. **The bar** (named/fetchable/comparable/reachable-hard + a number). 80% of outcomes. A perfect loop with a vague bar is a self-praise machine.
2. **Gate completeness.** The second-best loop with a missing axis ships polished garbage.
3. **Evidence channel.** The critic optimizes what its tools expose, nothing else.
4. **Stop bounds.** Decides whether you spend $70 or $1,800 to learn the same lesson.
5. **Critic integrity extras** (cross-family, AA test, randomization). Cheap insurance, fires at gate moments.
6. **Economics routing.** Turns "impressive demo" into "repeatable tool."

The single most important thing: if you cannot name the real-world artifact your output must beat AND how the critic will hold both side by side, you are not ready to start the loop. Fix that first; everything else is scaffolding.
