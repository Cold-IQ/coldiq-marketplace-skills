# ColdIQ Marketplace Skills

A distributable package of **GTM skills wired to the ColdIQ marketplace API**. Each skill teaches
an AI agent how to run a go-to-market task (build a TAM, score companies, find & verify emails,
detect buying signals, write copy, load campaigns) **and** tells it exactly which
`https://api.coldiq.com` endpoint to call for each step — one key, unified credits.

The GTM workflows are re-routed from direct-provider APIs (Apollo, Instantly, and the like) onto
the ColdIQ marketplace, so everything runs with one key and unified credits.

## Install

### 1. Clone the repo

```bash
git clone https://github.com/Cold-IQ/coldiq-marketplace-skills.git
cd coldiq-marketplace-skills
```

### 2. Install the skills into your agent

Each skill is a folder under `skills/` containing a `SKILL.md` (YAML frontmatter + body). Drop those
folders wherever your agent looks for skills.

**Claude Code — all projects (recommended):**
```bash
mkdir -p ~/.claude/skills
cp -R skills/* ~/.claude/skills/
```

**Claude Code — one project only:**
```bash
mkdir -p /path/to/your/project/.claude/skills
cp -R skills/* /path/to/your/project/.claude/skills/
```

Restart Claude Code (or run `/skills`) and the 18 skills appear. They activate automatically from
their `description` triggers — e.g. ask *"find the work email for this LinkedIn URL"* and
`coldiq-search-enrich` kicks in.

**Other agents (Agent SDK, custom):** point the agent at the `skills/` folder and load each
`SKILL.md`. The frontmatter `description` is what the agent reads to decide when to use a skill.

> Tip: skills cross-reference each other and the shared docs by relative path (`../../endpoints/`,
> `../../shared/`). If you copy only `skills/`, those links won't resolve — copy the whole repo, or
> just clone it and keep `~/.claude/skills` as a symlink to `skills/`:
> `ln -s "$(pwd)/skills" ~/.claude/skills/coldiq` (groups them under one folder).

### 3. Set your ColdIQ API key

Get a key from your ColdIQ dashboard (`POST /dashboard/api-keys`), then:

```bash
export COLDIQ_API_KEY="your-key-here"
```

Base URL is `https://api.coldiq.com`. ⚠️ The exact auth **header** (`X-KEY` vs
`Authorization: Bearer`) is not yet confirmed — see [endpoints/auth.md](endpoints/auth.md) and
confirm before live calls.

### 4. (Optional) Verify the install

```bash
node scripts/validate.mjs   # 18 skills should lint clean
```

That's it — your agent now runs GTM tasks through the ColdIQ marketplace, one key, unified credits.

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

## The skills (18)

**Search / enrich / lists:** coldiq-search-enrich (folder `lima-data-api`), apollo-search,
contact-enrichment, clay-mastery, list-dedup, meta-ads-scraper.
**Signals & strategy:** signal-detection, tam-scoring, icp-personas, website-visitors.
**Outreach & infra:** instantly-api, email-infra, emailbison, ad-audiences, campaign-delivery.
**Copy (methodology):** crawford-method, cold-email-copy. **Meetings:** fireflies-usage.

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

All 18 skills lint clean. Endpoint paths/credits/auth are **best-effort from a pasted admin
catalog and unverified** — confirm against the live API before production. See the
"Needs Verification" section of [endpoints/catalog.md](endpoints/catalog.md).
