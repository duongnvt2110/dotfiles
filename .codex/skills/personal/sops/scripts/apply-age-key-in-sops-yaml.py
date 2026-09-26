#!/usr/bin/env python3
# /// script
# requires-python = ">=3.9"
# dependencies = [
#     "ruamel.yaml>=0.18",
# ]
# ///
"""Add or remove one age recipient public key in a project's .sops.yaml.

Supports two creation_rules shapes, matched in file order, first match
wins -- never touches path_regex, encrypted_comment_regex, or any other
section:
  1. `key_groups: - age: [...]` -- a real YAML list, edited in place.
  2. flat `age: <scalar>` directly under a creation_rules entry -- a
     comma-separated string (each entry may carry its own trailing text,
     e.g. an ssh-rsa key's own comment field). Labels aren't supported
     here since there's no per-entry comment slot; a --label is dropped
     with a stderr note.
Idempotent: adding an already-present key or removing an absent one is a
no-op (reported, not an error).

Parses with ruamel.yaml (round-trip mode) so comments, key ordering, and
formatting elsewhere in the file are preserved exactly.

Usage:
    uv run scripts/apply-age-key-in-sops-yaml.py add    <sops_yaml_path> <recipient> [--label NAME]
    uv run scripts/apply-age-key-in-sops-yaml.py remove <sops_yaml_path> <recipient>
    (append --dry-run to preview either)
"""
import argparse
import base64
import re
import sys
from io import StringIO
from pathlib import Path

from ruamel.yaml import YAML
from ruamel.yaml.scalarstring import LiteralScalarString

AGE_KEY_RE = re.compile(r"^age1[a-z0-9]+$")
SSH_KEY_TYPES = frozenset(("ssh-ed25519", "ssh-rsa"))


def make_yaml():
    yaml = YAML()
    yaml.preserve_quotes = True
    yaml.indent(mapping=2, sequence=4, offset=2)
    return yaml


def _join_one_per_line(entries):
    """Comma-then-newline join so each recipient entry lands on its own
    line verbatim -- explicit, not reliant on the emitter's width-based
    folding (which word-wraps mid-entry and jumbles multi-token entries
    like an ssh-rsa key's own trailing comment with the next recipient)."""
    return LiteralScalarString(",\n".join(entries))


def find_age_target(data):
    """Return (mode, obj) for the first place an age recipient list lives,
    walking creation_rules in file order -- or None if none exists.
    mode='list': obj is the key_groups[].age YAML list itself.
    mode='flat': obj is the creation_rules[] rule dict (age is obj["age"])."""
    for rule in (data.get("creation_rules") or []):
        for key_group in (rule.get("key_groups") or []):
            if "age" in key_group:
                return ("list", key_group["age"])
        if "age" in rule:
            if isinstance(rule["age"], list):
                return ("list", rule["age"])
            return ("flat", rule)
    return None


def _read_ssh_string(blob, offset):
    """Read one SSH wire-format string and return (value, next_offset)."""
    if offset + 4 > len(blob):
        raise ValueError("missing SSH string length")
    size = int.from_bytes(blob[offset:offset + 4], "big")
    start = offset + 4
    end = start + size
    if end > len(blob):
        raise ValueError("truncated SSH string")
    return blob[start:end], end


def _is_positive_ssh_mpint(value):
    """Return whether an SSH mpint is a non-zero, non-negative integer."""
    if not value:
        return False
    if value[0] & 0x80:
        return False
    return any(value)


def _ssh_recipient_identity(value):
    """Return an SSH recipient's stable ``type base64`` identity, or None.

    OpenSSH public-key comments are deliberately discarded: they identify the
    owner, not the recipient.  The decoded blob is checked so a key cannot
    claim one type while carrying another type's wire-format payload.
    """
    if "\r" in value or "\n" in value:
        return None

    fields = value.strip().split(None, 2)
    if len(fields) < 2 or fields[0] not in SSH_KEY_TYPES:
        return None
    key_type, encoded = fields[:2]
    try:
        blob = base64.b64decode(encoded.encode("ascii"), validate=True)
        embedded_type, offset = _read_ssh_string(blob, 0)
    except (UnicodeEncodeError, ValueError):
        return None

    if embedded_type != key_type.encode():
        return None

    try:
        if key_type == "ssh-ed25519":
            public_key, offset = _read_ssh_string(blob, offset)
            if len(public_key) != 32:
                return None
        else:  # ssh-rsa
            exponent, offset = _read_ssh_string(blob, offset)
            modulus, offset = _read_ssh_string(blob, offset)
            if not (_is_positive_ssh_mpint(exponent) and _is_positive_ssh_mpint(modulus)):
                return None
            # age rejects RSA recipients below 2048 bits; reject them here
            # before they can be committed to .sops.yaml.
            if int.from_bytes(modulus, "big").bit_length() < 2048:
                return None
    except ValueError:
        return None

    return f"{key_type} {encoded}" if offset == len(blob) else None


