---
name: implementation-evidence-gate
description: "Manual implementation gate that traces approved requirements to code paths, focused tests, and observed verification evidence before completion."
disable-model-invocation: true
---

# Implementation Evidence Gate

Use this skill when a change has behavioral risk or more than one meaningful
code path. It prevents a green existing test suite from being mistaken for
proof that the requested behavior is complete.

## Before editing

Read the approved plan, specification, or bug report and extract only its
normative requirements. For each requirement, keep a small traceability row:

```text
source → required behavior → code path → exact test/check → evidence
```

If no approved source exists, label the requirement baseline `UNVERIFIED` and
do not invent requirements from nearby code or old tests.

Inspect affected tests before changing code. Classify each relevant test as:

- current proof of the requested behavior;
- stale proof of an older behavior;
- useful regression coverage but not proof of this requirement; or
- unrelated.

Passing tests are evidence only for the behavior they explicitly assert.

## During implementation

- Change the smallest code path that satisfies the approved requirements.
- For changed behavior, add or update a focused test that asserts the new
  contract, not merely that the request returns without an error.
- For security or authorization boundaries, cover the relevant decision
  outcomes explicitly: allowed, denied, pending/rejected, and approved
  execution when applicable.
- Test both sides of a boundary and the handoff between validation, policy,
  approval, and execution when those layers are part of the requirement.
- If an old test contradicts the approved behavior, update it as stale rather
  than preserving a green but obsolete oracle.
- If implementation discovers a requirement conflict or scope expansion,
  stop and revise the plan before continuing.

## After implementation

Run the narrowest requirement-specific checks first, then the repository's
broader verification. Map every requirement to observed evidence. Do not
replace a missing focused test with a passing full-suite result.

Report each claim as one of:

- `OBSERVED` — directly proved by code, test output, or runtime evidence;
- `INFERRED` — supported by code but not directly exercised;
- `UNVERIFIED` — required but lacking proof;
- `PROPOSED` — a recommendation, not implemented behavior.

Do not call an implementation complete while a required row is `UNVERIFIED`.
State the smallest missing test or evidence needed, and distinguish a test
coverage gap from a production defect.

## Keep the gate small

Do not create a new test framework, event ledger, task graph, or abstraction
just to satisfy this skill. A short matrix, focused regression tests, and
honest verification reporting are sufficient.
