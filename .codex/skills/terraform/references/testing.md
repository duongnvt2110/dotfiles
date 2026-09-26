# Terraform Testing

Choose the narrowest test layer that proves Terraform/provider behavior.

## Procedure

1. Run formatting/validation first when relevant.
2. Use unit or framework tests for local logic.
3. Use plan-based/module tests for configuration behavior.
4. Use provider acceptance tests only when real API behavior must be proven.
5. Keep fixtures deterministic and cleanup explicit.

## Guardrails

- Do not replace behavior requirements with whatever an existing test happens to assert.
