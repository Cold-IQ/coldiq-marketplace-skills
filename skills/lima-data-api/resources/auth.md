# Authentication & base URL

- **Base URL:** `https://api.coldiq.com`
- **All marketplace endpoints** live under `/v1/<provider>/…`; account/billing under `/dashboard/…`.

## API key header — ⚠️ UNVERIFIED

The exact auth header is **not confirmed** against the live API yet. Two candidates:

| Candidate | Where seen |
|-----------|------------|
| `X-KEY: <key>` | ColdIQ resells providers (e.g. Prospeo) that use `X-KEY` in `coldiq_web` |
| `Authorization: Bearer <key>` | Common ColdIQ/SaaS convention |

Until confirmed, every skill marks endpoint callouts as `(unverified)` where the catalog
entry has `verified: false`. **Confirm the header before any production/live use:**

1. Sign in to your ColdIQ dashboard.
2. Create a key under `GET/POST /dashboard/api-keys`.
3. Test the cheapest free endpoint, e.g. `GET /dashboard/credits`, with each header form.
4. Set the winner in `catalog.json` → `auth.header` and flip `auth.verified` to `true`.

## Credits & usage

| Endpoint | Use |
|----------|-----|
| `GET /dashboard/credits` | current balance |
| `GET /dashboard/usage` / `/usage/summary` | usage history |
| `GET /dashboard/api-keys` · `POST` · `DELETE /{id}` | manage keys |
| `GET /dashboard/connections` · `PUT /{provider}` | BYOK: connect your own provider keys |

Many provider groups (instantly, lemlist, attio, unipile) are **BYOK and free** — you connect
your own account and ColdIQ proxies it at no credit cost. Lima Data (`/v1/limadata/*`) and native (`/v1/ai-ark/*`)
and most resold data endpoints consume ColdIQ credits per the costs in `catalog.json`.

> Credit values in the catalog are best-effort from the admin dump and may be wrong. The dump's
> "Cost" column was garbled for several groups; real costs were read from each endpoint's
> description text and flagged `unknown` where unreadable.
