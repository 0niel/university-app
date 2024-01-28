#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")/.."

relative_markdown_links=("$(grep -r packages --include "*\.md" -e "\[.*\]\((?!http).*\)" -l -P || true)")

if [[ -n "${relative_markdown_links[*]}" ]]; then
  printf "%s\n" "${relative_markdown_links[@]}"
  exit 1
fi
