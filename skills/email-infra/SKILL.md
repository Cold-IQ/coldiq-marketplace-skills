---
name: email-infra
description: >
  Set up and run cold email sending infrastructure (domains, DNS, mailboxes, warmup) through the
  ColdIQ marketplace Instantly endpoints. Use when sizing how many domains/mailboxes are needed,
  provisioning sending accounts, ordering done-for-you pre-warmed inboxes, enabling/monitoring
  warmup, checking domain availability, or troubleshooting deliverability before going live.
  Triggers on "email infra", "setup domains", "buy domains", "how many mailboxes", "mailbox
  setup", "warmup", "warm up", "DNS / SPF / DKIM / DMARC", "Instantly setup", "going live",
  "deliverability", "DFY inboxes", "pre-warmed domains". Do NOT use for writing campaign sequences
  or copy (see instantly-api / cold-email-copy) — this skill is about the sending infrastructure,
  not the campaigns that run on it.
---

# Email Infrastructure

Take cold email infrastructure from zero to live: size it, provision mailboxes, warm them up, and
verify health — using ColdIQ's resold Instantly account/warmup endpoints (BYOK, free, no ColdIQ
credits). Once infra is healthy, hand off to [instantly-api](../instantly-api/SKILL.md) for campaigns.

## ColdIQ Marketplace Endpoints

| Task | Method | Path | Credits | Endpoint ID | Notes |
|------|--------|------|---------|-------------|-------|
| Order DFY pre-warmed inboxes | POST | `/v1/instantly/dfy-email-account-orders` | free | `instantly.dfy_orders.create` | Fastest path to live |
| Check domain availability | POST | `/v1/instantly/dfy-email-account-orders/domains/check` | free | `instantly.dfy_orders.domains_check` | Before buying |
| List pre-warmed domains | POST | `/v1/instantly/dfy-email-account-orders/domains/pre-warmed-up-list` | free | `instantly.dfy_orders.domains_prewarmed` | Skip the 2-3 week warmup |
| Connect a mailbox | POST | `/v1/instantly/accounts` | free | `instantly.accounts.create` | Bring your own mailbox |
| List mailboxes | GET | `/v1/instantly/accounts` | free | `instantly.accounts.list` | Inventory |
| Get mailbox health | GET | `/v1/instantly/accounts/{email}` | free | `instantly.accounts.get` | Per-account status |
| Enable warmup | POST | `/v1/instantly/accounts/warmup/enable` | free | `instantly.accounts.warmup_enable` | Start 2-3 wks before sending |
| Disable warmup | POST | `/v1/instantly/accounts/warmup/disable` | free | `instantly.accounts.warmup_disable` | Avoid once campaigns live |
| Warmup analytics | POST | `/v1/instantly/accounts/warmup-analytics` | free | `instantly.accounts.warmup_analytics` | Health scores |
| Test account vitals | POST | `/v1/instantly/accounts/test/vitals` | free | `instantly.accounts.test_vitals` | Pre-launch check |
| Daily account analytics | GET | `/v1/instantly/accounts/analytics/daily` | free | `instantly.accounts.analytics_daily` | Monitor live sending |

## Critical rules (never break)

1. Never use your primary domain for cold outreach.
2. Max 2 mailboxes per domain.
3. One domain = one workspace (never mix).
4. Use multiple registrars (no single point of failure).
5. Warm up 2–3 weeks minimum before sending.
6. Never disable warmup once campaigns are running.
7. Start conservative, scale gradually.

## Infrastructure sizing formula

- Monthly goal ÷ 20 working days = daily volume
- Daily volume ÷ 20–25 per mailbox = mailboxes needed
- Mailboxes × 1.5 (buffer) ÷ 2 = domains needed
- Provider split: 60% Google Workspace, 40% Microsoft 365

Example: 3,000/month → 150/day → 10–12 mailboxes → 5–6 domains.

## DNS — all 4 records required

| Record | Purpose |
|--------|---------|
| MX | Routes incoming email |
| SPF | Declares sending servers |
| DKIM | Digital signature authentication |
| DMARC | Policy for SPF/DKIM failures |

(DNS is configured at the registrar/provider — ColdIQ doesn't set DNS. Use the DFY order to skip
manual setup.)

## Setup flow

1. Size the infra (formula above).
2. Fastest path — order done-for-you pre-warmed inboxes (skip manual domain/DNS/warmup).
   → **POST** `/v1/instantly/dfy-email-account-orders` · free · `instantly.dfy_orders.create`
   - First check what's available:
     → **POST** `/v1/instantly/dfy-email-account-orders/domains/pre-warmed-up-list` · free · `instantly.dfy_orders.domains_prewarmed`
     → **POST** `/v1/instantly/dfy-email-account-orders/domains/check` · free · `instantly.dfy_orders.domains_check`
3. BYO path — connect your own mailboxes, then enable warmup 2–3 weeks before sending.
   → **POST** `/v1/instantly/accounts` · free · `instantly.accounts.create`
   → **POST** `/v1/instantly/accounts/warmup/enable` · free · `instantly.accounts.warmup_enable`
4. Before launch, confirm health.
   → **POST** `/v1/instantly/accounts/warmup-analytics` · free · `instantly.accounts.warmup_analytics`
   → **POST** `/v1/instantly/accounts/test/vitals` · free · `instantly.accounts.test_vitals`
5. Go live (ramp), then monitor daily.
   → **GET** `/v1/instantly/accounts/analytics/daily` · free · `instantly.accounts.analytics_daily`

## Warmup & ramp

Warmup: Week 1 foundation (no campaigns) · Week 2 building (no campaigns) · Week 3 ready (health
70%+, ideally 90%+). Going-live ramp/mailbox: Wk1 G 10–15 / MS 5–10 → Wk2–3 G 15–20 / MS 10–12 →
Wk4+ G 20–25 / MS 12–15.

## Healthy metrics

Open 50%+ · reply 2%+ · bounce <3% (target <2%) · spam <0.1% · deliverability >95%.
If bounce climbs or vitals drop, pause that mailbox and re-check warmup analytics before resuming.
