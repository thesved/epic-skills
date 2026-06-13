#!/usr/bin/env python3
"""cdp.py <Domain.method> [json-params] - send one CDP command to a page target
and print the result. Discovers the target websocket from the /json endpoint.

  python3 chrome/cdp.py Page.navigate '{"url":"https://example.com"}'
  python3 chrome/cdp.py Runtime.evaluate '{"expression":"document.title","returnByValue":true}'

Env: CHROME_CDP_PORT (9222) · CDP_TARGET (substring to pick a tab by URL; else first page)."""
import json, os, sys, urllib.request, asyncio
import websockets

PORT = os.environ.get("CHROME_CDP_PORT", "9222")


def pick_target():
    data = json.load(urllib.request.urlopen(f"http://127.0.0.1:{PORT}/json"))
    pages = [t for t in data if t.get("type") == "page" and t.get("webSocketDebuggerUrl")]
    sub = os.environ.get("CDP_TARGET", "")
    if sub:
        pages = [t for t in pages if sub in t.get("url", "")] or pages
    if not pages:
        print("ERR: no page target - open a tab first (or run chrome/launch.sh)", file=sys.stderr)
        sys.exit(1)
    return pages[0]["webSocketDebuggerUrl"]


async def run(method, params):
    async with websockets.connect(pick_target(), max_size=None) as ws:
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
    p = json.loads(sys.argv[2]) if len(sys.argv) > 2 else {}
    sys.exit(asyncio.run(run(m, p)))
