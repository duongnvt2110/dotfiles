---
name: terraform
description: "Terraform/OpenTofu work for HCL, modules, providers, testing, state/import, refactoring, and stacks. Do not trigger for generic cloud work."
---

# Terraform

Use this skill as the domain router. Load a short summary first and deeper material only when the task needs it.

| Need | Summary | Deep material |
|---|---|---|
| Style / HCL conventions | `references/style.md` | `references/general/` |
| Module composition | `references/modules.md` | `references/general/module-patterns.md` |
| Provider development | `references/providers.md` | `references/general/` + `assets/new-provider/` |
| Provider resources | `references/provider-resources.md` | `references/general/` |
| Provider actions | `references/provider-actions.md` | `references/general/` |
| Terraform/provider testing | `references/testing.md` | `references/provider-testing/` + `references/general/testing-frameworks.md` |
| Acceptance tests | `references/acceptance-testing.md` | `references/provider-testing/` |
| Refactor modules | `references/refactoring.md` | `references/general/module-patterns.md` |
| Import existing resources | `references/import.md` | `references/import/` + `scripts/list_resources.sh` |
| Terraform Stacks | `references/stacks.md` | `references/stacks/` |

For debugging/planning/verification procedure, apply the relevant engineering method without changing the primary Terraform route.
