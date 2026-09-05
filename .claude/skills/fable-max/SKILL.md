---
name: fable-max
description: >-
  Gets maximum results from Claude Fable 5.1 and forges verifiable /goal
  statements. Defaults to Claude Code context: model and effort choice,
  task-prompt framing, /goal conditions rewritten through a 4-part gate
  (measurable end state, check command, constraints, stop bound).
  De-prescribes Opus-era prompts and CLAUDE.md files that degrade Fable.
  Default mode is delegate: Fable is the brain (graph plan, specs,
  verdicts), Sonnet runner agents babysit codex executors (GPT-5.6 Sol,
  GPT-6 Astra) and Gemini/OpenRouter models, logs on disk are the truth.
  Also routes work across Claude tiers and builds Fable system prompts
  for API, Agent SDK, and subagents. Use when the user says fable-max,
  max out fable, fable settings, prompt for fable, fable system prompt,
  write my goal, goal statement, /goal settings, overnight run setup,
  should I use fable, de-prescribe, save tokens, delegate to codex,
  delegate execution, fable orchestrator, or multi-model execution.
argument-hint: '[delegate] <task> (default) | goal <objective> | session | prompt <file|text> | api <use case> | route <task>'
---

Research-backed for Fable 5.1 (official docs, the live Claude Code 2.1.258 system prompt, a 2026-09-02 practitioner sweep; learning report in `_model-cache/research/2026-09-02/`). This file is the DEFAULT mode only. Everything else is progressive disclosure:

- `references/delegation.md`: the delegate mode's reference (graph planning, runner layer, sentinel, verification sandwich, routes, rubric, failure modes). Read it for every delegate run.
- `references/modes.md`: the rarely used modes `goal`, `session`, `prompt`, `api`, `route`. Read ONLY when the user names one (they point to `goal.md`, `prompting.md`, `tokens.md`, `api.md`).

Runner agent definitions ship in `fable-max/agents/` and must live in `~/.claude/agents/` to be spawnable (`cp ~/.claude/skills/fable-max/agents/*.md ~/.claude/agents/`, then restart the session once; `epic-install` does the copy).

A bare `/fable-max <task>` means `delegate` with the codex executor (the user's default). Only go to `modes.md` when the request unmistakably names a goal statement, a session setup, a prompt audit, an API/SDK prompt, or a pure routing question.

## Mode: delegate <task> (DEFAULT)

Read `references/delegation.md` AND the "Delegation roles" table in `~/.claude/skills/_model-cache/index.md` (current model picks live there, refreshed with model updates, never from memory). Fable is the brain; runner agents babysit executors; raw logs on disk are the truth.

0. Reality first, before any design: open the repo, the logs, the real data, the live page. Design or UX work: pull skin-in-the-game references (`/mobbin`, or the user's logged-in Chrome via `/chrome`) from products that are popular, profitable, or hyped, including the silent money printers. Unfamiliar domain: a YouTube sweep (`/youtube-research`, sized by the problem, off the main thread). Designing from a blank page is the banned opening.
1. Gates per node (size ~15 min, self-contained spec, taste gate for user-facing). A gate fails: keep that node in-session and say why.
2. Plan a GRAPH, not a queue: nodes, deps, allowed paths per node. Independent nodes run in parallel (about 3 codex executors by default; scale back when limits bite; coupled files get one owner, sequential). Print the graph before execution. Re-plan when a report or reality changes the picture; nothing is set in stone.
3. Per node: write the SPEC (goal, acceptance criteria, must-not-touch, verify commands, permitted initiative). Spawn `codex-runner` (OpenAI executors) or `model-runner` (Gemini, Grok, DeepSeek, GLM, Muse) with the spec, one runner per node, `isolation: "worktree"` when nodes touch the same repo. The runner compiles the prompt, launches via steer, babysits with the sentinel, verifies, stops the daemon, and returns ONE report with the log path. Claude subagents run direct. The main thread never reads raw executor output and never polls; it works other nodes or waits for reports.
4. Verification sandwich, cheap seat first: see it broken before (the runner pins `git status`, a failing check, a screenshot), see it fixed after (the runner runs the spec's check; Fable reads the diff itself, the report is a claim), forward test on a fresh case. Climb to a smarter seat (fresh Fable subagent, Astra through a runner, `/board`) only when the cheap check cannot settle it. Any model may open the raw logs; Sonnet's report is never the only copy of the truth.
5. Hard stuff goes UP, not out: planning the graph, a second check on something important, brainstorming a way out, being stuck, confirming or refuting a diagnosis, a fresh-eyes plan check, a taste verdict, experiment or eval design (examples of the user's taste, not an exhaustive list). Fable itself, a fresh Fable subagent, or Astra via `codex-runner`. Expensive is fine when slowing down is faster; meter it (Fable cap, Pro allowance).
6. Routes: Anthropic models as Claude subagents, OpenAI models through the codex CLI. OpenRouter for those two families only with the user's explicit approval in this session (ask first, never a fallback). Prompt authorship: Fable writes the spec, the runner has Sol compile it into the executor prompt and checks nothing was dropped (tested 2026-09-05: Sol's rewrites won 12/12 blind, two judges, both orders; report in `_model-cache/research/2026-09-05/prompt-author-test.md`).
7. State the arbitrage in one line (whose meter burns) and the executor and subagent caps. On close, run the `/wrap` retro questions (what we fucked up, used wrong, wasted, and the non-obvious 100x fix).


## Example

Input: `/fable-max add rate limiting to the public API`
Output: reality touch first (read the router, the existing middleware, the prod logs for the current request shape), then a printed graph: node A limiter middleware + unit tests, node B config + env plumbing, node C docs and the integration test; A and B parallel on `codex-runner` worktrees, C after both. Each node gets a spec with acceptance checks; runners return one report each with log paths; Fable reads the diffs, runs the integration test itself, climbs to a Fable subagent only if the limiter's semantics under bursts stay unclear. Arbitrage line: Sol burns the ChatGPT sub, Fable spends ~3 spec-and-verify turns. Cap: 3 runners.

