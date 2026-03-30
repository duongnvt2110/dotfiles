---
name: figma-cache
description: Cache-first variant of the general Figma MCP workflow with 429 asset fallback via agent-browser. Trigger only when the user explicitly asks for cache-first behavior, reliable cached extraction, or retry/throttling mitigation. Do not trigger for generic non-cache Figma requests.
---

# Figma MCP (Cache-First)

Use the Figma MCP server for Figma-driven implementation. This fork prefers cached responses and falls back to agent-browser for asset export when MCP is throttled.

For setup and debugging details (env vars, config, verification), see `references/figma-mcp-config.md`.

## Routing Contract

- Primary role: cache-first general Figma workflow.
- Must trigger when user asks for cache-first behavior, reliability under throttling, or explicit cached retries.
- Must yield to `figma-implement-design-cache` when the task is explicit design-to-code implementation and cache-first is requested.
- Must yield to `figma-detail-extractor` when the requested output is a structured extraction report/spec, not implementation.
- Must not trigger for generic Figma requests without cache intent; defer to `figma`.

## Figma MCP Integration Rules
These rules define how to translate Figma inputs into code for this project and must be followed for every Figma-driven change.

### Required flow (do not skip)
1. Run get_design_context first to fetch the structured representation for the exact node(s).
2. If the response is too large or truncated, run get_metadata to get the high-level node map and then re-fetch only the required node(s) with get_design_context.
3. Run get_screenshot for a visual reference of the node variant being implemented.
4. Only after you have both get_design_context and get_screenshot, download any assets needed and start implementation.
5. Translate the output (usually React + Tailwind) into this project's conventions, styles and framework. Reuse the project's color tokens, components, and typography wherever possible.
6. Validate against Figma for 1:1 look and behavior before marking complete.

### Cache policy (default)
- Prefer cache for all MCP calls.
- If the user says "no cache" or "refetch", bypass cache and re-run MCP calls.

### Asset handling (429 fallback)
- Use MCP assets endpoint first.
- If asset download fails with **429** or throttling, use **agent-browser** to export only the missing assets.
- Do not use placeholders when assets can be exported.

### Implementation rules
- Treat the Figma MCP output (React + Tailwind) as a representation of design and behavior, not as final code style.
- Replace Tailwind utility classes with the project's preferred utilities/design-system tokens when applicable.
- Reuse existing components (e.g., buttons, inputs, typography, icon wrappers) instead of duplicating functionality.
- Use the project's color system, typography scale, and spacing tokens consistently.
- Respect existing routing, state management, and data-fetch patterns already adopted in the repo.
- Strive for 1:1 visual parity with the Figma design. When conflicts arise, prefer design-system tokens and adjust spacing or sizes minimally to match visuals.
- Validate the final UI against the Figma screenshot for both look and behavior.

### Asset handling (baseline)
- The Figma MCP Server provides an assets endpoint which can serve image and SVG assets.
- IMPORTANT: If the Figma MCP Server returns a localhost source for an image or an SVG, use that image or SVG source directly.
- IMPORTANT: DO NOT import/add new icon packages, all the assets should be in the Figma payload.
- IMPORTANT: do NOT use or create placeholders if a localhost source is provided.

### Link-based prompting
- The server is link-based: copy the Figma frame/layer link and give that URL to the MCP client when asking for implementation help.
- The client cannot browse the URL but extracts the node ID from the link; always ensure the link points to the exact node/variant you want.

## References
- `references/figma-mcp-config.md` — setup, verification, troubleshooting, and link-based usage reminders.
- `references/figma-tools-and-prompts.md` — tool catalog and prompt patterns for selecting frameworks/components and fetching metadata.
