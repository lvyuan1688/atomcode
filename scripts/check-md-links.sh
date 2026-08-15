#!/usr/bin/env bash
set -euo pipefail
echo 'Checking markdown link targets...'
for f in docs/*.md *.md; do
  [ -f "$f" ] || continue
  grep -oE '\[.+\]\(([^)]+)\)' "$f" | while IFS= read -r line; do
    target=$(echo "$line" | sed 's/.*)\(//;s/)//')
    [ -e "$target" ] || echo "  $f: broken -> $target"
  done
done
echo 'Check complete.'
