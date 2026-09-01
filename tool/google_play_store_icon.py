import argparse
import base64
import binascii
import hashlib
import json
import struct
import subprocess
import tempfile
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path


API_ROOT = "https://androidpublisher.googleapis.com/androidpublisher/v3"
UPLOAD_ROOT = "https://androidpublisher.googleapis.com/upload/androidpublisher/v3"
TOKEN_URL = "https://oauth2.googleapis.com/token"


def base64url(value: bytes) -> str:
    return base64.urlsafe_b64encode(value).rstrip(b"=").decode("ascii")


def validate_icon(value: bytes) -> None:
    if len(value) > 1024 * 1024:
        raise ValueError("Google Play icon exceeds 1 MiB")
    if len(value) < 26 or value[:8] != b"\x89PNG\r\n\x1a\n":
        raise ValueError("Google Play icon must be a PNG")
    if value[12:16] != b"IHDR":
        raise ValueError("Google Play icon has no IHDR chunk")
    width, height = struct.unpack(">II", value[16:24])
    if (width, height) != (512, 512):
        raise ValueError("Google Play icon must be 512 by 512 pixels")


def hash_matches(value: str, expected: bytes) -> bool:
    normalized = value.strip()
    if normalized.lower() == expected.hex():
        return True
    padded = normalized + "=" * (-len(normalized) % 4)
    for decoder in (base64.b64decode, base64.urlsafe_b64decode):
        try:
            if decoder(padded.encode()) == expected:
                return True
        except (ValueError, binascii.Error):
            pass
    return False


def service_account_token(credentials: dict[str, object]) -> str:
    client_email = credentials.get("client_email")
    private_key = credentials.get("private_key")
    if not isinstance(client_email, str) or not isinstance(private_key, str):
        raise ValueError("Invalid Google Play service account configuration")
    now = int(time.time())
    header = base64url(
        json.dumps(
            {"alg": "RS256", "typ": "JWT"},
            separators=(",", ":"),
        ).encode()
    )
    payload = base64url(
        json.dumps(
            {
                "aud": TOKEN_URL,
                "exp": now + 600,
                "iat": now,
                "iss": client_email,
                "scope": "https://www.googleapis.com/auth/androidpublisher",
            },
            separators=(",", ":"),
        ).encode()
    )
    unsigned = f"{header}.{payload}".encode()
    with tempfile.TemporaryDirectory() as temporary_directory:
        key_path = Path(temporary_directory) / "service-account-key.pem"
        key_path.write_text(private_key, encoding="utf-8")
        key_path.chmod(0o600)
        signature = subprocess.run(
            ["openssl", "dgst", "-sha256", "-sign", str(key_path)],
            input=unsigned,
            check=True,
            stdout=subprocess.PIPE,
        ).stdout
    assertion = f"{unsigned.decode()}.{base64url(signature)}"
    request = urllib.request.Request(
        TOKEN_URL,
        data=urllib.parse.urlencode(
            {
                "assertion": assertion,
                "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
            }
        ).encode(),
        headers={"Content-Type": "application/x-www-form-urlencoded"},
        method="POST",
    )
    response = request_json(request)
    access_token = response.get("access_token")
    if not isinstance(access_token, str) or not access_token:
        raise RuntimeError("Google OAuth response has no access token")
    return access_token


def request_json(request: urllib.request.Request) -> dict[str, object]:
    try:
        with urllib.request.urlopen(request, timeout=60) as response:
            content = response.read()
    except urllib.error.HTTPError as error:
        detail = error.read().decode("utf-8", errors="replace")
        raise RuntimeError(
            f"Google Play request failed with HTTP {error.code}: {detail}"
        ) from error
    if not content:
        return {}
    parsed = json.loads(content)
    if not isinstance(parsed, dict):
        raise RuntimeError("Google Play response is not an object")
    return parsed


