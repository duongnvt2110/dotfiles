---
name: gen-pr-des
description: "Generate a pull request description from git history and diff data between a base and head ref."
---

# Pull Request Description Workflow

Use this workflow to generate deterministic PR descriptions from repository truth.

## Read-Only Command Policy

Use only these git commands:

- git merge-base
- git rev-parse
- git log
- git diff
- git show

## Inputs

- base = {{base}} (default: origin/main)
- head = {{head}} (default: HEAD)

## Steps

1) Compute merge base:
   BASE_SHA = git merge-base {{base}} {{head}}

2) Collect context:
   - Current branch: git rev-parse --abbrev-ref {{head}}
   - Latest commit on head: git log -1 --pretty=format:"%h%n%s%n%b" {{head}}
   - Commit list since base: git log --no-merges --pretty=format:"%h %s" BASE_SHA..{{head}}
   - Changed files: git diff --name-status BASE_SHA..{{head}}
   - Diff stat: git diff --stat BASE_SHA..{{head}}
   - Unified diff (truncate if very large): git diff BASE_SHA..{{head}}

3) Resolve PR template path using this deterministic order:
   - .codex/.github/pull_request_template.md
   - .github/pull_request_template.md
   - .github/PULL_REQUEST_TEMPLATE.md
   - first alphabetical file in .github/PULL_REQUEST_TEMPLATE/*.md

4) If no template exists, use this fallback structure:
   - Summary
   - Type
   - Scope
   - Description
   - Context
   - Changes
   - Breaking Changes
   - How to Test
   - Checklist

5) Fill the template using only collected git output:

   - Summary / Type / Scope / Description:
     Derive from the latest commit subject (Conventional Commits if present).
   - Context:
     Use commit body or referenced issue IDs only.
   - Changes:
     Derive from diff and file list.
   - Breaking Changes:
     Only if commit subject contains "!" or commit body contains "BREAKING CHANGE:".
     Otherwise write "None".
   - How to Test:
     If no test instructions exist in commit body or diff, write "None".
   - Checklist:
     Keep as-is unless something can be confidently checked.

## Deterministic Edge Cases

- If `git merge-base` fails (invalid refs), keep template structure and write
  `None` for unknown fields.
- Put the ref error detail in Context only.
- If there are no commits or diff since BASE_SHA, set Changes to
  `No changes since base`.
- If diff is large, prioritize summary from diff stat + file list and avoid
  line-level speculation.

## Rules

- Do NOT invent information.
- Do NOT guess intent.
- If a field cannot be determined, write "None".
- Preserve the template structure and headings exactly.
- Output only the filled template. No commentary.

## Usage Patterns

### Pattern 1: normal branch comparison

Input:

- base: origin/main
- head: HEAD
Expected:

- Fill template fields from commit and diff evidence only.

### Pattern 2: missing template

Input:

- no template file in expected paths
Expected:

- Use fallback structure.
- Keep unknown fields as `None`.

### Pattern 3: no changes since base

Input:

- BASE_SHA..HEAD has empty commit range
Expected:

- Set Changes to `No changes since base`.
