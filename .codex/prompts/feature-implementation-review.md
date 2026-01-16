# feature-implementation-review

Use this prompt to inspect a codebase (mono-repo or service) and report which requested features are implemented versus missing, along with supporting evidence and follow-up actions.

## Workflow

1. Clarify the scope: ask the user for the repository path, services of interest, target branch, and the canonical feature/requirement list (PRD, README checklist, tickets, etc.).
2. Collect references: read the top-level README, docs/, architecture diagrams, service-specific READMEs, and any proto or saga specs that describe intended features.
3. Inventory expected features by turning the requirement sources into a numbered list; note assumptions where requirements are implicit.
4. For each feature, search the repo (prefer `rg`, `ls`, `grep`) for handlers, routes, proto messages, events, or tests that prove the feature exists; skim relevant files (cmd/, pkg/, docs/, proto/) to confirm behavior.
5. Mark a feature as implemented only if there is clear code, documentation, or tests showing end-to-end coverage; capture file paths and short evidence snippets.
6. Mark features as partially implemented if scaffolding exists but functionality, wiring, or tests are missing; describe gaps and the work remaining.
7. Flag features as not implemented when no supporting code/docs are found; suggest likely locations or dependencies needed to build them.
8. Summarize findings in three sections (Implemented, Partial, Missing) and include: evidence paths, confidence level, blockers/tests to run, and any cross-service considerations.
9. Close with recommended next steps (e.g., `go test ./...`, `make up-service`, add docs) so the user can validate or continue implementation.

## Examples:

- "Review ./booking-service against the saga spec in docs/booking.md and list which booking workflow features exist, which are incomplete, and what's missing."
- "Scan the entire repo to confirm which payment fraud detection features described in docs/payment.md are built, partially built, or absent."

## Notes:

- Always restate assumptions about requirements and repository scope before analysis.
- Prefer evidence that includes file paths and line numbers so the user can verify quickly.
- If requirements conflict or are unclear, pause and ask for clarification instead of guessing.
- Mention any tests or commands you could not run so the user knows how to validate locally.
