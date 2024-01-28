#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")/.."
source tool/common.sh

./tool/build-dev-container.sh

container_id="$(docker run --rm -d -p "80:80" "$(image_tag "dev:latest")")"
function cleanup() {
    docker kill "$container_id"
}
trap cleanup EXIT

(
  cd packages/app
  fvm flutter drive \
    --driver=test_driver/integration_test.dart \
    --target=integration_test/screenshot_test.dart \
    --android-emulator
)
