---
name: gemini-bridge
description: >-
  Delegate to Google's Gemini when it's the stronger model: video analysis
  (especially YouTube - Gemini's biggest moat over Claude), non-English writing
  and review (Hungarian, German, Romanian…), image generation/editing,
  spoken-audio (TTS), long-context document analysis, and a different model's
  angle. Triggers: "ask gemini", "gemini write", "gemini review", "non-english
  copy", "translate", "generate image", "image with gemini", "edit this image",
  "text to speech", "tts", "spoken audio", "voice over", "narrate this", "read
  this aloud", "gemini tts", "analyze video", "youtube video", "watch this
  video", "summarize video", "long document", "what does gemini think",
  "different perspective", "another model's take". Proactively suggest when the
  user shares a YouTube URL or video file, wants non-English copy, generates/
  edits images, wants narration/TTS, or has a document too long for Claude.
argument-hint: write <task> | review <path> | translate <text> <lang> | image <prompt> | tts <text> [voice] | live <text> | video <url-or-path> [q] | ask <question> | smoke | verify [--full] | update-models [all|<ids>]
---

# Gemini - delegate when Gemini is stronger

Use Gemini for what Claude can't or does worse: **video analysis** (YouTube + local files - the moat), **non-English copy**, **image gen/edit**, **TTS**, **long-context**, and a genuinely different model's angle. Don't use it for routine English code work.

**Model ids, pricing, and exact call shapes live in the cache - read it before generating:** `~/.claude/skills/_model-cache/gemini.md` (and `index.md` for routing). For **how to prompt each model well**, read the ONE matching file in `~/.claude/skills/_model-cache/examples/` (each mode below names its file). This skill never hardcodes ids; they drift. The cache is the pin.

## Auth - default to the paid key
Default = **paid `GEMINI_API_KEY`** (env, else keychain `gemini-api-key`) via REST. Pay-as-you-go, no free-tier throttle wall - this is the default precisely because OAuth limits keep biting. Image/TTS/local-video **require** the key tier regardless. The `gemini` CLI obeys `~/.gemini/settings.json` → `security.auth.selectedType` (currently `oauth-personal`, so it ignores `GEMINI_API_KEY`); use REST `curl` for anything key-gated. `agy` (OAuth agentic seat) is opt-in only - see `/board`.

CLI use (text/`@file` ingestion): add `--skip-trust` to every headless call or it refuses ("not running in a trusted directory").

## Modes

### `write` / `review` / `translate` - non-English copy
Build a real brief (audience, voice, what to avoid, constraints, output format), not "translate this." Flash is enough for copy.
```bash
gemini --skip-trust -m gemini-3.5-flash -p "$(cat <<'EOF'
You are writing native-quality <lang> <copy type>. Audience: <…>. Voice: <…>.
Avoid: <literal-from-English, clichés>. Task: <…>. Constraints: <length/tone>. Output: just the copy.
EOF
)"
```
Review mode: ask for surgical defects ("quote each phrase that sounds translated, suggest a natural alternative"), not generic praise.

### `image` - generate / edit
REST + key only (CLI 404s on image models). **Read the IMAGE section of the cache** for the current id (`gemini-3.1-flash-image` cheap / `gemini-3-pro-image` studio), the `imageConfig` call shape, edit-via-inlineData, and per-image pricing. Output is base64 in `inlineData` - read its `mimeType`. Codex `gpt-image-2` is the fallback (`/codex-bridge image`) when you'd rather use OpenAI. **Prompt examples → `_model-cache/examples/gemini-image.md`.**

### `video` - YouTube or local file (the moat)
- **YouTube URL** → just pass it to the CLI; Gemini fetches it. For metadata + top comments folded in, prefer `/youtube`.
- **Local file** → `~/.claude/skills/gemini-bridge/video.sh "<path>" "<question>"` (Files API; the CLI can't upload local video). `GEMINI_MODEL=pro` for reasoning, `GEMINI_FPS=n` for rapid motion/dense text. Flash to collect (transcribe/OCR/list), Pro to reason (intent/cause). See the VIDEO section of the cache for sampling/limits. **Prompt examples (transcript, tutorial-extract, Veo gen) → `_model-cache/examples/gemini-video.md`.**

### `tts` - spoken audio
REST + key only. Quick path + the call shape are in the cache TTS section; **full reference (30 voices, multi-speaker, tags, WAV wrap): `~/.claude/skills/gemini-bridge/tts.md`. Meditation/hypnosis pacing: `~/.claude/skills/gemini-bridge/tts-meditation-pacing.md`** (read it or output is unusable audiobook narration). For one-line dev audio, macOS `say` is faster. **Prompt examples (style tags, multi-speaker, director) → `_model-cache/examples/gemini-audio.md`.**

### `live` - realtime / streaming voice (Live API, WebSocket)
For bidirectional voice agents or low-latency streaming TTS. `python3 ~/.claude/skills/_model-cache/realtime_gemini.py <model> <out.wav> "<text>"` (raw-websocket text→WAV; verified). Default model `gemini-2.5-flash-native-audio-preview-12-2025`. See the REALTIME section of the cache for the handshake, the `?key=` query-param auth, 24kHz output, and pricing (audio $3/$12 per 1M). For one-shot narration (not a live session), plain `tts` is cheaper. **Voice-agent prompt examples → `_model-cache/examples/gemini-audio.md`.**

### `ask` / long-context
```bash
gemini --skip-trust -m gemini-3.5-flash -p "<self-contained question>"   # or: @filepath inside the prompt to ingest files
```
Flash to collect, Pro to think (cache TEXT section). Throttle-proof key-backed one-shot (resolves key from keychain): `bash ~/.claude/skills/gemini-bridge/ask.sh <file|stdin>`. **Prompt examples (thinking control, JSON, long-context) → `_model-cache/examples/gemini-text.md`.** For Lyria music / deep-research → `_model-cache/examples/gemini-gen.md`.

### `smoke` / `verify` - is it actually working?
- `bash ~/.claude/skills/gemini-bridge/smoke.sh` → cheap liveness ping (lite model, paid key; `tier=standard` confirms paid).
- `bash ~/.claude/skills/_model-cache/verify.sh [--full]` → E2E PASS/FAIL table that **really calls** each capability (text/lite/image/tts/live; `--full` adds veo/lyria/deep-research/video). Use after `update-models` or when something seems off.

### `update-models` - refresh the cache
1. `bash ~/.claude/skills/_model-cache/update.sh gemini` - diffs the live model list vs snapshot, prints NEW/REMOVED/CHANGED.
2. Web-research **only** the flagged ids (capability + pricing + one best-practice sample) and edit `_model-cache/gemini.md`. Nothing changed → just refresh pricing.
3. `update-models all` re-researches everything; `update-models <ids>` only those.

## Output handling
Don't dump raw output. Summarize, quote the key bits. For copy/translations, offer alternatives. For images, report the saved path (`open <path>`). For non-English, show the user and ask if it reads naturally - don't assume Gemini nailed it.

## Failure modes
- **"not running in a trusted directory"** → add `--skip-trust`.
- **`ModelNotFoundError: 404` on image/TTS** → you're using the CLI; those are REST+key only (cache has the curl).
- **Local video via `@file` stalls** → CLI never uses the Files API (20MB inline cap); use `video.sh`.
- **`TerminalQuotaError` / quota** → OAuth tier burned; you should be on the key already (REST). 
- **Smoke ERR: no key** → add the key to keychain (`gemini-api-key`) or export `GEMINI_API_KEY`; `lib.sh` resolves env→`~/.zshrc`→keychain.
- **Key throttled / credits depleted (text)** → route the request through OpenRouter (`google/gemini-3.5-flash`) - see `_model-cache/openrouter.md`. (Media endpoints stay direct.)

## See also
- `/youtube` - YouTube wrapper adding title + description + top comments
- `/codex-bridge` - OpenAI take, prompt-writing, image-gen fallback (`gpt-image-2`)
- `/board` - multi-model panel (Opus + Gemini + Codex)
- `/think` - escalate to Opus when the need is harder thinking, not a different model
