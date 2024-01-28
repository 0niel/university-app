#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")/.."

rm -rf /tmp/nextcloud-neon
mkdir -p /tmp/nextcloud-neon

function generate_spec() {
    path="$1"
    codename="$2"
    ../nextcloud-openapi-extractor/generate-spec "$path" "/tmp/nextcloud-neon/$codename.openapi.json" --first-content-type --openapi-version 3.1.0

    # Use the full spec if it exists, otherwise use the default spec which is already the full spec.
    if [ -f "/tmp/nextcloud-neon/$codename.openapi-full.json" ]; then
      jq --indent 4 \
        ".info.title = \"$codename\"" \
        "/tmp/nextcloud-neon/$codename.openapi-full.json" \
        > "/tmp/nextcloud-neon/$codename.openapi.json"
    fi
}

(
  cd external/nextcloud-openapi-extractor
  composer install
)

for path in \
  core \
  apps/comments \
  apps/dashboard \
  apps/dav \
  apps/files \
  apps/files_external \
  apps/files_reminders \
  apps/files_sharing \
  apps/files_trashbin \
  apps/files_versions \
  apps/provisioning_api \
  apps/settings \
  apps/sharebymail \
  apps/theming \
  apps/updatenotification \
  apps/user_status \
  apps/weather_status \
; do
  (
    cd external/nextcloud-server
    generate_spec "$path" "$(basename $path)"
  )
done

(
  cd external/nextcloud-notifications
  generate_spec "." "notifications"
)
(
  cd external/nextcloud-spreed
  generate_spec "." "spreed"
)

for spec in /tmp/nextcloud-neon/*.openapi.json; do
  name="$(basename "$spec" | cut -d "." -f 1)"
  dir="packages/nextcloud/lib/src/patches/$name"
  if [ -d "$dir" ]; then
    for patch in "$dir/"*; do
      jsonpatch --indent 4 --in-place "$spec" "$patch"
    done
  fi
done

cp /tmp/nextcloud-neon/*.openapi.json packages/nextcloud/lib/src/api

./external/nextcloud-openapi-extractor/merge-specs \
  --core /tmp/nextcloud-neon/core.openapi.json \
  --merged /tmp/nextcloud-neon/merged.json \
  /tmp/nextcloud-neon/*.openapi.json \
  packages/nextcloud/lib/src/api/news.openapi.json \
  packages/nextcloud/lib/src/api/notes.openapi.json \
  packages/nextcloud/lib/src/api/uppush.openapi.json \
  --openapi-version 3.1.0

jq \
  --indent 4 \
  -s \
  '.[0] * {components: {schemas: .[1].components.schemas | with_entries(select(.key | endswith("Capabilities")))}, paths: {"/ocs/v2.php/cloud/capabilities": {get: {responses: .[1].paths."/ocs/v2.php/cloud/capabilities".get.responses}}}}' \
  /tmp/nextcloud-neon/core.openapi.json \
  /tmp/nextcloud-neon/merged.json \
  > packages/nextcloud/lib/src/api/core.openapi.json
