# TTS meditation pacing - authoring rubric

Companion to [tts.md](tts.md). Read this *before* writing any TTS script intended as a guided meditation, body scan, somatic practice, or hypnosis induction. TTS without these rules produces audiobook-style narration - fluent prose with no functional silence - which is unusable as a meditation.

## The rule that drives everything else

> **Audiobook narration uses pauses to pace the story. Guided meditation uses pauses as functional time for the listener to actually do the instruction.**

The pause is the practice. The words are scaffolding for the pause. Every pause-length decision is "how long does the listener need to *do* what I just said?"

---

## The empirical baseline

Whisper-transcribed Brett Kistler body-scan opening (real call recording, 3:14 of audio) vs the identical script through Gemini TTS Algieba with no wait tags:

| | Real meditation | Raw TTS | Gap |
|---|---|---|---|
| Effective rate (whole clip) | 87 wpm | 144 wpm | TTS is **1.65×** too fast |
| Speech-only rate | 153 wpm | 180 wpm | TTS is **1.18×** too fast |
| Silence ratio | 43% | 20% | TTS has **half** the silence |
| Pauses ≥ 2s | 17 | 0 | - |
| Pauses ≥ 5s | 3 | 0 | - |
| Max pause | 11.7s | 1.4s | - |

Punctuation alone (commas, periods, ellipses) gives ~0.3-1s gaps. That's audiobook prosody. To get meditation pacing, you must explicitly author `[wait N sec]` tags AND globally slow the speech rate (`atempo=0.85`, matching 153→130 wpm).

---

## The pause rubric

Tag pauses by the **linguistic type** of the prompt that precedes them, not by punctuation. Punctuation gives ~0.3s; the rubric below is what you author *on top* of natural punctuation.

| Prompt type | Example | `[wait N sec]` |
|---|---|---|
| **Setup / admin / framing** | "I'm sitting in my office." "We'll begin in a moment." | `[wait 1 sec]` |
| **Simple instruction** | "Let your eyes close." "Take a couple of breaths." | `[wait 2 sec]` |
| **Attention-directing instruction** | "Notice your breath." "Feel your feet on the ground." | `[wait 3 sec]` |
| **Somatic scan prompt** | "Feel the contact of your feet with the floor." "Drop your awareness into your belly." | `[wait 4 sec]` |
| **Depth probe / quantitative inquiry** | "How much of your breath can you feel?" "How deep can your roots go?" | `[wait 5 sec]` |
| **Experiential / phenomenological question** | "What's it like to be with your whole body?" "What's it like to notice both rhythms at once?" | `[wait 10 sec]` |
| **Section transition / integration** | End of body scan before next phase; "Stay with that." before opening eyes. | `[wait 12 sec]` |

**Rule of thumb**: pause length scales with the **interoceptive work** the listener has to do. "Notice X" is a 2-3 second action. "What's it like to be with X?" is a 10 second exploration. Cognitive load → silence budget.

**Anti-pattern**: pausing on punctuation alone. Commas and periods produce ~0.3-0.8s pauses - fine for natural prosody, useless for the practice.

---

## Authoring convention

**Write the real intended duration in one tag**: `[wait 12 sec]`. Do NOT chain shorter tags like `[wait 4 sec][wait 4 sec][wait 4 sec]`.

