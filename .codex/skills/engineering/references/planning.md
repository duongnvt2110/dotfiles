# Planning

Produce implementation-ready plans grounded in the actual repository. Generic planning remains an engineering procedure; `$planner` is the explicit manual workflow when the user wants a dedicated planning pass.

## Modes

- Standard — normal implementation plan
- Deep — larger/high-risk work needing stronger evidence and gotcha review
- Refactor — preserve behavior while changing structure
- Wayfinding — find the real path through an unfamiliar codebase/problem
- Competitive — compare multiple plans only when alternatives materially differ

## Procedure

1. Trace the current code path and relevant repository conventions.
2. Restate scope, constraints, and approved behavior.
3. Identify confirmed implementation gaps and dependencies.
4. Break work into ordered, atomic changes with concrete code areas and verification.
5. Call out risks only when reachable and relevant; do not add speculative architecture.
6. End when another engineer can execute the plan without unresolved design decisions.

## Guardrails

- Approved requirements outrank existing implementation assumptions.
- Do not implement merely because planning discovered adjacent improvements.
