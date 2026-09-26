# Git

Use development Git workflows without creating a separate lifecycle router.

## Modes

- Commit
- PR description
- Conflict resolution
- Guardrails
- Pre-commit verification

## Procedure

1. Inspect status/diff before acting so user changes are preserved.
2. For commits, describe the actual diff and keep commits scoped.
3. For PR descriptions, summarize behavior, tests, risks, and relevant context from the branch diff.
4. For conflicts, understand both sides before resolving and verify the result.
5. For pre-commit verification, inspect only the staged candidate and run the repository's smallest relevant non-mutating checks.

## Pre-commit verification

Use this when the user asks whether staged changes are ready to commit.

1. Inspect `git status`, `git diff --cached`, repository instructions, and staged files.
2. If nothing is staged, stop and report that there is no commit candidate.
3. Discover the repository's authoritative format, lint, test, and build commands from its existing configuration.
4. Run the smallest relevant checks in this order:
   - `git diff --cached --check`;
   - non-mutating format verification for staged source files;
   - configured lint for affected code;
   - targeted tests for affected packages/modules;
   - broader build/regression checks only when required by the repository or reachable risk.
5. Keep unit, integration, HTTP smoke, lint, and build results distinct.
6. Report each check as passed, failed, or blocked, then state remaining risk and the next concrete action.

When checks require Docker Compose, reuse the repository's existing Compose workflow and services; do not recreate containers or delete volumes merely for pre-commit verification.

## Guardrails

- No destructive Git operation without explicit, precise authorization.
- Pre-commit verification does not stage, commit, reset, stash, or rewrite files.
- Preserve unstaged and unrelated working-tree changes.
- Do not bypass checksum, signature, lockfile, lint, or test failures to make a candidate appear ready.
- A blocked required check is not a pass and must not be reported as commit-ready.
