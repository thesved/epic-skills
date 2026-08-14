#!/usr/bin/env bash
# steer.sh - steerable delegated codex runs (SendMessage semantics for GPT executors).
# Wraps driver.py, which owns one long-lived `codex app-server` child per agent.
#
#   steer.sh start <name> [-C workdir] [-m model] [-s sandbox] [prompt-file]   (stdin fallback)
#   steer.sh msg <name> "<text>"       inject into the RUNNING turn; idle -> new turn, context kept
#   steer.sh img <name> <path> ["<text>"]   inject a local image (e.g. fresh screenshot) mid-turn
#   steer.sh interrupt <name>          abort the live turn; thread + context survive
#   steer.sh wait <name> [timeout-s]   block until the turn finishes, print the tail of out.md
#   steer.sh status <name>             state.json + last output lines
#   steer.sh tail <name>               follow out.md
#   steer.sh stop <name>               terminate the agent's app-server (ALWAYS do this when done)
#   steer.sh ls                        list agents + statuses (audit for orphans - procguard)
#
# State per agent: $CODEX_STEER_HOME (default ~/.codex-steer)/<name>/
# Agents survive the launching session (setsid) - that is the point, and the risk:
# every start MUST be paired with a stop.
set -uo pipefail
SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE="${CODEX_STEER_HOME:-$HOME/.codex-steer}"

usage() { sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 1; }
[ $# -ge 1 ] || usage
cmd="$1"; shift || true

adir() { echo "$BASE/$1"; }
alive() { # alive <pid>
  [ -n "${1:-}" ] && [ "${1:-}" != "null" ] && kill -0 "$1" 2>/dev/null
}
jqs() { jq -r "$1" "$2" 2>/dev/null; }
driver_alive() { alive "$(jqs .driver_pid "$(adir "$1")/state.json")"; }

send_cmd() { # send_cmd <name> <json>
  local d; d="$(adir "$1")"
  driver_alive "$1" || { echo "ERR: agent '$1' driver not running (status: $(jqs .status "$d/state.json"))"; return 1; }
  # FIFO write blocks until the driver reads; watchdog guards a wedged driver
  # (macOS has no timeout(1))
  ( printf '%s\n' "$2" > "$d/cmd.fifo" ) & local w=$!
  local i=0
  while kill -0 "$w" 2>/dev/null; do
    i=$((i + 1))
    [ $i -ge 50 ] && { kill "$w" 2>/dev/null; echo "ERR: fifo write timed out (driver wedged?)"; return 1; }
    sleep 0.1
  done
  wait "$w" 2>/dev/null
}

case "$cmd" in
start)
  name="${1:?name}"; shift
  wd="$PWD"; model="gpt-5.6-sol"; sandbox="workspace-write"
  while [ $# -gt 0 ]; do case "$1" in
    -C) wd="${2:?}"; shift 2;;
    -m) model="${2:?}"; shift 2;;
    -s) sandbox="${2:?}"; shift 2;;
    *) break;;
  esac; done
  d="$(adir "$name")"
  if [ -f "$d/state.json" ] && driver_alive "$name"; then
    echo "ERR: agent '$name' already running (steer.sh stop $name first)"; exit 1
  fi
  mkdir -p "$d"
  rm -f "$d/state.json" "$d/events.jsonl" "$d/out.md" "$d/cmd.fifo" "$d/driver.log"
  mkfifo "$d/cmd.fifo"
  if [ -n "${1:-}" ] && [ -f "$1" ]; then cat "$1" > "$d/prompt.md"; else cat > "$d/prompt.md"; fi
  wd="$(cd "$wd" && pwd)"
  # driver calls os.setsid() itself (macOS has no setsid binary)
  python3 "$SELF/driver.py" --dir "$d" --workdir "$wd" \
    --model "$model" --sandbox "$sandbox" > "$d/boot.log" 2>&1 < /dev/null &
  disown
  # wait for the handshake (thread id) or an early death
  for _ in $(seq 1 60); do
    st="$(jqs .status "$d/state.json")"
    case "$st" in
      idle|running) echo "started '$name': thread=$(jqs .thread_id "$d/state.json") status=$st dir=$d"; exit 0;;
      dead) echo "ERR: startup failed: $(jqs .last_error "$d/state.json")"; tail -3 "$d/driver.log" 2>/dev/null; exit 1;;
    esac
    sleep 1
  done
  echo "ERR: startup timeout (see $d/driver.log)"; exit 1;;
msg)
  name="${1:?name}"; shift
  send_cmd "$name" "$(jq -cn --arg t "$*" '{cmd:"msg",text:$t}')" && echo "sent"; ;;
img)
  name="${1:?name}"; path="${2:?image path}"; text="${3:-}"
  [ -f "$path" ] || { echo "ERR: no such image: $path"; exit 1; }
  path="$(cd "$(dirname "$path")" && pwd)/$(basename "$path")"
  send_cmd "$name" "$(jq -cn --arg p "$path" --arg t "$text" '{cmd:"img",path:$p,text:$t}')" && echo "sent"; ;;
interrupt)
  send_cmd "${1:?name}" '{"cmd":"interrupt"}' && echo "sent"; ;;
wait)
  name="${1:?name}"; tmo="${2:-600}"; d="$(adir "$name")"
  end=$((SECONDS + tmo))
  while [ $SECONDS -lt $end ]; do
    st="$(jqs .status "$d/state.json")"
    case "$st" in idle|stopped|dead)
      echo "status=$st turns=$(jqs .turns_completed "$d/state.json")"
      echo "--- out.md tail ---"; tail -25 "$d/out.md" 2>/dev/null; exit 0;;
    esac
    sleep 2
  done
  echo "ERR: wait timed out after ${tmo}s (status=$(jqs .status "$d/state.json"))"; exit 1;;
status)
  d="$(adir "${1:?name}")"
  jq . "$d/state.json" 2>/dev/null || { echo "no such agent"; exit 1; }
  echo "--- out.md tail ---"; tail -8 "$d/out.md" 2>/dev/null; ;;
tail)
  tail -f "$(adir "${1:?name}")/out.md"; ;;
stop)
  name="${1:?name}"; d="$(adir "$name")"
  [ -f "$d/state.json" ] || { echo "no such agent"; exit 1; }
  send_cmd "$name" '{"cmd":"stop"}' 2>/dev/null
  for _ in $(seq 1 10); do
    st="$(jqs .status "$d/state.json")"
    [ "$st" = stopped ] || [ "$st" = dead ] && { echo "stopped '$name'"; exit 0; }
    sleep 1
  done
  # driver unresponsive: kill directly and mark state
  for p in "$(jqs .appserver_pid "$d/state.json")" "$(jqs .driver_pid "$d/state.json")"; do
    alive "$p" && kill "$p" 2>/dev/null
  done
  sleep 1
  jq '.status="stopped" | .live_turn_id=null' "$d/state.json" > "$d/.state.tmp" && mv "$d/.state.tmp" "$d/state.json"
  echo "force-stopped '$name'"; ;;
ls)
  [ -d "$BASE" ] || { echo "(no agents)"; exit 0; }
  found=0
  for s in "$BASE"/*/state.json; do
    [ -f "$s" ] || continue
    found=1
    n="$(jqs .name "$s")"; st="$(jqs .status "$s")"
    if [ "$st" = idle ] || [ "$st" = running ]; then
      driver_alive "$n" || st="dead(stale)"
    fi
    echo "$n  status=$st  turns=$(jqs .turns_completed "$s")  thread=$(jqs .thread_id "$s")"
  done
  [ "$found" = 1 ] || echo "(no agents)"; ;;
*) usage;;
esac
