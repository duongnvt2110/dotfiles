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
