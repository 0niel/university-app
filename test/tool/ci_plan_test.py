import importlib.util
import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import yaml


ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location("ci_plan", ROOT / "tool/ci_plan.py")
ci_plan = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(ci_plan)


class CiPlanTest(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.write("pubspec.yaml", {"name": "app", "workspace": ["packages/core", "packages/client", "packages/feature", "packages/independent"]})
        self.write("packages/core/pubspec.yaml", {"name": "core"})
        self.write("packages/client/pubspec.yaml", {"name": "client", "dependencies": {"core": {"path": "../core"}}})
        self.write("packages/feature/pubspec.yaml", {"name": "feature", "dev_dependencies": {"client": "any"}})
        self.write("packages/independent/pubspec.yaml", {"name": "independent"})
        self.write("tools/schedule_fetcher/pubspec.yaml", {"name": "fetcher", "dependencies": {"client": {"path": "../../packages/client"}}})

    def write(self, path, value):
        target = self.root / path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(yaml.safe_dump(value), encoding="utf-8")

    def plan(self, *paths):
        return ci_plan.plan_changes(self.root, list(paths))

    def active(self, plan):
        return {job for job in ci_plan.JOBS if plan[job]}

    def test_reverse_transitive_dependencies_and_standalone_consumer(self):
        plan = self.plan("packages/core/lib/core.dart")
        self.assertEqual(plan["packages"], ["packages/client", "packages/core", "packages/feature"])
        self.assertEqual(self.active(plan), {"flutter", "wear", "schedule-fetcher"})

    def test_independent_package_does_not_schedule_fetcher(self):
        plan = self.plan("packages/independent/test/independent_test.dart")
        self.assertEqual(plan["packages"], ["packages/independent"])
        self.assertEqual(self.active(plan), {"flutter", "wear"})

    def test_path_dependency_override_is_followed(self):
        self.write("packages/independent/pubspec.yaml", {"name": "independent", "dependency_overrides": {"local_core": {"path": "../core"}}})
        self.assertIn("packages/independent", self.plan("packages/core/lib/core.dart")["packages"])

    def test_dependency_cycles_terminate(self):
        self.write("packages/core/pubspec.yaml", {"name": "core", "dependencies": {"feature": "any"}})
        self.assertEqual(len(self.plan("packages/core/lib/core.dart")["packages"]), 3)

    def test_shared_configuration_and_ci_changes_select_everything(self):
        for path in [*ci_plan.SHARED_FILES, ".github/workflows/main.yml", ".github/requirements-ci.txt", "tool/ci_plan.py", "test/tool/ci_plan_test.py"]:
            with self.subTest(path=path):
                plan = self.plan(path)
                self.assertEqual(self.active(plan), set(ci_plan.JOBS))
                self.assertEqual(len(plan["packages"]), 4)

    def test_deleted_or_unknown_package_is_conservative(self):
        plan = self.plan("packages/deleted/lib/deleted.dart")
        self.assertEqual(self.active(plan), set(ci_plan.JOBS))
        self.assertEqual(len(plan["packages"]), 4)

    def test_markdown_only_changes_have_no_heavy_jobs(self):
        plan = self.plan("README.md", "packages/core/README.md", "tools/schedule_fetcher/CHANGELOG.md", "docs/guide.MD")
        self.assertEqual(self.active(plan), set())
        self.assertFalse(plan["has-packages"])
        self.assertEqual(plan["package-matrix"], {"include": [{"shard": 1, "packages": []}]})

    def test_root_application_changes_skip_package_tests(self):
        plan = self.plan("lib/main.dart", "test/app_test.dart", "android/app/build.gradle", "assets/icon.png")
        self.assertEqual(self.active(plan), {"flutter"})
        self.assertEqual(plan["packages"], [])

    def test_specialized_changes_are_scoped(self):
        cases = {
            "wear/lib/main.dart": {"wear"},
            "wear/android/app/src/main/res/mipmap-hdpi/ic_launcher.png": {"wear", "flutter"},
            "tools/schedule_fetcher/lib/main.dart": {"schedule-fetcher"},
            "tools/social_media_fetcher/fetcher.py": {"content-fetcher"},
            "tool/app_store_build_status.py": {"release-tools"},
            "tool/decrypt_release_symbols.ps1": {"release-tools", "flutter"},
            "tool/release_symbols_public.pem": {"release-tools", "flutter"},
            "test/tool/new_release_tool_test.py": {"release-tools"},
            "test/tool/new_configuration_test.dart": {"release-tools", "flutter"},
            "scripts/build_showcase_seed.mjs": {"release-tools"},
            "supabase/functions/ingest/index.ts": {"edge-functions"},
            "supabase/functions/deno.json": {"edge-functions", "flutter"},
            "supabase/migrations/new.sql": {"supabase-migrations"},
            "supabase/config.toml": {"supabase-migrations", "flutter"},
            "supabase/seed.sql": {"supabase-migrations"},
            "supabase/tests/schema_test.sql": {"supabase-migrations"},
        }
        for path, expected in cases.items():
            with self.subTest(path=path):
                self.assertEqual(self.active(self.plan(path)), expected)

    def test_runtime_markdown_triggers_its_owner(self):
        cases = {
            "assets/help.md": {"flutter"},
            "packages/core/assets/help.md": {"flutter", "wear", "schedule-fetcher"},
            "tools/schedule_fetcher/templates/help.md": {"schedule-fetcher"},
            "supabase/functions/prompts/instructions.md": {"edge-functions"},
            "runtime/instructions.md": set(ci_plan.JOBS),
            ".github/PULL_REQUEST_TEMPLATE.md": set(ci_plan.JOBS),
        }
        for path, expected in cases.items():
            with self.subTest(path=path):
                self.assertEqual(self.active(self.plan(path)), expected)

    def test_unknown_runtime_or_config_files_are_conservative(self):
        for path in ("new-runtime/service.js", "new-build-config.json", "supabase/new-config.toml", "tools/new_runtime/server.py"):
            with self.subTest(path=path):
                self.assertEqual(self.active(self.plan(path)), set(ci_plan.JOBS))

    def test_no_changed_files_skips_everything(self):
        self.assertEqual(self.active(self.plan()), set())

    def test_full_plan_includes_each_workspace_package_once(self):
        plan = ci_plan.plan_changes(ROOT)
        expected = sorted(yaml.safe_load((ROOT / "pubspec.yaml").read_text(encoding="utf-8"))["workspace"])
        shards = plan["package-matrix"]["include"]
        selected = [path for shard in shards for path in shard["packages"]]
        self.assertEqual(plan["packages"], expected)
        self.assertEqual(sorted(selected), expected)
        self.assertLessEqual(len(shards), 6)
        self.assertLessEqual(max(len(shard["packages"]) for shard in shards) - min(len(shard["packages"]) for shard in shards), 1)

    def test_nested_workspace_package_is_not_confused_with_siblings(self):
        self.write("pubspec.yaml", {"name": "app", "workspace": ["packages/auth/client", "packages/auth/storage"]})
        self.write("packages/auth/client/pubspec.yaml", {"name": "client"})
        self.write("packages/auth/storage/pubspec.yaml", {"name": "storage"})
        self.assertEqual(self.plan("packages/auth/storage/lib/storage.dart")["packages"], ["packages/auth/storage"])

    def test_missing_zero_invalid_or_unavailable_base_selects_full(self):
        for base in (None, "", "0" * 40, "bad-ref", "--output=file", "f" * 40):
            with self.subTest(base=base):
                self.assertIsNone(ci_plan.changed_files(self.root, base))

    def test_git_diff_disables_renames_and_has_no_file_count_limit(self):
        paths = [f"lib/file_{index}.dart" for index in range(350)]
        paths.extend(["packages/core/old.dart", "packages/independent/new.dart"])
        output = b"\0".join(path.encode() for path in paths) + b"\0"
        with patch.object(ci_plan.subprocess, "run", return_value=subprocess.CompletedProcess([], 0, stdout=output)) as run:
            self.assertEqual(ci_plan.changed_files(self.root, "a" * 40), paths)
        self.assertEqual(run.call_args.args[0], ["git", "diff", "--name-only", "-z", "--no-renames", "a" * 40, "HEAD", "--"])
        plan = self.plan(*paths[-2:])
        self.assertEqual(len(plan["packages"]), 4)

    def test_cli_writes_machine_readable_outputs(self):
        output = self.root / "github-output"
        with patch.object(ci_plan.sys, "argv", ["ci_plan.py"]), patch.dict(ci_plan.os.environ, {"GITHUB_OUTPUT": str(output)}), patch("builtins.print") as printed:
            self.assertEqual(ci_plan.main(), 0)
        plan = json.loads(printed.call_args.args[0])
        written = dict(line.split("=", 1) for line in output.read_text(encoding="utf-8").splitlines())
        self.assertEqual({key: json.loads(value) for key, value in written.items()}, plan)


if __name__ == "__main__":
    unittest.main()
