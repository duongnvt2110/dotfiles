#!/usr/bin/env bash

# Keep the formula list in Homebrew bottle mode first. Any formula that fails
# specifically because the tap has no bottle is returned to the caller so the
# fallback installer can handle it.
brew_install_bottles() {
  local brew_args=()
  local formulas=()
  local parsing_brew_args=1
  local arg

  for arg in "$@"; do
    if [ "$arg" = "--" ]; then
      parsing_brew_args=0
      continue
    fi

    if [ "$parsing_brew_args" -eq 1 ]; then
      brew_args+=("$arg")
    else
      formulas+=("$arg")
    fi
  done

  if [ "${#brew_args[@]}" -eq 0 ] || [ "${#formulas[@]}" -eq 0 ]; then
    echo "usage: brew_install_bottles <brew args...> -- <formula...>" >&2
    return 1
  fi

  local missing=()
  local formula output rc
  for formula in "${formulas[@]}"; do
    rc=0
    output="$("${brew_args[@]}" install --force-bottle "$formula" 2>&1)" || rc=$?

    if [ "$rc" -eq 0 ]; then
      printf '%s\n' "$output" >&2
      continue
    fi

    printf '%s\n' "$output" >&2
    if printf '%s\n' "$output" | grep -Eqi 'no bottle|has no bottle|does not have a bottle'; then
      missing+=("$formula")
      rc=0
      continue
    fi

    return "$rc"
  done

  printf '%s\n' "${missing[@]}"
}
