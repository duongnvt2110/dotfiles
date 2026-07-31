#!/usr/bin/env bash

# Install any formulas that do not have Homebrew bottles.
macports_install() {
  if [ "$#" -eq 0 ]; then
    return 0
  fi

  if ! command -v port >/dev/null 2>&1; then
    echo "MacPorts is not installed. Install MacPorts, then rerun this script." >&2
    return 1
  fi

  echo "Installing via MacPorts: $*" >&2

  if [ "$(id -u)" -eq 0 ]; then
    port install "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo port install "$@"
  else
    echo "sudo is not available; cannot install MacPorts packages." >&2
    return 1
  fi
}
