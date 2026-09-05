import argparse
import json
import re
import subprocess
from pathlib import Path

from app_store_build_status import AppStoreConnectClient, get_release_status, wait_for_build


EDITABLE_STATES = {
    "DEVELOPER_REJECTED", "INVALID_BINARY", "METADATA_REJECTED",
    "PREPARE_FOR_SUBMISSION", "REJECTED", "WAITING_FOR_REVIEW",
}
SUBMITTED_STATES = {
    "WAITING_FOR_REVIEW", "IN_REVIEW", "ACCEPTED",
    "PENDING_APPLE_RELEASE", "PENDING_DEVELOPER_RELEASE",
    "PROCESSING_FOR_APP_STORE", "PROCESSING_FOR_DISTRIBUTION",
    "READY_FOR_SALE", "READY_FOR_DISTRIBUTION",
    "WAITING_FOR_EXPORT_COMPLIANCE",
}


def validate_version(marketing_version: str, build_number: str) -> None:
    if not re.fullmatch(r"[0-9]+(?:\.[0-9]+){1,2}", marketing_version):
        raise ValueError("Invalid App Store marketing version")
    if not re.fullmatch(r"[0-9]{1,4}(?:\.[0-9]{1,2}){0,2}", build_number):
        raise ValueError("Invalid App Store build number")


def pending_review_submission(client, app_id: str, version_id: str) -> str:
    response = client.get(
        "/v1/reviewSubmissions",
        {
            "filter[app]": app_id, "filter[platform]": "IOS",
            "filter[state]": "READY_FOR_REVIEW", "include": "app", "limit": "200",
        },
    )
    submissions = response.get("data", [])
    if response.get("links", {}).get("next") or len(submissions) != 1:
        raise RuntimeError("Pending App Store review submission is unavailable or ambiguous")
    submission = submissions[0]
    attributes = submission.get("attributes", {})
    app = submission.get("relationships", {}).get("app", {}).get("data") or {}
    submission_id = submission.get("id")
    if (
        not isinstance(submission_id, str)
        or not re.fullmatch(r"[A-Za-z0-9-]+", submission_id)
        or attributes.get("platform") != "IOS"
        or attributes.get("state") != "READY_FOR_REVIEW"
        or app.get("id") != app_id
    ):
        raise RuntimeError("Pending App Store review submission does not match the app")
    response = client.get(
        f"/v1/reviewSubmissions/{submission_id}/items",
        {"include": "appStoreVersion", "limit": "200"},
    )
    items = response.get("data", [])
    if response.get("links", {}).get("next") or len(items) != 1:
        raise RuntimeError("Pending App Store review must contain only the requested version")
    item = items[0]
    selected = item.get("relationships", {}).get("appStoreVersion", {}).get("data") or {}
    if (
        not version_id
        or selected.get("id") != version_id
        or item.get("attributes", {}).get("state") != "READY_FOR_REVIEW"
    ):
        raise RuntimeError("Pending App Store review item does not match the version")
    return submission_id


