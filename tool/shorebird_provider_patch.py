import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess

from prepare_shorebird_patch import COMMIT, git, safe_path, tree


PIN = "config/university_provider.json"
CHECKOUT = "private/university_provider"


def read_pin(root, revision):
    try:
        value = json.loads(git(root, "show", f"{revision}:{PIN}"))
    except (subprocess.CalledProcessError, ValueError) as error:
        raise ValueError("A committed university provider pin is required") from error
    if not isinstance(value, dict) or set(value) != {"repository", "ref", "path"}:
        raise ValueError("University provider pin must contain repository, ref and path")
    if not isinstance(value["repository"], str) or not re.fullmatch(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", value["repository"]) or value["repository"].endswith(".git"):
        raise ValueError("Invalid university provider repository")
    if not isinstance(value["ref"], str) or not COMMIT.fullmatch(value["ref"]):
        raise ValueError("University provider requires a full immutable commit SHA")
    if value["path"] != ".":
        raise ValueError("Provider package layout changes require a full release")
    return value


def request(root, baseline, source, manifest):
    for revision in (baseline, source):
        if not isinstance(revision, str) or not COMMIT.fullmatch(revision):
            raise ValueError("Provider projection requires full public commit SHAs")
    git(root, "merge-base", "--is-ancestor", baseline, source)
    if not manifest or manifest.get("source_sha") != baseline:
        raise ValueError("Provider projection requires the registered baseline manifest")
    if not manifest.get("provider_sha"):
        if git(root, "ls-tree", baseline, "--", PIN) != git(root, "ls-tree", source, "--", PIN):
            raise ValueError("Provider changes require a registered provider baseline")
        return {"repository": "", "ref": "", "changed": False}
    before, after = read_pin(root, baseline), read_pin(root, source)
    if before["repository"] != after["repository"] or before["path"] != after["path"]:
        raise ValueError("Changing provider repository or package layout requires a full release")
    if before["ref"] != manifest["provider_sha"]:
        raise ValueError("Committed provider baseline differs from the registered release")
    return {"repository": after["repository"], "ref": after["ref"], "changed": before != after}


def verify_clean(root, revision):
    if root.is_symlink() or not root.is_dir() or Path(git(root, "rev-parse", "--show-toplevel").decode().strip()).resolve() != root.resolve():
        raise ValueError("Provider must be an independent repository checkout")
    if git(root, "rev-parse", "HEAD").decode().strip() != revision:
        raise ValueError("Provider checkout does not match the approved source pin")
    if git(root, "status", "--porcelain", "--untracked-files=all").strip():
        raise ValueError("Provider checkout has unrecorded changes")
    ignored = git(root, "ls-files", "--others", "--ignored", "--exclude-standard", "-z").decode().split("\0")
    for path in filter(None, ignored):
        parts = safe_path(path)
        if parts[0] not in {".dart_tool", "build", ".flutter-plugins", ".flutter-plugins-dependencies"}:
            raise ValueError(f"Unexpected ignored provider input: {path}")


def prepare(root, baseline, source, manifest, provider_root):
    selected = request(root, baseline, source, manifest)
    if not selected["ref"]:
        raise ValueError("Provider checkout has no registered baseline")
    verify_clean(provider_root, selected["ref"])
    base = manifest["provider_sha"]
    try:
        git(provider_root, "merge-base", "--is-ancestor", base, selected["ref"])
    except subprocess.CalledProcessError as error:
        raise ValueError("Provider baseline must be an ancestor of its approved source") from error
    before, after = tree(provider_root, base), tree(provider_root, selected["ref"])
    changed = sorted(path for path in before.keys() | after.keys() if before.get(path) != after.get(path))
    runtime, tests = [], []
    for path in changed:
        previous, current = before.get(path), after.get(path)
        if any(value and value.split()[0] not in {"100644", "100755"} for value in (previous, current)):
            raise ValueError("Provider special-file changes require a full release")
        if previous and current and previous.split()[0] != current.split()[0]:
            raise ValueError("Provider file mode changes require a full release")
        if path.startswith("lib/") and path.endswith(".dart"):
            runtime.append(path)
        elif path.startswith("test/") and path.endswith(".dart"):
            tests.append(path)
        else:
            raise ValueError(f"Provider dependency, native, asset or unknown changes require a full release: {path}")
    if not selected["changed"]:
        return None
    identity = {
        "repository": selected["repository"], "path": ".",
        "public_baseline_sha": baseline, "public_source_sha": source,
        "baseline_sha": base, "source_sha": selected["ref"],
        "baseline_tree_sha": git(provider_root, "rev-parse", f"{base}^{{tree}}").decode().strip(),
        "source_tree_sha": git(provider_root, "rev-parse", f"{selected['ref']}^{{tree}}").decode().strip(),
        "runtime_paths": runtime, "test_paths": tests,
    }
    identity["projection_sha256"] = hashlib.sha256(json.dumps(identity, sort_keys=True, separators=(",", ":")).encode()).hexdigest()
    return identity


def verify_receipt(root, manifest, receipt):
    provider = receipt.get("provider_projection")
    baseline, source = receipt.get("baseline_sha"), receipt.get("source_sha")
    selected = request(root, baseline, source, manifest)
    if not selected["changed"]:
        if provider is not None:
            raise ValueError("Unexpected provider projection for an unchanged source pin")
        return
    if not isinstance(provider, dict):
        raise ValueError("Changed provider pin requires provider projection evidence")
    expected = {
        "repository": selected["repository"], "path": ".",
        "public_baseline_sha": baseline, "public_source_sha": source,
        "baseline_sha": manifest["provider_sha"], "source_sha": selected["ref"],
    }
    if any(provider.get(key) != value for key, value in expected.items()):
        raise ValueError("Provider receipt does not match the approved pin and registered baseline")
    for key in ("baseline_tree_sha", "source_tree_sha"):
        if not isinstance(provider.get(key), str) or not COMMIT.fullmatch(provider[key]):
            raise ValueError("Invalid provider receipt tree identity")
    for key, prefix in (("runtime_paths", "lib/"), ("test_paths", "test/")):
        paths = provider.get(key)
        if not isinstance(paths, list) or paths != sorted(set(paths)):
            raise ValueError("Invalid provider receipt paths")
        for path in paths:
            safe_path(path)
            if not path.startswith(prefix) or not path.endswith(".dart"):
                raise ValueError("Provider receipt contains non-Dart runtime or test paths")
    data = {key: value for key, value in provider.items() if key != "projection_sha256"}
    digest = hashlib.sha256(json.dumps(data, sort_keys=True, separators=(",", ":")).encode()).hexdigest()
    if provider.get("projection_sha256") != digest:
        raise ValueError("Provider receipt projection digest differs")
    from prepare_shorebird_patch import projection
    _, expected_projection = projection(root, baseline, source, provider)
    if any(receipt.get(key) != expected_projection[key] for key in (
        "projection_sha256", "projected_tree_sha", "source_tree_sha",
    )):
        raise ValueError("Provider evidence differs from the combined projection identity")


def verify_workspace(root, manifest, receipt):
    verify_receipt(root, manifest, receipt)
    provider = receipt.get("provider_projection")
    if provider is None:
        raise ValueError("Provider workspace verification requires projection evidence")
    checkout = root / CHECKOUT
    from prepare_shorebird_patch import verify_checkout_path
    verify_checkout_path(root, ("private", "university_provider"), "university provider")
    actual = prepare(root, receipt["baseline_sha"], receipt["source_sha"], manifest, checkout)
    if actual != provider:
        raise ValueError("Provider checkout differs from the validated projection receipt")


def materialize(provider_root, output, revision):
    destination = output / CHECKOUT
    if destination.exists() or destination.is_symlink():
        raise ValueError("Provider projection destination must not exist")
    destination.parent.mkdir(parents=True, exist_ok=True)
    git(provider_root, "clone", "--quiet", "--local", "--no-hardlinks", "--no-checkout", "--no-recurse-submodules", str(provider_root), str(destination))
    git(destination, "config", "core.autocrlf", "false")
    git(destination, "checkout", "--quiet", "--detach", revision)
    verify_clean(destination, revision)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", type=Path, default=Path.cwd())
    parser.add_argument("--baseline", required=True)
    parser.add_argument("--source", required=True)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--github-output", type=Path)
    parser.add_argument("--verify-receipt", type=Path)
    args = parser.parse_args()
    from release_manifest import load_manifest
    manifest = load_manifest(args.manifest)
    selected = request(args.repo, args.baseline, args.source, manifest)
    if args.verify_receipt:
        receipt = json.loads(args.verify_receipt.read_text())
        if receipt.get("baseline_sha") != args.baseline or receipt.get("source_sha") != args.source:
            raise ValueError("Provider receipt public source differs from the requested promotion")
        verify_receipt(args.repo, manifest, receipt)
    if args.github_output:
        with args.github_output.open("a", encoding="utf-8") as output:
            for key in ("repository", "ref"):
                output.write(f"{key}={selected[key]}\n")
    print(json.dumps(selected, sort_keys=True))


if __name__ == "__main__":
    main()
