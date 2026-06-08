---
name: coldiq-search-enrich
description: >
  Search and enrich people and companies through the ColdIQ marketplace API. Use when
  finding work or personal emails, finding phone numbers, enriching a person or company,
  prospecting contacts by title/seniority/location, Sales-Navigator-style filtering,
  batch enrichment, LinkedIn-URL lookups, or monitoring people/companies for changes.
  Triggers on "find email", "work email", "personal email", "find phone", "enrich person",
  "enrich company", "prospect people", "prospect companies", "search people", "search
  companies", "batch enrich", "find people at company", "LinkedIn lookup", "Sales Navigator
  list". Do NOT use for sending campaigns (see instantly-api / emailbison), Apollo-specific
  filter semantics (see apollo-search), pure list dedup (see list-dedup), or buying-signal
  discovery (see signal-detection).
---

# ColdIQ Search & Enrich

Find people and companies, enrich them with emails/phones/firmographics, and prospect at
scale — all through the ColdIQ marketplace API with one key and unified credits.

> Substitution: this skill was **Lima Data** in GTME OS. Every `api.limadata.com` path is
> now ColdIQ-native `/v1/coldiq/*` (or `/v1/ai-ark/*` for big-database search). Behaviour is
> equivalent; credit costs are best-effort from the admin catalog and unverified.

## ColdIQ Marketplace Endpoints

| Task | Method | Path | Credits | Endpoint ID | Notes |
|------|--------|------|---------|-------------|-------|
| Find work email (name + domain) | POST | `/v1/coldiq/find/work-email` | 1 | `coldiq.find.work_email` | Free if not found |
| Find work email (LinkedIn URL) | POST | `/v1/coldiq/find/work-email-linkedin` | 3 | `coldiq.find.work_email_linkedin` | Fallback when domain missing |
| Find personal email | POST | `/v1/coldiq/find/personal-email` | 5 | `coldiq.find.personal_email` | Free if not found |
| Find phone | POST | `/v1/coldiq/find/phone` | 10 | `coldiq.find.phone` | Free if not found |
| Enrich person | POST | `/v1/coldiq/enrich/person` | 1–5 | `coldiq.enrich.person` | LinkedIn=1, name+company=2, personal email=5 |
| Enrich company | POST | `/v1/coldiq/enrich/company` | 1 | `coldiq.enrich.company` | Firmographics, funding, tech, traffic |
| Prospect people (filter) | POST | `/v1/coldiq/prospect/people/filter` | 25 | `coldiq.prospect.people.filter` | Sales-Nav-style, 25/page |
| Prospect people (SN URL) | POST | `/v1/coldiq/prospect/people/search-url` | 25 | `coldiq.prospect.people.search_url` | Paste a Sales Navigator URL |
| Prospect employees of a company | POST | `/v1/coldiq/prospect/employees` | 25 | `coldiq.prospect.employees` | Title/location/seniority filters |
| Prospect companies (filter) | POST | `/v1/coldiq/prospect/companies/filter` | 25 | `coldiq.prospect.companies.filter` | Firmographic filters |
| Batch prospect people (async) | POST | `/v1/coldiq/batch/prospect-people` | 1/entity | `coldiq.batch.prospect_people` | Cheaper at scale; poll results |
| Batch people profiles (async) | POST | `/v1/coldiq/batch/people` | 1/URL | `coldiq.batch.people` | LinkedIn URLs → profiles |
| Get batch results | POST | `/v1/coldiq/batch/results` | free | `coldiq.batch.results` | Poll every ~60s |
| Autocomplete filter values | POST | `/v1/coldiq/references/autocomplete` | free | `coldiq.references.autocomplete` | Resolve titles/industries/etc. |
| Web search | POST | `/v1/coldiq/search/web` | 0.1 | `coldiq.search.web` | Google web search |
| Large-scale people search | POST | `/v1/ai-ark/people` | per result | `ai_ark.people.search` | 500M profiles; use for big lists |
| Large-scale company search | POST | `/v1/ai-ark/companies` | per result | `ai_ark.companies.search` | 70M companies |

## Quick Reference

- **Base URL:** `https://api.coldiq.com`
- **Auth:** API key header (see [../../endpoints/auth.md](../../endpoints/auth.md) — header unverified)
- **Credits:** every call settles against your ColdIQ balance; check via `/dashboard/credits`
- **Not charged** when a find endpoint returns nothing (`free_if_not_found`)

## Find Emails (Waterfall)

Cheapest-first. Stop at the first hit.

