# Terraform Style

Apply readable, repository-consistent HCL and Terraform conventions.

## Procedure

1. Run/expect standard formatting for changed HCL.
2. Use descriptive resource/module names and consistent block ordering.
3. Prefer expressions and locals that clarify intent rather than hiding dependencies.
4. Avoid unnecessary `depends_on` and lifecycle exceptions; justify them from behavior.
5. Keep version/provider constraints explicit and consistent with the repository.
