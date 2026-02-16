#!/usr/bin/env bash
set -euo pipefail

# Install claude-tools into a target project or globally.
#
# Usage:
#   ./install.sh /path/to/your/project   # project-level install
#   ./install.sh --global                 # global install (~/.claude)
#
# Project install symlinks the entire .claude/ directory so that agents,
# skills, hooks, and settings are all available in the target project.
#
# Global install symlinks only agents and skills into ~/.claude/ since
# hooks and settings are not supported at the global level.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/.claude"

usage() {
  echo "Usage: $0 [--global | <target-project-directory>]"
  echo ""
  echo "  <target-project-directory>  Symlink the full .claude/ directory into a project"
  echo "  --global                    Symlink agents and skills into ~/.claude/"
  echo ""
  echo "Global install makes skills and agents available in all projects."
  echo "Hooks and settings are only supported at the project level."
}

symlink() {
  local src="$1" dst="$2" label="$3"

  if [[ -L "$dst" ]]; then
    echo "Removing existing symlink at $dst"
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    echo "Error: $dst already exists. Back it up or remove it first."
    exit 1
  fi

  ln -s "$src" "$dst"
  echo "  $label -> $src"
}

# --- Global install ---
if [[ "${1:-}" == "--global" ]]; then
  GLOBAL_DIR="$HOME/.claude"
  mkdir -p "$GLOBAL_DIR"

  echo "Installing globally into $GLOBAL_DIR"
  symlink "$SOURCE_DIR/agents" "$GLOBAL_DIR/agents" "agents"
  symlink "$SOURCE_DIR/skills" "$GLOBAL_DIR/skills" "skills"

  echo ""
  echo "Available globally:"
  echo "  Agents:  team-lead, senior-coder, ux-designer, quality-engineer"
  echo "  Skills:  /commit, /release, /explain, /pr"
  echo ""
  echo "Note: Hooks and settings must be installed per-project."
  echo "Run '$0 /path/to/project' to install hooks into a specific project."
  exit 0
fi

# --- Project install ---
if [[ $# -lt 1 ]]; then
  usage
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
echo "  Hooks:   post-edit-format, pre-commit-lint"
