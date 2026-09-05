import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess


BASELINE_SHA = "892c735ac0b46f3b8f6621b1d67d12342c45cc84"
REVIEWED_SOURCE_SHA = "0a5f375a1a312a6bb45567677852ee22242420ab"
RELEASE_VERSION = "5.2.1+1005301"
NAV_RELEASE_VERSION = "5.2.1+1005801"
NAV_IOS_RELEASE_VERSION = "5.2.1+2439.14.43"
NAV_BASELINE_SHA = "506602c5d8da2cac5a6180d26b753f415d381819"
NAV_REVIEWED_SOURCE_SHA = "281f0761b65405ab48a69e8c3df92e63bdc101da"
NAV_FIREBASE_SHA256 = "d0abe346d8d1ce3aca40807b7eadf951bd68d1db1da8631a3dddbd3be831fc9b"
NAV_RUNTIME_PATHS = {
    "lib/app/utils/system_ui_configurator.dart",
    "lib/app/view/app_router_view.dart",
    "lib/app/widgets/app_router.dart",
    "lib/app/widgets/app_system_ui_surface.dart",
    "lib/navigation/deep_links.dart",
    "lib/navigation/routes/routes.dart",
}
NAV_TEST_PATHS = {
    "test/app/widgets/app_system_ui_surface_test.dart",
    "test/navigation/deep_links_test.dart",
    "test/navigation/schedule_route_payload_test.dart",
}
READ_STATE_REVIEWED_SHA = "d958d00217238a815931d879ed8abc684a8c7cc3"
READ_STATE_BASELINES = {
    "5.2.1+1005801": "506602c5d8da2cac5a6180d26b753f415d381819",
    "5.2.1+2439.14.43": "506602c5d8da2cac5a6180d26b753f415d381819",
    "5.2.1+1006201": "781b2ff4a14c9888331eb61b156a2cb0c7e4515b",
    "5.2.1+2439.15.54": "ee51aeee41bf3c48925c6a524e9e9e90c40b0dd1",
}
READ_STATE_RUNTIME_PATHS = {
    'lib/app/view/app.dart',
    'lib/app/widgets/local_notification_listener.dart',
    'lib/app/widgets/user_preferences_scope.dart',
    'lib/notifications/cubit/notifications_cubit.dart',
    'lib/notifications/data/notification_inbox_repository.dart',
    'lib/notifications/view/notifications_sheet.dart',
    'lib/notifications/view/push_history_listener.dart',
    'lib/notifications/view/schedule_changes_read_scope.dart',
    'lib/profile/widgets/notifications_toggle_row.dart',
    'lib/profile/widgets/settings_sheets.dart',
    'lib/promo/cubit/promo_dismissals_cubit.dart',
    'lib/schedule/view/changes/changes_page.dart',
    'lib/schedule/view/schedule_page/schedule_body.dart',
    'lib/schedule/view/schedule_page/sheets/schedule_changes_sheet.dart',
    'packages/promo_repository/lib/promo_repository.dart',
    'packages/promo_repository/lib/src/client/promo_client.dart',
    'packages/promo_repository/lib/src/models/promo_dismissal.dart',
    'packages/promo_repository/lib/src/promo_repository.dart',
}
READ_STATE_SUPPORT_PATHS = {
    'supabase/migrations/20260905170626_promo_banner_dismissals.sql',
    'supabase/migrations/20260905170648_schedule_notification_read_state.sql',
    'supabase/tests/promo_banner_dismissals_contract.sql',
    'supabase/tests/schedule_notification_reads_contract.sql',
    'test/app/view/app_router_scope_test.dart',
    'test/notifications/cubit/notification_inbox_sync_test.dart',
    'test/notifications/cubit/notifications_cubit_test.dart',
    'test/notifications/data/notification_inbox_repository_test.dart',
    'test/notifications/view/push_history_listener_test.dart',
    'test/notifications/view/schedule_changes_read_scope_test.dart',
    'test/profile/view/notifications_settings_page_test.dart',
    'test/profile/widgets/notifications_toggle_row_test.dart',
    'test/promo/cubit/promo_dismissals_sync_test.dart',
    'test/promo/view/promo_banner_slot_test.dart',
    'test/schedule/view/schedule_page/schedule_responsive_test.dart',
}
WORKFLOW_PATHS = {
    "packages/app_ui/test/src/widgets/app_horizontal_scroll_view_test.dart",
    "supabase/tests/guest_active_day_contract.sql",
    "supabase/tests/mentorship_contract.sql",
    ".github/workflows/shorebird-patch.yml",
    ".github/workflows/shorebird-promote.yml",
    "tool/prepare_shorebird_patch.py",
    "test/tool/prepare_shorebird_patch_test.py",
    "test/tool/shorebird_patch_workflow_test.py",
}
MANIFEST = "android/app/src/main/AndroidManifest.xml"
PROCESS_TEXT = (
    '        <intent>\n'
    '            <action android:name="android.intent.action.PROCESS_TEXT" />\n'
    '            <data android:mimeType="text/plain" />\n'
    '        </intent>\n'
).encode()
DART_PACKAGES = {
    "barcode": ("2.2.9", "7b6729c37e3b7f34233e2318d866e8c48ddb46c1f7ad01ff7bb2a8de1da2b9f4"),
    "bidi": ("2.0.13", "77f475165e94b261745cf1032c751e2032b8ed92ccb2bf5716036db79320637d"),
    "pdf": ("3.12.0", "e47a275b267873d5944ad5f5ff0dcc7ac2e36c02b3046a0ffac9b72fd362c44b"),
}


