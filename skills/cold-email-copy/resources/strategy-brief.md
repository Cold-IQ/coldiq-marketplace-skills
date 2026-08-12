# The Strategy Brief, Before Any Copy Gets Written

Copy fails more often on strategy than on craft. A well-written email aimed at the wrong person, in
the wrong register, and explaining something the reader already knows is worse than a plain email
aimed correctly. Do this work before the first line.

Run the brief when the operator gave you nothing. Run it when the operator gave you a complete
campaign spec. Part of the brief's job is to disagree with the spec where the evidence disagrees.

## Contents

- [The output shape](#the-output-shape)
- [Stop or proceed](#stop-or-proceed)
- [Work out the ICP](#work-out-the-icp)
- [Use the education axis](#use-the-education-axis)
- [Merge the angle, ICP, and tone](#merge-the-angle-icp-and-tone)
- [Research the market](#research-the-market)
- [Resolve competing instructions](#resolve-competing-instructions)
- [Use reply evidence](#use-reply-evidence)

## The output shape

Fill all nine fields and put them in front of the operator before writing copy.

```text
STRATEGY BRIEF / <client> / <campaign>

ICP           Who receives this. Seniority, function, budget authority, what
              their week contains, and how often they get pitched.
TONE          The register and one sentence that explains the choice.
EDUCATION     Expert / Aware-but-unpriced / Uninformed. Add the evidence.
              Split this by sub-problem when the reader has different levels
              of knowledge. State which level controls the sequence.
ANGLE         One sentence. The single reason this person should care now.
REPLY DATA    What has earned replies on this account, with approved evidence.
              "No history" is valid and changes how you write.
DEPTH         Per-person openers or segment-level, and the segmenting fact.
              Base this on the evidence and what the client can review.
SENDER        Which sending identity, and why this reader believes them.
SIGN-OFF      Claims, quotes, and proof that need written client approval.
              Empty is fine. Guessing is not.
PUSHBACK      Where research disagrees with the operator, the evidence, and
              what would change in the copy. Do not manufacture dissent.
```

Keep the brief short. Keep it as a working note. Do not put it into the client-facing deliverable
unless the user asks for it.

## Stop or proceed

Write the brief, show it to the operator, and keep going in the same turn. The brief is a disclosure,
not an approval gate. Waiting for a reply on every job makes small rewrites too slow.

Stop and ask when a PUSHBACK item would change the ANGLE. Test this mechanically. Rewrite the angle
as though the pushback were correct.

- If the angle still names the same person and the same problem, proceed. State the conflict, write
  on the operator's read, and mark the alternative reversible.
- If the angle names a different person or a different problem, stop. You are about to write a
  different campaign.

When you proceed past a conflict, say so in one line above the working copy. Do not let the operator
discover the conflict by reading a live campaign.

## Work out the ICP

The title on the list is the start, not the end. Establish:

- Who they are. Use the function and seniority terms their company uses.
- What their week contains. Name the recurring work that the pitch touches.
- Whether they control the budget. Do not write to a non-buyer as though they can buy. Write to what
  they own and make routing easy.
- How often they get pitched. A heavily pitched senior reader has less tolerance for unearned
  warmth.
- What their profession treats as credible. Senior specialists tend to trust specificity and
  evidence. Operators want to know what changes in their work.

Record the answer in TONE. Do not keep changing the register after drafting begins unless new
evidence requires it. See [audience-register.md](audience-register.md).

## Use the education axis

Decide how much the reader already knows about the problem.

### Expert in the problem

The reader lives inside the problem. They have opinions about it and may have tried to fix it.

Do not explain the problem to them. Do not open with an industry statistic they already know or may
distrust. Show that you understand the mechanics of their work. Name the gap and let the reader
supply its significance.

A diagnostic question can work well here. It asks about an operation that only the reader can
measure. It proves that the sender understands the work without pretending to know the answer.

Typical readers include senior specialists, heads of function, and experienced operators inside
their own domain.

### Aware but has not priced it

The reader recognizes the symptom but has not measured its cost or does not know that a fix exists.

Name the symptom in the words they use, then quantify it only with approved evidence. A number can
help because it adds information instead of teaching the reader their own profession.

### Uninformed

The problem is new, normalized, or outside the reader's daily work.

This is the only position where education belongs. Put most education in email two. Email one must
still earn attention with something the reader recognizes.

### The test

Ask whether the reader could have written the first sentence themselves.

If yes, the sentence can sound like it comes from their world. If the reader would have written it
better, the copy is teaching an expert. Cut it and go one level deeper into the work.

## Merge the angle, ICP, and tone

These are separate decisions, and they fail in different ways.

- The angle decides whether the message says something worth reading.
- The ICP decides whether this reader cares about it.
- The tone decides whether the reader gets far enough to find out.

An angle can be true and important to the company but irrelevant to the person on the list. Sort
candidate angles by whose problem each one names. Prefer the angle that names the recipient's work,
not a broad company benefit they do not own.

Write the angle as one sentence that names a person and a problem. If the sentence needs a clause
about the product to make sense, it is a feature, not an angle.

## Research the market

Research every client when the tools and scope allow it, even when the operator supplied a brief.
Understand:

- The market and recent changes that affect the reader's work.
- Who the client sells to and who controls the problem.
- The client's competitors.
- Where the client is strong and weak.
- Where the client wins or loses.
- The unique value proposition supported by evidence.

Use sources in this order:

1. Client materials and call transcripts supplied for the task.
2. Approved account research, briefs, and battlecards.
3. Current public research for trends and recent news.

Record what came from where. Every factual claim in the final copy needs a source. If research tools
or required materials are unavailable, say so and return `insufficient_context` for any claim that
depends on them. Do not promise that research was done when it was not.

Only use a trend that the recipient can feel in their work. Broad market commentary does not earn a
place. Test whether the recipient can confirm or deny the consequence from their own week.

## Resolve competing instructions

Read the account rules and supplied client instructions before writing. Do not assume a fixed local
folder or file name. Use the most specific approved instruction available.

Apply this priority:

1. Approved account rules and claim restrictions.
2. The current campaign brief and client instructions.
3. Approved product facts and proof.
4. The craft defaults in this skill.

Account rules about facts, claims, naming, and approval beat house defaults. Craft rules can beat an
old planning document when the old document conflicts with a later approved correction. Flag the
conflict in PUSHBACK either way.

Research even when the operator already gave an ICP and angle. Where research contradicts the
operator, state:

1. What the operator said.
2. What the evidence says, with the source.
3. What would change in the copy if the evidence is correct.

Then proceed on the operator's read unless the conflict changes the angle. Be honest about evidence
strength. Account reply data is stronger than a general article. A vendor claim is weak evidence.

## Use reply evidence

Before settling the angle, check what has earned replies on the account when approved data is
available. Judge on positive replies and meetings, not opens or clicks.

Account-level evidence is more relevant than a general pattern because it came from the actual
audience. When the data is thin, say so. Treat the first campaign as a way to learn instead of
presenting a weak pattern as settled truth.

Never expose raw campaign data, client identity, response totals, or private copy in the public
skill output. Convert private evidence into a scoped decision for the current operator.
