#!/usr/bin/env node
/**
 * ColdIQ Marketplace Skills — offline validator.
 *
 * Checks (no live API key needed):
 *  1. Every SKILL.md has valid YAML frontmatter (kebab-case `name`, `description`
 *     with both positive triggers and a negative "Do NOT use" clause).
 *  2. Every endpoint id cited in a skill resolves to an entry in endpoints/catalog.json.
 *  3. Inline `→` callouts are consistent with the catalog (method + path match the id)
 *     and every callout id also appears in that skill's "## ColdIQ Marketplace Endpoints" table.
 *  4. No leftover direct-provider URLs outside a `>` blockquote (substitution/historical note).
 *  5. Callout paths start with /v1/ or /dashboard/ and use a valid HTTP method.
 *  6. Internal markdown links to repo files resolve.
 *  7. Reports every cited endpoint whose catalog entry is verified:false (human punch-list).
 *
 * Usage: node scripts/validate.mjs   (exit 0 = clean, 1 = errors)
 */
import { readFileSync, readdirSync, statSync, existsSync } from 'node:fs';
import { join, dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const SKILLS_DIR = join(ROOT, 'skills');
const CATALOG = JSON.parse(readFileSync(join(ROOT, 'endpoints', 'catalog.json'), 'utf8'));

const byId = new Map(CATALOG.endpoints.map((e) => [e.id, e]));
const ID_SHAPE = /^[a-z0-9]+(?:_[a-z0-9]+)*(?:\.[a-z0-9]+(?:_[a-z0-9]+)*)+$/;
const METHODS = new Set(['GET', 'POST', 'PATCH', 'PUT', 'DELETE']);
const DIRECT_URLS = [
  'api.apollo.io', 'api.limadata.com', 'api.instantly.ai', 'up.railway.app',
  'emailbison.com', 'airops-mail.com', 'api.fireflies.ai', 'send.airops-mail.com',
];

const errors = [];
const warnings = [];
const unverifiedCited = new Set();

function walk(dir) {
  const out = [];
  for (const name of readdirSync(dir)) {
    const p = join(dir, name);
    // resources/ holds bundled supporting docs (copies of canonical shared/
    // and endpoints/ files synced by sync-resources.mjs), not skill bodies —
    // they aren't linted for endpoint citations. Validate the canonical sources.
    if (name === 'resources') continue;
    if (statSync(p).isDirectory()) out.push(...walk(p));
    else if (name.endsWith('.md')) out.push(p);
  }
  return out;
}

function rel(p) { return p.replace(ROOT + '/', ''); }

function checkFrontmatter(file, text) {
  if (!text.startsWith('---\n')) { errors.push(`${rel(file)}: missing YAML frontmatter`); return; }
  const end = text.indexOf('\n---', 4);
  if (end === -1) { errors.push(`${rel(file)}: unterminated frontmatter`); return; }
  const fm = text.slice(4, end);
  const name = /(^|\n)name:\s*(\S+)/.exec(fm);
  const desc = /(^|\n)description:\s*([\s\S]+?)(\n[a-z_]+:|$)/.exec(fm);
  if (!name) errors.push(`${rel(file)}: frontmatter missing 'name'`);
  else if (!/^[a-z0-9]+(-[a-z0-9]+)*$/.test(name[2])) errors.push(`${rel(file)}: 'name' not kebab-case: ${name[2]}`);
  if (!desc) errors.push(`${rel(file)}: frontmatter missing 'description'`);
  else {
    const d = desc[2].replace(/\s+/g, ' ').trim(); // folded YAML scalars wrap lines
    if (!/do not use/i.test(d)) warnings.push(`${rel(file)}: description has no "Do NOT use" negative trigger`);
    if (d.length < 40) warnings.push(`${rel(file)}: description very short`);
  }
}

function citedIdsIn(text) {
  // Ignore blockquote lines (> Substitution notes) — they may contain provider domains
  // like `api.limadata.com` that look like an endpoint id but aren't one.
  const ids = new Set();
  const body = text.split('\n').filter((l) => !l.trimStart().startsWith('>')).join('\n');
  for (const m of body.matchAll(/`([a-z0-9_.]+)`/g)) if (ID_SHAPE.test(m[1])) ids.add(m[1]);
  return ids;
}

function tableIdsIn(text) {
  // ids cited inside the "## ColdIQ Marketplace Endpoints" section table
  const ids = new Set();
  const sec = /##\s+ColdIQ Marketplace Endpoints[\s\S]*?(\n##\s|$)/.exec(text);
  if (!sec) return ids;
  for (const m of sec[0].matchAll(/`([a-z0-9_.]+)`/g)) if (ID_SHAPE.test(m[1])) ids.add(m[1]);
  return ids;
}

function checkCallouts(file, text, hasTable, tableIds) {
  const lines = text.split('\n');
  for (const line of lines) {
    if (!line.includes('→')) continue;
    const mm = /→\s*\*\*([A-Z]+)\*\*\s*`([^`]+)`/.exec(line);
    if (!mm) continue; // not a strict callout
    const [, method, path] = mm;
    const idMatch = [...line.matchAll(/`([a-z0-9_.]+)`/g)].map((x) => x[1]).filter((x) => ID_SHAPE.test(x));
    const id = idMatch[idMatch.length - 1];
    if (!METHODS.has(method)) errors.push(`${rel(file)}: invalid method in callout: ${method}`);
    if (!path.startsWith('/v1/') && !path.startsWith('/dashboard/'))
      errors.push(`${rel(file)}: callout path must start /v1/ or /dashboard/: ${path}`);
    if (!id) { errors.push(`${rel(file)}: callout has no endpoint id: ${line.trim()}`); continue; }
    const entry = byId.get(id);
    if (!entry) { errors.push(`${rel(file)}: callout id not in catalog: ${id}`); continue; }
    if (entry.method !== method || entry.path !== path)
      errors.push(`${rel(file)}: callout ${method} ${path} ≠ catalog (${entry.method} ${entry.path}) for ${id}`);
    if (hasTable && !tableIds.has(id))
      errors.push(`${rel(file)}: callout id '${id}' not present in the skill's endpoints table`);
  }
}

