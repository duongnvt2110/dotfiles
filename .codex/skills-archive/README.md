# Archived Codex Skills

This directory holds inactive skill packages preserved outside normal skill
discovery. Packages remain available because their references, scripts, assets,
or specialized instructions may still be useful.

## Current replacement map

| Archived area | Active destination |
|---|---|
| `terraform/`, including former specialist packages | `../skills/terraform/` and its `references/`, `scripts/`, and `assets/` |
| `wordpress/` and `wordpress-router/` | `../skills/wordpress/` and its `references/` and `scripts/` |
| `figma-suite/` and `figma-local-router/` | Maintained external Figma integration; local cache recovery is `../skills/figma-cache-fallback/` |
| `frontend-design/`, `frontend-responsive-design-standards/`, and React rules | `../skills/frontend/` and its reference rules |
| `mattpacook/`, `khuym/`, planning, research, review, and workflow variants | `../skills/engineering/` references or explicit manual workflows such as `planner` and `evidence-first-consultant` |
| `sops/` | `../skills/personal/sops/` |
| `teach/`, `questionnaire/`, and wizard-style utilities | `../skills/manual-wizard/` or explicit manual use when no active replacement exists |

The active catalog and routing status are recorded in
`../../my_docs/2026_09_16_codex_skill_routing_matrix.md`.

## Restore policy

Restore a package only when an active route is missing a needed instruction,
script, asset, or explicit manual workflow. Preserve the package-local
resources when restoring it; do not copy only `SKILL.md` unless the resources
are proven unnecessary.

Restore a package with its original relative path:

```sh
rtk mv .codex/skills-archive/<path> .codex/skills/<path>
```

After restoration, validate the package, inspect its invocation policy, and
check for trigger overlap before making it automatic. A restore is not a
reason to delete the archived copy until the replacement is verified.

## Boundaries

- Archive contents are inactive and should not be treated as routed skills.
- `.system` skills are managed separately and are not archived here.
- Runtime trigger selection is not proven by this index; fresh-session checks
  remain required.
