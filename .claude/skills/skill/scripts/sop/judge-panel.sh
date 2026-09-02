#!/bin/bash
# Cross-family judge panel: Claude Opus + Gemini 3.7 Flash (OpenRouter). Usage: judge-panel.sh <promptfile>
# Prints a WINNER line only when both judges name the same letter; otherwise WINNER: TIE (harness counts it undecided).
D="$(dirname "$0")"; P="$1"
O="$(bash "$D/judge-claude.sh" "$P" 2>/dev/null)"; G="$(bash "$D/judge-gemini.sh" "$P" 2>/dev/null)"
wo="$(printf '%s\n' "$O" | grep -m1 -oE '^WINNER:\s*[AB]' | grep -oE '[AB]$')"
wg="$(printf '%s\n' "$G" | grep -m1 -oE '^WINNER:\s*[AB]' | grep -oE '[AB]$')"
if [ -n "$wo" ] && [ "$wo" = "$wg" ]; then
  printf 'WINNER: %s\n' "$wo"
  printf '%s\n' "$O" | grep -m1 -E '^EVIDENCE:' || echo "EVIDENCE: (opus) none"
  printf 'LOSER_FAULT: opus: %s | gemini: %s\n' "$(printf '%s\n' "$O" | grep -m1 -E '^LOSER_FAULT:' | cut -c14-)" "$(printf '%s\n' "$G" | grep -m1 -E '^LOSER_FAULT:' | cut -c14-)"
else
  printf 'WINNER: TIE\nEVIDENCE: judges disagree (opus=%s gemini=%s)\nLOSER_FAULT: panel-disagree\n' "${wo:-?}" "${wg:-?}"
fi
