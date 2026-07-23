# Skill conventions

Every skill in this package follows the same shape so that (a) an AI agent can decide
when to activate it, (b) it can find the right ColdIQ marketplace endpoint for each task,
and (c) the validator can prove the endpoint references are correct.

## 1. File layout

```
skills/<skill-name>/SKILL.md          # the skill (required)
skills/<skill-name>/resources/*.md    # optional deep references loaded on demand
```

Folder names mirror their original skill names for recognizability, even when the frontmatter
`name` differs (e.g. folder `lima-data-api/` → `name: coldiq-search-enrich`).

## 2. Frontmatter (YAML)

```yaml
---
name: coldiq-search-enrich        # kebab-case, unique
description: >
  One paragraph. What the skill does + extensive POSITIVE triggers ("Use when…",
  "Triggers on …") AND a NEGATIVE clause ("Do NOT use for … (see other-skill)").
  This is the ONLY text an agent reads to decide activation — make the triggers rich.
---
```

Rules: `name` kebab-case; `description` must contain a `Do NOT use` clause. No other keys.
**Endpoints never go in frontmatter** — they live in the body (see §4).

## 3. Body structure

```
# Title  (human title; may note "(formerly X)")
1-2 line overview.

## ColdIQ Marketplace Endpoints      ← the task→endpoint map (actionable skills only)
## When to Use
## <core sections>                    ← workflow / framework / templates, with inline callouts
## Tips / Gotchas
```

## 4. The three-layer endpoint scheme

The single source of truth is `endpoints/catalog.json`. Each endpoint has a stable `id`
(`group.action[.qualifier]`). Skills reference endpoints in two places, both keyed by that id:

**A. The per-skill table** — a `## ColdIQ Marketplace Endpoints` section near the top:

```markdown
## ColdIQ Marketplace Endpoints

| Task | Method | Path | Credits | Endpoint ID | Notes |
|------|--------|------|---------|-------------|-------|
| Find work email from LinkedIn | POST | `/v1/limadata/find/work-email-linkedin` | 3 | `limadata.find.work_email_linkedin` | Free if not found |
```

**B. Inline callouts** — at the exact step where the agent acts, in this FIXED grammar:

```markdown
3. Find the work email for the contact.
   → **POST** `/v1/limadata/find/work-email-linkedin` · 3 cr · `limadata.find.work_email_linkedin`
```

Grammar: `→ **<METHOD>** \`<path>\` · <credits> cr · \`<endpoint.id>\``
- `<METHOD>` ∈ GET, POST, PATCH, PUT, DELETE
- `<path>` starts with `/v1/` or `/dashboard/` and must equal the catalog entry's path
- the last back-ticked token on the line is the `endpoint.id` and must exist in the catalog
- every inline callout id must also appear in the skill's table (the validator enforces this)

If an endpoint is `verified:false` in the catalog (most are, pending live confirmation),
append `(unverified)` to the callout, e.g. `… · `signalbase.funding_signals` (unverified)`.

## 5. Substitutions & base-URL swaps

A workflow might otherwise call providers directly (Apollo, Instantly, Lima Data, Linkup,
Findymail, a local scraper, etc.). This package re-routes every actionable call to the ColdIQ
marketplace instead.

Resolution precedence (full rules in [../CONTRIBUTING.md](../CONTRIBUTING.md)):
1. Lima Data `/v1/limadata/*` if it covers the capability
2. `/v1/ai-ark/*` for large-database people/company search
3. the matching resold `/v1/<provider>/*` if ColdIQ resells that exact provider
4. closest-capability substitution otherwise

Any non-1:1 swap MUST be called out in the skill as a blockquote:

```markdown
> Substitution: this capability maps to Lima Data `/v1/limadata/*` through ColdIQ instead of a direct provider
> call. Behaviour is equivalent; credit costs unverified.
```

Direct-provider URLs are allowed ONLY inside such `>` blockquotes (the validator flags any
direct URL on a normal line).

## 6. Validate

Run `node scripts/validate.mjs` after editing any skill. Exit 0 = clean.
It checks frontmatter, that every cited id resolves, table⊇callouts, callout↔catalog
method/path match, no stray direct URLs, link integrity, and prints the Needs-Verification list.
