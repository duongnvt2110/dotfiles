#!/usr/bin/env python3
# /// script
# requires-python = ">=3.9"
# dependencies = [
#     "ruamel.yaml>=0.18",
# ]
# ///
"""Clone one repo to a scratch dir, add/remove one age recipient key in its
.sops.yaml, and open a PR -- the per-repo unit of step 6 in SKILL.md.

Idempotent: if apply-age-key-in-sops-yaml.py's apply_key_change() reports
no change (key already present/absent), skips commit/push/PR and prints
"no-op".

Usage:
    uv run scripts/open-age-key-pr-for-repo.py \\
        <add|remove> <owner/repo> <default-branch> <recipient> [label]

Env:
    SOPS_YAML_PATH  path to .sops.yaml within the repo (default: .sops.yaml)
"""
import importlib.util
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent


def _load_apply_module():
    spec = importlib.util.spec_from_file_location(
        "apply_age_key_in_sops_yaml", SCRIPT_DIR / "apply-age-key-in-sops-yaml.py"
    )
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


apply_mod = _load_apply_module()


def branch_slug_for(label, age_key):
    raw_slug = label or age_key[:12]
    slug = re.sub(r"[^A-Za-z0-9]+", "-", raw_slug)
    return re.sub(r"^-|-$", "", slug)


def main():
    if len(sys.argv) < 5 or len(sys.argv) > 6:
        print(
            f"usage: {sys.argv[0]} <add|remove> <owner/repo> <default-branch> <recipient> [label]",
            file=sys.stderr,
        )
        return 1

    action, name_with_owner, default_branch, age_key = sys.argv[1:5]
    label = sys.argv[5] if len(sys.argv) == 6 else None

    if action not in ("add", "remove"):
        print(f"error: action must be 'add' or 'remove', got '{action}'", file=sys.stderr)
        return 1

    if not apply_mod.validate_key(age_key):
        print(
            f"error: {age_key!r} doesn't look like an age1..., ssh-rsa, or ssh-ed25519 public recipient",
            file=sys.stderr,
        )
        return 1

    sops_yaml_rel = os.environ.get("SOPS_YAML_PATH", ".sops.yaml")

    workdir = Path(tempfile.mkdtemp())
    try:
        repo_dir = workdir / "repo"
        subprocess.run(
            ["gh", "repo", "clone", name_with_owner, str(repo_dir),
             "--", "--depth", "1", "--branch", default_branch],
            check=True,
        )

        branch_slug = branch_slug_for(label, age_key)
        branch_name = f"sops/{action}-age-key-{branch_slug}"
        subprocess.run(["git", "checkout", "-b", branch_name], cwd=repo_dir, check=True)

        sops_yaml = repo_dir / sops_yaml_rel
        if not sops_yaml.is_file():
            print(f"error: {sops_yaml} not found", file=sys.stderr)
            return 1

        print("--- dry-run ---")
        try:
            _, preview_message = apply_mod.apply_key_change(
                sops_yaml, action, age_key, label, dry_run=True
            )
        except ValueError as e:
            print(f"error: {e}", file=sys.stderr)
            return 1
        print(preview_message)

        changed, message = apply_mod.apply_key_change(sops_yaml, action, age_key, label, dry_run=False)
        print(message)

        if not changed:
            print(f"no-op: {name_with_owner} already in desired state")
            return 0

        subprocess.run(["git", "add", sops_yaml_rel], cwd=repo_dir, check=True)
        subprocess.run(
            ["git", "commit", "-m", f"{action} age recipient key for {branch_slug}"],
            cwd=repo_dir, check=True,
        )
        subprocess.run(["git", "push", "-u", "origin", "HEAD"], cwd=repo_dir, check=True)
        subprocess.run(
            ["gh", "pr", "create", "--repo", name_with_owner,
             "--base", default_branch, "--head", branch_name,
             "--title", f"{action} age recipient key for {branch_slug}",
             "--body", f"Automated via sops-admin-manage-key skill: {action} age recipient "
                       f"key ({age_key}) in {sops_yaml_rel}."],
            cwd=repo_dir, check=True,
        )
        return 0
    finally:
        shutil.rmtree(workdir, ignore_errors=True)


if __name__ == "__main__":
    sys.exit(main())
