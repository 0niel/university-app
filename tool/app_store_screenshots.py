import argparse
import hashlib
import json
import re
import struct
import time
import urllib.parse
import urllib.request
from pathlib import Path

from app_store_build_status import get_release_status, wait_for_build
from app_store_submit import AppStoreSubmissionClient, replace_pending_build, validate_version


DISPLAY_TYPE = "APP_IPHONE_67"
EDITABLE_STATES = {
    "PREPARE_FOR_SUBMISSION", "DEVELOPER_REJECTED", "REJECTED", "METADATA_REJECTED",
}


def identifier(value):
    if not isinstance(value, str) or not re.fullmatch(r"[A-Za-z0-9_-]+", value):
        raise RuntimeError("Invalid App Store resource ID")
    return value


class ScreenshotClient(AppStoreSubmissionClient):
    def delete(self, path):
        self._send("DELETE", path, {}, read=False)


def png_dimensions(content):
    if len(content) < 33 or content[:16] != b"\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR":
        raise ValueError("Screenshots must be PNG images")
    width, height, depth, color, compression, filtering, interlace = struct.unpack(
        ">IIBBBBB", content[16:29],
    )
    if (depth, color, compression, filtering) != (8, 2, 0, 0) or interlace not in (0, 1):
        raise ValueError("Screenshots must be 24-bit RGB PNG without alpha")
    position, saw_data = 8, False
    while position + 12 <= len(content):
        length = struct.unpack(">I", content[position:position + 4])[0]
        kind = content[position + 4:position + 8]
        end = position + length + 12
        if end > len(content) or kind == b"tRNS":
            raise ValueError("Invalid or transparent screenshot PNG")
        saw_data = saw_data or kind == b"IDAT"
        if kind == b"IEND":
            if length or end != len(content) or not saw_data:
                raise ValueError("Invalid screenshot PNG end")
            return width, height
        position = end
    raise ValueError("Incomplete screenshot PNG")


def jpeg_dimensions(content):
    if not content.startswith(b"\xff\xd8") or not content.endswith(b"\xff\xd9"):
        raise ValueError("Invalid screenshot JPEG")
    position = 2
    while position + 4 <= len(content):
        if content[position] != 255:
            raise ValueError("Invalid JPEG marker")
        while position < len(content) and content[position] == 255:
            position += 1
        if position >= len(content):
            break
        marker = content[position]
        position += 1
        length = int.from_bytes(content[position:position + 2], "big")
        if length < 2 or position + length > len(content):
            raise ValueError("Invalid JPEG segment")
        if marker in (0xC0, 0xC1, 0xC2):
            if length < 8:
                raise ValueError("Invalid JPEG dimensions")
            return int.from_bytes(content[position + 5:position + 7], "big"), int.from_bytes(content[position + 3:position + 5], "big")
        position += length
    raise ValueError("JPEG dimensions are unavailable")


def safe_error(error):
    message = re.sub(r"https?://[^\s\"<>]+", "[redacted URL]", str(error))
    message = re.sub(r"(?i)Bearer\s+\S+", "Bearer [redacted]", message)
    message = re.sub(r"\beyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+", "[redacted token]", message)
    return message[:1000]


def load_assets(directory):
    paths = sorted(path for path in directory.iterdir() if path.is_file())
    if len(paths) != 6:
        raise ValueError("Exactly six screenshot files are required")
    assets = []
    for position, path in enumerate(paths, 1):
        if not re.fullmatch(rf"{position:02d}-[a-z0-9-]+\.png", path.name):
            raise ValueError("Screenshots must be named 01-name.png through 06-name.png")
        content = path.read_bytes()
        if png_dimensions(content) != (1320, 2868):
            raise ValueError("iPhone screenshots must be 1320 by 2868 pixels")
        assets.append({
            "filename": path.name, "content": content, "bytes": len(content),
            "md5": hashlib.md5(content).hexdigest(),
            "sha256": hashlib.sha256(content).hexdigest(),
        })
    if len({asset["sha256"] for asset in assets}) != 6:
        raise ValueError("Each screenshot must have different content")
    return assets


