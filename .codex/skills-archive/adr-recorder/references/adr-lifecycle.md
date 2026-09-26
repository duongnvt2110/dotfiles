# ADR Lifecycle Rules

## Core Rules

- Record one decision per ADR.
- Never rewrite past ADR decisions to change meaning.
- Supersede by creating a new ADR and cross-linking both records.
- Keep ADRs in a central, searchable location.

## Status Guidance

- `accepted`: current decision of record.
- `rejected`: proposal reviewed and declined.
- `superseded`: replaced by a newer ADR.

## Supersession Procedure

1. Create new ADR with updated decision.
2. Set new ADR `Supersedes` to prior ADR ID.
3. Update prior ADR `Superseded-By` with new ADR ID.
4. Retain prior ADR content as historical context.
