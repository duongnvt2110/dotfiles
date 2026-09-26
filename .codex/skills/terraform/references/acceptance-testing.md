# Terraform Acceptance Testing

Use real-provider acceptance tests only when integration with the actual API must be verified.

## Procedure

1. Confirm required credentials/environment and isolate test resources.
2. Use repository naming and precheck conventions.
3. Cover create/read and requested update/import behavior.
4. Ensure cleanup/import verification is included when relevant.
5. Do not run destructive/expensive tests without the expected repository safeguards.
