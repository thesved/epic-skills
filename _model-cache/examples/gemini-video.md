# Gemini video - analysis + Veo generation prompt examples

Verified 2026-06-13. Analysis: `gemini-3.5-flash` (collect) / `gemini-3.1-pro-preview` (reason). Generation: `veo-3.1-lite-generate-preview`. Call shapes → `../gemini.md`; local-file analysis uses `../../gemini/video.sh`. Timestamps `MM:SS`. `[off]`=official, `[com]`=community.

---

## ANALYSIS - transcript + timestamps (audio as anti-hallucination anchor; split audio vs visual) [off]
```
Transcribe verbatim as | MM:SS | speaker | text |. Below, list visual-only events (on-screen text,
slides, cuts) with their own MM:SS. Do not invent events not present in audio or frames.
```

## ANALYSIS - tutorial → runnable runbook (pin to OCR'd frame text) [com]
```
Extract every shell command/code/config shown or spoken. JSON: [{"ts","step","command":exact or null,"why"}].
Preserve exact flags/filenames; mark obscured commands "PARTIAL".
```

## ANALYSIS - critique / editorial review [com]
```
Act as a video editor. List with MM:SS: (1) pacing dead-zones >3s, (2) audio/visual desync,
(3) where the hook could move earlier, (4) on-screen-text typos. Only flag what's actually present. Rank by severity.
```

## ANALYSIS - cost levers [off]
- Clip server-side: `videoMetadata:{startOffset:'90s',endOffset:'120s'}` - only that window is tokenized.
- Static content (slides/lecture): `videoMetadata:{fps:0.2}` (1 frame/5s); raise fps for fast action.
- Two-pass: low-res Flash builds an index (`| MM:SS | label |`), Pro drills into the clipped window only.

---

## VEO - structure `[shot]+[subject]+[action]+[scene]+[lighting]+[style]+[audio]`, 3-6 sentences, ONE camera move/clip [off]

**Cinematic single shot** - shot type first + lens + named grade (Veo locks onto film vocab):
```
Close-up, very shallow DoF, a young woman's face looking out a bus window at passing city lights,
her reflection faint on the glass, night rainstorm, melancholic cool blue tones, cinematic.
```
**Dialogue w/ lip-sync, no caption garbage** - `says: "…"` drives lips; always kill baked-in captions [com]:
```
Medium shot, a chef adds herbs to pasta, warm light. He looks at camera and enthusiastically says:
"This is the secret ingredient." SFX: sizzling pan. No subtitles, no on-screen text.
```
**Multi-shot in one render** - `[00:00-00:02]` timestamp blocks, each its own move + SFX.
**Negative = describe the absence** ("a desolate landscape, no buildings, empty horizon"), not "no X".
Audio syntax: dialogue `says: "…"` · effects `SFX: thunder cracks` · ambient `Ambient noise: quiet hum`.

Sources: Gemini video-understanding docs · Sveta Morag (Google Cloud Medium) field guide · Google Cloud "Ultimate prompting guide for Veo 3.1" · GlobalGPT/Skywork audio-aware Veo 2026.
