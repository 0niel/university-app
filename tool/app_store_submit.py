import argparse
import json
import re
import subprocess
import time
import urllib.error
import urllib.parse
import urllib.request
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


class AppStoreSubmissionClient(AppStoreConnectClient):
    def patch(self, path: str, payload: dict) -> None:
        request = urllib.request.Request(
            "https://api.appstoreconnect.apple.com" + path,
            data=json.dumps(payload, separators=(",", ":")).encode(),
            headers={
                "Accept": "application/json", "Content-Type": "application/json",
                "Authorization": f"Bearer {self.token()}",
            },
            method="PATCH",
        )
        try:
            with urllib.request.urlopen(request, timeout=30):
                pass
        except urllib.error.HTTPError as error:
            detail = error.read().decode("utf-8", errors="replace")
            raise RuntimeError(
                f"App Store Connect update failed with HTTP {error.code}: {detail}"
            ) from error


def validate_version(marketing_version: str, build_number: str) -> None:
    if not re.fullmatch(r"[0-9]+(?:\.[0-9]+){1,2}", marketing_version):
        raise ValueError("Invalid App Store marketing version")
    if not re.fullmatch(r"[0-9]{1,4}(?:\.[0-9]{1,2}){0,2}", build_number):
        raise ValueError("Invalid App Store build number")


def pending_review_submission(
    client, app_id: str, version_id: str, state: str = "READY_FOR_REVIEW",
    *, item_states=("READY_FOR_REVIEW",), include_item=False,
    expected_submission_id=None, allow_missing=False, ignore_empty_drafts=False,
) -> str | tuple[str, dict] | None:
    if expected_submission_id:
        response = {"data": [client.get(
            f"/v1/reviewSubmissions/{expected_submission_id}", {"include": "app"},
        ).get("data", {})]}
    else:
        response = client.get(
            "/v1/reviewSubmissions",
            {
                "filter[app]": app_id, "filter[platform]": "IOS",
                "filter[state]": state, "include": "app", "limit": "200",
            },
        )
    submissions = response.get("data", [])
    selected_items = None
    if submissions and ignore_empty_drafts and not response.get("links", {}).get("next"):
        nonempty = []
        for candidate in submissions:
            candidate_id = candidate.get("id")
            candidate_attributes = candidate.get("attributes", {})
            candidate_app = candidate.get("relationships", {}).get("app", {}).get("data") or {}
            if (
                not isinstance(candidate_id, str) or not re.fullmatch(r"[A-Za-z0-9-]+", candidate_id)
                or candidate_attributes.get("state") != "READY_FOR_REVIEW"
                or candidate_attributes.get("platform") != "IOS" or candidate_app.get("id") != app_id
            ):
                raise RuntimeError("Pending App Store draft does not match the app")
            candidate_items = client.get(
                f"/v1/reviewSubmissions/{candidate_id}/items",
                {"include": "appStoreVersion", "limit": "200"},
            )
            if candidate_items.get("links", {}).get("next"):
                raise RuntimeError("Pending App Store draft items are incomplete")
            if candidate_items.get("data"):
                nonempty.append((candidate, candidate_items))
        if not nonempty and allow_missing:
            return None
        if len(nonempty) != 1:
            raise RuntimeError("Pending App Store review submission is unavailable or ambiguous")
        candidate, selected_items = nonempty[0]
        submissions = [candidate]
    if not submissions and not response.get("links", {}).get("next") and allow_missing:
        return None
    if response.get("links", {}).get("next") or len(submissions) != 1:
        raise RuntimeError("Pending App Store review submission is unavailable or ambiguous")
    submission = submissions[0]
    attributes = submission.get("attributes", {})
    app = submission.get("relationships", {}).get("app", {}).get("data") or {}
    submission_id = submission.get("id")
    if (
        not isinstance(submission_id, str)
        or not re.fullmatch(r"[A-Za-z0-9-]+", submission_id)
        or (expected_submission_id and submission_id != expected_submission_id)
        or attributes.get("platform") != "IOS"
        or attributes.get("state") not in state.split(",")
        or app.get("id") != app_id
    ):
        raise RuntimeError("Pending App Store review submission does not match the app")
    response = selected_items or client.get(
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
        or item.get("attributes", {}).get("state") not in item_states
    ):
        raise RuntimeError("Pending App Store review item does not match the version")
    return (submission_id, item) if include_item else submission_id


