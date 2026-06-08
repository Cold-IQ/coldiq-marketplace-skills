# Credit optimization

ColdIQ marketplace calls cost credits. These rules cut spend without cutting coverage.

1. **Dedup before enriching.** Remove duplicate contacts/companies first so you never pay
   twice for the same record. See [../skills/list-dedup/SKILL.md](../skills/list-dedup/SKILL.md).
2. **Cheapest input first.** For emails: name+domain (`coldiq.find.work_email`, 1 cr) before
   LinkedIn-URL (`coldiq.find.work_email_linkedin`, 3 cr) before personal (`coldiq.find.personal_email`, 5 cr).
3. **Stop on first hit.** Run a waterfall; once a provider returns a value, skip the rest.
4. **Free when not found.** Find endpoints with `free_if_not_found: true` (work/personal email,
   phone) don't charge on a miss — safe to attempt broadly.
5. **Batch over live at scale.** `coldiq.batch.prospect_people` is 1 cr/entity vs 25 cr/page for
   live prospecting — use batch above a few hundred records.
6. **Resolve filters for free first.** `coldiq.references.autocomplete` is free; a misspelled
   title silently returns 0 results and still burns a 25-credit prospect page.
7. **Use BYOK free groups.** instantly / lemlist / attio / unipile are proxied at no credit cost
   when you connect your own account (`/dashboard/connections`).
8. **Cache.** People data ~30 days (job changes), company data ~90 days (firmographics move slowly).
9. **Test on a sample.** Run 50–100 rows, check hit rate, then run the full list.
10. **Watch the meter.** `GET /dashboard/credits` before/after a big job; `GET /dashboard/usage`
    to see where credits went.
