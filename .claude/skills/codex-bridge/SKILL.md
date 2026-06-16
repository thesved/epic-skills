---
name: codex-bridge
description: >-
  Use OpenAI Codex CLI for what it does better than Claude: writing prompts FOR
  Claude (especially Opus - Codex produces more rigorous, spec-like, less
  conversational prompts), generating images via gpt-image, and a structurally
  different "200 IQ autistic developer" second opinion. Triggers: "write a
  prompt", "improve this prompt", "prompt for opus", "prompt engineering", "ask
  codex", "codex image", "generate image via openai", "different model take",
  "what would codex say". Proactively suggest when the user is about to spawn an
  Agent/subagent with a hand-written prompt - Codex can sharpen it first.
argument-hint: prompt <goal> | improve <existing-prompt> | image <description> | ask <question> | smoke | update-models
---

# Codex Prompt - let Codex write prompts for Opus

Core insight: **Opus is not the best model for writing prompts Opus will execute.** Codex/GPT-5.5 writes more rigorous, spec-like, less conversational prompts. When about to spawn an Agent with a non-trivial briefing, run it through Codex first. Also the entry point for OpenAI-side capabilities Claude lacks: **image gen** (`gpt-image-2`) and a different-architecture **second opinion**.

**Model ids, pricing, call shapes, gotchas live in the cache - read before use:** `~/.claude/skills/_model-cache/openai.md`. For **how to prompt gpt-5.5/codex/realtime/gpt-image well** (spec/contract prompts, eagerness + reasoning_effort, AGENTS.md, voice-agent instructions, metaprompting for Opus) → `~/.claude/skills/_model-cache/examples/openai.md`. Don't hardcode ids; they drift and most `-codex`/`-pro` ids 400 on ChatGPT login.

## The one rule that breaks everything
Pass the prompt via **stdin**, never a positional arg (positional hangs on "Reading additional input from stdin…"). On ChatGPT-account login use **`-m gpt-5.5`** (the only reliable id; cache explains why). `--skip-git-repo-check` outside a repo.

## Modes

### `prompt` - write a prompt from scratch (esp. for an Agent/Opus call)
```bash
cat <<'EOF' | codex exec -m gpt-5.5 --skip-git-repo-check
Write a prompt for <target model> to do: <one-paragraph goal>.
CONTEXT IT WILL HAVE: <repo state, files, tools>.
CONSTRAINTS (numbered, hard): 1) … 2) …
DELIVERABLE: <exact output format>.
Prompt requirements: self-contained; specifies exact output format; lists what NOT to do; under <N> words; no filler.
Output ONLY the prompt. No preamble, no fences.
EOF
```
Review the output, then pass to `Agent(prompt: …)`. If it's not clearly better than yours, use yours - don't ceremoniously prefer Codex.

### `improve` - refine an existing prompt
Same invocation; paste the original between `---` markers and ask Codex to name weaknesses (vague goal, missing constraints, ambiguous output, filler) then output the improved prompt only. For critique-only: say "Just critique. Don't rewrite."

### `image` - generate via OpenAI (`gpt-image-2`)
Built-in `image_gen` tool, works on ChatGPT-login OAuth. **Read the IMAGE section of the cache** for the call shape + the hardcoded `~/.codex/generated_images/…` save path (you must `cp` the file out - telling it "save to /tmp" doesn't work). Use as the fallback when Gemini OAuth-only 404s, or for gpt-image's text/anatomy rendering. Good prompts: subject, style, composition, lighting, negative space, "avoid: text/logos/people".

### `ask` - second opinion / argue against my plan
```bash
cat <<'EOF' | codex exec -m gpt-5.5 --skip-git-repo-check
I am about to <action>. Reasoning: <reasoning>.
Argue against this. Find what I'm missing. Be specific and technical. Do not validate, do not soften.
EOF
```
Reasoning effort: add `-c model_reasoning_effort=high`. Don't dump verbatim - quote the 1-3 sharpest points and say what you'll do with them. Scripted/board one-shot (stdin + banner-strip handled): `bash ~/.claude/skills/codex-bridge/ask.sh <file|stdin>`.

### API-key extras (beyond the OAuth CLI)
With `OPENAI_API_KEY` set (in `~/.zshrc`), the full API opens up - details + verified call shapes in `~/.claude/skills/_model-cache/openai.md`:
- **Codex agentic models** (`gpt-5.3-codex` latest, `gpt-5.2-codex`, …) → **Responses API** (`/v1/responses`), NOT chat/completions. There is **no** `gpt-5.5-codex`.
- **Realtime audio** (`gpt-realtime`, GA) → `python3 ~/.claude/skills/_model-cache/realtime_openai.py gpt-realtime <out.wav> "<text>"` (verified).
- **OpenRouter** (`~/.claude/skills/_model-cache/openrouter.md`) = generic text fallback across providers when a route throttles.

### `smoke` / `verify` - is it actually working?
- `bash ~/.claude/skills/codex-bridge/smoke.sh` → pings `gpt-5.5` via stdin (`CODEX_MODEL=<id>` to override).
- `bash ~/.claude/skills/_model-cache/verify.sh` → E2E PASS/FAIL across all providers (incl. openai text/codex/realtime).

### `update-models` - refresh the cache
`bash ~/.claude/skills/_model-cache/update.sh openai` (needs `OPENAI_API_KEY`; on ChatGPT-login it's research-only - verify the id via `codex exec --help`), then web-research flagged models and edit `_model-cache/openai.md`.

## When to use / not
Use for: consequential Agent calls (planning, risky-code review, decisions), a vague hand-written prompt, batches of parallel agents needing consistent briefings, image-gen, adversarial second opinions. Skip for: trivial Agent calls, prompts already short and good.

## Failure modes
- **400 "not supported"** → wrong model id (an `-codex`/`-pro`/older id on ChatGPT login). Use `gpt-5.5`; if that 400s, run `update-models`.
- **Hang on "Reading additional input from stdin…"** → you used a positional arg. Pipe via stdin.
- **Output has fences/preamble despite instructions** → strip before using.
- **Image not where you asked** → it's in `~/.codex/generated_images/…`; `cp` it.

## See also
- `/gemini-bridge` - Gemini CLI; image gen, non-English copy, video, TTS
- `/board` - multi-model panel (Opus + Gemini + Codex)
- `/think` - escalate to Opus when the need is harder thinking, not a different model
