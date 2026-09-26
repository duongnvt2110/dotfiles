# Codex Skill Reduction Plan

> **Status:** Historical first-batch plan. The current refactor uses the five-router architecture (`engineering`, `terraform`, `wordpress`, `frontend`, `figma`). The earlier four-change scope lock below is retained as history and is no longer the active migration boundary.


## Goal

Reduce the number of active Codex skills and the amount of automatic skill-routing noise without losing useful workflows.

The guiding rule is:

> Archive first. Do not delete skills during cleanup.

Skills that are removed from the active catalog should be moved outside `.codex/skills/` so Codex no longer discovers them automatically, while keeping them easy to inspect and restore.

## Current Baseline

The current catalog contains:

- 102 non-system `SKILL.md` files.
- 87 model-invocable skills that can participate in automatic routing.
- 15 manual-only skills with `disable-model-invocation: true`.

From the August-September rollout history scanned before this cleanup:

- 27 of 102 current non-system skills had direct `SKILL.md` load evidence.
- 75 of 102 had no direct load evidence in that window.
- 25 of 87 model-invocable skills had direct load evidence.
- 62 of 87 model-invocable skills had no direct load evidence.

Across the available 2026 rollout history, 49 of the current 102 skills had direct-load evidence and 53 did not.

Zero observed usage alone is **not** enough reason to archive a skill. Usage is one signal combined with overlap, routing quality, obsolescence, and whether the skill is broken or superseded.

Codex has also reported that skill descriptions were shortened to fit the skill-context budget, so reducing the automatically advertised catalog has a concrete benefit.

## Target State

Aim for approximately:

```text
Current
102 non-system skills
87 auto-discoverable

        ↓

Target
~45-55 active skills
~20-30 auto-discoverable skills
```

The target is not a hard quota. Stop reducing once routing is clear and the context-budget problem is resolved.

## Directory Layout

Do not create an archive inside `.codex/skills/`, because recursive skill discovery may still find the archived `SKILL.md` files.

Use a sibling directory instead:

```text
.codex/
├── skills/                 # active skills
│   ├── planner/
│   ├── diagnosing-bugs/
│   └── ...
│
└── skills-archive/         # inactive skills; not part of skill discovery
    ├── plan-harder/
    ├── mattpacook/
    └── ...
```

Restore a skill by moving it back into `.codex/skills/`.

## Skill States

Every skill should end in one of four states.

### AUTO

Keep under `.codex/skills/` and allow automatic model invocation.

Use for workflows that are:

- frequently useful;
- clearly distinct;
- easy to route from their descriptions;
- worth spending global skill-context budget on.

### MANUAL-ONLY

Keep under `.codex/skills/`, but set:

```yaml
disable-model-invocation: true
```

Use for valuable but niche workflows that should only run when explicitly requested.

### OPTIMIZE / MERGE

Keep the useful behavior, but merge overlapping modes into one active skill.

Examples:

- `plan-harder` becomes a deep-planning mode inside `planner`.
- Figma cache behavior becomes a mode inside the normal Figma skills.

After the useful behavior is merged, move the superseded skill into `.codex/skills-archive/`.

### ARCHIVE

Move outside `.codex/skills/` when the skill is:

- superseded;
- a proven duplicate;
- broken or incomplete;
- no longer aligned with the current workflow;
- unnecessary after its durable rules have moved to `AGENTS.md` or another active skill.

Do not delete the archived directory.

## Evidence Rules

Do not use this rule:

```text
0 uses => archive
```

Use this decision model instead:

```text
duplicate + superseded + low/no recent usage
        → ARCHIVE

niche + valuable + low usage
        → MANUAL-ONLY

frequently used + overly broad trigger
        → OPTIMIZE trigger

frequently used + distinct responsibility
        → KEEP AUTO

always-on behavioral policy
        → move policy to AGENTS.md/hooks, then ARCHIVE skill
```

## First Reduction Batch

The first batch is intentionally limited to **four** high-confidence changes.
No other skill may be moved, merged, disabled, or archived as part of this batch.

### 1. `mattpacook/engineering/diagnose`

**Action:** archive.

Evidence:

- overlaps heavily with `mattpacook/engineering/diagnosing-bugs`;
- old skill was used in June/July;
- `diagnosing-bugs` replaced it in August/September;
- the newer skill contains the stronger version of the diagnosis workflow.

Target:

```text
.codex/skills/mattpacook/engineering/diagnose
        ↓
.codex/skills-archive/mattpacook/engineering/diagnose
```

