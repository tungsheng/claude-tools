#!/usr/bin/env bash
set -euo pipefail

# Guard against dangerous commands in Bash tool calls.
# Runs on PreToolUse for Bash — reads the command from stdin (JSON).
#
# This is a defense-in-depth measure. It catches common destructive
# patterns but is not a security boundary against intentional circumvention.

if ! command -v jq &>/dev/null; then
  echo "BLOCKED: jq is required for bash-safety-check but not found." >&2
  echo "Install jq: https://jqlang.github.io/jq/download/" >&2
  exit 2
fi

input=$(cat)
command=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')

if [[ -z "$command" ]]; then
  exit 0
fi

# Regex patterns — tolerant of extra whitespace
dangerous_patterns=(
  'rm\s+-rf\s+/'
  'rm\s+-rf\s+~'
  'rm\s+-rf\s+\$HOME'
  'git\s+push\s+--force'
  'git\s+push\s+-f\b'
  'git\s+reset\s+--hard'
  'git\s+clean\s+-[a-z]*f[a-z]*d|git\s+clean\s+-[a-z]*d[a-z]*f'
  'chmod\s+(-R\s+)?777'
  '>\s*/dev/sd'
  'mkfs\.'
  'dd\s+if='
  ':\(\)\{.*:\|:&\};:'
  'curl\s.*\|\s*(bash|sh)'
  'wget\s.*\|\s*(bash|sh)'
)

for pattern in "${dangerous_patterns[@]}"; do
  if [[ "$command" =~ $pattern ]]; then
    echo "BLOCKED: Dangerous command pattern detected." >&2
    echo "The command was blocked by bash-safety-check.sh" >&2
    exit 2
  fi
done

exit 0
