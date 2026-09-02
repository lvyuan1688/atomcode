#!/usr/bin/env bash
set -euo pipefail
# Audit the current permission policy and report any tools that are
# both allowed and denied (ambiguous) or missing from both (orphan).
POLICY="${ATOMCODE_POLICY:-$HOME/.atomcode/permissions.toml}"
[ -f "$POLICY" ] || { echo "No policy at $POLICY"; exit 0; }
echo "=== atomcode permission audit ==="
echo "policy file: $POLICY"
# Naive check: every tool name should appear in exactly one of allow/deny.
TOOLS="read_file write_file edit_file bash grep glob list_directory web_fetch"
for t in $TOOLS; do
  in_allow=$(grep -c "\"$t\"" "$POLICY" 2>/dev/null || echo 0)
  in_deny=$(grep -c "\"$t\"" "$POLICY" 2>/dev/null || echo 0)
  total=$((in_allow + in_deny))
  case "$total" in
    0) echo "ORPHAN: $t not in any list";;
    1) echo "OK: $t";;
    *) echo "AMBIGUOUS: $t appears $total times";;
  esac
done
echo "=== audit done ==="
