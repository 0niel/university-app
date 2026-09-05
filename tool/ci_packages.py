import json
import os
from pathlib import Path
import shutil
import subprocess
import sys


def run_packages(root, packages):
    dart = shutil.which("dart")
    flutter = shutil.which("flutter")
    if not dart or not flutter:
        raise RuntimeError("Dart and Flutter must be available")
    failed = []
    for package in packages:
        directory = (root / package).resolve()
        if not directory.is_relative_to(root.resolve()) or not (directory / "pubspec.yaml").is_file():
            raise ValueError(f"Invalid workspace package: {package}")
        print(f"::group::{package}", flush=True)
        try:
            subprocess.run([dart, "analyze", "--fatal-warnings"], cwd=directory, check=True)
            if any((directory / "test").rglob("*_test.dart")):
                runtime = subprocess.check_output(
                    [dart, str(root / "tool/package_test_runtime.dart"), str(directory)],
                    cwd=root, text=True,
                ).strip()
                if runtime not in {"flutter", "dart"}:
                    raise ValueError(f"Unknown test runtime: {runtime}")
                command = [flutter, "test", "--no-pub"] if runtime == "flutter" else [dart, "test"]
                subprocess.run(command, cwd=directory, check=True)
        except (subprocess.CalledProcessError, ValueError) as error:
            print(f"::error::{package}: {error}", flush=True)
            failed.append(package)
        finally:
            print("::endgroup::", flush=True)
    return failed


if __name__ == "__main__":
    packages = json.loads(os.environ["CI_PACKAGES"])
    if not isinstance(packages, list) or any(not isinstance(value, str) for value in packages):
        raise ValueError("CI_PACKAGES must be an array of package paths")
    sys.exit(bool(run_packages(Path(__file__).resolve().parents[1], packages)))
