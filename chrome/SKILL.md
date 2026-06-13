---
name: chrome
description: Drive Chrome via the DevTools Protocol (CDP). Triggers "chrome cdp", "devtools protocol", "control chrome", "remote debugging", "drive the browser".
argument-hint: 'launch | cdp <Domain.method> [params]'
---

# chrome - drive Chrome over CDP

Talk to a real Chrome via the [DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/). Two scripts: `launch.sh` (start Chrome with debugging) and `cdp.py` (send one CDP command).

## 1. Launch
```
bash ~/.claude/skills/chrome/launch.sh
```
Starts Chrome with `--remote-debugging-port=9222` on a **dedicated profile** (`~/.chrome-cdp-profile`). Idempotent - if CDP is already up it just reports the endpoint.

**Gotcha (Chrome 136+):** Chrome refuses `--remote-debugging-port` on the *default* profile for security - you MUST use a separate `--user-data-dir`. So this profile starts logged out; log into sites once inside it and the sessions persist for later runs. You cannot attach to an already-running normal Chrome that wasn't started with the flag.

Overrides: `CHROME_CDP_PORT`, `CHROME_CDP_PROFILE`, `CHROME_BIN`.

## 2. Discover targets
```
curl -s http://127.0.0.1:9222/json/version    # browser + ws endpoint
curl -s http://127.0.0.1:9222/json            # list tabs (pick webSocketDebuggerUrl)
```

## 3. Send CDP commands
```
python3 ~/.claude/skills/chrome/cdp.py <Domain.method> '<json-params>'
```
Picks the first page target (or set `CDP_TARGET=<url-substring>` to choose a tab). Needs the `websockets` Python package. Common recipes:

| Goal | Command |
|---|---|
| Navigate | `cdp.py Page.navigate '{"url":"https://example.com"}'` |
| Run JS, get value | `cdp.py Runtime.evaluate '{"expression":"document.title","returnByValue":true}'` |
| Full-page screenshot | `cdp.py Page.captureScreenshot '{"captureBeyondViewport":true}'` → base64 in `.data` |
| Get all cookies | `cdp.py Network.getAllCookies` |
| Print to PDF | `cdp.py Page.printToPDF '{}'` → base64 in `.data` |
| Get the DOM | `cdp.py DOM.getDocument '{"depth":-1}'` |

Decode base64 output with `... | jq -r .data | base64 -d > out.png`.

For a higher-level headless browser with QA helpers, the gstack `/browse` daemon also speaks CDP - this skill is the raw escape hatch.
