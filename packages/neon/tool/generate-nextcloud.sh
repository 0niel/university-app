#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")/.."

(
  cd packages/nextcloud
  rm -rf .dart_tool/build/generated/dynamite
  fvm dart run generate_props.dart
  fvm dart pub run build_runner build --delete-conflicting-outputs
  fvm dart run generate_exports.dart
  # For some reason we need to fix and format twice, otherwise not everything gets fixed
  fvm dart fix --apply lib/src/api/
  melos run format
  fvm dart fix --apply lib/src/api/
  melos run format
)
