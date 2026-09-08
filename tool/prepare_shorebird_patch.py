import argparse
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import stat
import subprocess
import tempfile


COMMIT = re.compile(r"[0-9a-f]{40}")
REGULAR_MODES = {"100644", "100755"}
NATIVE_ROOTS = {"android", "ios", "macos", "windows", "linux", "web"}


def git(root, *args, input=None, env=None):
    return subprocess.check_output(
        ["git", "-c", "core.autocrlf=false", "-C", str(root), *args],
        input=input, env=env, stderr=subprocess.PIPE,
    )


def safe_path(path):
    parts = PurePosixPath(path).parts
    if (not parts or path.startswith("/") or "\\" in path or ":" in path
            or any(ord(char) < 32 for char in path)
            or any(part in {".", ".."} or part.lower() == ".git" for part in parts)
            or PurePosixPath(path).as_posix() != path):
        raise ValueError(f"Unsafe repository path: {path!r}")
    return parts


def tree(root, revision):
    entries = {}
    folded = set()
    for entry in git(root, "ls-tree", "-rz", "--full-tree", revision).split(b"\0"):
        if not entry:
            continue
        metadata, raw_path = entry.split(b"\t", 1)
        path = raw_path.decode("utf-8")
        safe_path(path)
        mode, kind, identity = metadata.decode("ascii").split()
        if kind != "blob" or mode not in REGULAR_MODES:
            raise ValueError(f"Symlinks, gitlinks and non-regular files are unsupported: {path}")
        if path.casefold() in folded:
            raise ValueError(f"Case-colliding repository paths are unsupported: {path}")
        folded.add(path.casefold())
        entries[path] = f"{mode} {kind} {identity}"
    return entries


def is_runtime(path, package_roots=None):
    parts = safe_path(path)
    if path.startswith("lib/") and path.endswith(".dart"):
        return True
    if len(parts) == 4 and parts[:3] == ("lib", "l10n", "arb") and path.endswith(".arb"):
        return True
    if parts[0] == "packages" and path.endswith(".dart"):
        return any(
            part == "lib" and index >= 2 and index < len(parts) - 1
            and not set(parts[1:index]) & (NATIVE_ROOTS | {"assets", "test", "example"})
            and (package_roots is None or "/".join(parts[:index]) in package_roots)
            for index, part in enumerate(parts)
        )
    return False


def classification(path, package_roots=None):
    parts = safe_path(path)
    if parts[-1] in {"pubspec.yaml", "pubspec.lock"} or parts[-1].endswith(".lock"):
        raise ValueError(f"Dependency changes require a full release: {path}")
    if is_runtime(path, package_roots):
        return "runtime"
    if (len(parts) >= 4 and parts[:2] == ("tools", "schedule_fetcher")
            and parts[2] in {"bin", "lib", "test"} and path.endswith(".dart")
            and not set(parts[3:-1]) & (NATIVE_ROOTS | {"assets", "native"})):
        return "excluded"
    if parts[:2] == ("test", "tool"):
        return "excluded"
    if parts[0] == "test":
        return "test"
    if parts[0] == "packages" and any(
        part == "test" and index >= 2 and index < len(parts) - 1
        and not set(parts[1:index]) & (NATIVE_ROOTS | {"assets", "example", "lib"})
        and (package_roots is None or "/".join(parts[:index]) in package_roots)
        for index, part in enumerate(parts)
    ):
        return "test"
    if parts[0] in {"docs", "supabase", ".github", "tool"} or (
        len(parts) == 1 and path.lower().endswith(".md")
    ):
        return "excluded"
    raise ValueError(f"Native, dependency, asset or unknown changes require a full release: {path}")


def index_tree(root, baseline, entries, changed_paths):
    with tempfile.TemporaryDirectory() as temporary:
        env = {**os.environ, "GIT_INDEX_FILE": str(Path(temporary) / "index")}
        git(root, "read-tree", baseline, env=env)
        for path in changed_paths:
            value = entries.get(path)
            if value is None:
                git(root, "update-index", "--force-remove", "--", path, env=env)
            else:
                mode, _, identity = value.split()
                git(root, "update-index", "--add", "--cacheinfo", mode, identity, path, env=env)
        return git(root, "write-tree", env=env).decode().strip()