def resolve_rejected_review(client, app_id, version, bundle_id, marketing_version, build_id):
    version_id = version["id"]
    review = pending_review_submission(
        client, app_id, version_id, "UNRESOLVED_ISSUES",
        item_states=("REJECTED", "READY_FOR_REVIEW"), include_item=True,
        allow_missing=(version["attributes"].get("appVersionState") or version["attributes"].get("appStoreState")) == "PREPARE_FOR_SUBMISSION",
    )
    if review is None:
        review = pending_review_submission(
            client, app_id, version_id, "READY_FOR_REVIEW",
            include_item=True, allow_missing=True, ignore_empty_drafts=True,
        )
        if review is None:
            return True
    submission_id, item = review
    item_id = item.get("id")
    if not isinstance(item_id, str) or not re.fullmatch(r"[A-Za-z0-9_-]+={0,2}", item_id):
        raise RuntimeError("Rejected App Store review item ID is invalid")

    def verify_release():
        release = get_release_status(client, bundle_id, marketing_version, build_id)
        if (
            release["app_store_version_id"] != version_id
            or release["app_version_state"] not in ("REJECTED", "METADATA_REJECTED", "READY_FOR_REVIEW", "PREPARE_FOR_SUBMISSION")
            or release["release_type"] != "AFTER_APPROVAL"
            or release["phased_release_state"] not in (None, "COMPLETE")
        ):
            raise RuntimeError("Rejected App Store version changed before resubmission")

    def current_item():
        current_submission, current = pending_review_submission(
            client, app_id, version_id, "UNRESOLVED_ISSUES,READY_FOR_REVIEW",
            item_states=("REJECTED", "READY_FOR_REVIEW"), include_item=True,
            expected_submission_id=submission_id,
        )
        if current_submission != submission_id or current.get("id") != item_id:
            raise RuntimeError("Rejected App Store review changed before resubmission")
        return current["attributes"]["state"]

    verify_release()
    if current_item() == "REJECTED":
        client.patch(
            f"/v1/reviewSubmissionItems/{urllib.parse.quote(item_id, safe='')}",
            {"data": {"type": "reviewSubmissionItems", "id": item_id, "attributes": {"resolved": True}}},
        )
    deadline = time.monotonic() + 120
    while current_item() != "READY_FOR_REVIEW":
        if time.monotonic() >= deadline:
            raise RuntimeError("Rejected App Store review item has not become ready; retry after it is resolved")
        time.sleep(3)
    verify_release()
    if current_item() != "READY_FOR_REVIEW":
        raise RuntimeError("Resolved App Store review item changed before resubmission")
    return submission_id


