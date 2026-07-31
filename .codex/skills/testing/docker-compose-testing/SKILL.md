---
name: docker-compose-testing
description: Create or review tests that must run inside Docker Compose. Use when Codex needs to design, scaffold, or validate unit, integration, contract, smoke, or golden-file tests while keeping execution containerized and reusable.
metadata:
  dependencies: []
---

# Docker Compose Testing

Create and review test workflows that run fully inside Docker Compose and avoid
native runtime dependencies unless the user explicitly asks for them.

## Working Bias

- If the user points at `my_docs/...`, read that file first and treat it as the
  source of truth.
- Prefer repo docs, existing compose files, and current test scripts over
  memory.
- Preserve inferred versus proven status when evidence is incomplete.
- Keep scope tight; do not widen beyond the referenced plan or repo unless the
  user asks.

## Core Rules

1. Run tests inside Docker Compose.
2. Reuse existing containers by default with `--no-recreate`.
3. Wait for health checks before running tests.
4. Reset data logically; destroy containers and volumes only when explicitly
   requested.
5. Prefer deterministic tests over sleep-based timing.
6. Separate unit, integration, contract, smoke, and golden-file coverage.
7. Do not require native Go, DB, Redis, Kafka, Pact, Node, or external CLIs
   unless the repo already depends on them.
8. Keep local and CI paths aligned unless the repo already requires a split.

## Discovery Order

- Start from the exact plan, folder, compose file, or failing command the user
  named.
- Read the repo's compose, test, and validation conventions before proposing a
  workflow.
- If the artifact answers the question, inspect it instead of asking.

## Validation Loop

- First, inspect the target repo's compose files, test scripts, and existing
  checks.
- Then, run the narrowest validation first.
- If scripts or templates were added, verify one representative path and call
  out any untested variants.
- Finish by stating what passed, what was not verified, and the remaining risk.

## Output Shape

When helping the user, give:

1. Recommended test strategy
2. Required Docker Compose services
3. Commands to run
4. Data reset strategy
5. Acceptance criteria
6. Assumptions or gaps

## Canonical Patterns

- Unit tests: pure logic, table-driven, no Compose dependency.
- Integration tests: real DB, cache, or broker inside Compose with reset state.
- Contract tests: Pact consumer/provider flow with deterministic provider
  states.
- Smoke tests: small API-level checks only.
- Golden tests: compare generated outputs and inspect important structure when
  raw binaries are unstable.

## Stop or Pause

Pause if:

- The plan conflicts with repo conventions.
- The needed runtime cannot be inferred from the repo.
- Validation would require changing unrelated code.
- The user has not specified the target repo or compose environment and that
  choice materially affects the skill.

## Avoid

- Native-only instructions.
- Separate CI and local flows when the same Compose path can work for both.
- Sleep-based timing.
- Destroying volumes by default.
- Generic testing advice that is not Compose-specific.
