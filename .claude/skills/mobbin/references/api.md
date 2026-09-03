# mobbin CLI - technical reference (MCP wire protocol + OAuth)

Load only when debugging the CLI or auth breaks. Day-to-day use needs only `SKILL.md`.
Verified live 2026-07-14.

## Endpoint

`POST https://api.mobbin.com/mcp` - official Mobbin MCP, Streamable HTTP transport
(Vercel/Next.js at `/api/mcp/[[...route]]`). Everything is auth-gated, even `initialize`
(401 without Bearer).

## Auth (OAuth 2.1 code + PKCE)

The MCP REJECTS mobbin.com web-session JWTs ("Invalid or expired access token") even though
both come from the same Supabase project - it only accepts tokens minted by its own OAuth flow.

Auth server discovery: 401 `WWW-Authenticate` -> `https://api.mobbin.com/.well-known/
oauth-protected-resource/mcp` -> auth server `https://ujasntkfphywizsdaapi.supabase.co/auth/v1`
(metadata at `{auth}/.well-known/oauth-authorization-server`).

`mobbin login` automates the whole flow (one-time):
1. Dynamic client registration at `{auth}/oauth/clients/register` - public client,
   `token_endpoint_auth_method: "none"`, redirect `http://localhost:8976/callback`.
2. Browser approval at `{auth}/oauth/authorize` - S256 PKCE, `scope=openid`, `state`,
   `resource=https://api.mobbin.com/mcp` (RFC 8707). Opens CDP Chrome first (where the
   mobbin login usually lives), else macOS `open`, else prints the URL (`--no-open`).
3. One-shot localhost HTTP server catches the callback; code exchanged at `{auth}/oauth/token`
   with `code_verifier`.

Token file `~/.mobbin/mcp_session.json` (0600): access token ~1h + `refresh_token` +
`client_id` + computed `expires_at`. The CLI refreshes via `grant_type=refresh_token`
5 min before expiry. Refresh failure or 401 -> re-run `mobbin login`.

## Wire protocol

JSON-RPC 2.0 over POST. Headers: `Authorization: Bearer <token>`,
`Accept: application/json, text/event-stream`, `MCP-Protocol-Version: 2025-06-18`.

- Responses arrive as plain JSON or SSE (`data:` lines); `sse_extract()` takes the last
  message carrying result/error (notifications may interleave).
- Capture `Mcp-Session-Id` from the initialize response headers, echo it on later posts.
- Notifications (e.g. `notifications/initialized`) return 202 + empty body.
- Per-invocation handshake: `initialize` -> `notifications/initialized` -> real call.
  Stateless by design: two extra round trips per run, no session cache to go stale.

## Follow-the-server rule

The CLI hardcodes NO tool names or schemas. `tools/list` at runtime is the source of truth;
`call` is a verbatim passthrough (`tools/call` with `{name, arguments}`). Server-side tool
changes need zero CLI changes.

Live 2026-07-14: `search_screens`, `search_flows`, `search_sections` - natural-language
search returning a JSON text block + `structuredContent` (ids, `app_name`, `mobbin_url`,
short `image_url`) + inline base64 webp previews (~300x680), which `--out DIR` saves as
`mcp-NN.webp` in content order.

## Terms of service

The MCP is Mobbin's sanctioned programmatic surface (Pro+). Personal reference use on the
user's own account; keep volume modest, don't re-host content.
