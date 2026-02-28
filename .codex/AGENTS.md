# ExecPlans
 
When implementing complex features or performing significant refactors, you must use an ExecPlan (as defined in `.agent/PLANS.md`, located either in the project root or at `~/.codex/.agent`) to guide the work from design through implementation.

 ## Workflow Orchestration

  ### 0. Skill Pre‑Flight (Mandatory)

  - Before any planning or implementation, scan the available skills list and choose the best match.
  - If multiple skills apply, use the minimal set and state the order.
  - If a skill is missing or blocked, fall back to the closest workflow and note the gap.

  ### 1. Plan Mode Default (with Brainstorming)

  - Enter plan mode for any task with 3+ steps, cross‑file changes, or architectural decisions.
  - Use the brainstorming skill at the start of Plan Mode to clarify intent and options.
  - If new info invalidates the plan: stop, re‑plan, then continue.
  - Use plan mode for verification steps too (tests, QA, rollout).
  - Write specs up front to eliminate ambiguity and reduce rework.

  ### 2. OpenSpec → Beads Flow (After Detailed Plan)

  - Brainstorming phase: always read the PRD + ExecPlan before writing OpenSpec.
  - Write spec first with OpenSpec (scope, flows, edge cases, acceptance).
  - Save spec deltas in openspec/changes/... and update the relevant plan doc.
  - Convert plan → beads:
      - Create epic + tasks with bd create ... --json
      - Link dependencies with --deps discovered-from:<parent>
  - Start work only after:
      - bd ready --json shows unblocked items
      - You claim the task with bd update <id> --status in_progress --json

  ### 3. Subagent Strategy (Keep Main Context Clean)

  - Offload research, exploration, and parallel analysis to subagents.
  - One task per subagent; aggregate findings in a single summary.

  ### 4. Self‑Improvement Loop

  - After any user correction, update tasks/lessons.md with a rule.
  - Review lessons at session start and before similar tasks.
  - Treat lessons as executable guardrails, not notes.

  ### 5. Verification Before Done

  - Never mark done without proof: tests, logs, or direct runtime checks.
  - Validate behavior diff vs main when relevant.
  - Ask: “Would a staff engineer approve this?”

  ### 6. Demand Elegance (Balanced)

  - For non‑trivial changes, ask if a simpler or more robust approach exists.
  - If a fix feels hacky, replace with the elegant solution.
  - Skip this for simple/obvious tasks.

  ### 7. Autonomous Bug Fixing

  - When given a bug report, fix it end‑to‑end without extra prompting.
  - Trace logs/tests to root cause, then resolve.
  - Don’t bounce the user unless blocked by missing data.