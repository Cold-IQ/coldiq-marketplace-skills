# Providers — native vs resold

The ColdIQ marketplace (`api.coldiq.com`) exposes ~39 provider groups. Two kinds:

- **Native** — ColdIQ's own data + the AI Ark dataset. No external account needed.
- **Resold** — third-party providers ColdIQ proxies under `/v1/<provider>/*`. Some are
  pay-per-call (data providers); some are **BYOK & free** (you connect your own account via
  `/dashboard/connections` and ColdIQ proxies it at no credit cost).

## Native

| Group | What it does |
|-------|--------------|
| `ai-ark` | Search 70M companies / 500M people; reverse lookup; mobile phone finder; export people with verified email; email-finder by trackId |
| `dashboard` | API keys, credits, usage, billing, BYOK connections |

## Resold — data (pay per call)

`limadata`, `apollo`, `prospeo`, `fullenrich`, `findymail`, `wiza`, `icypeas`, `pdl`, `sumble`, `linkupapi`,
`companyenrich`, `blitzapi`, `builtwith`, `openmart`, `influencers-club`.

## Resold — signals & jobs

`signalbase` (funding/acquisition/job-change/hiring/investors/companies), `predictleads`,
`theirstack`, `career-site-jobs`, `linkedin-jobs-api`.

## Resold — SEO / web / search

`dataforseo`, `exa`, `serper`, `jina`.

## Resold — scrapers (async job + poll)

`meta-ads`, `google-ads`, `google-maps`, `linkedin-ad-library`, `reddit`/`reddit-ads`,
`twitter`/`twitter-ads`, `jungler` (LinkedIn post engagement), `leadsfactory` (Sales Nav scraper).

## Resold — sending / CRM / inbox (BYOK, free)

`instantly` (full campaign/lead/account API), `lemlist`, `attio` (CRM), `unipile`
(LinkedIn/email/calendar/chats).

## Common direct providers → ColdIQ route

If you previously called these providers directly, here's the ColdIQ marketplace equivalent:

| Direct provider | ColdIQ route |
|-----------------|--------------|
| Lima Data | resold `/v1/limadata/*` (+ `/v1/ai-ark/*` for big search) |
| Apollo | resold `/v1/apollo/*` |
| Instantly | resold `/v1/instantly/*` (BYOK) |
| Linkup | Lima Data `/v1/limadata/find/company-linkedin` + `/find/work-email*` |
| Email waterfall providers | resold `/v1/prospeo/*`, `/v1/findymail/*`, `/v1/fullenrich/*` |
| Meta Ad Library scraper | resold async `/v1/meta-ads/*` |
| EmailBison | **not resold** → substitute `/v1/instantly/*` or `/v1/lemlist/*` |
| Fireflies | **not resold** → stays on Fireflies (MCP), see fireflies-usage |
