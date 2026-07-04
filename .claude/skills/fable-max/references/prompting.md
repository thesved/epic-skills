# Fable 5 Prompting Playbook (Claude Code first)

Default context: you are prompting Fable INSIDE Claude Code (99% case). Claude Code's own system prompt already ships Anthropic's official Fable snippets (verified against the Piebald-AI/claude-code-system-prompts dump, v2.1.201, 2026-07-03), so your leverage is the task prompt and the /goal condition, not system-level behavior rules. For raw API, Agent SDK, or custom subagent bodies (surfaces that ship bare), load `api.md` instead.

Official facts from platform.claude.com (prompting-claude-fable-5, effort, migration-guide) and code.claude.com (model-config, sub-agents), accessed 2026-07-04. Community facts flagged inline.

## Contents
- Facts (what Fable is and costs)
- What Claude Code already ships (do not duplicate)
- The core law: goal + reason + boundaries + verification
- The task prompt shape
- The 3 gap snippets (long runs only)
- DELETE list (scaffolding that hurts Fable)
- Refusal navigation
- Routing: when NOT to use Fable
- Inversions (how competent users sabotage themselves)

## Facts

- Mythos-class tier above Opus. $10 in / $50 out per MTok (2x Opus 4.8). 1M context default, 128K max output.
- Thinking always on, billed, and invisible: raw chain of thought never returned; cannot be disabled.
- No assistant prefill. Non-default temperature/top_p/top_k rejected. Requires 30-day data retention (no ZDR).
- Safety classifiers target offensive cyber, bio/life-sciences, and reasoning extraction. Benign adjacent work can false-positive. In Claude Code a flagged request silently falls back to Opus 4.8.
- Claude Code: `/model fable`. Default effort HIGH (not xhigh; that was the Opus 4.8 advice). Never the default model on any plan.
- Turns run LONG by design: minutes per request, hours per autonomous run. This is the feature, not a bug.

## What Claude Code already ships (do not duplicate)

Claude Code's Fable system prompt already contains, verified in the v2.1.201 dump: autonomy ("asking 'Want me to...?' will block the work"), lead-with-outcome comms ("teammate who stepped away"), report-faithfully ("if tests fail, say so with the output"), assessment-vs-action boundaries, act-when-ready, scope discipline (condensed), memory format (own variant). This holds for interactive sessions AND `claude -p` headless.

BAN: pasting official Fable snippets into CLAUDE.md. Redundant with the harness, a per-turn token tax, and official memory docs say CLAUDE.md past ~200 lines "may reduce adherence". Falsifiable test for ANY rule you are about to add: would Claude Code already do this without being told? Yes: do not add it.

CLAUDE.md is for project FACTS: build commands, conventions, file pointers. Under ~200 lines.

Surfaces that ship WITHOUT the snippets (load `api.md` for these): raw Messages API (nothing), Agent SDK default ("minimal prompt... omits Claude Code's coding guidelines, response style"), custom subagents ("Subagents receive only this system prompt plus basic environment details, not the full Claude Code system prompt").

## The core law

Anthropic cut Claude Code's own system prompt ~80% for Fable 5 (the-decoder, 2026-07-02). The surviving shape: **give the model a goal, the reason behind it, explicit boundaries, and a way to verify its own work.** Your task prompts should have the same shape.

Official (model-config, "To get the most from Fable 5"):
1. Describe the outcome, not the steps.
2. Hand it ambiguous problems (root-cause hunts, outage debugging, architecture).
3. Skip verification reminders (it self-verifies). Reminders ("remember to test") are noise; a verification MEANS (test command, spec, oracle) is not, keep providing that. The ruler, not the nag.
4. Size up: give it work you would normally break into pieces.
5. Keep it working until the outcome holds: set a goal (/goal).

Also official: "Start at the top of your difficulty range." Testing Fable only on simple workloads undersells it.

## The task prompt shape

