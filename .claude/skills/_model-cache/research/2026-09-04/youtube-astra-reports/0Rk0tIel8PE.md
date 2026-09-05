## Video: GPT Astra LEAKED?! OpenAI’s Next Model Looks INSANE!!, ByteForward
**URL:** https://www.youtube.com/watch?v=0Rk0tIel8PE  **Views:** 2781  **Date:** 20260831  **Length:** 7:55
**ADDRESSES GOAL:** partially, discusses leaked Astra frontend/game coding capabilities, leaked token/time metrics, and release timelines, but relies purely on unverified social media leaks rather than direct hands-on testing.
**HANDS-ON:** no (reaction only)

---

### Demonstrated findings (with timestamps)
*No direct live runs or benchmarks were executed by the presenter.* On screen, the presenter shows captured third-party demo footage and screenshots of posts from X:
- **01:21**: Screenshot of an X post by `@XiViX_134` showing an internal checkpoint named `mozaik-alpha-fdm`, claiming: *"OpenAI has just dropped its first internal Astra checkpoint: mozaik-alpha-fdm. Here are the first two outputs, both generated 1-shot on Max effort. On Max the model tends to think ALOT more than Sol, but it has a ton of attention to detail as evident by the outputs below."*
- **01:27 - 02:06**: Video playback of a voxel/top-down city game ("Neon Borough") allegedly built one-shot by Astra, showing a mini-map HUD, weapon UI, and driving/combat mechanics.
- **02:09 - 02:46**: Video playback of "CycleForge", an interactive bicycle assembly studio with parametric geometry sliders, drivetrain configurators, and multi-stage assembly views.
- **02:48 - 03:22**: Side-by-side video clip labeled "Astra" vs "Fable 5.1" showing Minecraft-style voxel rendering and interaction (inventory, block breaking, tools, lighting, shaders).
- **03:25 - 03:58**: Video playback of a 3D first-person roguelike dungeon crawler allegedly generated one-shot by Astra, featuring dual-wielded weapons, combat damage numbers, and enemy pathing.
- **04:01**: Screenshot of `@XiViX_134` showing a 3D rendered PlayStation 5 controller.
- **04:06**: Screenshot of an X post by `@TimJayas` showing a 3D spaceship model ("N.S.V. Aurora").
- **04:10 - 04:29**: Video of a 3D sci-fi tank ("MBT-99 REVENANT") and an interactive 3D voxel diorama ("Sakura Sanctuary").
- **04:30**: Screenshot of an X post by `@lyraxana` listing Astra run generation stats:
  - `[GPT Astra] Pelican Voxel`: "~89k tokens, ~30 minutes, effort: max"
  - `[GPT Astra] Pelican SVG`: "~31k tokens, ~23 minutes, effort: max"
- **04:38**: Screenshot of an X post by `@DanOrts` comparing Astra vs Fable 5.1 on the prompt *"Generate an SVG of Ana de Armas as detailed as possible."*
- **04:42 - 04:55 / 05:51 - 06:12**: Video playback of "Aureliona", an interactive 3D voxel kingdom environment.
- **04:56 - 05:49**: Video clip watermarked `claude-melon-eap` showing a third-person mech action demo.
- **06:13**: Screenshot of an X post by `@synthwavecdd`: *"SCOOP: Astra recently graduated from the dogfood stage, and is now being made available to select OpenAI partners under the name 'ultima-alpha'. If feedback over this weekend is positive, the plan is to expand the early access program throughout next week before the wider launch, targeting next Thurs (the 3rd) to the end of the following week. Work also continues on an update to GPT-Image 2, with their launch windows being very similar (possibly even launching simultaneously)"* (Posted 11:00 AM, Aug 29, 2026).
- **07:31 - 07:54**: Video playback of "Pelago: Saltwind 07", an interactive 3D pelican-on-a-bicycle voxel scene.

---

