#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")/.."

(
  cd packages/file_icons
  fvm dart run
)
