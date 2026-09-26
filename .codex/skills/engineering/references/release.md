# Release

Prepare and validate a safe release without turning implementation completion into automatic deployment.

## Procedure

1. Identify the deployable unit, target environment, and repository-defined release path.
2. Re-read the requested behavior and confirm required checks passed.
3. Inspect compatibility risks that are reachable for this change:
   - API or event contract changes;
   - configuration/environment changes;
   - data/schema changes;
   - dependency/runtime changes;
   - old/new version coexistence during rollout.
4. Determine the smallest safe rollout strategy already supported by the system.
5. Define post-deploy verification using observable behavior, not only deployment status.
6. Define rollback or mitigation conditions before release when failure could affect users or data.
7. Execute deployment only when the user explicitly asks and the repository/environment permits it.

## Guardrails

- Do not invent canaries, feature flags, blue/green deployment, or new release infrastructure without a demonstrated need.
- A successful build or deployment is not proof that the feature works in the target environment.
- Be explicit when rollback is not safe or not sufficient, especially for irreversible data changes.
- Preserve the repository's existing CI/CD and release process unless change to that process is itself requested.

## Release evidence

When reporting a release, separate:

```text
pre-release checks
deployment result
post-deploy verification
rollback/mitigation readiness
remaining risk
```
