import importlib.util
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch


SPEC = importlib.util.spec_from_file_location(
    "ci_packages", Path(__file__).resolve().parents[2] / "tool/ci_packages.py"
)
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class PackageRunnerTest(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        for name in ("first", "second"):
            package = self.root / name
            (package / "test").mkdir(parents=True)
            (package / "pubspec.yaml").write_text(f"name: {name}\n")
            (package / "test/example_test.dart").write_text("")

    @patch.object(MODULE.shutil, "which", side_effect=lambda name: name)
    @patch.object(MODULE.subprocess, "check_output", return_value="flutter\n")
    @patch.object(MODULE.subprocess, "run")
    def test_flutter_tests_reuse_resolved_dependencies(self, run, output, which):
        self.assertEqual(MODULE.run_packages(self.root, ["first"]), [])
        self.assertEqual(run.call_args_list[1].args[0], ["flutter", "test", "--no-pub"])

    @patch.object(MODULE.shutil, "which", side_effect=lambda name: name)
    @patch.object(MODULE.subprocess, "check_output", return_value="dart\n")
    @patch.object(MODULE.subprocess, "run")
    def test_failure_does_not_hide_later_package_results(self, run, output, which):
        run.side_effect = [subprocess.CalledProcessError(1, "analyze"), None, None]
        self.assertEqual(MODULE.run_packages(self.root, ["first", "second"]), ["first"])
        self.assertEqual(run.call_count, 3)
        self.assertEqual(run.call_args.args[0], ["dart", "test"])

    @patch.object(MODULE.shutil, "which", side_effect=lambda name: name)
    @patch.object(MODULE.subprocess, "check_output")
    @patch.object(MODULE.subprocess, "run")
    def test_package_without_tests_still_gets_analyzed(self, run, output, which):
        (self.root / "first/test/example_test.dart").unlink()
        self.assertEqual(MODULE.run_packages(self.root, ["first"]), [])
        run.assert_called_once()
        output.assert_not_called()

    @patch.object(MODULE.shutil, "which", side_effect=lambda name: name)
    @patch.object(MODULE.subprocess, "run")
    def test_rejects_paths_outside_workspace(self, run, which):
        with self.assertRaises(ValueError):
            MODULE.run_packages(self.root, ["../outside"])
        run.assert_not_called()


if __name__ == "__main__":
    unittest.main()
