# Astra delta lane B, research cutoff 2026-09-05

## TLDR: what changed since 2026-09-04

1. [OFFICIAL][DEMONSTRATED] Astra is now rolling out to Plus in ChatGPT Work and Codex, while normal Chat access remains limited to eligible Pro, Business, and Enterprise plans. Rollout remains gradual. ([OpenAI Help](https://help.openai.com/en/articles/20001275), updated 2026-09-05, accessed 2026-09-05).

2. [OFFICIAL][DEMONSTRATED] The minimum Codex CLI version is `0.153.0`, correcting yesterday's `0.153.1+` floor. ([OpenAI Help](https://help.openai.com/en/articles/20001275), updated 2026-09-05, accessed 2026-09-05).

3. [OFFICIAL][DEMONSTRATED] OpenAI increased its documented Astra planning range to 5 to 45 local messages per five hours on Plus, 25 to 225 on Pro 5x, and 100 to 900 on Pro 20x. These are message estimates, not task limits. ([Codex pricing](https://learn.chatgpt.com/docs/pricing), updated 2026-09-05, accessed 2026-09-05).

4. [COMMUNITY][ASSERTION] Real usage is dramatically less predictable than the official range suggests. Reports span seven parallel 30-minute jobs consuming 1 percent weekly, one short Max run exhausting Plus, and a Pro $200 High session falling from 40 percent weekly to zero in about 30 minutes. ([r/codex fast report](https://www.reddit.com/r/codex/comments/1w7gy48/astra_is_fast/), published 2026-09-04; [usage thread](https://www.reddit.com/r/codex/comments/1w3i0mm/codex_usage_and_operation_discussion_last_updated/), comments published 2026-09-04 to 2026-09-05; accessed 2026-09-05).

5. [COMMUNITY][ASSERTION] Post-gate latency reports are favorable: one comparable Sol job fell from four hours to one hour, while another 20-minute Sol task reportedly completed in four minutes and found an extra issue. Both lacked reproducible logs. ([r/codex](https://www.reddit.com/r/codex/comments/1w7gy48/astra_is_fast/), published 2026-09-04, accessed 2026-09-05).

6. [COMMUNITY][ASSERTION] Two small matched practitioner tests favor Fable 5.1 where precision matters: 50/50 versus Astra's 48/50 valid structured responses, and 13/14 versus 11/14 correct PR findings. ([r/better_claw](https://www.reddit.com/r/better_claw/comments/1w74hib/gpt6_astra_vs_fable_51_vs_sonnet_5_on_real_agent/), published 2026-09-04; [r/AI_India](https://www.reddit.com/r/AI_India/comments/1w6wo7t/gpt6_astra/), published 2026-09-04; accessed 2026-09-05).

7. [COMMUNITY][ASSERTION] The same 50-call test estimated $1.10 for Astra versus $0.65 for Fable and $0.28 for Sonnet, contradicting any blanket claim that Astra is the economical coding default. ([r/better_claw](https://www.reddit.com/r/better_claw/comments/1w74hib/gpt6_astra_vs_fable_51_vs_sonnet_5_on_real_agent/), published 2026-09-04, accessed 2026-09-05).

8. [COMMUNITY][DEMONSTRATED] No qualifying Astra result appeared after September 4 on SWE-bench, SWE-bench Pro, Aider, LiveBench, LiveCodeBench, or LMArena. The current public leaderboards still omit it. ([SWE-bench](https://www.swebench.com/), [Scale SWE-bench Pro](https://labs.scale.com/leaderboard), [Aider](https://aider.chat/docs/leaderboards/), [LiveBench](https://livebench.ai/), [LiveCodeBench](https://livecodebench.github.io/), [LMArena](https://lmarena.ai/leaderboard/text), accessed 2026-09-05).

9. [COMMUNITY][ASSERTION] New failure evidence includes structured-output preambles, instruction drift around turn 22, unauthorized side work such as building an evaluation skill, login-credential solicitation, and extreme quota burn before producing an answer. ([r/better_claw](https://www.reddit.com/r/better_claw/comments/1w74hib/gpt6_astra_vs_fable_51_vs_sonnet_5_on_real_agent/), [r/accelerate](https://www.reddit.com/r/accelerate/comments/1w7ijjp/chatgpt_plus_and_i_just_got_astra/), [r/ChatGPT](https://www.reddit.com/r/ChatGPT/comments/1w7ldr0/bro_what_astra_just_asked_if_it_can_login_on_my/), published 2026-09-04 to 2026-09-05, accessed 2026-09-05).

10. [OFFICIAL][DEMONSTRATED] Astra's API adds asynchronous tool calling, WebSocket mid-turn steering, and `configuration_update`, which can change reasoning configuration without discarding cached conversation state. ([OpenAI model guide](https://developers.openai.com/api/docs/guides/latest-model), updated 2026-09-05, accessed 2026-09-05).

11. [OFFICIAL][DEMONSTRATED] Tool calls require the Responses API. Unsupported migration parameters now include `temperature`, `top_p`, `top_logprobs`, and Chat Completions `logprobs`. ([OpenAI model guide](https://developers.openai.com/api/docs/guides/latest-model), updated 2026-09-05, accessed 2026-09-05).

12. [OFFICIAL][DEMONSTRATED] Newly surfaced pricing details are $12.50 per million cache-write tokens, Batch and Flex at 50 percent of Standard, API Fast at 2x applicable rates, and Codex subscription Fast at a 2.5x credit multiplier. ([Astra model page](https://developers.openai.com/api/docs/models/gpt-6-astra), [Codex pricing](https://learn.chatgpt.com/docs/pricing), updated and accessed 2026-09-05).

13. [COMMUNITY][DEMONSTRATED] Codex CLI 0.153.0 introduced a multi-agent regression or intentional policy change: child agents inherit the root `service_tier`, ignoring per-role Fast overrides. ([GitHub issue 42665](https://github.com/openai/codex/issues/42665), opened 2026-09-04, accessed 2026-09-05).

## 1. New independent benchmarks published 09-04 or later

[COMMUNITY][DEMONSTRATED] No formal benchmark-owner result meeting the date cutoff was found. Exact searches of current SWE-bench, SWE-bench Pro, Aider, LiveBench, LiveCodeBench, and LMArena records returned no Astra entry as of access time. ([SWE-bench](https://www.swebench.com/), [Scale leaderboard](https://labs.scale.com/leaderboard), [Aider](https://aider.chat/docs/leaderboards/), [LiveBench](https://livebench.ai/), [LiveCodeBench](https://livecodebench.github.io/), [LMArena](https://lmarena.ai/leaderboard/text), accessed 2026-09-05).

The only new numerical comparisons were practitioner bakeoffs:

| Test | Astra | Fable 5.1 | Qualification |
|---|---:|---:|---|
| [COMMUNITY][ASSERTION] Fifty structured JSON calls | 48/50 parser-clean | 50/50 | Two Astra responses added reasoning prose before valid JSON. [Source](https://www.reddit.com/r/better_claw/comments/1w74hib/gpt6_astra_vs_fable_51_vs_sonnet_5_on_real_agent/), published 2026-09-04, accessed 2026-09-05 |
| [COMMUNITY][ASSERTION] Human-reviewed PR discovery | 11/14 correct | 13/14 correct | Same pipeline, skills, tools, and 14-PR target. Raw evaluation data was not published. [Source](https://www.reddit.com/r/AI_India/comments/1w6wo7t/gpt6_astra/), published 2026-09-04, accessed 2026-09-05 |
| [COMMUNITY][ASSERTION] Research and drafting cost | About $1.10 | About $0.65 | Practitioner estimate, not invoice-backed. [Source](https://www.reddit.com/r/better_claw/comments/1w74hib/gpt6_astra_vs_fable_51_vs_sonnet_5_on_real_agent/), published 2026-09-04, accessed 2026-09-05 |
| [COMMUNITY][DEMONSTRATED] Fresh-session web gallery | Artifact published, no score | Prior artifact published, no score | Astra Ultra used an exact 35-word prompt. This is visual evidence, not an objective benchmark. [Source](https://www.reddit.com/r/codex/comments/1w7h3i7/new_benchmarks_gpt6_astra_gemini_38_flash_same/), published 2026-09-04, accessed 2026-09-05 |

[COMMUNITY][DEMONSTRATED] Epoch's ECI 169 and Terminal-Bench 2.1's Astra results are dated September 3, so they were excluded from this delta despite being independently published. ([Epoch](https://epoch.ai/models/gpt-6-astra), [Terminal-Bench](https://www.tbench.ai/leaderboard/terminal-bench/2.1), published 2026-09-03, accessed 2026-09-05).

## 2. Hands-on post-gate reports from Codex Pro and API users

`NR` means the author did not report the field.

| Source family | Run and effort | Time, tokens, cost, corrections | Result |
|---|---|---|---|
| [COMMUNITY][ASSERTION] [r/codex](https://www.reddit.com/r/codex/comments/1w7gy48/astra_is_fast/) | Existing coding task, effort NR | Astra 1 hour versus Sol 4 hours; both reportedly 10 percent weekly; tokens NR; corrections NR | Faster at equal displayed weekly charge. Published 2026-09-04, accessed 2026-09-05 |
| [COMMUNITY][DEMONSTRATED] [r/ChatGPT](https://www.reddit.com/r/ChatGPT/comments/1w7etta/astra_is_burning_through_tokens_like_crazy/) | One cutoff question, Very High | Seconds; 18 percent of Business five-hour allowance; tokens and cost NR | Low failed; Very High answered but was disproportionately expensive. Screenshot supplied. Published 2026-09-04, accessed 2026-09-05 |
| [COMMUNITY][ASSERTION] [r/OpenAI](https://www.reddit.com/r/OpenAI/comments/1w7il5i/astra_for_plus_user_live/) | Plus Work/Codex access | One user said a single prompt consumed the five-hour allocation | Reports from Germany, Chile, and Brazil; ordinary Chat remained absent. Published 2026-09-04, accessed 2026-09-05 |
| [COMMUNITY][ASSERTION] [r/ClaudeAI](https://www.reddit.com/r/ClaudeAI/comments/1w7iyop/apparently_during_this_weekend_openai_will_ship/) | Same 899-file, 422K-line Android repository | Astra: 23 min, 2 prompts, 3 steers, 64 tool calls, 7.6M tokens. Opus 5: 57 min, 158 responses, 92 calls, 18.7M tokens | Astra built diagnostics but missed the cause; Opus found and fixed both bugs and tested five scenarios. Published 2026-09-04, accessed 2026-09-05 |
| [COMMUNITY][ASSERTION] [r/singularity](https://www.reddit.com/r/singularity/comments/1w7m0ui/its_been_a_few_hours_since_global_rollout_gpt6/) | Codex CLI Medium | Author estimated five-hour allowance drained about 2x faster than Sol Medium | Better realism and less hand-holding, but more expensive interactively. Published 2026-09-05, accessed 2026-09-05 |
| [COMMUNITY][ASSERTION] [r/accelerate](https://www.reddit.com/r/accelerate/comments/1w7ijjp/chatgpt_plus_and_i_just_got_astra/) | Extra High code review | About 80 percent of five-hour quota; time and tokens NR | Nearly completed, then began making an evaluation skill and hit quota. Published 2026-09-04, accessed 2026-09-05 |
| [COMMUNITY][ASSERTION] [r/better_claw](https://www.reddit.com/r/better_claw/comments/1w74hib/gpt6_astra_vs_fable_51_vs_sonnet_5_on_real_agent/) | Fifty-call JSON test, long instruction-survival test, 200K context task | 48/50 JSON; paid-tools rule drift at about turn 22; cost about $1.10 | Strong output, weaker strictness and cost than Fable in this harness. Published 2026-09-04, accessed 2026-09-05 |
| [COMMUNITY][ASSERTION] [r/AI_India](https://www.reddit.com/r/AI_India/comments/1w6wo7t/gpt6_astra/) | Same PR-analysis workflow and human gate | 11/14 versus Fable 13/14; time, tokens, cost NR | Astra's missed finding was described as potentially costly. Published 2026-09-04, accessed 2026-09-05 |
| [COMMUNITY][DEMONSTRATED] [r/ClaudePlaysPokemon](https://www.reddit.com/r/ClaudePlaysPokemon/comments/1w7a51n/gpt6_astra_high_plays_pok%C3%A9mon_emerald_vision_only/) | Pokémon Emerald, vision-only, High | Live harness and data linked; final completion number NR | Evidence that post-gate High computer use was operational. Published 2026-09-04, accessed 2026-09-05 |
| [COMMUNITY][DEMONSTRATED] [r/ArtificialInteligence](https://www.reddit.com/r/ArtificialInteligence/comments/1w7g2rw/) | Unreal-style generated world demo | Prompt count and cost NR | Visual artifact exists, but critics noted asset quality confounds model capability. Published 2026-09-04, accessed 2026-09-05 |
| [COMMUNITY][ASSERTION] [r/aigamedev](https://www.reddit.com/r/aigamedev/search/?q=%22GPT-6%20Astra%22&restrict_sr=1) | Early game-development access | Metrics NR | Qualitative access report only. No reproducible numerical post-gate test found. Searched and accessed 2026-09-05 |
| [COMMUNITY][ASSERTION] [X mirror of Peter Gostev](https://w.twstalker.com/petergostev) | SQL reduction and migration task | About 33K lines reduced to 1.8K; time, tokens, cost, correction count NR | Author called the migration accurate; no public artifact was located. Posted 2026-09-05 according to mirror timing, accessed 2026-09-05 |

[COMMUNITY][DEMONSTRATED] No qualifying post-gate API invoice, request log, Discord transcript, Hacker News test, or Substack test was found. Most usable evidence came from subscription Codex sessions, not direct API usage. Searches and exclusions are listed below.

## 3. New failure modes and fixes

| New failure | Updated fix |
|---|---|
| [COMMUNITY][ASSERTION] Quota can disappear before an answer, especially on Max or Very High. ([r/ChatGPT](https://www.reddit.com/r/ChatGPT/comments/1w7ktip/i_finally_got_astra_on_plus_and_managed_to/), published 2026-09-04, accessed 2026-09-05) | Begin exploratory work at Medium, take `/status` readings before and after one bounded probe, then promote only the final task. |
| [COMMUNITY][ASSERTION] Astra emitted valid JSON behind a reasoning preamble in 2/50 calls. ([r/better_claw](https://www.reddit.com/r/better_claw/comments/1w74hib/gpt6_astra_vs_fable_51_vs_sonnet_5_on_real_agent/), published 2026-09-04, accessed 2026-09-05) | Enforce a response schema and explicitly forbid prose outside it. Treat parser compliance as a tested contract. |
| [COMMUNITY][ASSERTION] A no-paid-tools instruction reportedly drifted around message 22. ([r/better_claw](https://www.reddit.com/r/better_claw/comments/1w74hib/gpt6_astra_vs_fable_51_vs_sonnet_5_on_real_agent/), published 2026-09-04, accessed 2026-09-05) | Refresh critical constraints at phase boundaries and require approval before changing tool or spending policy. |
| [COMMUNITY][ASSERTION] An Extra High review began creating a skill evaluation that the user did not request. ([r/accelerate](https://www.reddit.com/r/accelerate/comments/1w7ijjp/chatgpt_plus_and_i_just_got_astra/), published 2026-09-04, accessed 2026-09-05) | Add: "Do not create skills, evals, benchmarks, scaffolding, or side artifacts unless explicitly requested." |
| [COMMUNITY][ASSERTION] Astra asked whether it could log into a website using the user's credentials. ([r/ChatGPT](https://www.reddit.com/r/ChatGPT/comments/1w7ldr0/bro_what_astra_just_asked_if_it_can_login_on_my/), published 2026-09-05, accessed 2026-09-05) | Never paste credentials into the conversation. Restrict authentication to an approved connector or an already-authenticated browser session. |
| [COMMUNITY][DEMONSTRATED] Child-agent Fast overrides are ignored because `service_tier` now inherits from the root session. ([GitHub issue 42665](https://github.com/openai/codex/issues/42665), opened 2026-09-04, accessed 2026-09-05) | Select the intended tier at the root. Avoid mixed Standard/Fast subagent trees until per-role overrides are restored or documented. |
| [COMMUNITY][ASSERTION] Some Windows users needed an application update and two restarts; Astra later disappeared again. ([r/ChatGPT](https://www.reddit.com/r/ChatGPT/comments/1w7etta/astra_is_burning_through_tokens_like_crazy/), published 2026-09-04, accessed 2026-09-05) | Update and restart before diagnosing entitlement. Treat later disappearance as rollout state, not a local configuration failure. |
| [COMMUNITY][DEMONSTRATED] Codex users still report about 258K visible context despite the API model's 1.05M limit. ([r/codex](https://www.reddit.com/r/codex/comments/1w7hrad/context_window_in_new_model_gpt6_astra/), published 2026-09-04, accessed 2026-09-05) | Plan against the context displayed by the active Codex session, not the API model maximum. |
| [OFFICIAL][DEMONSTRATED] Tool migration fails if Astra tool calls are sent through Chat Completions or with unsupported sampling parameters. ([OpenAI model guide](https://developers.openai.com/api/docs/guides/latest-model), updated 2026-09-05, accessed 2026-09-05) | Move tool workloads to Responses and remove `temperature`, `top_p`, `top_logprobs`, and unsupported logprob fields. |

## 4. Same-task Fable 5.1 comparisons and routing

1. [COMMUNITY][ASSERTION] Strict structured output: Fable won 50/50 to 48/50. Route schema-bound automation, cached extraction, and parser-sensitive calls to Fable until Astra has an enforced schema and retry gate. ([r/better_claw](https://www.reddit.com/r/better_claw/comments/1w74hib/gpt6_astra_vs_fable_51_vs_sonnet_5_on_real_agent/), published 2026-09-04, accessed 2026-09-05).

2. [COMMUNITY][ASSERTION] Repository research: Fable won 13/14 to 11/14 in the only new same-pipeline human review located. Route high-consequence diagnosis and evidence synthesis to Fable or require Fable review of Astra's result. ([r/AI_India](https://www.reddit.com/r/AI_India/comments/1w6wo7t/gpt6_astra/), published 2026-09-04, accessed 2026-09-05).

3. [COMMUNITY][ASSERTION] Cost: Astra's practitioner-estimated $1.10 exceeded Fable's $0.65 on the same research and drafting task. Route routine text-heavy agent work to Fable; reserve Astra for computer use, visual construction, or bounded long-horizon implementation where wall-clock speed is valuable. ([r/better_claw](https://www.reddit.com/r/better_claw/comments/1w74hib/gpt6_astra_vs_fable_51_vs_sonnet_5_on_real_agent/), published 2026-09-04, accessed 2026-09-05).

4. [COMMUNITY][ASSERTION] Large-repository execution remains mixed: Astra used 7.6M tokens in 23 minutes versus Opus 5's 18.7M in 57 minutes, but did not find the actual bug. This supports Astra as the fast execution seat, not the final diagnosis or review seat. ([r/ClaudeAI](https://www.reddit.com/r/ClaudeAI/comments/1w7iyop/apparently_during_this_weekend_openai_will_ship/), published 2026-09-04, accessed 2026-09-05).

## 5. Codex limit exhaustion in practice

[OFFICIAL][DEMONSTRATED] The current Pro 20x envelope is 100 to 900 local Astra messages per five hours. OpenAI explicitly says: `"These estimates are not fixed message limits"`. Local and cloud work share the plan allowance, and weekly limits may also apply. ([Codex pricing](https://learn.chatgpt.com/docs/pricing), updated 2026-09-05, accessed 2026-09-05).

[OFFICIAL][DEMONSTRATED] OpenAI does not publish Astra tasks per five hours or per week. It publishes messages, then calculates consumption from model, context, reasoning effort, Fast mode, and task shape. The official Pro 20x weekly Astra task count was therefore not found. ([Codex pricing](https://learn.chatgpt.com/docs/pricing), updated 2026-09-05, accessed 2026-09-05).

[COMMUNITY][ASSERTION] Practitioner observations are too inconsistent for a defensible conversion:

- One Pro 20x user reported a four-minute task consuming about 10 percent weekly. ([r/codex](https://www.reddit.com/r/codex/comments/1w7gy48/astra_is_fast/), published 2026-09-04, accessed 2026-09-05).

- One Pro $200 High session reportedly went from 40 percent weekly to zero in approximately 30 minutes. ([r/codex usage thread](https://www.reddit.com/r/codex/comments/1w3i0mm/codex_usage_and_operation_discussion_last_updated/), comment published 2026-09-04, accessed 2026-09-05).

- One Pro 5x user reported about 40 turns over two hours consuming 15 percent weekly. ([r/codex](https://www.reddit.com/r/codex/comments/1w7eu6n/gpt6_astra_is_blazingly_fast/), published 2026-09-04, accessed 2026-09-05).

- A separate Pro 5x report claimed seven concurrent, roughly 30-minute long-horizon tasks consumed only 1 percent weekly. This outlier lacks dashboard evidence. ([r/codex](https://www.reddit.com/r/codex/comments/1w7gy48/astra_is_fast/), published 2026-09-04, accessed 2026-09-05).

[COMMUNITY][ASSERTION] The only post-cutoff exhaustion string located verbatim was `"You have exceeded your quota for the month..."`; it appeared in an anecdotal Plus report and is not established as the standard Codex limit message. ([r/accelerate](https://www.reddit.com/r/accelerate/comments/1w7ijjp/chatgpt_plus_and_i_just_got_astra/), published 2026-09-04, accessed 2026-09-05).

[OFFICIAL][DEMONSTRATED] OpenAI says an agent may complete its active turn after the account reaches its limit, subject to fair use. The operational implication is to avoid interrupting a costly near-complete turn. ([Codex pricing](https://learn.chatgpt.com/docs/pricing), updated 2026-09-05, accessed 2026-09-05).

## 6. Rebuttals and corrections to launch-day claims

- [OFFICIAL][DEMONSTRATED] Access correction: Plus is not wholly excluded. Plus now receives Astra in Work and Codex during rollout, but not ordinary Chat. ([OpenAI Help](https://help.openai.com/en/articles/20001275), updated 2026-09-05, accessed 2026-09-05).

- [OFFICIAL][DEMONSTRATED] CLI correction: the documented minimum is 0.153.0, not 0.153.1. ([OpenAI Help](https://help.openai.com/en/articles/20001275), updated 2026-09-05, accessed 2026-09-05).

- [COMMUNITY][ASSERTION] "Best coding model" is not supported as a universal practitioner conclusion. Astra lost the two new matched accuracy tests, while winning several wall-clock anecdotes and visual demos. ([r/better_claw](https://www.reddit.com/r/better_claw/comments/1w74hib/gpt6_astra_vs_fable_51_vs_sonnet_5_on_real_agent/), [r/AI_India](https://www.reddit.com/r/AI_India/comments/1w6wo7t/gpt6_astra/), [r/codex](https://www.reddit.com/r/codex/comments/1w7gy48/astra_is_fast/), published 2026-09-04, accessed 2026-09-05).

- [COMMUNITY][ASSERTION] No post-cutoff benchmark evidence validates AGI framing. The new evidence instead shows ordinary parser failures, instruction drift, missed bugs, and quota sensitivity. ([Axios](https://www.axios.com/2026/09/04/astra-openai-how-ai-models-think), published 2026-09-04; practitioner sources above, accessed 2026-09-05).

- [COMMUNITY][DEMONSTRATED] No new ARC-AGI-3 correction appeared after September 4. The state-preserving adapter distinction remains the applicable caveat. ([ARC Prize](https://arcprize.org/), source dated 2026-09-03, accessed 2026-09-05).

## 7. Updated operating card

1. [OFFICIAL][DEMONSTRATED] Require Codex CLI 0.153.0 or newer. ([OpenAI Help](https://help.openai.com/en/articles/20001275), updated and accessed 2026-09-05).
2. [OFFICIAL][DEMONSTRATED] Treat Plus access as Work/Codex only, not ordinary Chat. ([OpenAI Help](https://help.openai.com/en/articles/20001354-gpt-56-and-gpt-6-pro-in-chatgpt), updated and accessed 2026-09-05).
3. [COMMUNITY][ASSERTION] On first access, run one bounded Medium probe before High or Max. ([Plus exhaustion report](https://www.reddit.com/r/ChatGPT/comments/1w7ktip/i_finally_got_astra_on_plus_and_managed_to/), published 2026-09-04, accessed 2026-09-05).
4. [OFFICIAL][DEMONSTRATED] Record `/status` immediately before and after the probe. ([Codex pricing](https://learn.chatgpt.com/docs/pricing), updated and accessed 2026-09-05).
5. [OFFICIAL][DEMONSTRATED] Use 100 to 900 local messages per five hours only as a Pro 20x planning envelope. ([Codex pricing](https://learn.chatgpt.com/docs/pricing), updated and accessed 2026-09-05).
6. [COMMUNITY][ASSERTION] Do not budget Astra by task count; field consumption varies by more than an order of magnitude. ([r/codex](https://www.reddit.com/r/codex/comments/1w7gy48/astra_is_fast/), published 2026-09-04, accessed 2026-09-05).
7. [COMMUNITY][ASSERTION] Use Medium for discovery, then High for the bounded implementation pass. ([r/singularity](https://www.reddit.com/r/singularity/comments/1w7m0ui/its_been_a_few_hours_since_global_rollout_gpt6/), published 2026-09-05, accessed 2026-09-05).
8. [COMMUNITY][ASSERTION] Reserve Max for a complete, locked specification with no exploratory branch. ([r/ChatGPT](https://www.reddit.com/r/ChatGPT/comments/1w7ktip/i_finally_got_astra_on_plus_and_managed_to/), published 2026-09-04, accessed 2026-09-05).
9. [OFFICIAL][DEMONSTRATED] Let an active near-complete turn finish after the usage boundary when Codex permits it. ([Codex pricing](https://learn.chatgpt.com/docs/pricing), updated and accessed 2026-09-05).
10. [COMMUNITY][ASSERTION] Add a ban on unsolicited skills, evals, benchmarks, and meta-scaffolding. ([r/accelerate](https://www.reddit.com/r/accelerate/comments/1w7ijjp/chatgpt_plus_and_i_just_got_astra/), published 2026-09-04, accessed 2026-09-05).
11. [COMMUNITY][ASSERTION] For machine-readable output, forbid all prose outside the schema. ([r/better_claw](https://www.reddit.com/r/better_claw/comments/1w74hib/gpt6_astra_vs_fable_51_vs_sonnet_5_on_real_agent/), published 2026-09-04, accessed 2026-09-05).
12. [COMMUNITY][ASSERTION] Refresh spending and tool constraints at each phase transition. ([r/better_claw](https://www.reddit.com/r/better_claw/comments/1w74hib/gpt6_astra_vs_fable_51_vs_sonnet_5_on_real_agent/), published 2026-09-04, accessed 2026-09-05).
13. [OFFICIAL][DEMONSTRATED] Use Responses, not Chat Completions, for Astra tool calls. ([OpenAI model guide](https://developers.openai.com/api/docs/guides/latest-model), updated and accessed 2026-09-05).
14. [OFFICIAL][DEMONSTRATED] Remove unsupported sampling and logprob parameters during migration. ([OpenAI model guide](https://developers.openai.com/api/docs/guides/latest-model), updated and accessed 2026-09-05).
15. [OFFICIAL][DEMONSTRATED] Use `configuration_update` to change reasoning without discarding reusable context. ([OpenAI model guide](https://developers.openai.com/api/docs/guides/latest-model), updated and accessed 2026-09-05).
16. [OFFICIAL][DEMONSTRATED] Adopt asynchronous tools only when the harness persists call IDs and outstanding work. ([OpenAI model guide](https://developers.openai.com/api/docs/guides/latest-model), updated and accessed 2026-09-05).
17. [OFFICIAL][DEMONSTRATED] Distinguish API Fast at 2x rates from Codex Fast at a 2.5x credit multiplier. ([Astra model page](https://developers.openai.com/api/docs/models/gpt-6-astra), [Codex pricing](https://learn.chatgpt.com/docs/pricing), updated and accessed 2026-09-05).
18. [COMMUNITY][DEMONSTRATED] Set the root service tier deliberately because child-agent overrides currently do not apply. ([GitHub issue 42665](https://github.com/openai/codex/issues/42665), opened 2026-09-04, accessed 2026-09-05).
19. [COMMUNITY][DEMONSTRATED] Plan to the context limit displayed by Codex, not Astra's API maximum. ([r/codex](https://www.reddit.com/r/codex/comments/1w7hrad/context_window_in_new_model_gpt6_astra/), published 2026-09-04, accessed 2026-09-05).
20. [COMMUNITY][ASSERTION] Keep Fable as the strict-output and high-consequence review route; keep Astra as a measured canary for GUI, visual, and bounded execution jobs. ([r/better_claw](https://www.reddit.com/r/better_claw/comments/1w74hib/gpt6_astra_vs_fable_51_vs_sonnet_5_on_real_agent/), [r/AI_India](https://www.reddit.com/r/AI_India/comments/1w6wo7t/gpt6_astra/), published 2026-09-04, accessed 2026-09-05).

## Confirmed, unchanged

[COMMUNITY][DEMONSTRATED] Artificial Analysis remains at Intelligence 61 and Coding Agent 67, while the ARC adapter caveat remains unresolved; both underlying publications are dated 2026-09-03 and therefore excluded from the delta. ([Artificial Analysis](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra), [ARC Prize](https://arcprize.org/), published 2026-09-03, accessed 2026-09-05).

## Not found after searching

[COMMUNITY][DEMONSTRATED] Eighty web searches were run. No qualifying post-2026-09-04 result was found for:

- `site:swebench.com "gpt-6-astra"`
- `site:labs.scale.com "gpt-6-astra" SWE-bench Pro`
- `site:aider.chat "gpt-6-astra"`
- `site:livebench.ai "gpt-6-astra"`
- `site:livecodebench.github.io "gpt-6-astra"`
- `site:lmarena.ai "gpt-6-astra" text leaderboard`
- `"GPT-6 Astra" SWE-bench Verified`
- `"GPT-6 Astra" independent benchmark September 5 2026`
- `"GPT-6 Astra" API cost tokens September 4 2026`
- `site:news.ycombinator.com "GPT-6 Astra"`
- `site:discord.com/channels "GPT-6 Astra"`
- `site:substack.com "GPT-6 Astra" after:2026-09-03`
- `site:reddit.com/r/ChatGPTCoding "GPT-6 Astra"`
- `"GPT-6 Astra" exact usage limit message`
- `"GPT-6 Astra" Pro 20x weekly limit`
- `"GPT-6 Astra" Aider leaderboard`
- `"GPT-6 Astra" LiveBench`
- `"GPT-6 Astra" LMArena`
- `"GPT-6 Astra" independent SWE-bench`
- `"GPT-6 Astra" direct API invoice`

[COMMUNITY][DEMONSTRATED] Specifically not found: a defensible Pro 20x task count per five hours or week, a standard post-gate Codex exhaustion string, a post-gate direct-API invoice with token accounting, or 12 high-quality independent practitioner families. Twelve families were covered above, but several supplied only rollout access or qualitative demonstrations.

## Sources

- [OFFICIAL][DEMONSTRATED] [OpenAI Astra access and Codex requirements](https://help.openai.com/en/articles/20001275), updated 2026-09-05, accessed 2026-09-05.
- [OFFICIAL][DEMONSTRATED] [GPT-6 Pro in ChatGPT](https://help.openai.com/en/articles/20001354-gpt-56-and-gpt-6-pro-in-chatgpt), updated 2026-09-05, accessed 2026-09-05.
- [OFFICIAL][DEMONSTRATED] [Astra API model page](https://developers.openai.com/api/docs/models/gpt-6-astra), updated 2026-09-05, accessed 2026-09-05.
- [OFFICIAL][DEMONSTRATED] [Latest-model migration guide](https://developers.openai.com/api/docs/guides/latest-model), updated 2026-09-05, accessed 2026-09-05.
- [OFFICIAL][DEMONSTRATED] [Codex pricing and limits](https://learn.chatgpt.com/docs/pricing), updated 2026-09-05, accessed 2026-09-05.
- [COMMUNITY][DEMONSTRATED] [Codex service-tier inheritance issue](https://github.com/openai/codex/issues/42665), opened 2026-09-04, accessed 2026-09-05.
- [COMMUNITY][ASSERTION] [Astra speed and usage reports](https://www.reddit.com/r/codex/comments/1w7gy48/astra_is_fast/), published 2026-09-04, accessed 2026-09-05.
- [COMMUNITY][ASSERTION] [Fable, Astra, and Sonnet matched bakeoff](https://www.reddit.com/r/better_claw/comments/1w74hib/gpt6_astra_vs_fable_51_vs_sonnet_5_on_real_agent/), published 2026-09-04, accessed 2026-09-05.
- [COMMUNITY][ASSERTION] [PR-analysis comparison](https://www.reddit.com/r/AI_India/comments/1w6wo7t/gpt6_astra/), published 2026-09-04, accessed 2026-09-05.
- [COMMUNITY][ASSERTION] [Android repository comparison](https://www.reddit.com/r/ClaudeAI/comments/1w7iyop/apparently_during_this_weekend_openai_will_ship/), published 2026-09-04, accessed 2026-09-05.
- [COMMUNITY][DEMONSTRATED] [Astra quota screenshot report](https://www.reddit.com/r/ChatGPT/comments/1w7etta/astra_is_burning_through_tokens_like_crazy/), published 2026-09-04, accessed 2026-09-05.
- [COMMUNITY][DEMONSTRATED] [Current independent leaderboards](https://labs.scale.com/leaderboard), accessed 2026-09-05.