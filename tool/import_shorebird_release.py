import argparse
from datetime import datetime, timedelta
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import plistlib
import re
import shutil
import stat
import subprocess
import sys
import tempfile
import zipfile


WORKFLOWS = {
    "android": ".github/workflows/beta-release.yml",
    "ios": ".github/workflows/shorebird-release.yml",
}
BUNDLE_IDS = {"android": "ninja.mirea.mireaapp", "ios": "pro.oniel.it.university"}
MAX_ARCHIVE_BYTES = 2 * 1024 * 1024 * 1024
MAX_CONTENT_BYTES = 4 * 1024 * 1024 * 1024


class RegistrationError(ValueError):
    pass


def command(arguments, **kwargs):
    result = subprocess.run(arguments, stderr=subprocess.PIPE, **kwargs)
    if result.returncode:
        failure = "command failure"
        stderr = result.stderr.decode("utf-8", errors="replace") if isinstance(result.stderr, bytes) else (result.stderr or "")
        for pattern, label in (
            (r"HTTP 40[13]|authentication|not accessible by integration", "authentication or permissions"),
            (r"HTTP 429|rate limit", "rate limit"),
            (r"HTTP 5[0-9]{2}|timeout|timed out|connection|TLS", "network or provider availability"),
            (r"unknown flag|unknown command", "unsupported command interface"),
            (r"no attestations|failed to verify|verification failed", "attestation verification"),
        ):
            if re.search(pattern, stderr, re.IGNORECASE):
                failure = label
                break
        executable = arguments[0] if arguments[0] in ("gh", "git") else "binary inspector"
        raise RegistrationError(f"Release inspection command failed: {executable} (exit {result.returncode}; {failure})")
    return result


def api(path):
    result = command(["gh", "api", path], stdout=subprocess.PIPE)
    return json.loads(result.stdout)


def positive_id(value):
    if isinstance(value, bool) or not re.fullmatch(r"[1-9][0-9]*", str(value)):
        raise RegistrationError("A positive run or artifact ID is required")
    return int(value)


def verify_run(run, repository, run_id, platform):
    expected = {
        "id": run_id,
        "path": WORKFLOWS[platform],
        "head_branch": "master",
        "status": "completed",
        "conclusion": "success",
    }
    events = ("workflow_dispatch", "workflow_run") if platform == "android" else ("workflow_dispatch",)
    if any(run.get(key) != value for key, value in expected.items()) or run.get("event") not in events:
        raise RegistrationError("The origin must be a successful trusted full release on master")
    if any(run.get(key, {}).get("full_name") != repository for key in ("repository", "head_repository")):
        raise RegistrationError("Release repository identity mismatch")
    if not isinstance(run.get("head_sha"), str) or not re.fullmatch(r"[0-9a-f]{40}", run["head_sha"]):
        raise RegistrationError("Release source SHA is invalid")
    positive_id(run.get("run_attempt"))
    return run["head_sha"]


