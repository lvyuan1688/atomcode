#!/usr/bin/env bash
set -euo pipefail
A="${1:?usage: bench-compare.sh vA vB}"
B="${2:?usage: bench-compare.sh vA vB}"
echo "Comparing $A vs $B..."
for v in "$A" "$B"; do
  git checkout "$v" --quiet 2>/dev/null
  cargo build --release 2>&1 | tail -1
  cargo test --release 2>&1 | tail -1
done
echo 'Compare complete.'
