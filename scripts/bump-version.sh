#!/usr/bin/env bash
set -euo pipefail
current=$(git describe --tags --abbrev=0 2>/dev/null || echo v0.1.0)
echo "Current: $current"
echo "Bump: patch/minor/major?"
read -r level
case "$level" in
  patch|minor|major) ;;
  *) echo "invalid"; exit 1 ;;
esac
major=$(echo "$current" | sed 's/v//;s/\..*//')
minor=$(echo "$current" | sed 's/v[0-9]*\.//;s/\..*//')
patch=$(echo "$current" | sed 's/.*\.//')
echo "Will bump $major.$minor.$patch -> $level"
