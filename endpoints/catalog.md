# Endpoint catalog (human view)

Generated from `catalog.json` (v2026.06.08). Base URL `https://api.coldiq.com`. Auth header `X-KEY` (verified: false).

> Credit values are best-effort from the pasted admin dump. The dump's 'Cost' column was garbled for several groups (e.g. all apollo rows showed 2832, all blitzapi showed 2994). Real per-call costs are taken from each endpoint's description text. Any value we could not read is 'unknown'.

**145 endpoints across 30 groups.** This is a curated, GTM-relevant slice of the full ~575-endpoint marketplace — see `_raw/catalog-dump.txt` for the complete pasted list.

## ai-ark

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/ai-ark/companies` | per_result | `ai_ark.companies.search` | Search 70M+ enriched company profiles by industry, location, employee size, revenue, funding |
| POST | `/v1/ai-ark/people` | per_result | `ai_ark.people.search` | Search 500M+ enriched people profiles by name, title, seniority, skills, education |
| POST | `/v1/ai-ark/people/reverse-lookup` | 5 | `ai_ark.people.reverse_lookup` | Look up a person profile by email address or phone number |
| POST | `/v1/ai-ark/people/mobile-phone-finder` | 10 | `ai_ark.people.mobile_phone_finder` | Find a person's mobile phone by LinkedIn URL or name + company domain |
| POST | `/v1/ai-ark/people/export/single` | free | `ai_ark.people.export_single` | Export a single person's full profile with verified email (by AI Ark person ID or LinkedIn URL) |
| POST | `/v1/ai-ark/people/export` | per_result | `ai_ark.people.export` | Export up to 10,000 people profiles with verified emails by company + contact filters; returns trackId |
| POST | `/v1/ai-ark/people/email-finder` | per_result | `ai_ark.people.email_finder` | Find emails for all people in a previous People Search result, by its trackId |
| GET | `/v1/ai-ark/people/export/{trackId}` | free | `ai_ark.people.export.result` | Retrieve the result of an Export People job |
| GET | `/v1/ai-ark/people/email-finder/{trackId}` | free | `ai_ark.people.email_finder.result` | Retrieve the result of a Find Emails job |

## apollo

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/apollo/people/search` | 1 | `apollo.people.search` | Search people in Apollo's global DB by title, seniority, location, company |
| POST | `/v1/apollo/organizations/search` | 1 | `apollo.organizations.search` | Search organizations in Apollo by industry, size, location |
| POST | `/v1/apollo/people/match` | 1 | `apollo.people.match` | Enrich a person by name, email, LinkedIn URL, or company |
| POST | `/v1/apollo/people/bulk-match` | per_result | `apollo.people.bulk_match` | Enrich up to 10 people in one request (1 cr/person) |
| POST | `/v1/apollo/organizations/enrich` | 1 | `apollo.organizations.enrich` | Enrich an organization by domain (size, funding, tech stack) |
| POST | `/v1/apollo/organizations/bulk-enrich` | per_result | `apollo.organizations.bulk_enrich` | Enrich up to 10 organizations by domain (1 cr/org) |
| POST | `/v1/apollo/organizations/info` | 1 | `apollo.organizations.info` | Get complete organization info by Apollo ID |

## builtwith

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/builtwith/domain` | flat | `builtwith.domain` | Full technology stack detected on a domain |

## career-site-jobs

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/career-site-jobs/search` | unknown | `career_site_jobs.search.create` | Async search of real job postings from 175k+ company career sites (54 ATS) |

