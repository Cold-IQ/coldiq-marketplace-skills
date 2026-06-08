import { readFileSync, writeFileSync } from 'node:fs';
const c = JSON.parse(readFileSync('endpoints/catalog.json','utf8'));
const groups = {};
for (const e of c.endpoints) (groups[e.group] ??= []).push(e);
let md = `# Endpoint catalog (human view)\n\n`;
md += `Generated from \`catalog.json\` (v${c.version}). Base URL \`${c.base_url}\`. Auth header \`${c.auth.header}\` (verified: ${c.auth.verified}).\n\n`;
md += `> ${c.credit_note}\n\n`;
md += `**${c.endpoints.length} endpoints across ${Object.keys(groups).length} groups.** This is a curated, GTM-relevant slice of the full ~575-endpoint marketplace — see \`_raw/catalog-dump.txt\` for the complete pasted list.\n\n`;
for (const g of Object.keys(groups).sort()) {
  md += `## ${g}\n\n| Method | Path | Credits | Endpoint ID | Summary |\n|---|---|---|---|---|\n`;
  for (const e of groups[g]) md += `| ${e.method} | \`${e.path}\` | ${e.credits} | \`${e.id}\` | ${e.summary} |\n`;
  md += `\n`;
}
const nv = c.endpoints.filter(e => e.verified === false);
const unk = c.endpoints.filter(e => e.credits === 'unknown');
const flagged = c.endpoints.filter(e => e.flag);
md += `## Needs Verification\n\nEverything below is unconfirmed against the live API. Confirm before production.\n\n`;
md += `- **Auth header** \`${c.auth.header}\` is a guess — see [auth.md](auth.md).\n`;
md += `- **${nv.length} endpoints** are \`verified:false\` (all of them, pending a live smoke test).\n`;
md += `- **${unk.length} endpoints** have \`credits:"unknown"\` (cost unreadable in the dump):\n`;
for (const e of unk) md += `  - \`${e.id}\` — ${e.method} ${e.path}\n`;
if (flagged.length) { md += `- **${flagged.length} flagged entries** (path/source uncertainty):\n`;
  for (const e of flagged) md += `  - \`${e.id}\` — ${e.flag}\n`; }
writeFileSync('endpoints/catalog.md', md);
console.log('wrote endpoints/catalog.md —', c.endpoints.length, 'endpoints,', nv.length, 'unverified,', unk.length, 'unknown-cost,', flagged.length, 'flagged');
