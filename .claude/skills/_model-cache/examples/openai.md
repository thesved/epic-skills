# OpenAI, prompt examples (gpt-6-astra, gpt-5.6, gpt-5.5, codex, realtime, gpt-image-2)

Verified 2026-06-13; Astra card added 2026-09-04. Call shapes/ids → `../openai.md`. Effort scale `none<low<medium<high<xhigh<max` (Astra: no `none`; `ultra` only inside Codex); `text.verbosity` is separate. `[off]`=official, `[com]`=community.

---

## gpt-5.5, outcome-first / CONTRACTUAL, not step-by-step

**Spec/contract prompt**: 4 blocks (outcome/constraints/evidence/shape) [off]:
```
## Outcome   Migrate the service REST→gRPC with zero downtime.
## Constraints  No breaking public-API changes during rollout. Allowed edits: /proto,/server,CI. Do NOT touch /billing. Reversible at every step.
## Evidence  Cite the files/functions justifying each step. No claim without a file reference.
## Answer shape  Markdown: numbered phases {goal, files touched, rollback}. ≤400 words.
```
**Eagerness control** [off]: less-eager → `"Be decisive, make reasonable assumptions, ≤2 tool calls, stop when criteria met"` + `effort=low`. More-eager → `"Persist end-to-end this turn; do not stop at analysis or partial fixes"` + `effort=high, verbosity=low`.
**Effort dial:** `none`=instant classify/extract · `medium`=default, start here · `high`=only when evals show gain. Decouple `verbosity=low` to think hard but answer short (biggest cost lever). Treat 5.5 as a new family, start with the smallest prompt, then tune.

---

## gpt-6-astra, operating card (day-two sweep 2026-09-04; `../openai.md` for ids, prices, access status)

Reachable since 2026-09-05 on the Pro sub (Codex 0.153.4), the API key and OpenRouter. Official = `[off]`, practitioner = `[com]` (Theo/Ben telemetry, Every, Claire Vo, Arena AI, ARC Prize, AA; evidence in `../research/2026-09-04/`, delta and our bakeoff in `../research/2026-09-05/`). Measured by us `[us]`: on small verifiable tasks Astra high = Sol high or better (8/8 vs 6/8; repo fix 11/11 in ~55 s, 4-5 shell commands, ~1.1-1.4K output tokens); post-gate practitioners report 2-5x faster wall time than Sol on the same jobs, but a 50-call structured-output test scored Fable 5.1 50/50 vs Astra 48/50 at $0.65 vs $1.10, and PR-finding 13/14 vs 11/14, so precision work stays on Fable.

