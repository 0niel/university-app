#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")/.."

git ls-files | grep -v "^external/" | cloc --fullpath --list-file=- .
