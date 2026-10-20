import argparse
import hashlib
import json
import re
import struct
from pathlib import Path

from google_play_store_icon import (
    GooglePlayClient,
    hash_matches,
    service_account_token,
)


PACKAGE_NAME = "ninja.mirea.mireaapp"
SOURCE_LANGUAGE = "ru-RU"
IMAGE_TYPE = "phoneScreenshots"


class GooglePlayScreenshotClient(GooglePlayClient):
    def image_path(self, edit_id: str, language: str) -> str:
        return (
            f"/applications/{self.package_name}/edits/{self.quoted(edit_id)}"
            f"/listings/{self.quoted(language)}/{IMAGE_TYPE}"
        )

    def list_screenshots(self, edit_id: str, language: str) -> list[dict]:
        return self.list_icons(edit_id, language)

    def delete_screenshots(self, edit_id: str, language: str) -> None:
        self.delete_icons(edit_id, language)

    def upload_screenshot(self, edit_id: str, language: str, content: bytes) -> dict:
        return self.upload_icon(edit_id, language, content)


def validate_screenshot(content: bytes) -> None:
    if (
        len(content) < 33
        or content[:8] != b"\x89PNG\r\n\x1a\n"
        or content[8:16] != b"\x00\x00\x00\rIHDR"
    ):
        raise ValueError("Screenshots must be PNG files with an IHDR chunk")
    width, height, depth, color, compression, filtering, interlace = struct.unpack(
        ">IIBBBBB", content[16:29]
    )
    if (width, height) != (1080, 1920):
        raise ValueError("Phone screenshots must be 1080 by 1920 pixels")
    if (depth, color) != (8, 2):
        raise ValueError("Phone screenshots must be 24-bit RGB without alpha")
    if compression != 0 or filtering != 0 or interlace not in (0, 1):
        raise ValueError("Unsupported PNG header")
    offset = 8
    saw_data = False
    while offset + 12 <= len(content):
        length = struct.unpack(">I", content[offset : offset + 4])[0]
        kind = content[offset + 4 : offset + 8]
        end = offset + length + 12
        if end > len(content):
            raise ValueError("Screenshot PNG contains an incomplete chunk")
        if kind == b"tRNS":
            raise ValueError("Phone screenshots must not contain transparency")
        if kind == b"IDAT":
            saw_data = True
        if kind == b"IEND":
            if length or end != len(content) or not saw_data:
                raise ValueError("Screenshot PNG has an invalid image end")
            return
        offset = end
    raise ValueError("Screenshot PNG has no complete image end")


def load_assets(directory: Path) -> list[dict]:
    paths = sorted(path for path in directory.iterdir() if path.is_file())
    if len(paths) != 6:
        raise ValueError("Exactly six screenshot files are required")
    assets = []
    for position, path in enumerate(paths, 1):
        if not re.fullmatch(rf"{position:02d}-[a-z0-9-]+\.png", path.name):
            raise ValueError("Screenshots must be named 01-name.png through 06-name.png")
        content = path.read_bytes()
        validate_screenshot(content)
        assets.append({
            "filename": path.name,
            "content": content,
            "sha256": hashlib.sha256(content).hexdigest(),
            "bytes": len(content),
        })
    if len({asset["sha256"] for asset in assets}) != 6:
        raise ValueError("Each screenshot must have different content")
    return assets


def screenshots_match(images: list[dict], assets: list[dict]) -> bool:
    return len(images) == len(assets) and all(
        isinstance(image.get("sha256"), str)
        and hash_matches(image["sha256"], bytes.fromhex(asset["sha256"]))
        for image, asset in zip(images, assets)
    )


