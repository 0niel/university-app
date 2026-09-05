import argparse
import json
import os
from pathlib import Path, PurePosixPath
import subprocess
import sys

import yaml


JOBS = (
    "flutter",
    "wear",
    "content-fetcher",
    "release-tools",
    "edge-functions",
    "supabase-migrations",
    "schedule-fetcher",
)
SHARED_FILES = {
    "pubspec.yaml",
    "pubspec.lock",
    "pubspec_overrides.yaml",
    ".fvmrc",
    "analysis_options.yaml",
    "build.yaml",
    "dart_test.yaml",
    "l10n.yaml",
    "flutter_native_splash.yaml",
    "codemagic.yaml",
    "shorebird.yaml",
    "tool/package_test_runtime.dart",
}


def read_manifest(path):
    manifest = yaml.safe_load(path.read_text(encoding="utf-8"))
    if not isinstance(manifest, dict):
        raise ValueError(f"Invalid package manifest: {path}")
    return manifest


def workspace_graph(root):
    root = root.resolve()
    manifest = read_manifest(root / "pubspec.yaml")
    entries = manifest.get("workspace", [])
    if not isinstance(entries, list):
        raise ValueError("pubspec.yaml workspace must be a list")
    packages = {}
    for entry in entries:
        if not isinstance(entry, str):
            raise ValueError("Workspace entries must be relative paths")
        paths = sorted(root.glob(entry)) if any(c in entry for c in "*?[") else [root / entry]
        if not paths:
            raise ValueError(f"Workspace entry has no packages: {entry}")
        for path in paths:
            path = path.resolve()
            relative = path.relative_to(root).as_posix()
            packages[relative] = read_manifest(path / "pubspec.yaml")
    names = {}
    for path, package in packages.items():
        name = package.get("name")
        if not isinstance(name, str) or name in names:
            raise ValueError(f"Missing or duplicate workspace package name: {path}")
        names[name] = path
    reverse = {path: set() for path in packages}
    for path, package in packages.items():
        for dependency in local_dependencies(root / path, package, root, names):
            reverse[dependency].add(path)
    return packages, reverse, names


def local_dependencies(directory, manifest, root, names):
    dependencies = set()
    for section in ("dependencies", "dev_dependencies", "dependency_overrides"):
        for name, spec in (manifest.get(section) or {}).items():
            if name in names:
                dependencies.add(names[name])
            if isinstance(spec, dict) and isinstance(spec.get("path"), str):
                target = (directory / spec["path"]).resolve()
                try:
                    relative = target.relative_to(root).as_posix()
                except ValueError:
                    continue
                if relative in names.values():
                    dependencies.add(relative)
    return dependencies


def package_matrix(packages, max_shards=6):
    shards = [[] for _ in range(min(max_shards, len(packages)) or 1)]
    for index, package in enumerate(packages):
        shards[index % len(shards)].append(package)
    return {"include": [{"shard": index + 1, "packages": shard} for index, shard in enumerate(shards)]}


def finish_plan(jobs, packages):
    selected = sorted(packages)
    return {
        **jobs,
        "packages": selected,
        "has-packages": bool(selected),
        "package-matrix": package_matrix(selected),
    }


def plan_changes(root, changed_paths=None):
    root = root.resolve()
    packages, reverse, names = workspace_graph(root)
    full = finish_plan(dict.fromkeys(JOBS, True), packages)
    if changed_paths is None:
        return full
    jobs = dict.fromkeys(JOBS, False)
    selected = set()
    for raw_path in changed_paths:
        path = raw_path.replace("\\", "/")
        parts = PurePosixPath(path).parts
        if not parts or ".." in parts or PurePosixPath(path).is_absolute():
            return full
        markdown = path.lower().endswith(".md")
        conventional_docs = PurePosixPath(path).name.lower() in {"readme.md", "changelog.md"}
        documentation = markdown and (
            len(parts) == 1
            or path.startswith("docs/")
            or (conventional_docs and path.startswith(("packages/", "tools/")))
        )
        if documentation or path in {"LICENSE", "CODEOWNERS"}:
            continue
        if path in SHARED_FILES or path.startswith((".github/", ".githooks/", "tool/ci_", "test/tool/ci_")):
            return full
        if path.startswith("packages/"):
            owners = [package for package in packages if path.startswith(package + "/")]
            if not owners:
                return full
            selected.add(max(owners, key=len))
            jobs["flutter"] = True
            jobs["wear"] = True
        elif path.startswith("wear/"):
            jobs["wear"] = True
            if path.startswith("wear/android/"):
                jobs["flutter"] = True
        elif path.startswith("tools/schedule_fetcher/"):
            jobs["schedule-fetcher"] = True
        elif path.startswith("tools/social_media_fetcher/") or path == "docker-compose.social-media.yml":
            jobs["content-fetcher"] = True
        elif path.startswith("supabase/functions/"):
            jobs["edge-functions"] = True
            if path == "supabase/functions/deno.json":
                jobs["flutter"] = True
        elif path.startswith(("supabase/migrations/", "supabase/tests/", "supabase/seed")) or path == "supabase/config.toml":
            jobs["supabase-migrations"] = True
            if path == "supabase/config.toml":
                jobs["flutter"] = True
        elif path.startswith("test/tool/"):
            jobs["release-tools"] = True
            jobs["flutter"] = path.endswith(".dart") or jobs["flutter"]
        elif path.startswith("scripts/"):
            jobs["release-tools"] = True
        elif path.startswith("tool/") or (path.startswith("tools/") and path.endswith(".dart")):
            jobs["release-tools"] = True
            jobs["flutter"] = not path.endswith(".py") or jobs["flutter"]
        elif path.startswith(("lib/", "test/", "integration_test/", "assets/", "android/", "ios/", "macos/", "windows/", "linux/", "web/", "config/")):
            jobs["flutter"] = True
        else:
            return full
    pending = list(selected)
    while pending:
        for dependent in reverse[pending.pop()]:
            if dependent not in selected:
                selected.add(dependent)
                pending.append(dependent)
    schedule_manifest = root / "tools/schedule_fetcher/pubspec.yaml"
    if selected and schedule_manifest.exists():
        dependencies = local_dependencies(schedule_manifest.parent, read_manifest(schedule_manifest), root, names)
        jobs["schedule-fetcher"] = jobs["schedule-fetcher"] or bool(selected & dependencies)
    return finish_plan(jobs, selected)


def changed_files(root, base):
    if not base or set(base) == {"0"} or len(base) not in (40, 64) or any(c not in "0123456789abcdefABCDEF" for c in base):
        return None
    try:
        result = subprocess.run(
            ["git", "diff", "--name-only", "-z", "--no-renames", base, "HEAD", "--"],
            cwd=root,
            check=True,
            capture_output=True,
        )
    except (OSError, subprocess.CalledProcessError):
        return None
    return [os.fsdecode(path) for path in result.stdout.split(b"\0") if path]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--base")
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    plan = plan_changes(root, changed_files(root, args.base))
    print(json.dumps(plan, separators=(",", ":")))
    output = os.environ.get("GITHUB_OUTPUT")
    if output:
        with open(output, "a", encoding="utf-8") as stream:
            for key, value in plan.items():
                stream.write(f"{key}={json.dumps(value, separators=(',', ':'))}\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
