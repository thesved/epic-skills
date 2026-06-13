#!/usr/bin/env bash
# Shared helpers for the model-cache scripts. Source this self-locating, so it
# works at any install root (~/.claude/skills OR <project>/.claude/skills):
#   SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; . "$SELF/../_model-cache/lib.sh"

# resolve_key VARNAME -> prints the key, security-first across platforms:
#   1) OS secret store  2) current env  3) skills .env  4) shell rc export line.
# OS store: macOS Keychain (security) / Linux libsecret (secret-tool) / pass.
# Store service+account name = lowercased var, _->- : GEMINI_API_KEY -> gemini-api-key.
resolve_key() {
  local n="$1" v="" svc rc envf root
  svc="$(printf '%s' "$n" | tr 'A-Z_' 'a-z-')"
  # 1) OS secret store (most secure)
  if command -v security >/dev/null 2>&1; then           # macOS Keychain
    v="$(security find-generic-password -a "$USER" -s "$svc" -w 2>/dev/null)"
  fi
  if [ -z "$v" ] && command -v secret-tool >/dev/null 2>&1; then   # Linux libsecret
    v="$(secret-tool lookup service "$svc" 2>/dev/null)"
  fi
  if [ -z "$v" ] && command -v pass >/dev/null 2>&1; then          # pass
    v="$(pass show "$svc" 2>/dev/null | head -1)"
  fi
  # 2) current env
  [ -z "$v" ] && eval "v=\${$n:-}"
  # 3) skills .env (KEY=val or export KEY=val), self-located then HOME default
  if [ -z "$v" ]; then
    root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." 2>/dev/null && pwd)"
    for envf in "$root/.env" "$HOME/.claude/skills/.env"; do
      [ -f "$envf" ] || continue
      v="$(grep -E "^[[:space:]]*(export[[:space:]]+)?$n=" "$envf" 2>/dev/null | tail -1 \
           | sed -E 's/^[^=]*=//; s/^"//; s/"[[:space:]]*$//; s/^'\''//; s/'\''[[:space:]]*$//')"
      [ -n "$v" ] && break
    done
  fi
  # 4) shell rc export line (covers session env predating an rc edit)
  if [ -z "$v" ]; then
    for rc in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.profile"; do
      [ -f "$rc" ] || continue
      v="$(grep -E "^[[:space:]]*export[[:space:]]+$n=" "$rc" 2>/dev/null | tail -1 \
           | sed -E 's/^[^=]*=//; s/^"//; s/"[[:space:]]*$//; s/^'\''//; s/'\''[[:space:]]*$//')"
      [ -n "$v" ] && break
    done
  fi
  printf '%s' "$v"
}

# wav_ok FILE -> 0 if FILE is a non-trivial RIFF/WAVE file (>1KB of audio)
wav_ok() {
  [ -f "$1" ] || return 1
  local sz; sz=$(stat -f%z "$1" 2>/dev/null || stat -c%s "$1" 2>/dev/null || echo 0)
  [ "$sz" -gt 1024 ] && file "$1" | grep -qi 'WAVE audio'
}