Keep `mattpacook/engineering/diagnosing-bugs` active.

### 2. `plan-harder`

**Action:** merge, then archive.

`plan-harder` describes itself as a planning-depth modifier rather than a standalone planner. Preserve only its unique deep-planning rules inside `planner`.

Target behavior:

```text
planner
├── normal planning
└── deep mode when explicitly requested
```

Then move:

```text
.codex/skills/plan-harder
        ↓
.codex/skills-archive/plan-harder
```

### 3. `mattpacook/engineering/to-issues`

**Action:** archive.

Keep `to-tickets` as the explicit/manual workflow.

Reason:

- substantial overlap;
- `to-tickets` already has the more deliberate manual-only boundary;
- no need for both to compete in automatic routing.

### 4. `find-skills`

**Action:** make manual-only. Do not archive it in the first batch.

Reason:

- its automatic trigger is broad;
- its purpose is to find and install more skills, which works against reducing the active catalog;
- explicit use such as "find me a skill for X" remains useful.

Smallest change:

```yaml
disable-model-invocation: true
```

Archive `find-skills` later only if subsequent usage evidence shows that the manual workflow is unnecessary.

## Conditional Candidates

The following candidates are **not approved for the first batch**. They may be changed only after the first batch is verified and new evidence proves the change is necessary.

### `mattpacook/engineering/to-prd`

Potential action: archive in favor of manual `to-spec`.

Condition:

- verify that `to-spec` covers the workflows actually needed; and
- confirm there is no recent or explicit need for a separate PRD-producing workflow.

### `khuym/exploring`

Potential action: archive.

Condition:

- re-confirm that its required Khuym handoffs are still missing or unusable; and
- confirm no active workflow depends on it.

### `khuym/executing`

Potential action: archive.

Condition:

- re-confirm the incomplete Khuym dependency chain; and
- confirm no active workflow depends on it.

All other cleanup candidates in this document are also conditional unless they are one of the four explicitly listed in the first batch.

## Figma Consolidation

**Conditional candidate only.** Do not implement this as part of the approved first batch. Re-evaluate it after first-batch verification and proceed only if Figma routing duplication remains a demonstrated problem.

Current:

```text
figma
figma-cache
figma-implement-design
figma-implement-design-cache
figma-detail-extractor
```

Target:

```text
figma
├── normal mode
└── cache-first mode

figma-implement-design
├── normal mode
└── cache-first mode

figma-detail-extractor
```

After merging cache-specific behavior, archive:

```text
figma-suite/figma-cache
figma-suite/figma-implement-design-cache
```

Do not discard their useful fallback/cache instructions before moving them.

## Behavioral Skills

Behavioral policy should normally be always-on rather than dependent on skill routing.

### `karpathy-workflow`

Potential action: archive after migration verification. This is conditional and is not approved in the first batch.

Its core rules now substantially overlap with:

```text
AGENTS.md
+
Ponytail
+
Scope Guard
```

Before archiving it, verify that every unique rule worth retaining already exists in an always-on layer.

### `personal-agent-workflow`

Do **not** archive immediately.

It has recent usage and contains personal workflow conventions. First compare it against `AGENTS.md` and migrate only the durable rules that are still missing.

Then archive the skill once the always-on policy is complete.

## `brainstorming`

**Conditional optimization candidate.** Keep it unchanged during the first batch. Consider narrowing its automatic trigger only after the first-batch results are reviewed and broad triggering is still demonstrated to be a routing problem.

It is one of the most frequently loaded skills, but its current instruction is too broad when it requires brainstorming before nearly every creative or configuration change.

Target routing intent:

```text
Use brainstorming when requirements, product choices, or design decisions are genuinely ambiguous and multiple viable approaches need discussion before implementation.
```

It should not automatically block:

- normal bug fixes;
- small configuration changes;
- implementation from an already-approved plan;
- straightforward maintenance work.

High usage is not automatically evidence that the trigger is good; an overly broad trigger can itself create high usage.

## Domain Skill Strategy

Do not mass-archive WordPress or Terraform specialists in the first pass.

Prefer a router/general skill for automatic discovery and keep specialists available behind it or as manual-only skills.

### WordPress

Potential target:

