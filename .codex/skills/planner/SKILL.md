---
name: planner
description: "Manual repository-first planning for features, bugs, and refactors. Produce the smallest execution-ready plan with concrete code paths and checks."
disable-model-invocation: true
---

# Planner

Use this when the user explicitly wants an implementation plan rather than implementation.

## Core Rule

**Explore broadly. Prove necessity. Implement narrowly.**

Repository behavior is the primary planning evidence. Requirements and approved specs define the contract; the repository tells you how that contract can be implemented.

## Workflow

1. Read the relevant repository instructions and user-named requirements.
2. Trace the current end-to-end path before proposing changes.
3. Reuse existing models, layers, patterns, and transaction boundaries where they already satisfy the need.
4. Identify only confirmed gaps between required behavior and reachable implementation.
5. Ask questions only for material ambiguity that cannot be resolved from the repository or provided requirements.
6. Produce the smallest ordered set of implementation tasks needed to close those gaps.
7. Attach a focused validation method to every behavior-changing task.
8. Run a final gotcha pass for stale data, concurrency, failure handling, migrations, compatibility, and deployment only where relevant.

## Plan Shape

For each task include:

- **Goal** — behavior being added/fixed;
- **Code path** — concrete files/functions/layers when known;
- **Change** — smallest sufficient implementation;
- **Why needed** — evidence or requirement proving necessity;
- **Validation** — exact test/check that proves it.

Use phases only when ordering genuinely matters. Do not create sprints, RFCs, ADRs, new abstractions, or architecture work merely to make the plan look comprehensive.

## Boundaries

- For Terraform, WordPress, or frontend work, keep the domain skill primary and use this planning method as supporting procedure.
- Do not implement unless the user separately asks for implementation.
