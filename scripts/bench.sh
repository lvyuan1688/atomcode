#!/usr/bin/env bash
set -euo pipefail
echo "=== atomcode benchmark harness ==="
cargo build --release 2>&1 | tail -3
cargo test --release 2>&1 | tail -5
cargo clippy -- -D warnings 2>&1 | tail -3
echo "=== bench complete ==="
