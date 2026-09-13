import argparse
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import subprocess
import tempfile


PRODUCERS = {
    "android": ".github/workflows/beta-release.yml",
    "ios": ".github/workflows/shorebird-release.yml",
}
REGISTRAR = ".github/workflows/shorebird-register.yml"
GENERATED = {
    "android": ("android/app/google-services.json", "android/tenant.properties"),
    "ios": ("ios/Flutter/Tenant.xcconfig", "ios/Podfile.lock"),
}
OPTIONAL_INPUTS = ("pubspec.lock",)
LOCKS = (("ios/Podfile.lock", "CocoaPods"), ("pubspec.lock", "Dart"))
PROVIDER = "private/university_provider"


def run(*args, cwd=None):
    return subprocess.check_output(args, cwd=cwd, text=True).strip()


def git(repo, *args):
    return run("git", "-c", f"safe.directory={repo.resolve().as_posix()}", "-C", str(repo), *args)


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def checkout_source(repo, relative, label):
    checkout = repo / relative
    if Path(git(checkout, "rev-parse", "--show-toplevel")).resolve() != checkout.resolve():
        raise ValueError(f"Missing {label} repository checkout")
    if git(checkout, "status", "--porcelain", "--untracked-files=all"):
        raise ValueError(f"{label.capitalize()} checkout has unrecorded changes")
    return git(checkout, "rev-parse", "HEAD")


def private_source(repo):
    return checkout_source(repo, "android/private/nfc-pass-android", "private native")


def provider_source(repo):
    return checkout_source(repo, PROVIDER, "university provider")


def require(pattern, value, label):
    if not isinstance(value, str) or not re.fullmatch(pattern, value):
        raise ValueError(f"Invalid {label}")
    return value


def safe_path(root, name):
    if not isinstance(name, str) or not name or name in (".", ".."):
        raise ValueError("Unsafe artifact path")
    path = PurePosixPath(name)
    if path.is_absolute() or ".." in path.parts or "\\" in name or ":" in name:
        raise ValueError("Unsafe artifact path")
    target = root / path
    if target.is_symlink() or not target.resolve().is_relative_to(root.resolve()):
        raise ValueError("Artifact path escapes its directory")
    return target


def read_app_id(repo, source_sha, platform):
    require(r"[0-9a-f]{40}", source_sha, "source SHA")
    if platform not in PRODUCERS:
        raise ValueError("Unsupported platform")
    text = git(repo, "show", f"{source_sha}:shorebird.yaml")
    pattern = r"^app_id:\s*([0-9a-f-]+)\s*$" if platform == "ios" else r"^  production:\s*([0-9a-f-]+)\s*$"
    matches = re.findall(pattern, text, re.MULTILINE)
    if len(matches) != 1:
        raise ValueError("Ambiguous production Shorebird app identity")
    return require(r"[0-9a-f]{8}(?:-[0-9a-f]{4}){3}-[0-9a-f]{12}", matches[0], "app ID")


def read_private_native_ref(repo, source_sha):
    workflow = git(repo, "show", f"{source_sha}:{PRODUCERS['android']}")
    steps = re.split(r"(?m)^      - ", workflow)
    candidates = [step for step in steps if re.search(r"(?m)^          path: android/private/nfc-pass-android\s*$", step)]
    if len(candidates) != 1:
        raise ValueError("Historical release has no unique private native checkout")
    pins = re.findall(r"(?m)^          ref: ([0-9a-f]{40})\s*$", candidates[0])
    if len(pins) != 1:
        raise ValueError("Historical private native checkout was not pinned")
    return pins[0]


def config_digests():
    root = Path(os.environ["RUNNER_TEMP"])
    return {name: hashlib.sha256(json.dumps(json.loads(safe_path(root, name).read_text(encoding="utf-8")), sort_keys=True, separators=(",", ":")).encode()).hexdigest() for name in ("firebase.json", "university.json")}


