#!/usr/bin/env bash
# sentinel.sh - dumb progress watchdog for ONE steer run. Runs INSIDE the runner's
# Bash call (blocks), never in the orchestrator. No model in the loop.
#
#   sentinel.sh <name> [--stall SECS] [--max SECS] [--tick SECS]
#
# exit 0  run finished (status idle/stopped)      prints tail of out.md
# exit 2  stall: out.md did not grow for --stall seconds (default 300) while running
# exit 3  driver or app-server died (status dead, or pid gone)
# exit 4  wall clock exceeded --max seconds (default 3600)
# exit 5  limit/auth signature seen in new output (rate limit, usage limit, 401/403)
# exit 1  no such agent / bad args
set -uo pipefail
BASE="${CODEX_STEER_HOME:-$HOME/.codex-steer}"
name="${1:-}"; shift || true
[ -n "$name" ] || { sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'; exit 1; }
stall=300; max=3600; tick=10
while [ $# -gt 0 ]; do
  case "$1" in
    --stall) stall="$2"; shift 2;; --max) max="$2"; shift 2;; --tick) tick="$2"; shift 2;;
    *) echo "unknown arg: $1"; exit 1;;
  esac
done
d="$BASE/$name"; st="$d/state.json"; out="$d/out.md"
[ -f "$st" ] || { echo "ERR: no such agent '$name' ($st)"; exit 1; }
jqs() { jq -r "$1" "$st" 2>/dev/null; }
alive() { [ -n "${1:-}" ] && [ "$1" != "null" ] && kill -0 "$1" 2>/dev/null; }
size() { stat -f %z "$out" 2>/dev/null || stat -c %s "$out" 2>/dev/null || echo 0; }
start=$SECONDS; last_size=$(size); last_growth=$SECONDS; seen=$last_size
ts() { date +%H:%M:%S; }
while :; do
  status="$(jqs .status)"
  case "$status" in
    idle|stopped)
      echo "[$(ts)] done status=$status turns=$(jqs .turns_completed) elapsed=$((SECONDS-start))s"
      echo "--- out.md tail ---"; tail -25 "$out" 2>/dev/null; exit 0;;
    dead)
      echo "[$(ts)] DEAD status=dead last_error=$(jqs .last_error)"; exit 3;;
  esac
  alive "$(jqs .driver_pid)" || { echo "[$(ts)] DEAD driver pid gone (status=$status)"; exit 3; }
  now=$(size)
  if [ "$now" -gt "$last_size" ]; then
    # scan only the new bytes for limit/auth signatures
    if tail -c $((now - seen)) "$out" 2>/dev/null | grep -qiE 'rate.?limit|usage limit|quota|401|403|unauthorized|reauthenticate'; then
      echo "[$(ts)] LIMIT/AUTH signature in new output (status=$status)"; tail -15 "$out"; exit 5
    fi
    seen=$now; last_size=$now; last_growth=$SECONDS
  elif [ $((SECONDS - last_growth)) -ge "$stall" ]; then
    echo "[$(ts)] STALL no output growth for ${stall}s (status=$status, size=${now}B)"; tail -15 "$out"; exit 2
  fi
  [ $((SECONDS - start)) -ge "$max" ] && { echo "[$(ts)] MAX wall time ${max}s reached (status=$status)"; tail -15 "$out"; exit 4; }
  sleep "$tick"
done
