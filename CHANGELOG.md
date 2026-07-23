# Changelog

## Unreleased

- Migrated Lima Data endpoint paths and IDs from `coldiq.*` / `/v1/coldiq/*` to
  `limadata.*` / `/v1/limadata/*`.
- Corrected workplace ratings to `/v1/limadata/company/workplace-ratings` and removed the
  discontinued post-details endpoint.

## 0.2.0 — 2026-06-09

Added 4 non-redundant skills (from analysis of ColdIQ's master-skills — nothing already covered):

- **email-infra** — sending infrastructure (domains/mailboxes/warmup) via Instantly account &
  DFY endpoints (added 11 `instantly` account/warmup/DFY entries to the catalog).
- **ad-audiences** — matched ad audiences + ABM lists + ads↔outbound sync, via
  `coldiq.find.hashed_email` / `identity_resolution`.
- **website-visitors** — enrich & route de-anonymized site visitors (external pixel/IP tool →
  ColdIQ enrichment tail).
- **icp-personas** — ICP definition, ABM account sizing/tiering, buying-committee mapping.

Catalog now 145 endpoints. All 18 skills lint clean.

## 0.1.0 — 2026-06-08

Initial package.

- Ported 14 GTM skills into the marketplace house format (YAML frontmatter + per-skill endpoint
  table + inline callouts).
- Re-routed all actionable tasks from direct-provider APIs to ColdIQ marketplace endpoints
  (`https://api.coldiq.com/v1/*`).
- Built `endpoints/catalog.json` (134 curated entries across 30 groups) from the pasted admin
  catalog, with `verified:false` and `credits:"unknown"` flags where the source was uncertain.
- Added `scripts/validate.mjs` offline linter; all skills pass.
- **Open items:** auth header unconfirmed; credit costs best-effort; async poll/result shapes and
  every `replaces` mapping need a live smoke test. See `endpoints/catalog.md` → Needs Verification.
