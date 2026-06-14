#!/usr/bin/env python3
"""cdp.py <Domain.method> [json-params] - send one CDP command to a page target
and print the result. Discovers the target websocket from the /json endpoint.

  python3 chrome/cdp.py Page.navigate '{"url":"https://example.com"}'
  python3 chrome/cdp.py Runtime.evaluate '{"expression":"document.title","returnByValue":true}'

Multi-agent friendly + non-disruptive. Each SESSION owns one tab:
  - reuses that tab on every call (navigates in place, no open/close churn),
  - creates its OWN tab on first use instead of adopting an existing one, so it
    never hijacks the human's tab or another agent's tab in the shared Chrome.
Session key = CDP_SESSION, else CLAUDE_CODE_SESSION_ID, else "default".
The focus-stealers Page.bringToFront / Target.activateTarget are refused (they
yank Chrome to the macOS foreground); set CDP_ALLOW_FOCUS=1 to override.

Env: CHROME_CDP_PORT (9222) · CDP_SESSION (tab owner id) ·
CDP_TARGET (substring: attach this session to an existing tab by URL) ·
CDP_ALLOW_FOCUS (permit the focus-stealing commands)."""
import json, os, re, sys, tempfile, urllib.request, asyncio
from urllib.error import URLError
import websockets

PORT = os.environ.get("CHROME_CDP_PORT", "9222")
_raw = os.environ.get("CDP_SESSION") or os.environ.get("CLAUDE_CODE_SESSION_ID") or "default"
SESSION = re.sub(r"[^A-Za-z0-9._-]", "_", _raw)[:64]
STATE_DIR = os.path.join(tempfile.gettempdir(), f"cdp-tabs-{PORT}")
PIN = os.path.join(STATE_DIR, SESSION)
# commands that drag the OS window to the foreground and steal focus on macOS
FOCUS_STEALERS = {"Page.bringToFront", "Target.activateTarget"}


def _get(path):
    try:
        return json.load(urllib.request.urlopen(f"http://127.0.0.1:{PORT}{path}"))
    except (URLError, OSError) as e:
        print(f"ERR: cannot reach Chrome CDP on :{PORT} ({e}) - run chrome/launch.sh", file=sys.stderr)
        sys.exit(1)


def _pages():
    return [t for t in _get("/json") if t.get("type") == "page" and t.get("webSocketDebuggerUrl")]


def _read_pin():
    try:
        with open(PIN) as f:
            return f.read().strip()
    except OSError:
        return ""


def _write_pin(tid):
    try:
        os.makedirs(STATE_DIR, exist_ok=True)
        with open(PIN, "w") as f:
            f.write(tid)
    except OSError:
        pass


async def _create_tab(url="about:blank"):
    # Target.createTarget is a browser-level method - use the /json/version socket.
    async with websockets.connect(_get("/json/version")["webSocketDebuggerUrl"], max_size=None) as ws:
        await ws.send(json.dumps({"id": 1, "method": "Target.createTarget", "params": {"url": url}}))
        while True:
            msg = json.loads(await ws.recv())
            if msg.get("id") == 1:
                if "error" in msg:
                    print(f"ERR: could not create tab: {msg['error']}", file=sys.stderr); sys.exit(1)
                return msg["result"]["targetId"]


async def resolve_ws():
    pages = _pages()
    # explicit override: attach this session to an existing tab by URL substring
    sub = os.environ.get("CDP_TARGET", "")
    if sub:
        match = [t for t in pages if sub in t.get("url", "")]
        if match:
            _write_pin(match[0]["id"]); return match[0]["webSocketDebuggerUrl"]
    # hot path: reuse this session's own tab if it still exists
    pin = _read_pin()
    if pin:
        for t in pages:
            if t.get("id") == pin:
                return t["webSocketDebuggerUrl"]
    # first use (or my tab was closed): make my own, never adopt someone else's
    tid = await _create_tab()
    _write_pin(tid)
    for _ in range(40):
        for t in _pages():
            if t.get("id") == tid:
                return t["webSocketDebuggerUrl"]
        await asyncio.sleep(0.05)
    print("ERR: created tab but could not find its websocket", file=sys.stderr); sys.exit(1)


async def run(method, params):
    async with websockets.connect(await resolve_ws(), max_size=None) as ws:
        await ws.send(json.dumps({"id": 1, "method": method, "params": params}))
        while True:
            msg = json.loads(await ws.recv())
            if msg.get("id") == 1:
                out = msg.get("result", msg.get("error"))
                print(json.dumps(out, indent=2))
                return 0 if "error" not in msg else 1


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(1)
    m = sys.argv[1]
    if m in FOCUS_STEALERS and not os.environ.get("CDP_ALLOW_FOCUS"):
        print(f"refusing {m}: it yanks Chrome to the macOS foreground and steals focus.\n"
              f"each session reuses one background tab on purpose - screenshots etc. do NOT\n"
              f"need it. if you really must, re-run with CDP_ALLOW_FOCUS=1.", file=sys.stderr)
        sys.exit(2)
    p = json.loads(sys.argv[2]) if len(sys.argv) > 2 else {}
    sys.exit(asyncio.run(run(m, p)))
