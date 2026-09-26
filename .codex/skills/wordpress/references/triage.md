# WordPress Triage

Inspect the WordPress project before selecting specialist guidance.

## Procedure

1. Run the bundled triage helper when repository type/tooling is not already obvious:

   ```bash
   node <this-skill-dir>/scripts/detect_wp_project.mjs
   ```

2. Identify WordPress/PHP versions, project type, plugin/theme structure, build tooling, and test/lint commands.
3. Prefer the most specific strong repository signal when several match:

   ```text
   gutenberg > wp-core > wp-site > wp-block-theme > wp-block-plugin > wp-theme > wp-plugin
   ```

4. Locate the relevant plugin/theme/module and inspect similar code.
5. Choose only the specialist references needed for the request.
6. Prefer repository-provided lint/test/build commands over generic commands.

## Intent routing

| Intent | Load |
|---|---|
| Interactivity API / `data-wp-*` / `@wordpress/interactivity` | `interactivity-api.md` + `interactivity-api/` |
| Abilities API | `abilities-api.md` + `abilities-api/` |
| Playground / blueprints | `playground.md` + `playground/` |
| Blocks / `block.json` / serialization | `blocks.md` + `blocks/` |
| `theme.json` / templates / patterns | `block-themes.md` + `block-themes/` |
| Plugins / hooks / lifecycle / Settings API | `plugin-development.md` + `plugin-development/` |
| REST endpoint / `register_rest_route` | `rest-api.md` + `rest-api/` |
| WP-CLI / operations | `wp-cli.md` + `wp-cli/` |
| PHPStan | `phpstan.md` + `phpstan/` |
| Performance / caching / profiling | `performance.md` + `performance/` |

A full site may need more than one reference area, but do not load unrelated WordPress material. For build tooling, testing, or security, combine the relevant WordPress material with the repository's normal engineering/security procedure instead of inventing another router.

## Guardrails

- Verify detected tooling before suggesting Composer/npm/pnpm/yarn commands.
- Prefer repository-provided lint/test/build scripts.
- Ask for WordPress/PHP version constraints only when they materially affect the task and cannot be discovered.
- Do not create new WordPress architecture merely because several specialist references exist.
