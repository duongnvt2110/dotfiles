---
name: agent-browser
description: "Browser automation CLI for navigating pages, interacting with elements, extracting structured state, and taking screenshots in agent workflows."
---

# Agent Browser

Use this as a supporting browser-automation skill when the task requires deterministic page interaction from the shell.

## Workflow

1. Open the target URL.
2. Snapshot the current page and prefer structured refs.
3. Perform the smallest interaction needed.
4. Re-snapshot after navigation or major DOM changes.
5. Verify the resulting page state before continuing.

Prefer isolated `--session` state for repeatable flows. Use CDP only when intentionally connecting to an existing browser session; never hardcode another user's profile path or credentials.

Read `references/commands.md` when you need command syntax or session/CDP details.
