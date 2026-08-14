#!/usr/bin/env bash
# launch.sh - start Chrome/Chromium with the DevTools Protocol open, on a
# DEDICATED profile. Chrome 136+ refuses --remote-debugging-port on the default
# user-data-dir, so a separate profile is required (and keeps your real browsing
# out of automation). Log in once inside this profile; sessions persist.
#
#   bash chrome/launch.sh [extra chrome args...]
#   CHROME_CDP_PORT     debugging port (default 9222)
#   CHROME_CDP_PROFILE  profile dir   (default ~/.chrome-cdp-profile)
#   CHROME_BIN          explicit Chrome/Chromium binary
set -uo pipefail
PORT="${CHROME_CDP_PORT:-9222}"
PROFILE="${CHROME_CDP_PROFILE:-$HOME/.chrome-cdp-profile}"

find_chrome() {
  local c
  for c in "${CHROME_BIN:-}" \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    "/Applications/Chromium.app/Contents/MacOS/Chromium" \
    google-chrome google-chrome-stable chromium chromium-browser chrome; do
    [ -z "$c" ] && continue
    command -v "$c" >/dev/null 2>&1 && { echo "$c"; return; }
    [ -x "$c" ] && { echo "$c"; return; }
  done
}

if curl -fsS "http://127.0.0.1:$PORT/json/version" >/dev/null 2>&1; then
  echo "CDP already up on :$PORT"; curl -s "http://127.0.0.1:$PORT/json/version"; exit 0
fi
BIN="$(find_chrome)"
[ -n "$BIN" ] || { echo "ERROR: Chrome/Chromium not found - set CHROME_BIN" >&2; exit 1; }
mkdir -p "$PROFILE"
# Chrome 136+ rejects CDP websocket upgrades carrying an Origin header (403) unless
# that origin is allowlisted. Clients on a browser/HTTP stack that auto-sends Origin
# (python websockets, node ws, fetch) hit this; allowlist the loopback CDP origins.
# Chrome MUST outlive whoever launched it. A plain `&` leaves it in the caller's
# process group, and launchd KILLS a job's whole process group when the job exits
# (unless AbandonProcessGroup=true). That is how a 10-minute launchd watcher was
# killing a Chrome shared with the human every single run: not a tab close, a
# process-group reap. start_new_session=True (setsid) puts Chrome in its own
# session and process group, so no parent's death can take it down.
spawn_detached() {
  python3 - "$@" <<'PY'
import subprocess, sys
proc = subprocess.Popen(sys.argv[1:], stdin=subprocess.DEVNULL,
                        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                        start_new_session=True)
print(proc.pid)
PY
}
CHROME_ARGS=("$BIN" --remote-debugging-port="$PORT" --user-data-dir="$PROFILE"
             --remote-allow-origins="http://localhost:$PORT,http://127.0.0.1:$PORT"
             --no-first-run --no-default-browser-check "$@")
if command -v python3 >/dev/null 2>&1; then
  PID="$(spawn_detached "${CHROME_ARGS[@]}")"
else
  # fallback: still detach as far as bash can (new pgroup via job control)
  set -m
  "${CHROME_ARGS[@]}" >/dev/null 2>&1 &
  PID=$!
  disown "$PID" 2>/dev/null || true
  set +m
fi
echo "launching: $BIN  ·  CDP :$PORT  ·  profile $PROFILE  ·  pid $PID (detached)"
for _ in $(seq 1 25); do
  curl -fsS "http://127.0.0.1:$PORT/json/version" >/dev/null 2>&1 && { echo "ready:"; curl -s "http://127.0.0.1:$PORT/json/version"; exit 0; }
  sleep 0.3
done
echo "WARN: CDP not responding on :$PORT yet" >&2
