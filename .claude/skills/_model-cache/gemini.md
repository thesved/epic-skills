# Gemini model cache

Verified 2026-06-13 - every capability below **passed `_model-cache/verify.sh --full` (real artifacts)**: text, lite, image, tts, **live realtime audio**, veo video-gen, lyria music, deep-research, YouTube video-analysis. Also cross-checked vs official `ai.google.dev` docs/changelog + community. Prices = USD per 1M tokens unless noted. **Google hot-swaps `-latest`/`-preview` alias targets with ~2wk notice** - pin a dated id for anything reproducible; this file is the pin. Refresh: `_model-cache/update.sh gemini` then the `update-models` mode of `/gemini-bridge`.

Default auth = **paid `GEMINI_API_KEY`** (env, else keychain `gemini-api-key`), REST `generateContent`. Pay-as-you-go, no free-tier wall. **The `gemini` CLI is DEAD (2026-07-09: OAuth `IneligibleTierError`, migrate-to-Antigravity) - everything is REST now.** `agy` (Antigravity, OAuth) is the opt-in agentic seat only.

## TEXT / REASONING
| id | in | out | status | notes |
|---|---|---|---|---|
| `gemini-3.5-flash` | 1.50 | 9.00 | **GA, default workhorse** | cache-in 0.15; 1M ctx / 65k out |
| `gemini-3.1-pro-preview` | 2.00→4.00 | 12.00→18.00 | preview, **best reasoning** | >200k ctx doubles in / +50% out; out incl thinking tokens |
| `gemini-3-flash-preview` | 0.50 | 3.00 | preview | cheap mid-tier; prefer 3.5-flash for prod |
| `gemini-2.5-pro` | 1.25→2.50 | 10.00→15.00 | GA, **shutdown 2026-10-16** | |
| `gemini-2.5-flash` | 0.30 | 2.50 | GA, **shutdown 2026-10-16** | |
| `gemini-2.5-flash-lite` | 0.10 | 0.40 | GA | cheapest GA lite |
| ~~`gemini-3-pro-preview`~~ | - | - | **DEAD 2026-03-09** | → use `gemini-3.1-pro-preview` |

Pick: **Flash to collect** (transcribe/summarize/extract/OCR/translate - mechanical), **Pro to think** (intent/cause/tradeoffs/synthesis). Set thinking via `thinkingConfig.thinkingLevel` (3.x) / `thinkingBudget` (2.5). Cache hit -90% input ($1/hr storage). Batch API = 50% off, ≤24h.

## LITE (smoke / bulk)
`gemini-flash-lite-latest` (alias → `gemini-3.1-flash-lite`, 0.25/1.50) · `gemini-3.1-flash-lite` · `gemini-2.5-flash-lite` (0.10/0.40). Smoke uses `gemini-flash-lite-latest` (self-updating, never stale).

## ALIASES (auto-retarget, ~2wk notice - current targets 2026-06)
`gemini-flash-latest`→`3.5-flash` · `gemini-pro-latest`→`3.1-pro-preview` · `gemini-flash-lite-latest`→`3.1-flash-lite`. Use aliases only for smoke; pin dated ids elsewhere.

## IMAGE (Nano Banana; `generateContent`, NOT imagen's `:predict`)
| id | per-image | status |
|---|---|---|
| `gemini-3.1-flash-image` ("Nano Banana 2") | ~0.045 (≤1K) → ~0.15 (4K) | **GA, cheap-iterate default** |
| `gemini-3-pro-image` ("Nano Banana Pro") | 0.039 (≤1K) → 0.134 (2K) → 0.24 (4K) | **GA, studio/4K, legible text, ≤14 ref imgs** |
| `gemini-2.5-flash-image` ("Nano Banana") | ~0.039 | GA, gen-1 |
| ~~`*-image-preview`, `nano-banana-pro-preview`~~ | - | **shutdown 2026-06-25** → GA ids |
| ~~`imagen-4.0-*`~~ | - | **shutdown 2026-06-24** → Nano Banana |

