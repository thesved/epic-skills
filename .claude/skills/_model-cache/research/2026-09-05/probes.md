# Live probes, 2026-09-05 (Muse Spark 1.3 and GPT-6 Astra)

Run by the orchestrator from this Mac (Budapest) between ~07:40 and ~10:30 UTC. Each row is a real call.

| probe | result |
|---|---|
| OpenRouter catalog grep `muse` | `meta/muse-spark-1.3` and `-contributor` created 2026-09-02, `muse-spark-1.2` 08-05, `-1.2-contributor` 08-21, `muse-spark-1.1` 07-16, `muse-glimmer-30b` 08-09 (+`:batch`). Spark: 1,048,576 ctx, 943,718 max out, text+image+video+file+audio in, single upstream Meta, moderated |
| `meta/muse-spark-1.3` "Reply OK", first attempt | 403 `This model requires you to complete the following before use: 18+ age confirmation. Confirm at https://openrouter.ai/settings/preferences.` (`missing_attestation_types ["age_18plus"]`). User confirmed the attestation ~08:10 UTC; the same call then served from Meta in 3.2 s |
| `meta/muse-spark-1.3-contributor` after attestation | 404 `0 endpoints out of 1 requested are available matching your guardrail restrictions and data policy ... Paid model training violation (account settings)`: our account forbids paid-training endpoints; same guardrail that blocks DeepSeek first-party |
| effort dial on Spark 1.3 ("Reply OK") | default 181 reasoning tokens 3.2 s; low 109 / 1.9 s; high 145 / 2.6 s; xhigh 249 / 7.5 s (only xhigh returned a one-line reasoning summary); max 128 / 2.8 s (accepted, no proof it is Meta's max); `effort: none` and `enabled: false` both 400 `Reasoning is mandatory for this endpoint and cannot be disabled.` |
| identity | "Muse Spark (version unknown), developer unknown, cutoff unknown, today September 05, 2026" (the model knows the date; never trust self-identification) |
| 293K-token needle, effort low | 3/3 planted facts, 15 s, $0.369, 405 reasoning tokens |
| video: YouTube URL as `video_url` | 400 `unsupported media type ... text/html. Supported: MP4.` (Gemini 3.7 Flash answered the same call correctly) |
| video: 6 s MP4 with speech as `video_url` data URI | text on screen and spoken code both correct, 7.5 s, 1,673 input tokens, $0.005; the same MP4 as a `file` part also worked (11.8 s) |
| audio: WAV as `input_audio` | first call 504; retry answered "I don't see any audio attached", i.e. the part is silently dropped |
| audio: m4a as `input_audio` | 400 `unsupported file type ... m4a` |
| audio: MP3 as `input_audio` | transcribed correctly (code 7194; "Tallinn" heard as "Talon"), 6.1 s |
| audio: MP3 inside a `file` part | ignored ("I don't see an audio file attached") |
| PDF (one page, hand-built) as `file` part | correct code and date, 4.2 s, 2,563 input tokens |
| structured output strict json_schema (integer, enum, nested array) | valid, 9/9 field checks (also on Glimmer) |
| `muse-glimmer-30b` | served by DeepInfra/Phala/Fireworks in 1.0-2.6 s with visible reasoning; not pursued further (user: not interesting) |
| Codex CLI 0.153.2, ChatGPT Pro login, `-m gpt-6-astra` | `OK`, 4,097 tokens (rollout reached the account) |
| OpenAI API key, `POST /v1/responses` gpt-6-astra | completed, 16 tokens |
| OpenRouter catalog grep `gpt-6` | `openai/gpt-6-astra`, `-pro`, both with `:batch`, created 2026-09-04, $10/$50; `google/gemini-3.8-flash` created 2026-09-02, $0.75/$3.75 |
| `_model-cache/update.sh openai` | NEW: gpt-6-astra |
| Codex custom provider to OpenRouter | `wire_api="chat"` refused by Codex 0.153 ("no longer supported"); `wire_api="responses"` works for `openai/gpt-5.6-luna` (answered OK); for `meta/muse-spark-1.3` Meta returns 400 `` `name` must be at most 64 characters, got 66 `` even with apps, goals, multi-agent, plugins, request_user_input, collaboration_modes and web_search features off (captured request: 18 tools incl. a `codex_apps` namespace; no single `name` field over 42 chars in the JSON, so the limit is applied to something OpenRouter or Meta derives) |
| yt-dlp 2025.10.14 (Python 3.9 pins it) watch pages | `The page needs to be reloaded` on every watch page all day (flat `ytsearch` fine); cookies from the CDP Chrome profile did not help; 277 of 311 metadata fetches empty. The Gemini video route (OpenRouter, Google AI Studio provider) kept working, so analyses ran with flat-search metadata only |
| Codex CLI update | `npm i -g --prefix ~/.local/share/codex-cli @openai/codex@latest`: 0.153.2 -> 0.153.4 |