def listed(client, path, query=None):
    response = client.get(path, {"limit": "200", **(query or {})})
    if response.get("links", {}).get("next"):
        raise RuntimeError("App Store resource list is incomplete")
    return response.get("data", [])


def screenshot_summary(image):
    attributes = image.get("attributes", {})
    return {
        "id": identifier(image.get("id")),
        "filename": attributes.get("fileName"),
        "bytes": attributes.get("fileSize"),
        "md5": attributes.get("sourceFileChecksum"),
        "state": attributes.get("assetDeliveryState", {}).get("state"),
    }


def matches(images, assets):
    return len(images) == len(assets) and all(
        image.get("attributes", {}).get("fileName") == asset["filename"]
        and image.get("attributes", {}).get("fileSize") == asset["bytes"]
        and str(image.get("attributes", {}).get("sourceFileChecksum", "")).lower() == asset["md5"]
        and image.get("attributes", {}).get("assetDeliveryState", {}).get("state") == "COMPLETE"
        for image, asset in zip(images, assets)
    )


def write_report(directory, report):
    directory.mkdir(parents=True, exist_ok=True)
    temporary = directory / "app-store-screenshots.json.tmp"
    temporary.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    temporary.replace(directory / "app-store-screenshots.json")


def find_version(client, bundle_id, marketing_version, build_id):
    apps = listed(client, "/v1/apps", {"filter[bundleId]": bundle_id, "limit": "2"})
    if len(apps) != 1 or apps[0].get("attributes", {}).get("bundleId") != bundle_id:
        raise RuntimeError("App Store app does not match the bundle ID")
    app_id = identifier(apps[0].get("id"))
    versions = listed(client, f"/v1/apps/{app_id}/appStoreVersions", {
        "filter[platform]": "IOS", "filter[versionString]": marketing_version,
        "include": "build", "limit": "2",
    })
    if len(versions) != 1:
        raise RuntimeError("App Store version is unavailable or ambiguous")
    version = versions[0]
    attributes = version.get("attributes", {})
    selected = version.get("relationships", {}).get("build", {}).get("data") or {}
    identifier(version.get("id"))
    if attributes.get("platform") != "IOS" or attributes.get("versionString") != marketing_version or selected.get("id") != build_id:
        raise RuntimeError("App Store version does not select the verified build")
    return app_id, version


def inspect_locales(client, version_id):
    result = []
    for locale in listed(client, f"/v1/appStoreVersions/{version_id}/appStoreVersionLocalizations"):
        locale_id = identifier(locale.get("id"))
        sets = []
        for item in listed(client, f"/v1/appStoreVersionLocalizations/{locale_id}/appScreenshotSets"):
            set_id = identifier(item.get("id"))
            images = listed(client, f"/v1/appScreenshotSets/{set_id}/appScreenshots")
            sets.append({
                "id": set_id, "display_type": item.get("attributes", {}).get("screenshotDisplayType"),
                "images": [screenshot_summary(image) for image in images],
            })
        result.append({"id": locale_id, "locale": locale.get("attributes", {}).get("locale"), "sets": sets})
    return result


def safe_url(url, *, upload=False):
    parsed = urllib.parse.urlsplit(url)
    host = parsed.hostname or ""
    allowed = host.endswith(".apple.com") if upload else (host.endswith(".apple.com") or host.endswith(".mzstatic.com"))
    if parsed.scheme != "https" or not allowed or parsed.username or parsed.password:
        raise RuntimeError("Unexpected App Store asset host")
    return url


