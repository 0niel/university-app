#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")/.."
source tool/common.sh

if [ "$#" -eq 0 ]; then
  presets=(./packages/nextcloud_test/docker/presets/*/*)
else
  presets=("$@")
fi

for preset in "${presets[@]}"; do
  tag="$(preset_image_tag "$preset")"

  args=()
  while read -r arg; do
    args+=("--build-arg=$arg")
  done < "$preset"

  # shellcheck disable=SC2046,SC2086
  docker buildx build --tag "$tag" $(cache_build_args "$tag") ${args[*]} -f - ./packages/nextcloud_test/docker < packages/nextcloud_test/docker/Dockerfile
done
