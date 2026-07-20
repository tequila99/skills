#!/usr/bin/env bash
set -euo pipefail
# Usage: idea_init.sh <idea_dir>
# Creates the idea directory.
idea_dir="${1:-}"
if [[ -z "$idea_dir" ]]; then
  echo "Error: Usage: idea_init.sh <idea_dir>" >&2
  exit 1
fi
mkdir -p "$idea_dir"
