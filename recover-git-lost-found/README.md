# Recover Git Lost-Found

This folder contains a helper script to export unreachable Git objects found
by `git fsck --lost-found` into readable files.

## Script

- `export-lost-found-objects.sh`

## What It Does

1. Runs `git fsck --full --no-reflogs --unreachable --lost-found`.
2. Reads object SHAs from `.git/lost-found/other/*`.
3. Exports each object content with `git cat-file -p`.
4. Renames each exported file to include:
   - Object SHA
   - Content-based slug
   - Best-effort extension by detected content type

Output is written to:

- `recovered-lost-found/`

## Output Naming

Generated files follow this pattern:

- `lost-found-object-<sha>-<slug>.<ext>`

Examples:

- `lost-found-object-a1b2c3d4-fix-login-flow.patch`
- `lost-found-object-9e8f7a6b-package-json.json`

If a name already exists, the script appends `-1`, `-2`, etc.

## Usage (Local)

Run from the repository root:

```sh
bash recover-git-lost-found/export-lost-found-objects.sh
```

Or make it executable:

```sh
chmod +x recover-git-lost-found/export-lost-found-objects.sh
./recover-git-lost-found/export-lost-found-objects.sh
```

## Setup Global Command

Install a global command into `~/.local/bin`:

```sh
bash recover-git-lost-found/scripts/setup-recover-git-lost-found.sh
```

Then run from any Git repository:

```sh
recover-git-lost-found
```

## Makefile Shortcuts

From `recover-git-lost-found/`:

```sh
make setup    # install global command into ~/.local/bin
make run      # run recovery (global command, fallback to local script)
make check    # syntax-check scripts
```

## Notes and Limits

- Current scope is `.git/lost-found/other/*` only.
- Extension detection is heuristic and may not always be exact.
- Binary-like objects may be saved with `.bin`.
