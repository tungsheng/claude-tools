#!/usr/bin/env bash
set -euo pipefail

# Auto-format files after Claude edits or writes them.
# This hook runs on PostToolUse for Edit and Write tool calls.
# The file path is read from the JSON input on stdin.

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)

if [[ -z "$file_path" || ! -f "$file_path" ]]; then
  exit 0
fi

extension="${file_path##*.}"

# Try to format based on file extension using available tools
case "$extension" in
  js|jsx|ts|tsx|json|css|scss|md|yaml|yml|html)
    if command -v npx &>/dev/null && [[ -f "node_modules/.bin/prettier" || -f "$(npm root -g 2>/dev/null)/prettier/bin/prettier.cjs" ]]; then
      npx prettier --write "$file_path" 2>/dev/null || true
    fi
    ;;
  py)
    if command -v black &>/dev/null; then
      black --quiet "$file_path" 2>/dev/null || true
    elif command -v ruff &>/dev/null; then
      ruff format "$file_path" 2>/dev/null || true
    fi
    ;;
  rs)
    if command -v rustfmt &>/dev/null; then
      rustfmt "$file_path" 2>/dev/null || true
    fi
    ;;
  go)
    if command -v gofmt &>/dev/null; then
      gofmt -w "$file_path" 2>/dev/null || true
    fi
    ;;
esac

exit 0