def projection(root, baseline, source):
    for revision in (baseline, source):
        if not COMMIT.fullmatch(revision):
            raise ValueError("A full commit SHA is required")
        if git(root, "rev-parse", f"{revision}^{{commit}}").decode().strip() != revision:
            raise ValueError("Revision must identify a commit")
    try:
        git(root, "merge-base", "--is-ancestor", baseline, source)
    except subprocess.CalledProcessError as error:
        raise ValueError("Baseline must be an ancestor of source") from error
    before = tree(root, baseline)
    after = tree(root, source)
    changed = sorted(path for path in before.keys() | after.keys() if before.get(path) != after.get(path))
    paths = {"runtime": [], "test": [], "excluded": []}
    projected = dict(before)
    package_roots = {path.rsplit("/", 1)[0] for path in before
                     if path.startswith("packages/") and path.endswith("/pubspec.yaml")}
    for path in changed:
        if path in before and path in after and before[path].split()[0] != after[path].split()[0]:
            raise ValueError(f"File mode changes require a full release: {path}")
        category = classification(path, package_roots)
        paths[category].append(path)
        if category == "excluded":
            continue
        if path in after:
            projected[path] = after[path]
        else:
            projected.pop(path)
    projected_tree = index_tree(root, baseline, projected, paths["runtime"] + paths["test"])
    return projected, {
        "baseline_sha": baseline,
        "source_sha": source,
        "reviewed_source_sha": source,
        "source_tree_sha": git(root, "rev-parse", f"{source}^{{tree}}").decode().strip(),
        "projected_tree_sha": projected_tree,
        "projection_sha256": hashlib.sha256(json.dumps(projected, sort_keys=True, separators=(",", ":")).encode()).hexdigest(),
        "runtime_paths": paths["runtime"],
        "test_paths": paths["test"],
        "excluded_paths": paths["excluded"],
    }


def manifest_for(path, baseline, root):
    if path is None:
        return None
    from release_manifest import load_manifest, read_app_id
    manifest = load_manifest(path)
    if manifest["source_sha"] != baseline:
        raise ValueError("Release manifest source does not match the baseline")
    if manifest["source_tree"] != git(root, "rev-parse", f"{baseline}^{{tree}}").decode().strip():
        raise ValueError("Release manifest tree does not match the baseline")
    if manifest["app_id"] != read_app_id(root, baseline, manifest["platform"]):
        raise ValueError("Release manifest app identity does not match the baseline")
    return manifest


def verify_ignored_private_checkout(root, manifest):
    if (not manifest or manifest.get("platform") != "android"
            or not COMMIT.fullmatch(manifest.get("private_native_sha") or "")):
        raise ValueError("Ignored private checkout requires verified Android release inputs")
    target = root
    for part in ("android", "private", "nfc-pass-android"):
        target /= part
        if (target.is_symlink() or not target.is_dir()
                or not target.resolve().is_relative_to(root.resolve())
                or getattr(target.lstat(), "st_file_attributes", 0) & getattr(stat, "FILE_ATTRIBUTE_REPARSE_POINT", 0)):
            raise ValueError("Unsafe private native checkout path")
    from release_manifest import private_source
    if private_source(root) != manifest["private_native_sha"]:
        raise ValueError("Private native module differs from the release")


