# ColdIQ Marketplace Skills

A distributable package of **GTM skills wired to the ColdIQ marketplace API**. Each skill teaches
an AI agent how to run a go-to-market task (build a TAM, score companies, find & verify emails,
detect buying signals, write copy, load campaigns) **and** tells it exactly which
`https://api.coldiq.com` endpoint to call for each step — one key, unified credits.

The GTM workflows are re-routed from direct-provider APIs (Apollo, Instantly, and the like) onto
the ColdIQ marketplace, so everything runs with one key and unified credits.

## Install (Claude Code)

The ColdIQ marketplace ships as a **Claude Code plugin** — one command installs the 18 GTM skills
**and** the ColdIQ MCP server together, wired to your key, and keeps them updatable.

### One command — install or update

```bash
curl -fsSL https://raw.githubusercontent.com/Cold-IQ/coldiq-marketplace-skills/main/install.sh | bash
```

It checks for the Claude Code CLI, registers the ColdIQ marketplace, installs the plugin, and prompts
for your ColdIQ API key (stored securely in your OS keychain — never written to disk in plaintext).
**Re-run the exact same command any time to update** to the latest skills + MCP.

Prefer not to be prompted? Pass the key non-interactively:

```bash
curl -fsSL https://raw.githubusercontent.com/Cold-IQ/coldiq-marketplace-skills/main/install.sh | COLDIQ_API_KEY=your_key bash
```

### Or use the Claude Code CLI directly (any OS — macOS, Linux, Windows)

No script needed; this is exactly what the installer runs under the hood:

```bash
claude plugin marketplace add Cold-IQ/coldiq-marketplace-skills
claude plugin install coldiq@coldiq --config apiKey=YOUR_COLDIQ_API_KEY
```

Get a key from your ColdIQ dashboard at <https://coldiq.com/marketplace> (→ API keys). Then **restart
Claude Code** (or run `/reload-plugins`) so the MCP server loads.

### Updating

Skills and endpoint wiring improve on GitHub continuously. Pull the latest with:

```bash
claude plugin marketplace update coldiq && claude plugin update coldiq@coldiq
```

…or just re-run the install one-liner — it's the same thing. Restart Claude Code / `/reload-plugins`
afterwards so MCP changes take effect (skill changes load live).

### What you get

- **18 GTM skills** under the `coldiq:` namespace (e.g. `coldiq:apollo-search`), activated
  automatically from their `description` triggers — ask *"find the work email for this LinkedIn URL"*
  and the right skill kicks in. List them with `/plugin`.
- **The ColdIQ MCP server** (`@coldiq/mcp`), authenticated with your key, exposing the
  search / enrich / verify / signals tools to Claude.

One key, unified credits, base URL `https://api.coldiq.com`.

### Other agents (Agent SDK, custom — no plugin system)

<details>
<summary>Manual install: clone + copy the skills folder</summary>

Each skill is a folder under `skills/` containing a `SKILL.md` (YAML frontmatter + body). Skills
cross-reference each other and the shared docs by relative path (`../../endpoints/`, `../../shared/`),
so keep the whole repo together rather than copying `skills/` alone.

```bash
git clone https://github.com/Cold-IQ/coldiq-marketplace-skills.git
cd coldiq-marketplace-skills
export COLDIQ_API_KEY="your-key-here"
node scripts/validate.mjs   # optional: 18 skills should lint clean
```

Point your agent at the `skills/` folder and load each `SKILL.md`. The frontmatter `description` is
what the agent reads to decide when to use a skill.

</details>

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
