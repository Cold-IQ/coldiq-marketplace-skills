---
name: cold-email-copy
description: >
  Write and review ColdIQ cold-email sequences, strategy briefs, subject lines, personalized
  opening lines, calls to action, and positive reply copy. Use when writing or rewriting cold
  outbound copy, building a two-step or three-step sequence, turning a strategy into launch-ready
  copy, choosing the right audience register, or building personalized openers at volume. Do NOT
  use for audience sourcing, campaign sending, mailbox operations, open or click tracking, or
  claims that need unverified research.
---

# Cold Email Copy

Write cold email copy the ColdIQ way. Carry the rules held across campaigns and the patterns learned
from the ones that worked and the ones that did not. Use this skill to write a sequence from scratch
or rewrite a draft that is not landing.

Treat approved facts as a closed claim set. Do not turn a capability into an unsupplied benefit,
reduction, improvement, or causal outcome. A possibility label does not make an unsupported product
outcome safe. Treat an offered artifact as closed context too. When the brief supplies only its name,
offer it by that exact name. Do not invent its contents, coverage, usefulness, or effects.

## Strategy first

Copy fails on strategy more often than on craft. Before writing a line, produce a strategy brief and
put it in front of the operator. Run this on every job, including one with a full campaign spec,
because part of its job is to test that spec.

```text
STRATEGY BRIEF / <client> / <campaign>

ICP           Who receives this. Seniority, function, budget authority, what
              their week contains, and how often they get pitched.
TONE          The register, and one sentence that explains the choice.
EDUCATION     Expert / Aware-but-unpriced / Uninformed, plus the evidence.
ANGLE         One sentence. The single reason this person should care now.
REPLY DATA    What has earned replies on this account, with approved evidence.
DEPTH         Per-person openers or segment-level, and the segmenting fact.
SENDER        Which sending identity, and why this reader believes them.
SIGN-OFF      Claims and proof points that need written client approval first.
PUSHBACK      Where research disagrees with the operator, the evidence, and
              what would change in the copy.
```

Hand the brief to the operator and keep working in the same turn. It is a disclosure, not an
approval gate. Stop and ask only when a PUSHBACK item would change the ANGLE itself. Rewrite the
angle as though the pushback were correct. If it still names the same person and the same problem,
proceed and mark the alternative reversible. If it names a different person or problem, stop. That
would be a different campaign.

Four things decide the brief:

1. Load the client context and research the market. Read only the materials placed in scope. Use
   research tools when they are available and allowed. If required research is unavailable, state
   the gap instead of inventing a plausible answer.
2. Decide the register. Use seniority, profession, pitch frequency, budget authority, and language
   needs. Simple language is not the same as casual language. See
   [resources/audience-register.md](resources/audience-register.md).
3. Decide how much the reader already knows. An expert inside the problem needs proof that the
   sender understands the work, not an explanation of the problem. See
   [resources/strategy-brief.md](resources/strategy-brief.md).
4. Know the angle and check it against approved reply evidence. Write one sentence that names a
   person and a problem. If it needs a product clause to make sense, it is a feature, not an angle.

Research even when the operator supplied an ICP and angle. Where evidence contradicts the spec,
state the conflict, cite the evidence, and explain what would change. Write on the operator's read
unless the conflict changes the angle itself.

Once the brief is settled, find the per-person anchor: the real research each opening line will use.
If the answer is nothing, say so before copy is generated. See
[resources/personalized-openers.md](resources/personalized-openers.md).

## The rules

- Write two or three emails.
- Use 75 to 90 words per email by default.
- Keep every sentence under 20 words.
- Keep every subject between three and five words.
- Use one ask per email. Do not stack CTAs.
- Lead with the pain or wedge, never the product or a generic pleasantry.
- Do not use the U+2014 em dash character.
- Never add, suggest, or assume open or click tracking.
- Use simple language for audiences that are not native English speakers or not technical. This
  controls vocabulary and sentence length, not the register.
- Make clarity outrank cleverness. Use no irony, callbacks, wordplay, or observations about the
  reader's career. Name who does what instead of using an abstract noun.
- Show that you know the reader's business. Do not set out to educate an expert about their work.
- Use spintax only when the user, client rules, or selected sending tool requires it. Never nest a
  merge field inside a spintax block. Keep every approved claim sentence byte-stable.
- Remove machine-writing tells before review. Check lists of three, mirrored contrasts,
  self-answered questions, fragments as punchlines, filler transitions, speculation, and banned
  vocabulary. See [resources/ai-tropes.md](resources/ai-tropes.md).

Longer proof-heavy copy can run to 150 words only when the user requests it and every proof point has
a source. Nothing else buys extra words. Use the full reasons and exceptions in
[resources/copy-rules.md](resources/copy-rules.md).

## The per-person opening line

