#!/usr/bin/env bash
set -euo pipefail
# Usage: idea_append.sh <file_path>
# Reads content from stdin and appends it to the file.
file_path="${1:-}"
if [[ -z "$file_path" ]]; then
  echo "Error: Usage: idea_append.sh <file_path>" >&2
  exit 1
fi
mkdir -p "$(dirname "$file_path")"
cat >> "$file_path"
