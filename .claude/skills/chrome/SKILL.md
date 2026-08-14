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

**Chrome is spawned detached (setsid), on purpose. Never "simplify" that back to `cmd &`.**
A backgrounded child stays in the launcher's process group, and **launchd kills a job's entire
process group when the job exits** unless the plist sets `AbandonProcessGroup=true`. A
10-minute launchd watcher that called `launch.sh` therefore killed the shared Chrome on every
single run, taking every window with it, which reads as "something keeps closing my browser"
and looks nothing like a CDP bug. Same trap applies to cron and to any dying agent session.
Two layers, keep both: `launch.sh` setsids Chrome into its own session, and any launchd plist
that touches Chrome sets `AbandonProcessGroup=true`.
Regression test: launch Chrome from a subshell, then `kill -KILL -<that subshell's pgid>`.
Chrome must still answer on `/json/version`.

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

## Save an authenticated page as ONE self-contained HTML

Goal: grab a login-gated, JS-rendered page (e.g. a pages.dev deck behind Cloudflare Access) as a single offline HTML.

**Pull the pristine *served* HTML, not the live DOM.** Serializing `document.documentElement.outerHTML` captures the post-JS DOM; any script that *appends* on load (chart drawers, `container.appendChild(...)`, `innerHTML +=`) then **double-renders** every element when the saved file is reopened (JS runs again on top of the already-baked output). General bug, hits all such widgets.

Fix: fetch the original response body via `Page.getResourceContent` through the logged-in session (empty containers + the draw script → renders exactly once on open). `curl` gets 401 (no auth); page CSP often blocks in-page `fetch`. Needs Page domain enabled in the **same** websocket session, so `cdp.py`'s one-command-per-connection won't do it: write a one-shot websocket script: `Page.enable` → `Page.navigate` → wait `Page.loadEventFired` → `Page.getResourceTree` (frame id + url) → `Page.getResourceContent` (base64-decode if flagged).

Self-contained only if the source already inlines assets (images as `data:` URIs, inline `<script>`/`<style>`, 0 external `src`/`href`). Verify: reopen the saved `file://` and assert no chart/container holds >1 rendered child.

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

## 5. Driving Google apps (Sheets/Docs) - measured 2026-08-14

- **Rapid-fire cdp.py calls fail SILENTLY.** Each call opens its own websocket; several back-to-back in one shell line return empty output with exit 0 and the command never ran. One cdp.py call per shell invocation, ≥0.3s gaps, and treat empty stdout as failure, never as success.
- **Synthetic JS events are ignored** (`element.dispatchEvent(...)` is untrusted; Google apps drop it). Use trusted `Input.dispatchMouseEvent` / `Input.dispatchKeyEvent` at coordinates from `getBoundingClientRect()`; re-read coordinates after any UI change (tabs shift on rename).
- **Paste into Sheets:** `pbcopy < file.tsv` then `Input.dispatchKeyEvent '{"type":"keyDown","key":"v","code":"KeyV","modifiers":4,"commands":["paste"]}'`. Works into the grid from A1.
- **Sheets grid is canvas - DOM readback impossible.** Verify via `Page.captureScreenshot` (read the image) + selection range from `.waffle-name-box`; tab names live in `.docs-sheet-tab-name` spans (DOM, readable). Dblclick a tab name (two trusted click pairs, clickCount 1 then 2) → selectAll+insertText+Enter renames it. `sheets.new` creates a spreadsheet if the profile is logged in.

<!-- skill-lint: ignore placeholder-example -->

