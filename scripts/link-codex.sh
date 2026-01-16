#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
src_base="${repo_root}/.codex"
dest_base="${HOME}/.codex"
timestamp="$(date +%Y%m%d-%H%M%S)"

mkdir -p "${dest_base}"

link_item() {
  local name="$1"
  local src="${src_base}/${name}"
  local dest="${dest_base}/${name}"

  if [[ ! -e "${src}" ]]; then
    echo "Missing source: ${src}" >&2
    return 1
  fi

  if [[ -L "${dest}" ]]; then
    rm -f "${dest}"
  elif [[ -e "${dest}" ]]; then
    mv "${dest}" "${dest}.bak.${timestamp}"
  fi

  ln -s "${src}" "${dest}"
  echo "Linked ${dest} -> ${src}"
}

link_item ".agent"
link_item "prompts"
link_item "skills"
link_item "config.toml"
