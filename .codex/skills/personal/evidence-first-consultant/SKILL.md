---
name: evidence-first-consultant
description: Review repositories, plans, and architecture from observed evidence before recommending changes; use when completeness, gaps, or implementation risk matters.
disable-model-invocation: true
---

# Evidence First Consultant

Use this skill for repository assessments, plan reviews, architecture advice,
gap analysis, and release-readiness recommendations. It governs the quality of
the consultant's reasoning and reporting; it does not authorize code or
configuration changes.

## Evidence boundary

Before recommending a design or claiming a feature exists:

1. Inspect the complete user-named scope, its entry points, persistence,
   validators, callers, and relevant tests.
2. Trace the real workflow end to end. Treat plans, reports, passing unit
   tests, and previous conclusions as claims to verify, not implementation
   evidence.
3. Reproduce the reported behavior when practical.
4. Label claims as `OBSERVED`, `INFERRED`, `PROPOSED`, or `UNVERIFIED`.
   Never present an inference or proposal as an observed capability.

## Contract-first audit

When a review compares implementation with a specification or an accepted
decision, establish the contract before looking for cleanup:

1. Resolve sources in this order:
   - current approved specification;
   - later accepted decisions that intentionally change it;
   - reachable repository behavior;
   - tests and reports as supporting evidence, never as the contract itself.
2. Record conflicts between sources instead of silently choosing one. Treat an
   unresolved conflict as `UNVERIFIED` until the applicable decision is known.
3. Trace each user-facing operation end to end:

   ```text
   endpoint -> handler -> use case -> repository -> transaction -> side effect
   ```

4. For every state-changing operation, inspect:
   - checks before the transaction;
   - the row lock or transaction boundary;
   - checks after the lock;
   - fields written and whether the write uses current or stale data;
   - external side effects and failure handling.
5. Compare exact semantics, not approximate intent. Examples include
   `TrimSpace` versus `strings.Fields`, `status` versus `status + end_at`,
   space ownership versus user ownership, and request validation versus
   transaction-time validation.

Layered validation is not automatically redundant:

```text
handler    -> request shape and HTTP error mapping
use case   -> domain rules, authorization, and resource validation
repository -> persistence and mutable invariants rechecked under lock
```

Call a finding confirmed only when the required behavior and a reachable code
path proving the gap are both established. Otherwise classify it as
conditional, adjacent, or unverified rather than turning it into implementation
scope.

## Plan completeness

When reviewing a plan, distinguish source completeness from implementation
traceability. An agent-created ledger is not proof that the plan was fully
captured.

For every normative plan item, establish:

```text
original source → approved requirement → implementation scope → Task
→ check → evidence
```

If the plan is free-form and no approved requirement baseline exists, state
that semantic extraction completeness is `UNVERIFIED`. Do not claim that a
Ledger, checklist, or bidirectional mapping guarantees that no plan item was
omitted. Recommend an approved structured baseline or explicit human approval
of the extracted requirements when completeness matters.

Do not invent a baseline from the plan and then use that same baseline as its
own proof. Check both directions:

```text
plan source → requirement
requirement → plan source
```

Also verify that every requirement has an executable Task, owning source
scope, required check, and current evidence. A passing isolated test cannot
replace an installed or end-to-end workflow test when the request concerns
external agent behavior.

## Recommendation format

For each material finding, report:

| Field | Required content |
|---|---|
| Evidence | Exact file, function, command, record, or test result |
| Classification | `OBSERVED`, `INFERRED`, `PROPOSED`, or `UNVERIFIED` |
| Gap | The precise behavior that is absent or inconsistent |
| Impact | How it can break the requested outcome |
| Smallest fix | Reuse existing models and paths; avoid speculative architecture |
| Proof | Focused test, integration test, and evidence artifact needed |
| Limitation | What the fix still cannot guarantee |

Prioritize confirmed blockers over speculative improvements. Do not add a
second workflow, semantic judge, or new abstraction merely to make the report
look complete.

## Adversarial pass

Before concluding, challenge the recommendation:

```text
What requirement from the original Goal or Plan could still be missing?
What assumption would make this recommendation false?
Does the proposed test exercise the real user-facing workflow?
Could the evidence pass while the intended outcome remains incomplete?
```

If any answer is unresolved, report it as a limitation or blocker. Do not
silently promote it to a fact.
