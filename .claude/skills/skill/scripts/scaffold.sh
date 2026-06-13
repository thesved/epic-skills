#!/usr/bin/env bash
# scaffold.sh <skill-name> [target-skills-dir] - create a new skill directory
# from assets/SKILL.template.md. Default target is ~/.claude/skills.
set -uo pipefail
SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAME="${1:?usage: scaffold.sh <skill-name> [target-skills-dir]}"
DEST="${2:-$HOME/.claude/skills}/$NAME"

echo "$NAME" | grep -qE '^[a-z0-9-]{1,64}$' || { echo "ERROR: name must be lowercase a-z, 0-9, hyphen, 1-64 chars" >&2; exit 1; }
echo "$NAME" | grep -qiE 'claude|anthropic' && { echo "ERROR: name cannot contain 'claude' or 'anthropic'" >&2; exit 1; }
[ -e "$DEST" ] && { echo "ERROR: $DEST already exists" >&2; exit 1; }

mkdir -p "$DEST"
sed "s/{{NAME}}/$NAME/g" "$SELF/../assets/SKILL.template.md" > "$DEST/SKILL.md"
echo "created $DEST/SKILL.md"
echo "next: fill it in, then validate -> python3 $SELF/validate.py \"$DEST\""
