#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")/.."
source tool/common.sh

function get_mount_paths_dir() {
  dir="$1"
  mapfile -t packages < <(melos list --parsable --relative --dir-exists="$dir")
  echo "${packages[@]/%//$dir}"
}

function get_mount_paths_file() {
  file="$1"
  mapfile -t packages < <(melos list --parsable --relative --file-exists="$file")
  echo "${packages[@]/%//$file}"
}

targets=("linux/arm64" "linux/amd64")

target="$1"

# shellcheck disable=SC2076
if ! [[ ${targets[*]} =~ "$target" ]]; then
  echo "Unknown target $target, must be one of ${targets[*]}"
  exit 1
fi

if [[ "$target" == "linux/arm64" ]] || [[ "$target" == "linux/amd64" ]]; then
  os="$(echo "$target" | cut -d "/" -f 1)"
  arch="$(echo "$target" | cut -d "/" -f 2)"

  tag="$(image_tag "build:$os-$arch")"

  # shellcheck disable=SC2046
  docker buildx build \
  --platform "$target" \
  --progress plain \
  --tag "$tag"  \
  --build-arg="FLUTTER_VERSION=$(jq ".flutterSdkVersion" -r < .fvm/fvm_config.json | cut -d "@" -f 1)" \
  $(cache_build_args "$tag") \
  -f "tool/build/Dockerfile.$os" \
  ./tool/build

  paths=(packages/app/{pubspec.lock,linux,build})
  mapfile -O "${#paths[@]}" -t paths < <(get_mount_paths_dir "lib")
  mapfile -O "${#paths[@]}" -t paths < <(get_mount_paths_dir "assets")
  mapfile -O "${#paths[@]}" -t paths < <(get_mount_paths_file "pubspec.yaml")
  mapfile -O "${#paths[@]}" -t paths < <(get_mount_paths_file "pubspec_overrides.yaml")

  run_args=()
  for path in ${paths[*]}; do
    run_args+=(-v "$(pwd)/$path:/src/$path")
  done
  mkdir -p "packages/app/build"

  container_id="$(
    # shellcheck disable=SC2086
    docker run \
    --platform "$target" \
    --rm -d \
    -e "ORIGINAL_USER=$(id -u)" \
    -e "ORIGINAL_GROUP=$(id -g)" \
    -e "BUILD_ARGS=${*:2}" \
    ${run_args[*]} \
    "$tag"
  )"

  function cleanup() {
    docker kill "$container_id" > /dev/null 2>&1 || true
  }
  trap cleanup EXIT

  docker logs -f "$container_id"
fi
