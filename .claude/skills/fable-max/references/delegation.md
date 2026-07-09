# Delegation: the orchestrator plans, other models execute

The top model plans, judges, reviews, and authors every delegated prompt; everything token-hungry or mechanical runs on someone else's meter. Two wins at once: subscription/price arbitrage AND a leaner orchestrator context (reports come back, floods don't). Community-measured savings 46-74%; on long autonomous runs 10x+.

**Who is currently best at what lives in `~/.claude/skills/_model-cache/index.md` → "Delegation roles" table** (refreshed with every model update). This file carries only the logic that does not drift. The bridges own the call shapes:
- **codex-bridge** `implement` / `review` / `computer-use`: OpenAI-executor shell-outs
- **gemini-bridge**: video, multimodal, long-context dumps, non-English
- **openrouter-bridge / board**: cross-family opinions, cheap text fallback

## Routing logic (timeless; names come from the cache table)

Planning quality is the top model's moat; execution is near-parity across frontier coders. Pay top-model rates only where errors compound: decomposition, architecture, non-obvious debugging, conflict arbitration, plan + final review, /goal ownership, authoring delegated prompts.

- Tie-break for anything that ships: **intelligence > taste > cost**. Cost is a tie-breaker only.
- Cheaper output below the bar → redo with a smarter model without asking; escalating costs less than shipping mediocre work.
- User-facing work (UI, copy, API design) needs a high-taste model or a mandatory taste review of the executor's draft.
- Security-flavored review never returns through Fable (refusal-downgrade risk, see prompting.md); route it to the cache table's review seat.
- Computer use: delegating it is a COST move (screenshot loops are token furnaces), not a quality move; quality-critical GUI verification stays on the best GUI driver (check the cache).

## Gates (all three, before any delegation)

1. **Size gate:** under ~15 min of work, do it in-session. Delegation overhead (briefing + verification + handoff risk) eats the savings on small jobs.
2. **Spec gate:** if the orchestrator cannot write the task self-contained (goal, acceptance criteria, must-not-touch, verify commands), the task still needs thinking, not typing. Keep it.
3. **Taste gate:** user-facing output → high-taste model or executor draft + taste review.

## Wrapper pattern (non-Claude executors inside Agent/Workflow fan-outs)

Agent/Workflow `model:` only accepts Claude models. To fan out an external executor:
- **The orchestrator authors the complete self-contained prompt** and embeds it in the wrapper's briefing. The wrapper is plumbing, not a prompt-writer: cheapest reliable Claude model, low effort, its entire job = write the given prompt to a file, run the bridge shell-out via Bash, return the report (`schema` on the wrapper for structure).
- Label wrappers with the real worker's name (`label: 'gpt-5.5-review-auth'`) - the UI shows the wrapper's Claude model; the label is the only trace.
- Parallel implementation wrappers need `isolation: "worktree"` or executor edits collide.
- Workflow `budget.spent()` counts only Claude tokens; executor work is invisible there. Never read budget burn as work done; track the executor's own quota separately.

## CLAUDE.md rubric block (template; fill the table FROM the cache roles table at paste time)

```markdown
## Picking the right models for workflows and subagents
Rankings, higher = better. Cost reflects what I actually pay. Intelligence =
how hard a problem the model takes unsupervised. Taste = UI/UX, code quality,
API design, copy.
| model | cost | intelligence | taste |
|---|---|---|---|
| <bulk executor> | 9 | 8 | 5 |
| <wrapper/mid> | 5 | 5 | 7 |
| <taste/review> | 4 | 7 | 9 |
| <orchestrator> | 2 | 9 | 9 |
- Defaults, not limits: standing permission to redo below-bar output with a
  smarter model without asking. Judge the output, not the price tag.
- Cost is a tie-breaker only; for anything that ships, intelligence > taste > cost.
- Bulk/mechanical work goes to the bulk executor via its CLI bridge, never MCP.
- User-facing (UI, copy, API design) needs taste >= 7.
- Reviews: orchestrator or taste/review model, optionally the bulk executor
  as an extra independent seat.
```

## Failure rules (each one cost someone a session or real money)

1. Orchestrator effort caps at HIGH; xhigh/max degrades orchestration (overthinking, loops).
2. A subagent's security/vulnerability report returning to Fable can trigger the silent Opus downgrade. Scrub exploit language from returning reports.
3. Wrapper reporting success is not evidence: check `git status`/`git diff` yourself.
4. Wrappers cannot spawn wrappers (one-level depth); recursive delegation designs silently never execute.
5. When planning is trivial (bulk fan-out of identical mechanical tasks), skip the orchestrator entirely - a mid-tier fleet beats top-model-plus-fleet there. The premium buys nothing without hard decisions.
