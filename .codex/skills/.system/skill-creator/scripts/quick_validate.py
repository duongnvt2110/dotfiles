#!/usr/bin/env python3
"""Quick validation script for skills without external dependencies."""

import re
import sys
from pathlib import Path

MAX_SKILL_NAME_LENGTH = 64
MAX_SKILL_DESCRIPTION_LENGTH = 160
MAX_AGENT_SHORT_DESCRIPTION_LENGTH = 120


def parse_frontmatter(frontmatter_text: str):
    """Parse simple YAML frontmatter key/value pairs used by SKILL.md."""
    data = {}
    lines = frontmatter_text.splitlines()
    i = 0
    while i < len(lines):
        line = lines[i]
        if not line.strip():
            i += 1
            continue
        if line.startswith(" ") or line.startswith("\t"):
            # Nested fields (for example metadata maps) are ignored by this quick validator.
            i += 1
            continue
        match = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", line)
        if not match:
            return None, f"Invalid frontmatter line: {line!r}"
        key = match.group(1)
        value = match.group(2).strip()
        if value in {"|", ">", "|-", ">-", "|+", ">+"}:
            block = []
            i += 1
            while i < len(lines):
                nxt = lines[i]
                if re.match(r"^[A-Za-z0-9_-]+:\s", nxt):
                    i -= 1
                    break
                if nxt.startswith("  "):
                    block.append(nxt.strip())
                elif not nxt.strip():
                    if block:
                        block.append("")
                else:
                    return None, f"Invalid block scalar indentation: {nxt!r}"
                i += 1
            parsed = " ".join(part for part in block if part).strip()
        elif value.startswith('"') and value.endswith('"') and len(value) >= 2:
            parsed = value[1:-1]
        elif value.startswith("'") and value.endswith("'") and len(value) >= 2:
            parsed = value[1:-1]
        else:
            parsed = value
        data[key] = parsed
        i += 1
    return data, None


def validate_skill(skill_path):
    """Basic validation of a skill"""
    skill_path = Path(skill_path)

    skill_md = skill_path / "SKILL.md"
    if not skill_md.exists():
        return False, "SKILL.md not found"

    content = skill_md.read_text()
    if not content.startswith("---"):
        return False, "No YAML frontmatter found"

    match = re.match(r"^---\n(.*?)\n---", content, re.DOTALL)
    if not match:
        return False, "Invalid frontmatter format"

    frontmatter_text = match.group(1)

    frontmatter, parse_error = parse_frontmatter(frontmatter_text)
    if parse_error:
        return False, f"Invalid frontmatter: {parse_error}"
    if not isinstance(frontmatter, dict):
        return False, "Frontmatter must be a key/value mapping"

    allowed_properties = {
        "name",
        "description",
        "license",
        "allowed-tools",
        "metadata",
        "compatibility",
    }

    unexpected_keys = set(frontmatter.keys()) - allowed_properties
    if unexpected_keys:
        allowed = ", ".join(sorted(allowed_properties))
        unexpected = ", ".join(sorted(unexpected_keys))
        return (
            False,
            f"Unexpected key(s) in SKILL.md frontmatter: {unexpected}. Allowed properties are: {allowed}",
        )

    if "name" not in frontmatter:
        return False, "Missing 'name' in frontmatter"
    if "description" not in frontmatter:
        return False, "Missing 'description' in frontmatter"

    name = frontmatter.get("name", "")
    if not isinstance(name, str):
        return False, f"Name must be a string, got {type(name).__name__}"
    name = name.strip()
    if name:
        if not re.match(r"^[a-z0-9-]+$", name):
            return (
                False,
                f"Name '{name}' should be hyphen-case (lowercase letters, digits, and hyphens only)",
            )
        if name.startswith("-") or name.endswith("-") or "--" in name:
            return (
                False,
                f"Name '{name}' cannot start/end with hyphen or contain consecutive hyphens",
            )
        if len(name) > MAX_SKILL_NAME_LENGTH:
            return (
                False,
                f"Name is too long ({len(name)} characters). "
                f"Maximum is {MAX_SKILL_NAME_LENGTH} characters.",
            )

    description = frontmatter.get("description", "")
    if not isinstance(description, str):
        return False, f"Description must be a string, got {type(description).__name__}"
    description = description.strip()
    if description:
        if "<" in description or ">" in description:
            return False, "Description cannot contain angle brackets (< or >)"
        if len(description) > MAX_SKILL_DESCRIPTION_LENGTH:
            return (
                False,
                f"Description is too long ({len(description)} characters). "
                f"Maximum is {MAX_SKILL_DESCRIPTION_LENGTH} characters.",
            )

    agent_yaml = skill_path / "agents" / "openai.yaml"
    if agent_yaml.exists():
        agent_content = agent_yaml.read_text()
        short_match = re.search(
            r"^\s*short_description:\s*(.*)$", agent_content, flags=re.MULTILINE
        )
        if short_match:
            short_description = short_match.group(1).strip().strip('"').strip("'")
            if len(short_description) > MAX_AGENT_SHORT_DESCRIPTION_LENGTH:
                return (
                    False,
                    "agents/openai.yaml short_description is too long "
                    f"({len(short_description)} characters). Maximum is "
                    f"{MAX_AGENT_SHORT_DESCRIPTION_LENGTH} characters.",
                )

    return True, "Skill is valid!"


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python quick_validate.py <skill_directory>")
        sys.exit(1)

    valid, message = validate_skill(sys.argv[1])
    print(message)
    sys.exit(0 if valid else 1)
