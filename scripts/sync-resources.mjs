#!/usr/bin/env node
/**
 * Sync shared reference docs into each skill's own resources/ folder.
 *
 * Skills must be self-contained so they install correctly across agents
 * (Claude Code, Cursor, Codex, …) via `npx skills` — which bundles only files
 * INSIDE a skill folder and rejects any `../` path. So a skill that needs a
 * shared doc references it as `resources/<file>` and this script copies the
 * canonical copy from shared/ or endpoints/ into that skill's resources/.
 *
 * Canonical sources: shared/*.md and endpoints/*.md (top level).
 * Skill-owned resources (a resources/<file> with no canonical match, e.g.
 * emailbison/resources/analytics.md) are left untouched.
 *
 * Usage:
 *   node scripts/sync-resources.mjs          # write/refresh copies
 *   node scripts/sync-resources.mjs --check  # fail (exit 1) if anything is stale/missing
 *
 * Run this after editing anything in shared/ or endpoints/.
 */
import { readFileSync, writeFileSync, readdirSync, existsSync, mkdirSync, statSync } from 'node:fs';
import { join, dirname, basename, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const SKILLS_DIR = join(ROOT, 'skills');
const CHECK = process.argv.includes('--check');

// Build basename -> absolute path map of canonical docs.
const canonical = new Map();
for (const dir of ['shared', 'endpoints']) {
  const abs = join(ROOT, dir);
  if (!existsSync(abs)) continue;
  for (const name of readdirSync(abs)) {
    if (name.endsWith('.md') && statSync(join(abs, name)).isFile()) {
      canonical.set(name, join(abs, name));
    }
  }
}

const REF_RE = /resources\/([A-Za-z0-9._-]+\.md)/g;
let synced = 0, stale = 0, dangling = 0, skillOwned = 0;

for (const skill of readdirSync(SKILLS_DIR)) {
  const skillMd = join(SKILLS_DIR, skill, 'SKILL.md');
  if (!existsSync(skillMd)) continue;
  const body = readFileSync(skillMd, 'utf8');
  const wanted = new Set([...body.matchAll(REF_RE)].map((m) => m[1]));
  for (const file of wanted) {
    const dest = join(SKILLS_DIR, skill, 'resources', file);
    const src = canonical.get(file);
    if (!src) {
      // Skill-owned resource (no canonical source) — must already exist.
      if (!existsSync(dest)) {
        console.error(`✗ ${skill}: references resources/${file} but it doesn't exist and has no canonical source`);
        dangling++;
      } else {
        skillOwned++;
      }
      continue;
    }
    const want = readFileSync(src, 'utf8');
    const have = existsSync(dest) ? readFileSync(dest, 'utf8') : null;
    if (have === want) continue;
    if (CHECK) {
      console.error(`✗ ${skill}/resources/${file} is ${have === null ? 'missing' : 'out of date'} (canonical: ${src.replace(ROOT + '/', '')})`);
      stale++;
      continue;
    }
    mkdirSync(dirname(dest), { recursive: true });
    writeFileSync(dest, want);
    console.log(`✓ synced ${skill}/resources/${file}`);
    synced++;
  }
}

if (CHECK && (stale || dangling)) {
  console.error(`\n${stale} stale/missing, ${dangling} dangling. Run: node scripts/sync-resources.mjs`);
  process.exit(1);
}
if (dangling) process.exit(1);
console.log(`\nDone. ${synced} synced, ${skillOwned} skill-owned left as-is${CHECK ? ' (check passed)' : ''}.`);
