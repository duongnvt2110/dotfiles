#!/usr/bin/env python3
"""Commit and push previously prepared SOPS re-encryption changes.

Run only after explicit admin approval. Read the manifest written by
local-reencrypt-values-after-merge.py, reject unexpected local changes or an
advanced default branch, then commit and push only the prepared file paths.
"""
import argparse
import json
import subprocess
import sys
from pathlib import Path


def git(repo_dir, *args, check=True):
    result = subprocess.run(["git", "-C", str(repo_dir), *args],
                            capture_output=True, text=True)
    if check and result.returncode:
        raise RuntimeError(result.stderr.strip() or result.stdout.strip())
    return result


def changed_files(repo_dir):
    return set(filter(None, git(repo_dir, "diff", "--name-only").stdout.splitlines()))


def validate_prepared_target(item):
    required = ("repo", "ref", "files", "checkout")
    if any(key not in item for key in required):
        raise ValueError("prepared manifest target is missing required fields")
    repo_dir = Path(item["checkout"])
    if not repo_dir.is_dir():
        raise ValueError(f"prepared checkout not found: {repo_dir}")
    files = set(item["files"])
    changed = changed_files(repo_dir)
    unexpected = changed - files
    if unexpected:
        raise ValueError("unexpected local changes: " + ", ".join(sorted(unexpected)))
    staged = git(repo_dir, "diff", "--cached", "--name-only").stdout.splitlines()
    if staged:
        raise ValueError("staged local changes: " + ", ".join(staged))
    untracked = git(repo_dir, "ls-files", "--others", "--exclude-standard").stdout.splitlines()
    if untracked:
        raise ValueError("untracked local files: " + ", ".join(untracked))
    return repo_dir, files, bool(changed)


def default_branch_is_current(repo_dir, ref):
    git(repo_dir, "fetch", "origin", ref)
    return git(repo_dir, "rev-parse", "HEAD").stdout.strip() == \
        git(repo_dir, "rev-parse", f"origin/{ref}").stdout.strip()


def push_target(item, dry_run):
    if item.get("status") == "no_change":
        return {"repo": item.get("repo"), "status": "no_change"}
    if item.get("status") != "prepared":
        return {"repo": item.get("repo"), "status": "not_prepared"}
    try:
        repo_dir, files, has_changes = validate_prepared_target(item)
        if not has_changes:
            return {"repo": item["repo"], "status": "no_change"}
        if dry_run:
            return {"repo": item["repo"], "status": "would_push", "files": sorted(files)}
        if not default_branch_is_current(repo_dir, item["ref"]):
            return {"repo": item["repo"], "status": "base_branch_advanced"}
        git(repo_dir, "add", "--", *sorted(files))
        if git(repo_dir, "diff", "--cached", "--quiet", check=False).returncode == 0:
            return {"repo": item["repo"], "status": "no_change"}
        git(repo_dir, "commit", "-m", "chore(sops): re-wrap encrypted values")
        git(repo_dir, "push", "origin", f"HEAD:{item['ref']}")
        return {"repo": item["repo"], "status": "reencrypted_and_pushed", "files": sorted(files)}
    except (RuntimeError, ValueError) as error:
        return {"repo": item.get("repo"), "status": "push_error", "detail": str(error)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("manifest", type=Path, help="manifest produced by local re-encryption")
    parser.add_argument("--dry-run", action="store_true", help="validate and preview; never commit or push")
    args = parser.parse_args()
    try:
        manifest = json.loads(args.manifest.read_text())
        if manifest.get("version") != 1 or not isinstance(manifest.get("targets"), list):
            raise ValueError("unsupported re-encryption manifest")
    except (OSError, ValueError, json.JSONDecodeError) as error:
        print(f"error: {error}", file=sys.stderr)
        return 1
    results = [push_target(item, args.dry_run) for item in manifest["targets"]]
    print(json.dumps(results, indent=2))
    return 1 if any(item["status"] == "push_error" for item in results) else 0


if __name__ == "__main__":
    sys.exit(main())
