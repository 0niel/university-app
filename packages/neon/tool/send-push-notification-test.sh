#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")/.."
source tool/common.sh

docker exec -it "$(docker ps | grep "$(image_tag "dev")" | cut -d " " -f 1)" /bin/sh -c "php -f occ notification:test-push $*"
