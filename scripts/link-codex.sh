#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
src_base="${repo_root}/.codex"
dest_base="${HOME}/.codex"
timestamp="$(date +%Y%m%d-%H%M%S)"

if [[ -L "${dest_base}" ]]; then
  echo "Refusing to link through symlinked Codex root: ${dest_base}" >&2
  exit 1
fi

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
    if [[ "$(readlink "${dest}")" == "${src}" ]]; then
      return 0
    fi
    echo "Refusing to replace unrelated symlink: ${dest} -> $(readlink "${dest}")" >&2
    return 1
  elif [[ -e "${dest}" ]]; then
    mv "${dest}" "${dest}.bak.${timestamp}"
  fi

  ln -s "${src}" "${dest}"
  echo "Linked ${dest} -> ${src}"
}

link_skills() {
  local src_root="${src_base}/skills"
  local dest_root="${dest_base}/skills"

  if [[ -L "${dest_root}" ]]; then
    local current_target expected_target
    current_target="$(cd "${dest_root}" && pwd -P)" || {
      echo "Cannot resolve existing skills link: ${dest_root}" >&2
      return 1
    }
    expected_target="$(cd "${src_root}" && pwd -P)"
    if [[ "${current_target}" != "${expected_target}" ]]; then
      echo "Refusing to replace unrelated skills link: ${dest_root} -> ${current_target}" >&2
      return 1
    fi

    mv "${dest_root}" "${dest_root}.bak.${timestamp}"
    mkdir -p "${dest_root}"
  elif [[ -e "${dest_root}" && ! -d "${dest_root}" ]]; then
    echo "Skills destination is not a directory: ${dest_root}" >&2
    return 1
  else
    mkdir -p "${dest_root}"
  fi

  if [[ -d "${src_root}/.system" \
    && ! -e "${dest_root}/.system" \
    && ! -L "${dest_root}/.system" ]]; then
    cp -a "${src_root}/.system" "${dest_root}/.system"
  fi

  local src_skill name dest_skill
  for src_skill in "${src_root}"/*; do
    [[ -d "${src_skill}" ]] || continue
    name="$(basename "${src_skill}")"
    dest_skill="${dest_root}/${name}"

    if [[ -L "${dest_skill}" && "$(readlink "${dest_skill}")" == "${src_skill}" ]]; then
      continue
    fi
    if [[ -e "${dest_skill}" || -L "${dest_skill}" ]]; then
      mv "${dest_skill}" "${dest_skill}.bak.${timestamp}"
    fi
    ln -s "${src_skill}" "${dest_skill}"
    echo "Linked ${dest_skill} -> ${src_skill}"
  done
}

link_item ".agent"
link_skills
link_item "hooks"
link_item "hooks.json"
