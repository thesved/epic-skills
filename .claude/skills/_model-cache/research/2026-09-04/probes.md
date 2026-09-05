# Live probes, 2026-09-04 (GPT-6 Astra day two)

Run by the orchestrator from this Mac at ~07:15 UTC, 2026-09-04. Each row is a real call, not a doc claim.

| probe | command | result |
|---|---|---|
| Direct API, our `OPENAI_API_KEY` | `POST /v1/responses {"model":"gpt-6-astra"}` | `The model 'gpt-6-astra' does not exist or you do not have access to it.` (not yet provisioned on our key) |
| `/v1/models` on our key | `GET /v1/models` grep `gpt-6|astra` | only `gpt-5.6-sol`, `gpt-5.6-terra`, `gpt-5.6-luna`; `update.sh openai` prints "no new gpt/image models" |
| Codex CLI 0.152.1, ChatGPT-account login | `codex exec -m gpt-6-astra` | `400 invalid_request_error: The 'gpt-6-astra' model is not supported when using Codex with a ChatGPT account.` plus the warning `Model metadata for 'gpt-6-astra' not found. Defaulting to fallback metadata` (CLI predates 0.153.0, which added Astra metadata) |
| OpenRouter model list | `GET /api/v1/models` grep `astra|gpt-6` | no id listed |
| yt-dlp YouTube search, 20 queries x 25 | flat-playlist | 191 unique candidates, 182 over 3 min, 94 uploaded 2026-08-31 or later, 86 Astra-relevant under 2 h |

Re-probe 2026-09-04 ~08:00 UTC after `npm i -g @openai/codex@latest` (0.152.1 -> 0.153.2): Codex ChatGPT login still `400 not supported when using Codex with a ChatGPT account` (and still 'Model metadata not found', the catalog entry is served hidden); direct API still 'does not exist or you do not have access'; OpenRouter still no id. The block is the account rollout, not the CLI.

Re-probe order once access lands: `codex --version` (need >= 0.153.2), `codex exec -m gpt-6-astra`, then the Responses call, then OpenRouter.
