---
name: adr-recorder
description: Record finalized architecture decisions as Architecture Decision Records. Use when a decision is approved and must be captured as the authoritative source of truth with status, date, deciders, rationale, consequences, and supersession links. Use this skill as the only place that marks final architecture decision status.
---

# ADR Recorder

## Overview

Use this skill to create durable, traceable ADRs for accepted or rejected
architecture choices. Preserve history by superseding with new ADRs instead of
rewriting old decisions.

## Routing Contract

- Primary role: record final decision artifacts and lifecycle updates.
- Trigger when decision outcome is already known and needs authoritative storage.
- Do not re-run broad option exploration; route unresolved options to
  `rfc-writer`.

## When To Use

- Final decision has been made and needs durable record.
- Existing ADR must be superseded by a newer decision.
- Team needs decision traceability for audits/onboarding/change review.

## ADR Required Fields

Every ADR must include:

- `Status`: `accepted` | `rejected` | `superseded`
- `Date`
- `Deciders`
- `Context`
- `Decision`
- `Alternatives Considered`
- `Consequences` (positive, negative, neutral)
- `Linked RFC` (or explicit no-RFC rationale)
- `Supersedes` / `Superseded-By` references when applicable

## Authority Rule

- This skill is the single source of truth for final architecture decision
  status.
- One ADR documents one decision only.
- Never rewrite prior ADR meaning; create a new ADR and cross-link lifecycle.

## Workflow

1. Create ADR from `references/adr-template.md`.
2. Verify required fields and links to source RFC/discussion.
3. If replacing old decision, update lifecycle links in both records.
4. Publish ADR and hand back to implementation planning.

## RFC Quality Gate

- If linked RFC lacks required framing or evidence artifacts, route back to
  `rfc-writer` instead of recording final ADR.
- If linked RFC is complete, continue ADR recording as authoritative source.

## Handoff Contract

- `rfc-writer` -> `adr-recorder` after approval.
- `adr-recorder` -> `rfc-writer` when linked RFC evidence quality is
  insufficient.
- `adr-recorder` -> implementation planner after record is finalized.

## References

- `references/adr-template.md`
- `references/adr-lifecycle.md`

## Usage Patterns

Prompt: "The queue migration RFC was approved; write the ADR and mark prior
queue choice as superseded."
Expected behavior: generate one ADR with complete fields and supersession links.

Prompt: "Decision rejected after review; capture rationale and implications."
Expected behavior: create rejected ADR with alternatives and consequence notes.