Call (REST, **key required** - CLI 404s on image models):
```bash
curl -s "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-image:generateContent?key=$KEY" \
  -H 'content-type: application/json' \
  -d '{"contents":[{"parts":[{"text":"PROMPT"}]}],
       "generationConfig":{"responseModalities":["IMAGE"],
         "imageConfig":{"aspectRatio":"16:9","imageSize":"2K"}}}' \
| jq -r '.candidates[0].content.parts[]?|select(.inlineData?)|.inlineData.data' | base64 -d > out.jpg
```
- `imageSize`: `1K`|`2K`|`4K` (+`512`/`0.5K` on 3.1-flash); resolution drives price. `aspectRatio`: 1:1, 16:9, 9:16, 4:3, 3:2, 21:9, … Default 1K.
- **Output is base64 in `inlineData`; read its `mimeType`** - docs say PNG, REST has returned JPEG in practice. Decode is the same.
- **Edit**: prepend a `{"inlineData":{"mimeType":"image/jpeg","data":"<src-b64>"}}` part before the text part (state the delta only, e.g. "make the apple green"). Pro composes up to 14 input images.
- Prompt as a scene/narrative, not keyword soup. Pro renders legible text - quote exact strings for posters/UI mockups.

## TTS (`generateContent` + `responseModalities:["AUDIO"]`; **key required**)
| id | in | out |
|---|---|---|
| `gemini-3.1-flash-tts-preview` | 1.00 | 20.00 |
| `gemini-2.5-flash-preview-tts` | 0.50 | 10.00 |
| `gemini-2.5-pro-preview-tts` | 1.00 | 20.00 |

Output = **raw PCM s16le / 24kHz / mono** (no WAV header - wrap with `ffmpeg -f s16le -ar 24000 -ac 1`). 30 voices (Kore, Puck, Zephyr, Charon, …), 70+ langs, ≤2 speakers, inline tags `[whispers]`/`[laughs]`/`[excited]`. Single: `speechConfig.voiceConfig.prebuiltVoiceConfig.voiceName`. Multi: `speechConfig.multiSpeakerVoiceConfig.speakerVoiceConfigs[]` (the `speaker` field must match `Name:` prefixes in the text). **Full reference + meditation pacing: `gemini-bridge/tts.md`, `gemini-bridge/tts-meditation-pacing.md`.**

## REALTIME AUDIO - Live API (WebSocket `BidiGenerateContent`)
Bidirectional voice/streaming. **Client: `_model-cache/realtime_gemini.py`** (raw `websockets`, text→WAV; verified). URL `wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1beta.GenerativeService.BidiGenerateContent?key=$KEY` - **key is a `?key=` query param, NOT a header**; no beta header.
| id | type | status | notes |
|---|---|---|---|
| `gemini-2.5-flash-native-audio-preview-12-2025` | native-audio | preview | **default**; affective dialog, proactive audio |
| `gemini-3.1-flash-live-preview` | native-audio 3.x | preview | newer gen; `thinkingLevel` |
| `gemini-live-2.5-flash-native-audio` | native/half-cascade | **GA** | use if you need GA SLA |
| `gemini-3.5-live-translate-preview` | translate | preview | realtime speech translation only |
Flow (3 sends): `{setup:{model:"models/…",generationConfig:{responseModalities:["AUDIO"],speechConfig…}}}` → wait `setupComplete` → `{clientContent:{turns:[…],turnComplete:true}}` → collect `serverContent.modelTurn.parts[].inlineData.data` (base64) until `turnComplete`. **Output = 24kHz PCM16 mono** (input is 16kHz - easy to mix up); audio arrives as many chunks; `max_size=None` on connect. Pricing: text $0.50/$2, **audio $3/$12** per 1M (~25 tok/s audio). Session ≤15min audio-only. Latency ~4s round-trip for a short turn (first audio <1s, then real-time). Browser → ephemeral token (`v1alpha`), never raw key. Native-audio = expressive; half-cascade = robust under tool-use.

