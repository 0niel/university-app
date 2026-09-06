import argparse
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import plistlib
import re
import shutil
import stat
import subprocess
import tempfile
import zipfile


WORKFLOWS = {
    "android": ".github/workflows/beta-release.yml",
    "ios": ".github/workflows/shorebird-release.yml",
}
BUNDLE_IDS = {"android": "ninja.mirea.mireaapp", "ios": "pro.oniel.it.university"}
MAX_ARCHIVE_BYTES = 2 * 1024 * 1024 * 1024
MAX_CONTENT_BYTES = 4 * 1024 * 1024 * 1024


def command(arguments, **kwargs):
    result = subprocess.run(arguments, stderr=subprocess.PIPE, **kwargs)
    if result.returncode:
        raise ValueError(f"Release inspection command failed: {Path(arguments[0]).name}")
    return result


def api(path):
    result = command(["gh", "api", path], stdout=subprocess.PIPE)
    return json.loads(result.stdout)


def positive_id(value):
    if isinstance(value, bool) or not re.fullmatch(r"[1-9][0-9]*", str(value)):
        raise ValueError("A positive run or artifact ID is required")
    return int(value)


def verify_run(run, repository, run_id, platform):
    expected = {
        "id": run_id,
        "path": WORKFLOWS[platform],
        "head_branch": "master",
        "event": "workflow_dispatch",
        "status": "completed",
        "conclusion": "success",
    }
    if any(run.get(key) != value for key, value in expected.items()):
        raise ValueError("The origin must be a successful manual full release on master")
    if any(run.get(key, {}).get("full_name") != repository for key in ("repository", "head_repository")):
        raise ValueError("Release repository identity mismatch")
    if not isinstance(run.get("head_sha"), str) or not re.fullmatch(r"[0-9a-f]{40}", run["head_sha"]):
        raise ValueError("Release source SHA is invalid")
    positive_id(run.get("run_attempt"))
    return run["head_sha"]


def find_artifact(repository, run, platform):
    matches = []
    for page in range(1, 11):
        response = api(f"repos/{repository}/actions/runs/{run['id']}/artifacts?per_page=100&page={page}")
        artifacts = response["artifacts"]
        for artifact in artifacts:
            name = artifact.get("name", "")
            if (platform == "android" and name.startswith("android-beta-")) or (
                platform == "ios" and name == "ios-shorebird-release"
            ):
                matches.append(artifact)
        if len(artifacts) < 100:
            break
    else:
        raise ValueError("Release artifact listing exceeds its bounded limit")
    if len(matches) != 1:
        raise ValueError("The full release must have exactly one matching artifact")
    artifact = matches[0]
    origin = artifact.get("workflow_run", {})
    if origin.get("id") != run["id"] or origin.get("head_sha") != run["head_sha"] or origin.get("head_branch") != "master":
        raise ValueError("Artifact origin does not match the verified release")
    positive_id(artifact.get("id"))
    if artifact.get("expired") is not False or not isinstance(artifact.get("digest"), str) or not re.fullmatch(r"sha256:[0-9a-f]{64}", artifact["digest"]):
        raise ValueError("The immutable artifact is expired or has no verifiable digest")
    size = artifact.get("size_in_bytes")
    if not isinstance(size, int) or isinstance(size, bool) or not 0 < size <= MAX_ARCHIVE_BYTES:
        raise ValueError("Release archive size is invalid")
    return artifact


def digest(path):
    with path.open("rb") as source:
        return hashlib.file_digest(source, "sha256").hexdigest()


def archive_entries(archive):
    entries = archive.infolist()
    seen = set()
    total = 0
    for entry in entries:
        name = entry.orig_filename
        path = PurePosixPath(name)
        mode = entry.external_attr >> 16
        if (
            not name or "\\" in name or "\x00" in name or ":" in name
            or path.is_absolute() or ".." in path.parts
            or stat.S_ISLNK(mode) or entry.flag_bits & 1
            or name.casefold() in seen
        ):
            raise ValueError("Unsafe or ambiguous release archive entry")
        seen.add(name.casefold())
        total += entry.file_size
        if total > MAX_CONTENT_BYTES or entry.file_size > MAX_ARCHIVE_BYTES:
            raise ValueError("Release archive exceeds its content limit")
    return entries


def extract_binary(archive_path, output_dir, platform):
    suffix = ".apk" if platform == "android" else ".ipa"
    with zipfile.ZipFile(archive_path) as archive:
        candidates = [entry for entry in archive_entries(archive) if not entry.is_dir() and entry.filename.endswith(suffix)]
        if len(candidates) != 1:
            raise ValueError("The release artifact must contain exactly one application binary")
        target = output_dir / ("application" + suffix)
        with archive.open(candidates[0]) as source, target.open("xb") as destination:
            shutil.copyfileobj(source, destination)
    return target


def aapt_path():
    for name in ("ANDROID_HOME", "ANDROID_SDK_ROOT"):
        root = os.environ.get(name)
        if root:
            candidates = sorted((Path(root) / "build-tools").glob("*/aapt"), reverse=True)
            if candidates:
                return str(candidates[0])
    available = shutil.which("aapt")
    if available:
        return available
    raise ValueError("Android SDK aapt is required to inspect the APK")


