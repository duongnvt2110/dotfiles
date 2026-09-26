---
name: sops
description: >-
  SOPS + age operational workflows for onboarding a member or managing
  recipient keys. Use only for these SOPS-specific security/operations tasks.
---

# SOPS

Use this skill only for SOPS + age operations. Choose exactly one mode:
member onboarding or admin key management. Read only the reference for the
selected mode before following its procedure.

## Shared safety and scope

- Never read, print, upload, or transmit private age identity or key material.
- Use only public recipient keys for recipient administration.
- Get the explicit confirmations required by the selected procedure before
  identity setup or external repository changes.
- Member onboarding is local machine setup only; it does not edit project
  files or bootstrap project secrets.
- Admin key management may edit only `key_groups[].age` in `.sops.yaml` and
  perform the explicitly approved ciphertext re-wrap/push workflow. Never
  merge a PR.

## Modes

- For local SOPS/age tooling and member identity onboarding, read
  [references/member-onboarding.md](references/member-onboarding.md).
- For adding or removing a recipient across private repositories, read
  [references/admin-key-management.md](references/admin-key-management.md).

Do not combine the two procedures in one run.
