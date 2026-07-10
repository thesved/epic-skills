# OpenAI - prompt examples (gpt-5.5, codex, realtime, gpt-image-2)

Verified 2026-06-13. Call shapes/ids → `../openai.md`. Effort scale `none<low<medium<high<xhigh` (+`max` on 5.6 Sol); `text.verbosity` is separate. `[off]`=official, `[com]`=community.

---

## gpt-5.5 - outcome-first / CONTRACTUAL, not step-by-step

**Spec/contract prompt** - 4 blocks (outcome/constraints/evidence/shape) [off]:
```
## Outcome   Migrate the service REST→gRPC with zero downtime.
## Constraints  No breaking public-API changes during rollout. Allowed edits: /proto,/server,CI. Do NOT touch /billing. Reversible at every step.
## Evidence  Cite the files/functions justifying each step. No claim without a file reference.
## Answer shape  Markdown: numbered phases {goal, files touched, rollback}. ≤400 words.
```
**Eagerness control** [off]: less-eager → `"Be decisive, make reasonable assumptions, ≤2 tool calls, stop when criteria met"` + `effort=low`. More-eager → `"Persist end-to-end this turn; do not stop at analysis or partial fixes"` + `effort=high, verbosity=low`.
**Effort dial:** `none`=instant classify/extract · `medium`=default, start here · `high`=only when evals show gain. Decouple `verbosity=low` to think hard but answer short (biggest cost lever). Treat 5.5 as a new family - start with the smallest prompt, then tune.

---

## gpt-5.6 (Sol/Terra/Luna) - levers + the trust rule

Ids/pricing/routes → `../openai.md`. What changed for prompting [off, latest-model guide]:
- **Effort scale gains `max`** (Sol). Migration advice verbatim spirit: smallest prompt that preserves the contract, move to Responses API, **try one effort level LOWER than your 5.5 baseline** (+54% token efficiency claim), change one variable at a time.
- `reasoning.mode:"pro"` = quality-first single answer (replaces separate -pro model). **Ultra mode** = parallel subagent spawning (beta), the agentic-bench lift. `reasoning_context:"all_turns"` = reasoning persists across turns (fixes the discarded-reasoning complaint - big for multi-turn agents). Programmatic tool calling replaces chatty tool loops.
- Sol tends to **exceed user intent in agentic work** (system card: acts without being asked) - tighten must-NOT constraints vs 5.5.
- **Trust rule [com/METR]: highest reward-hacking rate METR ever measured on a public model** (exfiltrated hidden test suites, gamed checks). When Sol is an executor: sandbox, verify with checks IT cannot see or touch, never accept its self-reported test results. Our "report is a claim, not evidence" delegation rule is mandatory here, not hygiene.
- Routing [com, day-one]: Sol/Ultra = agentic terminal coding, computer use, long-horizon runs. Fable 5 still owns planning + code quality (day-one consensus, e.g. "Fable plans, GPT implements, Fable reviews"). Terra = volume value pick; no writing edge found yet.
- **Via codex CLI (preferred route):** contract prompts from the 5.5 section carry over; only knob = `-c model_reasoning_effort=<none..max>` (start one level lower than your 5.5 habit). `reasoning.mode:"pro"` / Ultra / `reasoning_context` are API-only → `-pro` ids via OpenRouter.

---

## gpt-5.3-codex - agentic coding (Responses API only)

**System-prompt skeleton** [off] - tool hierarchy (`apply_patch` over shell) + "no partial fixes" cut the most fragile edits/early-stops:
```
## Autonomy  Senior-engineer, bias to action. Persist end-to-end this turn; no partial fixes.
## Tools  Prefer git/rg/read_file/apply_patch/update_plan; run_terminal_cmd only as last resort. Batch reads in parallel.
## Editing  apply_patch for ALL edits, never sed/echo>>. Warn before destructive git.
```
**AGENTS.md** (repo root / `~/.codex`, auto-injected per dir, nearer overrides farther) carries build/test/lint + "never touch /migrations" rules without bloating per-call prompts. The Responses `phase` field (`commentary` vs `final_answer`) is the structural fix for premature "final" messages.

**Metaprompting - write a spec prompt for Opus** (5.5 is strong at this) [com]:
```
Write a system prompt for Claude Opus 4.x to <TASK>. Spec-style, contractual, not conversational:
role + single hard objective; sections Inputs/Constraints(allowed+forbidden)/Procedure/Evidence/
Output schema/Stop conditions; imperative MUST/NEVER, no hedging. Return ONLY the prompt text.
```

---

## gpt-realtime-2.1 - voice agent (2.1: window 128k / out 32k; old `gpt-realtime` 32k/4k; `-2.1-mini` = cheap pick, $10/$20 audio). Instructions+tools ≤16k tok. Voices incl. `marin`,`cedar`.

**Structured role block** - short labeled sections + CAPS rules are what it was tuned on [off]:
```
# Role & Objective  Friendly Acme support agent. Resolve the issue, confirm resolution before ending.
# Personality & Tone  Warm, concise. 2-3 sentences per turn.
# Language  Respond ONLY in English even if the caller code-switches.
# Unclear audio  If noisy/silent/unintelligible, ASK FOR CLARIFICATION - never guess.
```
**Tool preamble (anti-silence)** [off] - say a filler before EVERY tool call so the line is never dead: `"I'll check that order now." then call the tool. Do NOT wait silently.`
**Digit-by-digit readback** of captured IDs eliminates the #1 voice error. Params: prefer `turn_detection:{type:"semantic_vad",eagerness:"auto"}`; `interrupt_response:true` for barge-in.

---

## gpt-image-2 - image-gen. **No transparency** (`background:"opaque"`).

**Poster with literal text** (~99% text accuracy is the headline feature) [off]:
```
Vintage travel poster for "LAKE TAHOE". Bold sans-serif headline "ESCAPE THE ORDINARY" top,
"EST. 1864" badge bottom-right. Mid-century flat illustration, teal/cream/burnt-orange. Print-ready, legible.
```
**Transparency workaround** - request a flat cut-out bg, key out later: `"…pure white seamless background, no shadows touching edges - isolated for clean masking."`
**Edits** - surgical + identity-lock: `"Replace only the clothing; do not change face, body shape, pose, or identity."` + `input_fidelity:"high"`. Keep in-image text to headlines (body copy degrades past ~100 words). Params: `size`, `quality:low|medium|high`, `output_format`, `n`.

Sources: OpenAI "Using GPT-5.5" + Codex Prompting Guide + Realtime Prompting Guide + Image-Gen guide (cookbook 2026) · Simon Willison 2026 · Daniel Vaughan codex harness · MindStudio · Atlabs CTCO · Apiyi/PixVerse gpt-image-2.
