#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")/.."
source tool/common.sh

if [ "$#" -eq 1 ]; then
    preset="$1"
else
    preset="packages/nextcloud_test/docker/presets/latest"
fi

./tool/build-dev-container.sh "$preset"

echo "Running development instance on http://localhost. To access it in an Android Emulator use http://10.0.2.2"

tag="$(preset_image_tag "$preset")"
volume="nextcloud-neon-dev-$(echo "$tag" | cut -d ":" -f 2)"
container="$(docker run -d --rm -v "$volume":/usr/src/nextcloud -v "$volume":/var/www/html -p "80:80" --add-host=host.docker.internal:host-gateway "$tag")"
function cleanup() {
    docker kill "$container"
}
trap cleanup EXIT

docker logs -f "$container" &

sleep infinity
