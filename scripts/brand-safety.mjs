export const PROHIBITED_SKILL_NAMES = [
  ['Clay', /\bclay(?:gent|script)?\b/i],
  ['DeepLine', /\bdeep[\s-]?line\b/i],
  ['Orthogonal', /\borthogonal\b/i],
  ['Unify', /\bunify\b/i],
  ['Swan AI', /\bswan[\s-]*ai\b/i],
  ['Oxygen GTM', /\boxygen[\s-]*gtm\b/i],
];

export function findProhibitedNames(value) {
  return PROHIBITED_SKILL_NAMES
    .filter(([, pattern]) => pattern.test(value))
    .map(([name]) => name);
}
