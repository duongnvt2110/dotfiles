#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_SCRIPT="$SCRIPT_DIR/../export-lost-found-objects.sh"
DEST_DIR="$HOME/.local/bin"
DEST_CMD="$DEST_DIR/recover-git-lost-found"

if [[ ! -f "$SRC_SCRIPT" ]]; then
  echo "Source script not found: $SRC_SCRIPT" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"
install -m 0755 "$SRC_SCRIPT" "$DEST_CMD"

echo "Installed: $DEST_CMD"

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *)
    echo "Warning: ~/.local/bin is not in PATH for this shell."
    echo "Add this to ~/.zshrc if needed:"
    echo '  export PATH="$HOME/.local/bin:$PATH"'
    ;;
esac

echo "Run from any git repo:"
echo "  recover-git-lost-found"