function checkDirectUrls(file, text) {
  text.split('\n').forEach((line, i) => {
    if (line.trimStart().startsWith('>')) return; // substitution / historical blockquote
    for (const u of DIRECT_URLS)
      if (line.includes(u)) errors.push(`${rel(file)}:${i + 1}: leftover direct-provider URL '${u}' (move into a > Substitution note or re-route)`);
  });
}

function checkLinks(file, text) {
  for (const m of text.matchAll(/\]\((\.{1,2}\/[^)\s]+|[a-zA-Z0-9_\-/]+\.(?:md|json|mjs))\)/g)) {
    const target = m[1].split('#')[0];
    if (/^https?:/.test(target)) continue;
    const abs = resolve(dirname(file), target);
    if (!existsSync(abs)) warnings.push(`${rel(file)}: broken internal link → ${target}`);
  }
}

const files = existsSync(SKILLS_DIR) ? walk(SKILLS_DIR) : [];
let skillCount = 0;
for (const file of files) {
  const text = readFileSync(file, 'utf8');
  if (file.endsWith('SKILL.md')) { skillCount++; checkFrontmatter(file, text); }
  const tableIds = tableIdsIn(text);
  const hasTable = tableIds.size > 0;
  for (const id of citedIdsIn(text)) {
    if (!byId.has(id)) errors.push(`${rel(file)}: cited endpoint id not in catalog: \`${id}\``);
    else if (byId.get(id).verified === false) unverifiedCited.add(id);
  }
  checkCallouts(file, text, hasTable, tableIds);
  checkDirectUrls(file, text);
  checkLinks(file, text);
}

console.log(`\nScanned ${files.length} markdown files (${skillCount} SKILL.md) · catalog: ${CATALOG.endpoints.length} endpoints\n`);
if (warnings.length) { console.log(`⚠️  ${warnings.length} warning(s):`); warnings.forEach((w) => console.log('   - ' + w)); console.log(''); }
if (errors.length) { console.log(`❌ ${errors.length} error(s):`); errors.forEach((e) => console.log('   - ' + e)); }
else console.log('✅ No errors.');

if (unverifiedCited.size) {
  console.log(`\n🔎 Needs Verification — ${unverifiedCited.size} cited endpoint(s) are verified:false:`);
  [...unverifiedCited].sort().forEach((id) => {
    const e = byId.get(id);
    console.log(`   - ${id}  (${e.method} ${e.path}, credits: ${e.credits})`);
  });
  console.log('   → confirm auth header, paths, and credit costs against the live API before production use.');
}

process.exit(errors.length ? 1 : 0);
