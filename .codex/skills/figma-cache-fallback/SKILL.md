---
name: figma-cache-fallback
description: "Manual Figma MCP fallback for cache-first retries and 429 asset export via agent-browser when normal Figma access is throttled."
disable-model-invocation: true
---

# Figma Cache Fallback

Use this only when the normal Figma workflow is throttled, the user explicitly requests cache-first behavior, or an asset fetch fails with HTTP 429.

## Workflow

1. Keep the normal Figma integration as the primary source of design context.
2. Prefer cached MCP responses when available.
3. Retry only the exact missing node or asset; do not refetch the whole file unnecessarily.
4. If asset export is throttled with 429, use `agent-browser` only for the missing assets.
5. Return to the normal implementation workflow after the missing context/assets are recovered.

Do not use this as a general Figma router or design-to-code workflow.

For MCP setup/tool details, read `references/figma-mcp-config.md` or `references/figma-tools-and-prompts.md` only when needed.
