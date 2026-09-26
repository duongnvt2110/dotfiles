---
name: frontend
description: "Browser UI work for design, responsive layout, React, Next.js, and frontend performance. Use maintained Figma tooling for Figma-specific interpretation."
---

# Frontend

| Need | Reference |
|---|---|
| UI implementation/design quality | `references/design.md` |
| Responsive behavior | `references/responsive.md` |
| React/Next.js performance overview | `references/react-next-performance.md` |
| Detailed React/Next performance rules | `references/react-next-performance/rules/` |

Load individual performance rules only when they apply; do not dump the whole rule pack into context. Use generic engineering methodology for planning, debugging, and verification without changing the primary frontend route.

For a Figma-backed implementation, use the maintained Figma integration first. Use `$figma-cache-fallback` only for cache/throttling recovery.
