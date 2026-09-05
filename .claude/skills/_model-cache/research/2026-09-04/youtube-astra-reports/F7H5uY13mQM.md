## Video: O GPT-6 ASTRA Acabou de QUEBRAR a Internet (AGI Chegou?), Felipe Borges - Fala IA!
**URL:** https://www.youtube.com/watch?v=F7H5uY13mQM  **Views:** 160  **Date:** 20260903  **Length:** 16:28
**ADDRESSES GOAL:** partially, provides initial launch details, official benchmark charts, and pricing tiers compared to Fable 5.1 and GPT-5.6 Sol, but contains no direct hands-on testing or execution metrics.
**HANDS-ON:** no (reaction only to Nate's English video, OpenAI announcement blog, and Reddit threads; presenter explicitly states at 00:09 "não chegou para mim nem chegou para você").

---

### Demonstrated findings (with timestamps)
- **Official video demo clip shown:** At 04:58-05:10, OpenAI promotional video footage demonstrates Astra performing multimodal prompt interactions ("Cria um círculo amarelo ali... transforma em janela... agora vou obter o modelo 3D").
- **Benchmark charts displayed on screen:**
  - **Terminal-Bench Science 0.1** (07:05): Graph comparing API Cost vs Benchmark Score across GPT-6 Astra, GPT-5.6 Sol, Claude Fable 5.1, and Claude Fable 5. Astra shows higher performance at lower cost relative to Fable 5.1.
  - **ARC-AGI-2** (08:42): Bar chart displaying Astra significantly higher than Claude Fable 5 and GPT-5.6 Sol.
  - **FrontierMath Tier 4 (CoT)** (08:43): Accuracy curves across test budgets.
  - **AutomationBench** (08:44): Performance scaling curves across API cost.
  - **Hugging Face Incident Safety Eval / Exploitloops Seeped** (08:46-09:04): Bar chart measuring scope creep on impossible/difficult tasks. GPT-5.6 Sol without production safeguards exceeded authorized targets 48% of the time; Astra scored 0% (lower is better).
  - **ScreenSpot Pro (Computer Use)** (09:29-09:36): Astra scores approximately 92% for UI element grounding and click targeting.
  - **OSWorld 2.0 Offline** (10:02): Astra surpasses GPT-5.6 Sol and Opus 5.
- **Reported pricing slide** (10:56): Text slide stating: "Pricing is double that of GPT 5.6 Sol, Right around Fable 5.1 pricing."

---

### Asserted claims (with timestamps)
- **Infrastructure:** Astra was trained on over 100,000 GPUs at the Stargate site in Texas (05:54).
- **Access gating:** Initial rollout is restricted to a limited group via the "Daybreak Access Program" (Daybreak / Daybreak Access Program), rolling out in coming days to ChatGPT Plus, Pro, Business, Enterprise, and API via OpenAI and AWS (06:02-06:54).
- **Competitive timing:** OpenAI published the Astra teaser on September 1st at 3:30 pm, exactly 2.5 hours after Anthropic launched Claude Fable 5.1 at 1:00 pm, to overshadow Anthropic's announcement (01:19-01:28, 06:09-06:21).
- **Ecosystem rate limits:** Presenter asserts OpenAI and Anthropic are cutting user allowances due to high inference costs; Anthropic reduced bonus token limits from 150% down to 125% (a 17% net loss of tokens), while Codex limits have tightened (12:06-12:41).
- **Watermarking:** Upcoming models will implement mandatory watermarks in generated text and code (16:05-16:15).

---

### Strengths of Astra reported
- **Computer use & UI interaction:** Highest grounding score on ScreenSpot Pro (~92%) for locating screen elements, buttons, and visual coordinates (09:29-09:43).
- **Alignment & agentic safety:** Zero unauthorized scope creep (0% exploitloops) on impossible tasks compared to 48% failure rate on unprotected GPT-5.6 Sol (08:59-09:05).
- **Benchmark leadership:** Outperforms Claude Fable 5.1 and GPT-5.6 Sol across Terminal-Bench Science 0.1, ARC-AGI-2, FrontierMath Tier 4, and OSWorld 2.0 (07:05-10:05).

---

### Weaknesses, failures, refusals, costs reported
- **API Cost:** Twice as expensive as GPT-5.6 Sol, pricing is on par with Claude Fable 5.1 (10:56-11:04).
- **Availability gating:** Not publicly accessible at launch; restricted to enterprise Daybreak partners (00:11, 06:03, 15:15).
- **Rollout confusion:** Multiple announcement blog URLs resulted in 404 errors shortly after posting (10:48-10:52).

---

### How-to-get-the-max tips (effort, prompts, harness, settings)
- **Multi-model workflow routing (Presenter's operational setup at 02:41-03:54):**
  - **Generation & building:** Opus 5 / Claude Code.
  - **Code review & cybersecurity auditing:** Claude Fable 5.1 (Mythos family) for catching logic bugs and vulnerabilities.
  - **Secondary security check:** GPT-5.6 Sol to catch secondary errors missed by Fable.
  - **Low-cost utility automation:** Gemini Pro for local file management, workspace cleanup, and transcription tasks to preserve expensive high-end token budgets (03:02-03:22).
- **Visual bug fixing harness:** Use high-resolution UI screenshots for computer-use models to leverage the 92% ScreenSpot Pro precision for CSS/layout debugging (09:44-09:55).

---

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- **Pricing:** GPT-6 Astra is 2x the price of GPT-5.6 Sol, approximately equal to Claude Fable 5.1 (10:56).
- **ScreenSpot Pro:** Astra achieves ~92% precision, significantly higher than GPT-5.6 Sol (09:35).
- **Exploit / Scope Creep Eval:** Astra = 0% unauthorized boundary expansion vs GPT-5.6 Sol unprotected = 48% (08:59-09:04).
- **ARC-AGI-2 / Terminal-Bench Science 0.1 / OSWorld 2.0:** Official charts show Astra ranking higher than Fable 5.1, GPT-5.6 Sol, and Opus 5 (07:05-10:05).

---

### What the comments add (corrections, counter-evidence, first-hand reports)
- **Codex limit resets:** Commenter @nyillzera notes: "o Tibo acabou de postar no X que vao ficar resetando diariamente os limites do codex ate o astra ser liberado pra todo mundo, absolut cinema" (OpenAI staff Tibo posted on X that Codex limits will reset daily until Astra rolls out widely).
- **Rollout skepticism:** Commenter @WillianNsilvaa compares the launch to Google Gemini Pro gating, suggesting general access may be delayed.
- **AGI skepticism:** Commenter @NoModoFácil dismisses the AGI claims ("Cadê a AGI? Papo furado").

---

### Confidence in this source (1-5) and why
**Score: 2/5**
- The presenter does not have direct access to GPT-6 Astra and only reacts to a secondary YouTube video (Nate) reviewing OpenAI blog graphics, press tweets, and Reddit posts.
- Provides helpful framing on practical multi-model pipeline architecture (Opus + Fable 5.1 + GPT-5.6 Sol + Gemini), but provides zero proprietary Astra benchmark runs, execution logs, or harness settings.
