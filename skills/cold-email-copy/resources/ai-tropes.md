# Machine-Writing Tells and Mechanical Checks

Copy that a prospect identifies as machine-written loses trust. The tells are predictable enough to
check. One instance can be acceptable. Several tells in one email, or one repeated across a
sequence, require revision.

## The tells, worst first

### Lists of three

This is the most common tell. Three parallel items often exist for rhythm, and the third item adds
little meaning. Use two items, four items, or a direct sentence. A real enumeration from an approved
product description is different.

### Mirrored contrast

Reject forms such as `it is not X, it is Y`, `less about X and more about Y`, and `X is a Y problem
before it is a Z problem`. Rewrite the point as plain sentences.

### Self-answered questions

Ask nothing that the email answers itself.

### Fragments as punchlines

Reject short dramatic fragments that have no subject or complete verb. Write the complete thought.

### Announcing the point

Remove sentence openings such as `That means`, `Which means`, and `So` when the rest of the sentence
already makes the point.

### Abstract nouns that hide the actor

Replace phrases such as `carry the burden` with the real action. Name who does what.

### Speculation dressed as insight

Reject `likely showed you`, `no doubt`, and similar guesses. If the evidence does not prove it, do
not say it about the reader.

### Filler transitions

Reject phrases such as `it is worth noting`, `here is the thing`, `let us break this down`, `imagine
a world where`, and `in conclusion`.

### Inflated verbs

Replace `serves as`, `stands as`, and `represents` with a plain verb when the meaning allows it.

### Vocabulary tells

Check words such as `delve`, `leverage`, `robust`, `streamline`, `landscape`, `tapestry`, `journey`,
`unlock`, `empower`, `seamless`, `holistic`, `granular`, `ecosystem`, `optimize`, and `game-changing`.
Use the direct word that fits the fact.

### Flattery

Reject generic phrases such as `impressive`, `caught my eye`, and unsupported praise. They do not
prove that the sender understands the reader.

### Punctuation and locale

Reject the U+2014 em dash and rhetorical semicolons. Use the spelling requested for the audience.
Do not let the prompt use one locale while it asks the model to produce another.

## Audit the prompt

A model copies the prompt's patterns. Check the prompt for every rule that the output must follow.
A banned word or wrong-locale spelling in the prompt can appear in many generated lines.

## Generate, check, and regenerate

Use this loop for generated lines:

1. Generate the line.
2. Run the checks below.
3. If it fails, regenerate with the failure reasons and rejected line.
4. Try two or three times.
5. Ship only a line that passes.

Do not hand-fix meaning errors in generated rows. A high failure rate means that the prompt or input
is wrong. Deterministic edits, such as removing a filler prefix or normalizing spelling, can be
applied directly when they do not change meaning.

## Reference checks

```python
import re

BANNED = re.compile(
    r"\b(delve|leverage|robust|streamline|landscape|tapestry|journey|unlock|"
    r"empower|seamless|holistic|granular|ecosystem|optimize|game-changing|"
    r"impressive|caught my eye|it is worth noting|here is the thing|"
    r"serves as|stands as)\b",
    re.I,
)

RULE_OF_THREE = re.compile(
    r"\b(\w[\w ]{1,24}), (\w[\w ]{1,24}), and (\w[\w ]{1,24})\b"
)
NO_NO_NO = re.compile(
    r"\bno [\w ]{2,20}, no [\w ]{2,20}, (and )?no \b",
    re.I,
)
SPECULATION = re.compile(
    r"\b(likely|probably|presumably|no doubt|I imagine)\b",
    re.I,
)
ANNOUNCE = re.compile(r"(?<=[.]) ?(That|Which) means\b")

def is_fragment(sentence):
    return bool(re.match(r"^[A-Z]\w+ing\b", sentence)) and not re.search(
        r"\b(is|are|was|were|has|have|had|will|would|can|could|does|do)\b",
        sentence,
        re.I,
    )
```

Also check the word limit, sentence limit, question marks, punctuation, and required locale.

## The test that catches what patterns cannot

Replace the recipient and company with a stranger. If the line remains true, it is not personalized.
Reject it even when every mechanical check passes.
