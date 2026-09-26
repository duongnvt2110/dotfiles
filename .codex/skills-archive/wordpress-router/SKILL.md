---
name: wordpress-router
description: "Manual WordPress project triage: detect repository type/tooling, choose the relevant WordPress workflow, and identify the right validation commands."
disable-model-invocation: true
---

# WordPress Router

Use this explicit entry point when you want WordPress project classification before deeper work.

## Workflow

1. Run the bundled triage helper:

   ```bash
   node <this-skill-dir>/scripts/detect_wp_project.mjs
   ```

2. Classify the repository: plugin, classic theme, block theme, WordPress core, or full site.
3. Identify available PHP/Composer, Node, `@wordpress/scripts`, PHPUnit, Playwright, and `wp-env` tooling.
4. Read `references/decision-tree.md` only when routing is ambiguous.
5. Continue with the matching `$wordpress` reference area and the repository's existing lint/test/build commands.

Do not invent a new WordPress architecture merely because several specialist references exist. The router chooses context; `$wordpress` remains the domain implementation skill.
