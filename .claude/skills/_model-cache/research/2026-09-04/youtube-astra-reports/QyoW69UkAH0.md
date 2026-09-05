## Video: LANÇOU o GPT-6 Astra! Melhor que o Fable?, Matheus Battisti - Hora de Codar
**URL:** https://www.youtube.com/watch?v=QyoW69UkAH0  **Views:** 149  **Date:** 20260903  **Length:** 11:57  
**ADDRESSES GOAL:** partially, provides initial pricing, developer documentation specs, System Card excerpts, and aggregate benchmark slides for GPT-6 Astra, but lacks direct user execution.  
**HANDS-ON:** no (reaction and documentation review only; attempting to open the model in the OpenAI Playground at [08:30] triggered the error: *"The model 'gpt-6-astra' is not available for your org"*).

---

### Demonstrated findings (with timestamps)
- [06:02 - 07:38] Screen share of early tester posts on X showcasing Astra generating Unreal Engine environments (Matt Shumer), 3D Blender models and animations from images (Pietro Schirano), interactive games (Theo, Matthew Berman), Minecraft one-shots (Flavio Adamo), and 3D architectural house designs (Tom Krcha).
- [07:43 - 08:45] Official developer portal documentation (`developers.openai.com`) for `gpt-6-astra`:
  - Context window: 1,050,000 tokens [07:52].
  - Max output tokens: 128,000 tokens [07:52].
  - Knowledge cutoff: April 30, 2026 [07:52].
  - Token pricing: $10.00 / 1M input tokens, $1.00 / 1M cached input tokens, $12.50 / 1M cache writes, $50.00 / 1M output tokens [07:56].
  - Surcharges: Prompts exceeding 270K input tokens are billed at 2x input/cache rates and 1.5x output rates [07:56].
  - Batch and Flex processing offered at 50% discount; Fast mode charged at 2x applicable rates [07:56].
- [08:30] Live attempt to load `gpt-6-astra` in the OpenAI Platform Playground resulted in failure due to org-level gating.
- [08:48 - 09:03] Model guidance documentation detailing initiative handling, tool autonomy, and instruction-following parameters.
- [09:05 - 09:40] Review of the 117-page GPT-6 Astra System Card covering prompt injection defense rates, alignment jailbreak metrics, and safety evaluations.

---

### Asserted claims (with timestamps)
- [00:15 - 00:25] Astra is initially restricted to Trusted Access partners and the Daybreak cybersecurity program; general Plus, Pro, and API rollouts follow in subsequent days.
- [01:37 - 01:50] Model training utilized over 100,000 GPUs at the Texas Stargate facility and marked the first time previous OpenAI models supervised the training run.
- [01:53 - 01:59] OpenAI collapsed its tier naming scheme, launching only Astra and Astra Pro (skipping Luna, Terra, and Sol variant designations).
- [02:00 - 02:15] Greg Brockman declared at the press briefing: *"Bem-vindos à era da AGI"* ("Welcome to the AGI era"), framing AGI as an internal mission milestone rather than a contractual Microsoft clause.
- [04:26 - 05:11] Astra shifts primary optimization from pure code generation to general computer use and desktop application control (KiCad, Excel, Blender, Power BI).

---

### Strengths of Astra reported
- **Computer use and OS navigation:** Achieves 72.6% on OSWorld v2 (demonstrated on slide at [04:26]).
- **Execution speed on web tasks:** 1.9x faster completion on Mind2Web benchmarks utilizing OpenAI's new agentic harness [04:26].
- **Task latency:** Reduces average task duration from 75 minutes down to 40 minutes [04:26].
- **Benchmark claims reported from X:** 99.8% on ARC-AGI 3, 98.6% on hard math, and 100% on ExploBench [06:51].

---

### Weaknesses, failures, refusals, costs reported
- **High base token price:** $10.00/1M input and $50.00/1M output, making casual use expensive [03:09, 07:56].
- **Large-context penalty:** Prompts >270K input tokens incur a 2x input multiplier and 1.5x output multiplier [07:56].
- **Immediate access gating:** Unavailable on release day to standard ChatGPT Plus/Pro subscriptions or generic API developer tiers [00:20, 08:30].
- **Session consumption:** Expected to exhaust API balances and standard rate limits rapidly during long reasoning or computer use sessions [03:34].

---

### How-to-get-the-max tips (effort, prompts, harness, settings)
- **Harness integration:** Utilize the specialized Mind2Web harness framework to achieve up to 1.9x task acceleration [04:26].
- **Reasoning Effort settings:** Model guidance supports reasoning tiers ranging from `low`, `medium`, `high`, up to `max` depending on problem difficulty [07:52].
- **Cost optimization:** Route non-realtime asynchronous tasks to Batch or Flex endpoints for a 50% discount [07:56].
- **Avoid large single-shot contexts:** Keep input prompts under 270,000 tokens to avoid the automatic 2x penalty rate [07:56].

---

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- **API Input/Output pricing:**
  - GPT-6 Astra: $10.00 input / $50.00 output per 1M tokens [03:09].
  - Claude Fable 5.1: $10.00 input / $50.00 output per 1M tokens (parity) [03:09].
  - GPT-5.6 Sol: Astra is 2.5x the promotional price of Sol [03:09].
  - Muse: $1.25 input / $4.25 output per 1M tokens [03:09].
  - Gemini 3.8 Flash: $0.75 input / $3.75 output per 1M tokens [03:09].
- **Prompt Caching:**
  - Astra cached input is $1.00/1M tokens [07:56]. Battisti notes Claude Fable caching is significantly cheaper ($0.25/1M tokens asserted at [08:03]).
- **OSWorld v2 Benchmark:**
  - GPT-6 Astra: 72.6% [04:26].
  - GPT-5.6 Sol: 65.7% [04:26].

---

### What the comments add (corrections, counter-evidence, first-hand reports)
- **Access status:** @GuLuppi reports early verification: *"Minha conta faz parte do programa Daybreak, já iniciando os testes."*
- **Cost complaints:** @joao.zorzetti highlights high operating expense: *"Esses modelos são só pra esbanjar status, porque é impossível usar sem ter um orçamento infinito. 1 prompt acaba o saldo."*
- **Skepticism on reliability:** @leandroalmeida1210 argues against AGI marketing claims: *"essas i.a tao muito longe de ser AGI. alucinam muito em coisas complexas."*
- **Course promotion:** @MatheusBattisti pinned a link promoting his Claude Code training course.

---

### Confidence in this source (1-5) and why
**2/5**  
The presenter did not have hands-on access to the model, attempted to run it live in the playground, and was blocked by access controls. The technical specs (pricing tables, context limits, long-context surcharges) are accurately captured directly from the live developer documentation and system card, but all performance and benchmark claims are secondary aggregations from social media posts and OpenAI marketing slides.
