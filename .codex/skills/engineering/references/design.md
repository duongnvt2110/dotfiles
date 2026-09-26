# Design

Use design mode only when the task contains a meaningful interface, architecture, data-model, or ownership decision.

## Procedure

1. Identify the decision and constraints from repository evidence and approved requirements.
2. List only viable alternatives; keep the current design as an option when appropriate.
3. Compare trade-offs in behavior, complexity, compatibility, operability, and migration cost.
4. Choose the smallest design that satisfies the requirement.
5. Define the changed interfaces/contracts and how the decision will be verified.

## Guardrails

- Do not enter architecture mode for a small local implementation change.
- Prototype only when it reduces a concrete unknown.
