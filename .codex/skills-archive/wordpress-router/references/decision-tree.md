# WordPress Router Decision Tree

Run the bundled project triage helper first, then use the detected repository kind plus user intent to choose the smallest relevant `$wordpress` reference set.

## Repository kind

Prefer the most specific strong signal when several match:

`gutenberg` > `wp-core` > `wp-site` > `wp-block-theme` > `wp-block-plugin` > `wp-theme` > `wp-plugin`

A full site may require more than one reference area, but do not load unrelated WordPress material.

## Intent → WordPress material

| Intent | Load |
|---|---|
| Interactivity API / `data-wp-*` / `@wordpress/interactivity` | `wordpress/references/interactivity-api.md` + `interactivity-api/` |
| Abilities API | `wordpress/references/abilities-api.md` + `abilities-api/` |
| Playground / blueprints | `wordpress/references/playground.md` + `playground/` |
| Blocks / `block.json` / serialization | `wordpress/references/blocks.md` + `blocks/` |
| `theme.json` / templates / patterns | `wordpress/references/block-themes.md` + `block-themes/` |
| Plugins / hooks / lifecycle / Settings API | `wordpress/references/plugin-development.md` + `plugin-development/` |
| REST endpoint / `register_rest_route` | `wordpress/references/rest-api.md` + `rest-api/` |
| WP-CLI / operations | `wordpress/references/wp-cli.md` + `wp-cli/` |
| PHPStan | `wordpress/references/phpstan.md` + `phpstan/` |
| Performance / caching / profiling | `wordpress/references/performance.md` + `performance/` |

For build tooling, testing, or security, first inspect the repository's existing tooling and then combine the relevant WordPress material with normal engineering/security procedure. Do not route to planned/nonexistent micro-skills.

## Guardrails

- Verify detected tooling before suggesting Composer/npm/pnpm/yarn commands.
- Prefer repository-provided lint/test/build scripts.
- Ask for WordPress/PHP version constraints only when they materially affect the task and cannot be discovered.
