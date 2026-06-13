# epic-skills

A curated set of [Claude Code](https://claude.com/claude-code) skills: a **multi-model board** (Opus + Gemini + Codex), the **thinking discipline** to use it well, and a few sharp utilities. The seats let Claude delegate to whichever model is actually strongest - Gemini for video/translation/TTS, Codex for spec-grade prompts - and weigh their disagreements.

## Install - one line, any agent

Paste this to your coding agent (Claude Code, etc.):

> **Clone `https://github.com/thesved/epic-skills`, run `bash epic-skills/epic-install/install.sh copy --target ~/.claude/skills`, then walk me through the `epic-install` skill** (API keys, CLIs, verification).

Or do it yourself:

```bash
git clone https://github.com/thesved/epic-skills ~/epic-skills
bash ~/epic-skills/epic-install/install.sh copy --target ~/.claude/skills
# then, in Claude Code:  /epic-install   →  sets up keys, CLIs, and verifies the board
```

Install to a **project** instead of globally by passing `--target <project>/.claude/skills`. Update later with `/epic-update` (preserves any edits you made).

## How it fits together - one workflow

The skills are designed to chain. A typical session:

```
/orient        →  where am I, what's next (caveman-terse map of the project)
/think  <task> →  Opus reasons hard, escalates to the board when it matters
/board  <q>    →  Opus + Gemini + Codex answer in parallel; disagreement = signal
   ├─ /gemini-bridge  →  video/YouTube, non-English copy, image, TTS, long docs
   └─ /codex-bridge   →  spec-grade prompts for Opus, gpt-image, a 2nd-architecture take
/grill-me      →  get interviewed until the plan has no soft spots
/ask           →  (the inverse) Claude asks YOU only when genuinely blocked
/wrap          →  close the session so a cold start resumes with zero context loss
```

Plus standalone utilities: **`/caveman`** (terse mode, ~75% fewer tokens), **`/chrome`** (drive Chrome over the DevTools Protocol).

## Prerequisites

| Tool | For | Install |
|---|---|---|
| `gemini` CLI | Gemini seat + media | `npm i -g @google/gemini-cli` |
| `codex` CLI | Codex seat | `npm i -g @openai/codex` → `codex login` |
| `jq`, `curl` | Gemini seat plumbing | your package manager |
| `ffmpeg` (opt) | TTS/audio output | your package manager |

**API keys** (set up by `/epic-install`, stored in your OS secret store - Keychain / libsecret / `pass`):

| Key | Needed for | Get it at |
|---|---|---|
| `GEMINI_API_KEY` | Gemini seat, video/TTS/image | https://aistudio.google.com/apikey |
| `OPENAI_API_KEY` | optional - Codex image-gen / API models | https://platform.openai.com/api-keys |
| `OPENROUTER_API_KEY` | optional - throttle fallback | https://openrouter.ai/keys |

## `_model-cache`

Model ids, pricing, and call-shapes live in `_model-cache/`. **They go stale** - providers hot-swap aliases and prices. Refresh with `bash _model-cache/update.sh` and verify with `bash _model-cache/verify.sh --cheap`. Never hardcode model ids; the cache + self-updating aliases are the pin.

## License

MIT - see [LICENSE](LICENSE).
