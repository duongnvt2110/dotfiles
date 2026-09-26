#!/usr/bin/env python3
# /// script
# requires-python = ">=3.9"
# dependencies = ["ruamel.yaml>=0.18"]
# ///
"""Prepare local SOPS ciphertext re-wrapping after a key-change source.

Never commits or pushes. Accept a merged PR as <owner>/<repo>:<pr-number>, or
a direct default-branch change as <owner>/<repo> or <owner>/<repo>:<branch>.
Clone the verified default branch into --output-dir, re-wrap files selected by
.sops.yaml, and write a manifest for the separate push script.
"""
import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

from ruamel.yaml import YAML

SOPS_YAML_NAME = ".sops.yaml"
MANIFEST_NAME = "sops-reencrypt-manifest.json"


def resolve_age_key_file(explicit):
    if explicit:
        return Path(explicit)
    value = os.environ.get("SOPS_AGE_KEY_FILE")
    return Path(value) if value else None


def gh_json(args):
    result = subprocess.run(["gh", *args], capture_output=True, text=True)
    if result.returncode:
        raise RuntimeError(result.stderr.strip())
    return json.loads(result.stdout)


def pr_merge_state(repo, pr_number):
    data = gh_json(["pr", "view", str(pr_number), "--repo", repo,
                    "--json", "state,baseRefName,url"])
    return data["state"], data.get("baseRefName"), data["url"]


def repo_default_branch(repo):
    data = gh_json(["repo", "view", repo, "--json", "defaultBranchRef"])
    ref = data.get("defaultBranchRef") or {}
    if not ref.get("name"):
        raise RuntimeError(f"default branch not found for {repo}")
    return ref["name"]


def clone_repo(repo, ref, dest):
    result = subprocess.run(["gh", "repo", "clone", repo, str(dest), "--",
                             "--depth", "1", "--branch", ref],
                            capture_output=True, text=True)
    if result.returncode:
        raise RuntimeError(result.stderr.strip())


def matched_encrypted_files(repo_dir):
    sops_yaml = repo_dir / SOPS_YAML_NAME
    if not sops_yaml.is_file():
        raise RuntimeError(f"{SOPS_YAML_NAME} not found in {repo_dir}")
    yaml = YAML(typ="safe")
    with sops_yaml.open() as file:
        data = yaml.load(file)
    patterns = [re.compile(rule["path_regex"])
                for rule in (data.get("creation_rules") or [])
                if rule.get("path_regex")]
    if not patterns:
        raise RuntimeError(f"no path_regex found in {sops_yaml}")
    result = subprocess.run(["git", "-C", str(repo_dir), "ls-files"],
                            capture_output=True, text=True)
    if result.returncode:
        raise RuntimeError(result.stderr.strip())
    return [path for path in result.stdout.splitlines()
            if any(pattern.search(path) for pattern in patterns)]


def reencrypt_files(repo_dir, files, age_key_file):
    env = {**os.environ, "SOPS_AGE_KEY_FILE": str(age_key_file)}
    for path in files:
        result = subprocess.run(["sops", "updatekeys", "-y", path],
                                cwd=repo_dir, env=env, capture_output=True,
                                text=True)
        if result.returncode:
            raise RuntimeError(f"{path}: {result.stderr.strip()}")


def has_changes(repo_dir, files):
    result = subprocess.run(["git", "-C", str(repo_dir), "diff", "--quiet",
                             "--", *files])
    if result.returncode not in (0, 1):
        raise RuntimeError("could not inspect re-encryption changes")
    return result.returncode == 1


def parse_target(target):
    repo, separator, selector = target.rpartition(":")
    if not separator:
        if "/" not in target:
            raise ValueError("expected <owner>/<repo> or <owner>/<repo>:<pr-number|branch>")
        return target, "default", None
    if not repo or "/" not in repo or not selector:
        raise ValueError("expected <owner>/<repo> or <owner>/<repo>:<pr-number|branch>")
    return repo, "pr" if selector.isdigit() else "default", selector


