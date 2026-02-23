---
name: gen-commit
description: Generate a Conventional Commit message from staged git changes and optionally run `git commit` with that message. Use when the user asks to draft a commit message, summarize staged work, or commit already-staged files without adding new files.
---

# Commit Workflow Skill

Use this workflow to create deterministic commit messages for staged changes.

## Command Policy

- Allowed commands:
  - `git status --short`
  - `git diff --staged --name-status`
  - `git diff --staged`
  - `git commit -m ...` (only when the user asks to commit now)
- Never run `git add`.
- Never add attribution lines (for example: "Generated with ...").

## Modes

Use one explicit mode:

1. `message_only` (default): return commit message text only.
2. `commit_now`: return message and run `git commit` using exactly that message.

If user intent is unclear, use `message_only`.

## Steps

1. Check staged state with `git status --short` and `git diff --staged --name-status`.
2. If no staged changes exist, stop and return:
   - `No staged changes found.`
   - `Stage files first, then ask me to generate or commit.`
3. Read `git diff --staged`.
4. Pick a primary commit type.
5. Generate the message with the format rules below.
6. If mode is `commit_now`, run `git commit` using that message.

## Message Format

Use:

```text
<type>(<optional-scope>): <title>

<optional blank line>
<optional bullet list>
```

Rules:

- Keep title lowercase and without trailing period.
- Keep title concise (50 chars max target).
- Use optional body bullets for intent/impact, not file-by-file detail.
- Keep bullets concise and high-level.

## Allowed Types

| Type     | Description                           |
| -------- | ------------------------------------- |
| feat     | New feature                           |
| fix      | Bug fix                               |
| chore    | Maintenance (e.g., tooling, deps)     |
| docs     | Documentation changes                 |
| refactor | Code restructure (no behavior change) |
| test     | Adding or refactoring tests           |
| style    | Code formatting (no logic change)     |
| perf     | Performance improvements              |

## Type Selection Rules

Choose the dominant type by impact:

1. `fix` if bug resolution is primary.
2. `feat` if new user-facing behavior is primary.
3. `refactor` for structural change without behavior change.
4. `docs`, `test`, `perf`, `style`, `chore` when clearly primary.

If changes are mixed, choose one primary type and mention secondary work in bullets.

## Usage Patterns

### Pattern 1: docs updates

Input intent: "Generate commit message for staged README edits."

```text
docs(readme): clarify setup and usage

- explain setup flow for first-time users
- clarify command examples and expected output
```

### Pattern 2: mixed fix and refactor

Input intent: "Write commit message for staged API changes."
Expected behavior:

- Pick `fix` when bug impact is primary.
- Mention refactor as secondary in bullets.

### Pattern 3: no staged files

Input intent: "Commit my changes."
Expected behavior:

- Do not run `git commit`.
- Return deterministic no-staged guidance.
