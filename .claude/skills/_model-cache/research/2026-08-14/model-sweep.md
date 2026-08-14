# Model sweep 2026-08-14: Grok 4.6, Opus 5 quirks, new drops

Learning report (history + evidence live HERE; operating changes went to the cache/skill files, kept terse). Lanes: cache diff (`update.sh`), 2 YouTube deep-reads (Gemini), codex gpt-5.6-sol web sweep, own WebSearch verification.

## TLDR (what changed for us)

1. **Opus 5 is out (July 24), replaces Opus 4.8 as our review seat.** Same price ($5/$25), near-Fable intelligence at half price, 1M ctx / 128k out. Cache table updated.
2. **Grok 4.6 (Aug 12): smarter but slower + hidden cost hike.** AAI 61 (= Sol, 2 behind Fable). Unit price flat $2/$6 but ~30% more tokens/run → ~2x real task cost ($0.84/task), cache read $0.30→$0.50. Lost the 4.5 speed edge. Route-to/away updated in `examples/grok.md`.
3. **Gemini 3.7 Flash (Aug 13): new workhorse, half price intro.** $0.75/$3.75 until end 2026 (then ~2x), stronger coding/agents. Live-verified on our key. 3.5 Pro still delayed.
4. **DeepSeek direct API goes time-variable 2026-08-16 16:00 UTC**: peak $1.32/$3.96, off-peak $0.66/$1.98 vs $0.435/$0.87 flat now (primary source api-docs.deepseek.com; SCMP's "12x" headline compares vs cache-hit floor). Our board seat rides OpenRouter; provider pass-through likely. Re-verify seat cost after Aug 16.
5. **Kimi K3 keeps the open-weight crown, narrowly**, over new Qwen3.8-Max (2.4T-A95B). No seat flip.
6. **Opus 5 quirk cluster confirmed** (jargon, verbosity, style drift). Caveman solves 2 of 3; drift needs output-style-level injection (auto-reinforced), not CLAUDE.md lines.

**Benchmark-index caveat (binding for every number below).** AA-style composite indexes average saturated benchmarks and compress the one axis that separates frontier models: how hard a problem gets finished UNSUPERVISED. Index deltas of 1-5 pts = noise; ordering at the top is not trustworthy. User practice calibration 2026-08-14: **Fable ~2x Opus 5 on real long-horizon work despite AA showing 62 vs 63 the other way.** Opus 5's "surpasses Fable" rows (OSWorld, Frontier-Bench) are Anthropic's own marketing benches. Rank by cost-per-COMPLETED-task and observed unsupervised horizon; use index numbers only for big moves (Grok +5, non-hallucination +20) and direction. Memory: `feedback-benchmark-indexes-weak`.

---

## 1. Grok 4.6 (xAI, released 2026-08-12)

Facts (official + Artificial Analysis + Theo t3.gg video, see sources):
- AAI Intelligence Index **61** (+5 vs 4.5): parity with GPT-5.6 Sol (61), behind Fable 5 (62) and Opus 5 (63).
- SWE-bench (Vals) **95.6%** (+~9 pts vs 4.5, strongest verified gain). DeepSWE 65.9% (Fable 70.0, Sol 73.0). CursorBench 3.2: 69.9% (beats Sol 67.2, trails Fable 70.5).
- **Not a new pretrain**: post-training/RL update on Grok 4.5, using RL pipelines from xAI's Cursor acquisition (Theo, 03:25).
- Context 500k (unchanged). Price $2/$6 under 200k prompt; faster variant 2x; **cache read $0.30 → $0.50**.
- **~30% more output tokens per run** than 4.5 → task cost roughly doubled to ~$0.84/task (vs Kimi K3 $0.84, Fable $3.14). The famous 4.5 near-instant speed is gone (Theo 10:20-11:10, 22:53).
- Strong: knowledge work, legal, repo-wide audits/comprehension. Weak: **terminal use** (AA), **frontend/UI taste** ("disgusting and sinful" vs Fable/Sol, Theo 13:36), **3D/canvas** (blank-screen first pass, inverted controls, 15:37-16:33).
- Grok 4.7 teased ~3-4 weeks out, w/ SpaceX company data (Musk tweet, speculative).
- Community pushback: consumer sub ($30-40/mo) rate-limits hard; API is the usable surface.

**Routing consequence** (applied to grok.md): Grok's old niche = cheap+fast utility lane is DEAD (slow now); new niche = cheap Opus-class repo-audit / knowledge-work lane at ~1/4 Fable task cost. Never UI/3D.

Sources: [kingy.ai Grok 4.6 guide](https://kingy.ai/blog/grok-4-6-price-benchmarks-api-cursor-context-window/) (2026-08); [MarkTechPost](https://www.marktechpost.com/2026/08/12/spacexai-releases-grok-4-6/) (2026-08-12); [OpenRouter endpoint](https://openrouter.ai/x-ai/grok-4.6); Theo, [youtube c7W8jpsjtCc](https://www.youtube.com/watch?v=c7W8jpsjtCc) (2026-08).

## 2. Anthropic: Opus 5 + quirk cluster

- **Opus 5 shipped 2026-07-24**, id `claude-opus-5`, $5/$25 (unchanged vs 4.8), 1M ctx, 128k out. Anthropic's line: near-Fable at half price; OSWorld 2.0 above Fable at 1/3 cost; behind Fable on cybersecurity tasks. Opus 4.1 retired (API errors now).
- **Quirk cluster** (RoboNuggets video HH6QqWyXJu8 + comments, corroborated by X posts it cites):
  1. **Jargon density**: narrow-domain acronyms in answers to simple questions (demo 00:43).
  2. **Verbosity**: essay-length answers to trivial questions ("its own novel", "harry potter book every time"; demo 02:14).
  3. **Style drift**: output-format rules in CLAUDE.md get ignored as context grows (06:38).
- **Mitigation map** (the useful part):
  - Quirks 1-2: solved by terse/plain-language style = our caveman skill already covers.
  - Quirk 3: NOT solved by prompt lines. Claude Code's `/config → Output style` (`~/.claude/output-styles/*.md`) is auto-reinjected mid-session, so it survives long contexts where CLAUDE.md rules fade. Video also warns: a GLOBAL terse rule cripples plan/code quality; keep terse as default style but allow full-detail for plans (our caveman already scopes this; keep tech terms exact).
  - Skeptic signal: @rezakaaccount claims style overrides don't work at all; @lordthrakazog reports drift even WITH output styles. So output-style is mitigation, not cure.
- Anthropic claims Opus 5 is "cleaner and more concise" than 4.8; community says the opposite in practice. Classic official-vs-lived gap: benchmark-tuned "thoroughness" reads as bloat in daily use.

Sources: [anthropic.com/news/claude-opus-5](https://www.anthropic.com/news/claude-opus-5) (2026-07-24); RoboNuggets, [youtube HH6QqWyXJu8](https://www.youtube.com/watch?v=HH6QqWyXJu8) (2026-08); [blog.mean.ceo Opus news](https://blog.mean.ceo/claude-opus-news-august-2026/) (2026-08).

## 3. OpenAI / Codex

- Early Aug: ChatGPT surface merged Instant+reasoning into one **updated Sol** ("more focused answers, improved factual reliability, reasoning-effort slider"); Luna default+unlimited for Free/Go.
- **Codex CLI deprecation: gpt-5.4 / 5.4-mini removed 2026-08-31** for ChatGPT-login users → replacements gpt-5.6-terra / gpt-5.6-luna. Our picks (sol/terra) unaffected.
- Codex CLI: this build has NO `--search` flag; web search = `-c tools.web_search=true` (bit us this sweep; recorded in codex-bridge).

Sources: [OpenAI GPT-5.6](https://openai.com/index/gpt-5-6/); [Codex changelog](https://developers.openai.com/codex/changelog) (2026-08).

## 4. Google Gemini

- **Gemini 3.7 Flash, 2026-08-13**, three weeks after prior Flash: coding/debugging/agent focus, "production-ready code first try" claim, beats comparable Anthropic/OpenAI models on 9 benchmarks (Google's own framing).
- **Intro price $0.75/$3.75 per Mtok until end of 2026** = half of predecessor launch price; expect ~2x in 2027.
- Live-verified on our paid key 2026-08-14 (`OK gemini-3.7-flash` via ask.sh).
- **Gemini 3.5 Pro still delayed** (Bloomberg): flagship gap persists; 3.1-pro-preview stays our Gemini reasoning pick.

Sources: [SiliconANGLE](https://siliconangle.com/2026/08/13/google-launches-gemini-3-7-flash-coding-ai-agent-projects/) (2026-08-13); [9to5google](https://9to5google.com/2026/08/13/gemini-3-7-flash-launch/) (2026-08-13); [Bloomberg on 3.5 Pro delay](https://www.bloomberg.com/news/articles/2026-08-13/google-debuts-new-gemini-flash-while-top-ai-model-still-delayed) (2026-08-13).

## 5. Open-weight movers

- **DeepSeek V4 Pro GA = 0813 snapshot (2026-08-12)**, ends 4-month preview. 1.6T MoE / 49B active, 1M ctx, 384k max out. "Significantly enhanced agent capabilities"; AAI 53 (= GLM-5.2, 4 behind Terra). SCMP: weak on general benchmarks, shines in cybersecurity.
  - **PRICE TRAP: DeepSeek direct API time-variable from 2026-08-16 16:00 UTC**: peak $1.32/$3.96, off-peak $0.66/$1.98 (vs $0.435/$0.87 flat now). OpenRouter: 16 providers for this model, 4x price spread, 4-57 tok/s (OR's own data): pin the provider. ACTION: re-check board-seat economics after Aug 16; off-peak/batch for bulk.
- **Qwen3.8-2.4T-A95B ("Qwen3.8-Max")**: open-weight, 2.4T MoE / 95B active, 262k ctx (1M ext). PaperBench 93.0 (beats Sol 90.5, Fable 88.8); Terminal Bench 2.1 86.6 (beats Opus 4.8/Fable, behind Sol-max). Serious model.
- **Open-weight crown**: Kimi K3 still #1, narrowly (BenchAlign v5 80.2 vs Qwen 79.6; LLM Stats open leaderboard 55.4; Arena Frontend Code ~1679 ELO #1). Qwen cheaper + more multimodal; K3 clearer SWE record. **No board-seat flip**; Qwen3.8 = candidate, watch independent benches (still in progress).
- **ByteDance Seed 2.1 Turbo** now on OpenRouter (released June 24): multimodal (text/image/video in), 256k ctx, coding/agent focus, single provider. Interesting as a cheap multimodal-agent fallback; not displacing anything yet.

Sources: [SCMP](https://www.scmp.com/tech/big-tech/article/3363895/deepseeks-updated-v4-pro-ai-model-struggles-benchmarks-shines-cybersecurity) (2026-08); [simonwillison.net](https://simonwillison.net/2026/Aug/12/deepseek-v4-pro-0813/) (2026-08-12); [MindStudio Qwen3.8](https://www.mindstudio.ai/blog/qwen3-8-2-4t-a95b-model-overview) (2026-08); [BenchLM Chinese models](https://benchlm.ai/best/chinese-models) (2026-08); [datanorth Seed 2.1](https://datanorth.ai/news/bytedance-releases-seed-2-1-pro-and-seed-2-1-turbo) (2026-06).

## 6. Practitioner meta

- "**Plan with Fable, build with Sonnet**" is now the mainstream published pattern (MindStudio, claude-world, productcompass, all Aug 2026). Our fable-max delegate mode is a superset (sol executor + sub-metering); nothing to import, validates the design.
- Multi-model stacks appearing in the wild: "Fable as orchestrator, Sol 5.6 as subagents" (top YT comment @yevgenitiger); defections from Opus verbosity to Sol/Codex are a visible migration current.
- Fable 5 API $10/$50 w/ 90% cache-read discount (confirmed unchanged, 2026-08-07 review).

## Inversion (how this sweep could burn us)

- **Trusting Grok 4.6's flat unit price as "same cost":** real cost/task ~2x via token inflation. Unit price is the wrong metric; cost-per-TASK is the routing input. (Same trap as reasoning-token billing, 2026-08-12 research.)
- **Keeping the old "Grok = fast lane" reflex**: the speed edge is gone; routing by stale vibes silently doubles latency.
- **Reading Google's intro price as the price**: $0.75/$3.75 expires end 2026; any cost model built on it breaks in Jan.
- **DeepSeek seat "cheap" assumption goes stale on Aug 17** at up to 12x peak.
- **Believing the official "cleaner and more concise" line on Opus 5**: lived reports say opposite; test, don't quote.

## Codex-lane extras (gpt-5.6-sol web sweep; full raw report w/ sources: `codex-lane.md`)

Findings my lanes missed, all sourced in codex-lane.md:

- **Grok 4.6 has NO official model card or changelog**: every spec (pricing tiers, tools, context) is community-inferred. >200k prompt: $4/$12. Non-hallucination score jumped 45.9 → 65.7 (AA). Terminal-Bench 3.0 ~26% vs ~34% Sol/Fable = terminal-away confirmed twice.
- **Grok 4.6 API prose is overly CURT** (opposite of its token-hungry reasoning): community sampling fix `temperature=1, top_p=0.8, min_p=0.05` (added to grok.md). Both are true at once: verbose thinking, terse prose.
- **Sonnet 5 intro price $2/$10 ends 2026-08-31 → $3/$15**; its tokenizer counts 1.0-1.35x more tokens for identical text (real price is higher than the sticker).
- **OpenRouter Terra/Luna ~50% promo**: Terra ~$1/$6, Luna ~$0.10/$0.60. Expiry UNVERIFIED. Luna at that price = absurd bulk-mechanical lane; check live route price before relying (OR support: developer promos don't always propagate).
- **OpenAI July 30 permanent cuts**: Terra $2/$12 (-20%), Luna $0.20/$1.20 (-80%), Sol unchanged $5/$30. Codex catalog: gpt-5.3-codex still top coding model ($1.75/$14, 400k ctx); no GPT-5.6-codex exists.
- **Claude Code v2.1.219 allows nested subagents to depth 3** (was 1). If verified, our delegation.md failure rule 4 ("wrappers cannot spawn wrappers") is stale. TEST before relying.
- **Opus 5 quirk detail**: instruction loss / subtle bugs cluster around 100-150k context; "run Opus 5 at LOW effort" is a community fix for overengineering + scope creep. Disputed: some users report zero problems (harness/config variance).
- **Fable 5 falls back to Opus 4.8 in <5% of sessions** (official); practitioners pin model versions because silent fallbacks change behavior mid-task (matches our security-refusal-downgrade rule).
- **Gemini 3.6 Flash existed** (July 21, -17% output tokens, $1.50/$7.50): we skipped it entirely; 3.7 supersedes. 3.5 Pro "coming soon" since I/O May; cancellation rumor UNVERIFIED.
- **Codex CLI 0.147+**: portable Agent Plugins, `/import` from Claude Code + Cursor (2026-08-11), remote compaction, secret redaction. Cross-tool skill portability is becoming first-class.
- **Explicit tool-call batching in AGENTS.md** ("batch independent calls, Promise.all style") reportedly cuts Codex tool cycles ~52-55%, credits 24-45% (single experiment, UNVERIFIED).
- **Community routing consensus mirrors ours**: Luna explore → Terra implement → Sol review, Claude for architecture; independent cross-model review passes catch disjoint failure modes (our 2026-07-12 evidence, now folk knowledge).

## Verify-later ledger

- [ ] After 2026-08-16 16:00 UTC: DeepSeek board-seat cost via OpenRouter (peak pass-through?).
- [ ] OpenRouter Terra/Luna 50% promo: check live endpoint price + expiry before building on it.
- [ ] Claude Code nested-subagent depth 3: forward-test, then update delegation.md rule 4 if real.
- [ ] Grok 4.7 (~early Sept): re-run route-to/away; check token inflation + terminal weakness.
- [ ] Qwen3.8-Max independent benches mature → revisit high-stakes board seat.
- [ ] Gemini 3.5 Pro release (or confirmed cancellation) → re-verify Gemini reasoning pick.
- [ ] 2026-08-31: Sonnet 5 $3/$15; gpt-5.4/-mini pulled from Codex CLI.
- [ ] 2027-01-01: Gemini 3.7 Flash doubles to $1.50/$7.50.
