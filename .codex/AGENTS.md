# AGENTS.md

This file defines working rules for coding agents in this repository. It is the
operational guide for discovery, planning, implementation, verification, and
reporting.

## /init Behavior

When `/init` is run for a project:

1. Copy `PROJECT-AGENTS.md` into the project root as `AGENTS.md` if it does not
   already exist.
2. Treat `PROJECT-AGENTS.md` as the source of project-level workflow guidance.
3. If `PROJECT-AGENTS.md` is missing, proceed with this global file and note
   the absence in your report.

## 1) Instruction Priority

When instructions conflict, follow this order:

1. System and developer instructions
2. This `AGENTS.md`
3. Task-specific docs and repository docs (`README.md`, `docs/`, ADRs, specs)
4. The direct user request

If there is a conflict, follow the higher-priority instruction and note the
conflict briefly in your report.

## 2) Repository Discovery (Always First)

Before planning or editing:

- Inspect repository structure and identify files relevant to the task.
- Read local docs, README sections, and config files relevant to the change.
- Confirm any required spec/plan is current and is the source of truth.
- Identify build, test, lint, format, and run commands before editing.
- Confirm entry points, affected modules, and external interfaces.

If discovery is not possible, state why and list assumptions.

## 3) Planning Standard

Choose the lightest planning process that still makes the work safe.

### Small Change

Use a short plan when the change is local, low-risk, and easy to verify.

### Complex Change

Use a full Task ExecPlan for:

- Non-trivial features
- Architectural changes
- Significant refactors
- Multi-file changes with behavioral risk
- Migration work
- Unclear requirements or dependencies

Task ExecPlans follow `.agent/PLANS.md` in the project root, or
`~/.codex/.agent/PLANS.md` if project guidance is missing.

## 4) Workflow Guidance

Use workflow depth based on task clarity:

- Unclear idea: Brainstorming -> mini plan -> spec -> task plan -> implementation
- Mostly clear idea: Brainstorming -> spec -> task plan -> implementation
- Clear idea: spec/plan (as needed) -> implementation

If new information invalidates the plan, stop, re-plan, and continue.

## 5) Context Passing

Before writing a Task ExecPlan or implementing a change:

- Read the relevant task record (for example Beads), if one exists.
- Read related specs and docs that define the current behavior.
- Read all files you expect to modify.
- Extract requirements for the current task only.

Do not rely on memory for requirements or hidden assumptions.

## 6) Editing Rules

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

## 7) Skill and Tool Pre-Flight

Before planning or implementation:

- Check available skills, tools, or project workflows.
- Choose the smallest useful set.
- State the chosen order only when it affects the outcome.
- If a preferred skill or tool is unavailable, use the closest supported path
  and note the gap.

### RTK Shell Guardrail (Required)

All shell commands must use `rtk` as the command entrypoint.

- Required default: `rtk <command>`
- If a wrapper is unavailable: `rtk proxy <command>`
- Only fallback: raw shell command when `rtk` cannot execute the command safely
  or correctly; explicitly note the reason in the report.
- Verification commands should also use `rtk` when supported.

Examples:

- `rtk git status`
- `rtk npm run build`
- `rtk proxy \"python3 -m pytest -q\"`

## 8) Subagent Usage

Use subagents only when they reduce risk or keep the main context focused.

- One clear task per subagent.
- Use them for research, exploration, or parallel analysis.
- Aggregate findings into one concise summary before acting.

## 9) Verification Requirement

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

## 10) Definition of Done

A task is done only when:

- The requested behavior is implemented.
- Relevant tests or checks pass, or verification limits are clearly stated.
- Related documentation is updated when needed.
- Known risks, trade-offs, and follow-ups are reported clearly.

## 11) Bug-Fix Standard

When given a bug report:

- Reproduce or narrow the failure.
- Trace to the most likely root cause.
- Fix the underlying issue, not just the symptom, when practical.
- Add or update regression coverage when reasonable.
- Verify the fix directly.

Do not ask unnecessary follow-up questions when the repository already
contains enough information to proceed.

## 12) Quality Bar

For non-trivial work, check whether the solution is:

- Simpler
- More robust
- Easier to maintain
- Consistent with the rest of the repository

Prefer the simplest solution that meets the requirements and verification
standard.

## 13) Reporting Format

Final task reports must include:

- Summary of what changed
- Key decisions or trade-offs
- Files changed
- Verification performed
- Remaining risks or follow-ups

## 14) Safety

- Do not change unrelated files.
- Avoid destructive operations unless explicitly requested.

## 15) Document Storage Guardrail (`my_docs`)

All generated or updated docs for tasks must live under the project-level
`my_docs/` folder. This includes specs, plans, ADR drafts, investigation notes,
and any implementation-related documentation.

Before creating or updating docs:

1. Check whether `my_docs/` exists at the current project root.
2. If missing, create/link it using `project-link` scripts:
   - Preferred: `project-link link my_docs`
   - Local fallback (when available in repo): \
     `./link-local-docs/project-link.sh link my_docs`
3. If `project-link` is not installed, print this setup message and stop doc
   generation until setup is complete:

```text
[Guardrail] Missing `project-link` command.
Setup steps:
1) cd link-local-docs
2) ./scripts/setup-project-link.sh
3) source ~/.zshrc   (or open a new shell)
4) project-link link my_docs
5) project-link status my_docs
```

If a task requires docs and `my_docs/` is unavailable, report the blocker
explicitly in the final report.

### Naming Convention (Required)

Every plan/spec/doc file under `my_docs/` must use this filename pattern:

`yyyy_mm_dd_file_name.{extension}`

Rules:

- `yyyy_mm_dd` uses the creation date in 4-digit year, 2-digit month, 2-digit
  day format.
- `file_name` must be lowercase snake_case and descriptive.
- Use a suitable extension (`.md`, `.txt`, `.json`, etc.).

Examples:

- `2026_04_09_api_rollout_plan.md`
- `2026_04_09_auth_spec.md`

### Content Update Stamp (Required)

When a doc is updated, the content must also include an explicit update stamp
near the top of the file, for example:

`Updated: 2026-04-09 14:30`

Rules:

- Use datetime format `YYYY-MM-DD HH:MM` (24-hour time).
- Do not delete previous update entries; keep older updates as history.
- Keep history as repeated lines in this exact format:
  `Updated: YYYY-MM-DD HH:MM`
- Add the newest `Updated: ...` line first (reverse chronological order) under
  an `Update History` section near the top of the file.
- If the document uses front matter, keep an `updated` field with the latest
  datetime and also preserve a list-based history section in the content.

## Appendix: Optional Behavioral Skill

For Karpathy-inspired coding behavior guidelines (think before coding,
simplicity first, surgical changes, goal-driven execution), use:

- `skills/karpathy-workflow/SKILL.md`

This appendix is discoverability-only and does not replace global always-on
rules in this `AGENTS.md`.
