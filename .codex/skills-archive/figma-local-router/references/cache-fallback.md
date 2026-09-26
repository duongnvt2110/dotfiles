# Figma Cache Fallback

Use cached Figma data only when direct inspection is unavailable or intentionally avoided.

## Procedure

1. Prefer fresh/direct Figma evidence when available.
2. Confirm the cached artifact corresponds to the requested file/frame/version closely enough for the task.
3. State when the answer relies on cache and what may be stale.
4. Return to the normal inspect/extract/implement flow once usable data is available.

## Guardrails

- Cache is a fallback strategy, never a routing decision.

## Migrated from

- `figma-suite/figma-cache`
- `figma-suite/figma-implement-design-cache`

The original skill files remain manual-only during routing verification and are the rollback source until final archival.
