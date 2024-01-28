#!/bin/bash
set -euxo pipefail

function image_tag() {
  name="$1"
  echo "ghcr.io/${GITHUB_REPOSITORY:-nextcloud/neon}/$name"
}

function cache_build_args() {
    tag="$1"

    build_args=(
      "--load"
      "--cache-from" "type=inline"
      "--cache-to" "type=inline,mode=max"
      "--cache-from" "type=registry,ref=$tag"
    )
    if [ -v GITHUB_REPOSITORY ]; then
      build_args+=("--cache-to" "type=registry,ref=$tag,mode=max")
    fi

    echo "${build_args[*]}"
}

function preset_image_tag() {
  path="$(realpath --relative-to ./packages/nextcloud_test/docker/presets "$1")"
  name="$(dirname "$path")"
  version="$(basename "$path")"
  image_tag "dev:$name-$version"
}
