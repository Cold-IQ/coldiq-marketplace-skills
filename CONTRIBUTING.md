# Contributing — how the mapping works

## Adding or editing a skill

1. Create `skills/<name>/SKILL.md` following [shared/conventions.md](shared/conventions.md)
   (YAML frontmatter with kebab-case `name` + a `description` carrying positive triggers and a
   `Do NOT use` clause).
2. Add a `## ColdIQ Marketplace Endpoints` table for any actionable skill.
3. Add inline `→` callouts at each step, keyed by `endpoint.id`.
4. Run `node scripts/validate.mjs` until clean.

## Endpoint resolution rules (Kenny-direct → ColdIQ)

When a source skill calls a provider directly, re-route it by this precedence:

1. **Native first** — if `/v1/coldiq/*` covers the capability, use it (Lima Data
   `/find /enrich /prospect /search /research /watch /batch` → `/v1/coldiq/*`, ~1:1).
2. **ai-ark for big-database search** — large people/company search → `/v1/ai-ark/people|companies`.
3. **Matching resold provider** — if ColdIQ resells the exact provider Kenny used (Apollo,
   Instantly, Prospeo, FullEnrich, Wiza…), use `/v1/<provider>/*`, preserving the path shape.
4. **Closest-capability substitution** — when ColdIQ doesn't resell the provider:
   - Linkup → `/v1/coldiq/find/company-linkedin` + `/find/work-email*`
   - EmailBison / AirOps → `/v1/instantly/*` or `/v1/lemlist/*`
   - Fireflies → no equivalent; stays on Fireflies (MCP)
   - Clay internal waterfall → a sequence of ColdIQ email-finder endpoints
5. **Always flag substitutions** — a `> Substitution:` blockquote in the skill **and** a `replaces`
   entry in `catalog.json`. Never swap silently.

## Editing the endpoint registry

- The raw pasted catalog lives in `endpoints/_raw/catalog-dump.txt` — **never edit it** (provenance).
- Add/normalize entries in `endpoints/catalog.json`. New entry shape: see existing entries
  (`id, group, kind, method, path, summary, credits, free_if_not_found, async, inputs, replaces,
  verified`). Use `"credits": "unknown"` when the dump's cost was garbled; keep `verified: false`
  until confirmed live.
- Regenerate the human view: `node scripts/gen-catalog.mjs` (or re-run the generator in the repo
  history) writes `endpoints/catalog.md` + the Needs-Verification appendix.

## Verifying against the live API (flips `verified:false` → `true`)

1. Confirm the **auth header** (`X-KEY` vs `Authorization: Bearer`) with a free call
   (`GET /dashboard/credits`). Set it in `catalog.json` → `auth`.
2. Smoke-test each endpoint group; correct any wrong path/method/credits.
3. Set `verified: true` on confirmed entries and drop the `(unverified)` tag from skill callouts.

## Conventions

- Folder names mirror GTME OS (recognizability); frontmatter `name` reflects the new reality.
- Endpoints never go in frontmatter.
- Run the linter before every commit.