def upload_parts(content, operations):
    ranges = []
    for operation in operations:
        offset, length = operation.get("offset"), operation.get("length")
        if operation.get("method") != "PUT" or type(offset) is not int or type(length) is not int or offset < 0 or length <= 0 or offset + length > len(content):
            raise RuntimeError("Invalid App Store upload operation")
        ranges.append((offset, offset + length))
        safe_url(operation.get("url", ""), upload=True)
    cursor = 0
    for start, end in sorted(ranges):
        if start != cursor:
            raise RuntimeError("App Store upload operations do not cover the source")
        cursor = end
    if cursor != len(content):
        raise RuntimeError("App Store upload operations do not cover the source")
    for operation in operations:
        headers = {item["name"]: item["value"] for item in operation.get("requestHeaders", [])}
        if any(name.lower() in ("authorization", "cookie") for name in headers):
            raise RuntimeError("Unexpected credentials in asset upload operation")
        offset, length = operation["offset"], operation["length"]
        request = urllib.request.Request(operation["url"], data=content[offset:offset + length], headers=headers, method="PUT")
        try:
            with urllib.request.urlopen(request, timeout=120) as response:
                response.read()
        except Exception:
            raise RuntimeError("App Store asset byte upload failed") from None


def upload_asset(client, set_id, asset, created, timeout=300):
    image = client.post("/v1/appScreenshots", {"data": {
        "type": "appScreenshots", "attributes": {"fileSize": asset["bytes"], "fileName": asset["filename"]},
        "relationships": {"appScreenshotSet": {"data": {"type": "appScreenshotSets", "id": set_id}}},
    }}).get("data", {})
    image_id = identifier(image.get("id"))
    created.append(image_id)
    upload_parts(asset["content"], image.get("attributes", {}).get("uploadOperations", []))
    client.patch(f"/v1/appScreenshots/{image_id}", {"data": {
        "type": "appScreenshots", "id": image_id,
        "attributes": {"uploaded": True, "sourceFileChecksum": asset["md5"]},
    }})
    deadline = time.monotonic() + timeout
    while True:
        image = client.get(f"/v1/appScreenshots/{image_id}", {}).get("data", {})
        if image.get("id") != image_id:
            raise RuntimeError("App Store screenshot ID changed during upload")
        state = image.get("attributes", {}).get("assetDeliveryState", {}).get("state")
        if state == "COMPLETE":
            if not matches([image], [asset]):
                raise RuntimeError("App Store screenshot source checksum differs")
            return image_id
        if state == "FAILED" or time.monotonic() >= deadline:
            raise RuntimeError("App Store screenshot did not process successfully")
        time.sleep(3)


def backup_assets(client, set_id, directory):
    images = listed(client, f"/v1/appScreenshotSets/{set_id}/appScreenshots")
    directory.mkdir(parents=True, exist_ok=True)
    backups = []
    for position, image in enumerate(images):
        attributes = image.get("attributes", {})
        asset = attributes.get("imageAsset") or {}
        width, height = asset.get("width"), asset.get("height")
        if type(width) is not int or type(height) is not int or width <= 0 or height <= 0:
            raise RuntimeError("Existing screenshot is not downloadable; replacement is blocked")
        url = asset.get("templateUrl", "").replace("{w}", str(width)).replace("{h}", str(height)).replace("{f}", "jpg")
        try:
            with urllib.request.urlopen(safe_url(url), timeout=60) as response:
                content = response.read(24 * 1024 * 1024 + 1)
        except Exception:
            raise RuntimeError("Existing screenshot backup download failed") from None
        if len(content) > 24 * 1024 * 1024 or jpeg_dimensions(content) != (width, height):
            raise RuntimeError("Existing screenshot backup is invalid")
        name = f"{position + 1:02d}-{identifier(image.get('id'))}.jpg"
        (directory / name).write_bytes(content)
        backups.append({"filename": name, "content": content, "bytes": len(content), "md5": hashlib.md5(content).hexdigest()})
    return images, backups


def reorder(client, set_id, image_ids):
    client.patch(f"/v1/appScreenshotSets/{set_id}/relationships/appScreenshots", {
        "data": [{"type": "appScreenshots", "id": image_id} for image_id in image_ids],
    })


