<!-- BEGIN COLDIQ -->
# ColdIQ

You have access to the **ColdIQ MCP server** — B2B go-to-market data tools that run
through one API key with unified credits (base URL `https://api.coldiq.com`). The key is
already configured; you do not need to ask the user for it.

## Tools available (via MCP)

- **Prospecting:** `search_companies`, `find_people`, `find_influencers`
- **Contact data:** `find_email`, `find_emails`, `verify_email`, `find_phone`
- **Enrichment:** `enrich_person`, `enrich_company`
- **Intelligence:** `find_signals`, `search_jobs`, `search_ads`, `search_seo`, `search_reddit`
- **Web & local:** `search_web`, `search_places`, `fetch_page_content`

## How to use them well — always batch, never loop

1. To find people across several companies, make **one** `find_people` call passing every
   company in `company_linkedin_urls` (preferred) or `company_domains` — never one call per
   company. Set `limit = (results per company) × (number of companies)`.
2. To find emails for several people, make **one** `find_emails` call with all of them —
   never loop `find_email` per person. It runs providers in parallel and is much faster.
3. Typical flow: `search_companies` → `find_people` (one batched call) → `find_emails`
   (one batched call).

## Credits

Every call settles against the user's ColdIQ balance. Find endpoints don't charge on a
miss (`free_if_not_found`). Dedup before enriching, run cheapest input first, and stop a
waterfall on the first hit. Check balance with the `get_credit_balance` tool.

## Detailed playbooks (skills)

On skill-capable agents (Claude Code, Cursor) the 18 ColdIQ GTM skills — TAM building,
Apollo search, contact enrichment, signal detection, copywriting, campaign delivery, and
more — load on demand. On other agents, lead with the MCP tools above. Full catalog:
https://github.com/Cold-IQ/coldiq-marketplace-skills
<!-- END COLDIQ -->
