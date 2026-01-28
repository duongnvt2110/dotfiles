#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: link-codex-claude-folders.sh [--force] [--backup]

Creates per-folder symlinks from this repo into:
  ~/.codex/<child>  -> <repo>/.codex/<child>
  ~/.claude/<child> -> <repo>/.claude/<child>

Existing target folders are kept by default (no replace).

Options:
  --force   Remove existing target folder before linking.
  --backup  Move existing target folder to *.bak-YYYYMMDD-HHMMSS before linking.
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

link_children() {
  local src_root="$1"
  local dst_root="$2"

  if [[ ! -d "$src_root" ]]; then
    echo "Source directory missing: $src_root" >&2
    return 1
  fi

  mkdir -p "$dst_root"

  local child
  for child in "$src_root"/*; do
    [[ -e "$child" ]] || continue
    local name
    name="$(basename "$child")"
    local dst="$dst_root/$name"

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
        echo "Skipped existing target: $dst"
        continue
      fi
    fi

    ln -s "$child" "$dst"
    echo "Linked $dst -> $child"
  done
}

link_children "$repo_root/.codex" "$HOME/.codex"
link_children "$repo_root/.claude" "$HOME/.claude"
