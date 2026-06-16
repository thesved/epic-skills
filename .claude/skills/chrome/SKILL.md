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

## 4. Stay out of the way (one tab per session, shared Chrome)

`cdp.py` is built to share **one** Chrome with you and other agents without stepping on anyone:

- **One tab per session, reused.** Each session owns a tab (id remembered in `/tmp/cdp-tabs-<port>/<session>`) and navigates it *in place* on every call - no open/close churn. Session key = `CDP_SESSION`, else `CLAUDE_CODE_SESSION_ID` (so each agent auto-isolates), else `default`.
- **Creates its own tab, never adopts yours.** On first use a session opens a fresh tab instead of grabbing an existing one, so it can't hijack the tab you're looking at or another agent's tab. Cost: one foreground flash when a session first appears. Attach to a specific existing tab on purpose with `CDP_TARGET=<url-substring>`.
- **Refuses the focus-stealers.** `Page.bringToFront` and `Target.activateTarget` drag Chrome to the macOS foreground; `cdp.py` blocks them (exit 2). Override with `CDP_ALLOW_FOCUS=1`. Screenshots do **not** need them.
- **Screenshots of a background tab** work without foregrounding. If a backgrounded tab returns stale/blank frames (render throttling), nudge it once: `cdp.py Emulation.setFocusEmulationEnabled '{"enabled":true}'`.

Orphan tabs: a finished session leaves its tab open (we never auto-close, to avoid shutting one of your tabs by mistake). Close them by hand when they pile up.

**Show that a tab is being driven** (no attention cost - lives on the session's own tab):
```
bash ~/.claude/skills/chrome/badge.sh on   [label] [dotcolor]   # red dot on a painted favicon + 🔴 title prefix
bash ~/.claude/skills/chrome/badge.sh off
```
Paints its own favicon (never taints/depends on the page's real one) and re-applies via `MutationObserver` if an SPA overwrites it. A page navigation wipes it (new document), so re-run `on` after navigating if you want it to persist.

**macOS caveat (10-yr Chromium bug):** on *stable headed* Chrome, CDP traffic can still trigger app activation on the create-tab flash even with the above. Kill the jarring Space-jump with `defaults write NSGlobalDomain AppleSpacesSwitchOnActivate -bool false && killall Dock`.

<!-- skill-lint: ignore placeholder-example -->

