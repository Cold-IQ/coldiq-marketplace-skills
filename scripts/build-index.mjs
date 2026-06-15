#!/usr/bin/env node
/**
 * Generate .well-known/agent-skills/index.json — the discovery index for the
 * 18 skills. Two consumers:
 *   1. The ColdIQ MCP server (@coldiq/mcp) fetches it to power list_skills /
 *      load_skill, so loader-less agents (Codex, Windsurf, Cline) get skills
 *      over the MCP they already have installed.
 *   2. The open agent-skills ecosystem (skills.sh / npx skills) can discover us.
 *
 * Each entry: { name (frontmatter), type, description, url (raw SKILL.md),
 * digest (sha256 of SKILL.md) }. `name` may differ from the folder (e.g.
 * folder lima-data-api → name coldiq-search-enrich); `url` always uses the folder.
 *
 * Usage:
 *   node scripts/build-index.mjs           # write the index
 *   node scripts/build-index.mjs --check   # exit 1 if the index is out of date (CI)
 */
import { readFileSync, writeFileSync, readdirSync, existsSync, statSync } from 'node:fs';
import { createHash } from 'node:crypto';
import { join, dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const SKILLS_DIR = join(ROOT, 'skills');
const OUT = join(ROOT, '.well-known', 'agent-skills', 'index.json');
const CHECK = process.argv.includes('--check');
const RAW_BASE = 'https://raw.githubusercontent.com/Cold-IQ/coldiq-marketplace-skills/main';

function frontmatter(text) {
  if (!text.startsWith('---\n')) return null;
  const end = text.indexOf('\n---', 4);
  if (end === -1) return null;
  const fm = text.slice(4, end);
  const name = /(^|\n)name:\s*(\S+)/.exec(fm);
  const desc = /(^|\n)description:\s*([\s\S]+?)(\n[a-z_]+:|$)/.exec(fm);
  return {
    name: name ? name[2] : null,
    // Strip a leading YAML block-scalar indicator (`>`/`|` with optional chomp)
    // before folding, so it doesn't leak into the description.
    description: desc ? desc[2].replace(/^\s*[>|][+-]?\s*/, '').replace(/\s+/g, ' ').trim() : null,
  };
}

const skills = [];
for (const folder of readdirSync(SKILLS_DIR).sort()) {
  const skillMd = join(SKILLS_DIR, folder, 'SKILL.md');
  if (!existsSync(skillMd) || !statSync(skillMd).isFile()) continue;
  const text = readFileSync(skillMd, 'utf8');
  const fm = frontmatter(text);
  if (!fm || !fm.name || !fm.description) {
    console.error(`✗ ${folder}/SKILL.md: missing name/description`);
    process.exit(1);
  }
  const digest = 'sha256:' + createHash('sha256').update(text).digest('hex');
  skills.push({
    name: fm.name,
    type: 'skill-md',
    description: fm.description,
    url: `${RAW_BASE}/skills/${folder}/SKILL.md`,
    digest,
  });
}
skills.sort((a, b) => a.name.localeCompare(b.name));

const index = {
  $schema: 'https://schemas.agentskills.io/discovery/0.2.0/schema.json',
  name: 'coldiq',
  description: 'ColdIQ GTM skills — prospecting, enrichment, signals, copy, campaigns through one API key.',
  skills,
};
const json = JSON.stringify(index, null, 2) + '\n';

if (CHECK) {
  const current = existsSync(OUT) ? readFileSync(OUT, 'utf8') : '';
  if (current !== json) {
    console.error(`✗ ${OUT.replace(ROOT + '/', '')} is out of date. Run: node scripts/build-index.mjs`);
    process.exit(1);
  }
  console.log(`✓ index up to date (${skills.length} skills)`);
} else {
  writeFileSync(OUT, json);
  console.log(`✓ wrote ${OUT.replace(ROOT + '/', '')} (${skills.length} skills)`);
}
