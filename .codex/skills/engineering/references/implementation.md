# Implementation

Implement the smallest safe change that satisfies the approved requirement.

## Modes

- Single-task
- Test-first
- Parallel — only independent work
- Worker/delegated
- Long-running

## Procedure

1. Read every file expected to change and trace the relevant behavior first.
2. Choose the implementation mode based on dependency/risk, not novelty.
3. Reuse repository patterns and dependencies; preserve compatibility unless change is requested.
4. Make focused edits and keep unrelated working-tree changes intact.
5. Run the narrowest meaningful checks while implementing.
6. Stop once the requested behavior is correct, safe, verified, and complete.

## Guardrails

- Explore broadly. Prove necessity. Implement narrowly.
- Parallelism is not a reason to split tightly coupled work.
- Do not refactor adjacent code opportunistically.
