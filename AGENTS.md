<!-- BEGIN COLDIQ -->
# ColdIQ

You have access to the **ColdIQ MCP server** (`https://mcp.coldiq.com/mcp`) — B2B
go-to-market data tools with unified credits. It signs in with the user's ColdIQ account
over OAuth; do not ask the user for an API key. If a tool reports that the server is not
authenticated, ask the user to sign in to the `coldiq` MCP server from their agent's MCP
settings (Codex: `codex mcp login coldiq`).

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

For step-by-step playbooks — TAM building, Apollo search, contact-enrichment waterfalls,
signal detection, ICP & personas, copywriting, campaign delivery, and more:

- On **Claude Code** and **Cursor**, the 17 skills load natively on demand.
- On **every other agent**, call the **`list_skills`** MCP tool to see the catalog, then
  **`load_skill("<name>")`** to read the full playbook before executing the task.

Full catalog: https://github.com/Cold-IQ/coldiq-marketplace-skills
<!-- END COLDIQ -->
