#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")/.."

for package in $(yq -r ".dev_dependencies | keys | .[]" pubspec.yaml); do
  version="$(yq -r ".dev_dependencies.$package" pubspec.yaml)"
  dart pub global activate "$package" "$version"
done
echo "y" | fvm install

if [ ! -v GITHUB_REPOSITORY ]; then
  fvm flutter precache
fi

melos bootstrap
fvm dart run husky install
