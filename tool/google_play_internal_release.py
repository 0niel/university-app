import argparse
import json
import urllib.parse
import urllib.request
from pathlib import Path

from google_play_store_icon import (
    UPLOAD_ROOT,
    GooglePlayClient,
    request_json,
    service_account_token,
)


class GooglePlayReleaseClient(GooglePlayClient):
    def upload_bundle(self, edit_id: str, bundle: bytes) -> int:
        path = (
            f"/applications/{self.package_name}/edits/{self.quoted(edit_id)}"
            "/bundles?uploadType=media"
        )
        request = urllib.request.Request(
            UPLOAD_ROOT + path,
            data=bundle,
            headers={
                "Accept": "application/json",
                "Authorization": f"Bearer {self.access_token}",
                "Content-Type": "application/octet-stream",
            },
            method="POST",
        )
        response = request_json(request)
        version_code = response.get("versionCode")
        if not isinstance(version_code, int) or version_code <= 0:
            raise RuntimeError("Google Play upload response has no version code")
        return version_code

    def update_internal_track(
        self,
        edit_id: str,
        release_name: str,
        version_code: int,
    ) -> None:
        payload = json.dumps(
            {
                "track": "internal",
                "releases": [
                    {
                        "name": release_name,
                        "status": "completed",
                        "versionCodes": [str(version_code)],
                    }
                ],
            },
            separators=(",", ":"),
        ).encode()
        self.request(
            "PUT",
            f"/applications/{self.package_name}/edits/{self.quoted(edit_id)}"
            "/tracks/internal",
            data=payload,
            content_type="application/json",
        )

    def internal_release_version_codes(
        self,
        edit_id: str,
        release_name: str,
        expected_version_code: str,
    ) -> list[str]:
        response = self.request(
            "GET",
            f"/applications/{self.package_name}/edits/{self.quoted(edit_id)}"
            "/tracks/internal",
        )
        releases = response.get("releases", [])
        for release in releases:
            if (
                not isinstance(release, dict)
                or release.get("name") != release_name
                or release.get("status") != "completed"
            ):
                continue
            version_codes = release.get("versionCodes", [])
            if isinstance(version_codes, list) and all(
                isinstance(value, str) for value in version_codes
            ) and expected_version_code in version_codes:
                return version_codes
        return []

    def commit_release_edit(self, edit_id: str) -> None:
        query = urllib.parse.urlencode(
            {
                "changesInReviewBehavior": "ERROR_IF_IN_REVIEW",
                "changesNotSentForReview": "true",
            }
        )
        self.request(
            "POST",
            f"/applications/{self.package_name}/edits/{self.quoted(edit_id)}"
            f":commit?{query}",
            data=b"",
        )


def publish_internal_release(
    client: GooglePlayReleaseClient,
    bundle: bytes,
    release_name: str,
) -> dict[str, object]:
    if not bundle.startswith(b"PK"):
        raise ValueError("Android App Bundle is not a ZIP archive")
    if not release_name.strip():
        raise ValueError("Google Play release name is empty")
    expected_version_code = release_name.rsplit(".", maxsplit=1)[-1]
    if not expected_version_code.isdigit():
        raise ValueError("Google Play release name must end with a version code")
    edit_id = client.insert_edit()
    edit_open = True
    try:
        existing_version_codes = client.internal_release_version_codes(
            edit_id,
            release_name,
            expected_version_code,
        )
        if existing_version_codes:
            client.delete_edit(edit_id)
            edit_open = False
            return {
                "already_published": True,
                "release_name": release_name,
                "track": "internal",
                "version_codes": existing_version_codes,
            }
        version_code = client.upload_bundle(edit_id, bundle)
        client.update_internal_track(edit_id, release_name, version_code)
        client.commit_release_edit(edit_id)
        edit_open = False
    finally:
        if edit_open:
            try:
                client.delete_edit(edit_id)
            except RuntimeError:
                pass
    return {
        "already_published": False,
        "release_name": release_name,
        "track": "internal",
        "version_code": version_code,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--credentials", required=True, type=Path)
    parser.add_argument("--bundle", required=True, type=Path)
    parser.add_argument("--package-name", required=True)
    parser.add_argument("--release-name", required=True)
    arguments = parser.parse_args()
    credentials = json.loads(arguments.credentials.read_text(encoding="utf-8"))
    if not isinstance(credentials, dict):
        raise SystemExit("Invalid Google Play service account configuration")
    access_token = service_account_token(credentials)
    client = GooglePlayReleaseClient(access_token, arguments.package_name)
    result = publish_internal_release(
        client,
        arguments.bundle.read_bytes(),
        arguments.release_name,
    )
    print(json.dumps(result, sort_keys=True))


if __name__ == "__main__":
    main()
