#!/usr/bin/env python3
"""List private GitHub repos in an org that carry a .sops.yaml.

Read-only -- calls `gh search code` (one call, finds every repo with a
matching file in one shot) then `gh repo list` (for branch/url fields),
never mutates anything.

Usage:
    uv run scripts/list-infra-private-repos.py [--owner ORG] [--limit N]

--owner defaults to "ExecutionLab". No name-based filtering (no prefix
matching) -- every private repo in the org with a `.sops.yaml` anywhere
in its default branch is printed.
"""
import argparse
import json
import subprocess
import sys

DEFAULT_OWNER = "ExecutionLab"


def run_gh(args):
    result = subprocess.run(["gh", *args], capture_output=True, text=True)
    if result.returncode != 0:
        print(f"error: gh {' '.join(args)} failed: {result.stderr.strip()}", file=sys.stderr)
        sys.exit(1)
    return result.stdout


def repos_with_sops_yaml(owner, limit):
    out = run_gh([
        "search", "code", "--filename", ".sops.yaml",
        "--owner", owner,
        "--limit", str(limit),
        "--json", "repository",
        "--jq", ".[].repository.nameWithOwner",
    ])
    return {line for line in out.splitlines() if line}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--owner", default=DEFAULT_OWNER, help=f"GitHub org to list repos for (default: {DEFAULT_OWNER})")
    parser.add_argument("--limit", type=int, default=1000)
    args = parser.parse_args()

    matches = repos_with_sops_yaml(args.owner, args.limit)
    if not matches:
        print(json.dumps([], indent=2))
        return 0

    repos = json.loads(run_gh([
        "repo", "list", args.owner,
        "--visibility", "private",
        "--limit", str(args.limit),
        "--json", "name,nameWithOwner,defaultBranchRef,url",
    ]))
    matched = [
        {
            "name": r["name"],
            "nameWithOwner": r["nameWithOwner"],
            "defaultBranch": (r.get("defaultBranchRef") or {}).get("name") or "main",
            "url": r["url"],
        }
        for r in repos
        if r["nameWithOwner"] in matches
    ]
    print(json.dumps(matched, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
