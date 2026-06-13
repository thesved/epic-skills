---
name: epic-install
description: Install / set up epic-skills on this machine. Triggers "install", "setup", "install the skills", "set up epic-skills".
argument-hint: '(walk me through install) | home | project'
---

# epic-install: set up epic-skills

Goal: a working install where `/board`, `/gemini-bridge`, `/codex-bridge`, `/think` and the rest run. Walk the user through it; the mechanics live in `install.sh` (run it from the cloned repo). **Source** = the dir containing this skill (`SRC`).

## 0. Hook them first - WHY this is worth 2 minutes
Before asking anyone to fetch API keys, give a short, PERSONAL taster so they actually finish setup. People bail on key-wrangling unless they see the payoff first. In 2-3 sentences, tie the value to something concrete:
- **In a project?** Name a real decision/pain you can see in their repo and show the one line they'd run. e.g. *"You've got three auth approaches half-started in `src/auth/`. Once this is set up, instead of one opinion you'll type `/board which auth approach should I commit to?` and get Opus + Gemini + Codex weighing in at once, with their disagreements flagged."*
- **Not in a project?** Pull from recalled memory about the user (role, domain, what they're building) and make the example theirs. If memory is empty, give one vivid example and ask what they're working on.

Close the taster with the cost and a yes/no: *"Takes ~2 min, 3 steps (copy, one API key, done). Want to set it up?"* Then continue.

## 1. Where to install - ASK
- **Home** (default, global to all projects): `~/.claude/skills`
- **Project** (scoped to this repo, committable): `<project>/.claude/skills`

Then copy:
```
bash SRC/epic-install/install.sh copy --target <TARGET>
```
This copies only the managed skills (per `MANIFEST`), writes `.install-manifest` + `.installed-version` (used by `/update`), and rewrites doc paths for project installs. It never touches the user's other skills.

## 2. API keys - set up securely
Keys go into the **OS secret store** first (macOS Keychain / Linux libsecret / `pass`), else a `chmod 600` `.env`. **Do not paste keys into the chat.** Give the user these commands to run themselves (silent prompt, piped straight to the store):

| Key | Needed for | Get it at |
|---|---|---|
| `GEMINI_API_KEY` | Gemini seat, video/TTS/image (paid tier) | https://aistudio.google.com/apikey |
| `OPENAI_API_KEY` | optional - codex image-gen / API-key models | https://platform.openai.com/api-keys |
| `OPENROUTER_API_KEY` | optional - throttle fallback | https://openrouter.ai/keys |

```
read -rs GEMINI_API_KEY && printf '%s' "$GEMINI_API_KEY" | \
  bash <TARGET>/epic-install/install.sh store-key GEMINI_API_KEY --target <TARGET>; unset GEMINI_API_KEY
```
(Repeat per key. The user can run these with a leading `!` in this session.)

## 3. CLIs + auth
The seats call two CLIs:
- **Gemini**: `npm i -g @google/gemini-cli` (the bridge's REST features use `GEMINI_API_KEY`).
- **Codex**: `npm i -g @openai/codex`, then **`codex login`** (ChatGPT account OAuth - the Codex seat needs this, not an API key).

## 4. Caveman mode - ASK (opt-in)
If the user wants terse-by-default replies globally:
```
bash <TARGET>/epic-install/install.sh caveman
```
Appends one line to `~/.claude/CLAUDE.md` (idempotent). Skip it and `/caveman` still works on demand.

## 5. Verify
```
bash <TARGET>/epic-install/install.sh check --target <TARGET>
```
Reports CLI presence and runs the board smoke. **Read the seat line carefully** - distinguish:
- *no key* → key not in store/env (redo step 2),
- *seat ERR / auth* → CLI not logged in (`codex login`) or wrong tier,
- *ok* → seat live.

Tell the user which seats are green and the exact next command for any that aren't. Then ACTIVATE them (step 6).

## 6. Activate - orient + live demo
Don't stop at "installed". Show the user what they now have and prove it on something real.

**a. Show the map.** Print this plain-ASCII flow and define each skill in plain words (no jargon):
```
 you
  |
  v
 /orient    ->  "where am I, what's next?"  (maps your project in plain words)
  |
  v
 /think     ->  reason hard; pull in the board when the call is big
  |
  v
 /board     ->  ask Opus + Gemini + Codex at once; where they DISAGREE = the signal
  |              |-- /gemini-bridge : video, YouTube, translate, image, TTS, long docs
  |              '-- /codex-bridge  : spec-grade prompts, gpt-image, 2nd-architecture take
  v
 /grill-me  ->  it interviews YOU until the plan has no soft spots
 /ask       ->  the reverse: Claude asks you a question only when genuinely stuck
  |
  v
 /wrap      ->  close the session so a cold start resumes with zero context loss
```

**b. Tailor a demo to their context:**
- **In a project?** (cwd has `.git`, `package.json`, `src/`, or other code) Run a REAL mini-demo on it: run `/orient` to map where they are, then point at one concrete thing the board/think would help with right now (a TODO, a risky file, an open decision you can see). 
- **Not in a project?** Use what you know about the user from recalled memory (role, domain, current work) to craft a scenario that is relevant to THEM. If memory is empty, ask one quick "what are you working on?" and build from the answer.

**c. Run ONE step for real** (keep it cheap: a single `/think` or `/board` call) so they SEE it work, not just read about it. Then hand over the wheel: "now try `/think <your actual task>`."

Keep the whole activation noob-friendly and short - the goal is an "oh, I get it" moment, not a manual.
