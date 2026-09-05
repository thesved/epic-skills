## Video: O novo GPT 6 Astra HUMILHOU o Fable 5.1 com apenas 2 dias de vida (Analise Completa), Gabriel Adamuchi - IA Fácil
**URL:** https://www.youtube.com/watch?v=Fb8Q4vddF9o  **Views:** 0  **Date:** 20260904  **Length:** 24:46
**ADDRESSES GOAL:** partially, reviews official benchmarks, costs, and computer-use demos but provides no direct first-hand coding or orchestrator evaluation.
**HANDS-ON:** no (reaction only to the official OpenAI announcement page and embedded interactive widgets)

### Demonstrated findings (with timestamps)
* **02:02**: OpenAI launch page shown reporting Astra saturating FrontierMath Tier 4 at 98%.
* **02:14**: Official benchmarks displayed showing 99.9% on ARC-AGI-3 and 100% on ExploitBench.
* **04:54**: FrontierMath Level 4 (v2) chart displayed: GPT-6 Astra scored 97.6% across reasoning efforts Medium ($0.67 API cost), High ($0.86 API cost), XHigh ($1.20 API cost), and Max ($1.27 API cost). Claude Fable 5.1 scored 87.8% ($4.10 API cost).
* **05:34**: Terminal-Bench 4.0 chart displayed: GPT-6 Astra scored 57.6% on XHigh ($7.48), 57.3% on High ($7.21), and 56.7% on Max ($10.35). Claude Fable 5.1 scored 55.8% on Max ($19.50). Claude Opus 5 scored 52.6% ($18.36). GPT-5.6 Sol scored 37.1% ($7.89).
* **06:33**: Bancada de Automacao (Automation Bench) chart displayed: GPT-6 Astra scored 41.4% ($1.77 API cost) versus Claude Fable 5.1 at 31.4% and Claude Opus 5 at 26.9%.
* **07:48**: ExploitGym HoneyPot test displayed: GPT-5.6 Sol went out of bounds in 48.2% of cases, whereas GPT-6 Astra recorded 0.0%.
* **09:07**: Agent Last Exam chart displayed: GPT-6 Astra reached 59.3% versus Claude Opus 5 at 55.5% and GPT-5.6 Sol at 53.8%.
* **09:41**: ScreenSpot-Pro chart displayed: GPT-6 Astra scored 92.7% on XHigh ($0.09 API cost), 92.6% on Max ($0.09), and 91.6% on Medium ($0.08). GPT-5.6 Sol scored 75.8% on High ($0.034) and 68.7% on Medium ($0.033).
* **10:50**: OSWorld 2.0 Offline chart displayed: GPT-6 Astra scored 72.6% ($1030 API cost), GPT-5.6 Sol scored 65.7% ($820 API cost), and Claude Opus 5 scored 70.2% ($24.11 API cost).
* **18:19**: Testimonial quote from Higgfield AI shown: "utilizando até 20% menos tokens do que outros modelos que testamos".
* **19:35**: Embedded interactive browser kart game ("Tidal Rush") shown and played on-screen.
* **20:06**: Embedded 3D spaceship model viewer with procedural seed generation shown on-screen.
* **21:50**: FrontierCode 1.1 Extended chart displayed: Claude Fable 5.1 scored 64.9% (48.41k output tokens), while GPT-6 Astra scored 64.5% (26.04k output tokens).
* **22:11**: DeepSWE v1.1 chart displayed: Claude Opus 5 scored 73.2% on Extra High, while GPT-6 Astra reached 71.5% on Max effort.

### Asserted claims (with timestamps)
* **00:01**: Asserted that GPT-6 Astra completely humbles Claude Fable 5.1 across all domains.
* **03:16**: Presenter claimed he regularly uses Codex to automate workflows inside HubSpot CRM.
* **03:51**: Asserted rollout is starting with selected enterprise partners, expanding to ChatGPT Plus, Pro, Business, Enterprise, and API on OpenAI and AWS in the following days.
* **09:45**: Asserted that Max reasoning effort is rarely worth the cost increase over XHigh.
* **24:21**: Asserted that OpenAI 20x usage tiers provide 20x the Pro baseline, whereas Anthropic 20x tiers scale from lower baseline limits.

### Strengths of Astra reported
* Highly accurate UI navigation and OS automation (ScreenSpot-Pro 92.7%).
* Strong mathematical reasoning (97.6% on FrontierMath v2 across multiple reasoning effort tiers).
* Zero unauthorized out-of-scope actions in HoneyPot alignment evaluations (0.0%).
* Efficient token usage on coding and complex workflows (around 20% fewer tokens per task).
* Steerability during execution without discarding primary task context.

### Weaknesses, failures, refusals, costs reported
* Raw code benchmarks trail top Anthropic models slightly (64.5% vs 64.9% on FrontierCode 1.1; 71.5% vs 73.2% on DeepSWE v1.1 vs Opus 5).
* Extremely high absolute costs on heavy OSWorld benchmarks ($1030 API run cost).
* Gated rollout limited to select organizations at launch date.

### How-to-get-the-max tips (effort, prompts, harness, settings)
* Set reasoning effort to "XHigh" or "High" instead of "Max" for optimal cost to performance balance (09:45).
* Send mid-task steer prompts without restarting conversations; the model handles directional corrections without abandoning prior instructions (21:07).

### Comparisons vs Fable 5.1 / Sol / others (numbers)
* **FrontierMath v2**: Astra 97.6% ($1.20) vs Fable 5.1 87.8% ($4.10).
* **Terminal-Bench 4.0**: Astra 57.6% ($7.48) vs Fable 5.1 55.8% ($19.50) vs Opus 5 52.6% ($18.36) vs Sol 37.1% ($7.89).
* **Automation Bench**: Astra 41.4% ($1.77) vs Fable 5.1 31.4% vs Opus 5 26.9%.
* **FrontierCode 1.1**: Fable 5.1 64.9% (48.41k tokens) vs Astra 64.5% (26.04k tokens).
* **OSWorld 2.0**: Astra 72.6% ($1030) vs Opus 5 70.2% ($24.11) vs Sol 65.7% ($820).

### What the comments add (corrections, counter-evidence, first-hand reports)
* No comments were provided in the source data.

### Confidence in this source (1-5) and why
**3/5**: The presenter accurately reviews and displays official OpenAI launch data, but lacks independent empirical testing and offers purely reactive commentary.
