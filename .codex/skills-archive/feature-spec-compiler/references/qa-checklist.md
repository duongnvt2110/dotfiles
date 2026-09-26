# Feature Spec QA Checklist

Use this checklist to validate each spec before delivery.

## Acceptance Checklist

- Inputs and outputs are defined with types and requiredness.
- Every rule has at least one positive and one negative test.
- Decision tables cover all expected outcomes or define a manual review case.
- Workflow transitions include guards and invalid transition handling.
- Schema validation passes and required fields are present.
- Conflicts and overlaps are reported, not silently resolved.
- Observability requirements list required events and identifiers.
- Versioning notes describe compatibility impact.

## Validation Checks

- Coverage check for rule tables and workflows.
- Conflict check for overlapping conditions.
- Missing input check for each rule outcome.
- Deterministic tie-breakers for routing and ranking.
- Idempotency and dedupe logic for integrations and notifications.

## Versioning Guidance

- MAJOR for schema changes or decision semantics changes.
- MINOR for new rules that do not change existing outcomes.
- PATCH for wording improvements or added tests with no logic change.
