#!/usr/bin/env bash
set -euo pipefail
# Summarize atomcode session history: total sessions, total tokens,
# average tokens per session, and the most-used tool.
DIR="$HOME/.atomcode/sessions"
[ -d "$DIR" ] || { echo "No sessions dir: $DIR"; exit 0; }
sessions=$(find "$DIR" -name '*.jsonl' | wc -l)
if [ "$sessions" -eq 0 ]; then echo "No sessions found."; exit 0; fi
echo "=== atomcode session stats ==="
echo "sessions: $sessions"
echo "total lines: $(cat "$DIR"/*.jsonl | wc -l)"
# crude token sum from any line containing "tokens"
tokens=$(grep -oP '"in":\s*\K[0-9]+' "$DIR"/*.jsonl 2>/dev/null | awk '{s+=$1} END{print s+0}')
echo "total input tokens: $tokens"
# most-used tool
top_tool=$(grep -oP '"name":\s*"\K[^"]+' "$DIR"/*.jsonl 2>/dev/null | sort | uniq -c | sort -rn | head -1)
echo "most-used tool: ${top_tool:-none}"
echo "=== stats done ==="
