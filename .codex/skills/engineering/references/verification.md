# Verification

Verify the requested outcome, not just the implementation mechanics. Select only the quality dimensions that are reachable and relevant to the change.

## Modes

- Normal closure verification
- PR-feedback verification

## Procedure

1. Re-read the original requirement and approved clarifications.
2. Inspect the final diff for scope and behavioral alignment.
3. Identify which verification dimensions matter for this change:
   - requested behavior and error/failure paths;
   - data integrity and state transitions;
   - concurrency/ordering when shared state is involved;
   - compatibility with callers, persisted data, APIs, or events;
   - security boundaries when permissions/input/trust change;
   - performance when the change can materially affect latency, memory, CPU, or query load;
   - runtime behavior when the result depends on deployed services or external systems.
4. Run targeted tests/checks that exercise those dimensions and the changed behavior.
5. Perform an independent closure check for missed paths, stale assumptions, or regressions.
6. For PR feedback, map each reviewer item to evidence/fix and re-verify only the affected scope.
7. Report passed checks, unverified checks, and remaining risk separately.

## Guardrails

- Tests are evidence; tests are not automatically the requirement.
- A passing broad suite does not replace a missing requirement-specific check.
- Do not run every possible quality check by default; select checks based on reachable risk.
- Do not report adjacent/speculative findings as blockers without proving reachability, relevance, and necessity.
