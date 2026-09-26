---
name: brainstorming
description: "Manual design exploration for vague or creative engineering work: clarify intent, inspect context, compare approaches, and shape a small design before planning."
disable-model-invocation: true
---

# Brainstorming

Use this when the user explicitly wants to explore an idea before implementation. It is a collaborative design workflow, not a mandatory gate for every change.

## Workflow

1. Inspect the repository, relevant docs, and nearby implementation before asking questions.
2. State the apparent goal, constraints, and unknowns.
3. Ask only the highest-value unresolved question, one at a time when interaction is useful.
4. Compare 2-3 materially different approaches when real alternatives exist. Do not manufacture alternatives for a trivial change.
5. Prefer the smallest design that satisfies the goal and existing repository conventions.
6. Record unresolved risks and how they would be validated.

## Output

Produce only what the task needs:

- problem / desired outcome;
- observed constraints;
- viable approaches and meaningful trade-offs;
- proposed design;
- open questions or proof needed.

If the user asked only to brainstorm, stop at the design. If they also want a plan, continue with `$planner`. Do not force a commit, ADR, RFC, or implementation handoff for a small discussion.

## Principles

- Repository first; do not design from assumptions that the code can answer.
- Explore broadly enough to find the real options, then implement narrowly.
- YAGNI: no extra services, abstractions, or framework changes without a demonstrated need.
- Preserve user choices; recommendations are proposals, not binding architecture decisions.