def replace_set(client, set_id, assets, old, backups, report):
    if old and len(old) != len(backups):
        raise RuntimeError("Screenshot deletion requires a complete backup")
    created, removed = [], []
    try:
        if len(old) + len(assets) > 10:
            for image in old:
                client.delete(f"/v1/appScreenshots/{identifier(image.get('id'))}")
                removed.append(image["id"])
        for asset in assets:
            upload_asset(client, set_id, asset, created)
        for image in old:
            if image["id"] not in removed:
                client.delete(f"/v1/appScreenshots/{identifier(image.get('id'))}")
                removed.append(image["id"])
        reorder(client, set_id, created)
        if not matches(listed(client, f"/v1/appScreenshotSets/{set_id}/appScreenshots"), assets):
            raise RuntimeError("App Store screenshot order or checksums differ after update")
    except Exception:
        report["rollback_attempted"] = True
        try:
            current = listed(client, f"/v1/appScreenshotSets/{set_id}/appScreenshots")
            old_ids = [image["id"] for image in old]
            if any(image["id"] not in old_ids + created for image in current):
                raise RuntimeError("Screenshot set changed concurrently; rollback is blocked")
            for image in current:
                if image["id"] in created:
                    client.delete(f"/v1/appScreenshots/{identifier(image['id'])}")
            restored = []
            expected = []
            for image, backup in zip(old, backups):
                if image["id"] in removed:
                    upload_asset(client, set_id, backup, restored)
                    expected.append(backup)
                else:
                    restored.append(image["id"])
                    attributes = image["attributes"]
                    expected.append({"filename": attributes["fileName"], "bytes": attributes["fileSize"], "md5": attributes["sourceFileChecksum"]})
            reorder(client, set_id, restored)
            actual = listed(client, f"/v1/appScreenshotSets/{set_id}/appScreenshots")
            if [image["id"] for image in actual] != restored or not matches(actual, expected):
                raise RuntimeError("Restored screenshot order or checksums differ")
            report["rollback_succeeded"] = True
        except Exception:
            report["rollback_succeeded"] = False
        raise