def git(root, *args, input=None):
    return subprocess.check_output(["git", "-C", str(root), *args], input=input)


def changed(root, before, after):
    return set(filter(None, git(root, "diff", "--name-only", "--no-renames", "-z", before, after).decode().split("\0")))


def tree(root, revision):
    result = {}
    for entry in git(root, "ls-tree", "-rz", "--full-tree", revision).split(b"\0"):
        if entry:
            metadata, path = entry.split(b"\t", 1)
            result[path.decode()] = metadata.decode()
    return result


def blob(root, revision, path):
    return git(root, "show", f"{revision}:{path}")


def validate_dependencies(baseline, source):
    root_before = baseline["pubspec.yaml"]
    root_after = source["pubspec.yaml"]
    normalized = re.sub(rb"(?m)^version: [^\n]+$", b"version: reviewed", root_after)
    expected = re.sub(rb"(?m)^version: [^\n]+$", b"version: reviewed", root_before)
    if normalized.replace(b"  pdf: 3.12.0\n", b"", 1) != expected:
        raise ValueError("Only the reviewed pure Dart PDF dependency may change")
    lock = source["pubspec.lock"].decode()
    blocks = dict(re.findall(r"(?m)^  ([a-z0-9_]+):\n((?:^ {4}[^\n]*\n)+)", lock))
    for name, (version, digest) in DART_PACKAGES.items():
        block = blocks.get(name, "")
        if (
            f'    version: "{version}"\n' not in block
            or digest not in block
            or '      url: "https://pub.dev"\n' not in block
            or '    source: hosted\n' not in block
        ):
            raise ValueError(f"Unexpected reviewed dependency: {name}")
        lock = lock.replace(f"  {name}:\n{block}", "", 1)
    if lock.encode() != baseline["pubspec.lock"]:
        raise ValueError("Existing locked dependencies must remain identical to the release")
    return root_before.replace(b"  pdfx:", b"  pdf: 3.12.0\n  pdfx:", 1)


def navigation_projection(root, source_sha, workflow_sha, release_version):
    for ancestor, descendant in ((NAV_BASELINE_SHA, NAV_REVIEWED_SOURCE_SHA), (NAV_REVIEWED_SOURCE_SHA, source_sha), (source_sha, workflow_sha)):
        git(root, "merge-base", "--is-ancestor", ancestor, descendant)
    support = WORKFLOW_PATHS | NAV_TEST_PATHS | {"test/tool/configure_firebase_test.py"}
    if changed(root, NAV_REVIEWED_SOURCE_SHA, source_sha) - support:
        raise ValueError("Runtime source differs from the explicitly reviewed snapshot")
    delta = changed(root, NAV_BASELINE_SHA, source_sha)
    if delta - NAV_RUNTIME_PATHS - support:
        raise ValueError("Only the reviewed navigation runtime and support files may change")
    after = tree(root, source_sha)
    for path in delta:
        if not after.get(path, "").startswith("100644 blob "):
            raise ValueError(f"Changed paths must remain regular files: {path}")
    digest = hashlib.sha256(json.dumps(after, sort_keys=True, separators=(",", ":")).encode()).hexdigest()
    return {}, {
        "baseline_sha": NAV_BASELINE_SHA,
        "reviewed_source_sha": NAV_REVIEWED_SOURCE_SHA,
        "source_sha": source_sha,
        "release_version": release_version,
        "projection_sha256": digest,
    }