def should_submit(client, bundle_id: str, marketing_version: str, build_id: str) -> bool | str:
    apps = client.get(
        "/v1/apps", {"filter[bundleId]": bundle_id, "limit": "2"}
    ).get("data", [])
    if len(apps) != 1:
        raise RuntimeError("App Store app is unavailable or ambiguous")
    response = client.get(
        f"/v1/apps/{apps[0]['id']}/appStoreVersions",
        {"filter[platform]": "IOS", "include": "build", "limit": "200"},
    )
    if response.get("links", {}).get("next"):
        raise RuntimeError("App Store version list is incomplete")
    matches = []
    for version in response.get("data", []):
        attributes = version.get("attributes", {})
        if attributes.get("platform") != "IOS":
            raise RuntimeError("Unexpected App Store version platform")
        state = attributes.get("appVersionState") or attributes.get("appStoreState")
        legacy_state = attributes.get("appStoreState")
        if not state:
            raise RuntimeError("App Store version state is unavailable")
        same_version = attributes.get("versionString") == marketing_version
        if not same_version and (
            state in EDITABLE_STATES or legacy_state in EDITABLE_STATES
        ):
            raise RuntimeError("Another editable App Store version exists")
        if same_version:
            matches.append(version)
    if len(matches) > 1:
        raise RuntimeError("App Store version is ambiguous")
    if not matches:
        return True
    version = matches[0]
    attributes = version["attributes"]
    state = attributes.get("appVersionState") or attributes.get("appStoreState")
    selected = version.get("relationships", {}).get("build", {}).get("data") or {}
    if selected.get("id") and selected["id"] != build_id:
        raise RuntimeError("App Store version selects a different build")
    if state in SUBMITTED_STATES:
        if selected.get("id") != build_id:
            raise RuntimeError("Submitted App Store version has no matching build")
        return False
    if state == "READY_FOR_REVIEW":
        if selected.get("id") != build_id:
            raise RuntimeError("Pending App Store version has no matching build")
        release = get_release_status(client, bundle_id, marketing_version, build_id)
        if (
            release["release_type"] != "AFTER_APPROVAL"
            or release["phased_release_state"] not in (None, "COMPLETE")
        ):
            raise RuntimeError("Pending App Store version has unexpected release options")
        return pending_review_submission(client, apps[0]["id"], version.get("id"))
    if state not in EDITABLE_STATES:
        raise RuntimeError(f"App Store version cannot be submitted in state {state}")
    return True


def submit_build(client, bundle_id, marketing_version, build_number, private_key):
    validate_version(marketing_version, build_number)
    build = wait_for_build(
        client, bundle_id, marketing_version, build_number, timeout=1200, interval=30
    )
    build_id = build.get("build_id")
    if (
        not isinstance(build_id, str)
        or not re.fullmatch(r"[A-Za-z0-9-]+", build_id)
        or build.get("build_number") != build_number
        or build.get("marketing_version") != marketing_version
        or build.get("processing_state") != "VALID"
    ):
        raise RuntimeError("Verified App Store build does not match the request")
    submission = should_submit(client, bundle_id, marketing_version, build_id)
    if isinstance(submission, str):
        subprocess.run(
            [
                "app-store-connect", "review-submissions", "confirm", submission,
                "--disable-jwt-cache", "--private-key", f"@file:{private_key}",
                "--silent",
            ],
            check=True,
            stdout=subprocess.DEVNULL,
            timeout=600,
        )
        action = "resumed"
    elif submission:
        subprocess.run(
            [
                "app-store-connect", "builds", "submit-to-app-store", build_id,
                "--version-string", marketing_version,
                "--platform", "IOS",
                "--release-type", "AFTER_APPROVAL",
                "--no-phased-release",
                "--max-build-processing-wait", "0",
                "--disable-jwt-cache",
                "--private-key", f"@file:{private_key}",
                "--whats-new", "Исправлен чёрный экран при запуске приложения на iOS.",
                "--silent",
            ],
            check=True,
            stdout=subprocess.DEVNULL,
            timeout=600,
        )
        action = "submitted"
    else:
        action = "already_submitted"
    return {**build, "submission_action": action}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bundle-id", required=True)
    parser.add_argument("--marketing-version", required=True)
    parser.add_argument("--build-number", required=True)
    parser.add_argument("--key-id", required=True)
    parser.add_argument("--issuer-id", required=True)
    parser.add_argument("--private-key", required=True, type=Path)
    arguments = parser.parse_args()
    client = AppStoreConnectClient(
        arguments.key_id, arguments.issuer_id, arguments.private_key
    )
    result = submit_build(
        client, arguments.bundle_id, arguments.marketing_version,
        arguments.build_number, arguments.private_key,
    )
    print(json.dumps(result, sort_keys=True))


if __name__ == "__main__":
    main()
