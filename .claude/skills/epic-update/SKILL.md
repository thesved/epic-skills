---
name: epic-update
description: Update epic-skills to the latest version. Triggers "update skills", "update epic-skills", "upgrade the skills".
argument-hint: '(fetch latest + apply, preserving local edits)'
---

# update - pull the latest epic-skills

```
bash ~/.claude/skills/epic-update/update.sh
```
(Or from a project install: `bash <target>/epic-update/update.sh`.)

Fetches the public repo into a cache clone and applies it **without clobbering your edits**:
- file untouched since install → overwritten with the new version,
- file you edited → kept as-is; new version dropped beside it as `<file>.new` to merge,
- new files added; **non-managed skills (not in `MANIFEST`) are never touched.**

Reports the `VERSION` change and counts (overwritten / new / your-edits-preserved). After it runs, tell the user to review any `.new` files. Overrides: `EPIC_REPO`, `EPIC_CACHE`.
