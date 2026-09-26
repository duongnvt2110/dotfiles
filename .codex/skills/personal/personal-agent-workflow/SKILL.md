---
name: personal-agent-workflow
description: "Manual personal repository workflow for RTK usage, my_docs setup, document naming, update stamps, and user-specific documentation conventions."
disable-model-invocation: true
---

# Personal Agent Workflow

Use this only when the user wants their personal repository/documentation conventions applied. Generic repository discovery, scope discipline, implementation safety, and verification remain owned by the active `AGENTS.md` instructions and should not be duplicated here.

## RTK

Prefer `rtk` for output-heavy commands when it materially reduces context, for example:

- `rtk git status`
- `rtk git diff`
- `rtk rg ...`
- `rtk ls`
- `rtk ./path/to/script <args>` when supported

Use the native command when exact native output, interactivity, or unsupported behavior makes RTK unsuitable. Never write `rtk rtk <command>`.

## `my_docs`

Store user-created planning/specification/investigation documents under the project-level `my_docs/` directory.

Before creating a document:

1. Check whether `my_docs/` exists at the project root.
2. If missing, prefer:

   ```text
   rtk project-link link my_docs
   ```

3. If the repository provides a local fallback, it may be used instead:

   ```text
   rtk ./link-local-docs/project-link.sh link my_docs
   ```

4. If neither setup path is available, report the blocker instead of silently writing the document elsewhere.

## Naming

Use:

```text
yyyy_mm_dd_file_name.extension
```

Use a four-digit year, two-digit month/day, and lowercase snake_case filename.

Example:

```text
2026_09_17_poll_review_plan.md
```

## Update History

When updating an existing user document, keep the newest update stamp first near the top:

```text
Updated: YYYY-MM-DD HH:MM
```

Preserve prior update entries in reverse chronological order. If front matter has an `updated` field, keep it consistent with the newest update.

## Boundary

- Repository-specific commands and safety rules still come from the closest `AGENTS.md` and repository docs.
- This skill does not override the repository's documentation location if the repository explicitly requires another path.
- Do not create documents merely because this skill is loaded; use these conventions only when documentation is part of the requested work.
