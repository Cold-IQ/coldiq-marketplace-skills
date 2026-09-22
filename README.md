# ColdIQ Marketplace Skills

A distributable package of **GTM skills wired to the ColdIQ marketplace API**. Each skill teaches
an AI agent how to run a go-to-market task (build a TAM, score companies, find & verify emails,
detect buying signals, write copy, load campaigns) **and** tells it exactly which
`https://api.coldiq.com` endpoint to call for each step — one key, unified credits.

The GTM workflows are re-routed from direct-provider APIs (Apollo, Instantly, and the like) onto
the ColdIQ marketplace, so everything runs with one key and unified credits.

## Install

ColdIQ ships two things: the **hosted MCP server** at `https://mcp.coldiq.com/mcp` (search / enrich /
verify / signals tools) and the **17 GTM skills** (step-by-step playbooks). One command installs them
into whichever agents you have.

### One command — install or update (any agent)

```bash
curl -fsSL https://raw.githubusercontent.com/Cold-IQ/coldiq-marketplace-skills/main/install.sh | bash
```

It detects your installed agents (Claude Code, Cursor, Codex, Windsurf, Cline), connects each to the
hosted MCP server, and installs the skills where the agent supports them. There is no API key to paste:
each agent signs in with your ColdIQ account (OAuth) the first time it connects. It also replaces an
older `npx @coldiq/mcp` setup — that standalone package is retired. **Re-run the same command any
time to update.**

### What each agent gets

| Agent | Skills | MCP tools | How |
|---|---|---|---|
| **Claude Code** | ✅ 17 (native, progressive) | ✅ | Plugin — OAuth sign-in, auto-updates on restart |
| **Cursor** | ✅ 17 (native Skills) | ✅ | `npx skills` + `~/.cursor/mcp.json` |
| **Codex** | ✅ via MCP (`list_skills`) | ✅ | `codex mcp add` + `~/.codex/AGENTS.md` |
| **Windsurf** | ✅ via MCP (`list_skills`) | ✅ | `~/.codeium/windsurf/mcp_config.json` |
| **Cline** | ✅ via MCP (`list_skills`) | ✅ | VS Code `cline_mcp_settings.json` |

Agents with a native skills loader (Claude Code, Cursor) load the 17 skills directly. **Every other
agent gets them over the MCP**: the server exposes `list_skills` (the catalog) and `load_skill(name)`
(the full playbook on demand), so installing the MCP is enough — no native loader required. One
account, unified credits, hosted at `https://mcp.coldiq.com/mcp`.

### Manual setup (per agent)

<details>
<summary><b>Claude Code</b> — plugin</summary>

```bash
claude plugin marketplace add Cold-IQ/coldiq-marketplace-skills
claude plugin install coldiq@coldiq
```

Restart Claude Code (or `/reload-plugins`), then run `/mcp`, pick `plugin:coldiq:coldiq`, and
choose **Authenticate** to sign in with your ColdIQ account. Skills are namespaced `coldiq:<name>`
(e.g. `coldiq:apollo-search`) and activate from their `description` triggers.

MCP only, without the plugin:
```bash
claude mcp add --transport http --scope user coldiq https://mcp.coldiq.com/mcp
```

**Updates are automatic.** The installer enables startup auto-update; the plugin has no pinned version
(it tracks the git commit SHA), so **each push to `main` reaches you on the next restart**. Update on
demand with `claude plugin marketplace update coldiq && claude plugin update coldiq@coldiq`; disable via
`/plugin` → Marketplaces → `coldiq` → Disable auto-update.
</details>

<details>
<summary><b>Cursor</b> — Skills + MCP</summary>

Skills:
```bash
npx skills add Cold-IQ/coldiq-marketplace-skills --agent cursor --global --yes
```
MCP — add to `~/.cursor/mcp.json`, then enable the server in Settings → MCP and sign in:
```json
{
  "mcpServers": {
    "coldiq": {
      "url": "https://mcp.coldiq.com/mcp"
    }
  }
}
```
</details>

<details>
<summary><b>Codex</b> — MCP + AGENTS.md</summary>

```bash
codex mcp add coldiq --url https://mcp.coldiq.com/mcp
```
This starts the sign-in; run `codex mcp login coldiq` to sign in again later.
Codex has no skills loader, so add the [`AGENTS.md`](AGENTS.md) block (covers the tools + the
batch-don't-loop workflow) to `~/.codex/AGENTS.md`. The installer does this for you.
</details>

<details>
<summary><b>Windsurf / Cline</b> — MCP</summary>

- **Windsurf:** `~/.codeium/windsurf/mcp_config.json`
  ```json
  { "mcpServers": { "coldiq": { "serverUrl": "https://mcp.coldiq.com/mcp" } } }
  ```
- **Cline:** its `cline_mcp_settings.json` (VS Code globalStorage)
  ```json
  { "mcpServers": { "coldiq": { "type": "streamableHttp", "url": "https://mcp.coldiq.com/mcp" } } }
  ```

Then refresh MCP servers in the agent and sign in with your ColdIQ account.
</details>

<details>
<summary><b>Other agents / Agent SDK</b></summary>

`npx skills add Cold-IQ/coldiq-marketplace-skills --agent '*'` installs the skills to ~70 agents
(via [vercel-labs/skills](https://github.com/vercel-labs/skills) — a third-party CLI fetched with
`npx`; review before running). Each skill is a self-contained folder under `skills/` (`SKILL.md` +
its own `resources/`), so it installs cleanly anywhere. For MCP, point any client
that supports remote Streamable HTTP servers with OAuth at `https://mcp.coldiq.com/mcp` — and any MCP
client can also call the `list_skills` / `load_skill` tools to use the playbooks without a native
skills loader.
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

## The skills (17)

**Search / enrich / lists:** coldiq-search-enrich (Lima Data; folder `lima-data-api`), apollo-search,
contact-enrichment, list-dedup, meta-ads-scraper.
**Signals & strategy:** signal-detection, tam-scoring, icp-personas, website-visitors.
**Outreach & infra:** instantly-api, email-infra, emailbison, ad-audiences, campaign-delivery.
**Copy (methodology):** crawford-method, cold-email-copy. **Meetings:** fireflies-usage.

## How endpoints are wired into skills

Three layers, all keyed by a stable endpoint `id` from `catalog.json`:
1. a canonical **registry** (`endpoints/catalog.json`),
2. a per-skill **`## ColdIQ Marketplace Endpoints` table**, and
3. inline **callouts** at each step: `→ **POST** \`/v1/limadata/find/work-email\` · 1 cr · \`limadata.find.work_email\``.

Full spec in [shared/conventions.md](shared/conventions.md).

## Validate

```bash
node scripts/validate.mjs
```

Checks frontmatter, that every cited endpoint id resolves, table↔callout consistency,
callout↔catalog method/path match, no prohibited competitor names in skills, no stray
direct-provider URLs, and prints the
Needs-Verification list (endpoints to confirm against the live API).

## Status

All 17 skills lint clean. Endpoint paths/credits/auth are **best-effort from a pasted admin
catalog and unverified** — confirm against the live API before production. See the
"Needs Verification" section of [endpoints/catalog.md](endpoints/catalog.md).