def load_shorebird_release(app_id, version):
    output = run("shorebird", "releases", "list", "--app-id", app_id, "--json")
    envelopes = [json.loads(line) for line in output.splitlines() if line.startswith("{")]
    if len(envelopes) != 1 or envelopes[0].get("status") != "success":
        raise ValueError("Invalid Shorebird release inventory")
    matches = [item for item in envelopes[0]["data"]["releases"] if item["version"] == version]
    if len(matches) != 1:
        raise ValueError("Release is missing or ambiguous in Shorebird")
    return matches[0]


def validate_manifest(manifest):
    if not isinstance(manifest, dict) or type(manifest.get("schema_version")) is not int or manifest.get("schema_version") != 1 or manifest.get("platform") not in PRODUCERS:
        raise ValueError("Unsupported release manifest")
    for field in ("source_sha", "source_tree", "flutter_revision"):
        require(r"[0-9a-f]{40}", manifest.get(field), field)
    require(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", manifest.get("repository"), "repository")
    require(r"[0-9a-f]{8}(?:-[0-9a-f]{4}){3}-[0-9a-f]{12}", manifest.get("app_id"), "app ID")
    require(r"[0-9]+\.[0-9]+\.[0-9]+(?:-[A-Za-z0-9.-]+)?\+[0-9]+(?:\.[0-9]+)*", manifest.get("release_version"), "release version")
    require(r"[0-9]+\.[0-9]+\.[0-9]+(?:-[A-Za-z0-9.-]+)?", manifest.get("flutter_version"), "Flutter version")
    if type(manifest.get("release_id")) is not int or manifest["release_id"] <= 0:
        raise ValueError("Invalid Shorebird release ID")
    if manifest.get("target") != "lib/main/main_production.dart" or manifest.get("flavor") != ("production" if manifest["platform"] == "android" else None):
        raise ValueError("Unexpected production build target")
    evidence = manifest.get("evidence", {})
    if not isinstance(evidence, dict) or evidence.get("kind") not in ("release", "legacy") or evidence.get("workflow_path") != PRODUCERS[manifest["platform"]]:
        raise ValueError("Untrusted release producer")
    for key in ("run_id", "run_attempt"):
        if type(evidence.get(key)) is not int or evidence[key] <= 0:
            raise ValueError(f"Invalid evidence {key}")
    require(r"[0-9a-f]{40}", evidence.get("head_sha"), "producer head")
    if evidence.get("source_ref") != "refs/heads/master":
        raise ValueError("Release must originate on the protected branch")
    signer = REGISTRAR if evidence["kind"] == "legacy" else evidence["workflow_path"]
    if evidence.get("signing_workflow", signer) != signer:
        raise ValueError("Unexpected manifest signer")
    require(r"[0-9a-f]{40}", evidence.get("signing_sha", evidence["head_sha"]), "signer SHA")
    inputs = manifest.get("build_inputs")
    if not isinstance(inputs, dict) or set(inputs) - set(GENERATED[manifest["platform"]]) - set(OPTIONAL_INPUTS):
        raise ValueError("Unsupported prepared build input")
    if evidence["kind"] == "release" and not set(inputs) >= set(GENERATED[manifest["platform"]]):
        raise ValueError("Release is missing prepared build inputs")
    if evidence["kind"] == "legacy":
        missing = evidence.get("missing_prepared_inputs")
        if not isinstance(missing, list) or any(not isinstance(value, str) for value in missing) or set(missing) != set(GENERATED[manifest["platform"]]) - set(inputs) or len(missing) != len(set(missing)):
            raise ValueError("Legacy release must declare exact missing historical build inputs")
        for key in ("registration_run_id", "registration_run_attempt"):
            if type(evidence.get(key)) is not int or evidence[key] <= 0:
                raise ValueError("Invalid registration identity")
        require(r"[0-9a-f]{40}", evidence.get("signing_sha"), "registration signer SHA")
    for digest in inputs.values():
        require(r"[0-9a-f]{64}", digest, "build input digest")
    artifacts = manifest.get("artifacts")
    if not isinstance(artifacts, list) or not artifacts:
        raise ValueError("Release has no artifact evidence")
    names = set()
    for artifact in artifacts:
        if not isinstance(artifact, dict):
            raise ValueError("Invalid artifact record")
        name = artifact.get("name", "")
        if not isinstance(name, str) or not name or name in (".", "..") or PurePosixPath(name).name != name or "\\" in name or ":" in name or name in names:
            raise ValueError("Invalid or duplicate artifact name")
        names.add(name)
        require(r"[0-9a-f]{64}", artifact.get("sha256"), "artifact digest")
        if type(artifact.get("size")) is not int or artifact["size"] <= 0:
            raise ValueError("Invalid artifact size")
    if manifest.get("private_native_sha") is not None:
        require(r"[0-9a-f]{40}", manifest["private_native_sha"], "private native source")
    elif manifest["platform"] == "android":
        raise ValueError("Android release is missing private native source")
    if manifest.get("provider_sha") is not None:
        require(r"[0-9a-f]{40}", manifest["provider_sha"], "university provider source")
        if "pubspec.lock" not in inputs:
            raise ValueError("Provider release is missing its resolved dependency lock")
    configs = manifest.get("configuration_inputs", {})
    if not isinstance(configs, dict) or set(configs) - {"firebase.json", "university.json"}:
        raise ValueError("Unexpected configuration inputs")
    if evidence["kind"] == "release" and set(configs) != {"firebase.json", "university.json"}:
        raise ValueError("Release is missing canonical configuration digests")
    for digest in configs.values():
        require(r"[0-9a-f]{64}", digest, "configuration digest")
    return manifest


def load_manifest(path):
    if path.is_symlink():
        raise ValueError("Manifest must be a regular file")
    return validate_manifest(json.loads(path.read_text(encoding="utf-8")))


def write_manifest(path, manifest):
    validate_manifest(manifest)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(manifest, sort_keys=True, indent=2) + "\n", encoding="utf-8")


