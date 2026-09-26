---
name: openspec
description: "Manual OpenSpec workflow for exploring, defining, applying, verifying, and archiving spec-driven changes in an existing repository."
disable-model-invocation: true
---

# OpenSpec

Use this only when the user explicitly requests OpenSpec, `/opsx:*`, or the repository already uses an OpenSpec change workflow.

## Workflow

1. Inspect repository instructions and current OpenSpec state.
2. Read the relevant source specs before proposing a change.
3. Choose only the OpenSpec step the task needs:
   - explore uncertainty;
   - create a change;
   - continue or fast-forward artifacts;
   - apply implementation tasks;
   - verify implementation against artifacts;
   - archive a completed change.
4. Keep OpenSpec artifacts as the source of truth for that change.
5. Do not introduce a second task system or planning framework unless the user explicitly asks for one.

## Common commands

```bash
openspec list
openspec status --change <name>
openspec show <name>
openspec validate <name>
openspec archive <name>
```

For lifecycle details, artifact structure, and command guidance, read `references/workflow.md` only when needed.

For generic planning with no OpenSpec intent, use the normal engineering/planner workflow instead.
