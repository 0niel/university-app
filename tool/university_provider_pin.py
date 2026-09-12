import argparse
import json
from pathlib import Path
import re


PIN = "config/university_provider.json"
FIELDS = ("repository", "ref", "path")


def read_pin(path):
    if path.is_symlink() or not path.is_file():
        raise ValueError("University provider pin is missing")
    pin = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(pin, dict) or set(pin) - set(FIELDS):
        raise ValueError("University provider pin has unexpected fields")
    repository = pin.get("repository")
    ref = pin.get("ref")
    package = pin.get("path", ".")
    if not isinstance(repository, str) or not re.fullmatch(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", repository) or repository.endswith(".git"):
        raise ValueError("University provider repository must be a GitHub owner/name")
    if not isinstance(ref, str) or not re.fullmatch(r"[0-9a-f]{40}", ref):
        raise ValueError("University provider ref must be a full commit SHA")
    if (not isinstance(package, str) or not package or package.startswith("/") or "\\" in package
            or ":" in package or ".." in package.split("/")):
        raise ValueError("University provider path must stay inside the repository")
    return {"repository": repository, "ref": ref, "path": package}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--pin", type=Path, default=Path(PIN))
    parser.add_argument("--field", choices=FIELDS)
    parser.add_argument("--github-output", type=Path)
    args = parser.parse_args()
    pin = read_pin(args.pin)
    if args.field:
        print(pin[args.field])
    if args.github_output:
        with args.github_output.open("a", encoding="utf-8") as output:
            for field in FIELDS:
                output.write(f"{field}={pin[field]}\n")
    if not args.field and not args.github_output:
        print(json.dumps(pin, sort_keys=True))


if __name__ == "__main__":
    main()
