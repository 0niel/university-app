import argparse
import hashlib
import json
from pathlib import Path
import re


ASSETS = Path("packages/app_ui/assets/maps/pulse")
CAMPUS_ID = re.compile(r"[a-z0-9]+(?:-[a-z0-9]+)*")
ORGANIZATION_ID = re.compile(r"[a-z0-9]+(?:[-_][a-z0-9]+)*")


def export_sql(assets, destination):
    statements = ["begin;", "set local standard_conforming_strings = on;"]
    catalog = json.loads((assets / "catalog.json").read_text(encoding="utf-8"))
    campuses = [entry["id"] for entry in catalog["campuses"]]
    if not campuses or len(set(campuses)) != len(campuses):
        raise ValueError("Publication requires a nonempty catalog with unique campus IDs")
    for campus in campuses:
        if not isinstance(campus, str) or not CAMPUS_ID.fullmatch(campus):
            raise ValueError("Invalid publication campus ID")
        payload = (assets / f"campus_{campus}.json").read_text(encoding="utf-8").strip()
        document = json.loads(payload)
        organization = document.get("organization_id")
        if document.get("id") != campus or not isinstance(organization, str) or not ORGANIZATION_ID.fullmatch(organization):
            raise ValueError("Publication document does not match the catalog campus")
        delimiter = f"$campus_{hashlib.sha256(payload.encode('utf-8')).hexdigest()[:16]}$"
        if delimiter in payload:
            raise ValueError("Unexpected SQL delimiter collision")
        statements.append(
            f"select app_api_v1.publish_map_campus('{campus}', '{organization}', "
            f"{delimiter}{payload}{delimiter}::jsonb, 0);"
        )
    statements.append("commit;")
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text("\n\n".join(statements) + "\n", encoding="utf-8", newline="\n")


def main():
    parser = argparse.ArgumentParser(description="Write the bundled campus map documents as a publication SQL transaction.")
    parser.add_argument("--assets", type=Path, default=ASSETS)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    export_sql(args.assets, args.output)


if __name__ == "__main__":
    main()
