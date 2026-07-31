---
name: gh-pr-review-fix
description: Review a GitHub PR with gh, inspect inline review comments, patch the repo, verify the fix, and push the branch update. Use when Codex needs to address PR review feedback, reconcile reviewer comments with code changes, or drive a GitHub review/fix loop end to end.
---

# GitHub PR Review Fix

## Workflow

1. Inspect the PR with `gh pr view` and read the review summary, inline comments, and review decision.
2. Find the exact files and lines the review refers to. Prefer the inline comment thread over the summary when they differ.
3. Make the smallest safe change that resolves the reviewer concern. Do not fold unrelated cleanup into the fix.
4. Re-run the narrowest relevant verification first.
5. Commit the fix on the PR branch, push it, and re-check the PR state with `gh`.

## Review Rules

- Treat review comments as the source of truth for required changes.
- If the review asks for a behavior change, update the code and any affected docs/tests together.
- If the review asks for robustness, preserve existing behavior and only harden the fragile path.
- If a file path or filename is stale in the review context, verify the current repo state before editing.
- If a change touches generated outputs, keep the output contract consistent with the script or the document that owns it.

## Verification

- Use the narrowest check that proves the fix.
- If the review is code-only, run the relevant syntax or unit check before pushing.
- If the review is PR-process related, re-run `gh pr view` after pushing to confirm the new commit is on the PR branch.
- If a review thread is still open because the reviewer needs to re-check the change, leave a concise PR comment only if it adds value.

## Common Commands

- `gh pr view <number> --comments --json reviews,comments,latestReviews,headRefName,headRefOid,reviewDecision`
- `gh api repos/<owner>/<repo>/pulls/<number>/comments`
- `git diff`, `git status`, `git log --oneline -1`
- project-specific test or lint command for the touched files
