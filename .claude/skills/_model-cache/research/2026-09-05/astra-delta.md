# GPT-6 Astra delta, 2026-09-05: day one of access, what changed since the 2026-09-04 sweep

Learning report (history and evidence HERE; operating changes went to `_model-cache/openai.md` (status paragraph, Codex row, cache TTL), `_model-cache/examples/openai.md` (card header + measured line), `_model-cache/index.md` (Astra capability rows and the delegation row flipped from provisional to verified), `codex-bridge/SKILL.md` (Astra line, custom-provider note), `fable-max/references/prompting.md` (routing bullet)). Prior sweep: `../2026-09-04/astra-sweep.md`.

Lanes (Fable 5.1 orchestrated, wrote every prompt, verified every result):
- Live probes (`probes.md`): Codex CLI 0.153.2 on the ChatGPT Pro login answered `OK` at 07:50 UTC; the direct API key completed a Responses call; OpenRouter lists `openai/gpt-6-astra`, `-pro` and `:batch` twins since 09-04; `update.sh openai` flagged the new id; CLI updated to 0.153.4.
- 2 codex `gpt-5.6-sol` web lanes, delta-only (`astra/codex-astra-lane-A.md` official and rollout, `-B.md` practitioner and independent numbers).
- YouTube delta: 60 new videos (uploads not in the 09-04 index, 180 s to 2 h, titles naming Astra or GPT-6) analyzed by `gemini-3.7-flash` through OpenRouter with the goal embedded; 77 reports in `yt/reports_astra/`, index `yt/youtube-index-astra-delta.md`, synthesis `yt/youtube-evidence-astra.md` (Sol wrote the synthesis from the reports, Fable spot-checked the hands-on ones). Metadata fetch was bot-blocked by YouTube all day, so comments and exact upload dates are missing for most rows.
- Day-one bakeoff (`bakeoff/`): 8 verifiable text tasks through `codex exec` for Astra and Sol at high; the buggy-repo agentic task twice through native Codex (Astra, Sol) and once through our identical mini agent harness over OpenRouter (Astra vs 10 other seats).

## TLDR (what changed)

1. **Astra is live for us on all three routes; nothing blocks routing to it any more.** Codex on the Pro sub (CLI floor is 0.153.0 per the help center, 0.153.4 fixes the picker and makes Astra the bundled default), the API key, and OpenRouter (`openai/gpt-6-astra` $10/$50, `:batch` $5/$25). The delegation row in `index.md` is now verified, not provisional.
2. **On small verifiable work Astra high ties or beats Sol high, and it is the fastest seat we measured.** Codex: 8/8 text tasks vs Sol 6/8 (Sol dropped a Hungarian length constraint and a vision sum). Repo fix (5 bugs + 1 feature, 11 locked tests): native Codex 53-58 s with 4-5 shell commands vs Sol 55-97 s; mini agent 28.5 s in 6 turns (Sol 27-41 s, Fable 5.1 64 s, Spark 1.3 low 26-28 s). Astra's reasoning tokens were the lowest of the frontier seats (88-394).
3. **Its differentiated wins are still official and practitioner claims, not our measurement.** Our tasks were too small to exercise computer use, multi-hour loops or terminal science. Practitioners since 09-04 report 2-5x faster wall time than Sol on matched jobs (4 h to 1 h; 20 min to 4 min with an extra issue found), no reproducible logs. No new independent leaderboard entry (SWE-bench, Aider, LiveBench, LMArena all still omit it); ARC stays 62.7 standard vs 99.9 adapter.
4. **Precision work stays on Fable 5.1.** Two matched practitioner tests: structured-output validity Fable 50/50 vs Astra 48/50 at $0.65 vs $1.10; PR findings 13/14 vs 11/14. The 09-04 routing (Fable orchestrates, judges taste, reviews) is unchanged.
5. **The sub allowance is the real limit, and it is noisier than the rate card.** Official: rolling 5 h usage plus weekly limits, Astra 5-45 (Plus), 25-225 (Pro 5x), 100-900 (Pro 20x) local messages per 5 h, local and cloud shared, paid instant reset restores both windows; no daily reset any more. Practitioner: a Pro $200 high session went from 40% weekly to zero in about 30 min; seven parallel 30-min jobs used 1% weekly; one short max run exhausted Plus. Meter every run.
6. **Chat access clarified**: Plus gets Astra in ChatGPT Work and Codex, not GPT-6 Pro in ordinary Chat; Pro $200 = 200 GPT-6 messages per week plus 170 Sol Pro per day (200 per day combined); Pro $100 = 50 per week shared.
7. **API contract details now documented**: tools require Responses; `prompt_cache_options.ttl` accepts only `"30m"` (also the default); cache write $12.50/M; API Fast 2x rates, Codex Fast 2.5x credits; Batch and Flex 50%; `temperature`, `top_p`, `logprobs` unsupported; async tool calls, WebSocket mid-turn steering and `configuration_update` (change effort without losing the cached prefix) are live. Default effort still undocumented: set it.
8. **Misalignment 403 has an official runbook**: `invalid_request_error` / `misalignment_policy_violation`, "Do not automatically retry the blocked workflow", "A stopped request does not undo earlier actions". Unchanged advice: long runs on the Codex sub, not the API.
9. **New failure evidence**: structured-output preambles, instruction drift around turn 22 of a long thread, unrequested side work (built an evaluation skill nobody asked for), asking for login credentials, quota burn before any answer, Codex 0.153.0 child agents inherit the root `service_tier` (issue 42665, so per-role Fast overrides are ignored).
10. **Foundry GA, Bedrock only in the Codex picker.** Microsoft Foundry says "generally available for all customers" (Standard and Provisioned, Global and US Data Zone); Bedrock has a picker entry since CLI 0.153.3 but no AWS model card yet.

