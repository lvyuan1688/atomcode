#!/usr/bin/env bash
# Extract release notes section from CHANGELOG.md
# Usage: scripts/release-notes.sh v0.1.0
set -euo pipefail
VERSION="${1:?usage: release-notes.sh vX.Y.Z}"
sed -n "/## \[${VERSION}\]/,/^## \[/p" CHANGELOG.md | sed "1d" | head -n -1
