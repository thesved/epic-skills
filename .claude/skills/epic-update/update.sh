#!/usr/bin/env bash
# update.sh - pull the latest epic-skills and apply them without clobbering your
# local edits. Per-file: untouched -> overwrite; locally edited -> write <file>.new
# and keep yours. Only touches managed skills (MANIFEST); never your other skills.
#
#   bash epic-update/update.sh           # fetch + apply, report VERSION change + edits
#   EPIC_REPO   public repo URL (default https://github.com/thesved/epic-skills.git)
#   EPIC_CACHE  clone cache dir   (default ~/.claude/cache/epic-skills)
set -uo pipefail

TARGET="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="${EPIC_REPO:-https://github.com/thesved/epic-skills.git}"
CACHE="${EPIC_CACHE:-$HOME/.claude/cache/epic-skills}"
MAN="$TARGET/.install-manifest"
sha() { { shasum -a 256 "$1" 2>/dev/null || sha256sum "$1" 2>/dev/null; } | awk '{print $1}'; }
recorded() { grep -F "  $1" "$MAN" 2>/dev/null | tail -1 | awk '{print $1}'; }

# 1) fetch
if [ -d "$CACHE/.git" ]; then
  echo "→ fetching latest into $CACHE"; git -C "$CACHE" pull -q --ff-only || { echo "✗ git pull failed" >&2; exit 1; }
else
  echo "→ cloning $REPO"; mkdir -p "$(dirname "$CACHE")"; git clone -q "$REPO" "$CACHE" || { echo "✗ clone failed" >&2; exit 1; }
fi
SRC="$CACHE/.claude/skills"   # skills live under .claude/skills in the published repo
[ -f "$SRC/MANIFEST" ] || { echo "✗ no .claude/skills/MANIFEST in pulled repo" >&2; exit 1; }

OLDV="$(cat "$TARGET/.installed-version" 2>/dev/null || echo '?')"
NEWV="$(cat "$SRC/VERSION" 2>/dev/null || echo '?')"
echo "→ installed $OLDV → available $NEWV"

# 2) apply managed skills (paths are relative to the repo's .claude/skills)
DIRS=(); while IFS= read -r _l; do DIRS+=("$_l"); done < <(grep -vE '^[[:space:]]*(#|$)' "$SRC/MANIFEST")
NEWMAN="$(mktemp)"; up=0; kept=0; add=0
apply_file() { # relpath under .claude/skills
  local rel="$1" rf="$SRC/$rel" lf="$TARGET/$rel" nh lh rh
  nh="$(sha "$rf")"
  if [ ! -f "$lf" ]; then mkdir -p "$(dirname "$lf")"; cp "$rf" "$lf"; add=$((add+1)); echo "$nh  $rel" >> "$NEWMAN"; return; fi
  lh="$(sha "$lf")"
  if [ "$lh" = "$nh" ]; then echo "$nh  $rel" >> "$NEWMAN"; return; fi   # already current
  rh="$(recorded "$rel")"
  if [ "$lh" = "$rh" ] || [ -z "$rh" ]; then                            # untouched since install -> safe overwrite
    cp "$rf" "$lf"; up=$((up+1)); echo "$nh  $rel" >> "$NEWMAN"
  else                                                                  # user edited -> preserve, drop .new
    cp "$rf" "$lf.new"; kept=$((kept+1)); echo "  ~ kept your edit, new version at: ${rel}.new"
    echo "$rh  $rel" >> "$NEWMAN"                                       # keep old record so we flag again next time
  fi
}
for d in "${DIRS[@]}"; do
  [ -d "$SRC/$d" ] || continue
  while IFS= read -r rf; do apply_file "${rf#$SRC/}"; done < <(find "$SRC/$d" -type f ! -name '*.bak')
done
[ -f "$SRC/VERSION" ] && apply_file "VERSION"

mv "$NEWMAN" "$MAN"
printf '%s\n' "$NEWV" > "$TARGET/.installed-version"
echo "✓ update done: $up overwritten · $add new · $kept of your edits preserved (.new written)"
[ "$kept" -gt 0 ] && echo "  review the .new files and merge what you want."