def read_state_projection(root, source_sha, workflow_sha, release_version):
    baseline = READ_STATE_BASELINES[release_version]
    for ancestor, descendant in ((baseline, READ_STATE_REVIEWED_SHA), (READ_STATE_REVIEWED_SHA, source_sha), (source_sha, workflow_sha)):
        git(root, "merge-base", "--is-ancestor", ancestor, descendant)
    if changed(root, READ_STATE_REVIEWED_SHA, source_sha) - WORKFLOW_PATHS:
        raise ValueError("Runtime source differs from the explicitly reviewed read-state snapshot")
    support = WORKFLOW_PATHS | NAV_TEST_PATHS | READ_STATE_SUPPORT_PATHS | {"test/tool/configure_firebase_test.py"}
    delta = changed(root, baseline, source_sha)
    if delta - NAV_RUNTIME_PATHS - READ_STATE_RUNTIME_PATHS - support:
        raise ValueError("Only the reviewed read-state runtime and support files may change")
    after = tree(root, source_sha)
    for path in delta:
        if not after.get(path, "").startswith("100644 blob "):
            raise ValueError(f"Changed paths must remain regular files: {path}")
    digest = hashlib.sha256(json.dumps(after, sort_keys=True, separators=(",", ":")).encode()).hexdigest()
    return {}, {
        "baseline_sha": baseline,
        "reviewed_source_sha": READ_STATE_REVIEWED_SHA,
        "source_sha": source_sha,
        "release_version": release_version,
        "projection_sha256": digest,
    }


def projection(root, source_sha, workflow_sha, release_version=RELEASE_VERSION):
    for value in (source_sha, workflow_sha):
        if not re.fullmatch(r"[0-9a-f]{40}", value):
            raise ValueError("A full commit SHA is required")
    if git(root, "rev-parse", "HEAD").decode().strip() != source_sha:
        raise ValueError("Checked-out commit does not match source_sha")
    if release_version in READ_STATE_BASELINES:
        reviewed = subprocess.run(["git", "-C", str(root), "merge-base", "--is-ancestor", READ_STATE_REVIEWED_SHA, source_sha], capture_output=True)
        if reviewed.returncode == 0 or release_version not in (NAV_RELEASE_VERSION, NAV_IOS_RELEASE_VERSION):
            return read_state_projection(root, source_sha, workflow_sha, release_version)
    if release_version in (NAV_RELEASE_VERSION, NAV_IOS_RELEASE_VERSION):
        return navigation_projection(root, source_sha, workflow_sha, release_version)
    if release_version != RELEASE_VERSION:
        raise ValueError("Unsupported runtime projection release")
    for ancestor, descendant in ((BASELINE_SHA, REVIEWED_SOURCE_SHA), (REVIEWED_SOURCE_SHA, source_sha), (source_sha, workflow_sha)):
        git(root, "merge-base", "--is-ancestor", ancestor, descendant)
    if changed(root, REVIEWED_SOURCE_SHA, source_sha) - WORKFLOW_PATHS:
        raise ValueError("Runtime source differs from the explicitly reviewed snapshot")
    before = tree(root, BASELINE_SHA)
    after = tree(root, source_sha)
    for path in changed(root, BASELINE_SHA, source_sha):
        if not after.get(path, "").startswith("100644 blob "):
            raise ValueError(f"Changed paths must remain regular files: {path}")
        protected = path.startswith(("android/", "ios/", "macos/", "windows/", "linux/", "web/", "assets/")) or path in {".fvmrc", "shorebird.yaml"}
        package_resource = path.startswith("packages/") and not path.endswith(".dart")
        if (protected or package_resource) and path != MANIFEST and before.get(path) != after.get(path):
            raise ValueError(f"Native configuration and bundled assets must remain unchanged: {path}")
    paths = (MANIFEST, "pubspec.yaml", "pubspec.lock")
    baseline = {path: blob(root, BASELINE_SHA, path) for path in paths}
    source = {path: blob(root, source_sha, path) for path in paths}
    if source[MANIFEST].count(PROCESS_TEXT) != 1 or source[MANIFEST].replace(PROCESS_TEXT, b"", 1) != baseline[MANIFEST]:
        raise ValueError("The only reviewed manifest change is the optional PROCESS_TEXT query")
    overrides = {MANIFEST: baseline[MANIFEST], "pubspec.yaml": validate_dependencies(baseline, source)}
    identities = {path: value for path, value in after.items()}
    for path, data in overrides.items():
        identities[path] = "projection sha256 " + hashlib.sha256(data).hexdigest()
    digest = hashlib.sha256(json.dumps(identities, sort_keys=True, separators=(",", ":")).encode()).hexdigest()
    return overrides, {
        "baseline_sha": BASELINE_SHA,
        "reviewed_source_sha": REVIEWED_SOURCE_SHA,
        "source_sha": source_sha,
        "release_version": RELEASE_VERSION,
        "projection_sha256": digest,
    }


