# /caveman install (loaded only on `caveman install`)

Paths below are relative to the caveman skill dir (`~/.claude/skills/caveman/`).

Upsert project communication block (caveman + visual-first + mockups-before-code) into project CLAUDE.md. Block content lives in `assets/claude-md-block.md`, copy it verbatim. No HTML marker comments; block's own `## Communication (hard rules)` heading IS the anchor for detect + replace.

Long-session drift: CLAUDE.md style rules fade as context grows (Opus 5, observed 2026-08). If user wants caveman to survive long sessions, also install the block as a Claude Code output style (`~/.claude/output-styles/caveman.md`, pick via `/config` → Output style); the harness auto-reinjects output styles mid-session. Never make terse a hard global cap on plans/code: it degrades agent planning, keep it scoped to prose replies.

**MOST IMPORTANT RULE: block must be the FIRST `##` section.** Insert point = right before first existing `##` heading (real headings only; `##` lines inside fenced code blocks don't count). H1 + intro prose under it stay together ABOVE block (never split title from its intro; if line after H1 is already `##`, block lands right after H1). No `##` headings -> end of file, after H1 + prose. No H1 at all -> line 1. Never bury below other `##` sections; first section binds, buried rules get skimmed past.

Procedure (default target `./CLAUDE.md`, optional arg overrides path):

1. No CLAUDE.md -> create it, file = block only.
2. Find existing block: exact heading `## Communication (hard rules)`; miss -> grep `ALWAYS /caveman` (heading maybe renamed by hand). Section = heading to next `#`/`##` heading or EOF.
3. Not found -> insert block at correct spot (after H1 if H1 first heading, else line 1), blank line around, rest untouched.
4. Found at correct spot -> replace section body with current asset (refresh).
5. Found elsewhere -> delete old section, insert fresh at correct spot. Never two copies. Legacy installs (pre-2026-07) wrapped block in `<!-- caveman:install:start/end -->` comments, often above H1; delete BOTH marker lines with the old section, they are not part of section-by-heading math.
6. Verify after edit: first `##` in file is the block heading; no duplicate `ALWAYS /caveman` lines; zero `caveman:install` marker comments remain. Fail -> fix before reporting done.
7. Report: installed / moved / refreshed / unchanged + one-line block summary.

Asset file is the single source of block content; never hand-edit installed copies outside this procedure.

Example: repo has CLAUDE.md = `# MyProject`, intro paragraph, `## Setup`. User says "caveman install". Result: `# MyProject`, intro paragraph unchanged, blank line, `## Communication (hard rules)` block, blank line, `## Setup` and everything else unchanged. Reply: "Block in as first section. 3 rules: caveman always, visual-first decisions, mockups before code."