def checkout_name(repo, pr_number):
    return f"{repo.replace('/', '__')}--{pr_number or 'default'}"


def process_target(target, age_key_file, output_dir, dry_run):
    try:
        repo, source, selector = parse_target(target)
        pr_url = None
        if source == "pr":
            state, base_ref, pr_url = pr_merge_state(repo, selector)
            if state != "MERGED":
                return {"target": target, "repo": repo, "pr_url": pr_url,
                        "status": "not_merged", "pr_state": state}
            default_ref = repo_default_branch(repo)
            if base_ref != default_ref:
                return {"target": target, "repo": repo, "pr_url": pr_url,
                        "status": "not_default_branch",
                        "detail": f"PR base {base_ref} is not the default branch {default_ref}"}
        else:
            base_ref = repo_default_branch(repo)
            if selector and selector != base_ref:
                return {"target": target, "repo": repo, "status": "not_default_branch",
                        "detail": f"{selector} is not the default branch {base_ref}"}
        if dry_run:
            scratch = Path(tempfile.mkdtemp(prefix="sops-reencrypt-preview-"))
            try:
                repo_dir = scratch / "repo"
                clone_repo(repo, base_ref, repo_dir)
                files = matched_encrypted_files(repo_dir)
                status = "would_reencrypt" if files else "no_files_matched"
                return {"target": target, "repo": repo, "pr_url": pr_url,
                        "source": source, "status": status, "ref": base_ref,
                        "files": files}
            finally:
                shutil.rmtree(scratch, ignore_errors=True)
        repo_dir = output_dir / checkout_name(repo, selector)
        clone_repo(repo, base_ref, repo_dir)
        files = matched_encrypted_files(repo_dir)
        if not files:
            return {"target": target, "repo": repo, "pr_url": pr_url,
                    "source": source, "status": "no_files_matched"}
        reencrypt_files(repo_dir, files, age_key_file)
        status = "prepared" if has_changes(repo_dir, files) else "no_change"
        return {"target": target, "repo": repo, "pr_url": pr_url,
                "source": source, "status": status, "ref": base_ref, "files": files,
                "checkout": str(repo_dir.resolve())}
    except (RuntimeError, ValueError, subprocess.CalledProcessError) as error:
        return {"target": target, "status": "reencrypt_error", "detail": str(error)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("targets", nargs="+",
                        help="<owner>/<repo>[:<pr-number|default-branch>] sources")
    parser.add_argument("--age-key-file", type=Path,
                        help="defaults to $SOPS_AGE_KEY_FILE")
    parser.add_argument("--output-dir", type=Path,
                        help="new directory for prepared local checkouts")
    parser.add_argument("--dry-run", action="store_true",
                        help="check only; never re-wrap, create files, commit, or push")
    args = parser.parse_args()
    if not args.dry_run and args.output_dir is None:
        parser.error("--output-dir is required unless --dry-run is used")
    age_key_file = resolve_age_key_file(args.age_key_file)
    if not args.dry_run and (age_key_file is None or not age_key_file.is_file()):
        print("error: pass an existing --age-key-file or set SOPS_AGE_KEY_FILE", file=sys.stderr)
        return 1
    output_dir = None
    if not args.dry_run:
        output_dir = args.output_dir.expanduser().resolve()
        if output_dir.exists():
            print(f"error: output directory already exists: {output_dir}", file=sys.stderr)
            return 1
        output_dir.mkdir(parents=True)
    results = [process_target(target, age_key_file, output_dir, args.dry_run)
               for target in args.targets]
    if output_dir:
        manifest = {"version": 1, "targets": results}
        (output_dir / MANIFEST_NAME).write_text(json.dumps(manifest, indent=2) + "\n")
    print(json.dumps(results, indent=2))
    return 1 if any(item["status"] == "reencrypt_error" for item in results) else 0


if __name__ == "__main__":
    sys.exit(main())
