---
name: pre-commit-check
description: Check staged repository changes before commit using the repository's own formatting, lint, build, and targeted-test workflow; use for pre-commit verification, not for committing or broad code review.
---

# Pre Commit Check

Validate the staged diff and report whether it is ready to commit. This skill
does not stage, commit, reset, stash, reformat, or otherwise modify files.

## Scope and discovery

- Inspect `git status`, `git diff --cached`, repository `AGENTS.md`, and the
  files changed in the index.
- If nothing is staged, stop and report that there is no commit candidate.
- Preserve unstaged and unrelated changes; do not include them in checks unless
  the repository's check command necessarily reads the full tree.
- Read the repository's Makefile, package scripts, CI workflow, and Compose
  files to find the authoritative format, lint, build, and test commands.
- Choose checks based on the staged file types and affected packages. Do not
  run an unrelated full-repository workflow when a narrower supported check is
  sufficient.

## Toolchain selection

- Check tool availability before running a command. A missing host dependency
  is a reason to use the repository's existing container workflow, not to
  invent a new environment.
- If the repository uses Docker Compose for services or build dependencies,
  inspect the actual Compose file/project and reuse a running service with:

  ```bash
  docker compose -f <compose-file> exec -T <service> <command>
  ```

- Do not use standalone `docker run` when a matching Compose service exists.
- Do not recreate containers or delete volumes for a pre-commit check.
- Never bypass checksum, signature, or lockfile verification to make a check
  pass. Report the check as blocked and include the exact safe failure reason.

## Check order

Run the smallest relevant checks in this order:

1. `git diff --cached --check`.
2. Format verification for staged source files, without writing changes.
3. The repository's configured lint command, using its pinned version when
   available.
4. Targeted tests for affected packages or modules.
5. A broader build or regression check only when the staged change warrants it
   or the repository requires it before commit.

Keep test categories separate in the report: unit, integration, HTTP smoke,
lint, and build checks are not interchangeable.

## Results

Report:

- staged files checked and any intentionally excluded files;
- each command and whether it passed, failed, or was blocked;
- whether checks ran on the host or inside an existing Compose container;
- the first actionable failure and its scope;
- remaining risk and the exact next step.

A blocked tool installation is not a lint pass. Do not claim commit readiness
when a required check was not executed.
