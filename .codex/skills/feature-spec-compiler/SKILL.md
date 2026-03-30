---
name: feature-spec-compiler
description: "Compile business rules, policies, and feature requests into structured, verifiable specification artifacts like decision tables, workflows, schemas, test cases, and QA checklists. Use when asked to map product features to business logic, define decision or workflow rules, or generate implementable specs for engineering and QA."
---

# Feature Spec Compiler

## Overview

Turn policy and stakeholder intent into structured specs that engineering can
implement and QA can verify. Default to schema-first outputs, explicit unknown
branches, and test cases for every rule.

## Workflow

1. Normalize vocabulary by building a glossary and canonical rule phrasing.
2. Split atomic rules from workflows and classify each rule surface.
3. Select the matching template and define inputs, outputs, and invariants.
4. Generate structured artifacts and tests with schema-constrained outputs.
5. Validate coverage, conflicts, and missing inputs before delivery.
6. Package artifacts with versioning notes and QA checklist.

## Rule Surface Selection

Use these targets when mapping business logic to artifacts.

- Decision logic maps to decision tables and reason codes.
- Workflow logic maps to state machines or BPMN-style flows.
- Data rules map to schemas, invariants, and retention schedules.
- Integration rules map to contracts, mappings, and error models.
- Security rules map to authorization policies and audit events.
- Performance rules map to SLIs, SLOs, and enforcement actions.

## Artifacts To Produce

- Decision contract with input schema, output enum, and precedence rules.
- Rule tables or state transitions with explicit fallbacks.
- Test cases with positive, negative, and boundary scenarios.
- Validation checks for coverage, conflicts, and missing data.
- QA checklist and versioning notes.

## Guardrails

- Never invent policy or constraints. Ask questions when inputs are missing.
- Use deterministic, low-temperature outputs and schema validation.
- Include a manual review or cannot-decide outcome when required.
- Trace rules to sources with identifiers, not rewritten policy text.

## References

Read these references only when needed for the task.

- `references/templates.md` for decision templates and prompt structures.
- `references/qa-checklist.md` for validation and acceptance criteria.

## Usage Patterns

Example prompt: "Turn these business rules into a decision table, JSON schema,
reason codes, and tests." Expected behavior: return a structured decision
contract, a table, and test cases with missing-input questions.

Example prompt: "Generate a BPMN-style workflow spec with guard conditions and
acceptance checks." Expected behavior: return states, transitions, guards, and
QA checks.

Example prompt: "Create a data retention schedule with legal-hold logic and
validation tests." Expected behavior: return a retention table, hold rules, and
conflict tests.
