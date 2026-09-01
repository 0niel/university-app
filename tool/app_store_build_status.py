import argparse
import base64
import json
import subprocess
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path


def base64url(value: bytes) -> str:
    return base64.urlsafe_b64encode(value).rstrip(b"=").decode("ascii")


def read_der_length(value: bytes, offset: int) -> tuple[int, int]:
    if offset >= len(value):
        raise ValueError("Missing DER length")
    first = value[offset]
    offset += 1
    if first < 0x80:
        return first, offset
    count = first & 0x7F
    if count == 0 or count > 4 or offset + count > len(value):
        raise ValueError("Invalid DER length")
    length = int.from_bytes(value[offset : offset + count], "big")
    return length, offset + count


def read_der_integer(value: bytes, offset: int) -> tuple[bytes, int]:
    if offset >= len(value) or value[offset] != 0x02:
        raise ValueError("Invalid DER integer")
    length, offset = read_der_length(value, offset + 1)
    end = offset + length
    if length == 0 or end > len(value):
        raise ValueError("Invalid DER integer length")
    integer = value[offset:end]
    if integer[0] & 0x80:
        raise ValueError("Negative DER integer")
    if len(integer) > 1 and integer[0] == 0 and not integer[1] & 0x80:
        raise ValueError("Non-minimal DER integer")
    while len(integer) > 1 and integer[0] == 0:
        integer = integer[1:]
    if len(integer) > 32:
        raise ValueError("Oversized ES256 integer")
    return integer.rjust(32, b"\0"), end


def der_signature_to_raw(value: bytes) -> bytes:
    if not value or value[0] != 0x30:
        raise ValueError("Invalid DER sequence")
    length, offset = read_der_length(value, 1)
    if offset + length != len(value):
        raise ValueError("Invalid DER sequence length")
    left, offset = read_der_integer(value, offset)
    right, offset = read_der_integer(value, offset)
    if offset != len(value):
        raise ValueError("Unexpected DER signature data")
    return left + right


class AppStoreConnectClient:
    def __init__(self, key_id: str, issuer_id: str, private_key: Path) -> None:
        self.key_id = key_id
        self.issuer_id = issuer_id
        self.private_key = private_key

    def token(self) -> str:
        now = int(time.time())
        header = base64url(
            json.dumps(
                {"alg": "ES256", "kid": self.key_id, "typ": "JWT"},
                separators=(",", ":"),
            ).encode()
        )
        payload = base64url(
            json.dumps(
                {
                    "aud": "appstoreconnect-v1",
                    "exp": now + 600,
                    "iss": self.issuer_id,
                    "iat": now,
                },
                separators=(",", ":"),
            ).encode()
        )
        unsigned = f"{header}.{payload}".encode()
        signature = subprocess.run(
            [
                "openssl",
                "dgst",
                "-sha256",
                "-sign",
                str(self.private_key),
            ],
            input=unsigned,
            check=True,
            stdout=subprocess.PIPE,
        ).stdout
        return f"{unsigned.decode()}.{base64url(der_signature_to_raw(signature))}"

    def get(self, path: str, query: dict[str, str]) -> dict[str, object]:
        url = "https://api.appstoreconnect.apple.com" + path
        url += "?" + urllib.parse.urlencode(query)
        request = urllib.request.Request(
            url,
            headers={
                "Accept": "application/json",
                "Authorization": f"Bearer {self.token()}",
            },
        )
        try:
            with urllib.request.urlopen(request, timeout=30) as response:
                return json.load(response)
        except urllib.error.HTTPError as error:
            detail = error.read().decode("utf-8", errors="replace")
            raise RuntimeError(
                f"App Store Connect request failed with HTTP {error.code}: {detail}"
            ) from error


def wait_for_build(
    client: AppStoreConnectClient,
    bundle_id: str,
    marketing_version: str,
    build_number: str,
    timeout: int,
    interval: int,
) -> dict[str, object]:
    apps = client.get(
        "/v1/apps",
        {"filter[bundleId]": bundle_id, "limit": "1"},
    ).get("data", [])
    if len(apps) != 1:
        raise RuntimeError(f"App Store app is unavailable for {bundle_id}")
    app_id = apps[0]["id"]
    deadline = time.monotonic() + timeout
    version_id = None
    while True:
        if version_id is None:
            versions = client.get(
                "/v1/preReleaseVersions",
                {
                    "filter[app]": app_id,
                    "filter[platform]": "IOS",
                    "filter[version]": marketing_version,
                    "limit": "1",
                },
            ).get("data", [])
            if versions:
                version_id = versions[0]["id"]
        builds = []
        if version_id is not None:
            builds = client.get(
                "/v1/builds",
                {
                    "filter[app]": app_id,
                    "filter[preReleaseVersion]": version_id,
                    "filter[version]": build_number,
                    "limit": "1",
                },
            ).get("data", [])
        if builds:
            build = builds[0]
            attributes = build.get("attributes", {})
            state = attributes.get("processingState")
            if state == "VALID":
                return {
                    "build_id": build.get("id"),
                    "build_number": attributes.get("version"),
                    "icon_available": bool(attributes.get("iconAssetToken")),
                    "marketing_version": marketing_version,
                    "processing_state": state,
                    "uploaded_date": attributes.get("uploadedDate"),
                }
            if state in {"FAILED", "INVALID"}:
                raise RuntimeError(f"App Store build processing failed: {state}")
        if time.monotonic() >= deadline:
            raise TimeoutError(
                f"App Store build {marketing_version} ({build_number}) "
                "did not become valid in time"
            )
        time.sleep(interval)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bundle-id", required=True)
    parser.add_argument("--build-number", required=True)
    parser.add_argument("--marketing-version", required=True)
    parser.add_argument("--key-id", required=True)
    parser.add_argument("--issuer-id", required=True)
    parser.add_argument("--private-key", required=True, type=Path)
    parser.add_argument("--timeout", type=int, default=1200)
    parser.add_argument("--interval", type=int, default=30)
    arguments = parser.parse_args()
    if arguments.timeout <= 0 or arguments.interval <= 0:
        raise SystemExit("Timeout and interval must be positive")
    client = AppStoreConnectClient(
        arguments.key_id,
        arguments.issuer_id,
        arguments.private_key,
    )
    result = wait_for_build(
        client,
        arguments.bundle_id,
        arguments.marketing_version,
        arguments.build_number,
        arguments.timeout,
        arguments.interval,
    )
    print(json.dumps(result, sort_keys=True))


if __name__ == "__main__":
    main()
