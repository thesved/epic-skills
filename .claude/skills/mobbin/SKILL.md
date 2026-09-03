---
name: mobbin
description: >-
  Pull UI/UX design inspiration from mobbin.com as image files + JSON, ready to
  feed to any vision model (Claude, GPT, Gemini). Wraps Mobbin's official MCP
  server as a plain CLI (JSON-RPC over HTTP, no MCP client registration).
  One-time OAuth login, then natural-language search of real app screens, flows,
  and web sections. Use when the user says "mobbin", "design inspiration",
  "reference screens/flows", "how does app X design its Y",
  "onboarding/checkout/paywall examples", "steal this UI pattern", or wants real
  app screenshots to inform a design.
allowed-tools:
  - Bash
  - Read
---

# mobbin - design inspiration as images + JSON

CLI: `~/.claude/skills/mobbin/bin/mobbin` (Python 3 stdlib, zero deps). Talks to Mobbin's
official MCP server (`https://api.mobbin.com/mcp`) as plain JSON-RPC POSTs; no MCP client.
Search results print JSON to stdout; `--out DIR` saves the inline screenshot previews as
ordinary `.webp` files - hand them (or single files via `Read`) to any vision model.

Config: `~/.mobbin/mcp_session.json` (OAuth token, auto-refreshes; login is one-time).

## Commands

```
mobbin login                    # one-time browser OAuth approval
mobbin doctor                   # endpoint + auth + live tool list, one shot
mobbin tools [--full]           # what the server exposes RIGHT NOW (names, args, schemas)
mobbin call <tool> [--args JSON | --set k=v ...] [--out DIR] [--lowres] [--width 1440]
mobbin raw <jsonrpc-method> [--params JSON]     # escape hatch
```

## Workflow

1. `mobbin tools` first in a fresh session - the CLI hardcodes NO tool names; the server's
   live list is the source of truth. (Live 2026-07: `search_screens(query*, platform*, limit,
   mode, image_format, exclude_screen_ids)`, `search_flows(query*, platform*, limit, page,
   image_format)`, `search_sections(query*, limit, page)`. platform: `ios|android|web`.)
2. Search with natural language (no taxonomy labels needed):
   `mobbin call search_screens --set query="fintech paywall" --set platform=ios --set limit=6 --out ./insp`
   -> `./insp/mcp-01.webp ...` + JSON on stdout with `structuredContent` (per-hit `app_name`,
   `mobbin_url`, `image_url`; order matches the image files).
3. Analyze with a vision model: `Read` the files for Claude, or base64 them into image
   messages for GPT (`codex-bridge`/`openrouter-bridge`) or Gemini (`gemini-bridge`).

## Rules

- Never assume tool names or arg shapes from memory - run `mobbin tools` and follow it.
  When Mobbin changes the server, the CLI follows automatically; your knowledge may not.
- `--set` values parse as JSON when possible (`--set limit=5` is a number); use `--args`
  for one JSON blob.
- Without `--out`, inline base64 images are elided from stdout (never dumped); pass
  `--out DIR` whenever you actually want the screenshots.
- With `--out`, native-resolution images (~1180x2556, `hires-NN.webp`) download BY DEFAULT
  alongside the ~300px MCP previews (`mcp-NN.webp`); `--width` caps the size. No extra auth:
  the public screen page leaks the raw CDN asset id. Pass `--lowres` to skip the hires fetch:
  only when you want speed/small files for bulk layout-level triage of many screens, or if
  the screen-page scrape ever breaks (hires depends on the og:image leak; previews don't).
- 401 at any point -> `mobbin login` again (the web-session cookie does NOT work here;
  the MCP has its own OAuth).
- This uses the user's own Mobbin account via the sanctioned MCP surface; keep volume modest.

## Example

Input: "show me 6 fintech onboarding screens I can copy, for iOS"

```
mobbin call search_screens --set query="fintech onboarding" --set platform=ios --set limit=6 --out ./fintech-onb
Read ./fintech-onb/mcp-01.webp     # then analyze; map files to apps via stdout JSON order
```

Health check: `bash ~/.claude/skills/mobbin/smoke.sh`.
See `references/api.md` for wire protocol + OAuth internals (debugging only).
