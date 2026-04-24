---
name: rfc-writer
description: >-
  Draft and facilitate Request for Comments documents for non-trivial technical
  changes with multiple viable options, cross-team impact, or meaningful risk.
  Use to compare alternatives against ranked decision criteria and produce a
  recommendation before commitment. Enforce deterministic pre-RFC gates: invoke
  brainstorming when framing is unclear, and invoke deep-research when
  cross-team or external-impact decisions lack sufficient evidence. Do not
  record final authoritative decision status here; hand off accepted outcomes
  to adr-recorder.
---

# RFC Writer

## Overview

Use this skill to turn ambiguous architectural proposals into structured,
decision-ready RFCs. Ensure the recommendation is evidence-based and linked to
explicit priorities.

## Routing Contract

- Primary role: produce clear, reviewable RFCs and recommendation outcomes.
- Trigger when change is non-trivial, has multiple paths, or affects multiple
  teams/services.
- Must run deterministic pre-RFC gates when required:
  - Ambiguity gate -> `brainstorming`
  - Evidence gate -> `deep-research`
- Do not set authoritative final architecture status; accepted decisions must be
  recorded by `adr-recorder`.

## Deterministic Gates

### Gate 1: Ambiguity Gate (Mandatory)

Invoke `brainstorming` before drafting RFC when any of the following is true:

- Problem statement is unclear or disputed.
- Constraints and success criteria are incomplete.
- Option set is not explicit.

### Gate 2: Evidence Gate (Conditional Mandatory)

Invoke `deep-research` before drafting RFC when both conditions are true:

- Decision has cross-team or external impact (vendor/platform selection,
  compliance, reliability, security, cost posture, or major operational model).
- Evidence is insufficient to defend ranked decision criteria and trade-offs.

Skip this gate only if strong evidence already exists and is cited.

## When To Use

- Multiple credible solutions exist and trade-offs are not obvious.
- The change has architectural, security, compliance, or operational impact.
- The work crosses team boundaries or introduces new dependencies.
- Stakeholders need written review before implementation.

## When Not To Use

- Small local change with no meaningful alternatives and no cross-team impact.
- Bug fix where root cause and remediation are already clear.
- Decision is already approved and only needs durable recording (use
  `adr-recorder`).

## RFC Required Fields

Every RFC must include:

- `Status`: `proposed` | `in-review` | `accepted` | `rejected` | `withdrawn`
- `Owner`: accountable author (single DRI)
- `Approver`: person/group accountable for decision call
- `Context`: problem framing and current-state constraints
- `Goals` and `Non-Goals`
- `Decision Criteria (ranked)`: explicit priorities before option analysis
- `Options`: realistic alternatives only
- `Recommendation`: selected option with rationale tied to ranked criteria
- `Rollout Plan`: incremental path, checkpoints, rollback notes
- `Risks`: key failure modes and mitigations
- `Decision Deadline`: clear date for resolution

## Required Upstream Artifacts Before RFC Drafting

From `brainstorming` (when ambiguity gate fires):

- Clear problem statement
- Constraints and success criteria
- Candidate option set and non-goals

From `deep-research` (when evidence gate fires):

- Source-backed evidence summary
- Explicit source list/links
- Trade-off data points tied to ranked criteria
- Open risks and unknowns

## Workflow

1. Classify request complexity and impact.
2. Run ambiguity gate; invoke `brainstorming` if required.
3. Run evidence gate; invoke `deep-research` if required.
4. Collect required upstream artifacts.
5. Draft RFC from `references/rfc-template.md`.
6. Validate criteria ranking before option comparison.
7. Run async review; resolve comments or document rationale for non-adoption.
8. Run decision meeting if needed and record outcome.
9. If outcome is `accepted`, create handoff package for `adr-recorder`.

## Finalization Gate

Treat output as recommendation unless all are present:

- Decision owner
- Approver
- Decision deadline
- Comment resolution summary
- Explicit outcome status
- ADR link placeholder for accepted decisions

If any item is missing, keep status as `proposed` or `in-review`.

## Handoff Contract

- `brainstorming` or `planner` -> `rfc-writer` when options are open.
- `rfc-writer` -> `brainstorming` when framing is unclear.
- `rfc-writer` -> `deep-research` when evidence is insufficient for cross-team
  or external-impact decisions.
- `rfc-writer` -> `adr-recorder` when decision is approved.
- `adr-recorder` -> implementation planning after ADR is recorded.

## References

- `references/rfc-template.md`
- `references/review-checklist.md`
- `references/orchestration-gates.md`

## Usage Patterns

Prompt: "We need to replace our queueing system and there are 3 options with
different cost and latency trade-offs."
Expected behavior: produce an RFC with ranked criteria and recommendation, then
prepare ADR handoff details if accepted.

Prompt: "Should we move from monolith auth to shared SSO service across teams?"
Expected behavior: require explicit non-goals, rollout, and risk controls before
any acceptance status.

Prompt: "Choose between managed queue vendors for 5 teams and justify security
and reliability trade-offs."
Expected behavior: trigger deep-research evidence gate before final RFC
recommendation.