1. Try name + company domain.
   → **POST** `/v1/coldiq/find/work-email` · 1 cr · `coldiq.find.work_email`
   ```json
   { "full_name": "William Gates", "company_domain": "microsoft.com" }
   ```
2. If the domain is missing or step 1 is empty, fall back to the LinkedIn URL.
   → **POST** `/v1/coldiq/find/work-email-linkedin` · 3 cr · `coldiq.find.work_email_linkedin`
   ```json
   { "linkedin_url": "https://linkedin.com/in/williamgates" }
   ```
3. Personal email as a last resort.
   → **POST** `/v1/coldiq/find/personal-email` · 5 cr · `coldiq.find.personal_email`

Find rate is typically 60–70% for work emails. Always verify before sending (see contact-enrichment).

## Prospect People at Target Companies

1. Resolve exact filter values (titles, industries) so you don't waste a 25-credit page.
   → **POST** `/v1/coldiq/references/autocomplete` · free · `coldiq.references.autocomplete`
2. Run the live prospect with company + title + location filters (25 results/page).
   → **POST** `/v1/coldiq/prospect/people/filter` · 25 cr · `coldiq.prospect.people.filter`
   ```json
   {
     "filters": [
       {"filter_type": "company", "operator": "in", "values": ["https://linkedin.com/company/microsoft"]},
       {"filter_type": "current_title", "operator": "in", "values": ["Chief Marketing Officer"]},
       {"filter_type": "location", "operator": "in", "values": ["San Francisco Bay Area"]}
     ],
     "page": 1
   }
   ```

**Common filter types:** `company`, `current_title`, `seniority` (`Owner / Partner`, `CXO`,
`Vice President`, `Director`, `Senior`), `location`, `industry`, `company_headcount`
(`1-10` … `10,001+`), `function`, `recently_changed_jobs`.

Already have a Sales Navigator search URL? Skip the filter-building:
→ **POST** `/v1/coldiq/prospect/people/search-url` · 25 cr · `coldiq.prospect.people.search_url`

Want everyone at one company? Use the employee finder:
→ **POST** `/v1/coldiq/prospect/employees` · 25 cr · `coldiq.prospect.employees`

## Batch Prospect (Large Lists)

For lists above a few hundred, batch is 25× cheaper than live prospecting (1 cr/entity vs 25/page).

1. Submit the batch (entity count a multiple of 25).
   → **POST** `/v1/coldiq/batch/prospect-people` · 1/entity · `coldiq.batch.prospect_people`
   ```json
   { "name": "CMOs at target companies", "filters": [ ... ], "entity_count": 2500,
     "notification_url": "https://your-webhook.com/batch-complete" }
   ```
2. Poll until `completed` (pull pages as they finish — don't wait for the whole job).
   → **POST** `/v1/coldiq/batch/results` · free · `coldiq.batch.results`

Status flow: `pending → processing → completed | failed`. See
[../../shared/async-job-pattern.md](../../shared/async-job-pattern.md) for the generic poll loop.

To turn a list of LinkedIn profile URLs into full profiles, use
→ **POST** `/v1/coldiq/batch/people` · 1/URL · `coldiq.batch.people`

## Enrich

- Person — pick one input (LinkedIn=1 cr, work email=1, name+company=2, personal email=5):
  → **POST** `/v1/coldiq/enrich/person` · 1–5 cr · `coldiq.enrich.person`
- Company — by domain or LinkedIn URL; returns firmographics, funding, tech stack, traffic:
  → **POST** `/v1/coldiq/enrich/company` · 1 cr · `coldiq.enrich.company`

## When to use native vs ai-ark vs Apollo

| Need | Best | Why |
|------|------|-----|
| People at specific companies | `coldiq.prospect.people.filter` | Sales-Nav-style filters, batch support |
| Very large people lists | `ai_ark.people.search` | 500M profiles, per-result pricing |
| Apollo-specific filter semantics | apollo-search skill | Apollo's 65+ filters / intent topics |
| Enrich known contact → email | `coldiq.find.work_email*` | 1 cr name+domain, 3 cr LinkedIn |
| Company firmographics in one call | `coldiq.enrich.company` | Funding, revenue, tech stack together |
| Web / AI research | `coldiq.search.web`, `coldiq.research.ai_search` | 0.1–0.3 cr |

## Tips

- **Title formatting:** "VP SEO" not "VP, SEO" (no comma between prefix and role).
- **Resolve filter values first** with autocomplete — a misspelled title silently returns 0
  and still costs a prospect page.
- **Dedup before enriching** (see [list-dedup](../list-dedup/SKILL.md)) so you never pay twice
  for the same person.
- **Cache:** people data 30 days (job changes), company data 90 days (firmographics move slowly).
