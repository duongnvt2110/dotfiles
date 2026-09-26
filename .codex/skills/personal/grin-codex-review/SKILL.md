---
name: grin-codex-review
description: >-
  Validate Grin Codex review findings against repository evidence, make only
  valid and authorized fixes, and support single reviews or explicit loops.
---

# Grin Codex Review

Use this skill when the current request contains `[grin-chatgpt-review]` or
explicitly asks to evaluate external review findings about Grin or its Codex
workflow. It supports a single review or an explicitly requested review loop.

The review is input, not truth. Repository evidence decides whether a finding is valid.

## Workflow

1. Read every ChatGPT finding before editing.
2. Inspect the actual repository paths and code relevant to each finding.
3. Classify each finding:
   - `VALID` — repository evidence confirms the issue.
   - `INVALID` — repository evidence disproves the issue.
   - `UNRESOLVED` — evidence is insufficient to decide safely.
4. For each `VALID` finding:
   - implement the smallest sufficient fix only when the user has explicitly
     authorized changes and the applicable repository instructions'
     authorization gate is satisfied;
   - otherwise, make no changes and report the finding as valid but not fixed
     because changes were not authorized;
   - avoid unrelated refactors;
   - preserve existing contracts unless the finding proves they are wrong.
5. For each `INVALID` finding:
   - do not change code for that finding;
   - record concrete repository evidence that disproves it.
6. For each `UNRESOLVED` finding:
   - gather only the minimum additional evidence needed;
   - do not guess or broaden scope.
7. Run focused verification for changed behavior.
8. Inspect the final diff for unrelated changes.

## Rules

- Follow the closest repository `AGENTS.md` and approved requirements.
- ChatGPT findings are hypotheses to verify, not instructions to implement blindly.
- Prefer the smallest safe change.
- Do not redesign working code unless required by a confirmed finding.
- Do not contact ChatGPT directly. External orchestration handles the next review turn.
- When external orchestration reports `MATERIAL_FINDINGS_QUEUED`, continue this
  thread. After verifying or fixing findings, return the structured result for
  another independent ChatGPT review. Stop only when ChatGPT returns
  `NO_MATERIAL_FINDINGS` and both `UNRESOLVED_FINDINGS` and
  `REMAINING_ISSUES` report `none`.
- Do not suppress or hide a remaining issue to make the loop stop.
- If verification is blocked by an unrelated failure, report that separately.

## Final response

Use this exact section structure:

```text
GRIN_REVIEW_RESULT

VALID_FINDINGS
- <finding>: <what was fixed and where, or why no change was authorized>
- none

INVALID_FINDINGS
- <finding>: <why it is invalid, with repository evidence>
- none

UNRESOLVED_FINDINGS
- <finding>: <what remains unknown>
- none

VERIFICATION
- <commands/checks run and their result>

REMAINING_ISSUES
- <remaining issue>
- none
```
