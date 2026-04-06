# Project Link

Keep local-only docs (for example `my_docs`) outside your Git repository and access them through a symlink inside the repo.

This protects the real data from common Git cleanup operations (`git clean -fd`, `git clean -fdx`) while keeping your project workflow simple.

## One-Time Setup (Global + zshrc)

Run from this repo:

```bash
make setup
source ~/.zshrc
```

What `make setup` does:

- installs global command: `~/.local/bin/project-link`
- updates `~/.zshrc` idempotently with a managed helper block
- ensures `~/.local/bin` is in `PATH`
- adds helper functions:
  - `link-local-docs [name]`
  - `status-local-docs [name]`
  - `repair-local-docs [name]`

After setup, no per-project script copy is needed.

## Global Usage

Use from any repo:

```bash
project-link link my_docs
project-link status my_docs
project-link repair my_docs
```

## Files

- `project-link.sh`: source script used for both local and global usage
- `scripts/setup-project-link.sh`: setup installer for global command + zshrc updates
- `symlink-solution.md`: design and behavior notes
- `Makefile`: convenience targets

## Requirements

- Bash
- `git` (optional, for repo-root detection)
- `ln`, `readlink`
- `sha1sum` or `shasum`

## Make Targets

- `make setup`: install global command + update `~/.zshrc`
- `make link-local-docs`: create/validate symlink
- `make status-local-docs`: show current link status
- `make repair-local-docs`: repair wrong-target symlink
- `make check`: syntax-check scripts
- `make help`: show available targets

Behavior:

- Makefile tries global `project-link` first.
- If not found, it falls back to local `./project-link.sh`.
- Makefile sets `PROJECT_LINK_ROOT=$(CURDIR)` so links are created for the current project directory.

Compatibility aliases:

- `make link` -> `make link-local-docs`
- `make status` -> `make status-local-docs`
- `make repair` -> `make repair-local-docs`

## Configuration

You can override defaults:

```bash
project-link link notes
PROJECT_LOCAL_HOME=/tmp/project-data project-link status notes
PROJECT_LINK_ROOT=/path/to/your/repo project-link link my_docs

make link-local-docs LINK_NAME=notes
make status-local-docs LINK_NAME=notes PROJECT_LOCAL_HOME=/tmp/project-data
```

Variables:

- `LINK_NAME` (default: `my_docs`, for Make targets)
- `PROJECT_LOCAL_HOME` (default: `$HOME/.local/project-data`)
- `PROJECT_LINK_ROOT` (optional): force the project root path

## Behavior Summary

- Project root is detected from Git top-level when available.
- If not in a Git repo, current directory is used.
- If `PROJECT_LINK_ROOT` is set, it overrides auto-detection.
- If link is missing: create it.
- If link exists and points to expected target: no-op.
- If link exists but points elsewhere: fail with instructions.
- `repair`: replace wrong-target symlink safely.
- If a real directory/file exists at link path: fail safely.

## Verification

```bash
make check
project-link status
```

## Notes

- If the symlink is removed by `git clean`, your external data remains intact.
- Re-run `project-link link` to recreate the symlink.
