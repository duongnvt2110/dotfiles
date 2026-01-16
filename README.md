# Dotfiles Workspace

This repository contains personal dotfiles plus supporting automation assets.
The Codex agent catalog and skills live under `.codex/`.

## Folder Structure

```
.
├── .codex/          # Codex agent catalog, skills, rules, prompts
├── AGENTS.md        # Repository guidelines and contribution rules
└── README.md        # Root overview for this dotfiles repo
```

## What Each Folder Is For

- `.codex/`: All Codex/Claude automation content, including prompts, skills,
  rules, and config. See `.codex/README.md` for the catalog.
- `AGENTS.md`: Operating rules for modifying the agent catalog.
  Read this before making changes.
- `scripts/`: Helper utilities for local setup.

## Quick Setup

Link Codex assets into `~/.codex`:

```sh
scripts/link-codex.sh
```

## Notes

- Keep the root minimal; put Codex-related documentation inside `.codex/`.
- Do not commit `.codex/auth.json` or session transcripts.
