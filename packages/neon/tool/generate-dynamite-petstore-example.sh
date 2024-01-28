#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")/.."

cp external/openapi-specification/examples/v3.0/petstore-expanded.json packages/dynamite/dynamite/example/lib/petstore.openapi.json

(
  cd packages/dynamite/dynamite/example
  rm -rf .dart_tool/build/generated/dynamite
  fvm dart pub run build_runner build --delete-conflicting-outputs
  fvm dart fix --apply lib/
  melos run format
)
