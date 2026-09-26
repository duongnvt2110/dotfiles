import importlib.util
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch


SCRIPTS = Path(__file__).parents[1] / "scripts"


def load(name):
    spec = importlib.util.spec_from_file_location(name, SCRIPTS / name)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class LocalPreparationTests(unittest.TestCase):
    def test_parse_target_requires_repo_and_numeric_pr(self):
        module = load("local-reencrypt-values-after-merge.py")
        self.assertEqual(module.parse_target("org/repo:42"), ("org/repo", "pr", "42"))
        self.assertEqual(module.parse_target("org/repo"), ("org/repo", "default", None))
        self.assertEqual(module.parse_target("org/repo:main"), ("org/repo", "default", "main"))
        with self.assertRaises(ValueError):
            module.parse_target("org/repo:")

    def test_dry_run_reports_matched_files_without_reencrypting(self):
        module = load("local-reencrypt-values-after-merge.py")
        with patch.object(module, "pr_merge_state", return_value=("MERGED", "main", "url")), \
             patch.object(module, "repo_default_branch", return_value="main"), \
             patch.object(module, "clone_repo"), \
             patch.object(module, "matched_encrypted_files", return_value=["values.enc.yaml"]), \
             patch.object(module, "reencrypt_files") as reencrypt:
            result = module.process_target("org/repo:42", None, None, True)
        self.assertEqual(result["status"], "would_reencrypt")
        self.assertEqual(result["files"], ["values.enc.yaml"])
        reencrypt.assert_not_called()

    def test_direct_default_branch_is_a_valid_source(self):
        module = load("local-reencrypt-values-after-merge.py")
        with patch.object(module, "repo_default_branch", return_value="main"), \
             patch.object(module, "clone_repo"), \
             patch.object(module, "matched_encrypted_files", return_value=["values.enc.yaml"]):
            result = module.process_target("org/repo", None, None, True)
        self.assertEqual(result["source"], "default")
        self.assertEqual(result["ref"], "main")

    def test_direct_non_default_branch_is_rejected(self):
        module = load("local-reencrypt-values-after-merge.py")
        with patch.object(module, "repo_default_branch", return_value="main"):
            result = module.process_target("org/repo:develop", None, None, True)
        self.assertEqual(result["status"], "not_default_branch")

    def test_pr_targeting_non_default_branch_is_rejected(self):
        module = load("local-reencrypt-values-after-merge.py")
        with patch.object(module, "pr_merge_state", return_value=("MERGED", "release", "url")), \
             patch.object(module, "repo_default_branch", return_value="main"):
            result = module.process_target("org/repo:42", None, None, True)
        self.assertEqual(result["status"], "not_default_branch")


class PushSafetyTests(unittest.TestCase):
    def test_prepared_target_rejects_changes_outside_manifest(self):
        module = load("push-reencrypted-values-to-default-branch.py")
        item = {"repo": "org/repo", "ref": "main", "files": ["values.enc.yaml"],
                "checkout": str(Path.cwd())}
        with patch.object(module, "changed_files", return_value={"values.enc.yaml", "extra.txt"}):
            with self.assertRaisesRegex(ValueError, "unexpected local changes"):
                module.validate_prepared_target(item)

    def test_prepared_target_rejects_any_staged_change(self):
        module = load("push-reencrypted-values-to-default-branch.py")
        item = {"repo": "org/repo", "ref": "main", "files": ["values.enc.yaml"],
                "checkout": str(Path.cwd())}
        with patch.object(module, "changed_files", return_value={"values.enc.yaml"}), \
             patch.object(module, "git", return_value=SimpleNamespace(stdout="extra.txt\n")):
            with self.assertRaisesRegex(ValueError, "staged local changes"):
                module.validate_prepared_target(item)


if __name__ == "__main__":
    unittest.main()
