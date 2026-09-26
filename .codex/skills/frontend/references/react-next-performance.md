# React and Next.js Performance

Apply React/Next.js performance guidance only where it affects the requested user-facing path.

## Procedure

1. Inspect rendering/data-fetching boundaries and measure or identify the concrete cost.
2. Reduce unnecessary client work, rerenders, data transfer, or sequential fetching where evidence supports it.
3. Use framework-native server/client boundaries and caching semantics.
4. Avoid memoization or abstraction without a demonstrated benefit.
5. Verify behavior and performance-sensitive paths after the change.
