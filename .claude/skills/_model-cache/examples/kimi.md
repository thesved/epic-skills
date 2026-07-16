# Kimi K3 / Moonshot (moonshotai/kimi-k3 via OpenRouter)

Researched 2026-07-16 (launch day, model dropped ~24h earlier). Ids/pricing: `../openrouter.md`. Tags: `[off]`=Moonshot/OpenRouter official, `[com]`=community-verified, `[?]`=unverified. Benchmarks are day-zero and thin; re-check when the Artificial Analysis index lands.

---

## What it is

2.8T-param MoE, largest open-weight model to date, multimodal (text+image in), 1M ctx, from Moonshot AI [off]. Positioned for long-horizon agentic work: multi-hour runs, tool swarms [off]. First Kimi priced frontier-tier: $3/$15 per 1M, cache-read $0.30 (0.1x). That is Sonnet-rate, 3-5x GLM-5.2/DeepSeek, and the #1 community complaint.

## Route to / away

**TO it:** high-stakes board/fusion panel upgrade (only open-weight model scoring above Opus 4.8 on GDPval-AA v2, plus Moonshot-family diversity no other seat has); long-horizon agentic browse/search (vendor claims BrowseComp 91.2 single-agent SOTA [off, unreplicated]); 1M-ctx codebase/corpus reads; visible reasoning traces ("debugging ideas far more thoroughly" than Fable, which hides them [com]); strongest open-weight second opinion.
**AWAY:** cost-sensitive bulk (GLM-5.2 claimed "roughly the same quality at a much cheaper price" [com, disputed]; DeepSeek-V4 for basic tasks); latency-sensitive calls (reasoning is MANDATORY with no dial, ~23s measured for a 4-sentence answer); any decision needing verified benchmarks (no AA Intelligence Index yet, contamination skepticism high [com]); media beyond image-in.

## Drive it

- **Reasoning cannot be turned off or down**: mandatory, default-enabled, the ONLY supported effort is `max` [off, OpenRouter model entry]. Unlike Grok there is no cheap-call mode. Budget latency + output tokens accordingly.
- **Param trap:** `temperature` / `top_p` / `seed` are NOT in `supported_parameters` (K2.7-code has them, K3 does not). Send tools / tool_choice / structured_outputs / response_format / stop / penalties / max_tokens; skip sampling knobs.
- **Raw reasoning traces contain unescaped control chars**: `jq` dies parsing the response (`Invalid string: control characters ... must be escaped`, hit live 2026-07-16). Parse with python, or use `openrouter-bridge/ask.sh` which extracts content safely.
- **Single upstream provider** (Moonshot AI itself, no mirrors yet). Launch window = waves of 429 "temporarily rate-limited upstream" lasting minutes; 2 of 8 calls succeeded on launch day. Retry with backoff; BYOK Moonshot key lifts the shared limit.
- **Cost control:** cache-read is 0.1x ($0.30), front-load static context. Watch `usage.completion_tokens`: K2 lineage has documented reasoning-token bloat ("uses a lot of tokens for quite simple tasks" re K2.7 [com]); effective cost can exceed a pricier-per-token model that reasons shorter ("If Sol spends 10K reasoning tokens vs Kimi spends 50K, Sol wins on cost effectiveness" [com, HN]). Unmeasured on K3 yet.
- **Anthropic-compatible API on Moonshot direct** (K2 lineage pattern, api.moonshot.ai; touted for K3 as Claude Code backend) [com/?, unverified for K3].

## Benchmarks (day-zero, treat as provisional)

- GDPval-AA v2: **1687**, behind Fable 5 Max and GPT-5.6 Sol Max (1700+), ahead of Opus 4.8 Max (~1600) [3rd-party].
- AA-Briefcase: **1527**, #2 behind Fable 5 Max, ahead of Sol Max (1495) [3rd-party].
- BrowseComp: **91.2** single-agent, claimed SOTA [vendor, unreplicated].
- No Artificial Analysis Intelligence Index yet (insufficient coverage as of 2026-07-16). Community contamination skepticism: "all open-weight models come with amazing results now... hard to believe anything other than benchmarks leaked into training data" [com].
- Live seat test 2026-07-16 via `ask.sh` (panel-design question + arithmetic): sharp, correct, zero fluff. Qualitative PASS.

## Board / fusion integration (decision 2026-07-16)

**Opt-in high-stakes upgrade, NOT a default panel member.**
```bash
OPENROUTER_FUSION_PANEL="z-ai/glm-5.2,deepseek/deepseek-v4-pro,moonshotai/kimi-k3" \
bash ~/.claude/skills/openrouter-bridge/ask.sh --fusion /tmp/board_brief.md
```
Why not default: launch-day 429 waves on a single provider (a dead seat mid-board), unverified benchmarks, ~5x panel-mate price with unmeasured reasoning bloat, mandatory-max latency.
**Flip to default when ALL hold:** (1) AA Intelligence Index published and frontier-tier, (2) a second OpenRouter provider or a clean week without upstream 429s, (3) measured completion-token usage on a real board brief is sane (< ~3x GLM's for the same brief).

## Sources

- OpenRouter `/api/v1/models` entry + endpoints, live-queried 2026-07-16 (pricing, params, reasoning config, single provider).
- [HN: Kimi K3 is now live](https://news.ycombinator.com/item?id=48935342), 2026-07-16 (reception, quotes, GDPval/Briefcase numbers).
- [TechCrunch: Moonshot's upcoming Kimi 3 expected to close gap with Opus 4.8](https://techcrunch.com/2026/07/16/moonshots-upcoming-kimi-3-is-expected-to-close-the-gap-with-anthropics-opus-4-8/), 2026-07-16.
- [BigGo: flagship K3, 1M context, coding rivals GPT-5.5](https://finance.biggo.com/news/1463f539-2df9-479f-9d17-d6c3a1990722), 2026-07-16 (says 2.5T params; OpenRouter/officechai say 2.8T, went with official).
- [BenchLM Kimi K3](https://benchlm.ai/models/kimi-3), 2026-07 (3 published scores, no global rank).
- [Pandaily preview](https://pandaily.com/kimi-k3-moonshot-ai-model-preview-jul2026), 2026-07 (social benchmark videos, "approaches Fable 5 level" anecdotes).
- Live E2E: 2 successful calls 2026-07-16 (ask.sh + raw curl, 23s latency short answer), 6 rate-limited.
