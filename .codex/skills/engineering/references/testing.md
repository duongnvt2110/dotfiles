# Testing

Choose the narrowest test level that can prove the requested behavior. Testing is evidence for a requirement, not a substitute for understanding the requirement.

## Procedure

1. Identify the behavior or risk being proved.
2. Choose the lowest test level that exercises the real boundary:
   - unit for pure logic and local invariants;
   - integration for real database/cache/broker/service boundaries;
   - contract for producer/consumer API compatibility;
   - end-to-end for user-visible workflows that cross multiple components;
   - property/fuzz for broad input-space or parser/invariant risks;
   - race/concurrency tests when ordering, locking, retries, or shared state matter.
3. Reuse the repository's existing harness before introducing new infrastructure.
4. Make the test deterministic: control time, randomness, fixtures, and external state where practical.
5. Prove the test actually executes the intended code path and can fail for the targeted regression.
6. Run the narrowest focused test first, then broader checks only when useful.

## Test authoring gate

Before adding or changing a test, establish:

1. What observable behavior, invariant, or contract does this test protect?
2. What credible regression would make this test fail?
3. Does existing coverage already prove the same contract?
   - If yes, extend the strongest existing owner-boundary test instead of replaying the same behavior at another layer.
4. Would the test require production-only exports, wrappers, flags, dependency seams, or other code that no production caller needs?
   - If yes, prefer testing through the real observable boundary.

Avoid tests that primarily:

- assert private implementation details rather than behavior;
- duplicate stronger integration, contract, or end-to-end coverage;
- mirror production constants or control flow;
- reproduce expected values by reusing the implementation under test;
- mock the behavior being asserted;
- exist only to increase coverage;
- require test-only production APIs without a demonstrated production need.

A regression test should, when practical:

- fail against the pre-fix behavior for the intended reason;
- pass after the fix;
- live at the strongest boundary that owns the behavior.

## Existing-test changes

Do not modify an existing test merely to make the implementation pass.

First determine which case applies:

- the approved requirement changed -> the test may be stale; update it to the new contract;
- the implementation violates the current contract -> fix production code;
- the test is coupled to an implementation detail -> rewrite it toward observable behavior without weakening the contract;
- the applicable contract is unclear -> report the conflict and resolve the source of truth before changing either side.

Passing tests are evidence, not permission to weaken requirements or preserve obsolete behavior.

## Boundaries

- When runtime API verification should execute an existing `.http` collection, load `http-smoke-testing.md`.
- Use `docker-compose-testing` only when the test materially depends on the Compose environment or services.
- Prefer real dependencies for integration boundaries when mocks would hide the behavior under test.
- Prefer mocks/fakes when the dependency itself is not part of the contract being proved.
- Do not create a new test framework for one change when the repository already has a sufficient harness.

## Completion

Record:

```text
behavior → test/check → observed result
```

Do not call a change verified when the selected test does not exercise the changed behavior.
