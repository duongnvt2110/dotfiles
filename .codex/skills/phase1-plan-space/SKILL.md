---
name: phase1-plan-space
description: "Specialized Phase 1 plan-space workflow for multi-model plan competition and synthesis-by-diff before implementation."
---

# Phase 1 Plan-Space Workflow

## Overview

Use this skill to run Phase 1 ideation and planning in plan space, producing a vetted plan artifact and a detailed master plan before any execution.

## Routing Contract

- Primary role: explicit Phase 1 ideation competition and synthesis.
- Must trigger only when user requests phase1/plan-space/competing-models/synthesis-by-diff behavior.
- Must not trigger for generic "make a plan" requests; defer those to `planner`.
- Handoff rule: after plan-space output is finalized, hand off to `planner`, `openspec`, or `spec-kit-skill` depending on downstream workflow.

Use this skill when the user explicitly wants Phase 1 plan-space workflow, such as:
- Multi-model competing plans
- Synthesis-by-diff into a single master plan
- Explicit exit criteria before Phase 2 task decomposition
- Agent Flywheel Phase 1 planning

## When Not to Use

Do not use this skill for:
- Implementation or execution steps
- General brainstorming without multi-model plan synthesis
- Deep research orchestration

## Required Inputs

Collect or confirm these inputs, and mark anything missing as “unspecified” instead of guessing:
- Problem statement and target users
- Success criteria and measurable outcomes
- Constraints such as timeline, budget, security, and integrations
- Required deliverable format for the plan

## Canonical Workflow

1. Produce Plan v0 with a primary model.
2. Generate competing plans using the same inputs.
3. Synthesize improvements into Plan v1 using diff-style edits.
4. Optionally run an ideation expansion loop and patch the plan again.
5. Apply an exit gate with explicit completion criteria.

## Deliverables

- Plan v1 (or v2 if ideation loop runs)
- Detailed master plan artifact (default final output)
- Assumptions ledger with validation status
- Risk register with mitigations
- Exit criteria for Phase 2 handoff

## Guardrails

- Stay in plan space only. Do not execute.
- Do not add pricing or time-sensitive model availability details.
- Switch prompt style once execution begins. Do not demand upfront plans during rollouts.

## Templates and Checklist

Use these fully drafted prompts and checklist as needed:
- `templates/intake_prompt.md`
- `templates/competing_models_prompt.md`
- `templates/synthesis_prompt.md` (deep system design, default)
- `templates/ideation_prompt.md`
- `checklists/phase1_exit_checklist.md`

## References

Read `references/phase1.md` for detailed principles, prompt patterns, evaluation rubric, and failure modes.
