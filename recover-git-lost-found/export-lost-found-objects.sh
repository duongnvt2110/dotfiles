#!/usr/bin/env bash
set -euo pipefail

output_dir="recovered-lost-found"
mkdir -p "$output_dir"

git fsck --full --no-reflogs --unreachable --lost-found

slugify() {
  tr '[:upper:]' '[:lower:]' \
    | tr -cs 'a-z0-9' '-' \
    | sed 's/^-*//; s/-*$//' \
    | cut -c1-48
}

guess_extension() {
  local path="$1"
  local first_line
  first_line="$(head -n 1 "$path" 2>/dev/null || true)"

  if [[ "$first_line" =~ ^#!.*(ba|z|k)?sh ]]; then
    printf 'sh'
    return
  fi

  if grep -qE '^[[:space:]]*diff --git ' "$path"; then
    printf 'patch'
    return
  fi

  if grep -qE '^[[:space:]]*[\{\[]' "$path"; then
    printf 'json'
    return
  fi

  if grep -qE '<(html|!DOCTYPE[[:space:]]+html)' "$path"; then
    printf 'html'
    return
  fi

  if command -v file >/dev/null 2>&1; then
    case "$(file --brief --mime-type "$path" 2>/dev/null || true)" in
      text/x-shellscript) printf 'sh'; return ;;
      application/json) printf 'json'; return ;;
      text/html) printf 'html'; return ;;
      text/x-python) printf 'py'; return ;;
      text/x-c) printf 'c'; return ;;
      text/x-c++) printf 'cpp'; return ;;
      text/x-java) printf 'java'; return ;;
      text/markdown) printf 'md'; return ;;
      text/*) printf 'txt'; return ;;
      application/*) printf 'bin'; return ;;
      image/*) printf 'bin'; return ;;
    esac
  fi

  printf 'txt'
}

next_available_path() {
  local path="$1"
  local n=1
  local candidate="$path"

  while [[ -e "$candidate" ]]; do
    candidate="${path%.*}-$n.${path##*.}"
    n=$((n + 1))
  done

  printf '%s' "$candidate"
}

shopt -s nullglob
for obj in .git/lost-found/other/*; do
  sha="${obj##*/}"
  temp_file="$output_dir/lost-found-object-$sha.txt"

  if ! git cat-file -p "$sha" >"$temp_file" 2>/dev/null; then
    continue
  fi

  headline="$(
    sed -n '
      s/^[[:space:]]*//;
      /^$/d;
      /^diff --git /d;
      /^index [0-9a-f]/d;
      /^@@/d;
      /^--- /d;
      /^\+\+\+ /d;
      p;
      q
    ' "$temp_file"
  )"

  slug="$(printf '%s' "$headline" | slugify)"
  [[ -z "$slug" ]] && slug="content"

  ext="$(guess_extension "$temp_file")"
  target="$output_dir/lost-found-object-$sha-$slug.$ext"
  target="$(next_available_path "$target")"
  mv "$temp_file" "$target"
done
