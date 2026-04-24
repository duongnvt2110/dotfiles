---
name: karpathy-guidelines
description: >
  Behavioral guidelines to reduce common LLM coding mistakes. Use when writing,
  reviewing, or refactoring code to avoid overcomplication, make surgical
  changes, surface assumptions, and define verifiable success criteria.
---

# Karpathy Guidelines

Behavioral guidelines to reduce common LLM coding mistakes, derived from
[Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876)
on LLM coding pitfalls.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial
tasks, use judgment.

## Trigger Conditions

Use this skill when one or more are true:

- The task involves implementation, bug fixes, review, or refactoring where
  hidden assumptions and overengineering risk quality.
- The user asks for more disciplined execution with minimal, high-signal diffs.

Do not use this skill as primary when:

- The user explicitly requests another planning mode or process
  (`openspec`, `spec-kit-skill`, `phase1-plan-space`, `planner`).
- The task is mainly about version-sensitive third-party API usage; use
  `context7` first.

## 1) Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them. Do not pick silently.
- If a simpler approach exists, say so and push back when warranted.
- If something is unclear, stop and name what is unclear.

## 2) Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No configurability that was not requested.
- No error handling for impossible scenarios.
- If 200 lines can be 50, simplify.

## 3) Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't improve adjacent code, comments, or formatting without request.
- Don't refactor unrelated code.
- Match existing style and patterns.
- If unrelated dead code is found, mention it; don't delete it unless asked.

When your changes create orphans:

- Remove imports/variables/functions your change made unused.
- Don't remove pre-existing dead code unless explicitly requested.

## 4) Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" -> "Write tests for invalid inputs, then make them pass."
- "Fix the bug" -> "Write a test that reproduces it, then make it pass."
- "Refactor X" -> "Ensure tests pass before and after."

For multi-step tasks, state a brief plan:

```text
1. [Step] -> verify: [check]
2. [Step] -> verify: [check]
3. [Step] -> verify: [check]
```

## Interoperability Rules

- Use `brainstorming` first when intent is unclear.
- Use `context7` for external library documentation and version-specific APIs.
- Use domain skills (WordPress, Terraform, frontend, etc.) for specialized
  implementation rules.
- Architecture decision comparison belongs to `rfc-writer`; accepted decisions
  are recorded by `adr-recorder`.
- This skill does not override global safety/reporting/verification rules in
  `AGENTS.md`.

## Usage Patterns

### Pattern 1: Fix a bug with minimal blast radius

Prompt:
"Use Karpathy guidelines to fix this bug."

Expected behavior:

- Restate assumptions and clarify ambiguity before coding.
- Implement only lines needed for the fix.
- Add a reproducible verification step.

### Pattern 2: Implement a small feature without overengineering

Prompt:
"Add this feature and keep it simple."

Expected behavior:

- Choose the minimum implementation that satisfies the request.
- Avoid speculative abstraction/configuration.
- Verify with focused tests/checks.

### Pattern 3: Refactor while preserving behavior

Prompt:
"Refactor this module safely under Karpathy guidelines."

Expected behavior:

- Define behavior-preservation success criteria.
- Make surgical, scoped edits.
- Verify no regressions.

## Examples

For concrete before/after examples, see
`references/examples.md` in this skill package.