def recipient_identity(value):
    """Return a canonical recipient identity, ignoring an SSH key comment."""
    candidate = value.strip()
    if candidate == "publickey1" or AGE_KEY_RE.match(candidate):
        return candidate
    return _ssh_recipient_identity(candidate)


def stored_recipient_identity(value):
    """Canonicalize an existing config entry, including legacy age labels."""
    identity = recipient_identity(value)
    if identity:
        return identity
    first_token = str(value).strip().split(None, 1)[0] if str(value).strip() else ""
    return first_token if first_token == "publickey1" or AGE_KEY_RE.match(first_token) else None


def apply_add(age_list, key, label):
    key_identity = recipient_identity(key)
    if key_identity is None:
        raise ValueError("invalid recipient")
    if any(stored_recipient_identity(entry) == key_identity for entry in age_list):
        return False
    if list(age_list) == ["publickey1"]:
        del age_list[:]
    age_list.append(key_identity)
    if label:
        age_list.yaml_add_eol_comment(label, len(age_list) - 1)
    return True


def apply_remove(age_list, key):
    key_identity = recipient_identity(key)
    if key_identity is None:
        raise ValueError("invalid recipient")
    indices = [
        index for index, entry in enumerate(age_list)
        if stored_recipient_identity(entry) == key_identity
    ]
    if not indices:
        return False
    for index in reversed(indices):
        del age_list[index]
    return True


def _split_flat_entries(raw):
    """Split a flat `age:` scalar into its comma-separated entries,
    folding away line wraps first."""
    return [e.strip() for e in str(raw).replace("\n", " ").split(",") if e.strip()]


def apply_add_flat(rule, key, label):
    entries = _split_flat_entries(rule["age"])
    key_identity = recipient_identity(key)
    if key_identity is None:
        raise ValueError("invalid recipient")
    if any(stored_recipient_identity(entry) == key_identity for entry in entries):
        return False
    if label:
        print(f"note: flat `age:` field has no per-key label slot; dropping label {label!r}", file=sys.stderr)
    entries.append(key_identity)
    rule["age"] = _join_one_per_line(entries)
    return True


def apply_remove_flat(rule, key):
    entries = _split_flat_entries(rule["age"])
    key_identity = recipient_identity(key)
    if key_identity is None:
        raise ValueError("invalid recipient")
    kept = [entry for entry in entries if stored_recipient_identity(entry) != key_identity]
    if len(kept) == len(entries):
        return False
    rule["age"] = _join_one_per_line(kept) if kept else ""
    return True


def validate_key(key):
    return recipient_identity(key) is not None


def apply_key_change(sops_yaml, action, key, label=None, dry_run=False):
    """Load sops_yaml, add/remove key, write back unless dry_run.
    Returns (changed, message). Raises ValueError if no age target found --
    shared by this script's CLI and open-age-key-pr-for-repo.py."""
    key = recipient_identity(key)
    if key is None:
        raise ValueError("recipient must be age1..., ssh-rsa <base64>, or ssh-ed25519 <base64>")

    yaml = make_yaml()
    with sops_yaml.open() as f:
        data = yaml.load(f)

    target = find_age_target(data)
    if target is None:
        raise ValueError("no `key_groups: - age:` or flat `age:` section found in .sops.yaml")
    mode, obj = target

    if mode == "list":
        changed = apply_add(obj, key, label) if action == "add" else apply_remove(obj, key)
    else:
        changed = apply_add_flat(obj, key, label) if action == "add" else apply_remove_flat(obj, key)

    if not changed:
        verb = "already present" if action == "add" else "not found"
        return False, f"{sops_yaml}: {key} {verb}, no change"

    prefix = "would " if dry_run else ""
    message = f"{sops_yaml}: {prefix}{action} {key}"
    if not dry_run:
        with sops_yaml.open("w") as f:
            yaml.dump(data, f)
    return True, message


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=["add", "remove"])
    parser.add_argument("sops_yaml", type=Path)
    parser.add_argument("key", help="age1..., ssh-rsa, or ssh-ed25519 public recipient")
    parser.add_argument("--label", default=None, help="add only: name comment for the key")
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    if not validate_key(args.key):
        print(
            f"error: {args.key!r} doesn't look like an age1..., ssh-rsa, or ssh-ed25519 public recipient",
            file=sys.stderr,
        )
        return 1

    if not args.sops_yaml.is_file():
        print(f"error: {args.sops_yaml} not found", file=sys.stderr)
        return 1

    try:
        _, message = apply_key_change(args.sops_yaml, args.action, args.key, args.label, args.dry_run)
    except ValueError as e:
        print(f"error: {e}", file=sys.stderr)
        return 1

    print(message)
    return 0


if __name__ == "__main__":
    sys.exit(main())
