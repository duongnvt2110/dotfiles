# HTTP Smoke Testing

Use an existing repository HTTP collection to verify the running API through real request flows. This is a testing procedure inside engineering, not a separate router.

## When to use

Use this procedure when the repository already contains `.http` requests, environment files, request hooks, or documented API smoke scenarios and the task requires runtime HTTP verification.

## Procedure

1. Inspect the repository's HTTP collection and documented runner before executing requests.
2. Reuse existing environments, variables, auth/setup requests, hooks, assertions, and dependency order.
3. Select the smallest scenario chain that proves the requested behavior:

   ```text
   auth/setup
     -> create or discover valid fixture
     -> target request(s)
     -> response assertion
     -> persisted side-effect assertion when required
   ```

4. Prefer fresh local fixtures over stale hardcoded IDs when state matters.
5. Verify both the HTTP contract and any required persisted side effect.
6. Restore temporary local configuration changes in a guaranteed cleanup path.
7. Report the runner, collection files, environment, executed scenarios, results, skipped checks, and local state left behind.

## Runner selection

1. Use the HTTP runner already documented by the repository.
2. If none is documented, detect an installed compatible runner before choosing a fallback.
3. Execute the existing `.http` collection through that runner whenever possible so its variables, hooks, and assertions are exercised.
4. Direct `curl`/HTTP requests are a fallback only. Report them as API smoke checks, not as proof that the repository collection itself works.

## Runtime boundaries

- Reuse the repository's existing local runtime and services.
- If the runtime is Docker Compose-based, use `docker-compose-testing` as supporting execution guidance while this HTTP procedure owns the API scenario semantics.
- Wait for required services to be ready before sending requests.
- Do not start unrelated services unless the selected scenario requires them.
- Do not destroy volumes, reset all data, or alter production-like data without explicit authorization.

## Safety

- Never print access tokens, refresh tokens, cookies, signed URLs, private keys, or credential-file contents.
- Keep secrets in runner globals, environment variables, or other repository-defined secret handling.
- Avoid sleep-based polling when the API exposes a deterministic readiness/status check; otherwise use a bounded timeout and report it.
- Keep unit-test results separate from HTTP smoke results.