def build_manifest(*, repo, platform, release_version, source_sha, artifact_dir, evidence, live_release=None):
    app_id = read_app_id(repo, source_sha, platform)
    live = live_release or load_shorebird_release(app_id, release_version)
    if live.get("app_id") != app_id or live.get("version") != release_version or live.get("platform_statuses", {}).get(platform) != "active":
        raise ValueError("Release identity does not match the built platform")
    artifacts = []
    for path in sorted(artifact_dir.rglob("*")):
        if path.is_file() and path.name != "release-manifest.json" and (path.suffix in (".apk", ".aab", ".ipa", ".cms") or path.name in ("Podfile.lock", "pubspec.lock")):
            if path.is_symlink():
                raise ValueError("Artifact must not be a symlink")
            artifacts.append({"name": path.name, "sha256": sha256(path), "size": path.stat().st_size})
    inputs = {}
    private_native_sha = None
    provider_sha = None
    if evidence["kind"] == "release":
        for name in GENERATED[platform]:
            target = safe_path(repo, name)
            if not target.is_file():
                raise ValueError(f"Missing prepared build input: {name}")
            inputs[name] = sha256(target)
        if platform == "android":
            private_native_sha = private_source(repo)
        if (repo / PROVIDER).is_dir():
            provider_sha = provider_source(repo)
            inputs["pubspec.lock"] = sha256(safe_path(repo, "pubspec.lock"))
    elif platform == "android":
        private_native_sha = read_private_native_ref(repo, source_sha)
    manifest = {
        "schema_version": 1, "repository": os.environ["GITHUB_REPOSITORY"],
        "source_sha": source_sha, "source_tree": git(repo, "rev-parse", f"{source_sha}^{{tree}}"),
        "platform": platform, "app_id": app_id, "release_version": release_version,
        "release_id": live["id"], "flutter_version": live["flutter_version"],
        "flutter_revision": live["flutter_revision"], "target": "lib/main/main_production.dart",
        "flavor": "production" if platform == "android" else None,
        "build_inputs": inputs, "private_native_sha": private_native_sha,
        "provider_sha": provider_sha,
        "configuration_inputs": config_digests() if evidence["kind"] == "release" else {},
        "artifacts": artifacts, "evidence": evidence,
    }
    return validate_manifest(manifest)


def api(path):
    return json.loads(run("gh", "api", path))


