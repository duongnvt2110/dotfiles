#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: link-codex-claude.sh [--force] [--backup]

Creates symlinks:
  ~/.codex  -> <repo>/.codex
  ~/.claude -> <repo>/.claude

Options:
  --force   Remove existing targets before linking.
  --backup  Move existing targets to *.bak-YYYYMMDD-HHMMSS before linking.
USAGE
}

force=false
backup=false

for arg in "$@"; do
  case "$arg" in
    --force) force=true ;;
    --backup) backup=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $arg"; usage; exit 1 ;;
  esac
done

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

link_one() {
  local src="$1"
  local dst="$2"

  if [[ ! -e "$src" ]]; then
    echo "Source does not exist: $src" >&2
    return 1
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    if $backup; then
      local ts
      ts="$(date +%Y%m%d-%H%M%S)"
      local backup_path="${dst}.bak-${ts}"
      mv "$dst" "$backup_path"
      echo "Backed up $dst -> $backup_path"
    elif $force; then
      rm -rf "$dst"
      echo "Removed existing $dst"
    else
      echo "Target exists: $dst" >&2
      echo "Use --force to remove or --backup to move it aside." >&2
      return 1
    fi
  fi

  ln -s "$src" "$dst"
  echo "Linked $dst -> $src"
}

link_one "$repo_root/.codex" "$HOME/.codex"
link_one "$repo_root/.claude" "$HOME/.claude"
