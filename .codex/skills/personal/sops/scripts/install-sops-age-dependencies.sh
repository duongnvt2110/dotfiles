#!/usr/bin/env bash
set -euo pipefail

# Input: none.
# Output (stdout): one "<name>: installed|already-present" line per dependency.
# Exit 0 on success. Exit 1 with a message on stderr if brew is unavailable
# and something is missing (non-macOS — caller must install manually).

if command -v sops >/dev/null && command -v age >/dev/null; then
  echo "sops+age: already-present"
else
  if ! command -v brew >/dev/null; then
    echo "sops/age missing and brew unavailable — install sops and age via your platform's package manager" >&2
    exit 1
  fi
  brew install sops age >/dev/null
  echo "sops+age: installed"
fi

if command -v uv >/dev/null; then
  echo "uv: already-present"
else
  if ! command -v brew >/dev/null; then
    echo "uv missing and brew unavailable — install uv via your platform's package manager" >&2
    exit 1
  fi
  brew install uv >/dev/null
  echo "uv: installed"
fi

# helm-secrets/helm-diff only matter for helm/k8s projects -- skip them
# entirely on a terraform-only machine that has no helm installed.
if ! command -v helm >/dev/null; then
  echo "helm-secrets: skipped (helm not installed)"
  echo "helm-diff: skipped (helm not installed)"
  exit 0
fi

# --verify=false: these plugins are installed straight from their GitHub repo
# URL (VCS clone), which helm always treats as unsigned — verification is not
# supported for that install path regardless of whether the release itself is signed.
#
# Match plugin names exactly (column 1): jkroepke/helm-secrets registers three
# separate plugins (secrets, secrets-getter, secrets-post-renderer) — a substring
# grep for "secrets" false-positives on the latter two and skips installing the
# actual `secrets` CLI plugin that provides `helm secrets encrypt/decrypt/edit`.
installed_plugins="$(helm plugin list | awk 'NR>1{print $1}')"
helm_secrets_installed=false
for plugin in secrets secrets-getter secrets-post-renderer; do
  if echo "$installed_plugins" | grep -qx "$plugin"; then
    continue
  fi
  helm plugin install --verify=false "https://github.com/jkroepke/helm-secrets/releases/download/v4.7.4/${plugin}-4.7.4.tgz"
  helm_secrets_installed=true
done
if [ "$helm_secrets_installed" = true ]; then
  echo "helm-secrets: installed"
else
  echo "helm-secrets: already-present"
fi

if helm plugin list | awk 'NR>1{print $1}' | grep -qx diff; then
  echo "helm-diff: already-present"
else
  helm plugin install --verify=false https://github.com/databus23/helm-diff >/dev/null
  echo "helm-diff: installed"
fi