## coldiq

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/coldiq/enrich/person` | 1-5 | `coldiq.enrich.person` | Enrich a person's professional profile by email, LinkedIn URL, or name+company |
| POST | `/v1/coldiq/enrich/company` | 1 | `coldiq.enrich.company` | Enrich a company by domain or LinkedIn URL; firmographics, funding, tech stack, traffic |
| POST | `/v1/coldiq/person` | 3 | `coldiq.person` | Retrieve LinkedIn person data by profile URL (cached 30-60d; live=true for fresh) |
| POST | `/v1/coldiq/company` | 3 | `coldiq.company` | Get LinkedIn company data by profile URL (live=true for fresh) |
| POST | `/v1/coldiq/company/insights` | 5 | `coldiq.company.insights` | Company insights from Crunchbase, Semrush, IPqwery and others |
| POST | `/v1/coldiq/company/workplace-benefits` | 3 | `coldiq.company.workplace_benefits` | Get workplace benefits for a company by Glassdoor ID |
| POST | `/v1/coldiq/workplace-ratings` | 3 | `coldiq.workplace_ratings` | Get workplace ratings for a company by Glassdoor ID |
| POST | `/v1/coldiq/find/hashed-email` | 1 | `coldiq.find.hashed_email` | Find SHA-256 hashed emails for ad audience targeting (LinkedIn URL or work email) |
| POST | `/v1/coldiq/find/personal-email` | 5 | `coldiq.find.personal_email` | Find personal email from LinkedIn, GitHub, X, or work email |
| POST | `/v1/coldiq/find/work-email` | 1 | `coldiq.find.work_email` | Find business email from full name + company domain |
| POST | `/v1/coldiq/find/work-email-linkedin` | 3 | `coldiq.find.work_email_linkedin` | Find business email from a LinkedIn profile URL |
| POST | `/v1/coldiq/find/company-linkedin` | 1 | `coldiq.find.company_linkedin` | Find the LinkedIn page of a company from its domain |
| POST | `/v1/coldiq/find/phone` | 10 | `coldiq.find.phone` | Find phone numbers from LinkedIn profile or name+company |
| POST | `/v1/coldiq/find/identity-resolution` | 2 | `coldiq.find.identity_resolution` | Find social profile URLs (LinkedIn etc.) by name and company/domain/email |
| POST | `/v1/coldiq/find/reverse-email-lookup` | 5 | `coldiq.find.reverse_email_lookup` | Find LinkedIn, GitHub, X profiles from an email address |
| POST | `/v1/coldiq/find/glassdoor-company` | 1 | `coldiq.find.glassdoor_company` | Find the Glassdoor ID for a company from its domain |
| POST | `/v1/coldiq/jobs` | 2 | `coldiq.jobs` | Get LinkedIn job listings for a company page (20/page) |
| POST | `/v1/coldiq/jobs/details` | 1 | `coldiq.jobs.details` | Get detailed info about a LinkedIn job posting by ID |
| POST | `/v1/coldiq/posts` | 2 | `coldiq.posts` | Get LinkedIn posts of a person or company profile |
| POST | `/v1/coldiq/posts/comments` | 2 | `coldiq.posts.comments` | Get comments for a LinkedIn post using comments_urn |
| POST | `/v1/coldiq/posts/reactions` | 2 | `coldiq.posts.reactions` | Get reactions for a LinkedIn post using reactions_urn |
| POST | `/v1/coldiq/posts/details` | 1 | `coldiq.posts.details` | Get details of a single LinkedIn post by URL |
| POST | `/v1/coldiq/search/people` | 2 | `coldiq.search.people` | Search people by keywords with title/company/location filters |
| POST | `/v1/coldiq/search/companies` | 2 | `coldiq.search.companies` | Search companies by keywords with size/location/industry filters |
| POST | `/v1/coldiq/search/jobs` | 2 | `coldiq.search.jobs` | Search jobs by keywords with filters |
| POST | `/v1/coldiq/search/posts` | 2 | `coldiq.search.posts` | Search LinkedIn posts by keywords with filters |
| POST | `/v1/coldiq/search/web` | 0.1 | `coldiq.search.web` | Perform a Google web search |
| POST | `/v1/coldiq/research/ai-search` | 0.3 | `coldiq.research.ai_search` | AI-powered web search that retrieves and synthesizes information |
| POST | `/v1/coldiq/research/extract` | 0.1 | `coldiq.research.extract` | Extract clean markdown content from web pages (1-10 URLs) |
| POST | `/v1/coldiq/references/autocomplete` | free | `coldiq.references.autocomplete` | Get autocomplete results for prospect filter types |
| POST | `/v1/coldiq/prospect/people/search-url` | 25 | `coldiq.prospect.people.search_url` | Prospect people from a LinkedIn Sales Navigator search URL (25/page) |
| POST | `/v1/coldiq/prospect/people/filter` | 25 | `coldiq.prospect.people.filter` | Prospect people using filter criteria |
| POST | `/v1/coldiq/prospect/employees` | 25 | `coldiq.prospect.employees` | Prospect employees of a company with title/location/seniority filters |
| POST | `/v1/coldiq/prospect/companies/filter` | 25 | `coldiq.prospect.companies.filter` | Prospect companies using filter criteria |
| POST | `/v1/coldiq/prospect/companies/search-url` | 25 | `coldiq.prospect.companies.search_url` | Prospect companies from a LinkedIn Sales Navigator company search URL |
| POST | `/v1/coldiq/batch/people` | per_result | `coldiq.batch.people` | Batch retrieve LinkedIn people profiles (1 cr/URL) |
| POST | `/v1/coldiq/batch/companies` | per_result | `coldiq.batch.companies` | Batch retrieve LinkedIn company profiles (1 cr/URL) |
| POST | `/v1/coldiq/batch/prospect-people` | per_result | `coldiq.batch.prospect_people` | Batch prospect people with filters (1 cr/entity — cheaper at scale than live prospect) |
| POST | `/v1/coldiq/batch/prospect-companies` | per_result | `coldiq.batch.prospect_companies` | Batch prospect companies with filters (1 cr/entity) |
| POST | `/v1/coldiq/batch/list` | free | `coldiq.batch.list` | List all batch operations |
| POST | `/v1/coldiq/batch/results` | free | `coldiq.batch.results` | Get results of a batch operation by ID |
| POST | `/v1/coldiq/watch` | free | `coldiq.watch.create` | Create a watch subscription to monitor people/companies for changes (job changes, profile changes) |
| POST | `/v1/coldiq/watch/list` | free | `coldiq.watch.list` | List all watch subscriptions |

## dashboard

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| GET | `/dashboard/credits` | free | `dashboard.credits` | Get credit balance |
| GET | `/dashboard/usage` | free | `dashboard.usage` | Get usage history |
| GET | `/dashboard/api-keys` | free | `dashboard.api_keys.list` | List API keys |
| GET | `/dashboard/connections` | free | `dashboard.connections.list` | List your connected (BYOK) tools |

## exa

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/exa/search` | 0.3 | `exa.search` | Neural or deep web search; ranked results with optional content |

