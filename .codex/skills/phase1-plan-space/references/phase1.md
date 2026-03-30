# Phase 1 Plan-Space Reference

## Purpose

This reference captures the evergreen principles and patterns for Phase 1 ideation and planning. It supports high-quality plan artifacts before execution begins.

## Artifact Types

There are two artifacts produced in Phase 1:

1. Planning workspace artifact: captures the process (intake, Plan v0, competing plans, synthesis diff, assumptions, risks, exit criteria).
2. Master plan artifact: a standalone, detailed blueprint used to align execution and guide Phase 2 task decomposition.

Additional supporting artifacts:
- Decision log and conflict table (what changed, why, what was rejected).
- Assumption ledger with explicit status (validated, plausible, unknown/unspecified).
- Phase 2 handoff packet (plan + diff + decision log + risks + task-ready milestones).

## Planning Principles

- Plan in plan space before coding to prevent expensive architectural mistakes.
- Clarify scope early and keep MVP boundaries explicit.
- Document assumptions instead of guessing missing facts.
- Prefer simple architectures unless complexity is justified.

## Required Inputs

A Phase 1 plan should be based on a structured context packet:
- Problem statement and target users
- Success criteria and measurable outcomes
- Constraints such as timeline, budget, security, and integrations
- Deliverable format expectations

## Recommended Output Structure

A strong plan is structured and stable. Typical sections include:
- Context and problem definition
- Users and workflows
- MVP scope and non-goals
- Architecture overview
- Data model and key entities
- Non-functional requirements
- Milestones and sequencing
- Risks and mitigations
- Open questions
- Assumptions ledger

## Prompt Patterns

- Output contracts and completion criteria. Define exactly what the plan must include.
- Intensity calibration. Ask for careful analysis and verification when needed.
- Scope control. Use expand mode for ideation and narrow mode for MVP focus.
- Self-verification. Ask the model to check assumptions, contradictions, and feasibility.
- Context anchoring. Re-read stable references to prevent drift in long sessions.
- Temporal awareness. Write plans as self-contained artifacts for a future reader.
- Assumption labeling. Do not guess missing facts; mark them as unknown/unspecified.

## Multi-Model Competition and Synthesis

- Use identical inputs across models to isolate differences.
- Compare for missing risks, sequencing gaps, and architectural alternatives.
- Synthesize by applying the best deltas to the baseline plan, not by merging everything.
- Use a diff-style update to keep a clear decision trail.
- Maintain a decision log or conflict table that records choices and rationale.

## Ideation Expansion Loop

If you need breadth:
- Generate about 100 ideas.
- Select the top 10 with rationale.
- Repeat if new directions still emerge.

## Assumption Ledger

Track assumptions with explicit status:
- Validated
- Plausible
- Unknown or unspecified

Do not backfill unknowns. Leave them explicit for Phase 2 resolution.

## Evaluation Rubric

A Phase 1 plan should score well on:
- Clarity
- Feasibility
- Completeness
- Scope discipline
- Risk awareness
- Task readiness

Prefer qualitative scoring unless the project specifies numeric thresholds.

## Exit Criteria

Phase 1 is complete when:
- Scope is defined and bounded
- Architecture is coherent and feasible
- Risks and mitigations are documented
- Assumptions are visible and classified
- Task decomposition for Phase 2 is possible

## Common Failure Modes

- Vague plans that lack actionable detail
- Scope explosion that obscures the MVP
- Hidden assumptions that later break execution
- Weak sequencing that stalls implementation
- Premature coding before plan stability

## Plan-to-Execution Handoff

Once execution begins, switch prompt style. Avoid demanding upfront plans or frequent status updates during tool-driven rollouts, which can cause premature stopping.
