# Terraform Modules

Use for module boundaries, composition, interfaces, and repository structure.

## Procedure

1. Determine whether the change belongs in a resource module, higher-level infrastructure module, or composition.
2. Keep module inputs/outputs focused and stable.
3. Separate reusable modules from environment-specific composition.
4. Use examples/tests to demonstrate module behavior where the repository supports them.
5. Avoid module abstraction that exists only for hypothetical reuse.

## Guardrails

- Terraform remains the primary route; generic engineering design/planning may support it.
