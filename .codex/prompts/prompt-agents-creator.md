# prompt-agent-creator — Generate AGENTS.md for this repository

You are a coding agent running in Codex CLI. Your task is to generate or update an `AGENTS.md` file at the repository root that teaches other agents how to work effectively in this codebase.

## Inputs
- Optional scope from user: "$ARGUMENTS" (may be empty)

## Primary goal
Create a repo-specific, actionable `AGENTS.md` that:
- Explains repo purpose + high-level architecture
- Lists reliable setup/build/test/lint commands
- Documents conventions (branching, commit style, PR rules)
- Documents environments (dev/stg/prod) and how to run safely
- Points to key directories and “source of truth” files
- States what NOT to do (secrets, destructive commands, risky operations)

## Hard rules
- Do NOT invent commands. If you mention a command, verify it exists by locating:
  - Makefile targets, package.json scripts, go.mod tools, task runners, CI workflows, docs, etc.
- Prefer commands already used by CI (GitHub Actions, scripts).
- If uncertain, add an **Open Questions** section instead of guessing.
- Keep it concise but complete: optimize for “agent onboarding”.
- If `AGENTS.md` already exists: preserve intent, improve structure, update stale sections, and keep any repo-specific policies.

## What to scan (repo reconnaissance)
1. Root docs: README*, CONTRIBUTING*, docs/, ADRs, runbooks.
2. Build/test entry points:
   - Makefile, Taskfile, package.json, go.mod, tools.go
   - scripts/ (shell, node, python)
3. CI/CD:
   - .github/workflows/* (determine canonical commands)
4. Infrastructure:
   - terraform/ or infra/ structure, stacks.yaml, env/ configs, backend config
5. Local dev:
   - docker-compose*, Dockerfile*, devcontainer, .env.example

## Required AGENTS.md structure
Write AGENTS.md with these headings (omit any that truly don’t apply):

1. # Repository Overview
   - what it is, what it does, major components

2. # Quick Start
   - minimal steps to run locally (verified commands only)

3. # Common Commands
   - Build
   - Test
   - Lint/Format
   - Typecheck
   - Migrations (if applicable)
   - Infrastructure plan/apply (if applicable)

4. # Repo Map
   - short directory map (top 8–15 important paths)
   - where configs live (env/, config/, charts/, etc.)

5. # Architecture & Conventions
   - layering rules (handlers/usecase/repo etc.)
   - naming conventions
   - error handling/logging style
   - code generation rules (if any)

6. # CI/CD & Release
   - how PRs are validated
   - how deployments happen
   - environment promotion flow (dev → stg → prod)

7. # Safety & Guardrails
   - secrets handling rules
   - destructive ops warnings (terraform apply, migrations)
   - what requires human confirmation

8. # Open Questions
   - only if needed

## Output requirements
- Create or update `AGENTS.md` at repo root.
- After writing, print a short summary:
  - what you added/changed
  - any open questions
