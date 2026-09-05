## Video: OpenAI Declared AGI & World Models Get WILD!, Theoretically Media
**URL:** https://www.youtube.com/watch?v=_uZTCOfaSUk  **Views:** 2  **Date:** 20260903  **Length:** 12:10
**ADDRESSES GOAL:** partially, reviews official Astra release materials, pricing, benchmarks, and comparison points vs Fable 5.1, but lacks direct hands-on testing.
**HANDS-ON:** no (reaction only)

### Demonstrated findings (with timestamps)
* **OpenAI ARC-AGI-3 benchmark chart (01:56):** GPT-6 Astra scored 99.9%, Claude Opus 5 scored 30.2%, GPT-5.6 Sol scored 7.8% (estimated ~30% with harness), and average human scored 48%.
* **Official OpenAI API pricing and availability text (05:27, 05:36):** Standard API pricing is "$10 per million input tokens and $50 per million output tokens." Fast mode delivers "up to 2.5x the speed of Standard processing at 2x the standard price." Model ID is `gpt-6-astra` and also available in Amazon Bedrock.
* **Anthropic usage limits screen (06:58):** Host showed personal Anthropic dashboard showing 47% Fable usage and 26% all models usage consumed in one task.
* **Computer use footage from press kit (02:40 - 05:05):** Screen recordings of Salesforce CRM filling (shown at 4x speed at 02:48), Excel spreadsheet solver (02:58), legal document reformatting (03:19), marketing PDF redesign (03:38), Playco Playbot game iteration (04:00), and Blender/Unreal Engine 5 architectural scene generation (04:42).

### Asserted claims (with timestamps)
* **OpenAI AGI declaration (00:54):** Greg Brockman called Astra a "generational leap" and concluded with "welcome to the AGI era."
* **Training infrastructure (01:06):** Brockman claimed Astra is OpenAI's "largest training run ever" utilizing over 100,000 GPUs at the Stargate site in Texas.
* **Fable 5.1 resource consumption (06:47):** Quoting Justin Schroeder (@jpschroeder): Fable 5.1 is "50% more expensive than Fable 5", has "2.2x more token use", is "2x slower to complete", is "first to watermark your code", and produces "less beautiful output."
* **Benchmark harness impact (02:14):** ARC-AGI-3 results used OpenAI's "responses API harness, which discards past reasoning and past messages," which may have inflated scores.

### Strengths of Astra reported
* Near-perfect benchmark saturation on ARC-AGI-3 (99.9%).
* End-to-end autonomous computer use across CRM workflows, spreadsheet manipulation, document redesign, and 3D environment generation (Blender to Unreal Engine 5).
* Game creation iteration via tools like Playco Playbot.

### Weaknesses, failures, refusals, costs reported
* **Cost:** API is expensive at $10/M input, $50/M output, and $20/M input, $100/M output for Fast mode (05:36).
* **Gated access:** Phased rollout restricted to "Project Daybreak" trusted testers, followed later by Plus, Pro, Business, Enterprise, and API users (05:27).
* **Real-time execution speed:** Promotional computer-use demos were presented at 4x speed, with real-time operations running noticeably slower (02:52 - 03:05).

### How-to-get-the-max tips (effort, prompts, harness, settings)
* **Benchmark harness technique (02:18):** OpenAI's reported top results rely on an API harness that discards past reasoning and previous messages to avoid context contamination during complex interactive tasks.
* **Fast Mode setting (05:36):** For latency-sensitive workflows, use the Fast mode setting for 2.5x speed at 2x price.

### Comparisons vs Fable 5.1 / Sol / others (numbers)
* **ARC-AGI-3:** GPT-6 Astra: 99.9% vs Claude Opus 5: 30.2% vs GPT-5.6 Sol: 7.8% (01:56).
* **Human baseline:** Astra 99.9% vs Average Human 48% (02:24).
* **Fable 5.1 cost and quota:** Fable 5.1 costs 50% more and uses 2.2x more tokens than Fable 5, burning ~40% of weekly quota on single complex runs (06:47 - 06:58).

### What the comments add (corrections, counter-evidence, first-hand reports)
* @DigitalArtMatrix contested OpenAI's claims, stating Astra "doesn't even beat Fable 5; never mind 5.1".
* @LeefyLeefy noted public access will likely be heavily nerfed/filtered compared to unrestricted internal modes.
* @billybowens1 claimed Chinese models will match or exceed Astra capabilities by October.
* @kygo expressed hope that Astra's image pipeline resolves texture artifacts on vegetation.

### Confidence in this source (1-5) and why
**2/5.** The creator provides clear visual documentation of official blog posts, pricing, and benchmark charts, but does not possess hands-on access and relies entirely on marketing materials and second-hand posts.
