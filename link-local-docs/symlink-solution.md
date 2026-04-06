# Hardened Solution: External Local Folder + Verified Symlink

## Problem

A local-only folder like `my_docs` inside a Git repo can be deleted by cleanup actions, such as:

- `git clean -fd`
- `git clean -fdx`
- reset/cleanup scripts
- manual deletion in the repo

Goal: keep local docs safe from Git cleanup while still being convenient to access in the project.

---

## Recommended Solution

Store real data outside the repository and keep only a symlink inside the repo.

### Example structure

```text
~/.local/project-data/
  my-project-<repo_key>/
    my_docs/

~/code/my-project/
  my_docs -> ~/.local/project-data/my-project-<repo_key>/my_docs
```

`<repo_key>` is a stable hash of the absolute repo path to prevent collisions between repos that share the same folder name.

---

## Why this works

- Git does not manage the real data directory.
- `git clean -fd` or `git clean -fdx` can remove the symlink, but not the target data.
- Recreating the symlink is fast and deterministic.

---

## Important Git behavior

- `git reset --hard`: does not remove untracked symlink.
- `git clean -fd`: removes untracked symlink, not target data.
- `git clean -fdx`: also removes untracked symlink, not target data.

---

## Helper script (`project-link.sh`)

This script is now included in this repo and provides:

- target directory bootstrap
- symlink creation
- target validation
- `--status` diagnostics
- `--repair` for wrong-target symlinks

### Usage

```bash
./project-link.sh my_docs
./project-link.sh --status my_docs
./project-link.sh --repair my_docs
```

### Environment

- `PROJECT_LOCAL_HOME` (optional): base directory for external project data
- default: `$HOME/.local/project-data`

---

## Operational guardrails

- Keep `my_docs/` ignored in Git if your workflow ever creates a real folder there.
- Prefer a small bootstrap command (`make link-docs` or script call) in project setup docs.
- Back up `$PROJECT_LOCAL_HOME` periodically if the data is important.

---

## Quick verification checklist

- Fresh run creates target + symlink.
- Re-run is idempotent.
- Wrong-target symlink is detected and can be fixed with `--repair`.
- `git clean -fd` removes only link; target survives.
- `git clean -fdx` removes only link; target survives.

---

## Conclusion

For local-only durability on one machine, this is a solid and pragmatic solution.
