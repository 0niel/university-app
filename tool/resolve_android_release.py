import argparse
import json
import os
import re
import subprocess


def select_release(releases, source_sha):
    if not re.fullmatch(r"[0-9a-f]{40}", source_sha):
        raise ValueError("A full release source SHA is required")
    candidates = []
    for release in releases:
        if release.get("draft") or not release.get("prerelease") or release.get("target_commitish") != source_sha:
            continue
        names = [asset.get("name", "") for asset in release.get("assets", [])]
        if sum(name.endswith(".aab") for name in names) != 1 or names.count("SHA256SUMS") != 1:
            continue
        identity = release.get("id")
        if type(identity) is not int or identity <= 0:
            raise ValueError("Invalid GitHub release identity")
        tag = release.get("tag_name", "")
        if not isinstance(tag, str) or not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9._+-]*", tag):
            raise ValueError("Invalid release tag")
        candidates.append(release)
    if not candidates:
        raise ValueError("No signed Android bundle release matches the source commit")
    return max(candidates, key=lambda item: item["id"])["tag_name"]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-sha", required=True)
    arguments = parser.parse_args()
    repository = os.environ["GITHUB_REPOSITORY"]
    if not re.fullmatch(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", repository):
        raise ValueError("Invalid repository")
    releases = []
    for page in range(1, 11):
        batch = json.loads(subprocess.check_output([
            "gh", "api", f"repos/{repository}/releases?per_page=100&page={page}",
        ]))
        releases.extend(batch)
        if len(batch) < 100:
            break
    print(select_release(releases, arguments.source_sha))


if __name__ == "__main__":
    main()