def update_screenshots(client, assets, report_dir, bundle_id, marketing_version, build_number, *, apply=False, replace_pending_review=False, locales=None):
    validate_version(marketing_version, build_number)
    if replace_pending_review and not apply:
        raise ValueError("--replace-pending-review requires --apply")
    report = {
        "bundle_id": bundle_id, "marketing_version": marketing_version, "build_number": build_number,
        "display_type": DISPLAY_TYPE, "apply": apply, "status": "inspecting",
        "changed": False, "verified": False, "needs_resubmit": False,
        "assets": [{key: asset[key] for key in ("filename", "bytes", "md5", "sha256")} for asset in assets],
    }
    write_report(report_dir, report)
    try:
        build = wait_for_build(client, bundle_id, marketing_version, build_number, timeout=0, interval=1)
        build_id = identifier(build.get("build_id"))
        if build.get("build_number") != build_number or build.get("marketing_version") != marketing_version or build.get("processing_state") != "VALID":
            raise RuntimeError("Verified App Store build does not match the request")
        app_id, version = find_version(client, bundle_id, marketing_version, build_id)
        state = version["attributes"].get("appVersionState") or version["attributes"].get("appStoreState")
        report.update({"app_id": app_id, "version_id": version["id"], "build_id": build_id, "version_state": state})
        report["localizations"] = inspect_locales(client, version["id"])
        selected_names = locales or ["ru-RU"]
        selected = [locale for locale in report["localizations"] if locale["locale"] in selected_names]
        if len(selected) != len(set(selected_names)):
            raise ValueError("Requested locale is unavailable")
        changes = []
        for locale in selected:
            targets = [item for item in locale["sets"] if item["display_type"] == DISPLAY_TYPE]
            if len(targets) > 1:
                raise RuntimeError("Target screenshot set is ambiguous")
            current = listed(client, f"/v1/appScreenshotSets/{targets[0]['id']}/appScreenshots") if targets else []
            if not matches(current, assets):
                changes.append((locale, targets[0] if targets else None))
        report["locales_requiring_update"] = [locale["locale"] for locale, _ in changes]
        report["other_phone_sets"] = [{"locale": locale["locale"], "id": item["id"], "display_type": item["display_type"]} for locale in selected for item in locale["sets"] if str(item["display_type"]).startswith("APP_IPHONE") and item["display_type"] != DISPLAY_TYPE and item["images"]]
        report["status"] = "inspection_only" if changes else "unchanged"
        report["verified"] = not changes
        if apply and not changes and state in EDITABLE_STATES:
            report["needs_resubmit"] = True
            report["status"] = "verified_requires_resubmission"
        write_report(report_dir, report)
        if not apply or not changes:
            return report
        if state not in EDITABLE_STATES and not (state == "WAITING_FOR_REVIEW" and replace_pending_review):
            raise RuntimeError("App Store version is not editable; pending review requires explicit replacement")
        if report["other_phone_sets"]:
            raise RuntimeError("Other populated iPhone screenshot sizes require an explicit migration plan")
        backups = {}
        for locale, target in changes:
            if target:
                backups[locale["id"]] = backup_assets(client, target["id"], report_dir / "backup" / identifier(locale["id"]))
        release = get_release_status(client, bundle_id, marketing_version, build_id)
        if release["app_store_version_id"] != version["id"] or release["app_version_state"] != state:
            raise RuntimeError("App Store version changed before screenshot update")
        if state == "WAITING_FOR_REVIEW":
            report["needs_resubmit"] = True
            write_report(report_dir, report)
            replace_pending_build(client, app_id, version, marketing_version, build_id)
        report["needs_resubmit"] = True
        write_report(report_dir, report)
        for locale, target in changes:
            release = get_release_status(client, bundle_id, marketing_version, build_id)
            if release["app_store_version_id"] != version["id"] or release["app_version_state"] not in EDITABLE_STATES:
                raise RuntimeError("App Store version is no longer editable")
            if target is None:
                target = client.post("/v1/appScreenshotSets", {"data": {
                    "type": "appScreenshotSets", "attributes": {"screenshotDisplayType": DISPLAY_TYPE},
                    "relationships": {"appStoreVersionLocalization": {"data": {"type": "appStoreVersionLocalizations", "id": locale["id"]}}},
                }}).get("data", {})
                set_id = identifier(target.get("id"))
                old, saved = [], []
            else:
                set_id = target["id"]
                old, saved = backups[locale["id"]]
                current = listed(client, f"/v1/appScreenshotSets/{set_id}/appScreenshots")
                if [screenshot_summary(image) for image in current] != [screenshot_summary(image) for image in old]:
                    raise RuntimeError("Screenshot set changed after backup")
            report["active_locale"] = locale["locale"]
            write_report(report_dir, report)
            replace_set(client, set_id, assets, old, saved, report)
            report["changed"] = True
            write_report(report_dir, report)
        report["localizations_after"] = inspect_locales(client, version["id"])
        report["verified"] = True
        report["status"] = "verified_requires_resubmission"
        return report
    except Exception as error:
        report["status"] = "failed"
        report["error_type"] = type(error).__name__
        report["error_message"] = safe_error(error)
        raise
    finally:
        write_report(report_dir, report)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--assets-dir", type=Path, required=True)
    parser.add_argument("--report-dir", type=Path, required=True)
    parser.add_argument("--bundle-id", required=True)
    parser.add_argument("--marketing-version", required=True)
    parser.add_argument("--build-number", required=True)
    parser.add_argument("--key-id", required=True)
    parser.add_argument("--issuer-id", required=True)
    parser.add_argument("--private-key", type=Path, required=True)
    parser.add_argument("--locale", action="append", dest="locales")
    parser.add_argument("--apply", action="store_true")
    parser.add_argument("--replace-pending-review", action="store_true")
    arguments = parser.parse_args()
    client = ScreenshotClient(arguments.key_id, arguments.issuer_id, arguments.private_key)
    try:
        report = update_screenshots(client, load_assets(arguments.assets_dir), arguments.report_dir, arguments.bundle_id, arguments.marketing_version, arguments.build_number, apply=arguments.apply, replace_pending_review=arguments.replace_pending_review, locales=arguments.locales)
    except Exception as error:
        raise SystemExit(f"App Store screenshot update failed ({type(error).__name__}): {safe_error(error)}; inspect the report and current version before retrying") from None
    print(json.dumps(report, ensure_ascii=False))


if __name__ == "__main__":
    main()