Why:
- The 4-second engine cap is a Gemini implementation detail. Your script shouldn't leak it.
- `tts-wait.sh` (this skill's wrapper) splices exact silence post-hoc using ffmpeg silence detection - it handles any duration.
- Chained tags collapse into one silence in the TTS output anyway (adjacent waits merge), so chaining is broken on top of being ugly.
- Single-tag scripts diff cleanly, port across TTS engines, and read like a meditation script.

Leading and trailing waits are also supported by the wrapper - append/prepend silence after the TTS call.

---

## Speech rate: use `atempo=0.85`, not sentence surgery

Brett speaks at 153 wpm. Gemini TTS runs at 180 wpm. **`atempo=0.85` slows 180 → 153 exactly.** Apply it as a global post-processing pass:

```bash
ffmpeg -y -i input.mp3 -filter:a "atempo=0.85" -codec:a libmp3lame -b:a 96k output.mp3
```

This is a clean separation of concerns: author for content + pauses, post-process for global pace. `atempo` preserves pitch (no chipmunk effect).

**Don't** try to slow speech by breaking sentences into fragments and over-punctuating. That produces choppy prosody and makes the script unreadable. Brett's speech-only rate is uniform (~153 wpm steady) - the cadence variability lives in the pauses, not the spoken phrases. Mirror that.

**Dissenting view** (Opus, on the board): for very tonal practices where you want non-uniform tempo (slow on key prompts, normal on framing), sentence-level rewriting is more controllable than global `atempo`. Reserve this for hypnosis inductions or trance work where pace is part of the technique. Default meditations: trust `atempo=0.85`.

---

## Style prompt - the prefix that goes before every meditation script

Gemini TTS voices drift toward whispered or sing-song prosody on long meditation scripts. Counter this with an explicit positive-only style prefix (never negative directives like "monotone" or "flat" - community testing shows those degrade output).

**Default meditation prefix (validated May 2026, body-scan test):**
```
Read the following guided meditation aloud at a full, audible speaking volume - NOT whispered, NOT breathy, NOT hushed. Use a deep, resonant, grounded chest voice with weight and warmth, like a trusted meditation teacher anchoring the listener. Speak slowly and steadily with calm authority. Each sentence lands fully before the next begins. Neutral accent. Honor every pause - they are functional silence for the listener to actually do the practice.
```

**Alternative (LiveKit-style "liquid" prefix - for trance/hypnosis pacing):**
```
The tempo is incredibly slow and liquid. Words bleed into each other. There is zero urgency. Speak in a deep, resonant, low register, like a meditation guide. Long, deliberate pacing. Leave space between phrases. Soft articulation.
```

Critical phrases (positive-only, no flatness directives):
- **"NOT whispered, NOT breathy, NOT hushed"** - these specific "NOT" phrasings counter the default drift to whispered ASMR. Note: still positive in framing the *target* ("full, audible").
- **"deep, resonant, grounded chest voice"** - biases toward chest-tone over head voice.
- **"Each sentence lands fully before the next begins"** - slows prosody per-phrase without artificial sentence-fragmenting.
- **"Honor every pause"** - signals to the model that `[wait]` tags are intentional, not formatting noise.

**Inline reinforcement.** Beyond the prefix, you can use `[gently]`, `[warmly]`, `[thoughtfully]`, `[slow]`, `[asmr]` as bracket tags at specific moments - composite descriptors like `[deep, resonant, slow]` also work. Avoid `[whispers]` (defeats the prefix).

**Voice picks for grounding meditations** (deep-timbre, chest-voice biased): **Algieba, Orus, Enceladus, Fenrir, Gacrux**. Secondary: Algenib, Charon, Iapetus. **Avoid for grounded delivery**: Despina, Achird, Sulafat (intrinsically softer/breathier - fight the voice less, pick the right one).

---

## Full workflow

```
1. Write script with [wait N sec] tags per the rubric.
2. Prepend the style prefix.
3. Pick a deep-timbre voice (Algieba / Orus / Enceladus etc.).
4. Run through tts-wait.sh **with -60dB silence detection** (mandatory for meditations - see "Word-cut prevention" below):
     ~/.claude/skills/gemini-bridge/tts-wait.sh \
       --voice Algieba \
       --silence-db -60dB --silence-min 1.5 \
       --out out.wav \
       --file script.txt
5. Convert to mp3 and apply atempo=0.85:
     ffmpeg -y -i out.wav -filter:a "atempo=0.85" \
       -codec:a libmp3lame -b:a 96k out_85.mp3
6. Sanity-check duration: target ~80-95 wpm effective rate over the whole clip
   (i.e., total_words / (total_seconds/60) should land in 80-95).
   If higher, you under-paused; add more [wait] tags.
   If lower, you over-paused; shorten some.
```

---

## Worked example - Brett's body scan, before and after

**Bad (no wait tags, raw script):**
```
Just settle in your chair. Take a couple of breaths. Notice your body as it
expands with the air and then contracts. Your breath. Notice it in your chest.
Maybe let your breath come all the way into your belly. See if you can notice
your breath in your arms, in your legs, in your pelvis. How much of your body
can you feel it in?
```
→ Renders at ~30 seconds. No room to actually do anything. Audiobook of a meditation.

**Good (authored with rubric):**
```
Just settle in your chair. [wait 2 sec] Take a couple of breaths. [wait 6 sec]
Notice your body as it expands with the air, and then contracts. [wait 5 sec]
Your breath. [wait 3 sec] Notice it in your chest. [wait 4 sec] Maybe let your
breath come all the way into your belly. [wait 8 sec] See if you can notice
your breath in your arms, in your legs, in your pelvis. [wait 8 sec] How much
of your body can you feel it in? [wait 10 sec]
```
→ Renders at ~80 seconds at 100% speed; ~95 seconds at `atempo=0.85`. Listener has actual time to *do* each prompt.

---

## Sanity-check your authored script

Before generating audio, run this mental check:

1. **For each `[wait N sec]` tag**, ask: *"If I just heard the previous instruction, do I have time to actually do it before the next words start?"* If no, increase the wait.
2. **For each "Notice X" / "Feel X" / "How much can you...?" prompt**, verify the trailing pause is ≥3s. If shorter, the prompt is functionally rhetorical.
3. **Count total `[wait]` seconds**, add ~0.5s/sentence for natural prosody, add speech time at ~130 wpm (post-atempo). Target effective rate: **80-95 wpm** over the whole clip. Brett was at 87 wpm; that's the gold standard.
4. **At least one pause ≥ 10s per ~3 minutes of script.** Without one, there's no "land it" moment - the listener never gets the experiential silence that distinguishes meditation from instruction.

---

## When TTS pacing breaks down

- **Word-cut artifacts before long pauses** (audible "chops" where the last syllable of a word disappears right before a `[wait]` silence): the silence threshold is too loud and catching the word's trailing decay. Use `--silence-db -60dB --silence-min 1.5`. Gemini TTS produces near-digital silence between phrases (hard zeros), so anywhere from -60dB down detects only true silence. Never use -30dB or -40dB for meditation work - those will eat word tails. Empirically verified on Algieba and Aoede, May 2026.
- **Wrapper reports "requested N waits, detected M silences" with M < N**: one wait collapsed into adjacent prosody. Lower `--silence-min` (try `1.0`) to catch shorter pauses. Do NOT raise `--silence-db` toward -30dB to force more detections - that's the word-cut trap. If still misdetected, split the script around that wait and concat.
- **Two `[wait]` tags adjacent in text** (`[wait 5 sec] [wait 5 sec]`): they merge into one silence in the TTS output. Combine into a single `[wait 10 sec]`.
- **Lead/trailing waits "lost"**: Gemini drops `[wait]` tags with no surrounding speech. The wrapper handles these by prepending/appending pure silence post-hoc - supported, but check the output duration matches expectations.
- **Voice still sounds whispered**: stronger style prefix ("full, audible, chest-toned, NOT whispered, NOT breathy"). Or switch voice - some are intrinsically soft.

---

## References

- Empirical analysis script: was at `/tmp/meditation_analysis/analyze_v2.py` during the May 2026 study. Reproduce by running Whisper with `--word_timestamps True --output_format json` on any real meditation, then computing word-end → next-word-start gaps and bucketing by linguistic prompt type.
- Source recording analyzed: AoA Old Student cohort call, 2025-12-03, Brett Kistler's opening body scan (0:27-4:16).
- Wrapper: [tts-wait.sh](tts-wait.sh) handles exact-length silence splicing.
- Main TTS reference: [tts.md](tts.md).
