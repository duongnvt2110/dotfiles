---
name: http-smoke-test
description: Run API smoke scenarios from a repository's existing http/ collection against its local runtime; use for endpoint, auth, request-flow, and persisted-side-effect verification, not unit tests.
---

# HTTP Smoke Test

Use this skill when a repository already contains `.http` requests, environment
files, login hooks, or scenario collections and the user asks to verify the
running API through HTTP.

## Source of truth

- Inspect `http/` first. Read `http/http-client.env.json`, the selected
  environment, the login/auth request, and the target scenario file.
- Reuse the collection's variables, request hooks, dependency order, expected
  status codes, and response assertions.
- Do not treat hardcoded IDs as fresh fixtures. Create or discover valid local
  IDs when the collection requires state, then update the runner variables or
  record the substituted values without persisting tokens.
- Do not create a second smoke-test collection unless the user asks for one.

## Missing scenarios

Before running a requested smoke plan, compare its acceptance cases with the
existing scenario groups. If a required case is missing:

- add it to the existing `.http` file for that API area;
- place it under the correct existing group/section, such as auth, list/detail,
  create, vote, option, or error coverage;
- follow the file's naming, headers, variable, response-hook, and expectation
  conventions;
- use dynamic response variables for IDs created by earlier requests instead
  of copying stale IDs from the environment file;
- add only the missing request/assertion; do not rewrite unrelated scenarios or
  create a parallel collection.

After adding a case, run that request through the collection runner when one is
available. If no runner exists, syntax-check the file and report the case as
added but unexecuted rather than silently replacing collection verification
with curl.

## Runner selection

1. Use the HTTP runner already documented by the repository.
2. If it is not documented, detect an installed compatible runner (for example
   Kulala or HTTPyac) before choosing a fallback.
3. Execute the existing `.http` requests through that runner whenever
   possible. This verifies both the API and the collection's variables/hooks.
4. If no runner is available, direct HTTP requests are an explicit fallback
   only. Report them as API smoke tests, not as execution of the `.http`
   collection, and state which collection assertions were not exercised.

Never print access tokens, refresh tokens, space tokens, cookies, signed URLs,
or credential-file contents. Keep them in runner globals or shell-local
variables only.

## Runtime

- Read the repository's Compose file and reuse the existing local services.
- Prefer `docker compose ... ps` and existing containers with `--no-recreate`.
- Wait for the API, database, auth/emulator, object storage, and required job
  services before sending requests.
- Do not run unrelated services such as OpenSearch unless the selected smoke
  scenario requires them.
- Do not use `down -v`, delete volumes, reset the whole database, or alter
  production-like data unless explicitly authorized.

## Execution

Run the smallest scenario chain that proves the requested behavior:

```text
login/auth setup
  -> space/environment setup
  -> create or discover valid fixture
  -> target request(s)
  -> response assertion
  -> persisted side-effect assertion when required
```

For stateful scenarios:

- Prefer fresh local fixtures over stale IDs.
- Assert both HTTP contract and the specific side effect required by the plan.
- For expiration, voting, attachment, or storage scenarios, inspect the
  local database/object-storage state only when the plan requires it.
- If a test temporarily changes local configuration or a plan limit, record
  the original value and restore it in a guaranteed cleanup path.
- Avoid sleep-based polling when the repository exposes a deterministic status
  or readiness check; otherwise use a bounded timeout and report it.

For image/upload flows, follow the repository's existing sequence:

```text
presigned upload request
  -> upload with the correct content type
  -> attachment record creation
  -> wait for processing completion
  -> reference the uploaded-file ID in the target API request
```

## Reporting

Report:

- runner and collection files actually executed;
- Compose services and environment used;
- each scenario's HTTP result and important persisted side effect;
- whether tests used fresh or pre-existing IDs;
- skipped scenarios and why;
- local data/configuration left behind and any restored values.

Keep unit-test results separate from HTTP smoke results. A passing direct curl
fallback does not prove that the repository `.http` collection itself works.