Default to one generated opener per recipient followed by a fixed, client-approved body when the
available evidence and client review capacity support it. The client approves the body once. The
opener is the only moving part, and it never carries a product claim.

Use two sentences and no more than 35 words. State what the person specifically does, then the
problem next to it. Build it from real research about the person, not from a job title alone. With an
expert audience, the second sentence often works better as a diagnostic question about their own
operation.

Judge the anchor before using it. Not every fact earns a personal line, and forcing one is worse than
not having one. Return `usable`, one short reason, and the opener. When `usable` is false, use an
approved segment-level opener and mark the fallback.

Give the model the domain facts for each segment. A model asked to be specific without the facts
will be specific and wrong. Match personalization depth to the client's review capacity. When the
client cannot approve hundreds of unique lines, use one approvable opener per meaningful segment.

See [resources/personalized-openers.md](resources/personalized-openers.md).

## The sequence structure

- Email 1, core context. Give the strategy and the reason to reach out now. Open on the prospect's
  pain or a shift in their world, then the wedge.
- Email 2, the platform. Explain what the product does beyond the first hook and how it changes the
  reader's work. Keep it additive.
- Email 3, the close or route. Make it a truthful last note, offer a useful next step, or ask for the
  correct owner. Do not create false urgency.

Use [resources/sequence-structures.md](resources/sequence-structures.md) for the two-step variant and
worked skeletons. Use [resources/campaign-patterns.md](resources/campaign-patterns.md) for an approved
campaign approach and [resources/exemplars.md](resources/exemplars.md) for fictional composites.

When the recipient is not the decision maker, write to the problem they own. Make the one CTA a
routing ask. When a fact needed for segmentation is unavailable, ask the reader to identify it
instead of making a guess look like personalization.

Choose subjects with [resources/subject-lines.md](resources/subject-lines.md).

## Answering replies

Treat replies as a different genre. Answer the exact question in the first line, add one paragraph
of substance, and offer one next action that matches the prospect's intent. Reply copy has no
sequence word limit and never uses spintax. Never say that material is attached, linked, sent, or
scheduled unless the artifact or approved delivery fact is present in the working context. When it
is missing, return `insufficient_context` and name the blocker outside the prospect-facing draft.
See [resources/reply-copy.md](resources/reply-copy.md).

## Draft and review workflow

Keep one canonical draft throughout the workflow.

1. Create the strategy brief and canonical draft from approved context.
2. Run the mechanical checks in [resources/ai-tropes.md](resources/ai-tropes.md). For generated
   per-row copy, regenerate with the failure reasons. Do not hide a failing prompt with hand edits.
3. Run Prospect clarity with [resources/prospect-reviewer.md](resources/prospect-reviewer.md).
4. Run Client voice and requirements with
   [resources/client-voice-reviewer.md](resources/client-voice-reviewer.md).
5. Run Research and factual support with
   [resources/research-reviewer.md](resources/research-reviewer.md).
6. Run ColdIQ copy standards with
   [resources/coldiq-copy-reviewer.md](resources/coldiq-copy-reviewer.md).
7. Revise in this order: prospect, client, research, ColdIQ standards.
8. Run QC last with [resources/qc-reviewer.md](resources/qc-reviewer.md).
9. If QC fails, make one repair and run one final QC check.
10. If the second QC check fails, return `needs_human_review` with the blockers.

When the host can start subagents, run the four specialist reviewers as independent tasks. Start QC
only after their findings are coordinated and the canonical draft is revised. Include real task IDs
when the host provides them. Retry a failed native reviewer once. If it fails again, return
`incomplete_review` and name the missing review. Report `Review mode: native-subagent-review`.

When the host cannot start subagents, run the same four rubrics as compact labeled passes. Then
revise and run QC. Never claim that separate agents ran. Report `Review mode: single-agent-review`.

Limit each reviewer to five findings. Make each finding one short sentence with a location, issue,
and proposed change. Quote no more than twelve draft words. Do not repeat the draft in reviewer
output. Show the final copy once.

## Deliverable

Return:

1. The strategy brief.
2. The real review mode.
3. Status: `complete`, `insufficient_context`, `incomplete_review`, or `needs_human_review`.
4. A compact review summary for the four reviewers and QC.
5. The final subjects and copy once.
6. A short fact ledger when the copy contains factual claims.
7. Personalization coverage and fallbacks when openers vary by person or segment.

Return Markdown by default. Create a DOCX only when the host supports files and the user asks for it.
For a client-ready document, open with campaign metadata, show the approved copy and variants, list
only questions the client must answer, and remove internal process commentary. Preview every opener
type with its source evidence. Never ask the client to resolve an internal mistake.

Do not expose private campaign evidence. Public output can contain process rules, normative limits,
and newly written fictional examples. It cannot contain measured campaign totals, response rates,
conversion lifts, client identities, client results, launch findings, raw client copy, or facts
derived from one client.
