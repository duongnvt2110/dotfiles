#!/usr/bin/env bash
set -euo pipefail

# Creates the age identity file if missing, then prints only the derived
# public key (age1...). Never prints the private key contents.
#
# Key path resolution: $SOPS_AGE_KEY_FILE if set, else
# ~/.config/sops/age/keys.txt (matching sops/age's own default and the
# other sops skills' check-age-identity-exists.py).

KEY_FILE="${SOPS_AGE_KEY_FILE:-${HOME}/.config/sops/age/keys.txt}"
KEY_DIR="$(dirname "${KEY_FILE}")"

mkdir -p "${KEY_DIR}"

if [ -f "${KEY_FILE}" ]; then
  echo "Key file already exists: ${KEY_FILE} (skipped generation)" >&2
else
  age-keygen -o "${KEY_FILE}"
  echo "Generated new age identity: ${KEY_FILE}" >&2
fi

age-keygen -y "${KEY_FILE}"
