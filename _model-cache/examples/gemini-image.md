# Gemini image (Nano Banana) - prompt examples

Verified 2026-06-13. Models: `gemini-3.1-flash-image` (fast edits), `gemini-3-pro-image` (text/layout/4K). Call shape (REST, key required) → `../gemini.md`. `[off]`=official, `[com]`=community.

## Rules [off]
- Prompt as a **scene/narrative, not keyword soup**; put the key subject first.
- Params live in `generationConfig.imageConfig` (`aspect_ratio`, `image_size:"1K"|"2K"|"4K"`); some proxies drop it silently → **also state the ratio in prose** ("a 9:16 vertical poster").
- Output is base64 in `inlineData` - read its `mimeType` (REST returns JPEG in practice).

## Photoreal scene - 5-slot `[subject]+[action]+[location]+[composition]+[style/camera]`, end with film-stock+grade [off]
```
A fashion model in a tailored brown dress, confident statuesque stance, deep cherry-red studio
backdrop, medium-full shot center-framed, editorial, shot on medium-format analog film, pronounced
grain, cinematic lighting.
```
Add explicit lens + named camera color science: `shallow DoF (f/1.8), shot on Fujifilm, golden-hour backlighting`.

## Legible text / poster (Pro, 4K) - literal text in quotes + font weight + position + "perfectly legible" [off/com]
```
A 9:16 vertical minimalist thriller poster titled "THE SILENT ECHO". Title in large distressed
sans-serif at top, perfectly legible, centered. A lone cabin in a snowy forest from above. High-contrast B&W.
```
Pro does per-line fonts + multilingual + "cut-out window" text effects in one render. For diagrams add `tools=[{"google_search":{}}]` to ground facts; say "labels correctly spelled", 4K.

## Conversational edit - describe ONLY the delta, pin what stays [off]
```
Change the lighting to golden hour. Keep the composition and subject identical.
```
```
Remove the person in the background and replace with a potted plant. Keep everything else unchanged.
```

## Multi-ref compose (≤14) - assign each reference an explicit role [off]
```
Use Image A for pose, Image B for art style, Image C for background. Combine into one cinematic
16:9 image; change the dress to the dress in Image D.
```
Brand consistency: `"maintain exact logo placement and colorway"`.

Sources: Google Cloud "Ultimate prompting guide for Nano Banana" · Google blog Nano Banana Pro tips · Atlabs guide 2026 · Vidmuse 2026 · LiteLLM #18656 (imageConfig dropped).
