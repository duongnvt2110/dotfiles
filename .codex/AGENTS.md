# AGENTS.md

This file defines global, repo-agnostic guardrails for coding agents. Tool- or
workflow-specific rules belong in each project’s AGENTS.md.

## /init Instruction

When `/init` is run for a project:

1. Copy `PROJECT-AGENTS.md` into the project root as `AGENTS.md` if it does not
   already exist.
2. Treat `PROJECT-AGENTS.md` as the source of project-level workflow guidance.
3. If `PROJECT-AGENTS.md` is missing, proceed with this global file and note
   the absence in your report.

## 1) Instruction Priority

When instructions conflict, follow this order:

1. System and developer instructions
2. Project `AGENTS.md`
3. Task-specific docs and repository docs (`README.md`, `docs/`, ADRs, specs)
4. The direct user request
5. This `AGENTS.md`

If there is a conflict, follow the higher-priority instruction and note the
conflict briefly in your report.

## 2) Repository Discovery (Always First)

Before planning or editing:

- Inspect repository structure and identify relevant entry points.
- Read local docs and config files relevant to the change.
- Confirm any required spec/plan exists and is the latest source of truth.
- Identify build, test, lint, format, and run commands.
- Locate the exact files you will change.

If discovery is not possible, state why and list assumptions.

## 3) Planning Standard

Choose the lightest planning process that still makes the work safe.

- Use a full plan for multi-step, cross-file, or architectural changes.
- Small, localized changes may use a short plan but must still verify and
  report.

## 4) Editing Rules

When editing code:

- Prefer the smallest safe diff that fully solves the problem.
- Preserve existing style and patterns unless explicitly changing them.
- Do not refactor unrelated code.
- Do not rename public APIs, files, or exported symbols without checking
  impact.
- Do not introduce new dependencies unless clearly justified.
- Update related tests, docs, configs, or migrations when behavior changes.
- Keep backward compatibility unless the task explicitly allows breaking
  changes.

## 5) Skill and Tool Pre-Flight

Before planning or implementation:

- Check available skills, tools, or project workflows.
- Choose the smallest useful set.
- State the chosen order only when it affects the outcome.
- If a preferred skill or tool is unavailable, use the closest supported path
  and note the gap.

## 6) Subagent Usage

Use subagents only when they reduce risk or keep the main context focused.

- One clear task per subagent.
- Use them for research, exploration, or parallel analysis.
- Aggregate findings into one concise summary before acting.

## 7) Verification Requirement

Never mark work complete without verification. Verification should follow this
order when possible:

1. Run the narrowest relevant test.
2. Run broader tests only if needed.
3. Run lint/format/type-check steps relevant to the change.
4. Perform direct runtime or manual checks when automated checks are
   unavailable.

In the final report:

- State exactly what was verified.
- State the result.
- State what was not verified.
- State any remaining risk.

If verification is impossible, say so explicitly and explain why.

## 8) Definition of Done

A task is done only when:

- The requested behavior is implemented.
- Relevant tests or checks pass, or verification limits are clearly stated.
- Related documentation is updated when needed.
- Known risks, trade-offs, and follow-ups are reported clearly.

## 9) Bug-Fix Standard

When given a bug report:

- Reproduce or narrow the failure.
- Trace to the most likely root cause.
- Fix the underlying issue, not just the symptom, when practical.
- Add or update regression coverage when reasonable.
- Verify the fix directly.

Do not ask unnecessary follow-up questions when the repository already
contains enough information to proceed.

## 10) Quality Bar

For non-trivial work, check whether the solution is:

- Simpler
- More robust
- Easier to maintain
- Consistent with the rest of the repository

Prefer the simplest solution that meets the requirements and verification
standard.

## 11) Reporting Format

Final task reports must include:

- Summary of what changed
- Key decisions or trade-offs
- Files changed
- Verification performed
- Remaining risks or follow-ups

## 12) Safety

- Do not change unrelated files.
- Avoid destructive operations unless explicitly requested.