def binary_identity(path, platform):
    if platform == "ios":
        with zipfile.ZipFile(path) as archive:
            candidates = [entry for entry in archive_entries(archive) if re.fullmatch(r"Payload/[^/]+\.app/Info\.plist", entry.filename)]
            if len(candidates) != 1 or candidates[0].file_size > 1024 * 1024:
                raise ValueError("The IPA must have exactly one bounded application plist")
            values = plistlib.loads(archive.read(candidates[0]))
        bundle = values.get("CFBundleIdentifier")
        version = values.get("CFBundleShortVersionString")
        number = values.get("CFBundleVersion")
    else:
        result = command([aapt_path(), "dump", "badging", str(path)], stdout=subprocess.PIPE)
        lines = [line for line in result.stdout.decode().splitlines() if line.startswith("package:")]
        if len(lines) != 1:
            raise ValueError("APK package metadata is missing or ambiguous")
        fields = dict(re.findall(r"(\w+)='([^']*)'", lines[0]))
        bundle, version, number = (fields.get(key) for key in ("name", "versionName", "versionCode"))
    if bundle != BUNDLE_IDS[platform]:
        raise ValueError("Application bundle identity mismatch")
    if not isinstance(version, str) or not re.fullmatch(r"[0-9]+\.[0-9]+\.[0-9]+", version):
        raise ValueError("Application marketing version is invalid")
    pattern = r"[1-9][0-9]*" if platform == "android" else r"[0-9]+(?:\.[0-9]+){0,2}"
    if not isinstance(number, str) or not re.fullmatch(pattern, number):
        raise ValueError("Application build number is invalid")
    return f"{version}+{number}"


def import_release(*, repo, repository, run_id, platform, output_dir):
    import release_manifest

    if not re.fullmatch(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", repository):
        raise ValueError("GitHub repository identity is invalid")
    run_id = positive_id(run_id)
    run = api(f"repos/{repository}/actions/runs/{run_id}")
    source = verify_run(run, repository, run_id, platform)
    command(["git", "-C", str(repo), "merge-base", "--is-ancestor", source, "HEAD"], stdout=subprocess.PIPE)
    artifact = find_artifact(repository, run, platform)
    output_dir.mkdir(parents=True, exist_ok=True)
    if output_dir.is_symlink() or any(output_dir.iterdir()):
        raise ValueError("Manifest output directory must be empty and regular")
    with tempfile.TemporaryDirectory() as directory:
        archive = Path(directory) / "release.zip"
        with archive.open("xb") as destination:
            command(["gh", "api", f"repos/{repository}/actions/artifacts/{artifact['id']}/zip"], stdout=destination)
        if archive.stat().st_size > MAX_ARCHIVE_BYTES or "sha256:" + digest(archive) != artifact["digest"]:
            raise ValueError("Downloaded archive differs from its immutable artifact digest")
        binary = extract_binary(archive, output_dir, platform)
    version = binary_identity(binary, platform)
    if platform == "android" and artifact["name"] != "android-beta-" + version:
        raise ValueError("Artifact name differs from the actual APK version")
    app_id = release_manifest.read_app_id(repo, source, platform)
    live = release_manifest.load_shorebird_release(app_id, version)
    if live.get("app_id") != app_id or live.get("version") != version or live.get("platform_statuses", {}).get(platform) != "active":
        raise ValueError("The original application does not match an active Shorebird release")
    evidence = {
        "kind": "legacy",
        "run_id": run_id,
        "run_attempt": run["run_attempt"],
        "workflow_path": run["path"],
        "head_sha": source,
        "source_ref": "refs/heads/master",
        "artifact": {key: artifact[key] for key in ("id", "digest", "name")},
        "missing_prepared_inputs": list(release_manifest.GENERATED[platform]),
        "signing_workflow": ".github/workflows/shorebird-register.yml",
        "signing_sha": os.environ["GITHUB_SHA"],
        "registration_run_id": positive_id(os.environ["GITHUB_RUN_ID"]),
        "registration_run_attempt": positive_id(os.environ["GITHUB_RUN_ATTEMPT"]),
    }
    if platform == "android":
        evidence["private_native_provenance"] = "producer-workflow-pin"
    manifest = release_manifest.build_manifest(
        repo=repo, platform=platform, release_version=version, source_sha=source,
        artifact_dir=output_dir, evidence=evidence, live_release=live,
    )
    release_manifest.write_manifest(output_dir / "release-manifest.json", manifest)
    return manifest


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--run-id", required=True)
    parser.add_argument("--platform", choices=tuple(WORKFLOWS), required=True)
    parser.add_argument("--repo", type=Path, default=Path.cwd())
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args()
    try:
        manifest = import_release(
            repo=args.repo.resolve(), repository=os.environ["GITHUB_REPOSITORY"],
            run_id=args.run_id, platform=args.platform, output_dir=args.output_dir,
        )
    except (ValueError, OSError, KeyError, zipfile.BadZipFile, plistlib.InvalidFileException):
        parser.exit(1, "Release registration failed: origin, artifact, or binary evidence is invalid or unavailable\n")
    print(json.dumps({key: manifest[key] for key in ("platform", "release_version", "source_sha")}))


if __name__ == "__main__":
    main()