## findymail

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/findymail/verify` | 1 | `findymail.verify` | Verify whether an email is deliverable (bounce check) |
| POST | `/v1/findymail/search/name` | 1 | `findymail.search.name` | Find an email from name + company domain (1 cr if found) |
| POST | `/v1/findymail/search/business-profile` | 1 | `findymail.search.business_profile` | Find an email from a LinkedIn profile URL (1 cr if found) |
| POST | `/v1/findymail/search/employees` | per_result | `findymail.search.employees` | Find employees at a company by job titles (1 cr/contact found) |
| POST | `/v1/findymail/search/phone` | 10 | `findymail.search.phone` | Find a phone number from a LinkedIn profile URL (10 cr if found) |

## fullenrich

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/fullenrich/contact/enrich/bulk` | per_result | `fullenrich.contact.enrich_bulk` | Submit up to 100 contacts for enrichment; returns enrichment_id (async) |
| GET | `/v1/fullenrich/contact/enrich/bulk/{enrichmentId}` | free | `fullenrich.contact.enrich_bulk.result` | Retrieve the result of a bulk enrichment job |

## google-ads

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/google-ads/search` | flat | `google_ads.search.create` | Async scrape of Google Ads from the Ads Transparency Center |

## google-maps

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/google-maps/scraper` | unknown | `google_maps.scraper.create` | Async extract of places from Google Maps by search terms or URLs |