```text
AUTO
└── wordpress-router

SPECIALIST / MANUAL
├── wp-project-triage
├── wp-plugin-development
├── wp-block-development
├── wp-block-themes
├── wp-rest-api
├── wp-performance
├── wp-wpcli-and-ops
├── wp-phpstan
├── wp-playground
├── wp-interactivity-api
├── wp-abilities-api
└── wpds
```

Do not implement this conversion until the first reduction batch has been verified.

### Terraform

Potential target:

```text
AUTO
└── terraform-skill-codex

SPECIALIST / MANUAL
├── terraform-test
├── terraform-style-guide
├── terraform-stacks
├── terraform-search-import
├── refactor-module
├── provider-actions
├── provider-resources
├── provider-test-patterns
├── run-acceptance-tests
├── new-terraform-provider
└── aws-ami-builder
```

Provider-development skills are especially good manual-only candidates because they are specialized and currently show little direct usage.

## Matt Pocock Collection

The Matt Pocock collection is the largest source of catalog volume and is a candidate for a dedicated second-pass review. Do not modify it beyond the explicitly approved first-batch skills unless a later evidence review authorizes additional changes.

Current size: roughly 37 skills.

Likely active core:

```text
diagnosing-bugs
code-review
tdd
codebase-design
writing-for-agents
research          # review against deep-research first
grilling          # only if still part of the preferred workflow
```

Useful manual workflows can remain without consuming automatic-routing budget, for example:

```text
to-spec
to-tickets
implement
ask-matt
```

Do not mass-move the remaining Matt skills until each one is classified as AUTO, MANUAL-ONLY, MERGE, or ARCHIVE.

## Implementation Sequence

### Phase 1 — Create archive boundary

Create:

```text
.codex/skills-archive/
```

Ensure this directory is tracked by the dotfiles repository but is not under `.codex/skills/`.

Do not modify Codex discovery logic.

### Phase 2 — First high-confidence reduction

Implement only:

1. archive `mattpacook/engineering/diagnose`;
2. merge `plan-harder` into `planner`, then archive `plan-harder`;
3. archive `mattpacook/engineering/to-issues`;
4. make `find-skills` manual-only.

**Scope lock:** do not modify, move, merge, disable, or archive any other skill in this phase.

Stop and inspect the diff before doing anything else.

### Phase 3 — Verify

Check:

- active skill count decreased as expected;
- archived skills are no longer advertised by Codex;
- retained replacement skills still load correctly;
- no broken relative references were introduced;
- Codex startup/session output no longer reports, or reports less frequently, that skill descriptions were shortened to fit the context budget.

Use Codex normally before expanding the cleanup.

### Phase 4 — Conditional second pass

Do not start a second cleanup batch automatically. Review the first-batch results first.

A later change is allowed only when it has fresh evidence for all of the following:

1. **REACHABLE** — the skill actually participates in, or interferes with, current routing/workflows;
2. **RELEVANT** — changing it would improve the skill-reduction goal;
3. **NECESSARY** — leaving it active materially preserves duplication, routing ambiguity, a broken workflow, or the context-budget problem.

Potential second-pass candidates include:

- `mattpacook/engineering/to-prd`;
- `khuym/exploring`;
- `khuym/executing`;
- the Figma cache variants;
- `karpathy-workflow`;
- `personal-agent-workflow`;
- WordPress/Terraform automatic-routing reductions;
- the remaining Matt Pocock collection.

Treat these as candidates, not approved work. Each requires a separate evidence review before implementation.

Stop when the active catalog is clear and the routing/context-budget problem is solved. Do not chase a numerical target for its own sake.

## Rollback

Every cleanup action should be reversible with a move.

Example:

```sh
mv .codex/skills-archive/plan-harder .codex/skills/
```

For merged skills, the archived original remains available for comparison until the new path has been used successfully.

## Out of Scope

Do not add the following unless a concrete failure proves they are necessary:

- automatic skill deletion;
- a skill database;
- a daemon or watcher;
- an LLM skill judge;
- new MCP tooling;
- runtime skill scoring;
- a dashboard;
- automatic archive/restore logic.

The cleanup should remain a repository-level organization change.

## Success Criteria

The work is complete when:

1. obvious duplicate and broken skills are outside the active skill tree;
2. niche workflows no longer compete unnecessarily in automatic routing;
3. important workflows remain available either automatically or manually;
4. no skill was permanently deleted;
5. archived skills can be restored with a simple move;
6. Codex has a smaller and clearer automatic skill catalog;
7. the skill-context truncation problem is reduced or eliminated;
8. no further cleanup is performed without evidence that it is necessary.
