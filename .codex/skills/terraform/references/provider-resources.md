# Provider Resources

Implement provider resources with correct schema, lifecycle, state, import, and diagnostics behavior.

## Procedure

1. Inspect a similar resource in the same provider.
2. Define schema/state semantics before implementation.
3. Implement create/read/update/delete behavior only where supported.
4. Handle IDs/import/state transitions consistently.
5. Add focused unit/acceptance coverage appropriate to the provider.
