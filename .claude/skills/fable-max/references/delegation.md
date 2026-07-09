# Delegation: Fable orchestrates, other models execute

Fable plans, judges, and reviews; everything token-hungry or mechanical runs on someone else's meter. Two wins at once: subscription/price arbitrage (codex bills the OpenAI sub, Sonnet/Haiku at 1/5-1/20 Fable rate, Gemini/OpenRouter on their own keys) AND a leaner orchestrator context (reports come back, floods don't). Community-measured savings 46-74%; on long autonomous runs 10x+.

The bridges already own the HOW - do not re-document call shapes here:
- **codex-bridge** `implement` / `review` / `computer-use`: GPT-5.5 execution shell-outs (verified flags, prompt rules, report-file pattern)
- **gemini-bridge**: video, multimodal, 1M-context dumps, non-English
- **openrouter-bridge / board**: cross-family opinions, cheap text fallback
This file adds only what the bridges don't: WHO gets WHAT, the wrapper pattern for fan-outs, and the gates.

## Routing rubric

Planning quality is Fable's moat; execution is near-parity across frontier coders. Pay Fable rates only where errors compound.

- **Fable (writes no bulk code):** decomposition, architecture, non-obvious debugging, conflict arbitration, plan + final review, /goal ownership, and AUTHORING every delegated prompt.
- **GPT-5.5 (codex-bridge):** clear-spec implementation, migrations, tests, data analysis, log reading, runtime/computer-use verification loops. Taste ~5/10: nothing user-facing without review.
- **Opus 4.8:** independent review seat; deep-reasoning subagent when Fable is overkill. Security-flavored review goes HERE, never back through Fable (refusal-downgrade risk, see prompting.md).
- **Sonnet 5:** wrapper agents, mid-taste work. **Haiku:** read-only scouting.
- Computer-use note: Claude is the stronger GUI driver; delegating it is a cost move (screenshot loops are token furnaces), not a quality move. Quality-critical GUI verification stays on Claude.

Tie-break for anything that ships: intelligence > taste > cost. Cheaper output below the bar → redo with a smarter model without asking; escalating costs less than shipping mediocre work.

## Gates (all three, before any delegation)

1. **Size gate:** under ~15 min of work, do it in-session. Delegation overhead (briefing + verification + handoff risk) eats the savings on small jobs.
2. **Spec gate:** if Fable cannot write the task self-contained (goal, acceptance criteria, must-not-touch, verify commands), the task still needs thinking, not typing. Keep it.
3. **Taste gate:** user-facing UI/copy/API design needs taste >= 7 → Opus/Fable, or executor draft + mandatory taste review.

## Wrapper pattern (non-Claude executors inside Agent/Workflow fan-outs)

Agent/Workflow `model:` only accepts Claude models. To fan out GPT-5.5 workers:
- **Fable authors the complete self-contained codex prompt** and embeds it in the wrapper's briefing. The wrapper is plumbing, not a prompt-writer: `model: sonnet`, low effort, its entire job = write the given prompt to a file, run the codex-bridge shell-out via Bash, return the report (`schema` on the wrapper for structure).
- Label wrappers `gpt-5.5-*` (`label: 'gpt-5.5-review-auth'`) - the UI shows the wrapper's Claude model; the label is the only trace of the real worker.
- Parallel implementation wrappers need `isolation: "worktree"` or codex edits collide.
- Workflow `budget.spent()` counts only Claude tokens; executor work is invisible there. Never read budget burn as work done; track Codex weekly-limit % separately.

## CLAUDE.md rubric block (paste-adapt; re-score cost to YOUR subscription mix)

```markdown
## Picking the right models for workflows and subagents
Rankings, higher = better. Cost reflects what I actually pay. Intelligence =
how hard a problem the model takes unsupervised. Taste = UI/UX, code quality,
API design, copy.
| model | cost | intelligence | taste |
|---|---|---|---|
| gpt-5.5 (codex CLI) | 9 | 8 | 5 |
| sonnet-5 | 5 | 5 | 7 |
| opus-4.8 | 4 | 7 | 9 |
| fable-5 | 2 | 9 | 9 |
- Defaults, not limits: standing permission to redo below-bar output with a
  smarter model without asking. Judge the output, not the price tag.
- Cost is a tie-breaker only; for anything that ships, intelligence > taste > cost.
- Bulk/mechanical (clear-spec implementation, migrations, data analysis): gpt-5.5
  via the codex-bridge skill (codex exec / codex review). Never via MCP.
- User-facing (UI, copy, API design) needs taste >= 7.
- Reviews: fable-5 or opus-4.8, optionally gpt-5.5 as an extra independent seat.
```

## Failure rules (each one cost someone a session or real money)

1. Orchestrator effort caps at HIGH; xhigh/max degrades orchestration (overthinking, loops).
2. A subagent's security/vulnerability report returning to Fable can trigger the silent Opus downgrade. Route security review to Opus; scrub exploit language from returning reports.
3. Wrapper reporting success is not evidence: check `git status`/`git diff` yourself.
4. Wrappers cannot spawn wrappers (one-level depth); recursive delegation designs silently never execute.
5. When planning is trivial (bulk fan-out of identical mechanical tasks), skip Fable entirely - all-Sonnet beats Fable-plus-fleet there. The premium buys nothing without hard decisions.
