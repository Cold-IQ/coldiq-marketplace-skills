---
name: website-visitors
description: >
  Turn de-anonymized website visitors into enriched, outreach-ready leads. The visitor
  identification itself runs in an external pixel/IP tool (RB2B, Warmly, Koala, Leadfeeder); this
  skill covers the ColdIQ marketplace tail — enriching and resolving identified visitors and timing
  outreach. Use when setting up website-visitor tracking, enriching identified visitors, scoring
  pricing/demo-page visits, or routing visitor signals to sequences. Triggers on "website
  visitors", "visitor tracking", "RB2B", "de-anonymize", "pixel identification", "IP to company",
  "Warmly", "Leadfeeder", "Koala", "visitor alerts", "who visited my site". Do NOT use for social
  post engagement (see signal-detection) or third-party intent data (see signal-detection).
---

# Website Visitor Signals

Website visitors are a top buying signal — they're already evaluating you (pricing/demo/competitor
pages), so reply rates run 25–30% when you act within 24–48h. The **de-anonymization happens in an
external tool**; ColdIQ enriches and resolves what that tool surfaces and feeds it to outreach.

> External step: visitor identification (pixel person-level or IP company-level) is done by RB2B,
> Warmly, Koala, Leadfeeder, etc. — there is no ColdIQ de-anonymization endpoint. ColdIQ takes over
> once you have an email, name, or company from the tool.

## ColdIQ Marketplace Endpoints (the enrichment tail)

| Task | Method | Path | Credits | Endpoint ID | Notes |
|------|--------|------|---------|-------------|-------|
| Email → full profile | POST | `/v1/limadata/find/reverse-email-lookup` | 5 | `limadata.find.reverse_email_lookup` | When the tool gives an email |
| Resolve identity (social URLs) | POST | `/v1/limadata/find/identity-resolution` | 2 | `limadata.find.identity_resolution` | name+company → LinkedIn etc. |
| Enrich the person | POST | `/v1/limadata/enrich/person` | 1–5 | `limadata.enrich.person` | Title, seniority, contact |
| Enrich the company (IP-level hit) | POST | `/v1/limadata/enrich/company` | 1 | `limadata.enrich.company` | When you only have the company |
| Find decision-makers at the account | POST | `/v1/limadata/prospect/employees` | 25 | `limadata.prospect.employees` | Company-level visit → buying committee |
| Find work email for outreach | POST | `/v1/limadata/find/work-email` | 1 | `limadata.find.work_email` | If only name+domain known |

## Why it works

- ~25–30% reply rate — they already know your brand.
- Pricing/demo-page visits = high intent. Pricing-page visit ≈ 80 pts (Tier 1); 5+ visits in 2
  weeks ≈ 50 pts; multiple stakeholders from one account ≈ 70 pts (buying committee forming).
- Act within 24–48h — same-day outreach converts ~10× better.

## Pixel vs IP identification (external tools)

| Method | Level | Match rate | Geo | Tools |
|--------|-------|-----------|-----|-------|
| Pixel-based | Person (name/email/LinkedIn) | 40–45% | US | RB2B, Warmly |
| IP-based | Company (name/industry/size) | 35–40% | Global (GDPR-safe) | Leadfeeder, Clearbit, ZoomInfo |

Set ICP filters in the tool so you only alert on relevant visitors, and pipe alerts to Slack.

## Flow: visitor → enriched lead → outreach

1. External tool identifies a visitor (person email, or company).
2a. **Person-level (have email):** resolve + enrich.
    → **POST** `/v1/limadata/find/reverse-email-lookup` · 5 cr · `limadata.find.reverse_email_lookup`
    → **POST** `/v1/limadata/enrich/person` · 1–5 cr · `limadata.enrich.person`
2b. **Company-level (have company only):** enrich the account, then find the buying committee.
    → **POST** `/v1/limadata/enrich/company` · 1 cr · `limadata.enrich.company`
    → **POST** `/v1/limadata/prospect/employees` · 25 cr · `limadata.prospect.employees`
3. Get the work email for the right person.
   → **POST** `/v1/limadata/find/work-email` · 1 cr · `limadata.find.work_email`
4. Route to a same-day sequence (see [instantly-api](../instantly-api/SKILL.md)) with copy that
   references the page they viewed (pass the "So what?" test — see
   [signal-detection](../signal-detection/SKILL.md)).

## Tips

- Prioritize pricing/demo/competitor-comparison pages over blog/home visits.
- Dedup visitors against your active sequences before enriching (see
  [list-dedup](../list-dedup/SKILL.md)) — don't pay to enrich someone already in a campaign.
- IP-level hits are accounts, not people — always prospect the committee before outreach.