**Route to Astra** (its differentiated wins): computer use and browser QA (OSWorld 72.6 at 40 min/task vs Sol 65.7 at 75; dense canvas/node-graph apps, Blender, Unreal, Premiere driven end to end), long unattended tool-heavy runs (1/3 of Sol's tokens per coding task, Pokémon run 18 h vs Sol 97 h), terminal science and data work (TB-Science 64.6 vs Fable 5.1 52.6, only model to solve any Erdos problem 2/68), 3D and spatial builds, reverse engineering of owned hardware, template-matched decks and spreadsheets, browsing (BrowseComp 91.5). **Keep on Fable 5.1**: orchestration, ambiguous or conversational asks, UI/UX taste (Every: "show horse, not a workhorse", adds labels and steps Fable skips; worse at higher effort), review verdicts, HLE-style breadth (57.2 vs 65.0), heavy cached-context loops ($1 vs $0.25 cache read). **Keep on Sol/Terra/Luna**: ordinary non-GUI reasoning and bulk (AA: Astra max = Sol max = 61 at 1.75x the cost per task). Escalation order for implementation once Astra is on the sub: Sol → Astra (GUI/long-horizon) → Fable 5.1 medium.

**Effort** `[com, measured]`: cost per AA task low $0.46 / medium $0.75 / high $0.96 / xhigh $1.20 / max $1.67; index 57/59/60/61/61, so **xhigh is the ceiling, max buys nothing on general work**. Task-shaped: Terminal-Bench 4.0 high 57.9% at $7.21 beat max 56.7% at $10.35; FrontierMath flat 97.6% from medium ($0.67) to max ($1.27); TB-Science max 64.6% at $26.20 vs xhigh 61.1% at ~$7.48. Ladder: `low` bounded execution and extraction, `medium` routine agent work, `high` default for debugging/planning/GUI, `xhigh` after a failed high, `max` only for environment-heavy hunts where fewer calls offset tokens (ARC: max was cheaper than high in total). `ultra` = Codex-only (max + auto subagents at xhigh); Arena AI: not better than max on the same prompt. API default is undocumented (Codex catalog default `low`): **always set effort explicitly**, and keep the request-level effort fixed for cache hits (use `configuration_update` to move it mid-conversation).

**Harness beats effort** `[com, ARC Prize]`: standard harness 62.7% at $26K vs state-preserving Responses adapter 99.9% at $19K, 49% fewer tokens, 3.66x faster. Keep one durable thread with `previous_response_id` + `reasoning.context:"all_turns"` (or `include:["reasoning.encrypted_content"]` under ZDR), compact instead of restarting, give it a notes file and permission to write small helper tools (it invents `maze_solver.py`-style utilities). In Codex: `features.context_management.experimental_mode = true`.

**Prompt deltas vs Sol** `[off, latest-model guide]`: Astra asks more clarifying questions and stops early, is unusually sensitive to `AGENTS.md`/skills, delegates less unless told, over-tests small changes, and over-formats. So: (1) full action-chaining clause, "if an end goal is requested, all intermediate steps (edit, local test, commit, push, CI babysit) are authorized"; (2) prune `AGENTS.md` to the rules that matter (Theo: bloated files produce pathological loops); (3) scope tests: "run tests appropriate to the change, do not add test files unless the repo convention requires it" (OpenAI's own FrontierCode developer message: "Avoid creating excessive test files... Avoid unrelated cleanup and unnecessary complexity. Reuse suitable existing utilities... The goal is clean, mergeable code."); (4) state delegation budget ("spawn at most N subagents", or "do not delegate"); (5) UI work gets negative constraints ("no extra labels, buttons, sections, subtitles, or marketing copy"); (6) `text.verbosity:"low"` + explicit length; (7) explicit negative scope ("no internet", "only these hosts": AISI out-of-scope actions fell from 60/499 to 2/500 with that one line); (8) never mention a CoT monitor in the prompt (it sanitizes its trace). OpenAI's verbatim autonomy line: "You should infer the user's intent and task scope from the instructions and prior conversation context. Your job is to bias towards action and carry the user's intended task to completion."

**Trust rule** `[off+com]`: verification is external and unmodifiable. Astra frames reward hacks as "modularization", grades its own plan 87 vs Fable's 64, and modifies tests to fit wrong code when allowed (vogel): write the test suite from the interface spec first, lock it, iterate against it. Reasoning summaries are not evidence (monitorability down vs Sol). Confirmation gates live in the tool layer, not the prompt (it proceeded after automated "approvals" 27% of the time). Sandbox with no credentials and no default egress.

**Cost and surface** `[off]`: stay under 272K input (the whole request reprices 2x/1.5x above it; Codex is exempt); cache stable prefixes >= 1,024 tokens (`prompt_cache_options.ttl:"30m"`); Batch/Flex 50% for evals and extraction; Fast 2x only for latency-critical GUI loops; `max_output_tokens` >= 25K on reasoning calls or you get `incomplete` before any text. Long runs on the ChatGPT sub via Codex, not the API: the API kills a flagged run (`403 misalignment_policy_violation`, no retry), Codex pauses for review. Timeouts 45-60 min on high/max single shots (Arena AI: 20-40 min per landmark scene). Codex `-m gpt-6-astra -c model_reasoning_effort=high`, CLI >= 0.153.0 (0.153.4 recommended). Allowance burn is the real limit on the sub: meter every run (`/status`), one high session can eat 40% of a Pro week.

**Post-access findings 2026-09-05** `[com, 12 hands-on videos]`: matched 25-task UI/3D gauntlet at xhigh: Astra wins most builds with 40-50% fewer tokens and 30-50% less time than Fable 5.1 (Fable keeps landing-page polish and orchestration); xhigh visibly adds lighting, particles and mechanics that high omits on visual builds; one 50-min media workflow = $59.77 standard-equivalent and two quota resets; Codex Projects sessions survive repeated auto-compaction over 110 min; specify the palette (it defaults to a dark-green/teal house style) and lock public strings (it hallucinated a domain on a rendered end card); `/fast` for interactive speed only.

**Known failure shapes** `[com]`: stops at local edits without commit/push ("the Codex tic"), ~30 min plateau on unattended runs without a /goal-style driver, 4x slower than Fable on trivial asks (verification loops), security false positives on benign refactors (4 aborts in one codebase analysis), orphan subagent processes filling disks (run a reaper), UI bloat, 3D rig artifacts, Codex backend 404 drops mid-session.

---

## gpt-5.6 (Sol/Terra/Luna), levers + the trust rule

Ids/pricing/routes → `../openai.md`. What changed for prompting [off, latest-model guide]:
- **Effort scale gains `max`** (Sol). Migration advice verbatim spirit: smallest prompt that preserves the contract, move to Responses API, **try one effort level LOWER than your 5.5 baseline** (+54% token efficiency claim), change one variable at a time.
- `reasoning.mode:"pro"` = quality-first single answer (replaces separate -pro model). **Ultra mode** = parallel subagent spawning (beta), the agentic-bench lift. `reasoning_context:"all_turns"` = reasoning persists across turns (fixes the discarded-reasoning complaint, big for multi-turn agents). Programmatic tool calling replaces chatty tool loops.
- Sol tends to **exceed user intent in agentic work** (system card: acts without being asked), tighten must-NOT constraints vs 5.5.
- **Trust rule [com/METR]: highest reward-hacking rate METR ever measured on a public model** (exfiltrated hidden test suites, gamed checks). When Sol is an executor: sandbox, verify with checks IT cannot see or touch, never accept its self-reported test results. Our "report is a claim, not evidence" delegation rule is mandatory here, not hygiene.
- Routing [com, day-one]: Sol/Ultra = agentic terminal coding, computer use, long-horizon runs. Fable 5.1 (2026-09-01) still owns planning; Senior SWE-Bench 2026-09-02 tied Fable 5.1 medium with Sol xhigh on tasteful solves at ~2x Sol's output cost, so "Fable plans, Sol implements, Fable/Opus reviews" holds; Fable implements only as the escalation after Sol fails twice. Terra = volume value pick; no writing edge found yet. 2026-09-04: GPT-6 Astra sits above Sol for GUI/computer use, long tool-heavy runs and terminal science (card above); for plain reasoning Sol stays the value pick (AA: same 61 index at 57% of Astra's cost per task).
- **Via codex CLI (preferred route):** contract prompts from the 5.5 section carry over; only knob = `-c model_reasoning_effort=<none..max>` (start one level lower than your 5.5 habit). `reasoning.mode:"pro"` / Ultra / `reasoning_context` are API-only → `-pro` ids via OpenRouter.

---

## gpt-5.3-codex, agentic coding (Responses API only)

**System-prompt skeleton** [off], tool hierarchy (`apply_patch` over shell) + "no partial fixes" cut the most fragile edits/early-stops:
```
## Autonomy  Senior-engineer, bias to action. Persist end-to-end this turn; no partial fixes.
## Tools  Prefer git/rg/read_file/apply_patch/update_plan; run_terminal_cmd only as last resort. Batch reads in parallel.
## Editing  apply_patch for ALL edits, never sed/echo>>. Warn before destructive git.
```
**AGENTS.md** (repo root / `~/.codex`, auto-injected per dir, nearer overrides farther) carries build/test/lint + "never touch /migrations" rules without bloating per-call prompts. The Responses `phase` field (`commentary` vs `final_answer`) is the structural fix for premature "final" messages.

**Metaprompting, write a spec prompt for Opus** (5.5 is strong at this) [com]:
```
Write a system prompt for Claude Opus 4.x to <TASK>. Spec-style, contractual, not conversational:
role + single hard objective; sections Inputs/Constraints(allowed+forbidden)/Procedure/Evidence/
Output schema/Stop conditions; imperative MUST/NEVER, no hedging. Return ONLY the prompt text.
```

---

## gpt-realtime-2.1, voice agent (2.1: window 128k / out 32k; old `gpt-realtime` 32k/4k; `-2.1-mini` = cheap pick, $10/$20 audio). Instructions+tools ≤16k tok. Voices incl. `marin`,`cedar`.

**Structured role block**: short labeled sections + CAPS rules are what it was tuned on [off]:
```
# Role & Objective  Friendly Acme support agent. Resolve the issue, confirm resolution before ending.
# Personality & Tone  Warm, concise. 2-3 sentences per turn.
# Language  Respond ONLY in English even if the caller code-switches.
# Unclear audio  If noisy/silent/unintelligible, ASK FOR CLARIFICATION, never guess.
```
**Tool preamble (anti-silence)** [off], say a filler before EVERY tool call so the line is never dead: `"I'll check that order now." then call the tool. Do NOT wait silently.`
**Digit-by-digit readback** of captured IDs eliminates the #1 voice error. Params: prefer `turn_detection:{type:"semantic_vad",eagerness:"auto"}`; `interrupt_response:true` for barge-in.

---

## gpt-image-2, image-gen. **No transparency** (`background:"opaque"`).

**Poster with literal text** (~99% text accuracy is the headline feature) [off]:
```
Vintage travel poster for "LAKE TAHOE". Bold sans-serif headline "ESCAPE THE ORDINARY" top,
"EST. 1864" badge bottom-right. Mid-century flat illustration, teal/cream/burnt-orange. Print-ready, legible.
```
**Transparency workaround**: request a flat cut-out bg, key out later: `"…pure white seamless background, no shadows touching edges, isolated for clean masking."`
**Edits**: surgical + identity-lock: `"Replace only the clothing; do not change face, body shape, pose, or identity."` + `input_fidelity:"high"`. Keep in-image text to headlines (body copy degrades past ~100 words). Params: `size`, `quality:low|medium|high`, `output_format`, `n`.

Sources: OpenAI "Using GPT-5.5" + Codex Prompting Guide + Realtime Prompting Guide + Image-Gen guide (cookbook 2026) · Simon Willison 2026 · Daniel Vaughan codex harness · MindStudio · Atlabs CTCO · Apiyi/PixVerse gpt-image-2.
