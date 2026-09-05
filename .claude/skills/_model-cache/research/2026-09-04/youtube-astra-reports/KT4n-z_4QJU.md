## Video: OpenAI Astra and Recurrent Depth / Looped Transformers, Sebastian Raschka
**URL:** https://www.youtube.com/watch?v=KT4n-z_4QJU  **Views:** 30402  **Date:** 20260902  **Length:** 28:03
**ADDRESSES GOAL:** partially / no, the video is a theoretical machine learning architecture lecture analyzing rumors about Astra's underlying recurrent depth mechanism rather than an operational evaluation of GPT-6 Astra.
**HANDS-ON:** no (reaction only to rumors from *The Information* ahead of release).

### Demonstrated findings (with timestamps)
- [00:57] Displayed article excerpt from *The Information*: *"The new technique OpenAI is using, known as recurrent depth or looped transformer, allows an AI model to improve its answers by processing the same text multiple times. Unlike commercially available state-of-the-art models, which show in writing how they are 'thinking' about a task before completing it, the new technique works in a way that obscures some or all of the AI's reasoning, otherwise known as its 'chain of thought.' That means the steps that the model takes to accomplish a task can't easily be read or understood by humans."*
- [03:02] Displayed arXiv paper "Nanbeige4.2-3B: Unlocking Agentic Capabilities in a Compact Model" trained on "28T tokens with a Looped Transformer that reuses the layer stack to increase capacity without adding parameters".
- [03:34] Displayed Nanbeige 4.2 (3B) architecture: 22 distinct layers looped once into 44 total layers, vocabulary size 166k, supported context length of 262k tokens, embedding dimension 3,072, intermediate projection size 10,752, 48 Q heads, 8 KV heads (group size 6), head dim 128.
- [09:43] Displayed Nanbeige paper excerpt on Loop Depth Selection: *"relative to a standard Transformer, it retains approximately 75% of the token efficiency and provides a significant capacity gain. Increasing the number of passes provides only marginal additional improvement, but substantially slows training and makes optimization less stable."*
- [10:36] Displayed KV Cache sharing excerpt showing sharing the KV cache across loops reduces memory by half but degrades performance.
- [11:59] Displayed arXiv paper "Mixture-of-Recursions: Learning Dynamic Recursive Depths for Adaptive Token-Level Computation" showing dynamic routing per token across 1 to 3 loops.
- [16:19] Displayed validation loss curves comparing Vanilla, Recursive, and Mixture of Recursions (MoR) across 135M, 360M, 730M, and 1.7B parameter models across compute budgets (2.0, 5.0, 16.5 x 10^18 FLOPs).
- [24:26] Displayed "Universal Transformers" (2018) paper diagram ($Embeddings \to [same\ transformer\ layer] \times T \to Output$).
- [25:26] Displayed 2025 arXiv paper "Scaling up Test-Time Compute with Latent Reasoning: A Recurrent Depth Approach".

### Asserted claims (with timestamps)
- [00:10] Astra is an upcoming OpenAI model rumored to use recurrent depth or looped transformers.
- [02:30] Looped transformers do not literally process raw text strings multiple times; they pass latent intermediate representations through shared layers repeatedly.
- [02:53] Disagrees with claims that recurrent depth inherently obscures chain of thought or harms interpretability compared to standard scaling.
- [08:52] Retrofitting an existing pre-trained transformer into a looped model causes poor performance; looped models must be trained from scratch.
- [20:52] Increasing layers via looping does not inherently reduce visible output reasoning tokens.
- [23:35] Recurrent depth is purely a parameter-efficient scaling technique, completely unrelated to recursive self-improvement (RSI).

### Strengths of Astra reported
- Potential parameter efficiency: Reusing layers enables larger effective depth without increasing parameter memory footprint [05:30].
- Increased compute capacity per parameter without ballooning VRAM for weight storage [06:38].

### Weaknesses, failures, refusals, costs reported
- Computational overhead: Reusing layers still scales training and inference FLOPs linearly with the number of loops [06:15].
- Memory requirements: Cannot naively share KV cache across loop passes without degrading model performance, meaning KV cache footprint scales with total passes rather than distinct physical layers [11:00].
- Diminishing returns beyond 2 passes: Additional loops destabilize optimization and yield minimal performance gains [10:20].

### How-to-get-the-max tips (effort, prompts, harness, settings)
- None demonstrated for GPT-6 Astra runtime usage, API settings, prompts, or tool harness routing.

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- GPT-5.6 Sol / Luna / Terra: Mentioned as OpenAI's three-tier model family [21:12]. Sol is larger and likely contains more layers than Luna, though no benchmark scores or pricing were provided.
- Claude Fable 5.1: Not mentioned.
- Nanbeige 4.2 (3B): 22 layers looped twice to emulate 44 layers, retaining ~75% token efficiency relative to standard transformers [09:43].

### What the comments add (corrections, counter-evidence, first-hand reports)
- @briancase6180: Affirms the debunking of claims regarding obscured reasoning traces.
- @paratirisis: Notes Nanbeige 3B uses ~8GB VRAM due to unshared KV caching across sweeps.
- @PaulanerStudios: Asserts depth-wise recurrence has an unfavorable tradeoff versus adding distinct layers when compute-matched.
- @dogwithamug & @east_const: Propose combining looped depth with Mixture of Experts (MoE) or latent feedback residuals.
- @tpae0: Corrects the video's statement regarding Nanbeige's geographic origin (not from India).

### Confidence in this source (1-5) and why
- 1/5 for the specific research goal. Sebastian Raschka provides an accurate technical breakdown of recurrent depth literature, but had zero hands-on access to GPT-6 Astra and provided no pricing, benchmarks, prompts, or operational guidance.
