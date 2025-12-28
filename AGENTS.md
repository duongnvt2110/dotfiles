# Repository Guidelines

This repository curates the Codex/Claude agent catalog that powers workspace automation, so every change must keep the agents trustworthy, composable, and easy to audit.

## Project Structure & Module Organization
- `.codex/agents/*.md` holds individual agent briefs; mirror the category and capability structure in `README.md`.
- `.codex/rules` and `.codex/prompts` store reusable directives; centralize shared text there instead of duplicating it in each agent.
- `.codex/skills` contains installer and creator utilities; treat every skill folder as an isolated package with its own `SKILL.md`.
- Keep the root minimal; add top-level folders only when the Codex CLI references them.

## Build, Test, and Development Commands
- `rg --files .codex/agents | sort` quickly inventories the catalog and reveals naming drift before you edit.
- `python .codex/skills/.system/skill-creator/scripts/quick_validate.py .codex/skills/create-plan` validates any skill folder; swap in your path.
- `markdownlint "**/*.md"` (or `npx markdownlint-cli` if available) enforces heading hierarchy and list spacing before review.

## Coding Style & Naming Conventions
- Author content in Markdown with ATX headings, 80-100 character lines, and fenced blocks for commands.
- Use hyphen-case filenames (`frontend-developer.md`) and keep titles in Title Case inside the documents.
- Every agent brief should open with a short summary, followed by capability tables or bullet lists organized from highest to lowest priority.

## Testing Guidelines
- Run `markdownlint` plus `quick_validate.py` for any folder that includes `SKILL.md`; failures block review until resolved.
- Add lightweight scenario tests (example prompts + expected behaviors) inside each agent file under a `## Usage Patterns` heading to keep manual QA deterministic.
- When changing shared rules or prompts, capture a before/after example at the bottom of the PR to show the behavioral delta.

## Commit & Pull Request Guidelines
- History is empty today, so follow Conventional Commits (`feat: add seo-content-planner agent`) to keep future changelog generation simple.
- Each PR description should include: scope summary, impacted directories, validation commands run, and any follow-up tasks.
- Link tickets or discussions in the PR body and add screenshots when the change affects rendered documentation.

## Security & Configuration Tips
- Keep `.codex/auth.json` and any session transcripts private; never paste credentials into agent briefs.
- When contributing automation around the CLI, reference `.codex/config.toml` instead of duplicating configuration defaults, and avoid committing personalized tokens or machine-specific paths.
