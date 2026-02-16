#!/usr/bin/env bash
set -euo pipefail

# Guard against dangerous commands in Bash tool calls.
# This hook runs on PreToolUse for Bash commands.
# It reads the command from stdin (JSON) and checks for dangerous patterns.

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty' 2>/dev/null || true)

if [[ -z "$command" ]]; then
  exit 0
fi

# Patterns that should be blocked or warned about
dangerous_patterns=(
  "rm -rf /"
  "rm -rf ~"
  "git push --force"
  "git push -f"
  "git reset --hard"
  "git clean -fd"
  "chmod -R 777"
  "> /dev/sda"
  "mkfs\."
  "dd if="
  ":(){:|:&};:"
)

for pattern in "${dangerous_patterns[@]}"; do
  if [[ "$command" == *"$pattern"* ]]; then
    echo "BLOCKED: Dangerous command detected: $pattern" >&2
    echo "The command '$command' contains a dangerous pattern and was blocked." >&2
    exit 2
  fi
done

exit 0
