# YouTube leg, synthesized findings (2026-08-14)

5 videos analyzed via gemini with the research goal embedded (youtube-research flow). Raw per-video reports live in the session transcript; this file keeps what changed our design. Companion to `evidence-dossier.md` (codex web leg, verbatim external artifact, kept as retrieved).

Verification note: all three load-bearing analysts confirmed on challenge that their findings came from successful Gemini REST calls with `fileData.fileUri` pointing at the YouTube URL (genuine server-side video ingestion). Precise on-screen digits are Gemini-transcribed, single-source; the F1 cost cross-checks against the creator's own "$1,200" description ([apex-gp repo](https://github.com/jolbol1/apex-gp)).

## What YouTube added beyond written sources

1. **The literal critic-loop wording that works** (Firecrawl, XTONeqPuh_4, 2026-08-07): "Each critic must run the actual game, screenshot it from the same camera situation as a reference image, compare the pair blind, say which is real, name the single biggest remaining gap, and send it back." Same-viewpoint evidence capture is part of the prompt, not an afterthought. Critic subdivides reference images into grid cells to score specific regions, not whole frames.
2. **Real run economics** (Firecrawl; Better Stack viHqe5QqTd0, 2026-08-03): 34h / 251 subagent sessions / 412M tokens (racer); 19h / 137 agents / 1.7B tokens / $1,226.39 API (F1). Devsplainers (y0ZNXlxVtv0): Worms clone >1B tokens (~$717), GTA ~$1,700/22h. Subscription tiers cannot sustain these runs (comment consensus, both channels).
3. **No diminishing-returns stop exists by default** (Better Stack): Opus itself logged that 90/100 vs real F1 was "a real stretch" with procedural geometry and predicted a plateau in the 70s; score crawled to 64; a human killed the run. Top comment: "If you say it has to be perfect, it'll never stop by definition" (Devsplainers, 20 likes).
4. **The critic dimension shapes what gets fixed** (Better Stack): five "harsh art director" critics produced great shadows/sparks while cars clipped through barriers and no finish logic existed. Firecrawl hit the same: bad FPS until perf metrics were added to the gate. Slide-deck practitioner (Devsplainers comments): loop "can go off and hyper focus on something just because it fits" when the eval target is subjective.
5. **Builders can build the measurement harness first** (Better Stack): the run authored its own 136-tool headless-Chromium/Playwright rig producing deterministic screenshots, state extraction, pixel diffs. The evidence channel is a buildable artifact.
6. **Meta-prompt pattern** (Better Stack): user supplies only [GOAL] + [OPTIONAL REFERENCES]; the top model designs the pipeline (5 phases, 30 agents: foundation, systems, integrate, critique x5 lenses, fix).
7. **Routing verdict** (Mansel Scheffel tmSXYtW17yg, 2026-08-07): gauntlet pays only under **valuable route uncertainty** (novel/no known path, subjective-taste experiences, adversarial research). Known-pattern domains: empirical failure, 3.1M tokens / 6h cloning a normal real-estate site, unusable result. His pre-gauntlet ladder: (1) prompt, (2) skill/trusted path, (3) repair loop vs known-good tests, (4) gauntlet, last resort.
8. **Cheap-executor confirmation** (Firecrawl): running everything at max effort on the top model is wasteful; top model as lead only, delegate execution down. Independent arrival at the fable-max delegation conclusion.
9. **Fake separation fails** (ALL The AI Guy SOyOwvKiAPw, 2026-08-09): chat-UI roleplay of the pattern (same conversation "critic", no fresh context, no screenshot pipeline) needed days of manual "continue" and still shipped broken camera math, weightless physics. The pattern's value is in the actual agent separation, not the vocabulary.

## Flagged as unverified

- Devsplainers' "$20k Anthropic C-compiler loop" example: challenged in comments ("proven false"), do not reuse as a validated case.
- Devsplainers' "53 loops did not improve performance" stat: no citation found by commenters.
