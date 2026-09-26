# Karpathy Guidelines Examples

Adapted from:

- <https://github.com/forrestchang/andrej-karpathy-skills/blob/main/EXAMPLES.md>

## 1) Think Before Coding

### Hidden assumptions

User request: "Add a feature to export user data."

Wrong pattern:

- Assume export format, fields, file location, and scope without asking.

Better pattern:

- Clarify scope (all users vs subset), output mode (download/API/job), allowed
  fields, and expected data volume before coding.

### Multiple interpretations

User request: "Make search faster."

Wrong pattern:

- Pick one interpretation silently and implement broad changes.

Better pattern:

- Present plausible interpretations (latency, throughput, perceived speed),
  offer tradeoffs, and confirm target metric before implementation.

## 2) Simplicity First

### Over-abstraction

User request: "Add a function to calculate discount."

Wrong pattern:

- Build strategy interfaces and config abstractions for single use.

Better pattern:

- Start with one small function and refactor only when concrete new
  requirements appear.

### Speculative features

User request: "Save user preferences to database."

Wrong pattern:

- Add optional merge/validate/notify/caching behavior not requested.

Better pattern:

- Implement direct persistence only; add extras only when requested by
  requirement.

## 3) Surgical Changes

### Drive-by refactoring

User request: "Fix crash on empty email."

Wrong pattern:

- While fixing bug, rewrite unrelated validation rules/comments/style.

Better pattern:

- Change only the lines needed to handle empty email safely and keep adjacent
  behavior untouched.

### Style drift

User request: "Add logging to upload function."

Wrong pattern:

- Reformat files, add type hints, and rewrite return logic while adding logs.

Better pattern:

- Keep existing style and control flow; add logging with minimal local edits.

## 4) Goal-Driven Execution

### Vague objective

User request: "Fix authentication."

Wrong pattern:

- Start coding without a reproducible failure or success criteria.

Better pattern:

- Define a concrete failure scenario, write a test that reproduces it, fix the
  issue, and verify no regressions.

### Incremental verification

User request: "Add rate limiting."

Wrong pattern:

- Implement full system in one large commit without checkpoints.

Better pattern:

- Deliver in small steps with explicit verification at each step (basic limit,
  middleware scope, shared backend, config), ensuring each step is testable.
