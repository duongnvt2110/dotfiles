---
name: engineering
description: "Fallback for general repository engineering—understand, plan, implement, debug, review, test, Git, and handoff—when no narrower domain skill or explicitly invoked manual workflow applies."
---

# Engineering

## Core rules

- Explore broadly. Prove necessity. Implement narrowly.
- Inspect the actual repository before making repository-specific claims.
- Approved user requirements are authoritative.
- Existing code and tests are evidence, not permission to rewrite requirements.
- Prefer the smallest sufficient solution.
- Do not add architecture unless required.
- Preserve unrelated working-tree changes.
- Verify against the original goal before declaring completion.
- Stop once the requested behavior is correct, safe, verified, and complete.

## Select references

Read only the references needed for the current task.

| Need | Reference |
|---|---|
| Clarify goal or terminology | `references/intake.md` |
| Gather repository or external evidence | `references/research.md` |
| Make an architecture/interface decision | `references/design.md` |
| Produce an implementation plan | `references/planning.md` |
| Produce/refine requirements | `references/specification.md` |
| Compare or record decisions | `references/decisions.md` |
| Decompose work into tasks | `references/tasks.md` |
| Change code | `references/implementation.md` |
| Choose/prove a test strategy | `references/testing.md` |
| Run existing HTTP API smoke scenarios | `references/http-smoke-testing.md` |
| Diagnose unexpected behavior | `references/debugging.md` |
| Review a code change for defects | `references/review.md` |
| Verify requested behavior or PR feedback | `references/verification.md` |
| Prepare/verify a release or rollout | `references/release.md` |
| Investigate production/runtime behavior | `references/operations.md` |
| Perform development Git workflows | `references/git.md` |
| Transfer work/context | `references/handoff.md` |

Multiple references may be used as the task progresses. Do not load all references by default.

## Domain precedence

When the request is clearly Terraform, WordPress, or frontend work, that domain skill is primary. Generic engineering procedures may still be reused as supporting methodology, but `engineering` must not steal the route.
