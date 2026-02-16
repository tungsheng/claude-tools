#!/usr/bin/env bash
set -euo pipefail

# Send a desktop notification when Claude needs attention.
# Runs on Notification events.

if command -v osascript >/dev/null 2>&1; then
  osascript -e 'display notification "Claude needs your attention" with title "Claude Code"'
elif command -v notify-send >/dev/null 2>&1; then
  notify-send 'Claude Code' 'Claude needs your attention'
fi
