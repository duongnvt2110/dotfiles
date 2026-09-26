# Review

Perform a defect-first review of a requested code change without turning ordinary
review into a separate automatic skill.

## Procedure

1. Identify the exact review target: working-tree diff, staged diff, branch/base
   diff, commit, PR change set, or user-named files.
2. Read the applicable repository instructions and enough surrounding code to
   understand each changed path.
3. Inspect the complete target for concrete regressions in correctness,
   security, performance, or maintainability.
4. Verify each candidate finding against reachable call paths, contracts, and
   relevant tests before reporting it.
5. Continue through the full review target after finding the first issue.
6. Report actionable findings first, ordered by severity, with precise file and
   line evidence. If there are no qualifying findings, say so explicitly.
7. Keep test gaps and residual risks separate from confirmed defects.

## Guardrails

- Review the requested change, not unrelated pre-existing problems.
- Do not report style preferences or speculative concerns as defects.
- Do not modify code unless the user also asked to fix findings.
- Use the system `review-agent` only when another agent explicitly delegates a
  read-only review; ordinary user review requests remain in `engineering`.
