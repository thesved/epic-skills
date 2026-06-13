# Gemini audio - TTS + Live realtime prompt examples

Verified 2026-06-13. TTS `gemini-3.1-flash-tts-preview` (full ref → `../../gemini/tts.md`); Live `gemini-2.5-flash-native-audio-preview-12-2025`. Call shapes → `../gemini.md`. `[off]`=official, `[com]`=community.

---

## TTS - style steering: `Say <style>:` prefix (not spoken) is the cheapest lever [off]
```
Say cheerfully: Have a wonderful day!
Style: nervous tone accelerating into excitement and relief.  Text: The lock clicked. Nobody was there. We were finally free.
```

## TTS - inline tags (documented only - invented tags degrade prosody) [off]
emotion `[excitedly][warmly][gently][thoughtfully]` · non-speech `[sighs][laughing][uhm]` · volume `[whispers][shouting]` · pace `[short pause]`≈250ms `[long pause]`≈1s
```
[sighs] Oh. [gently] I'm really sorry to hear that. [warmly] We'll get this sorted out [gently] for you... right away.
```

## TTS - multi-speaker (≤2) - names in prompt MUST match `speakerVoiceConfigs`; per-speaker style in the lead-in [off]
```
TTS, Speaker1 anxious+fast, Speaker2 calm: Speaker1: [very fast] The deploy is failing in prod-
Speaker2: [warmly] Breathe. Roll back to the last green build.
```

## TTS - director long-form - guard against reading stage directions aloud (#1 failure) [off]
```
…direction only. Do NOT speak them. Speak ONLY the lines under #### TRANSCRIPT.
```
temp 0.4 = consistent (support/technical) · 0.6-0.7 = expressive (storytelling).

---

## Live realtime - voice-agent system instruction - the "VOICE / no lists / digestible" guard is highest-leverage (else robotic text-shaped prose) [com]
```
You are a voice assistant - keep responses conversational and concise. Speak naturally; avoid lists
or formatting that doesn't work in speech. Break info into digestible pieces; ask a clarifying
question if ambiguous. Before any irreversible action, confirm details aloud first.
```

## Live realtime - turn-taking + language lock [off/com]
- Barge-in (native-audio handles interruption): `"If the user pauses mid-order, wait - do NOT fill silence. Stop talking the instant the user speaks."`
- Pin language (it switches by default): `"Respond ONLY in Hungarian regardless of input language."`
- `enable_affective_dialog=True` for emotion-aware prosody - **feature-detect** (400s on some model ids, python-genai#865).

Sources: ai.google.dev speech-generation · Cloud Gemini-TTS · AI Studio TTS guide (LiveKit) · Firecrawl voice agent · Cloud Live API native audio · python-genai#865.