def verify_run(repository, evidence):
    result = api(f"repos/{repository}/actions/runs/{evidence['run_id']}")
    expected = {"path": evidence["workflow_path"], "head_branch": "master", "head_sha": evidence["head_sha"], "status": "completed", "conclusion": "success"}
    if any(result.get(key) != value for key, value in expected.items()) or result.get("event") not in ("workflow_dispatch", "workflow_run"):
        raise ValueError("Originating release run is not a successful trusted run")
    if result.get("repository", {}).get("full_name") != repository or result.get("head_repository", {}).get("full_name") != repository:
        raise ValueError("Release run belongs to a different repository")
    if type(result.get("run_attempt")) is not int or result["run_attempt"] < evidence["run_attempt"]:
        raise ValueError("Release run predates its signed producer attempt")


def registry_tag(platform, version):
    if platform not in PRODUCERS:
        raise ValueError("Unsupported platform")
    require(r"[0-9]+\.[0-9]+\.[0-9]+(?:-[A-Za-z0-9.-]+)?\+[0-9]+(?:\.[0-9]+)*", version, "release version")
    return f"shorebird-{platform}-{version}"


def resolve(platform, version, output, github_output=None):
    repository = os.environ["GITHUB_REPOSITORY"]
    tag = registry_tag(platform, version)
    with tempfile.TemporaryDirectory() as directory:
        root = Path(directory)
        run("gh", "release", "download", tag, "--repo", repository, "--pattern", "release-manifest.json", "--dir", str(root))
        path = root / "release-manifest.json"
        manifest = load_manifest(path)
        if (manifest["repository"], manifest["platform"], manifest["release_version"]) != (repository, platform, version):
            raise ValueError("Registry manifest identity mismatch")
        evidence = manifest["evidence"]
        signer = REGISTRAR if evidence["kind"] == "legacy" else evidence["workflow_path"]
        run("gh", "attestation", "verify", str(path), "--repo", repository, "--signer-workflow", f"{repository}/{signer}", "--source-ref", "refs/heads/master", "--source-digest", evidence.get("signing_sha", evidence["head_sha"]), "--deny-self-hosted-runners")
        verify_run(repository, evidence)
        if evidence["kind"] == "legacy":
            registration = {**evidence, "run_id": evidence["registration_run_id"], "run_attempt": evidence.get("registration_run_attempt", 1), "head_sha": evidence["signing_sha"], "workflow_path": REGISTRAR}
            verify_run(repository, registration)
        locks = []
        for name, label in LOCKS:
            if name not in manifest["build_inputs"]:
                continue
            asset = PurePosixPath(name).name
            run("gh", "release", "download", tag, "--repo", repository, "--pattern", asset, "--dir", str(root))
            lock = root / asset
            if sha256(lock) != manifest["build_inputs"][name]:
                raise ValueError(f"Stored {label} lock digest mismatch")
            locks.append(lock)
        output.parent.mkdir(parents=True, exist_ok=True)
        for lock in locks:
            (output.parent / lock.name).write_bytes(lock.read_bytes())
        output.write_bytes(path.read_bytes())
    if github_output:
        values = {key: manifest[key] for key in ("app_id", "release_version", "flutter_version")}
        values.update(baseline_sha=manifest["source_sha"], manifest_sha256=sha256(output), manifest_path=str(output.resolve()), private_native_sha=manifest.get("private_native_sha") or "", provider_sha=manifest.get("provider_sha") or "")
        with github_output.open("a", encoding="utf-8") as stream:
            for key, value in values.items():
                if "\n" in str(value) or "\r" in str(value):
                    raise ValueError("Invalid workflow output")
                stream.write(f"{key}={value}\n")
    return manifest


def verify_live(manifest):
    live = load_shorebird_release(manifest["app_id"], manifest["release_version"])
    for field, remote in (("release_id", "id"), ("app_id", "app_id"), ("release_version", "version"), ("flutter_revision", "flutter_revision"), ("flutter_version", "flutter_version")):
        if manifest[field] != live.get(remote):
            raise ValueError(f"Live Shorebird identity mismatch: {field}")
    if live.get("platform_statuses", {}).get(manifest["platform"]) != "active":
        raise ValueError("Release is not active for this platform")