class GooglePlayClient:
    def __init__(self, access_token: str, package_name: str) -> None:
        self.access_token = access_token
        self.package_name = urllib.parse.quote(package_name, safe="")

    def request(
        self,
        method: str,
        path: str,
        data: bytes | None = None,
        content_type: str | None = None,
    ) -> dict[str, object]:
        headers = {
            "Accept": "application/json",
            "Authorization": f"Bearer {self.access_token}",
        }
        if content_type is not None:
            headers["Content-Type"] = content_type
        request = urllib.request.Request(
            API_ROOT + path,
            data=data,
            headers=headers,
            method=method,
        )
        return request_json(request)

    def insert_edit(self) -> str:
        response = self.request(
            "POST",
            f"/applications/{self.package_name}/edits",
            data=b"",
        )
        edit_id = response.get("id")
        if not isinstance(edit_id, str) or not edit_id:
            raise RuntimeError("Google Play edit has no identifier")
        return edit_id

    def delete_edit(self, edit_id: str) -> None:
        self.request(
            "DELETE",
            f"/applications/{self.package_name}/edits/{self.quoted(edit_id)}",
        )

    def commit_edit(self, edit_id: str, submit_for_review: bool) -> None:
        query = urllib.parse.urlencode(
            {
                "changesInReviewBehavior": "ERROR_IF_IN_REVIEW",
                "changesNotSentForReview": str(not submit_for_review).lower(),
            }
        )
        self.request(
            "POST",
            f"/applications/{self.package_name}/edits/{self.quoted(edit_id)}:commit?{query}",
            data=b"",
        )

    def listing_languages(self, edit_id: str) -> list[str]:
        response = self.request(
            "GET",
            f"/applications/{self.package_name}/edits/{self.quoted(edit_id)}/listings",
        )
        listings = response.get("listings", [])
        languages = {
            listing.get("language")
            for listing in listings
            if isinstance(listing, dict)
            and isinstance(listing.get("language"), str)
        }
        return sorted(languages)

    def list_icons(self, edit_id: str, language: str) -> list[dict[str, object]]:
        response = self.request(
            "GET",
            self.image_path(edit_id, language),
        )
        images = response.get("images", [])
        return [image for image in images if isinstance(image, dict)]

    def delete_icons(self, edit_id: str, language: str) -> None:
        self.request("DELETE", self.image_path(edit_id, language))

    def upload_icon(
        self,
        edit_id: str,
        language: str,
        icon: bytes,
    ) -> dict[str, object]:
        path = self.image_path(edit_id, language).replace(API_ROOT, "")
        request = urllib.request.Request(
            UPLOAD_ROOT + path + "?uploadType=media",
            data=icon,
            headers={
                "Accept": "application/json",
                "Authorization": f"Bearer {self.access_token}",
                "Content-Type": "image/png",
            },
            method="POST",
        )
        response = request_json(request)
        image = response.get("image")
        if not isinstance(image, dict):
            raise RuntimeError("Google Play upload response has no image")
        return image

    def image_path(self, edit_id: str, language: str) -> str:
        return (
            f"/applications/{self.package_name}/edits/{self.quoted(edit_id)}"
            f"/listings/{self.quoted(language)}/icon"
        )

    @staticmethod
    def quoted(value: str) -> str:
        return urllib.parse.quote(value, safe="")


def icons_match(images: list[dict[str, object]], digest: bytes) -> bool:
    return len(images) == 1 and isinstance(images[0].get("sha256"), str) and hash_matches(
        images[0]["sha256"],
        digest,
    )


def update_store_icon(
    client: GooglePlayClient,
    icon: bytes,
    submit_for_review: bool = False,
) -> dict[str, object]:
    digest = hashlib.sha256(icon).digest()
    edit_id = client.insert_edit()
    edit_open = True
    try:
        languages = client.listing_languages(edit_id)
        if not languages:
            raise RuntimeError("Google Play has no store listings")
        changed_languages = [
            language
            for language in languages
            if not icons_match(client.list_icons(edit_id, language), digest)
        ]
        if not changed_languages:
            client.delete_edit(edit_id)
            edit_open = False
            return {
                "changed": False,
                "languages": languages,
                "sha256": digest.hex(),
                "submitted_for_review": False,
                "verified": True,
            }
        for language in changed_languages:
            client.delete_icons(edit_id, language)
            uploaded = client.upload_icon(edit_id, language, icon)
            uploaded_hash = uploaded.get("sha256")
            if not isinstance(uploaded_hash, str) or not hash_matches(
                uploaded_hash,
                digest,
            ):
                raise RuntimeError(
                    f"Google Play returned an unexpected icon for {language}"
                )
        client.commit_edit(edit_id, submit_for_review)
        edit_open = False
    finally:
        if edit_open:
            try:
                client.delete_edit(edit_id)
            except RuntimeError:
                pass
    verification_id = client.insert_edit()
    try:
        verified = all(
            icons_match(client.list_icons(verification_id, language), digest)
            for language in languages
        )
    finally:
        client.delete_edit(verification_id)
    if not verified:
        raise RuntimeError("Google Play icon verification failed after commit")
    return {
        "changed": True,
        "languages": languages,
        "sha256": digest.hex(),
        "submitted_for_review": submit_for_review,
        "verified": True,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--credentials", required=True, type=Path)
    parser.add_argument("--icon", required=True, type=Path)
    parser.add_argument("--package-name", required=True)
    parser.add_argument("--submit-for-review", action="store_true")
    arguments = parser.parse_args()
    icon = arguments.icon.read_bytes()
    validate_icon(icon)
    credentials = json.loads(arguments.credentials.read_text(encoding="utf-8"))
    if not isinstance(credentials, dict):
        raise SystemExit("Invalid Google Play service account configuration")
    access_token = service_account_token(credentials)
    client = GooglePlayClient(access_token, arguments.package_name)
    result = update_store_icon(client, icon, arguments.submit_for_review)
    print(json.dumps(result, sort_keys=True))


if __name__ == "__main__":
    main()
