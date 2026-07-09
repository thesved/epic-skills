---
name: board
description: >-
  Convene a "board of directors" - query Fable 5, Gemini, Codex, Grok (latest
  xAI via OpenRouter), and an OpenRouter Fusion seat (GLM-5.2 + DeepSeek panel)
  in parallel on the same question, then synthesize the cross-model perspective.
  Use for irreversible decisions, open-problem exploration from multiple angles,
  or when one model's answer feels insufficient. Each model brings a different
  architecture and training distribution, so the disagreements are signal.
  Triggers: "board", "board of directors", "panel", "consult the panel",
  "multiple models", "cross-model", "second third and fourth opinion", "what
  does everyone think", "explore from multiple angles", "I'm stuck on this
  decision", "open-ended exploration", "ask grok", "what would grok say".
  Proactively suggest for: architectural decisions you'll live with for years,
  hiring/strategy questions, pre-launch sanity checks, "I want to be really
  sure about this". Also smoke-tests the panel CLIs on "board smoke", "board
  test", "is the board working".
argument-hint: '<question for the board> | smoke (check all seats)'
---

# Board - multi-model panel

Run one question through **Fable 5 + Gemini + Codex + Grok + an OpenRouter Fusion seat in parallel**, then synthesize. Agreement = higher confidence; disagreement = the signal worth investigating. This skill is the *orchestrator* - it does **not** re-document how to drive each model. For seat-specific call shapes, gotchas, and auth, the seats own their docs: **`/gemini-bridge`** (Gemini seat), **`/codex-bridge`** (Codex seat), and **`/openrouter-bridge`** (Grok + Fusion seats); model ids/pricing live in `~/.claude/skills/_model-cache/`.

The **4th seat is Grok** (`ask.sh --grok`, xAI via OpenRouter; self-healing chain grok-4.5 → US-proxy retry → grok-4.3, see `/openrouter-bridge`): a fourth independent frontier family (xAI) with a training distribution none of the other seats share. The **5th seat is OpenRouter Fusion** (`openrouter/fusion`): a panel of `z-ai/glm-5.2` + `deepseek/deepseek-v4-pro` (judge GLM-5.2) deliberates and returns one synthesized answer. It deliberately uses **non-OpenAI/Anthropic/Google/xAI families** - architecture diversity the other four seats don't cover - so its agreement/dissent is independent signal. Swap models with `OPENROUTER_FUSION_PANEL` / `OPENROUTER_FUSION_JUDGE` (see `/openrouter-bridge`). Fusion costs ≈4-5× a single call; drop it when budget matters more than breadth.

**Use when**: irreversible decision (architecture, vendor, schema, hiring); genuine exploration wanting angles one model misses; you've already escalated to Opus via `/think` and want a different family's sanity check; the user asks for the panel.
**Don't** when: there's a single checkable answer; you haven't tried it yourself; budget matters more than confidence (≈8× one call with Fusion, ≈4× without).

## Smoke test
`/board smoke` (or first board of a session - CLIs drift): `bash ~/.claude/skills/board/smoke.sh`. It delegates to each seat's own `smoke.sh` (Gemini = cheapest lite via paid key, throttle-proof; Codex = `gpt-5.5` via stdin; OpenRouter = cheap single-model ping, NOT fusion) and notes Fable as always-in-session. Report the seat table it prints. If a seat is DOWN, run the board with the rest and note it.

## Step 1 - Draft ONE briefing
Same self-contained prompt to every seat (assume no shared context):
```
QUESTION: <one sentence - the decision/exploration>
CONTEXT: <facts, constraints, what's ruled out>
LEANING TOWARD (+why): <your current view, if any>
WHAT I WANT: 1) your recommendation (X/Y/Z or a new option) 2) strongest reason FOR
3) strongest reason AGAINST 4) what would change your mind
Be concrete. No filler. Under 300 words.
```
"What would change your mind" is critical - it surfaces each model's hidden assumptions, where the disagreements live.

