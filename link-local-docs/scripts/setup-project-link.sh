#!/usr/bin/env bash
set -euo pipefail

SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_DIR="$(cd "$SELF_DIR/.." && pwd -P)"
SRC_SCRIPT="$REPO_DIR/project-link.sh"
DEST_DIR="$HOME/.local/bin"
DEST_CMD="$DEST_DIR/project-link"
ZSHRC="$HOME/.zshrc"

START_MARK="# >>> project-link helpers >>>"
END_MARK="# <<< project-link helpers <<<"

if [ ! -f "$SRC_SCRIPT" ]; then
  echo "Error: source script not found: $SRC_SCRIPT" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"
cp "$SRC_SCRIPT" "$DEST_CMD"
chmod +x "$DEST_CMD"

echo "Installed: $DEST_CMD"

if [ ! -f "$ZSHRC" ]; then
  touch "$ZSHRC"
fi

TMP_ZSHRC="${ZSHRC}.tmp.$$"
awk -v s="$START_MARK" -v e="$END_MARK" '
  $0==s {skip=1; next}
  $0==e {skip=0; next}
  !skip {print}
' "$ZSHRC" > "$TMP_ZSHRC"
mv "$TMP_ZSHRC" "$ZSHRC"

cat >> "$ZSHRC" <<'BLOCK'

# >>> project-link helpers >>>
# Added by sync_my_docs/scripts/setup-project-link.sh
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

link-local-docs() {
  project-link link "${1:-my_docs}"
}

status-local-docs() {
  project-link status "${1:-my_docs}"
}

repair-local-docs() {
  project-link repair "${1:-my_docs}"
}
# <<< project-link helpers <<<
BLOCK

echo "Updated: $ZSHRC"
echo "Run 'source ~/.zshrc' or open a new shell to use project-link and helper functions."
