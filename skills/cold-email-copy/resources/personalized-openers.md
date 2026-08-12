# The Per-Person Opening Line

Use one generated opener per recipient followed by a fixed body that the client approved. This gives
the campaign real personalization without putting approved product claims inside a generator.

```text
Hi {{firstName}},

{{opener}}          <- two sentences written for this person

[fixed approved body, identical for the segment]

[one ask]
```

The client approves the body once. The opener is the only moving part, and it never carries a
product claim.

## Contents

- [Define the opener](#define-the-opener)
- [Rank the research anchors](#rank-the-research-anchors)
- [Judge the anchor](#judge-the-anchor)
- [Supply domain facts](#supply-domain-facts)
- [Use current industry context](#use-current-industry-context)
- [Check every generated line](#check-every-generated-line)
- [Match depth to review capacity](#match-depth-to-review-capacity)
- [Show every type before launch](#show-every-type-before-launch)

## Define the opener

The opener has one job: make the first line of the fixed body read as the natural next sentence for
this person.

- Sentence one states the specific, verified thing this person does.
- Sentence two states the problem next to it or asks a diagnostic question about the operation.
- Keep both sentences below 35 words in total.
- Add no greeting, sign-off, or CTA inside the opener.
- Never ask for the person's time in the opener.
- Never ask a question that the email answers itself.

For an expert audience, a diagnostic question can be stronger than a statement. It stops before
explaining the person's own business to them. Pick one shape per segment and keep the previews
consistent.

## Rank the research anchors

An opener is only as good as the fact under it. Rank available anchors:

1. Something the person published about their work that connects to the problem.
2. Something the person did that can be verified, such as speaking, hiring, or leading a relevant
   program.
3. A segment fact that is true of the group, such as the practice area, product line, or function.

The third level is segmentation, not personal research. Label it correctly so nobody reports a
personalization rate that the campaign does not have.

## Judge the anchor

Not every fact earns a personal line. Forcing a connection is worse than using no personal fact.

Have the generator return a judgment with the line:

```json
{"usable": true, "why": "directly connects the role to the problem", "opener": "<two sentences>"}
```

When `usable` is false, write an approved segment-level opener and mark the row as a fallback. Report
the usable and fallback split to the operator without exposing private person data.

Reject an anchor when:

- It matches a keyword but not the campaign problem.
- It requires a guess about the person's priorities.
- The connection needs praise, flattery, or a long explanation.
- The same line would remain true after replacing the person and company with a stranger.
- The source is stale or cannot be verified.

## Supply domain facts

Give the model the actual work for each segment. A model asked to be specific without the facts will
be specific and wrong. That is worse than being general and correct.

For example, do not give every professional group the same work. Supply a small approved map:

```text
Customer success: onboarding, adoption reviews, renewal preparation
Revenue operations: routing, handoffs, data quality
Finance operations: reconciliation, approvals, close preparation
```

Tell the generator to mention only work present in the selected segment. Never let it fill a missing
domain fact from a stereotype.

## Use current industry context

The first sentence is about the person. The second can use an industry change when it is current,
verified, and felt in the recipient's work.

Test whether the recipient can confirm or deny the consequence from their own week. If not, it is
market commentary and does not belong in the opener.

State the event as a fact. Label the operational consequence as an inference unless a source proves
it for the person.

## Check every generated line

Use [ai-tropes.md](ai-tropes.md) for the mechanical checks. Openers often fail because of:

- A list of three used for rhythm.
- `That means` at the start of the second sentence.
- An abstract noun that hides who does the work.
- Speculation about the reader.
- Praise that could apply to anyone.
- A question that asks for time.

Check the merged output, not only the template. A research field can fail on one row and become the
most visible line in the email.

When a generated line fails, regenerate it with the rejected line and failure reasons. Use two or
three attempts. Do not hand-fix repeated failures because the failure rate shows that the prompt or
input is wrong.

## Match depth to review capacity

Before building a generator, ask how the client will approve what ships. A client who must sign off
on outbound cannot review hundreds of unique emails.

When that is the constraint, segment-level openers are the correct answer. Choose the segmenting
fact that carries the most meaning, such as role, practice area, product line, or use case. Write one
approvable opener per segment.

Use per-person openers only when the evidence is strong and the client accepts that approval model.
Settle this before generating the list.

## Show every type before launch

A client cannot approve a placeholder. Show previews grouped by anchor type and segment. Include:

- The opener.
- The verified fact under it.
- The source.
- A fallback example where the anchor was rejected.
- The fixed body that follows it.

Use real recipients only inside the authorized private review. Do not place their identities or
research in public skill output. Showing the rejected anchors helps the client trust the lines that
passed.