def verify_apk_attestation(binary, repository, run):
    source = run["head_sha"]
    repository_uri = f"https://github.com/{repository}"
    workflow_uri = f"{repository_uri}/{WORKFLOWS['android']}@refs/heads/master"
    invocation = f"{repository_uri}/actions/runs/{run['id']}/attempts/{run['run_attempt']}"
    result = command([
        "gh", "attestation", "verify", str(binary), "--repo", repository,
        "--signer-workflow", f"{repository}/{WORKFLOWS['android']}",
        "--source-ref", "refs/heads/master",
        "--source-digest", source, "--signer-digest", source,
        "--deny-self-hosted-runners", "--format", "json",
    ], stdout=subprocess.PIPE)
    verified = json.loads(result.stdout)
    if not isinstance(verified, list) or not verified:
        raise RegistrationError("No verified APK provenance")
    expected = {
        "issuer": "https://token.actions.githubusercontent.com",
        "subjectAlternativeName": workflow_uri,
        "buildSignerURI": workflow_uri, "buildSignerDigest": source,
        "buildConfigURI": workflow_uri, "buildConfigDigest": source,
        "sourceRepositoryURI": repository_uri, "sourceRepositoryDigest": source,
        "sourceRepositoryRef": "refs/heads/master",
        "sourceRepositoryIdentifier": str(positive_id(run["repository"]["id"])),
        "sourceRepositoryOwnerIdentifier": str(positive_id(run["repository"]["owner"]["id"])),
        "runnerEnvironment": "github-hosted", "buildTrigger": "workflow_run",
        "runInvocationURI": invocation,
    }
    binary_digest = digest(binary)
    matches = []
    for item in verified:
        if not isinstance(item, dict):
            raise RegistrationError("Invalid APK verification result")
        verification = item.get("verificationResult", {})
        certificate = verification.get("signature", {}).get("certificate", {})
        if any(certificate.get(key) != value for key, value in expected.items()):
            continue
        statement = verification.get("statement", {})
        definition = statement.get("predicate", {}).get("buildDefinition", {})
        details = statement.get("predicate", {}).get("runDetails", {})
        subjects = statement.get("subject", [])
        if (
            statement.get("_type") != "https://in-toto.io/Statement/v1"
            or statement.get("predicateType") != "https://slsa.dev/provenance/v1"
            or definition.get("buildType") != "https://actions.github.io/buildtypes/workflow/v1"
            or definition.get("externalParameters", {}).get("workflow") != {
                "repository": repository_uri, "path": WORKFLOWS["android"], "ref": "refs/heads/master",
            }
            or definition.get("internalParameters", {}).get("github", {}).get("event_name") != "workflow_run"
            or definition.get("resolvedDependencies") != [{
                "uri": f"git+{repository_uri}@refs/heads/master", "digest": {"gitCommit": source},
            }]
            or details.get("builder", {}).get("id") != workflow_uri
            or details.get("metadata", {}).get("invocationId") != invocation
            or not isinstance(subjects, list)
            or len([subject for subject in subjects if isinstance(subject, dict)
                and subject.get("digest") == {"sha256": binary_digest}
                and isinstance(subject.get("name"), str) and subject["name"].endswith(".apk")]) != 1
        ):
            raise RegistrationError("APK statement differs from its verified producer identity")
        matches.append(statement)
    if len(matches) != 1:
        raise RegistrationError("APK provenance does not uniquely match the exact producer attempt")
    return {"sha256": binary_digest, "invocation_uri": invocation}


def paginated(path, field):
    entries = []
    separator = "&" if "?" in path else "?"
    for page in range(1, 11):
        batch = api(f"{path}{separator}per_page=100&page={page}")[field]
        entries.extend(batch)
        if len(batch) < 100:
            return entries
    raise RegistrationError("Release evidence listing exceeds its bounded limit")


def checkout_log_lines(output, step):
    def timestamp(value):
        if not isinstance(value, str) or not re.fullmatch(r"[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(?:\.[0-9]+)?Z", value):
            raise RegistrationError("Checkout evidence has an invalid timestamp")
        return datetime.fromisoformat(value)

    started = timestamp(step.get("started_at"))
    completed = timestamp(step.get("completed_at"))
    if completed < started:
        raise RegistrationError("Checkout evidence has an invalid step interval")
    end = completed + timedelta(seconds=1)
    lines = []
    in_checkout = False
    for line in output.decode("utf-8-sig").splitlines():
        date, separator, message = line.partition(" ")
        if not separator:
            continue
        observed = timestamp(date)
        if not started <= observed < end:
            continue
        if message.startswith("##[group]Run "):
            if in_checkout:
                break
            if not re.fullmatch(r"##\[group\]Run actions/checkout@[0-9a-f]{40}", message):
                raise RegistrationError("Checkout interval starts with an unexpected action")
            in_checkout = True
        elif in_checkout:
            lines.append(message)
    if not in_checkout:
        raise RegistrationError("Checkout action is missing from its recorded step interval")
    return lines


def verify_automatic_checkouts(repository, run):
    jobs = paginated(f"repos/{repository}/actions/runs/{run['id']}/attempts/{run['run_attempt']}/jobs", "jobs")
    checked = []
    for name in ("prepare", "Android beta"):
        candidates = [job for job in jobs if job.get("name") == name]
        if len(candidates) != 1:
            raise RegistrationError("Automatic release checkout job is missing or ambiguous")
        job = candidates[0]
        expected = {"run_id": run["id"], "run_attempt": run["run_attempt"], "head_sha": run["head_sha"], "conclusion": "success"}
        steps = [step for step in job.get("steps", []) if step.get("name") == "Check out repository"]
        if any(job.get(key) != value for key, value in expected.items()) or len(steps) != 1 or steps[0].get("conclusion") != "success":
            raise RegistrationError("Automatic release checkout job differs from the producer attempt")
        job_id = positive_id(job.get("id"))
        output = command([
            "gh", "api", f"repos/{repository}/actions/jobs/{job_id}/logs",
        ], stdout=subprocess.PIPE).stdout
        lines = checkout_log_lines(output, steps[0])
        refs = [match[1] for line in lines if (match := re.fullmatch(r"\s+ref: ([0-9a-f]{40})", line))]
        heads = [lines[index + 1] for index, line in enumerate(lines[:-1])
            if re.fullmatch(r"\[command\](?:[^\s]*/)?git log -1 --format=%H", line)]
        if refs != [run["head_sha"]] or heads != [run["head_sha"]]:
            raise RegistrationError("Actual automatic release checkout differs from the attested source")
        checked.append({"id": job_id, "name": name, "source_sha": run["head_sha"]})
    return checked


