import assert from 'node:assert/strict';
import test from 'node:test';

import { findProhibitedNames } from '../scripts/brand-safety.mjs';

test('rejects each prohibited competitor name and common spelling variant', () => {
  const sample = 'Claygent, Deep Line, Orthogonal, Unify, Swan-AI, and Oxygen-GTM';
  assert.equal(findProhibitedNames(sample).length, 6);
});

test('allows the general GTM term', () => {
  assert.deepEqual(findProhibitedNames('Build a GTM workflow for the sales team.'), []);
});
