# EmailBison analytics → ColdIQ (Instantly) reference

EmailBison's analytics/replies endpoints have no ColdIQ resold equivalent. Map them to Instantly's
analytics + lead/email views. All Instantly endpoints below are BYOK and free (no ColdIQ credits).

## Endpoint mapping

| EmailBison | ColdIQ (Instantly) | Endpoint ID |
|------------|--------------------|-------------|
| `POST /api/campaigns/{id}/stats` (date range) | `GET /v1/instantly/campaigns/analytics` | `instantly.campaigns.analytics` |
| `GET /api/campaigns/{id}/line-area-chart-stats` | `GET /v1/instantly/campaigns/analytics/daily` | `instantly.campaigns.analytics.daily` |
| per-step breakdown | `GET /v1/instantly/campaigns/analytics/steps` | `instantly.campaigns.analytics.steps` |
| `GET /api/campaigns/{id}/replies` | `POST /v1/instantly/leads/list` (filter by status) | `instantly.leads.list` |
| `PATCH /api/replies/{id}/mark-as-interested` | `POST /v1/instantly/leads/update-interest-status` | — (path-only) |
| workspace-level stats | `GET /v1/instantly/campaigns/analytics/overview` | — (path-only) |

## Field mapping (EmailBison stats → Instantly analytics)

| EmailBison field | Instantly field |
|------------------|-----------------|
| `emails_sent` | `emails_sent_count` |
| `total_leads_contacted` | `contacted_count` |
| `unique_replies_per_contact_percentage` | derive from `reply_count` / `contacted_count` |
| `bounced_percentage` | derive from `bounced_count` / `emails_sent_count` |
| `interested_percentage` | `opportunities_count` / `contacted_count` |
| per-step `sent / unique_opens / unique_replies / interested` | `analytics/steps` response rows |

## Reply handling

EmailBison treats each reply as an object you mark interested/automated. Instantly tracks interest
at the **lead** level:

- List replies/leads by status:
  → **POST** `/v1/instantly/leads/list` · free · `instantly.leads.list`
- Mark a lead interested (not per-reply): `POST /v1/instantly/leads/update-interest-status`.

## Benchmarks (carry over from instantly-api)

Positive reply rate: kill <1%, keep 2–5%, scale >5%. Emails per positive reply: kill >5,000,
keep 1,000–3,000, scale <1,000. After 200+ sends/variant, kill underperformers; branch winners 70/20/10.
