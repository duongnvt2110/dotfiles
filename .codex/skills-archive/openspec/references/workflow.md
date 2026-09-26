# OpenSpec Workflow Reference

## Project Structure

```
openspec/
├── specs/              # Source of truth (how the system currently works)
│   └── <domain>/
│       └── spec.md
├── changes/            # One folder per proposed change
│   └── <change-name>/
│       ├── proposal.md     # WHY — intent, scope, approach
│       ├── specs/          # WHAT — delta specs (ADDED/MODIFIED/REMOVED)
│       ├── design.md       # HOW — technical approach, architecture
│       └── tasks.md        # DO — implementation checklist
└── config.yaml         # Project configuration (optional)
```

## Core Concepts

### Specs = Source of Truth

`openspec/specs/` describes how your system currently works, organized by domain. These are living documents that evolve as you ship features. Always read relevant specs before proposing changes.

**RFC 2119 keywords:** MUST/SHALL = absolute requirement, SHOULD = recommended, MAY = optional.

### Changes = Proposed Modifications

Each feature or bugfix gets its own isolated folder under `openspec/changes/`. Artifacts build on each other but you can update any artifact at any time.

| Artifact | Purpose |
|----------|---------|
| `proposal.md` | **WHY** — captures intent, scope, approach |
| `specs/` | **WHAT** — delta specs (ADDED/MODIFIED/REMOVED requirements) |
| `design.md` | **HOW** — technical approach and architecture decisions |
| `tasks.md` | **DO** — implementation checklist with checkboxes |

### Delta Specs

Instead of rewriting entire specs, deltas describe what changes:

```markdown
## ADDED Requirements
### Requirement: Two-Factor Authentication
The system MUST require a second factor during login.

## MODIFIED Requirements
### Requirement: Session Timeout
The system SHALL expire sessions after 30 minutes of inactivity.
(Previously: 60 minutes)

## REMOVED Requirements
### Requirement: Remember Me
(Deprecated in favor of 2FA)
```

On archive: ADDED gets appended, MODIFIED replaces, REMOVED deletes from the main specs.

## Workflow Commands

| Command | Purpose |
|---------|---------|
| `/opsx:explore` | Investigate ideas before committing to a change |
| `/opsx:new <name>` | Start a new change (creates folder under `changes/`) |
| `/opsx:continue` | Create the next artifact (one at a time, review between steps) |
| `/opsx:ff` | Fast-forward: generate all planning artifacts at once |
| `/opsx:apply` | Implement tasks from tasks.md |
| `/opsx:verify` | Validate implementation matches artifacts (completeness, correctness, coherence) |
| `/opsx:sync` | Merge delta specs into main specs |
| `/opsx:archive` | Archive a completed change (merges deltas, moves to archive folder) |
| `/opsx:bulk-archive` | Archive multiple completed changes at once |
| `/opsx:onboard` | Guided tutorial through the complete workflow |

## Error Recovery

### `/opsx:verify` fails

1. Read the verification output to identify which requirements are unmet
2. Check if the issue is missing implementation or spec drift
3. If implementation is incomplete: resume with `/opsx:apply` or `bd ready`
4. If spec changed during implementation: update the delta specs, then re-verify

### tasks.md and Beads are out of sync

1. Run `bd list` and compare against tasks.md checkboxes
2. Close any Beads tasks that are checked off in tasks.md but still open in Beads
3. Add any tasks that exist in tasks.md but not in Beads
4. Source of truth for scope is tasks.md; source of truth for execution state is Beads

### Agent created wrong dependencies

1. `bd dep remove <child> <parent>` to unwire incorrect edges
2. `bd dep add <child> <parent>` to add correct ones
3. `bd ready` to verify the new ordering makes sense

### Change needs to be abandoned

```bash
# Remove the change folder (specs were never merged)
rm -rf openspec/changes/<change-name>
# If Beads tasks were created, close the epic
bd close <epic-id> --reason "Change abandoned"
```

## CLI Quick Reference

```bash
openspec list                          # Active changes
openspec show <change-name>            # Change details
openspec status --change <name>        # Artifact + task status
openspec validate <change-name>        # Validate spec formatting
openspec archive <change-name>         # Archive via CLI
openspec view                          # Interactive dashboard
openspec update                        # Update tool configs after CLI upgrade
openspec list --json                   # JSON output for scripting
```