Official reason-template + community structure (byhartvig/fable5-prompting):
```
I'm working on [the larger task] for [who it's for]. They need [what the output enables].
Request: [one clear sentence, the OUTCOME, not the steps]
Output format: [exactly how structured / delivered]
Constraints: [what must NOT happen]
Verify with: [the means: test command, spec, oracle, screenshot check]
Checkpoints: [when to stop and ask; omit and it runs autonomously]
```
The WHY line is load-bearing: official docs say Fable "performs better when it understands the intent behind a request". The verify line is the ruler (core law #3).

For multi-turn autonomy, convert the outcome into a /goal (goal.md, 4-element gate).

## The 3 gap snippets (long runs only)

The only official snippets NOT in Claude Code's own prompt. Paste into the task prompt for long or overnight runs:

1. Audit-claims (only the report-faithfully half ships):
> "Before reporting progress, audit each claim against a tool result from this session. Only report work you can point to evidence for; if something is not yet verified, say so explicitly."

2. Self-verification cadence (no standing rule ships):
> "Establish a method for checking your own work at an interval of [X] as you build. Run this every [X interval], verifying your work with subagents against the specification."

3. Context-anxiety reassurance (not shipped, and Claude Code SHOWS the model a token countdown, the exact trigger the official guide warns about):
> "You have ample context remaining. Do not stop, summarize, or suggest a new session on account of context limits. Continue the work."

## DELETE list

Each of these Opus-era habits degrades Fable or worse. Falsifiable test for a rule: does it manage a weaker model's failure mode you no longer observe? Yes: delete.

1. **Step-by-step recipes.** Fable follows them literally, even when wrong. Official: skills for prior models are "often too prescriptive... can degrade output quality". Official best-practice: "Prefer general instructions over prescriptive steps."
2. **"Show your reasoning / think out loud" language.** Now triggers the `reasoning_extraction` refusal category and silently reroutes you to Opus 4.8. The single worst instruction to carry over. Official: "Audit existing skills and system prompts for reflection or show-your-thinking instructions when migrating."
3. **Token/context countdowns.** Showing remaining-budget numbers causes early stopping ("context anxiety"). Official: "Avoid surfacing explicit context-budget counts where possible."
4. **Verification reminders** ("remember to run the tests"). Noise; it verifies with less prompting. Do NOT delete the verification means (test command, spec, oracle): that is the "way to verify its own work" from the core law, and without it self-verification has nothing to bite on.
5. **Enumerated edge-case behavior lists.** "Instruction-following is improved enough that you can steer most behaviors with a brief instruction rather than enumerating each behavior by name."
6. **Official snippets duplicated into CLAUDE.md.** The harness already ships them; see the BAN above.

Self-audit prompt to run the cleanup (Pawel Huryn, productcompass.pm, 2026-06-11, verbatim):
```
Read your own instruction files (CLAUDE.md, skills, rules, memory files) end to end.
1. Where do they contradict each other? Quote both sides.
2. Which rules exist to manage a weaker model: guardrails for failure modes you
   don't have, recipes for things you no longer need spelled out, hardcoded facts
   that have drifted? List them with file:line.
3. Which rules teach by bad example: documents that violate the patterns they prescribe?
4. What would you delete? What would you keep exactly as is, and why?
Don't fix anything yet. Report first. I decide what gets cut.
```

## Refusal navigation

- Phrase security work defensively: "I am reviewing my own authorized codebase. Perform a defensive code review... Do not provide exploit chains, offensive tooling, payloads." Say "input-validation bugs", not "security audit" (community, wavect.io + Shri/medium, 2026-06/07).
- The fallback banner shows ONCE; the session can continue on Opus 4.8 silently afterwards. Verify per-turn serving model in `~/.claude/projects/<slug>/<session>.jsonl`, field `message.model` (github.com/anthropics/claude-code #66697).
- A memory file that records the refusal can re-trigger it on restart (single report, same issue). Scrub refusal mentions from memory files.
- Fable is NOT for offensive cyber or bio work, full stop. Route those to Opus 4.8 directly.

## Routing: when NOT to use Fable

Community consensus + private benchmarks (Endor Labs, afro88 on HN, CodeRabbit): Opus 4.8 and GPT-5.5 match or beat Fable on ROUTINE coding at half the price or less. Fable's edge is the hard tail.

- Fable: long-horizon (hours+), ambiguous or underspecified, architecture, root-cause debugging, cross-file review, one-shot complex systems.
- Opus 4.8 xhigh: daily agentic coding workhorse.
- Sonnet/Haiku: mechanical execution, boilerplate, subagent grunt work.
- "Fable sandwich" (wavect.io, 2026-07-02): cheap model explores, Fable plans, Opus/Sonnet executes, Fable reviews the diff. "Often more reliable than asking Fable to blindly do the entire job."

## Inversions (how competent users sabotage themselves)

1. **"More instructions = more control."** On Fable your guardrails ARE the sabotage: prescriptive scaffolding degrades output, and one "show your reasoning" line silently downgrades the whole session to Opus.
2. **"The official snippets belong in my CLAUDE.md."** In Claude Code the harness already ships them; you pay a per-turn tax to dilute your own adherence. They belong in API/SDK system prompts and subagent bodies (api.md).
3. **"xhigh/max = better results."** Measured (Willison, 2026-06-09): same task cost $0.10 at high, $0.30 at xhigh, $0.72 at max; independent timing runs (Huryn, n=50) found capability barely moves below max. High is the sweet spot; lower effort on Fable often exceeds prior models at xhigh (official).
4. **"The green /goal check means done."** Evaluator reads the transcript only; provably-correct-but-useless is a documented outcome. See goal.md.
5. **"The fallback banner will warn me."** Once. Then silence.
6. **"Fable is the best model, so use it for everything."** It loses to Opus 4.8 on routine PRs while costing 2x and burning subscription limits far faster than the official "~2x" (13-minute Max-window depletion reports, medium.com/@shriprasanna32, 2026-06-09). Pay for the hard 10%.