### Asserted claims (with timestamps)
- **00:09 - 00:15**: OpenAI may have addressed the biggest weakness of its previous coding models: front-end visual design and product aesthetics.
- **01:00 - 01:14**: OpenAI has publicly referenced Astra as an upcoming model, but has not officially confirmed whether Astra is GPT-6 (01:03).
- **01:21**: Leaked checkpoint name reported as `mozaik-alpha-fdm`.
- **02:40 - 02:46**: Astra outputs reflect deliberate UI/UX and product architecture considerations rather than superficial code generation.
- **03:47 - 03:55**: The presenter notes that leak demo videos never show long-term stability: *"These demo videos always mysteriously stop right before somebody clicks the button that destroys everything."*
- **05:21 - 05:43**: Anthropic early access checkpoints are reportedly circulating under internal code names like `claude-melon-eap` and `marshmallow`, which might correspond to Fable 5.1 or an updated Opus checkpoint.
- **05:50 - 06:00**: The presenter warns that leak cherry-picking is rampant: *"We don't know the reasoning settings, we don't know the system prompts, and we don't know if somebody generated Fable once and Astra 37 times until they got the result they wanted."*
- **06:13 - 06:40**: OpenAI reportedly moved Astra from dogfooding to external partner testing under the identifier `ultima-alpha`, targeting a launch window around Thursday, September 3rd, potentially alongside GPT-Image 2.
- **07:09 - 07:22**: Standard SWE-bench and reasoning scores do not capture whether front-end application code actually looks and feels like a finished product.

---

### Strengths of Astra reported
- **Complex front-end and full application state**: Capable of generating complex interactive applications with complete HUDs, mini-maps, submenus, and controls in single-prompt outputs (01:40 - 02:05).
- **Multi-system integration**: Minecraft-style demos include inventory management, block physics, custom tools, lighting, shaders, crafting, audio, and extra dimensions (03:00 - 03:22).
- **3D spatial coherence**: Generates full 3D models (controllers, tanks, spaceships) with consistent geometry from multiple camera angles, avoiding classic rotational AI artifacts (04:10 - 04:30).
- **Vector graphics detail**: Generates high-fidelity SVGs with layered shading, facial structure, hair strands, and lighting details represented entirely in code (04:33 - 04:41).

---

### Weaknesses, failures, refusals, costs reported
- **Massive generation time and token usage**: Leak stats from `@lyraxana` indicate Max effort runs require ~23 minutes (31k tokens) for detailed SVGs and ~30 minutes (89k tokens) for voxel models (04:30).
- **Unverified runtime robustness**: Presenter emphasizes that none of the public demos demonstrate what happens when you interact deeply or modify state after 5 minutes (03:47).
- **Cherry-picking risk**: No visibility into prompt attempts, error recovery, or failure rates prior to recording successful screen captures (05:50).

---

### How-to-get-the-max tips (effort, prompts, harness, settings)
- **Effort level**: Setting effort to `max` enables deep extended reasoning ("thinks ALOT more than Sol") necessary for large, multi-system single-shot codebases (01:21, 04:30).
- **Comprehensive specification**: Prompts requesting complete interactive studios (like CycleForge) succeed best when asking for end-to-end parametric controls, multiple stages, and live visualization rather than basic boilerplate (02:13 - 02:35).

---

### Comparisons vs Fable 5.1 / Sol / others (numbers)
- **Astra vs GPT-5.6 Sol**: Astra on `max` effort "tends to think ALOT more than Sol" and allocates significantly more attention to visual and structural details (01:21).
- **Astra vs Claude Fable 5.1 (SVG Benchmark)**: Leaked side-by-side on the prompt *"Generate an SVG of Ana de Armas as detailed as possible"* claims Astra has superior facial proportions, shading, and anatomical detail compared to Fable 5.1 (04:38).
- **Astra vs Claude Fable 5.1 (Game Demos)**: Fable 5.1 demo footage (`claude-melon-eap`) showcases advanced 3D mech combat rendering, while Astra matches it with full roguelikes and voxel worlds (02:48 - 03:30, 04:56 - 05:49).

---

### What the comments add (corrections, counter-evidence, first-hand reports)
- `@TGSDEV4220` (0 likes) points out a factual error in the comparison footage: *"The Minecraft clone was not made by fable 5.1. it is just a shader fable 5 made"* (correcting the video's assertion at 02:48 that Fable 5.1 built the Minecraft clone shown side-by-side).
- `@emanuele.jitari` (2 likes): Italian viewer remarking on being early (*"Primo in Italia probabilmente"*).

---

### Confidence in this source (1-5) and why
**2/5**
- **Reasoning**: The channel had zero direct access to Astra or Anthropic early-access models and solely aggregates third-party X leaks from various accounts (`@XiViX_134`, `@lyraxana`, `@TimJayas`, `@DanOrts`, `@synthwavecdd`). The presenter maintains healthy skepticism and highlights generation times, token usage, and cherry-picking pitfalls, but the video provides no independently reproducible data.