## icypeas

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/icypeas/email-search` | 0.3 | `icypeas.email_search` | Find an email from firstname, lastname, company domain (async, poll _id) |
| POST | `/v1/icypeas/email-verification` | 0.1 | `icypeas.email_verification` | Verify whether an email is valid and deliverable (async) |

## instantly

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/instantly/campaigns` | free | `instantly.campaigns.create` | Create a campaign |
| GET | `/v1/instantly/campaigns` | free | `instantly.campaigns.list` | List campaigns |
| GET | `/v1/instantly/campaigns/{id}` | free | `instantly.campaigns.get` | Get a campaign |
| PATCH | `/v1/instantly/campaigns/{id}` | free | `instantly.campaigns.patch` | Update a campaign |
| POST | `/v1/instantly/campaigns/{id}/activate` | free | `instantly.campaigns.activate` | Activate a campaign (empty body) |
| POST | `/v1/instantly/campaigns/{id}/pause` | free | `instantly.campaigns.pause` | Pause a campaign |
| POST | `/v1/instantly/campaigns/{id}/variables` | free | `instantly.campaigns.variables` | Add campaign variables |
| GET | `/v1/instantly/campaigns/analytics` | free | `instantly.campaigns.analytics` | Get campaign analytics (open/reply/bounce rates) |
| GET | `/v1/instantly/campaigns/analytics/daily` | free | `instantly.campaigns.analytics.daily` | Get daily campaign analytics time series |
| GET | `/v1/instantly/campaigns/analytics/steps` | free | `instantly.campaigns.analytics.steps` | Get per-step campaign analytics |
| POST | `/v1/instantly/leads` | free | `instantly.leads.create` | Create a single lead (first_name, last_name, email, company_name, custom vars) |
| POST | `/v1/instantly/leads/add` | free | `instantly.leads.add` | Bulk add leads to a campaign |
| POST | `/v1/instantly/leads/list` | free | `instantly.leads.list` | List leads (check status) |
| POST | `/v1/instantly/email-verification` | free | `instantly.email_verification.create` | Create an email verification |
| POST | `/v1/instantly/accounts` | free | `instantly.accounts.create` | Add/connect a sending account (mailbox) |
| GET | `/v1/instantly/accounts` | free | `instantly.accounts.list` | List sending accounts (mailboxes) |
| GET | `/v1/instantly/accounts/{email}` | free | `instantly.accounts.get` | Get one sending account's status/health |
| POST | `/v1/instantly/accounts/warmup/enable` | free | `instantly.accounts.warmup_enable` | Enable warmup on accounts |
| POST | `/v1/instantly/accounts/warmup/disable` | free | `instantly.accounts.warmup_disable` | Disable warmup on accounts (avoid once live) |
| POST | `/v1/instantly/accounts/warmup-analytics` | free | `instantly.accounts.warmup_analytics` | Get warmup health/analytics for accounts |
| POST | `/v1/instantly/accounts/test/vitals` | free | `instantly.accounts.test_vitals` | Test account vitals (deliverability/connection health) |
| GET | `/v1/instantly/accounts/analytics/daily` | free | `instantly.accounts.analytics_daily` | Daily per-account sending analytics |
| POST | `/v1/instantly/dfy-email-account-orders` | free | `instantly.dfy_orders.create` | Order done-for-you (pre-warmed) email accounts + domains |
| POST | `/v1/instantly/dfy-email-account-orders/domains/check` | free | `instantly.dfy_orders.domains_check` | Check domain availability for DFY order |
| POST | `/v1/instantly/dfy-email-account-orders/domains/pre-warmed-up-list` | free | `instantly.dfy_orders.domains_prewarmed` | Get list of available pre-warmed domains |

## jina

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/jina/reader` | flat | `jina.reader` | Fetch any URL → clean LLM-ready markdown (handles JS, PDFs) |

## jungler

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/jungler/workbooks` | free | `jungler.workbooks.create` | Extract comments and/or reactions from a LinkedIn post; returns task_id (async) |

