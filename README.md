# ColdIQ Marketplace Skills

A distributable package of **GTM skills wired to the ColdIQ marketplace API**. Each skill teaches
an AI agent how to run a go-to-market task (build a TAM, score companies, find & verify emails,
detect buying signals, write copy, load campaigns) **and** tells it exactly which
`https://api.coldiq.com` endpoint to call for each step — one key, unified credits.

The GTM workflows are re-routed from direct-provider APIs (Apollo, Instantly, and the like) onto
the ColdIQ marketplace, so everything runs with one key and unified credits.

## Install

```bash
git clone <this-repo> coldiq-marketplace-skills
```

Point your agent (Claude Code, an Agent SDK app, etc.) at the `skills/` folder. Each skill is a
`SKILL.md` with YAML frontmatter — the `description` field drives activation.

## Auth

Base URL `https://api.coldiq.com`. Get a key from the dashboard
(`POST /dashboard/api-keys`). ⚠️ The exact auth header is **not yet confirmed** — see
[endpoints/auth.md](endpoints/auth.md). Confirm it before any live calls.

## Layout

```
endpoints/
  catalog.json     canonical endpoint registry (source of truth, machine-readable)
  catalog.md       human view + "Needs Verification" punch-list
  providers.md     the ~39 providers; native vs resold; direct-provider → ColdIQ mapping
  auth.md          base URL, API key header (unverified), credits
  _raw/            the original pasted admin catalog (provenance, never edited)
skills/            one folder per skill (SKILL.md + optional resources/)
shared/            conventions, async-job pattern, credit optimization
scripts/validate.mjs   offline linter
```

## The skills (14)

**Actionable (re-routed to ColdIQ endpoints):** coldiq-search-enrich (folder `lima-data-api`),
apollo-search, contact-enrichment, instantly-api, clay-mastery, meta-ads-scraper, emailbison.
**Augmented (endpoints added where they exist):** signal-detection, tam-scoring, campaign-delivery,
crawford-method. **Methodology (no endpoints):** cold-email-copy, list-dedup, fireflies-usage.

## How endpoints are wired into skills

Three layers, all keyed by a stable endpoint `id` from `catalog.json`:
1. a canonical **registry** (`endpoints/catalog.json`),
2. a per-skill **`## ColdIQ Marketplace Endpoints` table**, and
3. inline **callouts** at each step: `→ **POST** \`/v1/coldiq/find/work-email\` · 1 cr · \`coldiq.find.work_email\``.

Full spec in [shared/conventions.md](shared/conventions.md).

## Validate

```bash
node scripts/validate.mjs
```

Checks frontmatter, that every cited endpoint id resolves, table↔callout consistency,
callout↔catalog method/path match, no stray direct-provider URLs, and prints the
Needs-Verification list (endpoints to confirm against the live API).

## Status

All 14 skills lint clean. Endpoint paths/credits/auth are **best-effort from a pasted admin
catalog and unverified** — confirm against the live API before production. See the
"Needs Verification" section of [endpoints/catalog.md](endpoints/catalog.md).