## VIDEO ANALYSIS
| source | how | cap |
|---|---|---|
| YouTube URL | pass `fileData.fileUri=<url>` - public only | paid: no length limit |
| local <100MB | inline base64 - use the helper (`video.sh`) | <100MB inline |
| local big/long | **Files API** (upload→poll ACTIVE→generate→delete) | 2GB free / 20GB paid |

**Local files: use `gemini-bridge/video.sh`** (Files API; requires the key tier - OAuth can't reach Files API). Default 1 FPS sampling (raise `GEMINI_FPS` for rapid motion/dense text). `media_resolution` low=66 tok/frame vs default 258; ~1hr @ default / ~3hr @ low within 1M ctx. Up to 10 videos/request. Clip with `start_offset`/`end_offset` to save tokens. Flash 3.5 to collect, Pro 3.1 to reason.

## VIDEO-GEN - `veo-3.1-lite-generate-preview`
Async: `POST .../models/veo-3.1-lite-generate-preview:predictLongRunning` body `{instances:[{prompt,image?}],parameters:{aspectRatio,durationSeconds,resolution}}` → returns Operation → poll `operations.get` until `done` → read video URI. ~$0.03/s (720p) → ~0.05-0.08/s (audio). Preview, no free tier. Latency ~45s per short clip (~6-10s per sec of output video). (Also: `veo-3.1-generate-preview`, `veo-3.1-fast-generate-preview`, legacy `veo-3.0-*`/`veo-2.0-*`.)

## MUSIC-GEN - `lyria-3-pro-preview`
`:generateContent` w/ `responseModalities:["AUDIO"]`, prompt in `contents` → **44.1kHz 192kbps stereo MP3** (`audio/mpeg`, verified). Name instruments/BPM/key/mood, use `[Verse]/[Chorus]/[Bridge]` tags. ~$0.04-0.08/song, ~20s/song. (Clip: `lyria-3-clip-preview`.) No tools/grounding/thinking.

## DEEP-RESEARCH - `deep-research-pro-preview-12-2025`
Agentic multi-step → cited reports (powered by 3.1 Pro, 1M ctx in / 65k out). **Interactions API only** - `generateContent` 400s ("only supports Interactions API"). `POST .../v1beta/interactions?key=$KEY` body `{"agent":"deep-research-pro-preview-12-2025","input":"…","background":true}` (**`background:true` is required**) → returns `{id,status:"in_progress"}` → poll `GET .../interactions/{id}` until `status:"completed"` (~2-3 min even for a tiny query, ~120k tokens - mostly tool-use + thought; high variance). Read `steps[]` for the cited report. For Claude-side research prefer the `/deep-research` skill.

## Other live models (from endpoint, niche)
native-audio (`gemini-2.5-flash-native-audio-*`), live/translate (`gemini-3.1-flash-live-preview`, `gemini-3.5-live-translate-preview`), computer-use (`gemini-2.5-computer-use-preview`), robotics-er, embeddings (`gemini-embedding-001`/`-2`), `gemma-4-*`, `antigravity-preview-05-2026`. Run `update.sh gemini` to see the full current list.

## DEPRECATION CALENDAR
| date | event → replacement |
|---|---|
| 2026-06-01 | `gemini-2.0-flash`/`-lite` retired (EOL) |
| 2026-06-24 | all `imagen-4.0-*` shut down → Nano Banana |
| 2026-06-25 | image `*-preview` + `nano-banana-pro-preview` → GA `*-image` ids |
| 2026-10-16 | `gemini-2.5-flash` + `gemini-2.5-pro` shut down → 3.5-flash / 3.1-pro |
| (done) 2026-03-09 | `gemini-3-pro-preview` → `gemini-3.1-pro-preview` |
