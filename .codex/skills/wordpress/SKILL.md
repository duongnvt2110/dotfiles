---
name: wordpress
description: "WordPress repository work for plugins, blocks/themes, REST and newer APIs, performance, static analysis, Playground, WP-CLI, and WPDS."
---

# WordPress

Start with project triage, then load only the specialist material needed for the task. Summary references give routing/guardrails; matching subdirectories contain deeper source material.

| Need | Summary | Deep material |
|---|---|---|
| Project inspection | `references/triage.md` | `references/triage/` + `scripts/detect_wp_project.mjs` |
| Plugin development | `references/plugin-development.md` | `references/plugin-development/` + `scripts/detect_plugins.mjs` |
| Block development | `references/blocks.md` | `references/blocks/` + `scripts/list_blocks.mjs` |
| Block themes | `references/block-themes.md` | `references/block-themes/` + `scripts/detect_block_themes.mjs` |
| Interactivity API | `references/interactivity-api.md` | `references/interactivity-api/` |
| Abilities API | `references/abilities-api.md` | `references/abilities-api/` |
| REST API | `references/rest-api.md` | `references/rest-api/` |
| Performance | `references/performance.md` | `references/performance/` + `scripts/perf_inspect.mjs` |
| PHPStan | `references/phpstan.md` | `references/phpstan/` + `scripts/phpstan_inspect.mjs` |
| Playground | `references/playground.md` | `references/playground/` |
| WP-CLI / operations | `references/wp-cli.md` | `references/wp-cli/` + `scripts/wpcli_inspect.mjs` |
| WordPress Design System | `references/wpds.md` | n/a |

Generic engineering planning/debugging/verification may support the task, but WordPress remains the primary domain route.