## Confirmed, unchanged (from 09-04)

Effort ladder (high default, xhigh ceiling, max buys nothing on general work, ultra Codex-only), harness beats effort (ARC adapter), the behavior deltas and their fixes (action-chaining clause, pruned AGENTS.md, locked tests, negative UI constraints, delegation budget, no CoT-monitor mention), trust rule (external verification only), cyber gating (Preparedness-Critical, PoC refusals, Daybreak reduced refusals not on Astra), 272K input cliff on the API with Codex exempt, price parity with Fable except the $1 cache read.

## Evidence quality

- Official: complete for rollout, limits, pricing and the API guide; Bedrock still thin.
- Independent numbers: none new; still AA, ARC, Epoch from launch week.
- Practitioner: a handful of post-gate Reddit threads and 12 hands-on videos; two matched small tests (50-call structured output, 14-finding PR review) are the only quantified comparisons vs Fable 5.1.
- Ours: 8 text tasks + 1 agentic task, 2 harnesses. Enough to say "no regression vs Sol on small work", not enough to rank it on its claimed strengths.

## Not done and why

- The full paired 20-task repo bakeoff from the 09-04 TODO: our tasks were 11 small verifiable ones plus one 11-test repo fix; every frontier seat solved them, so they cannot separate Astra from Sol or Fable. Needs a harder task set (multi-file feature with GUI verification, a 2 h tool loop) before the row is re-ranked.
- Astra as a research lane: not run on the sub because the allowance is shared with the Sol lanes that were already running.

## What the new videos added (77 reports, 12 hands-on; synthesis `yt/youtube-evidence-astra.md`, index `yt/youtube-index-astra-delta.md`)

- **Matched gauntlet with token counts** (まさおAI, 25 tasks via Devin and Codex at xhigh): Astra matched or beat Fable 5.1 on most UI and 3D builds using 40-50% fewer tokens and 30-50% less wall time (block editor 92 vs 85, vector tool 95 vs 88, earphone timeline 93 vs 91; Fable ahead on landing pages 85 vs 81, 86 vs 82, pinball 89 vs 82); the tester still keeps Fable for orchestration and harness design. Effort sweep: low and medium produce basic geometry, high and xhigh add lighting, particles, wave systems and annotations, so xhigh can matter for visual builds.
- **Allowance burn, measured**: a 50-minute video workflow on Codex showed $59.77 standard-equivalent ($119.54 at Fast), 2.00M input, 68M reasoning tokens, two quota resets exhausted (Nate Herk); a High + Fast engineering session on Pro moved from 53% to 50% weekly in ~25 min (Taylor Arndt). Chess vs Fable 5.1 over OpenRouter: Astra $0.049 per move vs Fable $0.185, and Astra won both games (JC BuenaVentura).
- **Long-session continuity works**: a 110-minute Codex Projects session survived two automatic compactions across Swift migration, Safari computer use, simulator audits, deploy and a physical iPhone install, with zero benign refusals (Taylor Arndt).
- **New API mechanics on screen**: `async: true` tool definitions and WebSocket `response.steer` redirecting a running Three.js render mid-turn (OpenAI's own developer video).
- **New failure shapes**: a hallucinated domain on a rendered end card (lock public-facing strings in a manifest and OCR-check renders), a recurring dark-green/teal house palette across unrelated apps (two channels; specify palettes explicitly), game-physics and rigging flaws behind impressive visuals, `/fast` needed for tolerable interactive speed (30-50+ tok/s, at 2x price).


