---
name: figma-detail-extractor
description: Specialized Figma extraction workflow for deep structured outputs (component specs, layer tables, asset lists, and documentation artifacts). Trigger when users explicitly request detailed extraction/reporting outputs, not code implementation. Prefer cache by default unless user requests no-cache/refetch.
---

# Figma Detail Extractor

Use this skill to produce **deep, structured specs** from Figma nodes. It complements the standard `figma` skill by focusing on **exhaustive property extraction** and **consistent output format**.

## Routing Contract

- Primary role: detailed extraction/reporting from Figma.
- Must trigger when the requested output is spec artifacts (layer tables, detailed measurements, asset manifests, extraction reports).
- Must not trigger when the primary objective is production code implementation; defer to `figma-implement-design` or `figma-implement-design-cache`.
- Must yield to `figma-cache` only when task remains general extraction and user explicitly asks for cache-first operational behavior.

## Core workflow (always follow)
1. **Parse Figma URL(s)** and extract node IDs.
2. **Fetch design context** with MCP:
   - Run `get_design_context` for the target node(s).
   - If response is truncated: run `get_metadata`, then refetch specific node(s) with `get_design_context`.
3. **Fetch visuals**: run `get_screenshot` for each primary node.
4. **Assets**:
   - Use MCP asset endpoints when available.
   - If MCP does not provide assets, use **agent-browser** to export SVG/PNG.
5. **Generate outputs** using the templates in `references/figma-detail-output-format.md`.

## Cache policy
- **Prefer cache by default.**
- If the user says "do not use cache" or "refetch", bypass cache.

## Output contract
Produce **all** of the following unless the user requests otherwise:
- **Component spec blocks** (structured bullets)
- **Layer table summary** (name/type/size/key styles)
- **Summary + reuse notes** (high-level layout and reuse opportunities)
- **Asset list** (exported images/SVGs + file paths)

## Notes
- Favor exact values over approximations (px, colors, font sizes, line height, spacing).
- If a property is ambiguous, say so explicitly and cite the node/layer.
- Keep output concise but complete; avoid redundant restatements.

## References
- `references/figma-detail-output-format.md`
