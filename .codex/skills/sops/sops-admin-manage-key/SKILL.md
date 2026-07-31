---
name: sops-admin-manage-key
description: Add or remove a recipient key across private repos with .sops.yaml. Re-wrap after a merged PR or direct default-branch change, then push only after explicit approval.
---

Manage one recipient's `.sops.yaml` key across private repos that carry a
root `.sops.yaml`, via one PR per repo and a ciphertext re-wrap.

## Scope: key_groups[].age edits + PR + local reencrypt + approved push

- Step 6 only ever changes `key_groups[].age` in `.sops.yaml` — never
  `path_regex`, `encrypted_comment_regex`, or Makefile.
- Step 8 re-wraps ciphertext locally; it never commits or pushes.
- Step 9 alone commits and pushes re-wrapped ciphertext to a default branch,
  and only after the admin explicitly approves its preview.
- Never merges a PR itself. For an external direct change, re-wrap only from
  the repository's verified default branch.
- Never guesses which repos to touch — candidates always come from the
  read-only listing script; the final target set is the admin's own typed
  selection.
- Out of scope: installing sops/age/helm-secrets, generating an age
  identity (`sops-onboard-new-member`); project-level bootstrap or initial
  marking/encrypting (`sops-bootstrap-helm-project`); verifying is manual
  (`sops -d`).

## Workflow

### 0. Track the workflow first

Track one task per numbered step (1-10). Mark it in progress before starting
and complete immediately after; use an explicit checklist if no tracker exists.

### 1. Ask which action: add or remove a key

Ask: "Add a new recipient's key, or remove an existing one?" Offer add
(grant access) and remove (revoke access); otherwise ask directly.

### 2. List candidate infra private repos

```bash
uv run scripts/list-infra-private-repos.py [--owner <org>]
```

`--owner` defaults to `ExecutionLab`. The script finds every private repo with
`.sops.yaml`, regardless of name. If `gh` is unauthenticated, relay its error
and direct the user to run `gh auth login`; never authenticate for them.

### 3. Admin picks target repos

Print step 2's output as a compact numbered list (repo name only, no
`nameWithOwner`, no descriptions):

```
1. k8s-app-a
2. k8s-app-b
3. k8s-app-c
```

Ask the admin to type repo names (comma-separated) as free text. Permit an
unlisted repo typed directly too.

### 4. Get the target member's public key

Ask for the local file path containing the member's **public** key as
free text; a file path is not a multiple-choice decision. Then:

```bash
cat "<path-the-admin-gave>"
```

Extract the public recipient (may be bare or wrapped in other text): an
`age1...` key, or a complete OpenSSH `ssh-rsa <base64>` or
`ssh-ed25519 <base64>` public-key line. `id_rsa.pub` and `id_ed25519.pub`
are file names; their recipient types are respectively `ssh-rsa` and
`ssh-ed25519`.
Never accept private key material. For `add`, optionally ask for a `# label`;
for `remove`, this value is the key to remove.

### 5. Confirm before touching any repo

This pushes branches and opens real PRs across every repo picked in step
3 — visible, shared-state changes others will see. Summarize the plan in
one line (action, key, repo list) and get explicit confirmation before
proceeding, even under auto mode.

### 6. Per repo: branch, edit, PR

```bash
uv run <this-skill-dir>/scripts/open-age-key-pr-for-repo.py \
  <add|remove> "<nameWithOwner>" "<defaultBranch>" "<public-key>" "<label>"
```

`<label>` optional — omit if declined in step 4. Prints a dry-run preview,
then either a `no-op: ...` line (nothing changed, note it) or the opened
PR URL — collect each as you go.

### 7. Wait for merges or confirm the direct default-branch change

Report PR URLs and stop for review/merge. Never merge on the admin's behalf.
For a direct default-branch change, confirm `.sops.yaml` was already changed
there. Step 8 independently checks each PR or verifies the default branch.

### 8. Reencrypt locally, without commit or push
```bash
uv run <this-skill-dir>/scripts/local-reencrypt-values-after-merge.py [--dry-run] \
  [--age-key-file <path>] [--output-dir <new-empty-directory>] \
  <owner>/<repo>[:<pr-number|default-branch>] [...]
```

Run `--dry-run` first, then for real with a new `--output-dir`. The script
clones each merged PR's base branch there, re-wraps only files matched by
`.sops.yaml`, and writes `sops-reencrypt-manifest.json`. It never commits or
pushes. `--age-key-file` is optional; it defaults to `$SOPS_AGE_KEY_FILE` and
is required only outside dry-run. Read the JSON statuses: `not_merged`,
`would_reencrypt`, `prepared`, `no_files_matched`, `no_change`, or
`reencrypt_error`.

Pass `<owner>/<repo>:<pr-number>` for a PR. For a direct change already on the
default branch, pass `<owner>/<repo>` or `<owner>/<repo>:<default-branch>`;
the script rejects a non-default branch with `not_default_branch`. It also
rejects a merged PR whose base is not the repository's default branch.

### 9. Confirm and push the prepared ciphertext

Show prepared repositories/files and get separate explicit confirmation.
Explain that this commits and pushes ciphertext-only changes directly to each
default branch. Run dry-run first, then real only after confirmation:

```bash
uv run <this-skill-dir>/scripts/push-reencrypted-values-to-default-branch.py \
  --dry-run <output-dir>/sops-reencrypt-manifest.json
uv run <this-skill-dir>/scripts/push-reencrypted-values-to-default-branch.py \
  <output-dir>/sops-reencrypt-manifest.json
```

The push script refuses unexpected or untracked local changes and refuses a
default branch that advanced after preparation. It reports `would_push`,
`reencrypted_and_pushed`, `no_change`, `base_branch_advanced`, or `push_error`.
For `base_branch_advanced`, rerun step 8 before asking for confirmation again.

### 10. Report and stop

- Summarize per repo: PR URL, merge status, local preparation, and approved
  push result (or "no-op — key already in that state").
- Removing a key only stops it decrypting *new* changes — old git history
  is still decryptable by that key; note this if the action was `remove`
  (matches the admin guide's "not a revoke" caveat).
- Bootstrap, marking secrets, and onboarding tooling are separate skills —
  do not continue into them.
