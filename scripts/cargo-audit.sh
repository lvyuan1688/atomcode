#!/usr/bin/env bash
set -euo pipefail
if ! command -v cargo-audit &>/dev/null; then
  cargo install cargo-audit
fi
cargo audit
echo "=== audit complete ==="
