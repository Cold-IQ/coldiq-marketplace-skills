---
name: cold-email-copy
description: >
  Write and review cold email subjects, first lines, value propositions, calls to action,
  two-email or three-email sequences, and positive reply copy. Use when drafting cold email
  copy, reviewing an email sequence, checking client voice, running copy QC, improving subject
  lines, or answering a positive reply. Do NOT use for audience sourcing, campaign sending,
  mailbox operations, open or click tracking, or claims that need unverified research.
---

# Cold Email Copy

Create concise, factual copy around one audience, one problem, one supported outcome, and one next step.
This skill makes no API calls. Research can supply verified facts before drafting, but copy work
must not invent them. Treat approved facts as a closed claim set. Do not turn a capability into an
unsupplied benefit, reduction, improvement, or causal outcome. A possibility label does not make an
unsupported product outcome safe.

Treat an offered artifact as closed context too. When the brief supplies only its name, offer it by
that exact name. Do not invent its contents, coverage, usefulness, or effects.

## Required context

Collect these inputs before drafting:

1. ICP and target segment.
2. Recipient persona and responsibility.
3. Reading level and language needs.
4. Campaign angle and desired outcome.
5. Client voice, banned phrases, and other instructions.
6. Verified facts with a source for each factual claim.

Return `insufficient_context` when required client instructions or factual evidence is missing.
Do not fill gaps with plausible claims.

## Copy contract

- Write two or three emails.
- Use 75 to 90 words per email by default.
- Use longer proof-heavy copy only when the user requests it and every proof point has a source.
- Keep each sentence under 20 words.
- Keep each subject line between three and five words.
- Use one CTA per email.
- Do not use the U+2014 em dash character.
- Do not suggest open tracking or click tracking.
- Use simple language for non-native or non-technical readers.
- Treat replies as a separate format. Reply copy has no sequence word limit and no spintax.
- Return Markdown by default. Create a DOCX only when the host supports files and the user asks for it.

Use the detailed craft rules in [resources/copy-rules.md](resources/copy-rules.md), the approved
campaign approaches in [resources/campaign-patterns.md](resources/campaign-patterns.md), and the
new fictional composites in [resources/exemplars.md](resources/exemplars.md). Select a sequence from
[resources/sequence-structures.md](resources/sequence-structures.md), then select subjects with
[resources/subject-lines.md](resources/subject-lines.md). For a response to an interested prospect,
use [resources/reply-copy.md](resources/reply-copy.md) instead of the sequence contract.

## Draft and review workflow

Keep one canonical draft throughout the workflow.

1. Create the canonical draft from the approved context.
2. Run Prospect clarity with [resources/prospect-reviewer.md](resources/prospect-reviewer.md).
3. Run Client voice and requirements with [resources/client-voice-reviewer.md](resources/client-voice-reviewer.md).
4. Run Research and factual support with [resources/research-reviewer.md](resources/research-reviewer.md).
5. Run ColdIQ copy standards with [resources/coldiq-copy-reviewer.md](resources/coldiq-copy-reviewer.md).
6. Revise in this order: prospect, client, research, ColdIQ standards.
7. Run QC last with [resources/qc-reviewer.md](resources/qc-reviewer.md).
8. If QC fails, make one repair and run one final QC check.
9. If the second QC check fails, return `needs_human_review` with the blockers.

### Native host mode

When the host can start subagents, start the four specialist reviewers as independent tasks.
Start QC only after their findings are coordinated and the canonical draft is revised. Include real
task IDs when the host provides them. Retry a failed native reviewer once. If it fails again, return
`incomplete_review` and name the missing review. Do not claim a review completed without evidence.

Report `Review mode: native-subagent-review`.

### ColdIQ Chat and single-agent mode

When the host cannot start subagents, run the same four rubrics as labeled review passes inside one
model response. Then revise and run the labeled QC pass. Never claim that separate agents or native
subagents ran.

Report `Review mode: single-agent-review`.

## Compact review rule

- Keep one canonical draft.
- Do not repeat the draft inside reviewer findings.
- Limit each reviewer to five findings.
- Make each finding one short sentence with a location, issue, and proposed change.
- Quote no more than twelve draft words in one finding.
- After coordination, return only the revised copy.
- Let QC return checks and blockers without copying the draft.
- Show the final copy once.

## Output

Return:

1. Review mode.
2. Status: `complete`, `insufficient_context`, `incomplete_review`, or `needs_human_review`.
3. A compact review summary for the four reviewers and QC.
4. The final subjects and copy once.
5. A short fact ledger when the copy contains factual claims.

Do not expose private campaign evidence. Public output can contain process rules, normative limits,
and newly written fictional composite examples. It cannot contain measured campaign totals,
response rates, conversion lifts, client identities, client results, launch findings, raw client
copy, or facts derived from one client.