def verify_native_config(repo, manifest):
    for name, digest in manifest["build_inputs"].items():
        target = safe_path(repo, name)
        if not target.is_file() or sha256(target) != digest:
            raise ValueError(f"Prepared build input differs from the release: {name}")
    if manifest.get("private_native_sha") and private_source(repo) != manifest["private_native_sha"]:
        raise ValueError("Private native module differs from the release")
    if manifest.get("provider_sha") and provider_source(repo) != manifest["provider_sha"]:
        raise ValueError("University provider differs from the release")
    if manifest.get("configuration_inputs") and config_digests() != manifest["configuration_inputs"]:
        raise ValueError("Release configuration differs from its recorded canonical input")


def publish(path, artifacts_dir):
    manifest = load_manifest(path)
    repository = os.environ["GITHUB_REPOSITORY"]
    if manifest["repository"] != repository or os.environ.get("GITHUB_REF") != "refs/heads/master":
        raise ValueError("Registry publication requires the protected repository branch")
    tag = registry_tag(manifest["platform"], manifest["release_version"])
    assets = [path]
    for name, label in LOCKS:
        if name not in manifest["build_inputs"]:
            continue
        lock = safe_path(artifacts_dir, PurePosixPath(name).name)
        if not lock.is_file() or sha256(lock) != manifest["build_inputs"][name]:
            raise ValueError(f"{label} lock does not match the manifest")
        assets.append(lock)
    existing = subprocess.run(["gh", "release", "view", tag, "--repo", repository, "--json", "tagName"], capture_output=True, text=True)
    if existing.returncode == 0:
        with tempfile.TemporaryDirectory() as directory:
            for asset in assets:
                run("gh", "release", "download", tag, "--repo", repository, "--pattern", asset.name, "--dir", directory)
                if sha256(Path(directory) / asset.name) != sha256(asset):
                    raise ValueError("Release provenance is write-once; refusing conflicting replacement")
        return
    run("gh", "release", "create", tag, *(str(asset) for asset in assets), "--repo", repository, "--target", manifest["source_sha"], "--title", f"Shorebird {manifest['platform']} {manifest['release_version']}", "--notes", "", "--prerelease")


def main():
    parser = argparse.ArgumentParser()
    commands = parser.add_subparsers(dest="command", required=True)
    create = commands.add_parser("create")
    for name in ("platform", "release-version", "source-sha"):
        create.add_argument(f"--{name}", required=True)
    create.add_argument("--artifact-dir", type=Path, required=True)
    create.add_argument("--output", type=Path, required=True)
    resolver = commands.add_parser("resolve")
    resolver.add_argument("--platform", required=True)
    resolver.add_argument("--release-version", required=True)
    resolver.add_argument("--output", type=Path, required=True)
    resolver.add_argument("--github-output", type=Path)
    for command in ("publish", "verify-live", "verify-inputs"):
        child = commands.add_parser(command)
        child.add_argument("--manifest", type=Path, required=True)
        if command == "publish":
            child.add_argument("--artifacts-dir", type=Path, required=True)
        if command == "verify-inputs":
            child.add_argument("--repo", type=Path, default=Path.cwd())
    args = parser.parse_args()
    if args.command == "create":
        workflow = os.environ["GITHUB_WORKFLOW_REF"].split("/", 2)[2].split("@", 1)[0]
        evidence = {"kind": "release", "run_id": int(os.environ["GITHUB_RUN_ID"]), "run_attempt": int(os.environ["GITHUB_RUN_ATTEMPT"]), "workflow_path": workflow, "head_sha": os.environ["GITHUB_SHA"], "source_ref": os.environ["GITHUB_REF"], "signing_sha": os.environ["GITHUB_SHA"]}
        write_manifest(args.output, build_manifest(repo=Path.cwd(), platform=args.platform, release_version=args.release_version, source_sha=args.source_sha, artifact_dir=args.artifact_dir, evidence=evidence))
    elif args.command == "resolve":
        resolve(args.platform, args.release_version, args.output, args.github_output)
    elif args.command == "publish":
        publish(args.manifest, args.artifacts_dir)
    elif args.command == "verify-live":
        verify_live(load_manifest(args.manifest))
    else:
        verify_native_config(args.repo, load_manifest(args.manifest))


if __name__ == "__main__":
    main()