def verify_source_ci(repository, run):
    candidates = paginated(
        f"repos/{repository}/actions/workflows/main.yml/runs?head_sha={run['head_sha']}&event=push&status=success", "workflow_runs",
    )
    matches = []
    expected = {"path": ".github/workflows/main.yml", "head_sha": run["head_sha"],
        "head_branch": "master", "event": "push", "status": "completed", "conclusion": "success"}
    release_created = datetime.fromisoformat(run["created_at"])
    for candidate in candidates:
        if any(candidate.get(key) != value for key, value in expected.items()):
            continue
        if any(candidate.get(key, {}).get("full_name") != repository for key in ("repository", "head_repository")):
            continue
        if datetime.fromisoformat(candidate["updated_at"]) <= release_created:
            matches.append(candidate)
    if len(matches) != 1:
        raise RegistrationError("Automatic release has no unique successful protected-branch source CI")
    return {"run_id": positive_id(matches[0]["id"]), "run_attempt": positive_id(matches[0]["run_attempt"])}


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
        raise RegistrationError("Release artifact listing exceeds its bounded limit")
    if len(matches) != 1:
        raise RegistrationError("The full release must have exactly one matching artifact")
    artifact = matches[0]
    origin = artifact.get("workflow_run", {})
    if origin.get("id") != run["id"] or origin.get("head_sha") != run["head_sha"] or origin.get("head_branch") != "master":
        raise RegistrationError("Artifact origin does not match the verified release")
    positive_id(artifact.get("id"))
    if artifact.get("expired") is not False or not isinstance(artifact.get("digest"), str) or not re.fullmatch(r"sha256:[0-9a-f]{64}", artifact["digest"]):
        raise RegistrationError("The immutable artifact is expired or has no verifiable digest")
    size = artifact.get("size_in_bytes")
    if not isinstance(size, int) or isinstance(size, bool) or not 0 < size <= MAX_ARCHIVE_BYTES:
        raise RegistrationError("Release archive size is invalid")
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
            raise RegistrationError("Unsafe or ambiguous release archive entry")
        seen.add(name.casefold())
        total += entry.file_size
        if total > MAX_CONTENT_BYTES or entry.file_size > MAX_ARCHIVE_BYTES:
            raise RegistrationError("Release archive exceeds its content limit")
    return entries


def extract_binary(archive_path, output_dir, platform):
    suffix = ".apk" if platform == "android" else ".ipa"
    with zipfile.ZipFile(archive_path) as archive:
        candidates = [entry for entry in archive_entries(archive) if not entry.is_dir() and entry.filename.endswith(suffix)]
        if len(candidates) != 1:
            raise RegistrationError("The release artifact must contain exactly one application binary")
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
    raise RegistrationError("Android SDK aapt is required to inspect the APK")


def binary_identity(path, platform):
    if platform == "ios":
        with zipfile.ZipFile(path) as archive:
            candidates = [entry for entry in archive_entries(archive) if re.fullmatch(r"Payload/[^/]+\.app/Info\.plist", entry.filename)]
            if len(candidates) != 1 or candidates[0].file_size > 1024 * 1024:
                raise RegistrationError("The IPA must have exactly one bounded application plist")
            values = plistlib.loads(archive.read(candidates[0]))
        bundle = values.get("CFBundleIdentifier")
        version = values.get("CFBundleShortVersionString")
        number = values.get("CFBundleVersion")
    else:
        result = command([aapt_path(), "dump", "badging", str(path)], stdout=subprocess.PIPE)
        lines = [line for line in result.stdout.decode().splitlines() if line.startswith("package:")]
        if len(lines) != 1:
            raise RegistrationError("APK package metadata is missing or ambiguous")
        fields = dict(re.findall(r"(\w+)='([^']*)'", lines[0]))
        bundle, version, number = (fields.get(key) for key in ("name", "versionName", "versionCode"))
    if bundle != BUNDLE_IDS[platform]:
        raise RegistrationError("Application bundle identity mismatch")
    if not isinstance(version, str) or not re.fullmatch(r"[0-9]+\.[0-9]+\.[0-9]+", version):
        raise RegistrationError("Application marketing version is invalid")
    pattern = r"[1-9][0-9]*" if platform == "android" else r"[0-9]+(?:\.[0-9]+){0,2}"
    if not isinstance(number, str) or not re.fullmatch(pattern, number):
        raise RegistrationError("Application build number is invalid")
    return f"{version}+{number}"