## leadsfactory

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/leadsfactory/contact-finder/searches` | per_result | `leadsfactory.contact_finder.create` | Find contacts by job title + seniority across a list of company LinkedIn URLs |

## lemlist

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| GET | `/v1/lemlist/campaigns` | free | `lemlist.campaigns.list` | List campaigns |
| POST | `/v1/lemlist/campaigns` | free | `lemlist.campaigns.create` | Create a campaign |
| POST | `/v1/lemlist/campaigns/{campaignId}/leads` | free | `lemlist.campaigns.leads.create` | Create a lead in a campaign |
| POST | `/v1/lemlist/campaigns/{campaignId}/start` | free | `lemlist.campaigns.start` | Start a campaign |
| GET | `/v1/lemlist/campaigns/{campaignId}/stats` | free | `lemlist.campaigns.stats` | Get campaign stats |

## linkedin-ad-library

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/linkedin-ad-library/search` | flat | `linkedin_ad_library.search.create` | Async scrape of the LinkedIn Ad Library; returns jobId |

## linkedin-jobs-api

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/linkedin-jobs-api/search` | unknown | `linkedin_jobs.search.create` | Async advanced LinkedIn job search (title, location, description, company filters) |

## linkupapi

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/linkupapi/data/mail/finder` | unknown | `linkupapi.mail.finder` | Find a professional email from LinkedIn URL or name + company domain |
| POST | `/v1/linkupapi/data/fundraising-companies` | unknown | `linkupapi.fundraising_companies` | Find companies that recently received funding |
| POST | `/v1/linkupapi/data/hiring-companies` | unknown | `linkupapi.hiring_companies` | Find companies actively hiring for roles (Indeed + LinkedIn) |

## meta-ads

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/meta-ads/search` | flat | `meta_ads.search.create` | Async search of the Facebook Ads Library by keyword or URL; returns jobId |
| GET | `/v1/meta-ads/search/{jobId}` | free | `meta_ads.search.result` | Poll a Meta Ads Library job (202 in progress, 200 done) |

## pdl

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/pdl/person/enrich` | flat | `pdl.person.enrich` | Match a person against PDL ~3B profiles by email, LinkedIn, phone, or name+contact |
| GET | `/v1/pdl/company/enrich` | flat | `pdl.company.enrich` | Enrich a company by website, name, LinkedIn URL, or stock ticker |
| POST | `/v1/pdl/person/search` | per_result | `pdl.person.search` | Query the PDL person dataset (Elasticsearch DSL or SQL) |

## predictleads

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| GET | `/v1/predictleads/discover/financing_events` | 0.18 | `predictleads.discover.financing_events` | Discover financing events by type and/or company location |
| GET | `/v1/predictleads/discover/job_openings` | 0.18 | `predictleads.discover.job_openings` | Discover job openings by O*NET codes and/or location |
| GET | `/v1/predictleads/discover/news_events` | 0.18 | `predictleads.discover.news_events` | Discover news events by category and/or company location |
| GET | `/v1/predictleads/companies/{companyIdOrDomain}/technology_detections` | 0.18 | `predictleads.company.technology_detections` | Technologies detected on a company website |

## prospeo

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/prospeo/enrich-person` | unknown | `prospeo.enrich_person` | Enrich a person by LinkedIn URL, email, name+company, or internal ID |
| POST | `/v1/prospeo/bulk-enrich-person` | unknown | `prospeo.bulk_enrich_person` | Enrich up to 50 person records (each needs an identifier) |
| POST | `/v1/prospeo/search-person` | free | `prospeo.search_person` | Search people with 30+ filters (seniority, location, industry, YoE) |
| POST | `/v1/prospeo/enrich-company` | unknown | `prospeo.enrich_company` | Enrich a company by website, LinkedIn URL, name, or internal ID |

## reddit

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/reddit/scrape` | unknown | `reddit.scrape.create` | Async scrape of Reddit posts, comments, communities, or users by URL |

