# Phase 1 Competing Plans Prompt

You will generate a competing plan using the SAME context packet and constraints. Do not add new assumptions. Do not execute.

## Input
- Use the provided context packet exactly as-is.

## Output Format (use these exact headings)

### Plan Summary
- 4 to 7 sentences describing the proposed solution.

### Architecture Overview
- Major components and how they interact.

### Data Model
- Key entities and relationships (high level).

### Milestones
- 3 to 6 milestones in order.

### Risks and Mitigations
- Top risks and how to reduce them.

### Assumptions
- Any assumptions you had to make. If none, say "None". If unknown, label "unknown/unspecified".

### Exit Criteria
- Explicit criteria for moving to Phase 2 task decomposition.

### Delta Summary
- 3 to 6 bullets describing how this plan differs from a baseline plan.

## Guardrails
- Keep inputs identical to other models.
- No execution steps or code changes.
- Flag contradictions or missing constraints.
- Do not add new assumptions; mark unknowns as unknown/unspecified.
