---
name: goal-griller
description: "Manual interview that turns vague engineering work into a bounded, verifiable execution goal with clear scope, validation, done, and pause conditions."
disable-model-invocation: true
---

# Goal Griller

Use this when the user wants a vague task converted into a goal that an agent can execute safely and verify. The skill is execution-tool agnostic; it does not depend on `/goal`, `set_goal`, or a specific runtime.

## Goal Contract

Resolve these fields before finalizing the goal:

1. **Outcome** — what must be true at the end.
2. **Success condition** — objective proof that the outcome is true.
3. **Scope boundary** — what may change and what must not change.
4. **Context to read first** — repositories, files, issues, logs, docs, or commands.
5. **Validation loop** — cheap checks during work and final proof.
6. **Pause conditions** — cases where the agent must ask instead of improvising.

Inspect discoverable repository context instead of asking the user for facts the code can answer. Ask one high-leverage question at a time only while a required field is genuinely ambiguous.

## Output

```text
Goal:
[one concrete outcome]

Read first:
- ...

Constraints:
- ...

Validation:
- During work: ...
- Final proof: ...

Done when:
- ...

Pause when:
- ...
```

Prefer three sharp constraints over a long generic checklist. Do not silently start execution when the user asked only for the goal definition.
