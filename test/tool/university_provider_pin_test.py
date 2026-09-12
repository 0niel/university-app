import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location("university_provider_pin", ROOT / "tool/university_provider_pin.py")
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class UniversityProviderPinTest(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)

    def write(self, value):
        path = self.root / "university_provider.json"
        path.write_text(json.dumps(value), encoding="utf-8")
        return path

    def test_committed_pin_is_valid(self):
        pin = MODULE.read_pin(ROOT / MODULE.PIN)
        self.assertEqual(set(pin), set(MODULE.FIELDS))

    def test_pin_defaults_path_and_rejects_unsafe_values(self):
        valid = {"repository": "owner/provider", "ref": "a" * 40}
        self.assertEqual(MODULE.read_pin(self.write(valid)), {**valid, "path": "."})
        for change in ({"ref": "main"}, {"ref": "A" * 40}, {"repository": "owner/provider.git"},
                       {"repository": "https://github.com/owner/provider"}, {"repository": "owner"},
                       {"path": "../outside"}, {"path": "/absolute"}, {"path": "a\\b"}, {"extra": True}, {"ref": 7}):
            with self.subTest(change=change), self.assertRaises(ValueError):
                MODULE.read_pin(self.write({**valid, **change}))
        with self.assertRaises(ValueError):
            MODULE.read_pin(self.root / "missing.json")

    def test_cli_writes_workflow_outputs_and_single_fields(self):
        pin = self.write({"repository": "owner/provider", "ref": "b" * 40, "path": "packages/provider"})
        output = self.root / "github-output"
        result = subprocess.run([sys.executable, str(ROOT / "tool/university_provider_pin.py"), "--pin", str(pin),
                                 "--github-output", str(output)], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(output.read_text(encoding="utf-8"),
                         "repository=owner/provider\nref=" + "b" * 40 + "\npath=packages/provider\n")
        result = subprocess.run([sys.executable, str(ROOT / "tool/university_provider_pin.py"), "--pin", str(pin),
                                 "--field", "ref"], capture_output=True, text=True)
        self.assertEqual(result.stdout.strip(), "b" * 40)
        self.write({"repository": "owner/provider", "ref": "main"})
        result = subprocess.run([sys.executable, str(ROOT / "tool/university_provider_pin.py"), "--pin", str(pin)],
                                capture_output=True, text=True)
        self.assertNotEqual(result.returncode, 0)


if __name__ == "__main__":
    unittest.main()
