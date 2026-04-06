# Dotfiles Workspace

This repository contains personal dotfiles plus automation helpers for Codex and
local workflows.

## Project Layout

```text
.
├── .codex/                  # Agent catalog, skills, rules, prompts, config
├── AGENTS.md                # Working rules for agents in this repository
├── link-local-docs/         # Symlink helper tooling (project-link)
├── recover-git-lost-found/  # Recover/export unreachable git objects
├── scripts/                 # Root-level setup/link helper scripts
└── README.md                # This file
```

## Key Folders

- `.codex/`: Core Codex/Claude automation content. Start with
  `.codex/README.md`.
- `link-local-docs/`: Utilities for creating and repairing local docs symlinks.
  See `link-local-docs/README.md`.
- `recover-git-lost-found/`: Utility to export objects from
  `.git/lost-found/other/*` into readable files. See
  `recover-git-lost-found/README.md`.
- `scripts/`: Local setup scripts such as Codex link helpers.

## Quick Start

Link Codex assets into `~/.codex`:

```sh
scripts/link-codex.sh
```

Install global command for git lost-found recovery:

```sh
cd recover-git-lost-found
make setup
```

Run recovery in any git repository:

```sh
recover-git-lost-found
```

## Notes

- Keep the root minimal; place feature-specific docs in their own folder.
- Do not commit `.codex/auth.json` or session transcripts.
