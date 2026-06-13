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
"$BIN" --remote-debugging-port="$PORT" --user-data-dir="$PROFILE" \
       --no-first-run --no-default-browser-check "$@" >/dev/null 2>&1 &
echo "launching: $BIN  ·  CDP :$PORT  ·  profile $PROFILE  ·  pid $!"
for _ in $(seq 1 25); do
  curl -fsS "http://127.0.0.1:$PORT/json/version" >/dev/null 2>&1 && { echo "ready:"; curl -s "http://127.0.0.1:$PORT/json/version"; exit 0; }
  sleep 0.3
done
echo "WARN: CDP not responding on :$PORT yet" >&2