def verify_worktree(root, entries, receipt, manifest=None, verify_native_inputs=False):
    if git(root, "rev-parse", "HEAD").decode().strip() != receipt["baseline_sha"]:
        raise ValueError("Projected checkout HEAD must remain at the release baseline")
    if git(root, "write-tree").decode().strip() != receipt["projected_tree_sha"]:
        raise ValueError("Projected index differs from the validated tree")
    native_inputs = (manifest or {}).get("build_inputs", {})
    for path, expected in entries.items():
        target = root / path
        parent = root
        unsafe_parent = False
        for part in safe_path(path):
            parent = parent / part
            unsafe_parent = unsafe_parent or parent.is_symlink()
        if unsafe_parent or not target.is_file() or not target.resolve().is_relative_to(root.resolve()):
            raise ValueError(f"Missing or unsafe projected file: {path}")
        data = target.read_bytes()
        mode, _, identity = expected.split()
        actual = hashlib.sha1(b"blob " + str(len(data)).encode() + b"\0" + data).hexdigest()
        if actual != identity:
            if path not in native_inputs or safe_path(path)[0] not in NATIVE_ROOTS:
                raise ValueError(f"Projection drift: {path}")
            if hashlib.sha256(data).hexdigest() != native_inputs[path]:
                raise ValueError(f"Native fingerprint mismatch: {path}")
        if os.name != "nt" and bool(target.stat().st_mode & 0o111) != (mode == "100755"):
            raise ValueError(f"Projection file mode drift: {path}")
    untracked = set(filter(None, git(root, "ls-files", "--others", "--exclude-standard", "-z").decode().split("\0")))
    if untracked - native_inputs.keys():
        raise ValueError("Unexpected untracked files in the projected workspace")
    ignored = set(filter(None, git(root, "ls-files", "--others", "--ignored", "--exclude-standard", "-z").decode().split("\0")))
    if "android/private/nfc-pass-android/" in ignored:
        verify_ignored_private_checkout(root, manifest)
        ignored.remove("android/private/nfc-pass-android/")
    if any(is_runtime(path) for path in ignored):
        raise ValueError("Unexpected ignored runtime source in the projected workspace")
    for path in (untracked | ignored) & native_inputs.keys():
        target = root / path
        if target.is_symlink() or not target.is_file() or not target.resolve().is_relative_to(root.resolve()):
            raise ValueError(f"Unsafe generated input: {path}")
        if hashlib.sha256(target.read_bytes()).hexdigest() != native_inputs[path]:
            raise ValueError(f"Native fingerprint mismatch: {path}")
    if verify_native_inputs:
        if not manifest:
            raise ValueError("Native input verification requires a release manifest")
        from release_manifest import verify_native_config
        verify_native_config(root, manifest)


def materialize(root, output, entries, receipt):
    root, output = root.resolve(), output.absolute()
    if output.is_symlink() or output.resolve().is_relative_to(root):
        raise ValueError("Output must be a separate directory outside the source checkout")
    if output.exists() and any(output.iterdir()):
        raise ValueError("Output directory must be empty")
    output.parent.mkdir(parents=True, exist_ok=True)
    git(root, "clone", "--quiet", "--local", "--no-hardlinks", "--no-checkout", str(root), str(output))
    git(output, "config", "core.autocrlf", "false")
    git(output, "checkout", "--quiet", "--detach", receipt["baseline_sha"])
    git(output, "read-tree", "--reset", "-u", receipt["projected_tree_sha"])
    verify_worktree(output, entries, receipt)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--baseline", required=True)
    parser.add_argument("--source", required=True)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--repo", type=Path, default=Path.cwd())
    parser.add_argument("--manifest", type=Path)
    parser.add_argument("--receipt", type=Path)
    parser.add_argument("--github-output", type=Path)
    parser.add_argument("--expected-projection")
    parser.add_argument("--verify-worktree", action="store_true")
    parser.add_argument("--verify-native-inputs", action="store_true")
    args = parser.parse_args()
    root = args.repo.resolve()
    manifest = manifest_for(args.manifest, args.baseline, root)
    entries, receipt = projection(root, args.baseline, args.source)
    if manifest:
        for name in ("platform", "app_id", "release_version"):
            receipt[name] = manifest[name]
    if args.expected_projection and args.expected_projection != receipt["projection_sha256"]:
        raise ValueError("The build projection differs from the validated projection")
    if args.verify_worktree:
        if args.receipt and json.loads(args.receipt.read_text(encoding="utf-8")) != receipt:
            raise ValueError("Projection receipt identity mismatch")
        verify_worktree(args.output, entries, receipt, manifest, args.verify_native_inputs)
    else:
        materialize(root, args.output, entries, receipt)
        if args.receipt:
            args.receipt.write_text(json.dumps(receipt, sort_keys=True) + "\n", encoding="utf-8")
    if args.github_output:
        with args.github_output.open("a", encoding="utf-8") as output:
            for name in ("projection_sha256", "projected_tree_sha", "baseline_sha", "source_sha"):
                output.write(f"{name}={receipt[name]}\n")
    print(json.dumps(receipt, sort_keys=True))


if __name__ == "__main__":
    main()
