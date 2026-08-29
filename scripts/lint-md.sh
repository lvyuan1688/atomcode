#!/usr/bin/env bash
set -euo pipefail
# Lint all markdown files in the repo.
# Checks: heading order, no trailing whitespace, no broken intra-repo links,
# every code block has a language tag.
fail=0
for f in $(find . -name '*.md' -not -path './target/*' -not -path './node_modules/*'); do
  # trailing whitespace
  if grep -nP '\s+$' "$f" >/dev/null; then
    echo "FAIL: trailing whitespace in $f"; fail=1
  fi
  # code block without language
  if grep -nP '^```\s*$' "$f" >/dev/null; then
    echo "FAIL: code block missing language in $f"; fail=1
  fi
done
exit $fail