def replace_pending_build(client, app_id, version, marketing_version, build_id):
    version_id = version.get("id")
    if not isinstance(version_id, str) or not re.fullmatch(r"[A-Za-z0-9-]+", version_id):
        raise RuntimeError("App Store version ID is invalid")
    attributes = version["attributes"]
    state = attributes.get("appVersionState") or attributes.get("appStoreState")
    if state not in ("WAITING_FOR_REVIEW", "DEVELOPER_REJECTED", "REJECTED", "METADATA_REJECTED"):
        raise RuntimeError("Only a pending, withdrawn or rejected App Store review can be replaced")
    if state in ("REJECTED", "METADATA_REJECTED"):
        _, item = pending_review_submission(
            client, app_id, version_id, "UNRESOLVED_ISSUES",
            item_states=("REJECTED", "READY_FOR_REVIEW"), include_item=True,
        )
        if not isinstance(item.get("id"), str) or not re.fullmatch(r"[A-Za-z0-9_-]+={0,2}", item["id"]):
            raise RuntimeError("Rejected App Store review item ID is invalid")
    old_build_id = version["relationships"]["build"]["data"]["id"]

    def current_version():
        current = client.get(f"/v1/appStoreVersions/{version_id}", {"include": "build"}).get("data", {})
        attrs = current.get("attributes", {})
        selected = current.get("relationships", {}).get("build", {}).get("data") or {}
        if (
            current.get("id") != version_id
            or attrs.get("platform") != "IOS"
            or attrs.get("versionString") != marketing_version
            or selected.get("id") != old_build_id
        ):
            raise RuntimeError("App Store version changed before build replacement")
        return attrs.get("appVersionState") or attrs.get("appStoreState")

    if state == "WAITING_FOR_REVIEW":
        submission_id = pending_review_submission(client, app_id, version_id, state)
        if current_version() != "WAITING_FOR_REVIEW":
            raise RuntimeError("App Store review is no longer pending")
        client.patch(
            f"/v1/reviewSubmissions/{submission_id}",
            {"data": {"type": "reviewSubmissions", "id": submission_id, "attributes": {"canceled": True}}},
        )
        deadline = time.monotonic() + 120
        while True:
            current_state = current_version()
            if current_state == "DEVELOPER_REJECTED":
                break
            if current_state != "WAITING_FOR_REVIEW":
                raise RuntimeError("App Store version entered an unexpected state after cancellation")
            if time.monotonic() >= deadline:
                raise RuntimeError("App Store review cancellation has not completed; retry after it is withdrawn")
            time.sleep(3)
    elif current_version() != state:
        raise RuntimeError("App Store version state changed before build replacement")
    client.patch(
        f"/v1/appStoreVersions/{version_id}/relationships/build",
        {"data": {"type": "builds", "id": build_id}},
    )


def should_submit(
    client, bundle_id: str, marketing_version: str, build_id: str,
    replace_pending_review: bool = False,
) -> bool | str:
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
        if replace_pending_review:
            replace_pending_build(client, apps[0]["id"], version, marketing_version, build_id)
            return should_submit(client, bundle_id, marketing_version, build_id)
        raise RuntimeError("App Store version selects a different build")
    if state in SUBMITTED_STATES:
        if selected.get("id") != build_id:
            raise RuntimeError("Submitted App Store version has no matching build")
        return False
    if state in ("REJECTED", "METADATA_REJECTED") or (
        state == "PREPARE_FOR_SUBMISSION" and selected.get("id") == build_id
    ):
        if selected.get("id") != build_id:
            raise RuntimeError("Rejected App Store version has no matching build")
        return resolve_rejected_review(
            client, apps[0]["id"], version, bundle_id, marketing_version, build_id,
        )
    if state == "READY_FOR_REVIEW":
        if selected.get("id") != build_id:
            raise RuntimeError("Pending App Store version has no matching build")
        release = get_release_status(client, bundle_id, marketing_version, build_id)
        if (
            release["release_type"] != "AFTER_APPROVAL"
            or release["phased_release_state"] not in (None, "COMPLETE")
        ):
            raise RuntimeError("Pending App Store version has unexpected release options")
        unresolved = pending_review_submission(
            client, apps[0]["id"], version.get("id"), "UNRESOLVED_ISSUES", allow_missing=True,
        )
        return unresolved or pending_review_submission(
            client, apps[0]["id"], version.get("id"), ignore_empty_drafts=True,
        )
    if state not in EDITABLE_STATES:
        raise RuntimeError(f"App Store version cannot be submitted in state {state}")
    return True


def submit_build(
    client, bundle_id, marketing_version, build_number, private_key,
    replace_pending_review=False,
):
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
    submission = should_submit(
        client, bundle_id, marketing_version, build_id, replace_pending_review,
    )
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
    parser.add_argument("--replace-pending-review", action="store_true")
    arguments = parser.parse_args()
    client = AppStoreSubmissionClient(
        arguments.key_id, arguments.issuer_id, arguments.private_key
    )
    result = submit_build(
        client, arguments.bundle_id, arguments.marketing_version,
        arguments.build_number, arguments.private_key,
        arguments.replace_pending_review,
    )
    print(json.dumps(result, sort_keys=True))


if __name__ == "__main__":
    main()
