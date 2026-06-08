# Changelog

## 0.1.0 — 2026-06-08

Initial package.

- Ported the 14 ColdIQ GTME OS skills into the marketplace house format (YAML frontmatter +
  per-skill endpoint table + inline callouts).
- Re-routed all actionable tasks from direct-provider APIs to ColdIQ marketplace endpoints
  (`https://api.coldiq.com/v1/*`).
- Built `endpoints/catalog.json` (134 curated entries across 30 groups) from the pasted admin
  catalog, with `verified:false` and `credits:"unknown"` flags where the source was uncertain.
- Added `scripts/validate.mjs` offline linter; all skills pass.
- **Open items:** auth header unconfirmed; credit costs best-effort; async poll/result shapes and
  every `replaces` mapping need a live smoke test. See `endpoints/catalog.md` → Needs Verification.
