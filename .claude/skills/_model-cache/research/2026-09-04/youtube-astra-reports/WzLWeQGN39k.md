## Video: Anthropic JUST DROPPED Fable 5.1!! + OpenAI Says Astra Is NEXT?!, ByteForward
**URL:** https://www.youtube.com/watch?v=WzLWeQGN39k  **Views:** 9314  **Date:** 20260901  **Length:** 5:00
**ADDRESSES GOAL:** partially, covers OpenAI's pre-release Astra safety disclosure benchmarks and gating alongside Fable 5.1 details, but does not provide hands-on GPT-6 Astra routing recipes.
**HANDS-ON:** no (reaction only)

### Demonstrated findings (with timestamps)
- 0:59: Displayed Anthropic's Terminal-Bench-Science 0.1 graph showing Fable 5.1 scaling from ~27% at low effort to 52.6% at max effort ($38 cost per task) vs Fable 5 at 24.7% ($44 cost per task).
- 1:10: Displayed CursorBench 3.2.0 accuracy vs cost graph: Fable 5.1 reaches 73.4% at max effort ($9.64 cost per task) vs Fable 5 reaching 70.5% at max effort (~$19 cost per task).
- 1:15: Displayed benchmark comparison table:
  - Agentic scientific research (Terminal-Bench-Science 0.1): Fable 5.1 at 52.6%, Fable 5 at 24.7%, Opus 5 at 29.0%, GPT-5.6 Sol at 22.4%.
  - Agentic coding (Terminal-Bench 4.0): Fable 5.1 at 55.8% (Mythos 5.1 at 60.9%), Fable 5 at 42.0%, Opus 5 at 52.3%, GPT-5.6 Sol at 37.3%.
  - Knowledge work (GDPval-AA v2): Fable 5.1 at 1853, Fable 5 at 1723, Opus 5 at 1824, GPT-5.6 Sol at 1711.
  - OSWorld 2.0 (partial / strict): Fable 5.1 at 77.9% / 41.7%, Fable 5 at 72.9% / 36.1%, Opus 5 at 75.4% / 39.6%.
  - Humanity's Last Exam (no tools / with tools): Fable 5.1 at 60.9% / 65.0%, Fable 5 at 57.8% / 63.8%, Opus 5 at 56.6% / 63.6%.
  - AutomationBench: Fable 5.1 at 31.4%, Fable 5 at 17.1%, Opus 5 at 26.9%, GPT-5.6 Sol at 19.6%.
  - CursorBench 3.2.0: Fable 5.1 at 73.4%, Fable 5 at 70.5%, Opus 5 at 70.0%, GPT-5.6 Sol at 67.2%.
- 2:17 - 2:45: Displayed 3D scene benchmark generation costs comparing Claude Fable 5.1 vs GPT-5.6 Sol: Island Mansion ($1.41 vs $0.15), Grand Hall ($1.04 vs $0.18), Pool & Water Park ($1.20 vs $0.18), Lambo Garage ($0.94 vs $0.18), Helipad ($1.10 vs $0.18).
- 3:26: Displayed OpenAI system card chart "ExploitBench - Internal Port (June-August 2026)": Astra reaches 39.0% completion at 76,188 output tokens (peaking around 40% near 90k tokens) vs GPT-5.6 Sol reaching ~12% at 140k tokens.
- 4:02: Displayed alignment charts: Circumventing auto-review (GPT-5.6 Sol 5.3% vs Astra 0.0%); ExploitGym honeypot (GPT-5.6 Sol 56.0% honeypot exploitation attempts vs Astra 1.3%).

### Asserted claims (with timestamps)
- 0:41: Asserted Claude Fable 5.1 and Mythos 5.1 share the same underlying model, differing only in safeguards and access restrictions.
- 1:28: Quoted Millennium case study claiming Fable 5.1 resolved a rare 1-in-a-million software crash unexplained for 4 to 5 years by disassembling vendor libraries against core dumps.
- 2:08: Asserted Fable 5.1 defaults to high effort in Claude Code and medium effort in claude.ai and Cowork.
- 2:20: Stated API pricing: $10/M input, $50/M output, prompt cache reads reduced 75% to $0.25/M tokens; context window is 1M tokens with 128k output.
- 3:11: Stated OpenAI declared Astra the first model reaching the Critical cybersecurity capability threshold under its Preparedness Framework.
- 3:55: Asserted advanced cybersecurity features in Astra are restricted via the Daybreak Blue access program.

### Strengths of Astra reported
- Scored 100% on ExploitBench (3:22).
- Discovered two zero-day vulnerabilities and constructed full exploit chains on hardened environments (3:40).
- Highly token-efficient in exploitation tasks compared to GPT-5.6 Sol (3:26).
- Zero successful circumventions of auto-review (0.0% vs 5.3% for GPT-5.6 Sol) (4:02).

### Weaknesses, failures, refusals, costs reported
- Astra refuses 91.5% of cyber jailbreak evaluation requests (3:48).
- Safeguards introduce friction, automatically pausing or stopping tasks in ChatGPT, Codex, and API during extended agent runs or flagged actions (4:11).
- Advanced cyber capabilities are restricted from general release under Daybreak Blue (4:06).

### How-to-get-the-max tips (effort, prompts, harness, settings)
- Note effort configurations: Claude Code defaults Fable 5.1 to high effort, while web surfaces default to medium effort (2:08).
- Expect automated pause checkpoints in Codex and ChatGPT when Astra triggers misalignment classifiers on long-running tasks (4:11).

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- Agentic coding (Terminal-Bench 4.0): Mythos 5.1 (60.9%) > Fable 5.1 (55.8%) > Opus 5 (52.3%) > Fable 5 (42.0%) > GPT-5.6 Sol (37.3%) (1:15).
- ExploitBench Internal Port: Astra peaked near 40% at ~90k tokens; GPT-5.6 Sol reached ~12% at 140k tokens (3:26).
- Cyber jailbreak refusals: Astra refuses 91.5% vs GPT-5.6 Sol at 59% (3:48).
- Honeypot exploit evasion: Astra attempted honeypots only 1.3% vs GPT-5.6 Sol at 56.0% (4:02).

### What the comments add (corrections, counter-evidence, first-hand reports)
- Real-world debugging report: @chrisdonnell2575 used Fable 5.1 to find 6 bugs in a 2-month-old Rust Nasdaq order entry trading DOM, taking 8 hours to resolve with 5 agents.
- Commentary on model posture: @ralphandrewsellote noted Anthropic prioritized release speed and lower cache prices, whereas OpenAI gated Astra due to critical risk ratings.

### Confidence in this source (1-5) and why
- 3/5. The presenter did not have hands-on access to Astra, strictly reviewing OpenAI's pre-release safety whitepaper and Anthropic's release documentation. Benchmark data shown on screen is accurate to official publications.
