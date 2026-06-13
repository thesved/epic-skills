# Skill spec: fields, limits, structure

Ground truth from the Agent Skills standard and the Claude Code skills docs. When in doubt, run `scripts/validate.py`; it enforces the mechanical rules here.

## Contents
- Required frontmatter
- Optional Claude Code frontmatter
- Size and structure limits
- Where skills live
- String substitutions

## Required frontmatter

| Field | Rule |
| --- | --- |
| `name` | 64 chars max, lowercase `a-z`, `0-9`, hyphen only. Must match the directory name. Cannot contain `claude` or `anthropic`. Gerund form reads well (`processing-pdfs`). |
| `description` | 1024 chars max, non-empty, third person. State what it does AND when to use it, with key trigger terms. Front-load the main use case: the combined `description` + `when_to_use` is truncated at 1536 chars in the skill listing. |

The directory name (not the `name` field) becomes the `/command`. The `name` field is the display label.

## Optional Claude Code frontmatter

Use an extra only when it materially changes behavior. Default is none.

| Field | Use |
| --- | --- |
| `when_to_use` | Extra trigger phrases, appended to the description in the listing (counts toward the 1536 cap). |
| `argument-hint` | Autocomplete hint, e.g. `new <idea> | change <name>`. |
| `disable-model-invocation: true` | Only the user can invoke it (`/name`). Use for side-effect workflows (deploy, commit). Removes it from auto-trigger entirely. |
| `user-invocable: false` | Only Claude can invoke it. Use for background-knowledge skills that are not user actions. |
| `allowed-tools` | Tools pre-approved while active. Grant the minimum; an unused grant is a finding. |
| `disallowed-tools` | Tools removed while active (e.g. `AskUserQuestion` for an autonomous loop). |
| `model`, `effort` | Override model or effort for the skill's turn. |
| `context: fork` + `agent` | Run the skill in a forked subagent. Only for skills with an actual task, not pure reference. |
| `paths` | Glob patterns that gate auto-activation to matching files. |

In the body, `${CLAUDE_SKILL_DIR}` resolves to the skill's own directory; use it for bundled script paths so they work at any install location. `$ARGUMENTS`, `$0`, `$1` substitute invocation arguments.

## Size and structure limits

- SKILL.md body under 500 lines. Past that, split into `references/`.
- Keep references ONE level deep from SKILL.md. A reference file that points to another reference file gets partially read and breaks. Link every reference directly from SKILL.md.
- Any reference file over 100 lines gets a table of contents at the top, so a partial read still sees the full scope.
- `scripts/` = executed code (not loaded into context). `references/` = docs loaded on demand. `assets/` = files used in output (templates).
- Forward-slash paths only. No Windows backslashes.

## Where skills live

`~/.claude/skills/<name>/` (personal, all projects) or `<project>/.claude/skills/<name>/` (project only). Precedence: enterprise > personal > project. A skill and a same-named `.claude/commands/` file: the skill wins.