def verify_worktree(root, overrides):
    if git(root, "ls-files", "--others", "--exclude-standard"):
        raise ValueError("Unexpected untracked files in the projected workspace")
    dirty = set(filter(None, git(root, "diff", "HEAD", "--name-only", "-z").decode().split("\0")))
    if dirty - overrides.keys():
        raise ValueError("Unexpected tracked changes in the projected workspace")
    for path, data in overrides.items():
        target = root / path
        if target.is_symlink() or target.read_bytes().replace(b"\r\n", b"\n") != data:
            raise ValueError(f"Projection drift: {path}")


def verify_navigation_firebase(root):
    target = root / "android/app/google-services.json"
    if target.is_symlink() or not target.resolve().is_relative_to(root) or not target.is_file():
        raise ValueError("Missing or invalid baseline Firebase native configuration")
    if hashlib.sha256(target.read_bytes()).hexdigest() != NAV_FIREBASE_SHA256:
        raise ValueError("Firebase native configuration differs from the verified release")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-sha", required=True)
    parser.add_argument("--workflow-sha", required=True)
    parser.add_argument("--release-version", choices=(RELEASE_VERSION, *READ_STATE_BASELINES), default=RELEASE_VERSION)
    parser.add_argument("--repo", type=Path, default=Path.cwd())
    parser.add_argument("--apply", action="store_true")
    parser.add_argument("--verify-worktree", action="store_true")
    parser.add_argument("--verify-native-firebase", action="store_true")
    parser.add_argument("--receipt", type=Path)
    parser.add_argument("--github-output", type=Path)
    parser.add_argument("--expected-projection")
    arguments = parser.parse_args()
    root = arguments.repo.resolve()
    overrides, receipt = projection(root, arguments.source_sha, arguments.workflow_sha, arguments.release_version)
    if arguments.expected_projection and arguments.expected_projection != receipt["projection_sha256"]:
        raise ValueError("The build projection differs from the validated projection")
    if arguments.apply:
        if git(root, "diff", "HEAD", "--name-only"):
            raise ValueError("Projection requires a clean tracked checkout")
        for path, data in overrides.items():
            target = root / path
            if target.is_symlink() or not target.resolve().is_relative_to(root):
                raise ValueError("Projection paths must remain inside the checkout")
            target.write_bytes(data)
    if arguments.apply or arguments.verify_worktree:
        verify_worktree(root, overrides)
    if arguments.verify_native_firebase:
        if arguments.release_version not in (NAV_RELEASE_VERSION, "5.2.1+1006201"):
            raise ValueError("Native Firebase reconstruction is only supported for the reviewed Android releases")
        verify_navigation_firebase(root)
    if arguments.receipt:
        arguments.receipt.write_text(json.dumps(receipt, sort_keys=True) + "\n", encoding="utf-8")
    if arguments.github_output:
        with arguments.github_output.open("a", encoding="utf-8") as output:
            output.write(f"projection_sha256={receipt['projection_sha256']}\n")
    print(json.dumps(receipt, sort_keys=True))


if __name__ == "__main__":
    main()
