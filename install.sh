#!/usr/bin/env bash
set -euo pipefail

# Install claude-tools into a target project by symlinking the .claude/ directory.
#
# Usage:
#   ./install.sh /path/to/your/project
#
# This creates a symlink at <project>/.claude -> <this-repo>/.claude
# so that agents, skills, hooks, and settings are available when running
# `claude` in the target project.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/.claude"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <target-project-directory>"
  echo ""
  echo "Symlinks the .claude/ directory into the target project so that"
  echo "agents, skills, hooks, and settings are available there."
  exit 1
fi

TARGET_DIR="$1"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: Target directory does not exist: $TARGET_DIR"
  exit 1
fi

TARGET_CLAUDE="$TARGET_DIR/.claude"

if [[ -L "$TARGET_CLAUDE" ]]; then
  echo "Removing existing symlink at $TARGET_CLAUDE"
  rm "$TARGET_CLAUDE"
elif [[ -d "$TARGET_CLAUDE" ]]; then
  echo "Error: $TARGET_CLAUDE already exists as a directory."
  echo "Back it up or remove it first, then re-run this script."
  exit 1
fi

ln -s "$SOURCE_DIR" "$TARGET_CLAUDE"
echo "Installed: $TARGET_CLAUDE -> $SOURCE_DIR"
echo ""
echo "Available in the target project:"
echo "  Agents:  team-lead, senior-coder, ux-designer, quality-engineer"
echo "  Skills:  /commit, /release, /explain, /pr"
echo "  Hooks:   post-edit-format, pre-commit-lint, notification"
