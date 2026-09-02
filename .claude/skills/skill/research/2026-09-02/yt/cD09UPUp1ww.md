## DSPy Masterclass ,  5 Real-World Use Cases for AI Engineers, ZazenCodes
URL: https://www.youtube.com/watch?v=cD09UPUp1ww  Date: 20250919  Views: 12891  Duration: 58:03
Class: ADJACENT
### Gemini analysis
### 1. Classification
**ADJACENT** ,  The video is an end-to-end coding walkthrough demonstrating DSPy (v3) modules and its prompt/pipeline optimizer (`MIPROv2`), which represents an adjacent declarative framework for automated prompt optimization and multi-stage LM programming.

---

### 2. Concrete Hands-On Details, Numbers, Errors & Workarounds
* **Setup & Dependency pegging [02:10-02:58]:** Installs `dspy-ai==3.0.1`, `openai>=1.9.9`, `python-dotenv>=1.1.0`, `sentence-transformers>=5.1.0` inside a Python virtual environment.
* **Token/Cost inspection [09:55-10:20, 54:19-54:33]:**
  * Simple structured extraction runs cost ~1,487 tokens (~1,136 input / 351 output) on `gpt-5-nano` [09:55].
  * Total OpenAI spend shown on dashboard across test runs: $3.40 total, with ~$0.24 spent during the filming session [54:19-54:27].
* **Errors & Parameter constraints hit:**
  * **Temperature/Token requirements [11:06-11:25]:** Setting custom parameters failed without explicit temperature (`temperature=1.0`) and large token allocation (`max_tokens >= 20000`) on reasoning models (`ValueError: OpenAI's reasoning models require passing temperature=1.0 and max_tokens >= 20000`).
  * **Shorthand string syntax error [16:40-17:05]:** Passing invalid signatures via raw arrow strings (e.g. `applicant profile -> loan risk`) threw `SyntaxError: invalid syntax`; requires strict identifier naming (underscores) and explicit keyword arguments.
  * **Pydantic/Type coercion bug [18:27-18:41]:** Passing a string `"no"` into a field typed as `bool` did not raise a validation error as expected; DSPy silently passed it into the system prompt.
  * **Anthropic SDK model string error [37:31-37:40]:** Calling `anthropic/claude-sonnet-4` threw `litellm.exceptions.NotFoundError: type: not_found_error, message: model: claude-sonnet-4` until the exact dated string was passed.
* **Self-Improving Pipeline Optimization Results [40:36-53:25]:**
  * Optimizing an HR RAG question-answering bot using `dspy.teleprompt.MIPROv2` (`metric=exact_match`, `auto="light"`):
    * **Baseline Score [47:00-47:45]:** 1/4 (25.0% accuracy) on the 4-sample evaluation set (failed on PTO count phrasing, receipt requirements, and laptop options).
    * **Optimized Score [52:48-53:05]:** 4/4 (100.0% accuracy) after MIPROv2 candidate generation and prompt tuning using `gpt-4o`.

---

### 3. Claims about What SkillOpt is Good At
* *Not discussed in this video* (SkillOpt is not mentioned; video focuses exclusively on DSPy/MIPROv2).

---

### 4. Claims about What SkillOpt is Bad At / Breaks
* *Not discussed in this video.*

---

### 5. Mechanism of Alternative (DSPy / MIPROv2) & Comparison to SkillOpt
* **Mechanism in 3 Bullets:**
  1. **Declarative Modular Signatures [03:40-04:30, 22:15-22:45]:** Encapsulates LLM tasks into explicit inputs/outputs (`dspy.Signature`) and modules (`Predict`, `ChainOfThought`, `ReAct`, `RAG`) that compile underlying prompt templates automatically.
  2. **Candidate Generation via LLM In-Context Analysis [48:00-49:05]:** An instructor model analyzes program structure, training examples, and task descriptions to propose candidate meta-instructions and few-shot example combinations.
  3. **Bayesian Optimization Selection (`MIPROv2`) [49:05-49:35]:** Searches the joint space of instruction candidates and bootstrapped few-shot traces to select prompt parameters that maximize a designated evaluation metric.
* **Evidence:** Live demonstration improving an HR policy RAG module from 25% to 100% exact match over 10 optimization trials [47:00, 52:48].
* **Comparison to SkillOpt Goal:**
  * DSPy optimizes *pipeline prompts and few-shot traces* using Bayesian search over candidate instructions, whereas SkillOpt specifically targets hierarchical agent skill libraries (`SKILL.md`), modular skill routing, and code-based tool APIs.
  * DSPy requires strict Python-native orchestration code (`dspy.Module`), making it less suited for optimizing pure Markdown agent prompt repositories (e.g., `CLAUDE.md`, `AGENTS.md`) without wrapping them in Python harnesses.

---

### 6. Non-Verifiable Tasks & Non-Coding Workflows
* **HR Policy Q&A SOPs [19:10-27:25, 48:40-49:00]:** Demonstrates grounding internal HR standard operating procedures (expense limits, vacation policies, onboarding laptop options) using RAG and CoT reasoning.
* **Expense Approval Assistant [30:00-37:05]:** Shows a non-coding multi-step SOP evaluating whether client dinner expenses comply with a $75/person policy using tool-augmented ReAct.
* **Verifiability Caveat [45:55-46:40, 50:00-50:20]:** Evaluates the RAG bot using string-normalization exact match (`exact_match`), showing that without flexible semantic or LLM-as-a-judge metrics, rigid string evaluation penalizes semantically valid but slightly verbose answers.

---

### 7. Quality Signal
**High (Hands-On Implementation):** The speaker (Alex Galea / ZazenCodes) writes code live on screen, triggers actual OpenAI/Anthropic API calls, inspects raw platform completion logs, troubleshoots runtime errors, and displays token usage and cost metrics.
### Comments (first-hand, corrections, disagreements)
- @stblackhole (4 likes): "One feature of DSPy that isn't well documented is the ability to finetune your own local models and LORAs based on your optimized DSPY programs. I was able to finetune a Llama 3.2 1B Instruct model on my own GPU as part of a Stable Diffusion image optimization agent. I used a larger local 21 B model" - first-hand experience, undocumented feature.
- @nnerik (1 like): "The missing logs and lightspeed runs could be due to local caching, which is a builtin DSPy feature." - correction/explanation of an anomaly in the video.
- @saibhaskerraju2513 (1 like): "I heard each LLM expects a prompt in a certain format or form to give best results and dspy takes care of it for us. Is it true? I saw logs in mlflow comparing gpt-4.1 with Gemini and the prompt structure was same for both of them. Can you help me understand how dspy helps us" - substantive question casting doubt on a DSPy claim.
- @RichardOrtega85 (0 likes): "Hopefully that OAI key got rolled! But great content" - security flag (live API key possibly shown on screen).
