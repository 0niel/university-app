#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")/.."

(
  cd packages/nextcloud_test
  fvm dart run nextcloud_test:generate_presets

  # Remove notes releases because they have an invalid PHP requirement which makes the app fail to install.
  rm docker/presets/notes/4.4
  rm docker/presets/notes/4.5
  rm docker/presets/notes/4.6
)