## Step 2 - Fire all seats in ONE message (parallel)
Write the briefing to a file ONCE (e.g. `/tmp/board_brief.md`), then point all seats at it. Issuing the Agent call + the Bash calls in a single assistant message runs them concurrently (the host executes independent tool calls in parallel). Run smoke first if you haven't this session, so you don't block on a dead seat.
```
Agent(subagent_type:"general-purpose", model:"fable", description:"Fable seat: <topic>", prompt:"<briefing - or: read /tmp/board_brief.md>")
Bash: bash ~/.claude/skills/gemini-bridge/ask.sh /tmp/board_brief.md
Bash: bash ~/.claude/skills/codex-bridge/ask.sh /tmp/board_brief.md
Bash: bash ~/.claude/skills/openrouter-bridge/ask.sh --grok /tmp/board_brief.md
Bash: bash ~/.claude/skills/openrouter-bridge/ask.sh --fusion /tmp/board_brief.md
```
- The seat helpers (`gemini-bridge/ask.sh`, `codex-bridge/ask.sh`) source `_model-cache/lib.sh` for the key (keychain-safe) and use a self-updating model alias - **no key or model id is hardcoded in this skill**, and they handle the Codex stdin/banner quirks. Because they resolve the key the same way `smoke` does, **smoke passing now predicts the board working** (an inline `?key=$GEMINI_API_KEY` would silently fail in the keychain-only setup). They take the briefing as a file arg or on stdin.
- **Richer agentic Gemini seat** (opt-in): `agy --model "Gemini 3.5 Flash (High)" -p "$(cat /tmp/board_brief.md)" </dev/null`. OAuth (can throttle/hang). The `</dev/null` is **mandatory** - agy blocks forever on an open stdin pipe - and the model string must match `agy models` exactly. Use only when you want agy's agentic seat and can tolerate OAuth limits; the key seat above answers in seconds otherwise.

## Step 3 - Synthesize
Map each seat → recommendation / strongest reason / strongest objection / would-change-mind. Then:
- **Unanimous** → high confidence; recommend.
- **2-1 split** → report majority AND quote the dissenter (often right).
- **All disagree** → the question is genuinely hard; surface all three, ask the user which constraint matters most. Don't fake a recommendation.
- **Agreement for different reasons** → they may be solving different framings; consider re-briefing.

## Step 4 - Present crisply (don't dump raw responses)
```
PANEL: Fable: <rec> - <why> | Gemini: <rec> - <why> | Codex: <rec> - <why> | Grok: <rec> - <why> | Fusion: <rec> - <why>
AGREE: <consensus>   DISAGREE: <key tension>
MY REC: <one option>, because <synthesis>.   KEY RISK: <dissent in one line>.
YOUR CALL.
```
The board informs; the user decides.

## Resilience - always return something
Each seat is independent; a seat erroring is normal. Drop a failed Bash seat and continue. Codex 400 → it's the model id (see `/codex-bridge`), retry once then drop. Gemini key errors (credits) → fall back to agy or drop. Grok seat erroring → likely the model id rotated (check `x-ai/*` in the live `/models` list, override `OPENROUTER_GROK_MODEL`), retry once then drop. Fusion seat slow/erroring (it fans out N+1 calls) → drop it or fall back to a plain OpenRouter model (`bash ~/.claude/skills/openrouter-bridge/ask.sh /tmp/board_brief.md`). **Fable (Agent tool) is always available**, so the board never returns empty. If `model:"fable"` is rejected (Fable pulled again), fall back to `model:"opus"`. Always note dropped seats in the output.

## Guardrails
One board per major decision per session unless asked. ~30-90s wall-clock. If the panel unanimously contradicts what the user wanted, **surface that gap explicitly** and let the user resolve it - don't quietly side with either.

## See also
- `/gemini-bridge`, `/codex-bridge`, `/openrouter-bridge` - the individual seats (and where their gotchas live)
- `/think` - more Opus reasoning, not more model variety
- `/grill-me` - interview the *user*, not the models
