#!/usr/bin/env bash
# install.sh - mechanical installer for epic-skills. Flag/subcommand driven; the
# `epic-install` SKILL drives the interactive choices and calls these.
#
#   install.sh copy   --target DIR [--from SRC]   copy managed skills + write install state
#   install.sh store-key NAME [--target DIR]      read value on stdin -> OS store (or .env)
#   install.sh min-header [CLAUDE_MD]             prepend keep-minimal banner (idempotent)
#   install.sh caveman [CLAUDE_MD]                append caveman line (idempotent)
#     CLAUDE_MD: pass the PROJECT's <project>/CLAUDE.md by default; the SKILL
#     falls back to ~/.claude/CLAUDE.md (the arg default) only outside a project.
#   install.sh check  [--target DIR]              CLI + key + smoke health report
#
# SRC defaults to this repo (the dir containing install/). TARGET defaults to
# ~/.claude/skills. Scripts are self-locating, so only SKILL.md prose carries an
# absolute path - `copy` rewrites it to TARGET when TARGET isn't the default home.
set -uo pipefail

SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DEFAULT="$(cd "$SELF/.." && pwd)"
HOME_TARGET="$HOME/.claude/skills"
sha() { { shasum -a 256 "$1" 2>/dev/null || sha256sum "$1" 2>/dev/null; } | awk '{print $1}'; }
svc_of() { printf '%s' "$1" | tr 'A-Z_' 'a-z-'; }

cmd_copy() {
  local target="$HOME_TARGET" src="$SRC_DEFAULT"
  while [ $# -gt 0 ]; do case "$1" in
    --target) target="$2"; shift 2;; --from) src="$2"; shift 2;; *) shift;; esac; done
  [ -f "$src/MANIFEST" ] || { echo "FATAL: no MANIFEST in $src" >&2; return 1; }
  mkdir -p "$target"
  local rewrite=0; [ "$target" != "$HOME_TARGET" ] && rewrite=1
  echo "→ installing into $target  (source: $src)"
  local manifest="$target/.install-manifest"; : > "$manifest"
  while read -r d; do
    [ -z "$d" ] && continue; case "$d" in \#*) continue;; esac
    [ -e "$src/$d" ] || { echo "  ! missing in source: $d" >&2; continue; }
    rsync -a --delete --exclude='.git' --exclude='.snap-*' --exclude='__pycache__' \
          --exclude='*.pyc' --exclude='.DS_Store' --exclude='.updated' "$src/$d/" "$target/$d/"
    # rewrite prose path for non-home installs
    [ "$rewrite" = 1 ] && grep -rIl '~/.claude/skills' "$target/$d" 2>/dev/null \
      | while read -r f; do sed -i.bak "s#~/.claude/skills#$target#g" "$f" && rm -f "$f.bak"; done
    # record hashes for update's edit-detection
    find "$target/$d" -type f ! -name '*.bak' | while read -r f; do
      echo "$(sha "$f")  ${f#$target/}" >> "$manifest"; done
    echo "  ✓ $d"
  done < "$src/MANIFEST"
  for rf in VERSION LICENSE README.md; do [ -f "$src/$rf" ] && cp "$src/$rf" "$target/$rf"; done
  cp "$src/VERSION" "$target/.installed-version" 2>/dev/null || true
  echo "→ installed $(cat "$src/VERSION" 2>/dev/null || echo '?') · state: .install-manifest, .installed-version"
}

cmd_store_key() {
  local name="$1"; shift; local target="$HOME_TARGET"
  while [ $# -gt 0 ]; do case "$1" in --target) target="$2"; shift 2;; *) shift;; esac; done
  local val; val="$(cat)"; val="${val%$'\n'}"
  [ -z "$val" ] && { echo "  ! empty value for $name, skipped" >&2; return 1; }
  local svc; svc="$(svc_of "$name")"
  if command -v security >/dev/null 2>&1; then
    security add-generic-password -U -a "$USER" -s "$svc" -w "$val" && { echo "  ✓ $name → macOS Keychain ($svc)"; return; }
  fi
  if command -v secret-tool >/dev/null 2>&1; then
    printf '%s' "$val" | secret-tool store --label="$svc" service "$svc" && { echo "  ✓ $name → libsecret ($svc)"; return; }
  fi
  if command -v pass >/dev/null 2>&1; then
    printf '%s\n' "$val" | pass insert -m -f "$svc" >/dev/null && { echo "  ✓ $name → pass ($svc)"; return; }
  fi
  local envf="$target/.env"; touch "$envf"; chmod 600 "$envf"
  grep -vE "^(export )?$name=" "$envf" > "$envf.tmp" 2>/dev/null || true; mv "$envf.tmp" "$envf"
  echo "$name=$val" >> "$envf"
  echo "  ✓ $name → $envf (no OS secret store found; chmod 600)"
}

cmd_min_header() {
  local md="${1:-$HOME/.claude/CLAUDE.md}"
  local line='**KEEP THIS FILE MINIMAL - caveman-terse, prune the unnecessary, NEVER bloat/trash it. Top-rules + cheat-sheet ONLY; war-stories/rationale/derivations → `learnings/INDEX.md`. Every edit: shorten, don'\''t pad.**'
  mkdir -p "$(dirname "$md")"; touch "$md"
  grep -qF "KEEP THIS FILE MINIMAL" "$md" && { echo "  · minimal-header already in $md"; return; }
  { printf '%s\n\n' "$line"; cat "$md"; } > "$md.tmp" && mv "$md.tmp" "$md"
  echo "  ✓ prepended minimal-header to $md"
}

cmd_caveman() {
  local md="${1:-$HOME/.claude/CLAUDE.md}"
  local line='ALWAYS reply caveman mode: terse, drop articles/fillers/pleasantries. Tech terms exact. (skill: /caveman)'
  mkdir -p "$(dirname "$md")"; touch "$md"
  grep -qF "(skill: /caveman)" "$md" && { echo "  · caveman line already in $md"; return; }
  printf '\n%s\n' "$line" >> "$md"; echo "  ✓ appended caveman line to $md"
}

cmd_check() {
  local target="$HOME_TARGET"
  while [ $# -gt 0 ]; do case "$1" in --target) target="$2"; shift 2;; *) shift;; esac; done
  echo "CLI:"
  command -v gemini >/dev/null 2>&1 && echo "  ✓ gemini CLI" || echo "  ✗ gemini CLI missing → npm i -g @google/gemini-cli"
  command -v codex  >/dev/null 2>&1 && echo "  ✓ codex CLI"  || echo "  ✗ codex CLI missing → npm i -g @openai/codex"
  command -v jq     >/dev/null 2>&1 && echo "  ✓ jq" || echo "  ✗ jq missing (needed by the Gemini seat)"
  echo "Keys / seats:"
  if [ -x "$target/board/smoke.sh" ]; then bash "$target/board/smoke.sh" 2>&1 | sed 's/^/  /'
  else echo "  ! $target/board/smoke.sh not found"; fi
}

case "${1:-}" in
  copy)      shift; cmd_copy "$@";;
  store-key) shift; cmd_store_key "$@";;
  min-header) shift; cmd_min_header "$@";;
  caveman)   shift; cmd_caveman "$@";;
  check)     shift; cmd_check "$@";;
  *) echo "usage: install.sh {copy|store-key NAME|min-header|caveman|check} [opts]"; exit 1;;
esac
