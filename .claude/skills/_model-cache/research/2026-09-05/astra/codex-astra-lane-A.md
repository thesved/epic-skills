# Astra delta lane A, research cutoff 2026-09-05

Tag key: `[OFFICIAL]` means OpenAI or the relevant platform vendor. `[COMMUNITY]` means an independent benchmark or user report. `[DEMONSTRATED]` means the source contains an observable release, table, configuration, or result. `[ASSERTION]` means the source states a plan, availability claim, or experience that was not independently reproduced here.

Research method: 68 web searches plus direct documentation inspection, covering OpenAI, Microsoft, AWS, OpenRouter, benchmark owners, release notes, and community rollout reports.

## TLDR: what changed since 2026-09-04

1. **Upgrade the Codex CLI from 0.153.2 to 0.153.4.** Version 0.153.4 fixes Astra disappearing from the bundled model picker and makes Astra the bundled default when no model is configured. It also restricts asynchronous questions to sessions where the required tool exists. `[OFFICIAL][DEMONSTRATED]` [Codex changelog](https://learn.chatgpt.com/docs/changelog), published 2026-09-04, accessed 2026-09-05.

2. **Plus access is narrower than the launch post implied.** Current help pages say Plus gets Astra in ChatGPT Work and Codex, but not GPT-6 Pro in ordinary Chat. Regular Chat access is limited to Pro $100, Pro $200, Business, and Enterprise during rollout. `[OFFICIAL][DEMONSTRATED]` [ChatGPT model availability](https://help.openai.com/en/articles/20001354-gpt-56-and-gpt-6-pro-in-chatgpt), updated 2026-09-05, accessed 2026-09-05; compare the broader [launch wording](https://openai.com/index/gpt-6-astra/), published 2026-09-03, accessed 2026-09-05.

3. **The Pro $200 Chat allowance is now explicitly documented.** The exact wording is `"200 messages per week"` for GPT-6 Pro, plus `"Separate 170 messages per day for GPT-5.6 Sol Pro. Both models together are also limited to 200 messages per day."` Pro $100 instead gets `"50 messages per week"` shared across Astra and Sol Pro. `[OFFICIAL][DEMONSTRATED]` [ChatGPT model limits](https://help.openai.com/en/articles/20001354-gpt-56-and-gpt-6-pro-in-chatgpt), updated 2026-09-05, accessed 2026-09-05.

4. **Codex allowances are now described as rolling five-hour usage plus possible weekly limits, not daily resets.** The live rate card gives Astra estimates of 5-45 local messages for Plus, 25-225 for Pro 5x, and 100-900 for Pro 20x. It states: `"Local messages and cloud chats share your plan's usage allowance. Weekly limits may also apply."` No current official page found says Astra Codex allowances still reset daily. `[OFFICIAL][DEMONSTRATED]` [Codex pricing](https://learn.chatgpt.com/docs/pricing), live page with no publication date shown, accessed 2026-09-05.

5. **Pro 5x and Pro 20x are now unambiguous product tiers.** OpenAI's exact wording is `"Choose 5x or 20x higher rate limits than Plus."` The corresponding subscription prices are $100 and $200 per month. `[OFFICIAL][DEMONSTRATED]` [Codex pricing](https://learn.chatgpt.com/docs/pricing), live page with no publication date shown, accessed 2026-09-05.

6. **There is a new paid weekly-reset mechanism.** Eligible Plus and Pro personal accounts can buy an instant reset. OpenAI says: `"A completed purchase immediately restores both 5-hour and weekly usage."` The next automatic weekly reset occurs seven days after the first subsequent Work or Codex request. This is not a daily reset and does not add a second allowance. `[OFFICIAL][DEMONSTRATED]` [Paid weekly resets](https://help.openai.com/en/articles/20001507-paid-weekly-work-and-codex-rate-limit-resets), updated 2026-09-01, accessed 2026-09-05.

7. **Microsoft Foundry has advanced to general availability.** The current Microsoft page redirects from its earlier "now available" URL to a page titled `"now generally available"` and says Astra is `"now generally available for all customers"`, with Standard and Provisioned Throughput deployments in Global and US Data Zone geographies. `[OFFICIAL][DEMONSTRATED]` [Microsoft Foundry announcement](https://azure.microsoft.com/en-us/blog/gpt-6-astra-frontier-intelligence-for-work-now-generally-available-in-microsoft-foundry/), published 2026-09-03, current revision accessed 2026-09-05; revision date not shown.

8. **Bedrock client support arrived, but AWS service rollout remains insufficiently documented.** CLI 0.153.3 added Astra to the Amazon Bedrock picker for Mantle and Runtime global and US routes. No post-launch AWS model card or AWS announcement establishing account-wide availability was found. `[OFFICIAL][DEMONSTRATED]` [Codex changelog](https://learn.chatgpt.com/docs/changelog), published 2026-09-04, accessed 2026-09-05; [AWS model catalog](https://docs.aws.amazon.com/bedrock/latest/userguide/model-cards.html), live page, accessed 2026-09-05.

9. **The API now has a concrete Astra migration contract.** Tool calling requires Responses, although plain text works through Chat Completions. New Astra features include asynchronous tool calls, WebSocket mid-turn steering, and `configuration_update` reasoning changes that preserve the cached prompt prefix. `[OFFICIAL][DEMONSTRATED]` [Astra model guidance](https://developers.openai.com/api/docs/guides/latest-model), live page with no publication date shown, accessed 2026-09-05.

10. **Astra's API default reasoning effort remains undocumented.** The guide recommends `low` when migrating from `none` or `minimal`, otherwise preserving the previous effective effort. That is migration advice, not a documented default. The model page also exposes only the moving `gpt-6-astra` alias, with no dated snapshot identifier. `[OFFICIAL][DEMONSTRATED]` [Astra model guidance](https://developers.openai.com/api/docs/guides/latest-model) and [model page](https://developers.openai.com/api/docs/models/gpt-6-astra), live pages with no publication dates shown, accessed 2026-09-05.

11. **Prompt caching now has a precise Astra-era lifetime and write charge.** The only supported `prompt_cache_options.ttl` is `"30m"`, which is also the default. Cache writes cost $12.50 per million tokens, or 1.25 times uncached input. `[OFFICIAL][DEMONSTRATED]` [Prompt caching guide](https://developers.openai.com/api/docs/guides/prompt-caching) and [Astra model page](https://developers.openai.com/api/docs/models/gpt-6-astra), live pages with no publication dates shown, accessed 2026-09-05.

12. **The API and Codex Fast multipliers are different.** API Fast costs 2 times the applicable token rate. Codex subscription Fast consumes credits at 2.5 times Astra's Standard rate. API Fast also lacks a latency SLA and is unavailable with EU data residency. `[OFFICIAL][DEMONSTRATED]` [Astra model page](https://developers.openai.com/api/docs/models/gpt-6-astra), [model guidance](https://developers.openai.com/api/docs/guides/latest-model), and [Codex pricing](https://learn.chatgpt.com/docs/pricing), live pages with no publication dates shown, accessed 2026-09-05.

13. **The 403 failure mode now has an official operational runbook.** OpenAI says: `"When misalignment monitoring blocks a request before streaming begins, the API returns HTTP 403, with error type invalid_request_error and code misalignment_policy_violation."` It further says: `"Do not automatically retry the blocked workflow."` and `"A stopped request does not undo earlier actions."` `[OFFICIAL][DEMONSTRATED]` [Misalignment monitoring](https://developers.openai.com/api/docs/guides/safety-checks/misalignment-monitoring), live page with no publication date shown, accessed 2026-09-05.

14. **No new independent mainstream coding leaderboard result appeared by cutoff.** No qualifying Astra entry was found for SWE-bench, Aider, LiveBench, or LMArena. ARC Prize still reports 62.7 percent under its Standard harness and 99.9 percent under the Provider Adapter, so the prior harness warning remains necessary. `[COMMUNITY][DEMONSTRATED]` [ARC Prize analysis](https://arcprize.org/blog/astra), published 2026-09-03, accessed 2026-09-05.

## 1. Rollout state per surface today

| Surface | State at cutoff |
|---|---|
| ChatGPT Plus | `[OFFICIAL][DEMONSTRATED]` No GPT-6 Pro in ordinary Chat. Astra is gradually rolling out only in Work and Codex. Published wording: `"Plus plans include GPT-6 Astra in ChatGPT Work and Codex as it rolls out."` [ChatGPT model availability](https://help.openai.com/en/articles/20001354-gpt-56-and-gpt-6-pro-in-chatgpt), updated 2026-09-05, accessed 2026-09-05. |
| ChatGPT Pro $100 | `[OFFICIAL][DEMONSTRATED]` Gradual access in Chat, Work, and Codex. Chat allowance: `"50 messages per week"`, shared between GPT-6 Pro and GPT-5.6 Sol Pro. Codex is the Pro 5x tier, estimated at 25-225 Astra local messages per five-hour period. [ChatGPT limits](https://help.openai.com/en/articles/20001354-gpt-56-and-gpt-6-pro-in-chatgpt), updated 2026-09-05; [Codex pricing](https://learn.chatgpt.com/docs/pricing), live page with no publication date shown; accessed 2026-09-05. |
| ChatGPT Pro $200 | `[OFFICIAL][DEMONSTRATED]` Gradual access in Chat, Work, and Codex. Chat allowance: `"200 messages per week"` for Astra. Sol Pro separately has 170 messages per day, with both models together capped at 200 per day. Codex is the Pro 20x tier, estimated at 100-900 Astra local messages per five-hour period. [ChatGPT limits](https://help.openai.com/en/articles/20001354-gpt-56-and-gpt-6-pro-in-chatgpt), updated 2026-09-05; [Codex pricing](https://learn.chatgpt.com/docs/pricing), live page with no publication date shown; accessed 2026-09-05. |
| Business Standard | `[OFFICIAL][DEMONSTRATED]` Chat gets `"15 messages per month"` shared across Astra and Sol Pro. Work and Codex get limited Astra usage, estimated at 5-45 local messages per five-hour window. Credits do not give early rollout access. [Business limits](https://help.openai.com/en/articles/12003714-chatgpt-team-models-limits), updated 2026-09-05, accessed 2026-09-05. |
| Business Premium | `[OFFICIAL][DEMONSTRATED]` Chat gets `"50 messages per week"` shared across Astra and Sol Pro. Work and Codex use the full existing Premium allowance. OpenAI says Premium has `"5x the included usage of Standard seats, with the benefit of no 5-hour limit"`. [Business limits](https://help.openai.com/en/articles/12003714-chatgpt-team-models-limits), updated 2026-09-05, accessed 2026-09-05. |
| Enterprise | `[OFFICIAL][DEMONSTRATED]` Gradual rollout, off by default. Existing Early Model Access does not carry over, and the normal two-week admin preview does not apply. An owner must enable Astra through workspace or role controls. Flexible-pricing workspaces have credit-scaled usage; legacy per-seat plans generally inherit Plus-like limits. [Enterprise limits](https://help.openai.com/en/articles/11165333-chatgpt-enterprise-models-limits), updated 2026-09-05, accessed 2026-09-05. |
| Codex CLI | `[OFFICIAL][DEMONSTRATED]` Minimum supported version remains 0.153.0, but 0.153.4 is the practical minimum for correct picker visibility and bundled-default behavior. [ChatGPT Work and Codex](https://help.openai.com/en/articles/20001275), updated 2026-09-05; [Codex changelog](https://learn.chatgpt.com/docs/changelog), published 2026-09-04; accessed 2026-09-05. |
| Codex desktop app | `[OFFICIAL][ASSERTION]` OpenAI directs users to update to the latest ChatGPT Desktop app but does not publish an Astra-specific minimum desktop version. Codex remains a separate desktop view and is not selectable on web or mobile. [ChatGPT Work and Codex](https://help.openai.com/en/articles/20001275), updated 2026-09-05, accessed 2026-09-05. |
| Codex cloud | `[OFFICIAL][DEMONSTRATED]` Astra is included in the overall Work and Codex rollout, but the pricing page currently says cloud chats on ChatGPT plans use GPT-5.6 Sol and may consume more allowance than local messages. No source found establishes Astra as a selectable Codex cloud model. [Codex pricing](https://learn.chatgpt.com/docs/pricing), live page with no publication date shown, accessed 2026-09-05. |
| OpenAI API | `[OFFICIAL][DEMONSTRATED]` The `gpt-6-astra` model page is live, with Tier 1 through Tier 5 limits and no Free tier. Access may still depend on account eligibility and rollout. [Astra model page](https://developers.openai.com/api/docs/models/gpt-6-astra), live page with no publication date shown, accessed 2026-09-05. |
| Amazon Bedrock | `[OFFICIAL][DEMONSTRATED]` Codex CLI 0.153.3 includes Astra Bedrock entries for Mantle and Runtime global and US routes. `[OFFICIAL][ASSERTION]` OpenAI says Bedrock rollout is coming, but no post-launch AWS model card or announcement was found. [Codex changelog](https://learn.chatgpt.com/docs/changelog), published 2026-09-04; [OpenAI launch post](https://openai.com/index/gpt-6-astra/), published 2026-09-03; accessed 2026-09-05. |
| Microsoft Foundry | `[OFFICIAL][DEMONSTRATED]` Generally available for all customers, with Standard and Provisioned Throughput options in Global and US Data Zone geographies. [Microsoft Foundry announcement](https://azure.microsoft.com/en-us/blog/gpt-6-astra-frontier-intelligence-for-work-now-generally-available-in-microsoft-foundry/), published 2026-09-03, current revision accessed 2026-09-05; revision date not shown. |
| OpenRouter | `[COMMUNITY][ASSERTION]` Users reported Astra appearing on OpenRouter and at least one EU 404, but no official Astra model page, slug, pricing entry, or release announcement was found. Treat availability as unverified. [Community rollout report](https://www.reddit.com/r/singularity/comments/1w7e04f/gpt6_astra_is_available_on_openrouter/), published 2026-09-04, accessed 2026-09-05; [OpenRouter model directory](https://openrouter.ai/models), live page, accessed 2026-09-05. |

### Current allowance wording

`[OFFICIAL][DEMONSTRATED]` OpenAI describes the Codex figures as estimates, not fixed message caps: `"The estimates below show local messages per five-hour period."` It adds: `"Local messages and cloud chats share your plan's usage allowance. Weekly limits may also apply."` [Codex pricing](https://learn.chatgpt.com/docs/pricing), live page with no publication date shown, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` No current official source found supports continuation of the temporary daily-reset arrangement. The documented mechanisms are rolling five-hour consumption, weekly allowances where applicable, paid weekly resets, and purchased credits. [Codex pricing](https://learn.chatgpt.com/docs/pricing) and [paid weekly resets](https://help.openai.com/en/articles/20001507-paid-weekly-work-and-codex-rate-limit-resets), live or updated 2026-09-01, accessed 2026-09-05.

## 2. Codex CLI releases since 0.153.2 and the Codex app

### Codex CLI 0.153.3

`[OFFICIAL][DEMONSTRATED]` Published 2026-09-04:

- `"Added GPT-6-Astra to the Amazon Bedrock model picker for Mantle and Runtime global/US routes."`
- `"Corrected GPT-6-Astra's guidance for asynchronous clarification questions to use the supported tool and recognize that it accepts text only."`

Source: [Codex changelog](https://learn.chatgpt.com/docs/changelog), published 2026-09-04, accessed 2026-09-05.

### Codex CLI 0.153.4

`[OFFICIAL][DEMONSTRATED]` Published 2026-09-04:

- `"Fixed Astra's visibility in the bundled model picker and made it the bundled default when no model is explicitly configured."`
- `"Updated Astra's guidance to use asynchronous questions only when the tool is available in the session."`

Source: [Codex changelog](https://learn.chatgpt.com/docs/changelog), published 2026-09-04, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` No later stable CLI release was published in the official changelog by the research cutoff. Searches for 0.153.5 and 0.154.0 found no qualifying release. [Codex changelog](https://learn.chatgpt.com/docs/changelog), accessed 2026-09-05.

### Defaults and flags

`[OFFICIAL][DEMONSTRATED]` The only newly documented Astra default is model selection: 0.153.4 chooses Astra when no model is explicitly configured. No Astra-specific default reasoning effort or response verbosity is documented. [Codex changelog](https://learn.chatgpt.com/docs/changelog), published 2026-09-04, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` Experimental context management has not yet become the documented default. The launch post still says it `"will become the default for Astra in the coming weeks."` [OpenAI launch post](https://openai.com/index/gpt-6-astra/), published 2026-09-03, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` No new Astra-specific command-line flag was added in 0.153.3 or 0.153.4. The changes are catalog, picker, default-selection, and asynchronous-question guidance fixes. [Codex changelog](https://learn.chatgpt.com/docs/changelog), published 2026-09-04, accessed 2026-09-05.

### Codex app

`[OFFICIAL][ASSERTION]` OpenAI's only Astra-specific desktop instruction is: `"please update to the latest available ChatGPT Desktop app."` It does not give a minimum Astra-compatible desktop build number. [ChatGPT Work and Codex](https://help.openai.com/en/articles/20001275), updated 2026-09-05, accessed 2026-09-05.

`[COMMUNITY][ASSERTION]` New rollout reports describe temporarily missing Astra picker entries, repeated app restarts, and unusually rapid five-hour or weekly usage depletion. These reports lack reproducible telemetry and should be treated as rollout symptoms, not measured token economics. [Astra token-use report](https://www.reddit.com/r/ChatGPT/comments/1w7etta/astra_is_burning_through_tokens_like_crazy/) and [Codex Astra report](https://www.reddit.com/r/codex/comments/1w7kvf7/gpt6_astra_wow/), published 2026-09-05, accessed 2026-09-05.

## 3. API changes

### Model identifier, snapshots, and effort

`[OFFICIAL][DEMONSTRATED]` The published identifier is `gpt-6-astra`. The snapshots section lists only this moving alias and no date-stamped snapshot. [Astra model page](https://developers.openai.com/api/docs/models/gpt-6-astra), live page with no publication date shown, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` Supported reasoning efforts are `low`, `medium`, `high`, `xhigh`, and `max`. No default is stated. Migration guidance says: `"If you currently use none or minimal, start with low and compare results. Otherwise, preserve your current effective reasoning effort."` [Astra model guidance](https://developers.openai.com/api/docs/guides/latest-model), live page with no publication date shown, accessed 2026-09-05.

### Processing tiers

`[OFFICIAL][DEMONSTRATED]` Standard, Batch, Flex, and Fast pricing are documented. Exact pricing wording: `"Batch and Flex are priced at 50% of Standard rates. Fast mode is priced at 2x the applicable rates."` [Astra model page](https://developers.openai.com/api/docs/models/gpt-6-astra), live page with no publication date shown, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` Fast has no Astra latency SLA and cannot be used with EU data residency through either `service_tier: "fast"` or `service_tier: "priority"`. [Astra model guidance](https://developers.openai.com/api/docs/guides/latest-model), live page with no publication date shown, accessed 2026-09-05.

### Prompt caching and the context cliff

`[OFFICIAL][DEMONSTRATED]` For GPT-5.6 and later, including Astra, `prompt_cache_options.ttl` accepts only `"30m"`, and that is the default. A cached prefix remains eligible for at least 30 minutes after its latest write or reuse. [Prompt caching guide](https://developers.openai.com/api/docs/guides/prompt-caching), live page with no publication date shown, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` Exact pricing text remains: `"Prompts with more than 272K input tokens are priced at 2x input and cache rates and 1.5x output for the full request."` Cache writes are newly itemized at $12.50 per million tokens. [Astra model page](https://developers.openai.com/api/docs/models/gpt-6-astra), live page with no publication date shown, accessed 2026-09-05.

### Responses-only functionality

`[OFFICIAL][DEMONSTRATED]` Chat Completions supports Astra text generation, but `"tool calling requires Responses."` Responses also carries the newly documented asynchronous tool calling, WebSocket mid-turn steering, persisted reasoning, compaction, and `configuration_update` effort changes. [Astra model guidance](https://developers.openai.com/api/docs/guides/latest-model), live page with no publication date shown, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` Unsupported sampling parameters are now explicit: remove `temperature`, `top_p`, and `top_logprobs`; also remove `logprobs` for Chat Completions. [Astra model guidance](https://developers.openai.com/api/docs/guides/latest-model), live page with no publication date shown, accessed 2026-09-05.

### Prompting and examples

`[OFFICIAL][DEMONSTRATED]` The new Astra prompting guide now officially recommends initiative and follow-through language, explicit instruction priority, reduced formatting instructions, deliberate subagent policies, and constrained testing. It also acknowledges a previously undocumented tendency to delegate less often than desired. [Astra model guidance](https://developers.openai.com/api/docs/guides/latest-model), live page with no publication date shown, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` No Astra-specific Cookbook recipe was found. OpenAI instead published two developer-blog case studies on 2026-09-04: [Building games with Astra](https://developers.openai.com/blog/how-to-build-games-with-astra) and [Architectural visualization with Astra](https://developers.openai.com/blog/architectural-visualization-with-astra), published 2026-09-04, accessed 2026-09-05.

## 4. Safety, refusal policy, and misalignment stopping

`[OFFICIAL][DEMONSTRATED]` The new operational detail is request coverage. Responses conversations using persisted reasoning, WebSockets, or OpenAI compaction can be monitored across continuations and automatically stopped. Responses requests without those mechanisms are monitored but are not automatically stopped by this system. Chat Completions is not covered by this particular monitor, although other checks still apply. [Misalignment monitoring](https://developers.openai.com/api/docs/guides/safety-checks/misalignment-monitoring), live page with no publication date shown, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` Exact error behavior: `"When misalignment monitoring blocks a request before streaming begins, the API returns HTTP 403, with error type invalid_request_error and code misalignment_policy_violation."` Streaming clients must also handle a block after partial output. [Misalignment monitoring](https://developers.openai.com/api/docs/guides/safety-checks/misalignment-monitoring), live page with no publication date shown, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` Exact recovery policy: `"Do not automatically retry the blocked workflow."` The API provides no general resume mechanism. Because monitoring is asynchronous, `"A stopped request does not undo earlier actions."` The prescribed response is to halt further actions, preserve request, response, and tool-call records, then send the work for human review. [Misalignment monitoring](https://developers.openai.com/api/docs/guides/safety-checks/misalignment-monitoring), live page with no publication date shown, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` Projects can subscribe to `safety.alert.created`; the webhook supplies an alert ID that must be retrieved with `api.safety.alerts.read`. Alert delivery is not a complete audit history. [Misalignment monitoring](https://developers.openai.com/api/docs/guides/safety-checks/misalignment-monitoring), live page with no publication date shown, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` No system-card addendum, refusal-policy relaxation, or Daybreak rollout notice dated after 2026-09-04 was found. The launch page continues to use future tense for less restrictive Daybreak safeguards. [Astra system card](https://deploymentsafety.openai.com/gpt-6-astra/vision), published 2026-09-03, accessed 2026-09-05; [OpenAI launch post](https://openai.com/index/gpt-6-astra/), published 2026-09-03, accessed 2026-09-05.

## 5. Official corrections and benchmark footnotes

`[OFFICIAL][DEMONSTRATED]` The clearest official correction is product-surface scope. The launch post says Astra will reach `"all ChatGPT Plus, Pro, Business, and Enterprise users"`, while the 2026-09-05 help pages specify that Plus receives Astra only in Work and Codex. [OpenAI launch post](https://openai.com/index/gpt-6-astra/), published 2026-09-03; [ChatGPT model availability](https://help.openai.com/en/articles/20001354-gpt-56-and-gpt-6-pro-in-chatgpt), updated 2026-09-05; accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` Microsoft Foundry's live announcement is now titled `"now generally available"` and states availability for all customers. This supersedes earlier limited-access wording, although Microsoft does not display the revision time. [Microsoft Foundry announcement](https://azure.microsoft.com/en-us/blog/gpt-6-astra-frontier-intelligence-for-work-now-generally-available-in-microsoft-foundry/), published 2026-09-03, current revision accessed 2026-09-05.

`[COMMUNITY][DEMONSTRATED]` ARC Prize provides the cleanest authoritative benchmark-owner distinction: 62.7 percent at max effort and $26,098 under the Standard harness, versus 99.9 percent at high effort and $18,817 under the Provider Adapter. The adapter preserves opaque reasoning state and uses compaction. [ARC Prize analysis](https://arcprize.org/blog/astra), published 2026-09-03, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` OpenAI has not corrected its top-line 99.9 percent ARC-AGI-3 claim. Its footnote still describes only a Responses API harness that changes two settings, without showing the 62.7 percent Standard result beside the headline. [OpenAI launch post](https://openai.com/index/gpt-6-astra/), published 2026-09-03, accessed 2026-09-05.

`[OFFICIAL][ASSERTION]` The statement `"GPT-6 Astra is the best model for software engineering to date"` remains on the launch page. No retraction, revised scope, or independent SWE-bench support for that claim was found by cutoff. [OpenAI launch post](https://openai.com/index/gpt-6-astra/), published 2026-09-03, accessed 2026-09-05.

## 6. Pricing changes and promotions

`[OFFICIAL][DEMONSTRATED]` No change was found to Astra's Standard API rates. Exact current prices are $10 per million input tokens, $1 per million cached input tokens, $12.50 per million cache-write tokens, and $50 per million output tokens. The cache-write line is the newly documented detail. [Astra model page](https://developers.openai.com/api/docs/models/gpt-6-astra), live page with no publication date shown, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` API Batch and Flex cost 50 percent of Standard, while API Fast costs 2 times the applicable rate. This is separate from Codex Fast, whose credit consumption is 2.5 times Standard. [Astra model page](https://developers.openai.com/api/docs/models/gpt-6-astra) and [Codex pricing](https://learn.chatgpt.com/docs/pricing), live pages with no publication dates shown, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` Foundry Global Standard matches OpenAI's short-context API prices. US Data Zone Standard is 10 percent higher: $11 input, $1.10 cached input, $13.75 cache writes, and $55 output. Long-context US Data Zone pricing is $22, $2.20, $27.50, and $82.50 respectively. [Microsoft Foundry announcement](https://azure.microsoft.com/en-us/blog/gpt-6-astra-frontier-intelligence-for-work-now-generally-available-in-microsoft-foundry/), published 2026-09-03, current revision accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` Astra has `"no separate compute-unit charge at launch"` inside the existing eligible Codex allowance. Extra use can consume purchased credits. [Codex pricing](https://chatgpt.com/codex/pricing), live page with no publication date shown, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` The new paid reset is not a discount or bonus allowance. It pulls the next normal weekly allowance forward, applies immediately, cannot be banked, and changes the automatic reset date. OpenAI does not publish a universal price because checkout price and availability vary by account and country. [Paid weekly resets](https://help.openai.com/en/articles/20001507-paid-weekly-work-and-codex-rate-limit-resets), updated 2026-09-01, accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` No Astra-specific free-token promotion, introductory discount, API credit grant, or Bedrock or Foundry launch rebate was found.

## Confirmed, unchanged

`[OFFICIAL][DEMONSTRATED]` The 2026-09-04 conclusions on Astra's executor-oriented positioning, benchmark headline values, base $10 and $50 API pricing, 272K pricing cliff, cyber Critical classification, advanced-cyber refusal posture, context-management experiment, and announced Daybreak direction remain substantively unchanged; no new evidence requires reversing them. [OpenAI launch post](https://openai.com/index/gpt-6-astra/), [Astra model page](https://developers.openai.com/api/docs/models/gpt-6-astra), and [Astra system card](https://deploymentsafety.openai.com/gpt-6-astra/vision), published 2026-09-03 or live documentation, accessed 2026-09-05.

## Not found after searching

`[OFFICIAL][DEMONSTRATED]` **No CLI release after 0.153.4.** Queries tried: `site:developers.openai.com/codex/changelog "0.153.5"`, `site:github.com/openai/codex/releases "0.154.0"`, `Codex CLI September 5 2026 Astra release`. Registry checked: [Codex changelog](https://learn.chatgpt.com/docs/changelog), accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` **No documented Astra API default effort, verbosity default, or dated snapshot.** Queries tried: `site:developers.openai.com "gpt-6-astra" "default effort"`, `site:developers.openai.com "gpt-6-astra" verbosity`, `site:developers.openai.com/api/docs/models/gpt-6-astra snapshot`. Pages checked: [model guidance](https://developers.openai.com/api/docs/guides/latest-model) and [model page](https://developers.openai.com/api/docs/models/gpt-6-astra), accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` **No Astra-specific Cookbook recipe.** Queries tried: `site:cookbook.openai.com "GPT-6 Astra"`, `site:developers.openai.com/cookbook Astra`, `site:github.com/openai/openai-cookbook gpt-6-astra`. The results led only to developer-blog case studies and general API guidance. [OpenAI Cookbook](https://developers.openai.com/cookbook), accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` **No post-2026-09-04 system-card addendum, Daybreak access change, or refusal-policy update.** Queries tried: `site:openai.com GPT-6 Astra system card addendum September 5 2026`, `site:deploymentsafety.openai.com gpt-6-astra update`, `site:openai.com GPT-6 Astra Daybreak update September 5 2026`. [Astra system card](https://deploymentsafety.openai.com/gpt-6-astra/vision), accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` **No AWS post-launch model card or availability announcement.** Queries tried: `site:aws.amazon.com/bedrock gpt-6-astra`, `site:aws.amazon.com/about-aws/whats-new gpt-6-astra`, `site:docs.aws.amazon.com/bedrock gpt-6-astra`, `Amazon Bedrock GPT-6 Astra model ID`. [AWS model catalog](https://docs.aws.amazon.com/bedrock/latest/userguide/model-cards.html), accessed 2026-09-05.

`[COMMUNITY][DEMONSTRATED]` **No verified OpenRouter listing.** Queries tried: `site:openrouter.ai/models gpt-6-astra`, `site:openrouter.ai/openai gpt-6-astra`, `site:openrouter.ai/docs gpt-6-astra`, `OpenRouter GPT-6 Astra model ID pricing`. [OpenRouter model directory](https://openrouter.ai/models), accessed 2026-09-05.

`[COMMUNITY][DEMONSTRATED]` **No newly published independent SWE-bench, Aider, LiveBench, or LMArena score.** Queries tried: `GPT-6 Astra SWE-bench independent September 5 2026`, `GPT-6 Astra Aider benchmark`, `GPT-6 Astra LiveBench`, `GPT-6 Astra LMArena leaderboard`, plus site-restricted variants for each benchmark.

`[OFFICIAL][DEMONSTRATED]` **No official statement that daily Codex resets still apply.** Queries tried: `site:help.openai.com Astra Codex daily reset`, `site:learn.chatgpt.com Astra daily limits`, `GPT-6 Astra Codex daily allowance reset`. Current documentation instead describes five-hour and weekly allowance mechanics. [Codex pricing](https://learn.chatgpt.com/docs/pricing) and [paid weekly resets](https://help.openai.com/en/articles/20001507-paid-weekly-work-and-codex-rate-limit-resets), accessed 2026-09-05.

`[OFFICIAL][DEMONSTRATED]` **No Astra-specific promotion.** Queries tried: `site:openai.com GPT-6 Astra promotion credits`, `site:help.openai.com Astra promotional usage`, `site:azure.microsoft.com GPT-6 Astra discount`, `site:aws.amazon.com GPT-6 Astra free credits`.

## Sources

1. `[OFFICIAL][DEMONSTRATED]` [OpenAI Astra launch post](https://openai.com/index/gpt-6-astra/), published 2026-09-03, accessed 2026-09-05.
2. `[OFFICIAL][DEMONSTRATED]` [GPT-5.6 and GPT-6 Pro in ChatGPT](https://help.openai.com/en/articles/20001354-gpt-56-and-gpt-6-pro-in-chatgpt), updated 2026-09-05, accessed 2026-09-05.
3. `[OFFICIAL][DEMONSTRATED]` [ChatGPT Work and Codex](https://help.openai.com/en/articles/20001275), updated 2026-09-05, accessed 2026-09-05.
4. `[OFFICIAL][DEMONSTRATED]` [Business models and limits](https://help.openai.com/en/articles/12003714-chatgpt-team-models-limits), updated 2026-09-05, accessed 2026-09-05.
5. `[OFFICIAL][DEMONSTRATED]` [Enterprise and Edu models and limits](https://help.openai.com/en/articles/11165333-chatgpt-enterprise-models-limits), updated 2026-09-05, accessed 2026-09-05.
6. `[OFFICIAL][DEMONSTRATED]` [Codex pricing](https://learn.chatgpt.com/docs/pricing), live page with no publication date shown, accessed 2026-09-05.
7. `[OFFICIAL][DEMONSTRATED]` [Paid weekly Work and Codex resets](https://help.openai.com/en/articles/20001507-paid-weekly-work-and-codex-rate-limit-resets), updated 2026-09-01, accessed 2026-09-05.
8. `[OFFICIAL][DEMONSTRATED]` [Codex changelog](https://learn.chatgpt.com/docs/changelog), relevant entries published 2026-09-04, accessed 2026-09-05.
9. `[OFFICIAL][DEMONSTRATED]` [GPT-6 Astra API model page](https://developers.openai.com/api/docs/models/gpt-6-astra), live page with no publication date shown, accessed 2026-09-05.
10. `[OFFICIAL][DEMONSTRATED]` [GPT-6 Astra model guidance](https://developers.openai.com/api/docs/guides/latest-model), live page with no publication date shown, accessed 2026-09-05.
11. `[OFFICIAL][DEMONSTRATED]` [Prompt caching guide](https://developers.openai.com/api/docs/guides/prompt-caching), live page with no publication date shown, accessed 2026-09-05.
12. `[OFFICIAL][DEMONSTRATED]` [Misalignment monitoring guide](https://developers.openai.com/api/docs/guides/safety-checks/misalignment-monitoring), live page with no publication date shown, accessed 2026-09-05.
13. `[OFFICIAL][DEMONSTRATED]` [GPT-6 Astra system card](https://deploymentsafety.openai.com/gpt-6-astra/vision), published 2026-09-03, accessed 2026-09-05.
14. `[OFFICIAL][DEMONSTRATED]` [Microsoft Foundry Astra announcement](https://azure.microsoft.com/en-us/blog/gpt-6-astra-frontier-intelligence-for-work-now-generally-available-in-microsoft-foundry/), published 2026-09-03, current revision accessed 2026-09-05.
15. `[OFFICIAL][DEMONSTRATED]` [AWS Bedrock model catalog](https://docs.aws.amazon.com/bedrock/latest/userguide/model-cards.html), live page, accessed 2026-09-05.
16. `[COMMUNITY][DEMONSTRATED]` [ARC Prize Astra analysis](https://arcprize.org/blog/astra), published 2026-09-03, accessed 2026-09-05.
17. `[OFFICIAL][DEMONSTRATED]` [Building games with Astra](https://developers.openai.com/blog/how-to-build-games-with-astra), published 2026-09-04, accessed 2026-09-05.
18. `[OFFICIAL][DEMONSTRATED]` [Architectural visualization with Astra](https://developers.openai.com/blog/architectural-visualization-with-astra), published 2026-09-04, accessed 2026-09-05.
19. `[COMMUNITY][ASSERTION]` [OpenRouter rollout report](https://www.reddit.com/r/singularity/comments/1w7e04f/gpt6_astra_is_available_on_openrouter/), published 2026-09-04, accessed 2026-09-05.
20. `[COMMUNITY][ASSERTION]` [Astra token-use report](https://www.reddit.com/r/ChatGPT/comments/1w7etta/astra_is_burning_through_tokens_like_crazy/), published 2026-09-05, accessed 2026-09-05.