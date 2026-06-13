# Gemini generative - Lyria music + Deep-research prompt examples

Verified 2026-06-13. Music `lyria-3-pro-preview` (≤3min; clip `lyria-3-clip-preview`). Research `deep-research-pro-preview-12-2025` (Interactions API). Call shapes → `../gemini.md`. `[off]`=official, `[com]`=community.

---

## LYRIA music - NO `negative_prompt` (bake exclusions into prose). Section tags `[Intro][Verse][Chorus][Bridge][Outro]`.

**Timestamped arrangement** (Pro superpower - direct the timeline) [off]:
```
[00:00] Massive gospel choir, uplifting. [00:15] Heavy hip-hop beat + 808 drop. [00:30] Male lead
raps a confident verse; choir punctuates. [01:10] Triumphant chorus, brass horns. [01:50] Strip to
gentle Hammond B3, quiet bridge. [02:10] Full choir + beat return; end on a sustained chord at [03:00].
```
**Spec-dense instrumental** - BPM + named instruments + "Instrumental only" [off]:
```
A 30s lofi hip hop beat, dusty vinyl crackle, mellow Rhodes chords, slow boom-bap at 85 BPM, jazzy upright bass. Instrumental only.
```
**Directed vocal** - range + dynamic arc + lyric *theme* (not verbatim lyrics; copyright filter) [off]:
```
A moody jazz ballad, piano + upright bass. Female breathy soulful soprano, starts confident then
calmer/quieter as it progresses. Lyrics about meeting the love of her life in New York.
```
Reproducibility: `seed:42` (omit sample_count) to iterate identically; `sample_count:4` (omit seed) for variations.

---

## DEEP-RESEARCH - async (`background=True`), poll until `completed`. Default tools: google_search + url_context + code_execution.

**Impose the report skeleton in-prompt** (parseable deliverable, not an essay) [com]:
```
Research Google TPUs. Focus: 1) breakthroughs last 12mo 2) position vs Nvidia/AMD.
Format as a strategic briefing: concise bullets + a table comparing the top 3 companies.
```
**Explicitly ask for charts** (`visualization="auto"` under-triggers): `"Include charts showing market-share changes over 5 years."`
**Restrict tools** to cut latency/cost: `tools=[{"type":"google_search"}]`.
**Planning gate** for $3-7 runs: `agent_config.collaborative_planning:True` to review the plan, then flip to `False` to actually execute (prose "go ahead" won't trigger it).
**Grounded over your docs:** mix `file_search` (private store) + `google_search` (public) in `tools`.
> For Claude-side research prefer the `/deep-research` skill. Faster/maxer seats: `deep-research-preview-04-2026` / `-max-preview-04-2026`.

Sources: Google Cloud "Ultimate prompting guide for Lyria 3 Pro" · ai.google.dev music-generation + deep-research · philschmid.de Deep Research guides · Vertex Lyria API ref.
