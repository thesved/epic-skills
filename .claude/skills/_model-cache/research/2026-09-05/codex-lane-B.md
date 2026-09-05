# Lane B: Unofficial practitioner evidence on Meta Muse Spark and Muse Glimmer, research cutoff 2026-09-05

## TLDR: decisions for our routing

1. **Route Muse Spark 1.3 Contributor as a cheap implementation, review, and bounded subagent seat, not as the primary architect.** Practitioners repeatedly report acceptable implementation when requirements are explicit, but weak tradeoff reasoning, inconsistent initiative, and poorer reliability than Fable 5.1 or GPT-5.6 Sol on ambiguous work. One developer found it handled Rust and TypeScript implementation with few bugs, while another found it unable to balance two conflicting priorities in repositories of 10,000 to 50,000 lines. [COMMUNITY][ASSERTION] [OpenCode hands-on report](https://www.reddit.com/r/opencode/comments/1w6i19c/hater_to_lover_muse_spark_13/), published 2026-09-03, accessed 2026-09-05. [COMMUNITY][ASSERTION] [ClaudeAI repository report](https://www.reddit.com/r/ClaudeAI/comments/1w5mbo4/meta_releases_muse_spark_13_matching_fable_5_w_10/), published 2026-09-02, accessed 2026-09-05.

2. **Keep Fable 5.1 or Sol in the planning and final-review seats.** The clearest practitioner comparison says Spark is in the DeepSeek V4 Flash, GLM 5.3 Flash, and Gemini Flash class, with better tools but less depth than Sol, Fable, or Kimi K3. A code-review user likewise ranked Sol above Kimi K3, GLM 5.3, and Spark. [COMMUNITY][ASSERTION] [OpenCodeCLI comparison thread](https://www.reddit.com/r/opencodeCLI/comments/1w6ar1y/how_does_meta_spark_13_match_claude_fable_5_on/), published 2026-09-04, accessed 2026-09-05. [COMMUNITY][ASSERTION] [Multi-model code-review thread](https://www.reddit.com/r/opencodeCLI/comments/1w5zhbn/kimi_k3_vs_glm_53_vs_qwen_38_max_vs_muse_spark_13/), published 2026-09-03, accessed 2026-09-05.

3. **Use Contributor only for public, synthetic, throwaway, or otherwise non-sensitive material.** OpenRouter states verbatim: “Prompts and outputs may be used to improve Meta’s products.” Practitioners recommend open-source projects and hardened sandboxes, and explicitly warn against customer data, production secrets, and unrestricted filesystem access. [OFFICIAL][ASSERTION] [OpenRouter Contributor page](https://openrouter.ai/meta/muse-spark-1.3-contributor), model released 2026-09-02, accessed 2026-09-05. [COMMUNITY][ASSERTION] [Contributor security discussion](https://www.reddit.com/r/opencode/comments/1w6i19c/hater_to_lover_muse_spark_13/), published 2026-09-03, accessed 2026-09-05.

4. **Do not assume standard Spark has independently documented zero retention or no training.** The public pages retrieved explicitly disclose Contributor data use, but the accessible standard page does not state retention, training exclusion, or ZDR terms. The absence of the Contributor warning is not itself a contractual privacy guarantee. [OFFICIAL][DEMONSTRATED] [Standard Spark page](https://openrouter.ai/meta/muse-spark-1.3), model released 2026-09-02, accessed 2026-09-05. [OFFICIAL][DEMONSTRATED] [Contributor Spark page](https://openrouter.ai/meta/muse-spark-1.3-contributor), model released 2026-09-02, accessed 2026-09-05.

5. **Start Spark 1.3 at xhigh for difficult coding, but do not route as though public max results are available everywhere.** Meta initially said max would follow additional safety testing, while practitioners reported xhigh as the public ceiling and max as limited-preview access. [OFFICIAL][ASSERTION] [Meta Spark 1.3 announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05. [COMMUNITY][ASSERTION] [OpenCode reasoning-level discussion](https://www.reddit.com/r/opencodeCLI/comments/1w5oqll/no_max_thinking_level_option_for_muse_spark_13/), published 2026-09-02, accessed 2026-09-05.

6. **Protect Git and external directories before giving Spark autonomy.** A Spark 1.2 user reported that a requested HTML design revert damaged unrelated pages and was followed by `git reset --hard HEAD`; another reported repeated attempts to read `/` after fresh starts and compaction. These are single-user reports, not proof of intentional collection, but they justify deny-by-default permissions. [COMMUNITY][ASSERTION] [Destructive revert report](https://www.reddit.com/r/opencodeCLI/comments/1vt60il/my_disastrous_experience_with_muse_spark_12/), published approximately 2026-08-20, accessed 2026-09-05. [COMMUNITY][DEMONSTRATED] [Filesystem access report with screenshot](https://www.reddit.com/r/opencodeCLI/comments/1vqglwm/privacy_concern_muse_spark_12_contributor/), published approximately 2026-08-17, accessed 2026-09-05.

7. **For Spark 1.2 integrations, prefer the Responses transport when the gateway supports it.** OpenCode and oh-my-pi users reproduced streams that ended without a non-null `finish_reason`; pinning Spark to `openai-responses` instead of `openai-completions` fixed the tool-call path. [COMMUNITY][DEMONSTRATED] [oh-my-pi issue 8957](https://github.com/can1357/oh-my-pi/issues/8957), published 2026-08-19, accessed 2026-09-05. [COMMUNITY][DEMONSTRATED] [OpenCode issue 43882](https://github.com/anomalyco/opencode/issues/43882), published 2026-08-21, accessed 2026-09-05.

8. **Muse Glimmer 30B is the more interesting Meta addition for an Apple-silicon local seat, especially for private tool use, review, and personal-agent work.** A 24 GB M4 Mac mini completed a real PR review at 5.33 generated tokens per second in about 51 minutes, finding one confirmed blocker with no false blocker. A separate M3 Ultra Hermes test scored Glimmer 93 versus Qwen3.6-27B at 81 on a full agent gauntlet. [COMMUNITY][DEMONSTRATED] [M4 Mac mini field test](https://www.reddit.com/r/LocalLLM/comments/1vmrgz2/can_a_24_gb_m4_mac_mini_do_a_real_agentic_code/), published approximately 2026-08-13, accessed 2026-09-05. [COMMUNITY][DEMONSTRATED] [Hermes head-to-head](https://www.reddit.com/r/LocalLLM/comments/1vmz6k0/muse_glimmer_30b_vs_qwen36_27b_for_hermes_agent/), published approximately 2026-08-13, accessed 2026-09-05.

9. **Treat 24 GB as experimental, 32 GB as workable, and 48 GB or more as comfortable for Glimmer on a development Mac.** The 24 GB test required closing the browser, Docker, and normal development services. An M1 Max 32 GB produced 14.3 tokens per second at 8K context with a 20.1 GB model-memory peak. [COMMUNITY][DEMONSTRATED] [24 GB field test](https://www.reddit.com/r/LocalLLM/comments/1vmrgz2/can_a_24_gb_m4_mac_mini_do_a_real_agentic_code/), published approximately 2026-08-13, accessed 2026-09-05. [COMMUNITY][DEMONSTRATED] [M1 Max oMLX benchmark](https://omlx.ai/benchmarks/performance/y3kusjty), published 2026-08-11, accessed 2026-09-05.

10. **Benchmark DFlash on the actual Mac before enabling it.** Meta measured speedups on Max chips, but a base M5 MacBook Air fell from 7.41 to 3.0 tokens per second at temperature 1.0, about 60 percent slower. Another M4 Max llama.cpp test measured only 0.9x to 1.0x, despite Meta’s official 1.5x M4 Max figure using ExecuTorch. [COMMUNITY][DEMONSTRATED] [M5 Air seven-quant benchmark](https://www.reddit.com/r/LocalLLM/comments/1vlo8wr/dflash_speculative_decoding_made_my_m5_macbook/), published approximately 2026-08-11, accessed 2026-09-05. [COMMUNITY][DEMONSTRATED] [M4 Max Claude Code bridge](https://github.com/CogniTechSystems/muse-glimmer-claude-code), published approximately 2026-08-11, accessed 2026-09-05. [OFFICIAL][DEMONSTRATED] [Meta Glimmer model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), model released 2026-08, accessed 2026-09-05.

11. **Avoid the broken Meta oQ4e MLX checkpoint for tool-calling work.** On an M3 Ultra it produced no tool call and only 9 to 12 tokens per second, while `mlx-community/Muse-Glimmer-30B-4bit` produced correct multi-step tool calls at 38 tokens per second in the same runtime. [COMMUNITY][DEMONSTRATED] [oMLX issue 2589](https://github.com/jundot/omlx/issues/2589), published approximately 2026-08-11, accessed 2026-09-05.

12. **Exploit Spark’s cheap cache only with stable harness prefixes and supported session metadata.** Contributor cache reads are listed at $0.002 per million tokens, versus $0.15 for standard, and OpenCode warned that requests missing its session header would lose prompt-cache optimization. [OFFICIAL][DEMONSTRATED] [Contributor pricing and cache rate](https://openrouter.ai/meta/muse-spark-1.3-contributor), model released 2026-09-02, accessed 2026-09-05. [COMMUNITY][ASSERTION] [OpenCode account mirror](https://zamantika.com/vi/profile/opencode), post visible 2026-09-04, accessed 2026-09-05.

13. **Complete the OpenRouter 18-plus attestation if Spark is to be callable, but do not interpret it as identity verification or a privacy consent.** The live probe returned HTTP 403 with “This model requires you to complete the following before use: 18+ age confirmation. Confirm at https://openrouter.ai/settings/preferences.” and `missing_attestation_types ["age_18plus"]`; the evidence only establishes an account preference prerequisite. [COMMUNITY][DEMONSTRATED] [OpenRouter preferences](https://openrouter.ai/settings/preferences), probed 2026-09-05, accessed 2026-09-05.

14. **Do not route audio-critical work to Spark 1.3 yet.** OpenRouter’s current model page warns verbatim: “Audio understanding in Muse Spark 1.3 is currently not fully supported, and response quality for requests including audio content may be degraded.” [OFFICIAL][ASSERTION] [OpenRouter Spark 1.3 page](https://openrouter.ai/meta/muse-spark-1.3), warning visible 2026-09-05, accessed 2026-09-05.

15. **Read OpenRouter popularity as evidence of experimentation and harness traffic, not evidence of quality.** Spark 1.3 Contributor’s largest attributed applications were omp at 69.6 billion tokens, Hermes Agent at 21.1 billion, Codex at 18.1 billion, pi at 17.4 billion, and Claude Code at 10.5 billion in the retrieved snapshot. [OFFICIAL][DEMONSTRATED] [OpenRouter Spark 1.3 Contributor activity](https://openrouter.ai/meta/muse-spark-1.3-contributor), snapshot accessed 2026-09-05.

## Official verification of the supplied live facts

Meta’s own announcement confirms the 2026-09-02 Spark 1.3 release, its focus on long-horizon coding and agentic work, tool use across varied harnesses, clarification behavior, and Meta’s internal finding of about 20 percent fewer tool calls and 25 percent fewer tokens than Spark 1.2. [OFFICIAL][ASSERTION] [Meta Spark 1.3 announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

OpenRouter’s direct pages confirm the supplied 1,048,576 context, $1.25 input, $4.25 output, $0.15 cache-read price for standard Spark 1.3, and $0.10 input, $0.20 output, $0.002 cache-read price for Contributor. They also confirm text, image, video, file, and audio input, tools, tool choice, and structured-output support. [OFFICIAL][DEMONSTRATED] [Standard Spark 1.3 page](https://openrouter.ai/meta/muse-spark-1.3), model released 2026-09-02, accessed 2026-09-05. [OFFICIAL][DEMONSTRATED] [Contributor Spark 1.3 page](https://openrouter.ai/meta/muse-spark-1.3-contributor), model released 2026-09-02, accessed 2026-09-05.

The accessible Meta announcement does not publish Spark pricing, cache pricing, maximum output, the full supported-parameter list, OpenRouter provider count, moderation status, or OpenRouter’s web-search charge. No Meta-source conflict was found because those fields are omitted, not contradicted. [OFFICIAL][DEMONSTRATED] [Meta Spark 1.3 announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

Meta’s Glimmer announcement and model card confirm a dense approximately 29.6 billion parameter model, text and image input, 131,072-plus context, local-agent focus, Muse Spark distillation, Apache 2.0 licensing, and BF16 plus two official 4-bit variants. [OFFICIAL][DEMONSTRATED] [Meta Glimmer announcement](https://research.meta.ai/blog/introducing-muse-glimmer-open-agentic-model), published 2026-08-10, accessed 2026-09-05. [OFFICIAL][DEMONSTRATED] [Meta Glimmer model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), model released 2026-08, accessed 2026-09-05.

OpenRouter records Glimmer as released or listed on 2026-08-09, while Meta publicly announced it on 2026-08-10. This is best understood as a catalog-listing date preceding the public announcement, not evidence that the weights were officially released a day earlier. [OFFICIAL][DEMONSTRATED] [OpenRouter Glimmer page](https://openrouter.ai/meta/muse-glimmer-30b), accessed 2026-09-05. [OFFICIAL][DEMONSTRATED] [Meta announcement](https://research.meta.ai/blog/introducing-muse-glimmer-open-agentic-model), published 2026-08-10, accessed 2026-09-05.

OpenRouter currently lists Glimmer providers Phala, DeepInfra, Fireworks, and Together. The retrieved snapshot showed respective median throughput of 67, 171, 44, and 83 tokens per second, with prices varying by provider. [OFFICIAL][DEMONSTRATED] [OpenRouter Glimmer provider table](https://openrouter.ai/meta/muse-glimmer-30b), accessed 2026-09-05.

## 1. First-hand hands-on reports

1. **Hacker News, Spark 1.3:** One user had not tried 1.3 yet but reported that the previous version was “the best free model available on OpenCode” for simple or moderate tasks when the request was precise and required few unstated assumptions. Another user had used Spark for Latin subtitle translation and placed it alongside Gemini for that task. Effort and sample size were unstated, so both are hands-on impressions rather than controlled demonstrations. [COMMUNITY][ASSERTION] [Hacker News Spark 1.3 thread](https://news.ycombinator.com/item?id=49541256), published approximately 2026-09-04, accessed 2026-09-05.

2. **Hacker News, Spark 1.2:** Simon Willison ran his standard pelican SVG prompt and considered Spark 1.2 a small improvement over 1.1. Other participants discussed the harness, privacy, and global-access questions but supplied little measured coding evidence. Effort was unstated. [COMMUNITY][DEMONSTRATED] [Hacker News Spark 1.2 thread](https://news.ycombinator.com/item?id=49187575), publication date not exposed in retrieved page, accessed 2026-09-05.

3. **Hacker News, Glimmer:** A developer used Glimmer on a Mac to research an old web application’s plugin API, generate a roughly 100-line filter-plugin skeleton, and diagnose a bug after the developer returned from shopping. The author considered it a responsive local sidekick, not an autonomous replacement. Effort was unstated. [COMMUNITY][ASSERTION] [Hacker News field report](https://news.ycombinator.com/item?id=49411199), publication date not exposed in retrieved page, accessed 2026-09-05.

4. **Reddit r/ClaudeAI:** A developer tested Spark 1.3 on repositories of roughly 10,000 to 50,000 lines plus documentation. It implemented code adequately after a stronger model supplied a detailed plan, but oscillated between conflicting priorities instead of reconciling them. The developer retained Fable for architecture and positioned Spark as a Haiku-style executor. Effort was unstated. [COMMUNITY][ASSERTION] [ClaudeAI Spark 1.3 thread](https://www.reddit.com/r/ClaudeAI/comments/1w5mbo4/meta_releases_muse_spark_13_matching_fable_5_w_10/), published 2026-09-02, accessed 2026-09-05.

5. **Reddit r/ClaudeAI, document editing:** One user reported that Claude refused an invoice PDF name and font edit, while Spark accepted the task and completed it in about half the time the user expected Claude to require. No files, timer, exact model effort, or reproducible prompt were published. [COMMUNITY][ASSERTION] [Invoice-editing report](https://www.reddit.com/r/ClaudeAI/comments/1w69iyf/for_the_first_time_it_happened_to_me_that_claude/), published 2026-09-03, accessed 2026-09-05.

6. **Reddit r/singularity:** A user tried Spark 1.3 through both OpenRouter and OpenCode Zen, changed system prompts, and also ran it outside a harness. It was passable for OpenGL shader composition, Godot debugging, and TypeScript and Go documentation lookup, but gave incomplete practice problems and incorrect explanations during upper-level discrete-math tutoring. Effort was not stated. [COMMUNITY][ASSERTION] [Benchmaxxing report](https://www.reddit.com/r/singularity/comments/1w78m6y/im_getting_the_feeling_muse_spark_13_is/), published 2026-09-04, accessed 2026-09-05.

7. **Reddit r/opencode:** A Spark 1.3 user applied it to a Rust and TypeScript project through Codex with OpenCode Go access. It reportedly followed the application’s visual identity and produced few, but not zero, bugs. The user’s central conclusion was price-to-performance rather than frontier quality. Effort was apparently xhigh from the surrounding discussion, but the exact run configuration was not documented. [COMMUNITY][ASSERTION] [Hater to Lover report](https://www.reddit.com/r/opencode/comments/1w6i19c/hater_to_lover_muse_spark_13/), published 2026-09-03, accessed 2026-09-05.

8. **Reddit r/opencode, design:** One practitioner gave Spark a bare-bones website initially created by DeepSeek and asked it to improve the appearance. Spark proposed a mockup and implemented the approved design, producing what the user described as a professional-looking result. No screenshots, timing, effort, or objective score accompanied the comment. [COMMUNITY][ASSERTION] [OpenCode early-consensus thread](https://www.reddit.com/r/opencode/comments/1w5tuwx/so_whats_the_early_consensus_about_the_new_muse/), published 2026-09-03, accessed 2026-09-05.

9. **Reddit r/opencodeCLI:** Several developers testing Spark 1.3 for coding placed it at or below GLM 5.3 Flash and DeepSeek V4 Flash. One game developer said it failed to solve a problem, failed to recognize the failure, and told the user the user was wrong. Another said a few hours of coding-partner use felt below both Flash models. Effort was unstated. [COMMUNITY][ASSERTION] [OpenCodeCLI comparison thread](https://www.reddit.com/r/opencodeCLI/comments/1w6ar1y/how_does_meta_spark_13_match_claude_fable_5_on/), published 2026-09-04, accessed 2026-09-05.

10. **Reddit r/LocalLLaMA:** A Glimmer user ran `UD-Q5_K_XL` with DFlash and compared it against Qwen3.6-27B. They reported better agentic workflow and tool-calling behavior, greater instruction compliance, and fewer hallucinations, while finding Glimmer worse at most coding. Another user reported that a recurring process Qwen completed correctly about 75 percent of the time had not yet failed under Glimmer, but did not publish the trial count. [COMMUNITY][ASSERTION] [LocalLLaMA A/B report](https://www.reddit.com/r/LocalLLaMA/comments/1vl64et/1_day_in_and_i_feel_okay_saying_museglimmer30b/), published 2026-08-11, accessed 2026-09-05.

11. **Reddit r/LocalLLM:** A documented M4 Mac mini test ran Glimmer `UD-Q4_K_XL` and Qwen3.6-27B `IQ4_XS` through a real pull-request review. Both found one confirmed blocker and produced no false blocker, while Glimmer took about 51 minutes at 5.33 generated tokens per second and Qwen about 71 minutes at 4.14. The author disclosed different prompt revisions, non-identical quants, and unequal context headroom. [COMMUNITY][DEMONSTRATED] [M4 Mac mini code-review test](https://www.reddit.com/r/LocalLLM/comments/1vmrgz2/can_a_24_gb_m4_mac_mini_do_a_real_agentic_code/), published approximately 2026-08-13, accessed 2026-09-05.

12. **Reddit r/CLine:** Practitioners copied Muse Code-style instructions into Cline and ran the same Spark 1.2 model on the same real Cline bug. The modified harness used 7.2 million tokens instead of 19.7 million, finished in 24 instead of 49 minutes, and cost $3.25 instead of $7.69. The system-prompt change was the claimed independent variable. [COMMUNITY][DEMONSTRATED] [Cline harness experiment](https://www.reddit.com/r/CLine/comments/1vh92q4/muse_code_had_a_bug_so_we_tried_its_system_prompt/), published approximately 2026-08-06, accessed 2026-09-05.

13. **DEV Community:** Federico Ramirez briefly used Spark 1.3 with Meta’s Muse harness. A GitHub-issue-to-PR skill that worked automatically with Opus 5 and Grok 4.6 sometimes stopped under Spark and required “continue”; Markdown rendering was inconsistent; permission prompts could loop. He nevertheless found the model readable, fast after first token, subjectively around Opus 4.8 or Grok 4.6, and capable of about two to four hours of continuous coding on the $15 plan before the rolling limit. [COMMUNITY][ASSERTION] [Muse Spark 1.3 review](https://dev.to/gosukiwi/muse-spark-13-a-review-3h7), published 2026-09-04, accessed 2026-09-05.

14. **Simon Willison’s weblog and tests:** Willison ran Glimmer locally through LM Studio on a Mac. Its pelican-on-a-bicycle SVG contained all requested components but arranged them incorrectly. In a later image-size web-tool task, Glimmer used 1,021 reasoning tokens and produced a functional but under-engineered page, while Qwen3.8-27B used 17,576 reasoning tokens and produced a more elaborate page. Glimmer also added an unnecessary CORS setting that broke one cross-origin image case. [COMMUNITY][DEMONSTRATED] [Hacker News comparison containing Willison’s artifacts](https://news.ycombinator.com/item?id=49324985), publication date not exposed in retrieved page, accessed 2026-09-05. [COMMUNITY][DEMONSTRATED] [Willison Meta archive](https://simonwillison.net/tags/meta/), entries dated 2026-08, accessed 2026-09-05.

15. **X and Twitter practitioners:** An indexed X post described Spark 1.3 as “unbelievably trash,” citing repetition, unrelated tool calls, and invented root causes. Another practitioner said it completed work extremely quickly and received an adversarial review score around 85 from Fable and Sol, but neither post published a controlled prompt set. These are hands-on opinions, not demonstrations. [COMMUNITY][ASSERTION] [Indexed X search page](https://twstalker.com/search/Muse%20Spark%201.3), posts visible 2026-09-04, accessed 2026-09-05.

16. **GitHub issue trackers:** The OpenCode and oh-my-pi communities reproduced Spark 1.2 streaming failures on tool-call turns. The exact client error was “OpenAI completions stream closed before a finish_reason was received.” Routing the model through the Responses API resolved the mapped transport issue in oh-my-pi. [COMMUNITY][DEMONSTRATED] [OpenCode issue 43882](https://github.com/anomalyco/opencode/issues/43882), published 2026-08-21, accessed 2026-09-05. [COMMUNITY][DEMONSTRATED] [oh-my-pi issue 8957](https://github.com/can1357/oh-my-pi/issues/8957), published 2026-08-19, accessed 2026-09-05.

17. **GitHub measured local-agent repository:** An M4 Max 36 GB owner connected Glimmer to Claude Code through llama.cpp and LiteLLM. Fresh generation was about 22 tokens per second, generation about 29,000 tokens deep fell to about 7, prompt prefill was about 110, cold Claude Code response took about four minutes, and later cached turns about one minute. DFlash measured only 0.9x to 1.0x overall. [COMMUNITY][DEMONSTRATED] [Muse Glimmer Claude Code repository](https://github.com/CogniTechSystems/muse-glimmer-claude-code), published approximately 2026-08-11, accessed 2026-09-05.

18. **oMLX benchmark community:** An M1 Max with 32 GB running a 4-bit oQ4e quant at 8,192 context measured 72.9 prompt-processing tokens per second, 14.3 generation tokens per second, and 20.1 GB peak MLX-active memory. DFlash and thinking budget were disabled. [COMMUNITY][DEMONSTRATED] [oMLX benchmark](https://omlx.ai/benchmarks/performance/y3kusjty), published 2026-08-11, accessed 2026-09-05.

19. **HolaClaw practitioners:** HolaClaw tested the official 17 GB quant on fanless M3 24 GB and M4 32 GB MacBook Air systems. The 24 GB setup used 8K context, the 32 GB setup 64K, text only, q4 KV cache, and reasoning disabled. The retrieved article exposed the configuration but not its complete result table, so it confirms fit and setup rather than a precise speed verdict. [COMMUNITY][DEMONSTRATED] [HolaClaw Mac test](https://holaclaw.ai/blog/muse-glimmer-on-mac), published approximately 2026-08-11, accessed 2026-09-05.

20. **YouTube creator written notes:** Marvijo Software’s accompanying Reddit write-up describes five controlled full-stack website builds with identical frozen briefs, isolated workspaces, and a three-prompt failure limit. Spark 1.2 Contributor scored 41 of 50 and DeepSeek V4 Flash Vision 39 of 50, although Spark received zero of three on one build’s visual design and DeepSeek lost delivery points for an incomplete receipt. [COMMUNITY][DEMONSTRATED] [Marvijo written test description](https://www.reddit.com/r/ArtificialInteligence/comments/1vysd92/muse_spark_beat_deepseek_41_to_39_across_five/), published 2026-08-26, accessed 2026-09-05.

21. **Stack Overflow:** A user reproduced `Error: OpenAI API error (403): {"type":"RegionError","message":"This model is not available in your country."}` in both OpenCode CLI and Desktop, on macOS and Windows. The platform-independent result points toward account or IP geography rather than an operating-system defect, but no authoritative resolution was posted. [COMMUNITY][DEMONSTRATED] [Stack Overflow region-error question](https://stackoverflow.com/questions/80000688/how-to-fix-model-is-not-available-in-your-country-error-when-using-muse-spark), published 2026-09-04, accessed 2026-09-05.

22. **OpenRouter usage pages:** These are platform telemetry rather than user reviews. Spark 1.3 Contributor’s top attributed clients were coding and agent harnesses, while Glimmer’s were pi, OpenClaw, Hermes Agent, LangChain, and omp. That supports actual agent-harness adoption, but does not reveal completion success, effort settings, user satisfaction, or whether traffic was evaluation versus production. [OFFICIAL][DEMONSTRATED] [Spark 1.3 Contributor activity](https://openrouter.ai/meta/muse-spark-1.3-contributor), accessed 2026-09-05. [OFFICIAL][DEMONSTRATED] [Glimmer activity](https://openrouter.ai/meta/muse-glimmer-30b), accessed 2026-09-05.

## 2. What people rave about

- “the best free model available on OpenCode.” The user qualified this to precise, simple, or moderate tasks with few undefined assumptions. [COMMUNITY][ASSERTION] [Hacker News](https://news.ycombinator.com/item?id=49541256), published approximately 2026-09-04, accessed 2026-09-05.

- “the price to performance value is INSANE!” This followed hands-on Rust and TypeScript implementation work. [COMMUNITY][ASSERTION] [OpenCode](https://www.reddit.com/r/opencode/comments/1w6i19c/hater_to_lover_muse_spark_13/), published 2026-09-03, accessed 2026-09-05.

- “Faster, more precise, more stable than spark 1.2.” No benchmark or effort level accompanied the comment. [COMMUNITY][ASSERTION] [OpenCode release thread](https://www.reddit.com/r/opencode/comments/1w5g31e/muse_spark_13_is_out/), published 2026-09-02, accessed 2026-09-05.

- “holy cowballs it's fast for my first few tasks.” The tasks were basic UI work, and the user said quality was not class-leading. [COMMUNITY][ASSERTION] [ClaudeAI launch thread](https://www.reddit.com/r/ClaudeAI/comments/1w5mbo4/meta_releases_muse_spark_13_matching_fable_5_w_10/), published 2026-09-02, accessed 2026-09-05.

- “Muse-Glimmer got there faster every time.” The author compared a few hours of OpenCode agent work against Qwen3.6-27B. [COMMUNITY][ASSERTION] [LocalLLaMA](https://www.reddit.com/r/LocalLLaMA/comments/1vl64et/1_day_in_and_i_feel_okay_saying_museglimmer30b/), published 2026-08-11, accessed 2026-09-05.

- “Toolcalling has been reliable, if not over eager.” The user was running Glimmer locally with large context across dual 16 GB GPUs. [COMMUNITY][ASSERTION] [LocalLLaMA use-case thread](https://www.reddit.com/r/LocalLLaMA/comments/1vn20yw/interesting_uses_for_muse_glimmer_30b/), published 2026-08-13, accessed 2026-09-05.

- “a breath of fresh air, with no fluff, ootb.” The author used Glimmer to inspect repositories and write technical material. [COMMUNITY][ASSERTION] [Hacker News](https://news.ycombinator.com/item?id=49375996), publication date not exposed in retrieved page, accessed 2026-09-05.

- “Yes, a 24 GB M4 Mac mini can run a 27-30B quantized model as a useful coding agent.” This conclusion followed a logged real pull-request review. [COMMUNITY][DEMONSTRATED] [M4 Mac mini test](https://www.reddit.com/r/LocalLLM/comments/1vmrgz2/can_a_24_gb_m4_mac_mini_do_a_real_agentic_code/), published approximately 2026-08-13, accessed 2026-09-05.

## 3. What people despise or hit

### Model behavior

- “muse is terrible it regularly gets in loops breaks stuff and is less useful than a chocolate heat shield.” No task, effort, or logs were provided. [COMMUNITY][ASSERTION] [OpenCode free-model thread](https://www.reddit.com/r/opencode/comments/1w5ziqj/meta_muse_spark_13_is_free_on_opencode_zen/), published 2026-09-03, accessed 2026-09-05.

- “It just does B.” The repository user reported that when reminded about A, Spark discarded B and switched entirely to A rather than finding a tradeoff. [COMMUNITY][ASSERTION] [ClaudeAI repository report](https://www.reddit.com/r/ClaudeAI/comments/1w5mbo4/meta_releases_muse_spark_13_matching_fable_5_w_10/), published 2026-09-02, accessed 2026-09-05.

- “it isn't even DS4 Flash or GLM 5.3 Flash level.” This came after a few hours of coding-partner use. [COMMUNITY][ASSERTION] [OpenCodeCLI comparison](https://www.reddit.com/r/opencodeCLI/comments/1w6ar1y/how_does_meta_spark_13_match_claude_fable_5_on/), published 2026-09-04, accessed 2026-09-05.

- “confidence exceeded its accuracy.” In a 100-extension task, Spark reportedly claimed completion while many sampled extensions were incomplete and required repeated prompting. [COMMUNITY][DEMONSTRATED] [Hy3 versus Spark test](https://www.reddit.com/r/opencodeCLI/comments/1vta8wf/hy3_muse_spark_12_contributor_my_experience/), published approximately 2026-08-20, accessed 2026-09-05.

- “Unfortunately it's a shit arse lazy model incapable of more than 3 minutes work.” This was an unmeasured user judgment about Spark 1.2 Contributor. [COMMUNITY][ASSERTION] [OpenCode free Spark thread](https://www.reddit.com/r/opencodeCLI/comments/1vtbr4q/muse_spark_12_is_now_free_on_opencode/), published approximately 2026-08-20, accessed 2026-09-05.

- A long-form writing user reported severe context degradation after roughly 20,000 tokens, including Glimmer copying a scene description nearly word for word despite instructions not to do so. [COMMUNITY][ASSERTION] [LocalLLaMA context-rot discussion](https://www.reddit.com/r/LocalLLaMA/comments/1w5l8bw/muse_spark_open_weights_coming_soon/), published 2026-09-02, accessed 2026-09-05.

### Tool calls, formats, and harnesses

- Exact Spark 1.2 error: “OpenAI completions stream closed before a finish_reason was received”. The affected OpenCode-compatible streaming path visibly completed content but omitted the terminal finish chunk. [COMMUNITY][DEMONSTRATED] [OpenCode issue 43882](https://github.com/anomalyco/opencode/issues/43882), published 2026-08-21, accessed 2026-09-05.

- Exact region error: `{"type":"RegionError","message":"This model is not available in your country."}` Reports came from the EU, Germany, Canada, Pakistan, and other unspecified locations, but no authoritative country list was found. [COMMUNITY][DEMONSTRATED] [OpenCode region thread](https://www.reddit.com/r/opencode/comments/1vsx645/musespark12contributor_this_model_is_not/), published 2026-08-19, accessed 2026-09-05. [COMMUNITY][ASSERTION] [Spark 1.3 free thread](https://www.reddit.com/r/opencode/comments/1w5ziqj/meta_muse_spark_13_is_free_on_opencode_zen/), published 2026-09-03, accessed 2026-09-05.

- Exact request-validation error reported by a user: “This request requires an end-user identifier. Provide a non-empty `safety_identifier` (or `user`) field.” [COMMUNITY][DEMONSTRATED] [OpenCode Spark 1.2 thread](https://www.reddit.com/r/opencode/comments/1vtbrle/muse_spark_12_is_now_free_on_opencode/), published approximately 2026-08-20, accessed 2026-09-05.

- The broken oQ4e MLX checkpoint returned `finish_reason: "stop"`, `tool_calls: null`, empty content, and reasoning that ended after planning a weather-tool call. The same prompt worked using the official Q6 GGUF and the mlx-community 4-bit checkpoint. [COMMUNITY][DEMONSTRATED] [oMLX issue 2589](https://github.com/jundot/omlx/issues/2589), published approximately 2026-08-11, accessed 2026-09-05.

- A Zed user reported a JSON nesting-depth limit of 10 that conflicted with Zed’s deeper read and write schemas. This was not independently reproduced in the thread. [COMMUNITY][ASSERTION] [Spark 1.2 failure thread](https://www.reddit.com/r/opencodeCLI/comments/1vt60il/my_disastrous_experience_with_muse_spark_12/), published approximately 2026-08-20, accessed 2026-09-05.

### Latency and capacity

- A base M5 Air measured DFlash at 3.0 tokens per second versus 7.41 without speculation at temperature 1.0. Lowering temperature to 0.6 raised it to 4.5, still below baseline. [COMMUNITY][DEMONSTRATED] [M5 Air benchmark](https://www.reddit.com/r/LocalLLM/comments/1vlo8wr/dflash_speculative_decoding_made_my_m5_macbook/), published approximately 2026-08-11, accessed 2026-09-05.

- A user reported reaching OpenCode’s five-hour free limit after about 400,000 to 500,000 tokens, while another claimed more than 100 million tokens without seeing a limit. These irreconcilable anecdotes indicate account, plan, rolling-window, or capacity differences, not a dependable quota. [COMMUNITY][ASSERTION] [OpenCode free-model thread](https://www.reddit.com/r/opencode/comments/1w5ziqj/meta_muse_spark_13_is_free_on_opencode_zen/), published 2026-09-03, accessed 2026-09-05.

- Spark 1.3 standard showed 95.04 percent three-day availability and 98.41 percent 24-hour availability in the retrieved OpenRouter snapshot, while Contributor showed 99.14 and 99.18 percent. These rolling figures can change and do not isolate age-attestation failures from provider failures. [OFFICIAL][DEMONSTRATED] [Standard Spark page](https://openrouter.ai/meta/muse-spark-1.3), accessed 2026-09-05. [OFFICIAL][DEMONSTRATED] [Contributor Spark page](https://openrouter.ai/meta/muse-spark-1.3-contributor), accessed 2026-09-05.

### Moderation and refusals

No indexed practitioner report demonstrated a moderation false positive specifically on Spark through OpenRouter. The only reproduced OpenRouter block in scope was the account attestation 403, which is an access prerequisite rather than content moderation. [COMMUNITY][DEMONSTRATED] [OpenRouter preferences](https://openrouter.ai/settings/preferences), probed 2026-09-05, accessed 2026-09-05.

## 4. Practitioner comparisons

### Claude Fable 5.1

The hands-on consensus does not support replacing Fable 5.1 as architect. One developer explicitly retained Fable for architecture and system-design documents, then passed detailed implementation plans to Spark. Another described Fable as more consistent and better at understanding intent. [COMMUNITY][ASSERTION] [ClaudeAI report](https://www.reddit.com/r/ClaudeAI/comments/1w5mbo4/meta_releases_muse_spark_13_matching_fable_5_w_10/), published 2026-09-02, accessed 2026-09-05. [COMMUNITY][ASSERTION] [OpenCodeCLI comparison](https://www.reddit.com/r/opencodeCLI/comments/1w6ar1y/how_does_meta_spark_13_match_claude_fable_5_on/), published 2026-09-04, accessed 2026-09-05.

### GPT-5.6 Sol

A practitioner comparing code review found Sol still edged Kimi K3, GLM 5.3, and Spark. Another said Spark and DeepSeek found the same code-review issue as Sol, suggesting parity on that narrow finding but not overall capability. [COMMUNITY][ASSERTION] [Multi-model review thread](https://www.reddit.com/r/opencodeCLI/comments/1w5zhbn/kimi_k3_vs_glm_53_vs_qwen_38_max_vs_muse_spark_13/), published 2026-09-03, accessed 2026-09-05. [COMMUNITY][ASSERTION] [Spark versus DeepSeek thread](https://www.reddit.com/r/opencode/comments/1vsl2mr/muse_spark_12_contributor_vs_deepseek_v4_flash/), published approximately 2026-08-19, accessed 2026-09-05.

No credible hands-on evidence found Spark consistently beating Sol. Claims that xhigh Spark beat xhigh Sol in launch threads were benchmark-derived opinions without disclosed tasks. [COMMUNITY][ASSERTION] [OpenCode free-model discussion](https://www.reddit.com/r/opencode/comments/1w5ziqj/meta_muse_spark_13_is_free_on_opencode_zen/), published 2026-09-03, accessed 2026-09-05.

### GPT-6 Astra

No post-launch, task-matched Spark versus GPT-6 Astra practitioner comparison was found. The indexed discussion only referred to Astra’s impending or same-week arrival and did not supply hands-on comparative results. [COMMUNITY][ASSERTION] [ClaudeAI launch discussion](https://www.reddit.com/r/ClaudeAI/comments/1w5mbo4/meta_releases_muse_spark_13_matching_fable_5_w_10/), published 2026-09-02, accessed 2026-09-05.

### Gemini 3.7 Flash

A half-day Spark 1.2 user testing Flutter refactors, exploration, architecture discussion, and bug hunting reported little difference from DeepSeek V4 Flash, not Gemini. The clearest Gemini comparison comes from the user whose Spark 1.2 HTML revert damaged a multi-page site while Gemini 3.7 had been the primary successful model. [COMMUNITY][ASSERTION] [Spark 1.2 initial impressions](https://www.reddit.com/r/opencode/comments/1vsjdfd/muse_spark_12_my_initial_impressions_compared_to/), published 2026-08-19, accessed 2026-09-05. [COMMUNITY][ASSERTION] [Destructive HTML report](https://www.reddit.com/r/opencodeCLI/comments/1vt60il/my_disastrous_experience_with_muse_spark_12/), published approximately 2026-08-20, accessed 2026-09-05.

### DeepSeek V4

This is the most common practitioner comparison. Reports range from Spark slightly better, especially for frontend advice, to Spark far worse for debugging and autonomous execution. A controlled five-site test scored Spark 1.2 Contributor 41 of 50 and DeepSeek V4 Flash Vision 39 of 50, but the two-point difference depended partly on delivery-receipt scoring. [COMMUNITY][DEMONSTRATED] [Five-site comparison](https://www.reddit.com/r/ArtificialInteligence/comments/1vysd92/muse_spark_beat_deepseek_41_to_39_across_five/), published 2026-08-26, accessed 2026-09-05.

Day-to-day system and backend users generally described Spark 1.2 and DeepSeek V4 Flash as similar, with Spark stronger on frontend and advisory review, and DeepSeek preferable for backend execution. [COMMUNITY][ASSERTION] [OpenCode comparison thread](https://www.reddit.com/r/opencode/comments/1vsl2mr/muse_spark_12_contributor_vs_deepseek_v4_flash/), published approximately 2026-08-19, accessed 2026-09-05.

### GLM 5.3 and GLM 5.3 Flash

Several Spark 1.3 users placed it at GLM 5.3 Flash level or below. One frontend practitioner considered Spark 1.3 roughly on par with full GLM 5.3 for frontend work, while another ranked GLM 5.3 and Kimi K3 above Spark for code review. [COMMUNITY][ASSERTION] [OpenCodeCLI hands-on comparison](https://www.reddit.com/r/opencodeCLI/comments/1w6ar1y/how_does_meta_spark_13_match_claude_fable_5_on/), published 2026-09-04, accessed 2026-09-05. [COMMUNITY][ASSERTION] [Four-model comparison](https://www.reddit.com/r/opencodeCLI/comments/1w5zhbn/kimi_k3_vs_glm_53_vs_qwen_38_max_vs_muse_spark_13/), published 2026-09-03, accessed 2026-09-05.

### Kimi K3

Practitioners generally favored Kimi K3 for planning and difficult review. One routing proposal used Kimi K3 or GLM 5.3 for planning, Spark 1.3 for implementation and cheap reviews, and Sol for the final pass. [COMMUNITY][ASSERTION] [Four-model routing thread](https://www.reddit.com/r/opencodeCLI/comments/1w5zhbn/kimi_k3_vs_glm_53_vs_qwen_38_max_vs_muse_spark_13/), published 2026-09-03, accessed 2026-09-05.

### Qwen 3.8

Willison’s functional HTML test measured 17,576 reasoning tokens for Qwen3.8-27B versus 1,021 for Glimmer. Qwen produced the more engineered solution and handled a cross-origin image that Glimmer broke, while Glimmer was dramatically more token efficient. [COMMUNITY][DEMONSTRATED] [Willison comparison in Hacker News](https://news.ycombinator.com/item?id=49324985), publication date not exposed in retrieved page, accessed 2026-09-05.

Other users described Glimmer as better than Qwen3.8-27B for non-coding work and faster in time-to-answer because it reasoned less, while a coding user found Glimmer noticeably worse as a drop-in replacement. [COMMUNITY][ASSERTION] [LocalLLaMA discussion](https://www.reddit.com/r/LocalLLaMA/comments/1w5l8bw/muse_spark_open_weights_coming_soon/), published 2026-09-02, accessed 2026-09-05. [COMMUNITY][ASSERTION] [Hacker News Qwen thread](https://news.ycombinator.com/item?id=49334544), publication date not exposed in retrieved page, accessed 2026-09-05.

### gpt-oss and Gemma

Practitioners likened Glimmer to gpt-oss in its concise, controllable reasoning and reliability, but no common controlled benchmark supporting an overall winner was found. [COMMUNITY][ASSERTION] [LocalLLaMA RTX 5080 comparison](https://www.reddit.com/r/LocalLLaMA/comments/1vmskes/qwen36_35b_2_min_vs_muse_glimmer_30b_4_min_on/), published approximately 2026-08-12, accessed 2026-09-05.

Compared with Gemma 4 31B, users often preferred Gemma for natural-language assistance and Glimmer for tool use and agent workflows. One local user called Glimmer too passive, while another reported Gemma was reluctant to call tools. [COMMUNITY][ASSERTION] [LocalLLaMA use-case thread](https://www.reddit.com/r/LocalLLaMA/comments/1vn20yw/interesting_uses_for_muse_glimmer_30b/), published 2026-08-13, accessed 2026-09-05. [COMMUNITY][ASSERTION] [LocalLLaMA open-weights thread](https://www.reddit.com/r/LocalLLaMA/comments/1w5l8bw/muse_spark_open_weights_coming_soon/), published 2026-09-02, accessed 2026-09-05.

## 5. Contributor tier reception

Contributor is being used heavily in omp, Hermes, Codex, pi, Claude Code, OpenCode, hobby coding, open-source work, automated code review, frontend generation, translation, and bulk agent tasks. OpenRouter’s attributed app traffic is dominated by agent and coding harnesses, while community posts describe Japanese novel translation, automated tasks, and GitHub review. [OFFICIAL][DEMONSTRATED] [Spark 1.3 Contributor activity](https://openrouter.ai/meta/muse-spark-1.3-contributor), accessed 2026-09-05. [COMMUNITY][ASSERTION] [OpenCode Spark 1.2 thread](https://www.reddit.com/r/opencodeCLI/comments/1vtbr4q/muse_spark_12_is_now_free_on_opencode/), published approximately 2026-08-20, accessed 2026-09-05.

The privacy debate is straightforward at the disclosure level and unresolved beyond it. OpenRouter says prompts and outputs may improve Meta products. Practitioners disagree between “public code is already public” and concern that agents may read secrets, unrelated directories, or customer data before those bytes enter the prompt. [OFFICIAL][ASSERTION] [Contributor disclosure](https://openrouter.ai/meta/muse-spark-1.3-contributor), model released 2026-09-02, accessed 2026-09-05. [COMMUNITY][ASSERTION] [Filesystem privacy discussion](https://www.reddit.com/r/opencodeCLI/comments/1vqglwm/privacy_concern_muse_spark_12_contributor/), published approximately 2026-08-17, accessed 2026-09-05.

No controlled standard-versus-Contributor quality A/B was found. Community comments generally assume the weights and capabilities are the same and the difference is data use, but the public sources retrieved do not provide a checksum, deterministic equivalence test, or contractual identity guarantee. [COMMUNITY][ASSERTION] [Spark 1.2 discussion](https://www.reddit.com/r/opencode/comments/1vhk4d0/muse_spark_12_is_awesome/), published 2026-08-06, accessed 2026-09-05.

OpenRouter’s rolling telemetry does show different observed performance: Spark 1.3 Contributor had a 2.94-second median latency and 109 tokens per second, while standard had 3.05 seconds and 64 tokens per second in the retrieved snapshot. This is not a model-quality comparison and could reflect request mix, load, caching, or service allocation. [OFFICIAL][DEMONSTRATED] [Contributor endpoint](https://openrouter.ai/meta/muse-spark-1.3-contributor), accessed 2026-09-05. [OFFICIAL][DEMONSTRATED] [Standard endpoint](https://openrouter.ai/meta/muse-spark-1.3), accessed 2026-09-05.

Contributor access is region-gated in at least some channels. Users reported 403 region errors in Germany, other EU locations, Canada, and Pakistan, while some users outside the US reported success. No authoritative current country list was found. [COMMUNITY][ASSERTION] [Spark 1.2 region thread](https://www.reddit.com/r/opencode/comments/1vsx645/musespark12contributor_this_model_is_not/), published 2026-08-19, accessed 2026-09-05. [COMMUNITY][ASSERTION] [Spark 1.3 free thread](https://www.reddit.com/r/opencode/comments/1w5ziqj/meta_muse_spark_13_is_free_on_opencode_zen/), published 2026-09-03, accessed 2026-09-05.

## Age gate and attestation

OpenRouter marks Spark 1.1, Spark 1.2, Spark 1.2 Contributor, Spark 1.3, Spark 1.3 Contributor, and Muse Image as 18-plus. Glimmer is not visibly marked 18-plus on the OpenRouter catalog page retrieved. [OFFICIAL][DEMONSTRATED] [OpenRouter programming-model catalog](https://openrouter.ai/models?category=programming&order=pricing-low-to-high), accessed 2026-09-05. [OFFICIAL][DEMONSTRATED] [OpenRouter image-model catalog](https://openrouter.ai/models?fmt=table&input_modalities=image&output_modalities=image), accessed 2026-09-05.

Meta’s Glimmer model card nevertheless says verbatim: “The model is not intended to be downloaded by or used by individuals under the age of 18.” It places responsibility on deployers whose systems may be used by minors. [OFFICIAL][ASSERTION] [Meta Glimmer model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), model released 2026-08, accessed 2026-09-05.

This creates an important asymmetry: Meta states an under-18 limitation for Glimmer, but OpenRouter served the live Glimmer probe without an age attestation while blocking Spark. Therefore the available evidence does not support a simple claim that OpenRouter automatically gates every Meta model whose documentation mentions age 18. [OFFICIAL][DEMONSTRATED] [Meta Glimmer model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), model released 2026-08, accessed 2026-09-05. [COMMUNITY][DEMONSTRATED] [OpenRouter preferences](https://openrouter.ai/settings/preferences), probed 2026-09-05, accessed 2026-09-05.

The exact reason Spark has this gate was not documented in any indexed OpenRouter policy or accessible Meta Spark terms page found in the sweep. The most defensible inference is that OpenRouter is enforcing a model-specific upstream or contractual age prerequisite, but the public evidence does not identify who required it. [COMMUNITY][ASSERTION] [OpenRouter Spark catalog](https://openrouter.ai/models?category=programming&order=pricing-low-to-high), accessed 2026-09-05.

The attestation demonstrably means an account must record the `age_18plus` preference before OpenRouter dispatches the request. Nothing found establishes identity-document verification, a birth-date check, data sharing with Meta, retention duration, legal jurisdiction, revocation behavior, or whether organization members inherit the account holder’s attestation. [COMMUNITY][DEMONSTRATED] [OpenRouter preferences](https://openrouter.ai/settings/preferences), probed 2026-09-05, accessed 2026-09-05.

## 6. Muse Glimmer 30B in the wild

### Quantizations and fit

Meta officially publishes BF16, K-Quant-Dynamic for a 32 GB target, and K-Quant-17GB for a 24 GB target. Meta reports average degradation of 0.2 percent and 1.0 percent for the two 4-bit variants across 15 benchmarks. These are vendor measurements. [OFFICIAL][DEMONSTRATED] [Meta model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), model released 2026-08, accessed 2026-09-05.

Community users have run `UD-Q6_K_XL`, `UD-Q5_K_XL`, `UD-Q4_K_XL`, `UD-IQ3_M`, `UD-Q3_K_XL`, `UD-IQ3_XXS`, official K-Quant-17GB, MLX 4-bit, 5-bit, 8-bit, MXFP8 with DFlash, and oQ4e. [COMMUNITY][DEMONSTRATED] [M5 Air quant ladder](https://www.reddit.com/r/LocalLLM/comments/1vlo8wr/dflash_speculative_decoding_made_my_m5_macbook/), published approximately 2026-08-11, accessed 2026-09-05. [COMMUNITY][DEMONSTRATED] [Hermes test](https://www.reddit.com/r/LocalLLM/comments/1vmz6k0/muse_glimmer_30b_vs_qwen36_27b_for_hermes_agent/), published approximately 2026-08-13, accessed 2026-09-05.

### Apple-silicon speed

| Hardware and runtime | Quant and context | Reported result |
|---|---|---|
| M5 MacBook Air, 32 GB, llama.cpp | K-Quant-17GB | 7.4 tok/s, DFlash 3.0 tok/s at temperature 1.0 [COMMUNITY][DEMONSTRATED] [source](https://www.reddit.com/r/LocalLLM/comments/1vlo8wr/dflash_speculative_decoding_made_my_m5_macbook/), published approximately 2026-08-11, accessed 2026-09-05. |
| M5 MacBook Air, 32 GB, llama.cpp | UD-IQ3_M, 14.1 GB | 8.5 tok/s, fastest of seven reported quants [COMMUNITY][DEMONSTRATED] [source](https://www.reddit.com/r/LocalLLM/comments/1vlo8wr/dflash_speculative_decoding_made_my_m5_macbook/), published approximately 2026-08-11, accessed 2026-09-05. |
| M1 Max 24-core GPU, 32 GB, oMLX | oQ4e 4-bit, 8K | 14.3 generation tok/s, 72.9 prompt tok/s, 20.1 GB MLX peak [COMMUNITY][DEMONSTRATED] [source](https://omlx.ai/benchmarks/performance/y3kusjty), published 2026-08-11, accessed 2026-09-05. |
| M4 Max, 36 GB, llama.cpp | UD-Q4_K_XL | about 22 tok/s fresh, about 7 tok/s around 29K context [COMMUNITY][DEMONSTRATED] [source](https://github.com/CogniTechSystems/muse-glimmer-claude-code), published approximately 2026-08-11, accessed 2026-09-05. |
| M4 mini, 24 GB, llama.cpp | UD-Q4_K_XL, real PR review | 5.33 decode tok/s, 45.13 prompt tok/s, about 51m 33s wall time [COMMUNITY][DEMONSTRATED] [source](https://www.reddit.com/r/LocalLLM/comments/1vmrgz2/can_a_24_gb_m4_mac_mini_do_a_real_agentic_code/), published approximately 2026-08-13, accessed 2026-09-05. |
| M4 Pro, 48 GB class machine | 8-bit with mlx-dspark | baseline 8.2 tok/s, 18 to 26 tok/s with speculation depending on content [COMMUNITY][DEMONSTRATED] [source](https://www.reddit.com/r/LocalLLaMA/comments/1vmo2sp/metas_muse_glimmer_30b_now_runs_up_to_33x_faster/), published 2026-08-12, accessed 2026-09-05. |

Meta’s own K-Quant-17GB results were 23.7 to 37.8 tokens per second on M4 Max and 26.6 to 50.2 on M5 Max without and with DFlash, using ExecuTorch, batch size one, and greedy decoding. These do not contradict the slower llama.cpp community results because hardware configuration, runtime, quant, sampling, and context differ. [OFFICIAL][DEMONSTRATED] [Meta model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), model released 2026-08, accessed 2026-09-05.

### Consumer GPUs

A single RTX 3090 user fit `UD-Q4_K_XL`, the vision projector, DFlash, and 262,144 context in about 22 to 23 GB VRAM with full-precision KV cache. [COMMUNITY][DEMONSTRATED] [RTX 3090 report](https://www.reddit.com/r/LocalLLaMA/comments/1vkm42m/muse_glimmer_actually_fits_on_a_single_rtx_3090/), published 2026-08-10, accessed 2026-09-05.

An RTX 5090 production-coding report using `UD-Q6_K_XL` and DFlash measured about 280 tokens per second during a Next.js and Nest.js theme-system implementation, with about 97 percent draft acceptance. This is an unusually favorable structured-refactoring workload and should not be generalized to arbitrary generation. [COMMUNITY][DEMONSTRATED] [RTX 5090 production report](https://www.reddit.com/r/LocalLLaMA/comments/1vl2sv6/museglimmer_30b_hits_280_ts_in_real_production/), published 2026-08-11, accessed 2026-09-05.

### Tool calling and harnesses

Glimmer’s strongest community case is agentic consistency rather than raw coding quality. Users report reliable or occasionally over-eager tool calls in OpenCode and Hermes, better delegation to stronger coding agents than Qwen3.6-27B, and good long-task consistency across sources. [COMMUNITY][ASSERTION] [LocalLLaMA A/B report](https://www.reddit.com/r/LocalLLaMA/comments/1vl64et/1_day_in_and_i_feel_okay_saying_museglimmer30b/), published 2026-08-11, accessed 2026-09-05. [COMMUNITY][DEMONSTRATED] [Hermes gauntlet](https://www.reddit.com/r/LocalLLM/comments/1vmz6k0/muse_glimmer_30b_vs_qwen36_27b_for_hermes_agent/), published approximately 2026-08-13, accessed 2026-09-05.

The M4 Mac mini test showed that local agent work is possible but slow enough that repeated tool reads and loops are costly. Glimmer invoked 28 tools and processed 58,050 new prompt tokens during its approximately 51-minute review. [COMMUNITY][DEMONSTRATED] [M4 field test](https://www.reddit.com/r/LocalLLM/comments/1vmrgz2/can_a_24_gb_m4_mac_mini_do_a_real_agentic_code/), published approximately 2026-08-13, accessed 2026-09-05.

### Templates and reasoning tags

A technical practitioner described Glimmer’s chat template as an OpenAI Harmony-style envelope with recipient routing, while tool calls use XML-style formatting and reasoning strength is supplied as system-prompt text. This analysis was not independently reproduced in the indexed post. [COMMUNITY][ASSERTION] [Indexed technical X profile](https://www6.twstalker.com/adithya_s_k), post visible approximately 2026-08-12, accessed 2026-09-05.

Meta officially specifies `Reasoning strength: low`, `medium`, `high`, or `xhigh` in the system prompt, with high or xhigh recommended for complex coding and agentic tasks. [OFFICIAL][ASSERTION] [Meta model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), model released 2026-08, accessed 2026-09-05.

### Licence

The weights and released artifacts are Apache 2.0. Meta separately supplies a Usage Policy and says the model is not intended for people under 18, so Apache licensing does not remove deployment, safety, or age-related responsibilities stated in the model card. [OFFICIAL][DEMONSTRATED] [Meta model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), model released 2026-08, accessed 2026-09-05.

## 7. OpenRouter usage signal

OpenRouter’s per-model totals changed substantially across crawls during the sweep, so the stable evidence is the direct per-app snapshot rather than attempting to reconstruct a global token-share percentage. [OFFICIAL][DEMONSTRATED] [OpenRouter model catalog](https://openrouter.ai/models?category=programming&order=pricing-low-to-high), accessed 2026-09-05.

| Model | Top attributed applications in retrieved snapshot |
|---|---|
| Spark 1.3 Contributor | omp 69.6B, Hermes Agent 21.1B, Codex 18.1B, pi 17.4B, Claude Code 10.5B tokens [OFFICIAL][DEMONSTRATED] [source](https://openrouter.ai/meta/muse-spark-1.3-contributor), accessed 2026-09-05. |
| Spark 1.3 standard | pi 4.51B, omp 4.05B, Hermes Agent 2.57B, Codex 2.32B, Portkey 1.61B tokens [OFFICIAL][DEMONSTRATED] [source](https://openrouter.ai/meta/muse-spark-1.3), accessed 2026-09-05. |
| Spark 1.2 Contributor | Craft 67.8B, omp 38.5B, Codex 23.4B, Hermes Agent 22.7B, pi 10B tokens [OFFICIAL][DEMONSTRATED] [source](https://openrouter.ai/meta/muse-spark-1.2-contributor-20260805), accessed 2026-09-05. |
| Glimmer 30B | pi 1.18B, OpenClaw 976M, Hermes Agent 744M, LangChain 347M, omp 305M tokens [OFFICIAL][DEMONSTRATED] [source](https://openrouter.ai/meta/muse-glimmer-30b), accessed 2026-09-05. |

OpenRouter showed Spark 1.3 Contributor at Programming rank 27 and Spark 1.2 Contributor at Programming rank 31 in the catalog snapshot. The standard 1.3 page did not expose a category rank in the retrieved direct page. [OFFICIAL][DEMONSTRATED] [OpenRouter programming catalog](https://openrouter.ai/models?category=programming&order=pricing-low-to-high), accessed 2026-09-05.

A defensible global token-share percentage was not published in the pages retrieved. OpenRouter documents an authenticated daily-ranking dataset, but no authenticated account or stable as-of export was available in this research context. [OFFICIAL][ASSERTION] [OpenRouter daily rankings documentation](https://openrouter.ai/docs/api/api-reference/datasets/get-rankings-daily), documentation visible 2026-09-05, accessed 2026-09-05.

## 8. How to get the maximum from the models

1. **Give Spark explicit, bounded implementation briefs.** Practitioners consistently report stronger results when a better model has already resolved architecture and tradeoffs. [COMMUNITY][ASSERTION] [ClaudeAI repository report](https://www.reddit.com/r/ClaudeAI/comments/1w5mbo4/meta_releases_muse_spark_13_matching_fable_5_w_10/), published 2026-09-02, accessed 2026-09-05.

2. **Use Spark as a reviewed subagent.** One user had ChatGPT perform a hostile second review, returned those findings to Spark, and reported that Spark corrected the discovered bugs. [COMMUNITY][ASSERTION] [OpenCodeCLI free-model thread](https://www.reddit.com/r/opencodeCLI/comments/1w5zifw/meta_muse_spark_13_is_free_on_opencode_zen/), published 2026-09-03, accessed 2026-09-05.

3. **Adopt the Muse Code-style verification prompt.** The measured Cline experiment instructed the model to trust source over the user prompt, read call sites and tests, reproduce bugs first, weigh error cases, distrust suspicious passing tests, and continue until verified. That change reduced tokens 2.7x and wall time about 2x on one bug. [COMMUNITY][DEMONSTRATED] [Cline experiment](https://www.reddit.com/r/CLine/comments/1vh92q4/muse_code_had_a_bug_so_we_tried_its_system_prompt/), published approximately 2026-08-06, accessed 2026-09-05.

4. **Use xhigh for difficult Spark tasks and record the actual effort in evaluation logs.** Public max availability was inconsistent around launch, so comparisons that silently use Meta’s max chart against public xhigh are not like-for-like. [OFFICIAL][ASSERTION] [Meta Spark announcement](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05. [COMMUNITY][ASSERTION] [Reasoning-level thread](https://www.reddit.com/r/opencodeCLI/comments/1w5oqll/no_max_thinking_level_option_for_muse_spark_13/), published 2026-09-02, accessed 2026-09-05.

5. **For Glimmer, start with Meta’s sampling recommendation: temperature 1.0, top-p 0.95, top-k 64.** Use high or xhigh reasoning for complex coding and agent work, then reduce effort when latency matters. [OFFICIAL][ASSERTION] [Meta Glimmer model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), model released 2026-08, accessed 2026-09-05.

6. **Tune DFlash separately from ordinary sampling.** On the base M5 Air, temperature 0.6 improved DFlash from 3.0 to 4.5 tokens per second by raising draft agreement, but still lost to the 7.41 non-speculative baseline. [COMMUNITY][DEMONSTRATED] [M5 Air benchmark](https://www.reddit.com/r/LocalLLM/comments/1vlo8wr/dflash_speculative_decoding_made_my_m5_macbook/), published approximately 2026-08-11, accessed 2026-09-05.

7. **Set context explicitly in llama.cpp.** One practitioner found automatic fitting silently reduced a 131K model to 4,096 tokens, causing a coding agent’s first request to fail; setting 32,768 explicitly fixed the immediate context problem. [COMMUNITY][DEMONSTRATED] [M5 Air setup report](https://www.reddit.com/r/LocalLLM/comments/1vlo8wr/dflash_speculative_decoding_made_my_m5_macbook/), published approximately 2026-08-11, accessed 2026-09-05.

8. **Budget for context-dependent slowdown on dense Mac inference.** An M4 Max fell from about 22 generated tokens per second in fresh context to about 7 near 29,000 tokens, and cold Claude Code responses took about four minutes. [COMMUNITY][DEMONSTRATED] [Local Claude Code bridge](https://github.com/CogniTechSystems/muse-glimmer-claude-code), published approximately 2026-08-11, accessed 2026-09-05.

9. **Use a known-good quant for tool calling.** The mlx-community 4-bit checkpoint produced working multi-step calls at 38 tokens per second where Meta’s oQ4e checkpoint stopped after reasoning. [COMMUNITY][DEMONSTRATED] [oMLX issue 2589](https://github.com/jundot/omlx/issues/2589), published approximately 2026-08-11, accessed 2026-09-05.

10. **Keep filesystem permissions deny-by-default and exempt only required paths.** A community configuration denied external directories while allowing specific temporary, agent, package, Cargo, and Go paths. [COMMUNITY][ASSERTION] [Filesystem privacy thread](https://www.reddit.com/r/opencodeCLI/comments/1vqglwm/privacy_concern_muse_spark_12_contributor/), published approximately 2026-08-17, accessed 2026-09-05.

11. **Do not let Spark manage Git history without independent safeguards.** Use human-owned commits, remote pushes, protected branches, and worktrees before autonomous edits. This recommendation follows reported destructive reverts, not a broad measured failure rate. [COMMUNITY][ASSERTION] [Spark 1.2 destructive revert report](https://www.reddit.com/r/opencodeCLI/comments/1vt60il/my_disastrous_experience_with_muse_spark_12/), published approximately 2026-08-20, accessed 2026-09-05.

12. **Preserve stable prompt prefixes for Contributor caching.** Contributor’s cache-read rate is $0.002 per million tokens, and OpenCode says its session header is required for its prompt-cache optimization path. [OFFICIAL][DEMONSTRATED] [Contributor cache price](https://openrouter.ai/meta/muse-spark-1.3-contributor), accessed 2026-09-05. [COMMUNITY][ASSERTION] [OpenCode post mirror](https://zamantika.com/vi/profile/opencode), post visible 2026-09-04, accessed 2026-09-05.

13. **Separate orchestration from implementation.** The best-aligned practitioner routing pattern is Kimi K3, GLM 5.3, Sol, or Fable for planning and adversarial review, with Spark for implementation and cheap repeated review. [COMMUNITY][ASSERTION] [Multi-model routing thread](https://www.reddit.com/r/opencodeCLI/comments/1w5zhbn/kimi_k3_vs_glm_53_vs_qwen_38_max_vs_muse_spark_13/), published 2026-09-03, accessed 2026-09-05.

## Not found after searching

- No indexed first-hand report was found in r/MachineLearning itself. Queries included `site:reddit.com/r/MachineLearning "Muse Spark" Meta`, `"Muse Spark 1.3"`, `"Muse Spark 1.2"`, and `"Muse Glimmer 30B"`. Results instead came from r/machinelearningnews and other communities. [COMMUNITY][DEMONSTRATED] [Nearest indexed result](https://www.reddit.com/r/machinelearningnews/comments/1w6gq9x/meta_ai_released_muse_spark_13_an_agentic_coding/), published 2026-09-03, accessed 2026-09-05.

- No indexed relevant hands-on posts were found in r/OpenAI or r/ChatGPTCoding. Queries included `site:reddit.com/r/OpenAI "Muse Spark"` and `site:reddit.com/r/ChatGPTCoding "Muse Spark"`. The closest result was r/ChatGPTcomplaints, which contained conversational impressions rather than coding evidence. [COMMUNITY][ASSERTION] [Closest Reddit result](https://www.reddit.com/r/ChatGPTcomplaints/comments/1sgc4og/anyone_tried_metas_muses_spark/), published 2026-04-09, accessed 2026-09-05.

- No indexed hands-on Muse report was found from Every, Interconnects, Zvi, Ethan Mollick, Theo, or Ben Hylak. Queries included each domain or author name with `"Muse Spark"` and `"Muse Glimmer"`. [COMMUNITY][DEMONSTRATED] [Latent Space result showing the nearest requested Substack coverage](https://www.latent.space/p/ainews-muse-glimmer-and-spark-open), published 2026-08-11, accessed 2026-09-05.

- Latent Space published a roundup, but the retrieved portion was news aggregation rather than a disclosed hands-on model run. It therefore was not counted as first-hand practitioner evidence. [COMMUNITY][ASSERTION] [Latent Space roundup](https://www.latent.space/p/ainews-muse-glimmer-and-spark-open), published 2026-08-11, accessed 2026-09-05.

- No indexed first-hand Muse reports were found in the public repositories or forums searched for Roo Code, Kilo Code, Aider, Continue, Cursor, Windsurf, or Zed’s official repository. Queries included the project repository or forum domain plus `"Muse Spark"` and `"Muse Glimmer"`. The only Zed-specific evidence found was a Reddit comment reporting JSON-depth incompatibility. [COMMUNITY][ASSERTION] [Reddit source containing the Zed report](https://www.reddit.com/r/opencodeCLI/comments/1vt60il/my_disastrous_experience_with_muse_spark_12/), published approximately 2026-08-20, accessed 2026-09-05.

- Discord messages from Cline, Roo, Kilo, OpenCode, Aider, Cursor, Windsurf, Zed, and Continue were not publicly indexed in a verifiable form. Searches used each community name with the model names and `Discord`. Public Reddit and GitHub issue evidence was substituted where available. [COMMUNITY][DEMONSTRATED] [Cline public substitute](https://www.reddit.com/r/CLine/comments/1vh92q4/muse_code_had_a_bug_so_we_tried_its_system_prompt/), published approximately 2026-08-06, accessed 2026-09-05.

- No authoritative Meta or OpenRouter document explaining why Spark specifically requires `age_18plus` was found. Queries included `site:openrouter.ai/docs "age_18plus"`, `site:openrouter.ai "missing_attestation_types"`, `"18+ age confirmation"`, `site:developer.meta.com/ai terms age 18 API`, and `Meta Model API terms minimum age 18`. [OFFICIAL][DEMONSTRATED] [OpenRouter model catalog showing the gate](https://openrouter.ai/models?category=programming&order=pricing-low-to-high), accessed 2026-09-05.

- No documentation was found explaining how OpenRouter verifies, stores, shares, expires, or revokes the 18-plus attestation. The live error only points to the account preferences page. [COMMUNITY][DEMONSTRATED] [OpenRouter preferences](https://openrouter.ai/settings/preferences), probed 2026-09-05, accessed 2026-09-05.

- No authoritative current country list for Spark or Contributor access was found. Queries included `"Muse Spark" "This model is not available in your country"`, `Muse Spark contributor region`, `Meta Model API expanded global access`, and country-specific EU, Canada, Pakistan, and Brazil variants. [COMMUNITY][DEMONSTRATED] [Region-error report](https://www.reddit.com/r/opencode/comments/1vsx645/musespark12contributor_this_model_is_not/), published 2026-08-19, accessed 2026-09-05.

- No controlled standard-versus-Contributor comparison measured response identity, task quality, reasoning tokens, or latency under matched load. Searches included `"Muse Spark 1.3 contributor" quality difference`, `standard vs contributor`, `latency difference`, and `same weights`. [OFFICIAL][DEMONSTRATED] [OpenRouter comparison page](https://openrouter.ai/compare/meta/muse-spark-1.3/meta/muse-spark-1.3-contributor), accessed 2026-09-05.

- No demonstrated OpenRouter moderation false positive was found for these models. Searches included `"Muse Spark 1.3" moderation OpenRouter 403`, `"Muse Spark" false positive moderation`, refusal, blocked prompt, safety filter, and content policy variants. [OFFICIAL][DEMONSTRATED] [OpenRouter Spark page](https://openrouter.ai/meta/muse-spark-1.3), accessed 2026-09-05.

- No reliable global OpenRouter token-share percentage for the Muse family was available in the retrieved public pages. The documented daily dataset requires authenticated access for a stable export. [OFFICIAL][ASSERTION] [OpenRouter rankings dataset documentation](https://openrouter.ai/docs/api/api-reference/datasets/get-rankings-daily), accessed 2026-09-05.

- No credible hands-on Spark versus GPT-6 Astra comparison was found before the cutoff. Searches included `"Muse Spark 1.3" "GPT-6 Astra"`, coding, agentic, OpenCode, Reddit, Hacker News, and X variants. [COMMUNITY][ASSERTION] [Closest launch discussion](https://www.reddit.com/r/ClaudeAI/comments/1w5mbo4/meta_releases_muse_spark_13_matching_fable_5_w_10/), published 2026-09-02, accessed 2026-09-05.

## Sources

[Meta, Introducing Muse Spark 1.3](https://research.meta.ai/blog/introducing-muse-spark-1-3), published 2026-09-02, accessed 2026-09-05.

[Meta, Introducing Muse Glimmer](https://research.meta.ai/blog/introducing-muse-glimmer-open-agentic-model), published 2026-08-10, accessed 2026-09-05.

[Meta Muse Glimmer model card](https://huggingface.co/meta-models/Muse-Glimmer-30B), model released 2026-08, accessed 2026-09-05.

[OpenRouter, Spark 1.3](https://openrouter.ai/meta/muse-spark-1.3), model released 2026-09-02, accessed 2026-09-05.

[OpenRouter, Spark 1.3 Contributor](https://openrouter.ai/meta/muse-spark-1.3-contributor), model released 2026-09-02, accessed 2026-09-05.

[OpenRouter, Spark 1.2](https://openrouter.ai/meta/muse-spark-1.2), model released 2026-08-05, accessed 2026-09-05.

[OpenRouter, Spark 1.2 Contributor](https://openrouter.ai/meta/muse-spark-1.2-contributor-20260805), model released 2026-08-21, accessed 2026-09-05.

[OpenRouter, Spark 1.1](https://openrouter.ai/meta/muse-spark-1.1), model released 2026-07-16, accessed 2026-09-05.

[OpenRouter, Glimmer 30B](https://openrouter.ai/meta/muse-glimmer-30b), catalog date 2026-08-09, accessed 2026-09-05.

[OpenRouter, Spark standard versus Contributor](https://openrouter.ai/compare/meta/muse-spark-1.3/meta/muse-spark-1.3-contributor), page date not visible, accessed 2026-09-05.

[OpenRouter programming catalog](https://openrouter.ai/models?category=programming&order=pricing-low-to-high), accessed 2026-09-05.

[OpenRouter image catalog](https://openrouter.ai/models?fmt=table&input_modalities=image&output_modalities=image), accessed 2026-09-05.

[OpenRouter daily rankings documentation](https://openrouter.ai/docs/api/api-reference/datasets/get-rankings-daily), accessed 2026-09-05.

[OpenRouter preferences](https://openrouter.ai/settings/preferences), accessed and probed 2026-09-05.

[Hacker News, Spark 1.3](https://news.ycombinator.com/item?id=49541256), published approximately 2026-09-04, accessed 2026-09-05.

[Hacker News, Spark 1.2](https://news.ycombinator.com/item?id=49187575), publication date not visible, accessed 2026-09-05.

[Hacker News, Glimmer launch](https://news.ycombinator.com/item?id=49241679), publication date not visible, accessed 2026-09-05.

[Hacker News, Qwen3.8 comparison](https://news.ycombinator.com/item?id=49324985), publication date not visible, accessed 2026-09-05.

[Hacker News, local plugin field report](https://news.ycombinator.com/item?id=49411199), publication date not visible, accessed 2026-09-05.

[Hacker News, Glimmer technical-writing report](https://news.ycombinator.com/item?id=49375996), publication date not visible, accessed 2026-09-05.

[Hacker News, Qwen3.8 score discussion](https://news.ycombinator.com/item?id=49334544), publication date not visible, accessed 2026-09-05.

[Reddit r/ClaudeAI, Spark 1.3 launch and repository reports](https://www.reddit.com/r/ClaudeAI/comments/1w5mbo4/meta_releases_muse_spark_13_matching_fable_5_w_10/), published 2026-09-02, accessed 2026-09-05.

[Reddit r/ClaudeAI, invoice editing](https://www.reddit.com/r/ClaudeAI/comments/1w69iyf/for_the_first_time_it_happened_to_me_that_claude/), published 2026-09-03, accessed 2026-09-05.

[Reddit r/singularity, Spark 1.3 benchmaxxing report](https://www.reddit.com/r/singularity/comments/1w78m6y/im_getting_the_feeling_muse_spark_13_is/), published 2026-09-04, accessed 2026-09-05.

[Reddit r/opencode, Hater to Lover](https://www.reddit.com/r/opencode/comments/1w6i19c/hater_to_lover_muse_spark_13/), published 2026-09-03, accessed 2026-09-05.

[Reddit r/opencode, early consensus](https://www.reddit.com/r/opencode/comments/1w5tuwx/so_whats_the_early_consensus_about_the_new_muse/), published 2026-09-03, accessed 2026-09-05.

[Reddit r/opencode, Spark 1.3 free](https://www.reddit.com/r/opencode/comments/1w5ziqj/meta_muse_spark_13_is_free_on_opencode_zen/), published 2026-09-03, accessed 2026-09-05.

[Reddit r/opencode, Spark 1.3 release](https://www.reddit.com/r/opencode/comments/1w5g31e/muse_spark_13_is_out/), published 2026-09-02, accessed 2026-09-05.

[Reddit r/opencode, Spark 1.2 initial impressions](https://www.reddit.com/r/opencode/comments/1vsjdfd/muse_spark_12_my_initial_impressions_compared_to/), published 2026-08-19, accessed 2026-09-05.

[Reddit r/opencode, Spark versus DeepSeek](https://www.reddit.com/r/opencode/comments/1vsl2mr/muse_spark_12_contributor_vs_deepseek_v4_flash/), published approximately 2026-08-19, accessed 2026-09-05.

[Reddit r/opencode, Spark region error](https://www.reddit.com/r/opencode/comments/1vsx645/musespark12contributor_this_model_is_not/), published 2026-08-19, accessed 2026-09-05.

[Reddit r/opencodeCLI, Fable comparison](https://www.reddit.com/r/opencodeCLI/comments/1w6ar1y/how_does_meta_spark_13_match_claude_fable_5_on/), published 2026-09-04, accessed 2026-09-05.

[Reddit r/opencodeCLI, multi-model routing](https://www.reddit.com/r/opencodeCLI/comments/1w5zhbn/kimi_k3_vs_glm_53_vs_qwen_38_max_vs_muse_spark_13/), published 2026-09-03, accessed 2026-09-05.

[Reddit r/opencodeCLI, reasoning levels](https://www.reddit.com/r/opencodeCLI/comments/1w5oqll/no_max_thinking_level_option_for_muse_spark_13/), published 2026-09-02, accessed 2026-09-05.

[Reddit r/opencodeCLI, destructive Spark 1.2 report](https://www.reddit.com/r/opencodeCLI/comments/1vt60il/my_disastrous_experience_with_muse_spark_12/), published approximately 2026-08-20, accessed 2026-09-05.

[Reddit r/opencodeCLI, filesystem privacy](https://www.reddit.com/r/opencodeCLI/comments/1vqglwm/privacy_concern_muse_spark_12_contributor/), published approximately 2026-08-17, accessed 2026-09-05.

[Reddit r/opencodeCLI, Hy3 versus Spark](https://www.reddit.com/r/opencodeCLI/comments/1vta8wf/hy3_muse_spark_12_contributor_my_experience/), published approximately 2026-08-20, accessed 2026-09-05.

[Reddit r/opencodeCLI, free Spark 1.2](https://www.reddit.com/r/opencodeCLI/comments/1vtbr4q/muse_spark_12_is_now_free_on_opencode/), published approximately 2026-08-20, accessed 2026-09-05.

[Reddit r/opencode, request-validation and region errors](https://www.reddit.com/r/opencode/comments/1vtbrle/muse_spark_12_is_now_free_on_opencode/), published approximately 2026-08-20, accessed 2026-09-05.

[Reddit r/CLine, harness-prompt experiment](https://www.reddit.com/r/CLine/comments/1vh92q4/muse_code_had_a_bug_so_we_tried_its_system_prompt/), published approximately 2026-08-06, accessed 2026-09-05.

[Reddit r/LocalLLaMA, Glimmer A/B report](https://www.reddit.com/r/LocalLLaMA/comments/1vl64et/1_day_in_and_i_feel_okay_saying_museglimmer30b/), published 2026-08-11, accessed 2026-09-05.

[Reddit r/LocalLLaMA, RTX 3090 fit](https://www.reddit.com/r/LocalLLaMA/comments/1vkm42m/muse_glimmer_actually_fits_on_a_single_rtx_3090/), published 2026-08-10, accessed 2026-09-05.

[Reddit r/LocalLLaMA, RTX 5090 production report](https://www.reddit.com/r/LocalLLaMA/comments/1vl2sv6/museglimmer_30b_hits_280_ts_in_real_production/), published 2026-08-11, accessed 2026-09-05.

[Reddit r/LocalLLaMA, local use cases](https://www.reddit.com/r/LocalLLaMA/comments/1vn20yw/interesting_uses_for_muse_glimmer_30b/), published 2026-08-13, accessed 2026-09-05.

[Reddit r/LocalLLaMA, open-weights discussion](https://www.reddit.com/r/LocalLLaMA/comments/1w5l8bw/muse_spark_open_weights_coming_soon/), published 2026-09-02, accessed 2026-09-05.

[Reddit r/LocalLLaMA, speculative MLX acceleration](https://www.reddit.com/r/LocalLLaMA/comments/1vmo2sp/metas_muse_glimmer_30b_now_runs_up_to_33x_faster/), published 2026-08-12, accessed 2026-09-05.

[Reddit r/LocalLLaMA, RTX 5080 comparison](https://www.reddit.com/r/LocalLLaMA/comments/1vmskes/qwen36_35b_2_min_vs_muse_glimmer_30b_4_min_on/), published approximately 2026-08-12, accessed 2026-09-05.

[Reddit r/LocalLLM, M4 Mac mini review](https://www.reddit.com/r/LocalLLM/comments/1vmrgz2/can_a_24_gb_m4_mac_mini_do_a_real_agentic_code/), published approximately 2026-08-13, accessed 2026-09-05.

[Reddit r/LocalLLM, M5 Air quant benchmark](https://www.reddit.com/r/LocalLLM/comments/1vlo8wr/dflash_speculative_decoding_made_my_m5_macbook/), published approximately 2026-08-11, accessed 2026-09-05.

[Reddit r/LocalLLM, Hermes comparison](https://www.reddit.com/r/LocalLLM/comments/1vmz6k0/muse_glimmer_30b_vs_qwen36_27b_for_hermes_agent/), published approximately 2026-08-13, accessed 2026-09-05.

[Reddit, five full-stack builds](https://www.reddit.com/r/ArtificialInteligence/comments/1vysd92/muse_spark_beat_deepseek_41_to_39_across_five/), published 2026-08-26, accessed 2026-09-05.

[Reddit r/ChatGPTcomplaints](https://www.reddit.com/r/ChatGPTcomplaints/comments/1sgc4og/anyone_tried_metas_muses_spark/), published 2026-04-09, accessed 2026-09-05.

[Reddit r/machinelearningnews](https://www.reddit.com/r/machinelearningnews/comments/1w6gq9x/meta_ai_released_muse_spark_13_an_agentic_coding/), published 2026-09-03, accessed 2026-09-05.

[DEV Community, Muse Spark 1.3 review](https://dev.to/gosukiwi/muse-spark-13-a-review-3h7), published 2026-09-04, accessed 2026-09-05.

[GitHub, OpenCode issue 43882](https://github.com/anomalyco/opencode/issues/43882), published 2026-08-21, accessed 2026-09-05.

[GitHub, oh-my-pi issue 8957](https://github.com/can1357/oh-my-pi/issues/8957), published 2026-08-19, accessed 2026-09-05.

[GitHub, oMLX issue 2589](https://github.com/jundot/omlx/issues/2589), published approximately 2026-08-11, accessed 2026-09-05.

[GitHub, local Glimmer Claude Code bridge](https://github.com/CogniTechSystems/muse-glimmer-claude-code), published approximately 2026-08-11, accessed 2026-09-05.

[oMLX M1 Max benchmark](https://omlx.ai/benchmarks/performance/y3kusjty), published 2026-08-11, accessed 2026-09-05.

[HolaClaw Mac test](https://holaclaw.ai/blog/muse-glimmer-on-mac), published approximately 2026-08-11, accessed 2026-09-05.

[Simon Willison Meta archive](https://simonwillison.net/tags/meta/), entries dated 2026-07 and 2026-08, accessed 2026-09-05.

[Latent Space roundup](https://www.latent.space/p/ainews-muse-glimmer-and-spark-open), published 2026-08-11, accessed 2026-09-05.

[Indexed X Spark 1.3 posts](https://twstalker.com/search/Muse%20Spark%201.3), posts visible 2026-09-04, accessed 2026-09-05.

[Indexed X Glimmer technical profile](https://www6.twstalker.com/adithya_s_k), post visible approximately 2026-08-12, accessed 2026-09-05.

[OpenCode X mirror](https://zamantika.com/vi/profile/opencode), posts visible 2026-09-04, accessed 2026-09-05.

[Stack Overflow region-error report](https://stackoverflow.com/questions/80000688/how-to-fix-model-is-not-available-in-your-country-error-when-using-muse-spark), published 2026-09-04, accessed 2026-09-05.