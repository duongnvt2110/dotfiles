#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  project-link.sh [link|status|repair] [name]
  project-link.sh [--status|--repair] [name]   # backward compatible

Commands:
  link      Create/validate symlink (default command)
  status    Show current link status and expected target
  repair    Replace wrong-target symlink

Options:
  -h, --help  Show this help message

Environment:
  PROJECT_LOCAL_HOME   Base directory for external project data
                      Default: $HOME/.local/project-data
  PROJECT_LINK_ROOT    Force project root directory (optional)

Behavior:
  - Project root is detected from Git (`git rev-parse --show-toplevel`) when possible.
  - If not inside a Git repo, current directory is used as project root.
  - Target path uses <project-name>-<repo-key> to avoid collisions.
USAGE
}

abs_path() {
  if command -v realpath >/dev/null 2>&1; then
    realpath "$1"
  else
    (cd "$1" && pwd -P)
  fi
}

repo_key() {
  local input="$1"
  if command -v sha1sum >/dev/null 2>&1; then
    printf '%s' "$input" | sha1sum | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    printf '%s' "$input" | shasum -a 1 | awk '{print $1}'
  else
    echo "Error: sha1sum/shasum not found; cannot derive stable repo key." >&2
    exit 2
  fi
}

project_root() {
  if [ -n "${PROJECT_LINK_ROOT:-}" ]; then
    abs_path "$PROJECT_LINK_ROOT"
    return 0
  fi

  if command -v git >/dev/null 2>&1; then
    local root
    if root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
      abs_path "$root"
      return 0
    fi
  fi
  abs_path .
}

COMMAND="link"
LINK_NAME="my_docs"

if [ "$#" -gt 0 ]; then
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --status)
      COMMAND="status"
      shift
      ;;
    --repair)
      COMMAND="repair"
      shift
      ;;
    link|status|repair)
      COMMAND="$1"
      shift
      ;;
    *)
      ;;
  esac
fi

if [ "$#" -gt 0 ]; then
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --*)
      echo "Error: unknown option: $1" >&2
      usage
      exit 2
      ;;
    *)
      LINK_NAME="$1"
      shift
      ;;
  esac
fi

if [ "$#" -gt 0 ]; then
  echo "Error: too many arguments." >&2
  usage
  exit 2
fi

PROJECT_DIR="$(project_root)"
PROJECT_NAME="$(basename "$PROJECT_DIR")"
BASE_DIR="${PROJECT_LOCAL_HOME:-$HOME/.local/project-data}"
REPO_KEY="$(repo_key "$PROJECT_DIR")"
TARGET_DIR="$BASE_DIR/$PROJECT_NAME-$REPO_KEY/$LINK_NAME"
LINK_PATH="$PROJECT_DIR/$LINK_NAME"

print_status() {
  echo "project_dir: $PROJECT_DIR"
  echo "base_dir:    $BASE_DIR"
  echo "repo_key:    $REPO_KEY"
  echo "target_dir:  $TARGET_DIR"
  echo "link_path:   $LINK_PATH"

  if [ -L "$LINK_PATH" ]; then
    local current_target
    current_target="$(readlink "$LINK_PATH")"
    echo "link_state:  symlink"
    echo "link_target: $current_target"
    if [ "$current_target" = "$TARGET_DIR" ]; then
      echo "valid:       yes"
    else
      echo "valid:       no (points to unexpected target)"
    fi
  elif [ -e "$LINK_PATH" ]; then
    echo "link_state:  exists but not symlink"
    echo "valid:       no"
  else
    echo "link_state:  missing"
    echo "valid:       no"
  fi
}

if [ "$COMMAND" = "status" ]; then
  print_status
  exit 0
fi

mkdir -p "$TARGET_DIR"

if [ -L "$LINK_PATH" ]; then
  CURRENT_TARGET="$(readlink "$LINK_PATH")"
  if [ "$CURRENT_TARGET" = "$TARGET_DIR" ]; then
    echo "Symlink already correct: $LINK_PATH -> $TARGET_DIR"
    exit 0
  fi

  if [ "$COMMAND" = "repair" ]; then
    rm "$LINK_PATH"
    ln -s "$TARGET_DIR" "$LINK_PATH"
    echo "Repaired symlink: $LINK_PATH -> $TARGET_DIR"
    exit 0
  fi

  echo "Error: symlink exists but points elsewhere:" >&2
  echo "  $LINK_PATH -> $CURRENT_TARGET" >&2
  echo "Expected target: $TARGET_DIR" >&2
  echo "Run: ${0##*/} repair $LINK_NAME" >&2
  exit 1
fi

if [ -e "$LINK_PATH" ]; then
  echo "Error: path exists and is not a symlink: $LINK_PATH" >&2
  exit 1
fi

ln -s "$TARGET_DIR" "$LINK_PATH"
echo "Created symlink: $LINK_PATH -> $TARGET_DIR"