def write_report(report_dir: Path, report: dict) -> None:
    report_dir.mkdir(parents=True, exist_ok=True)
    temporary = report_dir / "google-play-screenshots.json.tmp"
    temporary.write_text(
        json.dumps(report, ensure_ascii=False, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    temporary.replace(report_dir / "google-play-screenshots.json")


def update_screenshots(
    client,
    assets: list[dict],
    report_dir: Path,
    *,
    apply: bool = False,
    submit_for_review: bool = False,
    languages: list[str] | None = None,
) -> dict:
    if submit_for_review and not apply:
        raise ValueError("--submit-for-review requires --apply")
    report = {
        "package_name": PACKAGE_NAME,
        "image_type": IMAGE_TYPE,
        "source_language": SOURCE_LANGUAGE,
        "assets": [
            {key: asset[key] for key in ("filename", "sha256", "bytes")}
            for asset in assets
        ],
        "apply": apply,
        "changed": False,
        "committed": False,
        "commit_attempted": False,
        "submitted_for_review": False,
        "verified": False,
        "status": "inspecting",
    }
    write_report(report_dir, report)
    edit_id = None
    try:
        edit_id = client.insert_edit()
        existing_languages = client.listing_languages(edit_id)
        if not existing_languages:
            raise RuntimeError("Google Play has no existing store listings")
        selected = sorted(set(languages)) if languages else existing_languages
        if any(language not in existing_languages for language in selected):
            raise ValueError("Requested language does not have an existing store listing")
        report["languages"] = selected
        report["russian_source_fallback_languages"] = [
            language for language in selected if not language.lower().startswith("ru")
        ]
        previous = {
            language: client.list_screenshots(edit_id, language)
            for language in selected
        }
        report["previous_images"] = previous
        changed = [
            language for language in selected
            if not screenshots_match(previous[language], assets)
        ]
        report["languages_requiring_update"] = changed
        report["status"] = "inspected"
        write_report(report_dir, report)
        if not apply or not changed:
            report["verified"] = not changed
            report["status"] = "unchanged" if not changed else "inspection_only"
            return report
        for language in changed:
            client.delete_screenshots(edit_id, language)
            for asset in assets:
                uploaded = client.upload_screenshot(edit_id, language, asset["content"])
                if not screenshots_match([uploaded], [asset]):
                    raise RuntimeError(f"Uploaded screenshot hash differs for {language}")
        report["images_before_commit"] = {
            language: client.list_screenshots(edit_id, language)
            for language in selected
        }
        if not all(
            screenshots_match(images, assets)
            for images in report["images_before_commit"].values()
        ):
            raise RuntimeError("Screenshot order or hashes differ before commit")
        report["status"] = "verified_before_commit"
        report["commit_attempted"] = True
        write_report(report_dir, report)
        client.commit_edit(edit_id, submit_for_review)
        edit_id = None
        report["committed"] = True
        report["changed"] = True
        report["submitted_for_review"] = submit_for_review
        report["status"] = "committed"
        write_report(report_dir, report)
        edit_id = client.insert_edit()
        report["images_after_commit"] = {
            language: client.list_screenshots(edit_id, language)
            for language in selected
        }
        if not all(
            screenshots_match(images, assets)
            for images in report["images_after_commit"].values()
        ):
            raise RuntimeError("Screenshot order or hashes differ after commit")
        report["verified"] = True
        report["status"] = "verified_after_commit"
        return report
    except Exception as error:
        report["status"] = "failed"
        report["error"] = str(error)
        raise
    finally:
        try:
            if edit_id is not None:
                client.delete_edit(edit_id)
        except Exception as error:
            report["cleanup_error"] = str(error)
            if report["status"] != "failed":
                report["status"] = "cleanup_failed"
                raise
        finally:
            write_report(report_dir, report)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--credentials", required=True, type=Path)
    parser.add_argument("--assets-dir", required=True, type=Path)
    parser.add_argument("--report-dir", required=True, type=Path)
    parser.add_argument("--language", action="append", dest="languages")
    parser.add_argument("--apply", action="store_true")
    parser.add_argument("--submit-for-review", action="store_true")
    arguments = parser.parse_args()
    if arguments.submit_for_review and not arguments.apply:
        parser.error("--submit-for-review requires --apply")
    assets = load_assets(arguments.assets_dir)
    credentials = json.loads(arguments.credentials.read_text(encoding="utf-8"))
    if not isinstance(credentials, dict):
        raise SystemExit("Invalid Google Play service account configuration")
    client = GooglePlayScreenshotClient(service_account_token(credentials), PACKAGE_NAME)
    result = update_screenshots(
        client,
        assets,
        arguments.report_dir,
        apply=arguments.apply,
        submit_for_review=arguments.submit_for_review,
        languages=arguments.languages,
    )
    print(json.dumps({
        key: result[key]
        for key in ("status", "languages", "changed", "committed", "submitted_for_review", "verified")
    }, sort_keys=True))


if __name__ == "__main__":
    main()
