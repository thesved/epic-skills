## Video: Anthropic 与 OpenAI 同一天摊牌：下一场 AI 战争 ..., null
**URL:** https://www.youtube.com/watch?v=uMOcRh1u6aE **Views:** 13861 **Date:** 20260902 **Length:** 16:32
**ADDRESSES GOAL:** partially, provides official benchmark figures, security gating, and comparative context for Astra alongside Claude Fable 5.1 / Mythos 5.1, but lacks direct user workflow scripting.
**HANDS-ON:** no (reaction and analysis of official whitepapers, blog posts, and public developer tweets only)

### Demonstrated findings (with timestamps)
- 00:01: Anthropic API pricing card for Claude Fable 5.1 showing list prices of $10 input / $50 output per 1M tokens, 1M context window, 128k max output.
- 02:05: Lance Martin's post and CursorBench 3.2.0 scatter plot showing Claude Fable 5.1 low effort achieving 66.2% pass rate at $2.90/task, compared to Fable 5 high effort at 66.5% pass rate at $8.77/task.
- 03:52: Anthropic documentation slide showing prompt cache read price reduced from $1.00/1M tokens to $0.25/1M tokens (-75%), saving 25% on typical workloads and up to 45% on repetitive agent workflows.
- 04:23: Artificial Analysis chart plotting Intelligence Index vs Cost per Intelligence Index Task across model configurations.
- 05:18: Terminal-Bench-Science 0.1 benchmark table showing Fable 5.1 scoring 52.6% vs Fable 5 at 24.7% (Opus 5 at 29.0%, GPT-5.6 Sol at 29.0%).
- 06:25: Enterprise case studies screen: Millennium locating an intermittent bug, Ramp running an ML engineer task autonomously for 38 hours, Cognition (Devin) routing traffic to Fable 5.1.
- 07:14: Ethan Mollick's X post displaying the browser game "Cold Watch" generated via Claude Fable 5.1 early access.
- 09:56: Anthropic technical statement comparing Fable 5.1 and Mythos 5.1 (identical base weights, differentiated solely by safety layers).
- 12:23: OpenAI report excerpt ("Path to Astra") showing the Critical cybersecurity capability threshold definition.
- 13:00: ExploitBench (Internal Port June-August 2026) graph showing Astra achieving 100% success rate as output token budget expands to ~120k tokens, compared to GPT-5.6 Sol.

### Asserted claims (with timestamps)
- 00:30: Actual developer task spending dropped by nearly two-thirds when using Fable 5.1 in autonomous agent workflows despite unchanged list token rates.
- 00:50: OpenAI published "Path to Astra" confirming GPT-6 Astra breached the Critical Cybersecurity capability threshold in internal Preparedness Framework evaluations.
- 01:40: Frontier AI evaluation has transitioned from isolated benchmark IQ to long-horizon agent endurance, cost-per-task economics, and security confinement.
- 10:18: Fable 5.1 lowered false positive refusal rates on benign cybersecurity tasks by 60%, allowing vulnerability discovery while strictly blocking exploit payload generation.
- 10:48: Mythos 5.1 is restricted to Project Glasswing for verified security teams and life-science research partners.
- 13:28: Astra raw API access is withheld from public release and isolated inside protected sandbox infrastructure such as "Daybreak Blue".

### Strengths of Astra reported
- 100% success rate on known vulnerability exploitation benchmarks (ExploitBench) (13:03).
- Discovered and successfully exploited two unprompted zero-day vulnerabilities in hardened production-like operating systems and browser targets during internal testing (13:13).
- Executes complex multi-step cyber offensive planning end-to-end from a high-level goal without human intervention (12:44).

### Weaknesses, failures, refusals, costs reported
- Complete access lock: OpenAI refuses public API access due to Critical-level cyber capability risks (01:08, 13:26).
- Gated containment: Deployment is restricted to specialized defense-cleared sandboxes (e.g., Daybreak Blue) (13:36).
- High token consumption required to reach 100% exploit rate (roughly 120k output tokens in demonstrated ExploitBench curves) (13:24).

### How-to-get-the-max tips (effort, prompts, harness, settings)
- Set reasoning effort to "low effort" on long agentic coding tasks rather than default max effort; yields equivalent accuracy at a fraction of token cost (02:14).
- Leverage prompt caching aggressively; repeated agent context reads run at $0.25/1M tokens, driving overall cost down by 25% to 45% (03:52).
- Route benign security audit jobs to public models (Fable 5.1) for vulnerability discovery; avoid requesting exploit tooling to prevent immediate safety refusal trips (10:30).

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- CursorBench 3.2.0: Fable 5.1 (low effort) scored 66.2% at $2.90/task vs Fable 5 (high effort) at 66.5% at $8.77/task (02:23).
- Terminal-Bench-Science 0.1: Fable 5.1 scored 52.6% vs Fable 5 at 24.7%, Opus 5 at 29.0%, and GPT-5.6 Sol at 29.0% (05:27).
- ExploitBench: Astra achieved 100% success rate, significantly outperforming GPT-5.6 Sol (13:03, 13:24).
- Prompt cache pricing: Fable 5.1 cache read is $0.25/1M tokens (-75% vs $1.00/1M on previous generation) (03:56).

### What the comments add (corrections, counter-evidence, first-hand reports)
- @waisiutao8821: Praised the video summary clarity and conciseness.
- @王明典-v9q: Commented on US government interest and regulatory implications regarding restricted cyber-capable frontier models.

### Confidence in this source (1-5) and why
- 3: Presenter does not have hands-on runtime access to GPT-6 Astra or private APIs, but displays authentic slides, charts, and quotes from official OpenAI and Anthropic research papers released on September 1-2, 2026.
