---
name: docker-compose-testing
description: "Run tests and smoke checks with a repository's Docker Compose runtime, services, or Compose-provided build dependencies; reuse existing containers instead of starting ad-hoc containers."
---

# Docker Compose Testing

Create and review test workflows that run fully inside Docker Compose and avoid
native runtime dependencies unless the user explicitly asks for them.

## Working Bias

- Prefer repo docs, existing compose files, and current test scripts over
  memory.
- Preserve inferred versus proven status when evidence is incomplete.
- Keep scope tight; do not widen beyond the referenced plan or repo unless the
  user asks.

## Automatic selection

Select this skill when any of these are true:

- the user asks to use Docker, Docker Compose, an existing container, or the
  local Compose stack;
- the repository's documented test/runtime path is Compose-based;
- the test command needs a service, mounted fixture, emulator, database, or
  Compose-provided toolchain dependency;
- the native host run fails because a dependency supplied by the image is
  missing, such as `pkg-config`/`libvips`.

The last case still applies when the test logic is a pure unit test: classify
the test as a unit test in the report, but use Compose for its required build
environment. Do not wait for a failed ad-hoc container run before selecting
this skill when the Compose path is already evident.

## Core Rules

1. Run tests inside Docker Compose when they depend on Compose services or on
   dependencies/tooling supplied by the Compose image. Pure host-independent
   tests do not need Compose merely for consistency.
2. Inspect the repository Compose files and current containers before running
   tests. If the default `docker compose ps` shows no services, locate the
   actual Compose file/project used to start them (for example,
   `docker compose -f build/docker-compose.yml ps`).
3. Reuse an existing matching service by default, preferably
   `docker compose -f <file> exec -T <service> <command>`. Use
   `up -d --no-recreate` only when the required service is not running.
4. Do not use standalone `docker run` when a matching Compose service exists;
   use it only when no Compose path exists or the user explicitly requests it.
5. Wait for health checks before running tests.
6. Reset data logically; destroy containers and volumes only when explicitly
   requested.
7. Prefer deterministic tests over sleep-based timing.
8. Separate unit, integration, contract, smoke, and golden-file coverage.
9. Do not require native Go, DB, Redis, Kafka, Pact, Node, or external CLIs
   unless the repo already depends on them.
10. Keep local and CI paths aligned unless the repo already requires a split.

## Boundary

Use this skill for tests whose execution materially depends on Docker Compose services or lifecycle. Pure unit tests stay with the primary engineering or domain skill and should not be routed through Compose just for consistency.

## Discovery Order

- Start from the exact plan, folder, compose file, or failing command the user
  named.
- Read the repo's compose, test, and validation conventions before proposing a
  workflow.
- Check both service names and container names; the running container may belong
  to a non-default Compose project or Compose file.
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

- Unit tests: pure logic, table-driven, and environment-independent; do not
  force them into Compose merely for consistency.
- Unit tests with image-only build dependencies still run through the existing
  Compose service when that is the repository's available toolchain; report the
  test category separately from the execution environment.
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
