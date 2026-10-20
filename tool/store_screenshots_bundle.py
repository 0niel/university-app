import argparse
import hashlib
import json
import re
import zipfile
from pathlib import Path


NAMES = (
    "01-home.png", "02-schedule.png", "03-map.png",
    "04-calendar.png", "05-services.png", "06-profile.png",
)
ASSET_NAMES = {f"{platform}/{name}" for platform in ("android", "ios") for name in NAMES}


def extract_bundle(archive: Path, checksum: str, destination: Path) -> dict:
    if not re.fullmatch(r"[a-f0-9]{64}", checksum):
        raise ValueError("A lowercase SHA-256 digest is required")
    if hashlib.sha256(archive.read_bytes()).hexdigest() != checksum:
        raise ValueError("Screenshot archive checksum differs")
    if destination.exists():
        raise ValueError("Screenshot destination must not exist")
    with zipfile.ZipFile(archive) as bundle:
        entries = bundle.infolist()
        expected_names = ASSET_NAMES | {"manifest.json"}
        if len(entries) != len(expected_names) or {entry.filename for entry in entries} != expected_names:
            raise ValueError("Screenshot archive must contain only the twelve expected PNGs and manifest")
        if any(entry.file_size > 8 * 1024 * 1024 for entry in entries):
            raise ValueError("Screenshot archive contains an oversized entry")
        manifest = json.loads(bundle.read("manifest.json"))
        assets = manifest.get("assets", [])
        if len(assets) != 12 or {asset.get("path") for asset in assets} != ASSET_NAMES:
            raise ValueError("Screenshot manifest assets differ")
        contents = {}
        for asset in assets:
            name = asset["path"]
            content = bundle.read(name)
            if hashlib.sha256(content).hexdigest() != asset.get("sha256"):
                raise ValueError(f"Screenshot checksum differs: {name}")
            contents[name] = content
    destination.mkdir(parents=True)
    for name, content in contents.items():
        path = destination / name
        path.parent.mkdir(exist_ok=True)
        path.write_bytes(content)
    (destination / "manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    return manifest


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--archive", type=Path, required=True)
    parser.add_argument("--sha256", required=True)
    parser.add_argument("--destination", type=Path, required=True)
    arguments = parser.parse_args()
    result = extract_bundle(arguments.archive, arguments.sha256, arguments.destination)
    print(json.dumps({"verified_assets": len(result["assets"])}))


if __name__ == "__main__":
    main()