## serper

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/serper/search` | unknown | `serper.search` | Google web search (organic, knowledge graph, answer boxes) |
| POST | `/v1/serper/news` | unknown | `serper.news` | Google News search (tbs param for recency) |
| POST | `/v1/serper/places` | unknown | `serper.places` | Google Places search (name, address, coords, rating, phone, website) |

## signalbase

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| GET | `/v1/signalbase/funding-signals` | unknown | `signalbase.funding_signals` | Get funding signals (companies with funding events) with filters, pagination, search |
| GET | `/v1/signalbase/acquisition-signals` | unknown | `signalbase.acquisition_signals` | Get acquisition signals (M&A events) |
| GET | `/v1/signalbase/job-change-signals` | unknown | `signalbase.job_change_signals` | Get job change signals (role-aware position filters, department) |
| GET | `/v1/signalbase/hiring-signals` | unknown | `signalbase.hiring_signals` | Get hiring signals (open job postings, role-aware filters) |
| GET | `/v1/signalbase/investors` | unknown | `signalbase.investors` | Get investor data (VC firms, angels, PE) |
| GET | `/v1/signalbase/companies` | unknown | `signalbase.companies` | Browse/search companies with industry, headcount filters |

## sumble

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/sumble/organizations/enrich` | per_result | `sumble.organizations.enrich` | Identify technologies used at a specific organization (5 cr/tech found) |

## theirstack

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/theirstack/jobs/search` | per_result | `theirstack.jobs.search` | Search job postings by title, technology, company, location, seniority (1 cr/job) |
| POST | `/v1/theirstack/companies/search` | per_result | `theirstack.companies.search` | Search companies by tech stack, hiring signals, firmographics, funding (3 cr/company) |
| POST | `/v1/theirstack/companies/buying_intents` | 3 | `theirstack.companies.buying_intents` | Detect buying intent topics for a company from job signals + tech adoption (3 cr) |

## wiza

| Method | Path | Credits | Endpoint ID | Summary |
|---|---|---|---|---|
| POST | `/v1/wiza/individual-reveals` | unknown | `wiza.individual_reveals.create` | Enrich a single contact; returns reveal ID (async) |
| POST | `/v1/wiza/lists` | per_result | `wiza.lists.create` | Bulk enrich up to 2,500 contacts; returns list ID (async) |
| POST | `/v1/wiza/company-enrichments` | 2 | `wiza.company_enrichments` | Enrich company data by name, domain, or LinkedIn (2 cr/success) |

## Needs Verification

Everything below is unconfirmed against the live API. Confirm before production.

- **Auth header** `X-KEY` is a guess — see [auth.md](auth.md).
- **145 endpoints** are `verified:false` (all of them, pending a live smoke test).
- **20 endpoints** have `credits:"unknown"` (cost unreadable in the dump):
  - `prospeo.enrich_person` — POST /v1/prospeo/enrich-person
  - `prospeo.bulk_enrich_person` — POST /v1/prospeo/bulk-enrich-person
  - `prospeo.enrich_company` — POST /v1/prospeo/enrich-company
  - `wiza.individual_reveals.create` — POST /v1/wiza/individual-reveals
  - `linkupapi.mail.finder` — POST /v1/linkupapi/data/mail/finder
  - `linkupapi.fundraising_companies` — POST /v1/linkupapi/data/fundraising-companies
  - `linkupapi.hiring_companies` — POST /v1/linkupapi/data/hiring-companies
  - `signalbase.funding_signals` — GET /v1/signalbase/funding-signals
  - `signalbase.acquisition_signals` — GET /v1/signalbase/acquisition-signals
  - `signalbase.job_change_signals` — GET /v1/signalbase/job-change-signals
  - `signalbase.hiring_signals` — GET /v1/signalbase/hiring-signals
  - `signalbase.investors` — GET /v1/signalbase/investors
  - `signalbase.companies` — GET /v1/signalbase/companies
  - `career_site_jobs.search.create` — POST /v1/career-site-jobs/search
  - `linkedin_jobs.search.create` — POST /v1/linkedin-jobs-api/search
  - `google_maps.scraper.create` — POST /v1/google-maps/scraper
  - `reddit.scrape.create` — POST /v1/reddit/scrape
  - `serper.search` — POST /v1/serper/search
  - `serper.news` — POST /v1/serper/news
  - `serper.places` — POST /v1/serper/places
- **1 flagged entries** (path/source uncertainty):
  - `coldiq.workplace_ratings` — dump-path-said-/v1/colany/workplace-ratings; assumed /v1/coldiq/
