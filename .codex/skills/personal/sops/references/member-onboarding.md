# Member Onboarding

Onboard a developer's **local machine** for sops+age, so they can decrypt
project secrets once an admin registers their identity in `.sops.yaml`.
Works the same for terraform and helm/k8s projects — the only thing that
differs is whether helm plugins get installed (step 1). No project
directory required, no repo files touched.

## Scope: machine tooling + identity setup only

- Installs CLI tools/plugins on the local machine (step 1).
- Step 2 sets up the local decryption identity only after explicit user
  confirmation. Never run it unasked.
- Never reads, prints, uploads, or transmits identity secret material —
  only the value meant for the admin is ever shown, for the user to copy.
- Never touches any project's `.sops.yaml`, `key_groups`, Makefile, or
  values files — project bootstrap is outside this workflow.
- Never registers the printed value in `.sops.yaml` itself — the user or a
  project admin does that by hand.
- Out of scope: project bootstrap, marking/encrypting secrets;
  recipient administration is handled by
  [the admin key-management procedure](admin-key-management.md).

## Workflow

### 0. Track the workflow first

Track one task per numbered step (1-3) with the host's native task tracker.
Mark a task in progress immediately before starting it and complete
immediately after. If no tracker is available, keep an explicit checklist.
Never batch or skip a step, even when it is a no-op; record the no-op
instead.

### 1. Install dependencies

```bash
bash <this-skill-dir>/scripts/install-sops-age-dependencies.sh
```

Always installs `sops`/`age`/`uv`. `helm-secrets`/`helm-diff` are only
installed if `helm` is already on the machine — printed as `skipped (helm
not installed)` on a terraform-only machine, since those plugins are
irrelevant there. Prints one `<name>: installed|already-present|skipped
(...)` line per dependency. Exit 1 with an explanation on stderr if it
can't proceed (e.g. no package manager) — relay that to the user and
stop. Safe to re-run.

### 2. Ask, then set up the local identity

Ask whether the user wants their local decryption identity set up now.
Offer "Yes, set up now" and "No, skip". Use the host's choice-prompt
tool when available; otherwise ask the question directly.

- **No**: skip the rest, note it as skipped, move to step 3.
- **Yes**, run immediately, no further prompts:

  ```bash
  bash <this-skill-dir>/scripts/setup-age-identity.sh
  ```

  Prints only the value meant for the project admin on stdout. Never read
  or print anything else the script may have created. The script alone
  decides the identity file's path — `$SOPS_AGE_KEY_FILE` if the user
  already has it set, else sops/age's own default location — this skill
  never hardcodes or surfaces that path itself.

- Show the user that value and tell them to send it to whoever
  administers the target project's `.sops.yaml` (or, if they are the
  admin, to register it themselves and run the reencrypt workflow).
- This skill never edits any `.sops.yaml` itself.

### 3. Report and stop

- Summarize what changed locally (tools/plugins installed or already
  present).
- If identity setup ran: confirm it succeeded and repeat the value for the
  admin. If skipped: note it and remind them that value is needed before
  they can decrypt project secrets.
- Adding the value to a project and initial project secret-marking remain
  outside this mode; recipient management is handled by the admin mode.
