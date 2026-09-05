# Lane B: GPT-6 Astra unofficial practitioner evidence, research cutoff 2026-09-04

## TLDR: decisions for our routing

1. **Keep Claude Fable 5.1 as orchestrator and product-judgment model.** Astra reached `67` on Artificial Analysis's Codex Coding Agent Index, while Fable 5.1 reached `70`. Every's launch-day team also preferred Fable 5.1 for its largest tasks and for product intuition, despite using Astra heavily. [COMMUNITY][DEMONSTRATED] [Artificial Analysis](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra), published 2026-09-03, accessed 2026-09-04. [COMMUNITY][ASSERTION] [Every](https://every.to/newsletter?page=6), published 2026-09-03, accessed 2026-09-04.

2. **Route long, tool-heavy coding agents to Astra when Sol stalls.** Astra scored about `2` points above Sol on the Coding Agent Index while using one third of Sol's maximum output tokens. A separate Pokémon run reported `18h 12m` for Astra high versus `96h 35m` for Sol max. [COMMUNITY][DEMONSTRATED] [Artificial Analysis](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra), published 2026-09-03, accessed 2026-09-04. [COMMUNITY][DEMONSTRATED] [Clad3815 run report](https://search.yahoo.co.jp/realtime/search/tweet/2095596013168050551?detail=1&ifr=tl_quotedtw&rkf=1), published 2026-09-03, accessed 2026-09-04.

3. **Do not make Astra the general knowledge default.** On Artificial Analysis's Intelligence Index, Astra and Sol both scored `61`. Astra used about `10%` fewer output tokens but cost `75%` more per evaluated task because its token price was `2.5x` higher. Use Sol, Terra, Luna, or Gemini for ordinary analysis unless Astra's agentic advantages matter. [COMMUNITY][DEMONSTRATED] [Artificial Analysis](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra), published 2026-09-03, accessed 2026-09-04.

4. **Use persistent reasoning state, compacted history, and structured notes.** On ARC-AGI-3, the provider adapter scored between `96.7%` and `99.9%`, while the standard harness ranged from `17.5%` to `62.7%`. Across `167` jointly solved game-reasoning pairs, the adapter used `49%` fewer total tokens and was about `3.66x` faster. The harness mattered more than the effort setting. [COMMUNITY][DEMONSTRATED] [ARC Prize](https://arcprize.org/blog/astra), published 2026-09-03, accessed 2026-09-04.

5. **Start UI and product work at low or medium effort, then escalate selectively.** Every observed that higher effort often added unnecessary labels, buttons, features, and landing-page styling. Astra produced strong visual prototypes, but Fable retained better product taste. [COMMUNITY][ASSERTION] [Every](https://every.to/newsletter?page=6), published 2026-09-03, accessed 2026-09-04.

6. **At high effort, constrain scope, testing, and autonomy explicitly.** OpenAI itself warns that Astra can ask unnecessary clarification questions, over-test, over-format, and respond strongly to conflicting `AGENTS.md` or skill instructions. Practitioner reports describe instruction-following disputes and PR babysitting failures. [OFFICIAL][ASSERTION] [OpenAI model guidance](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra), accessed 2026-09-04. [COMMUNITY][ASSERTION] [Theo practitioner thread](https://zamantika.com/fr/profile/theo), published 2026-09-03, accessed 2026-09-04.

7. **Meter fanout and cap parallel subagents.** Latent Space reported `20B+ tokens` of early-access use, `33 tokens/sec` at max effort, and about `$100 over 2 days` for one monitored workflow. Its claimed `<$6 an hour` estimate counts output generation at `$50.00` per million tokens, but does not capture all input, cache-write, tool, or subagent costs. [COMMUNITY][ASSERTION] [Latent Space](https://www.latent.space/p/astra), published 2026-09-03, accessed 2026-09-04. [OFFICIAL][DEMONSTRATED] [OpenAI model page](https://developers.openai.com/api/docs/models/gpt-6-astra), accessed 2026-09-04.

8. **Use `high` when seeking peak interactive-task score, and test `max` when optimizing cost or action efficiency.** In ARC Prize's provider adapter, high scored `99.9%` at `$18,817`, while max scored `98.6%` at `$17,332`. Max was cheaper, but not the highest-scoring setting. This is ARC-specific evidence, not a universal rule. [COMMUNITY][DEMONSTRATED] [ARC Prize](https://arcprize.org/blog/astra), published 2026-09-03, accessed 2026-09-04.

9. **Do not budget around broad Plus availability yet.** OpenAI's launch language says Plus follows over the next days, but its current product-specific Help article says GPT-6 Pro in Chat is not included with Plus. It lists `200` GPT-6 messages per week for Pro `$200`, a shared `50` per week for Pro `$100`, `15` per month for Business Standard, and `50` per week for Business Premium. Codex and Work allowances are separate. [OFFICIAL][DEMONSTRATED] [OpenAI Help](https://help-lb.openai.com/en/articles/20001354-gpt-56-and-gpt-6-pro-in-chatgpt), updated and accessed 2026-09-04.

10. **Require tests or human review for hardware, financial, and visually plausible outputs.** Astra generated impressive hardware and 3D demonstrations, but an engineer reviewing a shared PCB image called it incomplete and identified improper ground connections. Visual polish is not proof of correctness. [COMMUNITY][DEMONSTRATED] [Reddit electrical-engineering review](https://www.reddit.com/r/singularity/comments/1w6m7hr/gpt6_astra_is_actually_nuts_for_electrical/), published 2026-09-03, accessed 2026-09-04.

11. **Treat creator superlatives as leads, not routing evidence.** Matthew Berman said, "This is the best model I've ever used. Period," but published no effort, token, cost, or success-rate table. Similar launch-day enthusiasm came mostly from invited early-access users. [COMMUNITY][ASSERTION] [Matthew Berman mirror](https://instalker.org/MatthewBerman), published 2026-09-03, accessed 2026-09-04.

## Evidence base and confidence

The first-hand evidence pool is unusually narrow because broad rollout had not completed by the cutoff. I found **9 distinct first-hand source families** that reported actually running Astra: 3 controlled evaluator organizations and 6 practitioner, company, or creator teams. Only Artificial Analysis, ARC Prize, and Epoch AI published recognizable benchmark methodologies or numerical comparisons. [COMMUNITY][DEMONSTRATED] [Artificial Analysis](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra), [ARC Prize](https://arcprize.org/blog/astra), and [Epoch AI benchmark hub](https://epoch.ai/benchmarks), all accessed 2026-09-04.

| User or organization | Credibility and access | Tasks and settings | Numbers and verdict | Grade |
|---|---|---|---|---|
| Artificial Analysis | Independent model-evaluation organization | Coding agents, intelligence, hallucination, long context, analytical work. Multiple efforts, including max | Coding Index `67`, Fable 5.1 `70`. Intelligence Index Astra `61`, Sol `61`. Astra about `70%` more token-efficient than Sol on coding, but `75%` more expensive per Intelligence Index task | [COMMUNITY][DEMONSTRATED], [source](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra), 2026-09-03 |
| ARC Prize | Independent evaluator with pre-release access | ARC-AGI-3 interactive games, standard harness versus provider adapter, all listed efforts | Best standard score `62.7%`. Best adapter score `99.9%`. Adapter `49%` fewer tokens and about `3.66x` faster on jointly solved pairs | [COMMUNITY][DEMONSTRATED], [source](https://arcprize.org/blog/astra), 2026-09-03 |
| Epoch AI | Independent benchmarking organization with pre-release access | Epoch Capabilities Index, math, continual learning, game puzzles, MirrorCode | Reported ECI `169` versus previous best `163`, with the difference within uncertainty around the reasoning-era trend. MirrorCode placed Astra between Opus 4.7 and Fable 5 | [COMMUNITY][DEMONSTRATED], [Epoch AI](https://epoch.ai/benchmarks) and [archived Epoch post](https://zamantika.com/scaling01/status/2095603422971990402), 2026-09-03 |
| Latent Space | AI engineering publication and early-access team | Long-running engineering agents, internal tools, SaaS replacements, finance, game AI, subagent fleets | Claimed `20B+ tokens`, `33 tokens/sec`, `<$6 an hour`, and about `$100 over 2 days` for one workflow | [COMMUNITY][ASSERTION], [source](https://www.latent.space/p/astra), 2026-09-03 |
| Every team, including Dan Shipper | AI product company and publication with launch access | Writing, coding, computer use, visual design, video production, Waterloo 3D experience | Called Astra an upgrade over Sol, but retained Fable 5.1 for biggest tasks and product intuition | [COMMUNITY][ASSERTION], [source](https://every.to/newsletter?page=6), 2026-09-03 |
| Claire Vo | ChatPRD founder and product executive | Browser QA, CRM, Figma-like tools, hardware CLI, Mac application, Blender assets | Reported a six-month product-intelligence problem reaching `90%`, plus multiple one-shot artifacts. No token, effort, or cost disclosure | Artifact [COMMUNITY][DEMONSTRATED], superiority claim [COMMUNITY][ASSERTION], [Lenny's Newsletter](https://www.lennysnewsletter.com/p/gpt-6-astra-is-a-banger-heres-everything), 2026-09-03 |
| Clad3815 | Operator of streamed autonomous Pokémon runs | Pokémon, no RAM access, no hints, no walkthrough, autonomous run. Astra high, Sol max | Astra `18h 12m`, Sol `96h 35m`, GPT-5.5 unfinished after `218h` | [COMMUNITY][DEMONSTRATED], not independently audited, [run report](https://search.yahoo.co.jp/realtime/search/tweet/2095596013168050551?detail=1&ifr=tl_quotedtw&rkf=1), 2026-09-03 |
| Theo | Developer and technical creator associated with T3 Code and Lakebed | Browser game, Blender, repository PRs, latency optimization, longer agent supervision | Claimed over `20` PRs and over `95%` lower round-trip times, but also documented instruction-following and PR babysitting problems | [COMMUNITY][ASSERTION], [source mirror](https://zamantika.com/fr/profile/theo), 2026-09-03 |
| Matthew Berman | AI creator with a large model-testing audience | Games, code, writing, browser, presentations, knowledge work | Reported a Fall Guys clone in `2 prompts`; no controlled protocol, settings, or cost disclosure | [COMMUNITY][ASSERTION], [source mirror](https://instalker.org/MatthewBerman), 2026-09-03 |

Simon Willison is not included in the first-hand count. His launch-day note explicitly says, "I've not tried it yet myself." [COMMUNITY][DEMONSTRATED] [Simon Willison](https://simonwillison.net/2026/Sep/3/gpt6-astra/), published 2026-09-03, accessed 2026-09-04.

## Strengths

### Coding agents and long-running execution

The strongest repeatable result is coding-agent efficiency. Artificial Analysis measured Astra at `67` on its Codex Coding Agent Index, roughly level with Claude Opus 5, Fable 5, and Muse Spark 1.3, but below Fable 5.1 at `70`. Astra used one third of Sol's maximum output tokens and one fifth of Opus 5 xhigh's output tokens. At max effort it cost about the same per coding task as Sol max while scoring about `2` points higher, and less than half as much as Fable 5 at a similar score. [COMMUNITY][DEMONSTRATED] [Artificial Analysis](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra), published 2026-09-03, accessed 2026-09-04.

The Clad3815 Pokémon run is the clearest practitioner-level Sol comparison. Under the operator's claimed conditions of no RAM access, hints, or walkthrough, Astra high reached Champion in `18h 12m`. Sol max took `96h 35m`, and GPT-5.5 had not finished after `218h`. This supports routing Astra to persistent action loops, but it is one environment, one operator, and not an independently audited benchmark. [COMMUNITY][DEMONSTRATED] [Clad3815 run report](https://search.yahoo.co.jp/realtime/search/tweet/2095596013168050551?detail=1&ifr=tl_quotedtw&rkf=1), published 2026-09-03, accessed 2026-09-04.

Latent Space reported coherent engineering work across billions of tokens, active-learning pipelines, deployment debugging, model training, and bounded fleets of specialized subagents. It described building a dozen internal or personal tools, including `4` paid-SaaS replacements. Raw run logs were not available in searchable text, so these remain concrete but self-reported claims. [COMMUNITY][ASSERTION] [Latent Space](https://www.latent.space/p/astra), published 2026-09-03, accessed 2026-09-04.

### Interactive environments and computer use

ARC Prize provides the strongest evidence that Astra can operate effectively in long interactive environments when its reasoning state is preserved. With the provider adapter, every published effort scored at least `96.7%`, compared with a maximum of `62.7%` in the standard harness. Max effort used `51.7%` fewer actions than the human median on average and fewer actions on `96.0%` of levels. [COMMUNITY][DEMONSTRATED] [ARC Prize](https://arcprize.org/blog/astra), published 2026-09-03, accessed 2026-09-04.

Claire Vo demonstrated browser QA, CRM work, design-tool operation, a hardware CLI, a Mac application, and Blender asset creation. Her video chapters place the demonstrations at `03:44`, `09:08`, `13:00`, `15:20`, `18:36`, `22:23`, and `24:24`. The outputs are visible artifacts, but the claim that these were impossible for Sol or Fable is not backed by matched prompts or settings. [COMMUNITY][DEMONSTRATED] [Lenny's Newsletter](https://www.lennysnewsletter.com/p/gpt-6-astra-is-a-banger-heres-everything), published 2026-09-03, accessed 2026-09-04.

### Writing and rapid artifact production

Every called Astra the best writing model its team had tried, describing it as fast, steerable, and low in obvious stylistic filler. The team reported producing a `4,000` word evaluation and accompanying video between `3 AM` and `2 PM` on launch day. Dan Shipper's operational verdict was: "Fable 5.1 still gets my biggest tasks." [COMMUNITY][ASSERTION] [Every](https://every.to/newsletter?page=6), published 2026-09-03, accessed 2026-09-04.

### Reduced hallucination under benchmark conditions

Artificial Analysis measured Astra's hallucination rate on AA Omniscience at `51%` at max effort, compared with `92%` for Sol, while accuracy increased by `4` points. That is a large improvement, but a `51%` benchmark hallucination rate is still unsuitable as a basis for unverified factual decisions. [COMMUNITY][DEMONSTRATED] [Artificial Analysis](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra), published 2026-09-03, accessed 2026-09-04.

## Weaknesses and regressions

### Fable 5.1 still leads at coding ceiling and product judgment

Artificial Analysis puts Fable 5.1 at `70` versus Astra at `67` on the Codex Coding Agent Index. Its broader Intelligence Index puts Fable 5.1 max, with fallback, `5` points above Astra. Every likewise reported that Astra did not match Fable's intuitive prompt interpretation or product-level taste. [COMMUNITY][DEMONSTRATED] [Artificial Analysis](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra), published 2026-09-03, accessed 2026-09-04. [COMMUNITY][ASSERTION] [Every](https://every.to/newsletter?page=6), published 2026-09-03, accessed 2026-09-04.

### Over-engineering and UI bloat

Every found that increasing effort could turn a simple interface into a feature-heavy landing page with unnecessary buttons, labels, and copy. This is particularly important for Codex tasks where higher effort might be assumed to be monotonically better. The current evidence says high effort can increase work while reducing design restraint. [COMMUNITY][ASSERTION] [Every](https://every.to/newsletter?page=6), published 2026-09-03, accessed 2026-09-04.

Theo's recorded discussion explicitly includes sections titled instruction-following problems, an uncommitted-fix debate, PR babysitting failure, and why Fable still wins. Without full raw transcripts, these establish that substantial operational failures occurred but do not support an exact failure rate. [COMMUNITY][ASSERTION] [Theo source mirror](https://zamantika.com/fr/profile/theo), published 2026-09-03, accessed 2026-09-04.

### Regressions outside headline domains

Artificial Analysis reported about `+80 Elo` on AA Briefcase, with better analytical work but lower presentation quality, where Sol max still led. It also reported approximately `+6` points on Humanity's Last Exam, but about `80 Elo` lower on GDPval-AA v2 and regressions of `2` to `3` points on tau3 Banking, SciCode, and AA-LCR. Astra is not a uniform upgrade. [COMMUNITY][DEMONSTRATED] [Artificial Analysis](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra), published 2026-09-03, accessed 2026-09-04.

### Visual plausibility can conceal engineering errors

A Reddit hardware demo was reviewed by a commenter identifying as an electrical engineer with more than `6` years of layout experience. The reviewer said the board was incomplete and that ground was not properly connected. This was an expert review of a displayed artifact, not a direct Astra session, so it demonstrates a verification problem rather than a measured model failure rate. [COMMUNITY][DEMONSTRATED] artifact, [COMMUNITY][ASSERTION] diagnosis, [Reddit thread](https://www.reddit.com/r/singularity/comments/1w6m7hr/gpt6_astra_is_actually_nuts_for_electrical/), published 2026-09-03, accessed 2026-09-04.

### Cost

Official API prices per `1M` tokens are `$10.00` input, `$1.00` cached input, `$12.50` cache writes, and `$50.00` output. Prompts above `272K` are priced at `2x` input and cache rates and `1.5x` output rates. Batch and Flex are `50%` of standard pricing; Fast is `2x`. [OFFICIAL][DEMONSTRATED] [OpenAI model page](https://developers.openai.com/api/docs/models/gpt-6-astra), accessed 2026-09-04.

For generic Intelligence Index work, Artificial Analysis measured a `75%` higher cost per task than Sol despite approximately `10%` fewer output tokens. Astra's value proposition therefore depends on its agent efficiency or its ability to finish tasks cheaper models fail, not on base token efficiency alone. [COMMUNITY][DEMONSTRATED] [Artificial Analysis](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra), published 2026-09-03, accessed 2026-09-04.

No screenshot of an individual Astra API bill was found by the cutoff. The only specific practitioner cost anecdote found was Latent Space's statement that one workflow consumed about `$100 over 2 days`. Its `<$6 an hour` estimate follows from `33 tokens/sec` at the official `$50.00` output price, approximately `$5.94` per hour for output alone. [COMMUNITY][ASSERTION] [Latent Space](https://www.latent.space/p/astra), published 2026-09-03, accessed 2026-09-04.

## Surprises and non-obvious behavior

### Harness design overwhelms effort selection

ARC's standard-harness max score was `62.7%` at `$26,098`, while its provider-adapter high score was `99.9%` at `$18,817`. The adapter was both more successful and cheaper. The main lesson is not simply to select a larger effort value. It is to preserve the model's hidden reasoning state and compact history without reducing it to lossy user-visible notes. [COMMUNITY][DEMONSTRATED] [ARC Prize](https://arcprize.org/blog/astra), published 2026-09-03, accessed 2026-09-04.

ARC observed Astra inventing compact task notes and utility files such as `maze_solver.py`, `combat_solver.py`, `patrol_solver.py`, and `sync_state.py`. This supports giving Astra a stable notes area and permission to build small task-specific tools during long environments. [COMMUNITY][DEMONSTRATED] [ARC Prize](https://arcprize.org/blog/astra), published 2026-09-03, accessed 2026-09-04.

### Max was cheaper, high scored higher

In ARC's provider adapter:

| Effort | Score | Total cost |
|---|---:|---:|
| max | `98.6%` | `$17,332` |
| xhigh | `98.4%` | `$18,147` |
| high | `99.9%` | `$18,817` |
| medium | `98.4%` | `$19,285` |
| low | `98.0%` | `$21,298` |
| none | `96.7%` | `$23,457` |

[COMMUNITY][DEMONSTRATED] [ARC Prize](https://arcprize.org/blog/astra), published 2026-09-03, accessed 2026-09-04.

There is an unresolved settings conflict. ARC published a `none` row, while OpenAI's current model guidance says reasoning effort `none` is unsupported and lists `low`, `medium`, `high`, `xhigh`, and `max`. The most plausible explanations are a pre-release evaluator configuration or an adapter-specific mapping, but neither source documents the reconciliation. The current OpenAI API documentation is more credible for production configuration. [OFFICIAL][DEMONSTRATED] [OpenAI model guidance](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra), accessed 2026-09-04. [COMMUNITY][DEMONSTRATED] [ARC Prize](https://arcprize.org/blog/astra), published 2026-09-03.

Latent Space also refers to Astra at "Ultra", which does not appear in the official effort list. Treat Ultra as an orchestration or Codex preset until documented otherwise. [COMMUNITY][ASSERTION] [Latent Space](https://www.latent.space/p/astra), published 2026-09-03, accessed 2026-09-04.

## Access reality on 2026-09-04

Access remained gated and inconsistent. OpenAI's model page says Trusted Access customers receive Astra first, with the API and consumer plans following over the next days. Reddit users on paid plans reported that the model was still absent, including "not available, even for paid users 5x." These are user reports, not a population-level rollout measurement. [OFFICIAL][DEMONSTRATED] [OpenAI model page](https://developers.openai.com/api/docs/models/gpt-6-astra), accessed 2026-09-04. [COMMUNITY][ASSERTION] [r/codex access thread](https://www.reddit.com/r/codex/comments/1w6izqh/what_the_fuck_is_the_point_of_a_public_release_if/), published 2026-09-03, accessed 2026-09-04.

OpenAI's ChatGPT Help article lists these caps:

- Pro `$200`: `200` GPT-6 messages per week. GPT-5.6 Sol Pro has a separate `170` per day cap, with both models combined limited to `200` per day.
- Pro `$100`: shared `50` per week across GPT-6 Pro and Sol Pro.
- Business Standard: shared `15` per month.
- Business Premium: shared `50` per week.
- At the GPT-6 cap, Pro `$200` falls back to GPT-5.6 Thinking Medium.
- Work and Codex allowances are separate from Chat allowances.

[OFFICIAL][DEMONSTRATED] [OpenAI Help](https://help-lb.openai.com/en/articles/20001354-gpt-56-and-gpt-6-pro-in-chatgpt), updated and accessed 2026-09-04.

No verified Astra-specific rate-limit error string or exact `"Astra unavailable"` response was found. No credible post-release screenshot showing an individual account's Astra API rate-limit error was found. The official API tiers range from Tier 1 at `500 RPM` and `500,000 TPM` to Tier 5 at `15,000 RPM` and `40,000,000 TPM`; Free is unsupported. [OFFICIAL][DEMONSTRATED] [OpenAI model page](https://developers.openai.com/api/docs/models/gpt-6-astra), accessed 2026-09-04.

## Head-to-head comparisons

### Astra versus GPT-5.6 Sol

The evidence favors Astra for coding agents, persistent environments, and reduced hallucination. It does not favor Astra as a general-purpose default. Coding Index was Astra `67`, with about `70%` better token efficiency than Sol. Intelligence Index was tied at `61`, while Astra cost `75%` more per task. [COMMUNITY][DEMONSTRATED] [Artificial Analysis](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra), published 2026-09-03, accessed 2026-09-04.

The Pokémon comparison strongly favors Astra high over Sol max, `18h 12m` versus `96h 35m`, but remains a single operator's environment. [COMMUNITY][DEMONSTRATED] [Clad3815 run report](https://search.yahoo.co.jp/realtime/search/tweet/2095596013168050551?detail=1&ifr=tl_quotedtw&rkf=1), published 2026-09-03, accessed 2026-09-04.

### Astra versus Claude Fable 5.1

Fable 5.1 leads Artificial Analysis's coding index `70` to `67` and leads the Intelligence Index by `5` points at max with fallback. Every preferred Fable for its largest tasks and for product intuition. Astra's counteradvantages were speed, writing, computer use, and cheaper coding performance at approximately the same score as older Fable 5. [COMMUNITY][DEMONSTRATED] [Artificial Analysis](https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra), published 2026-09-03, accessed 2026-09-04. [COMMUNITY][ASSERTION] [Every](https://every.to/newsletter?page=6), published 2026-09-03, accessed 2026-09-04.

Recommended toolkit division: Fable 5.1 plans, adjudicates, and reviews ambiguous product choices. Astra receives bounded implementation missions, persistent interactive environments, and escalations that Sol failed.

### Astra versus Gemini 3.7 and Grok 4.6

**NOT FOUND:** No credible, first-hand, matched-prompt comparison against Gemini 3.7 or Grok 4.6 was located by the cutoff. Searches covered X mirrors, Reddit, Hacker News, newsletters, blogs, and benchmark summaries.

A social-media snippet claimed Gemini 3.8 Flash scored `73.8%` against Astra's `73.3%` on DeepSWE, but it concerned Gemini 3.8, not 3.7, and no matched practitioner run or primary methodology was located. It is excluded from routing evidence.

## Prompting and configuration practices

1. **Preserve state.** Use one durable agent thread, provider-native reasoning continuity where available, compaction, and a concise notes file. ARC shows this can dominate the effect of reasoning effort. [COMMUNITY][DEMONSTRATED] [ARC Prize](https://arcprize.org/blog/astra), published 2026-09-03, accessed 2026-09-04.

2. **State that requests imply action.** OpenAI recommends telling Astra to complete authorized, reversible work before asking for approval because it is more likely than Sol to ask clarification questions or stop where the user expected reasonable assumptions. [OFFICIAL][ASSERTION] [OpenAI model guidance](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra), accessed 2026-09-04.

3. **Audit `AGENTS.md`, skills, and system instructions.** Astra is documented as more sensitive than Sol to skill files and repository instructions. Resolve conflicts and priority ordering before expensive runs. [OFFICIAL][ASSERTION] [OpenAI model guidance](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra), accessed 2026-09-04.

4. **Constrain output form.** Ask for concise paragraphs, plain language, and only necessary sections. OpenAI warns that Astra tends toward detailed formatting and recurring phrases. [OFFICIAL][ASSERTION] [OpenAI model guidance](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra), accessed 2026-09-04.

5. **Define testing boundaries.** Specify the test tier, affected packages, timeout, and stopping condition. OpenAI says Astra tends to test more broadly than needed. [OFFICIAL][ASSERTION] [OpenAI model guidance](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra), accessed 2026-09-04.

6. **Explicitly request or forbid delegation.** OpenAI says Astra may delegate less than expected unless instructed. Latent Space reports success with bounded concurrency and individually tuned subagents, but its cost data is incomplete. [OFFICIAL][ASSERTION] [OpenAI model guidance](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra), accessed 2026-09-04. [COMMUNITY][ASSERTION] [Latent Space](https://www.latent.space/p/astra), published 2026-09-03.

7. **For UI work, specify restraint.** Include "do not add features, labels, sections, buttons, or marketing copy unless requested." This directly targets Every's higher-effort over-engineering observation. [COMMUNITY][ASSERTION] [Every](https://every.to/newsletter?page=6), published 2026-09-03, accessed 2026-09-04.

8. **Use current API controls only.** Tool calling requires the Responses API. Current guidance supports `low`, `medium`, `high`, `xhigh`, and `max`, but not `none`. It says to remove `temperature`, `top_p`, and `top_logprobs`; Chat Completions users should also remove `logprobs`. Prompt-cache TTL is configured as `prompt_cache_options.ttl: "30m"`. [OFFICIAL][DEMONSTRATED] [OpenAI model guidance](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra), accessed 2026-09-04.

## Hype and astroturf screening

No evidence proving paid astroturfing was found. There is, however, strong selection and launch-partner bias. Most positive reports came from organizations or creators with invited access, large audiences, publication incentives, or unusually generous trial limits. [COMMUNITY][ASSERTION] [Latent Space](https://www.latent.space/p/astra), [Every](https://every.to/newsletter?page=6), and [Matthew Berman mirror](https://instalker.org/MatthewBerman), published 2026-09-03, accessed 2026-09-04.

Matthew Berman's broad "best model" verdict lacks settings, tokens, costs, failure counts, or matched baselines. Claire Vo and Every showed useful artifacts but likewise did not publish controlled prompt matrices. Their evidence is good for discovering capabilities and failure modes, but weak for estimating success probability or cost per task. [COMMUNITY][ASSERTION] [Matthew Berman mirror](https://instalker.org/MatthewBerman), [Lenny's Newsletter](https://www.lennysnewsletter.com/p/gpt-6-astra-is-a-banger-heres-everything), and [Every](https://every.to/newsletter?page=6), published 2026-09-03, accessed 2026-09-04.

Anonymous Reddit "AGI" reactions, benchmark screenshots without source links, and comments from people who admitted they lacked access were excluded as usage evidence. One launch thread itself contains skepticism about "trust me bro benchmarks" and confirms many commenters had not used the model. [COMMUNITY][ASSERTION] [r/ChatGPT launch discussion](https://www.reddit.com/r/ChatGPT/comments/1w6ik0i/gpt6_astra/), published 2026-09-03, accessed 2026-09-04.

## Gaps and open questions

- **Public sample size:** Only 9 first-hand source families were located, and only 3 published controlled numerical evaluations. The evidence is not representative of ordinary Pro, Plus, or API users.
- **Codex availability:** NOT FOUND after searching OpenAI Codex issues and pull requests for `astra` and `gpt-6-astra`. No first-party GitHub issue documenting a successful ordinary-user Codex session was found. [GitHub issue search](https://github.com/openai/codex/issues?q=astra), accessed 2026-09-04.
- **Hacker News:** NOT FOUND after searching launch-title, model-id, and comment queries. No substantive launch discussion with first-hand Astra use was indexed by the cutoff. [HN Algolia search](https://hn.algolia.com/?q=%22GPT-6%20Astra%22), accessed 2026-09-04.
- **Discord and Slack:** NOT FOUND after searching for Astra Discord recaps, Slack recaps, run logs, screenshots, and transcripts. No credible public recap containing settings and results was located.
- **Named newsletters:** No relevant first-hand post was found from The Pragmatic Engineer, Ethan Mollick, Zvi, Interconnects, Ben's Bites, The Neuron, or TLDR AI. Simon Willison had not yet tried Astra.
- **Rate limits:** No verified post-release `"Astra unavailable"` error string, `429` body, or rate-limit header screenshot was found.
- **Bills:** No practitioner posted a verifiable Astra API invoice or bill screenshot. Latent Space's `$100 over 2 days` remains self-reported.
- **Effort naming:** ARC's `none` and Latent Space's "Ultra" conflict with the official supported list. Production clients should follow current OpenAI documentation.
- **Computer-use reliability:** Strong demonstrations exist, but there are no published success rates across repeated browser or desktop runs.
- **Security behavior:** No credible practitioner report of sandbox escape, reward hacking, or deliberate scope violation was found. Absence of a report after one day is not evidence of absence.
- **Gemini and Grok:** No first-hand Astra comparison against Gemini 3.7 or Grok 4.6 was found.
- **Long-context economics:** The `1,050,000` context window is documented, but no practitioner published a representative bill for a task exceeding the `272K` pricing threshold. [OFFICIAL][DEMONSTRATED] [OpenAI model page](https://developers.openai.com/api/docs/models/gpt-6-astra), accessed 2026-09-04.

## Sources

1. OpenAI, GPT-6 Astra model page, accessed 2026-09-04: https://developers.openai.com/api/docs/models/gpt-6-astra
2. OpenAI, GPT-6 Astra model and prompting guidance, accessed 2026-09-04: https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra
3. OpenAI Help, GPT-5.6 and GPT-6 Pro in ChatGPT, updated and accessed 2026-09-04: https://help-lb.openai.com/en/articles/20001354-gpt-56-and-gpt-6-pro-in-chatgpt
4. Artificial Analysis, Benchmarking GPT-6 Astra, published 2026-09-03: https://artificialanalysis.ai/articles/benchmarking-gpt-6-astra
5. ARC Prize, GPT-6 Astra on ARC-AGI-3, published 2026-09-03: https://arcprize.org/blog/astra
6. Epoch AI benchmark hub, updated 2026-09-03: https://epoch.ai/benchmarks
7. Epoch AI post mirror, accessed 2026-09-04: https://zamantika.com/scaling01/status/2095603422971990402
8. Latent Space, GPT-6 Astra, published 2026-09-03: https://www.latent.space/p/astra
9. Every newsletter index, Vibe Check: GPT-6 Astra Is a Big Upgrade With Some Bad Habits, published 2026-09-03: https://every.to/newsletter?page=6
10. Dan Shipper and Every launch commentary mirror, accessed 2026-09-04: https://zamantika.com/ko/profile/Hesamation
11. Lenny's Newsletter and Claire Vo, GPT-6 Astra Is a Banger, published 2026-09-03: https://www.lennysnewsletter.com/p/gpt-6-astra-is-a-banger-heres-everything
12. Claire Vo demonstration video: https://youtu.be/AniiF8rOu9c
13. Clad3815 Pokémon run report mirror, published 2026-09-03: https://search.yahoo.co.jp/realtime/search/tweet/2095596013168050551?detail=1&ifr=tl_quotedtw&rkf=1
14. Theo practitioner post mirror, accessed 2026-09-04: https://zamantika.com/fr/profile/theo
15. Matthew Berman post mirror, accessed 2026-09-04: https://instalker.org/MatthewBerman
16. Simon Willison, GPT-6 Astra, published 2026-09-03: https://simonwillison.net/2026/Sep/3/gpt6-astra/
17. Reddit r/codex access complaint, published 2026-09-03: https://www.reddit.com/r/codex/comments/1w6izqh/what_the_fuck_is_the_point_of_a_public_release_if/
18. Reddit r/ClaudeAI launch-access thread, published 2026-09-03: https://www.reddit.com/r/ClaudeAI/comments/1w6g58f/astra_is_out_and_so_are_the_benchmarks/
19. Reddit r/ChatGPT launch discussion, published 2026-09-03: https://www.reddit.com/r/ChatGPT/comments/1w6ik0i/gpt6_astra/
20. Reddit electrical-engineering artifact review, published 2026-09-03: https://www.reddit.com/r/singularity/comments/1w6m7hr/gpt6_astra_is_actually_nuts_for_electrical/
21. GitHub OpenAI Codex Astra issue search, accessed 2026-09-04: https://github.com/openai/codex/issues?q=astra
22. Hacker News Algolia Astra search, accessed 2026-09-04: https://hn.algolia.com/?q=%22GPT-6%20Astra%22