def import_release(*, repo, repository, run_id, platform, output_dir, report=None):
    import release_manifest

    def stage(name):
        if report is not None:
            report(name)

    stage("release origin")
    if not re.fullmatch(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", repository):
        raise RegistrationError("GitHub repository identity is invalid")
    run_id = positive_id(run_id)
    run = api(f"repos/{repository}/actions/runs/{run_id}")
    source = verify_run(run, repository, run_id, platform)
    stage("source ancestry")
    command(["git", "-C", str(repo), "merge-base", "--is-ancestor", source, "HEAD"], stdout=subprocess.PIPE)
    stage("artifact metadata")
    artifact = find_artifact(repository, run, platform)
    stage("output directory")
    output_dir.mkdir(parents=True, exist_ok=True)
    if output_dir.is_symlink() or any(output_dir.iterdir()):
        raise RegistrationError("Manifest output directory must be empty and regular")
    with tempfile.TemporaryDirectory() as directory:
        archive = Path(directory) / "release.zip"
        stage("artifact download")
        with archive.open("xb") as destination:
            command(["gh", "api", f"repos/{repository}/actions/artifacts/{artifact['id']}/zip"], stdout=destination)
        stage("artifact digest")
        if archive.stat().st_size > MAX_ARCHIVE_BYTES or "sha256:" + digest(archive) != artifact["digest"]:
            raise RegistrationError("Downloaded archive differs from its immutable artifact digest")
        stage("binary extraction")
        binary = extract_binary(archive, output_dir, platform)
    stage("binary identity")
    version = binary_identity(binary, platform)
    if platform == "android" and artifact["name"] != "android-beta-" + version:
        raise RegistrationError("Artifact name differs from the actual APK version")
    automatic = None
    if run["event"] == "workflow_run":
        stage("APK attestation")
        automatic = verify_apk_attestation(binary, repository, run)
        stage("producer checkouts")
        automatic["checkout_jobs"] = verify_automatic_checkouts(repository, run)
        stage("source CI")
        automatic["source_ci"] = verify_source_ci(repository, run)
    stage("application identity")
    app_id = release_manifest.read_app_id(repo, source, platform)
    stage("live Shorebird release")
    live = release_manifest.load_shorebird_release(app_id, version)
    if live.get("app_id") != app_id or live.get("version") != version or live.get("platform_statuses", {}).get(platform) != "active":
        raise RegistrationError("The original application does not match an active Shorebird release")
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
    if automatic is not None:
        evidence["automatic_provenance"] = automatic
    stage("manifest construction")
    manifest = release_manifest.build_manifest(
        repo=repo, platform=platform, release_version=version, source_sha=source,
        artifact_dir=output_dir, evidence=evidence, live_release=live,
    )
    stage("manifest validation and write")
    release_manifest.write_manifest(output_dir / "release-manifest.json", manifest)
    return manifest


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--run-id", required=True)
    parser.add_argument("--platform", choices=tuple(WORKFLOWS), required=True)
    parser.add_argument("--repo", type=Path, default=Path.cwd())
    parser.add_argument("--output-dir", type=Path, required=True)
    args = parser.parse_args()
    current_stage = "request"

    def report(stage):
        nonlocal current_stage
        current_stage = stage
        print(f"Checking {stage}", file=sys.stderr, flush=True)

    try:
        manifest = import_release(
            repo=args.repo.resolve(), repository=os.environ["GITHUB_REPOSITORY"],
            run_id=args.run_id, platform=args.platform, output_dir=args.output_dir, report=report,
        )
    except RegistrationError as error:
        parser.exit(1, f"Release registration failed at {current_stage}: {error}\n")
    except (ValueError, OSError, KeyError, subprocess.CalledProcessError, zipfile.BadZipFile, plistlib.InvalidFileException) as error:
        parser.exit(1, f"Release registration failed at {current_stage}: invalid or unavailable evidence ({type(error).__name__})\n")
    print(json.dumps({key: manifest[key] for key in ("platform", "release_version", "source_sha")}))


if __name__ == "__main__":
    main()
