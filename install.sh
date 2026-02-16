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
FORCE=false

usage() {
  echo "Usage: $0 [--force] [--global | <target-project-directory>]"
  echo ""
  echo "  --global                    Symlink agents and skills into ~/.claude/"
  echo "  --force                     Back up existing paths before symlinking"
  echo "  <target-project-directory>  Symlink the full .claude/ directory into a project"
  echo ""
  echo "Global install makes skills and agents available in all projects."
  echo "Hooks and settings are only supported at the project level."
}

symlink() {
  local src="$1" dst="$2" label="$3"

  if [[ -L "$dst" ]]; then
    echo "Replacing existing symlink at $dst"
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    if [[ "$FORCE" == true ]]; then
      local backup="${dst}.bak"
      echo "Backing up $dst -> $backup"
      mv "$dst" "$backup"
    else
      echo "Error: $dst already exists."
      echo "  Use --force to auto-backup, or remove it manually."
      exit 1
    fi
  fi

  ln -s "$src" "$dst"
  echo "  $label -> $src"
}

# --- Parse flags ---
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)  FORCE=true; shift ;;
    --global) POSITIONAL+=("$1"); shift ;;
    --help|-h) usage; exit 0 ;;
    --*)      echo "Unknown flag: $1"; usage; exit 1 ;;
    *)        POSITIONAL+=("$1"); shift ;;
  esac
done
set -- "${POSITIONAL[@]+"${POSITIONAL[@]}"}"

# Validate source directory exists
if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Error: Source directory not found: $SOURCE_DIR"
  exit 1
fi

# Ensure hook scripts are executable
chmod +x "$SOURCE_DIR"/hooks/*.sh 2>/dev/null || true

# --- Global install ---
if [[ "${1:-}" == "--global" ]]; then
  GLOBAL_DIR="$HOME/.claude"
  mkdir -p "$GLOBAL_DIR"

  echo "Installing globally into $GLOBAL_DIR"
  symlink "$SOURCE_DIR/agents" "$GLOBAL_DIR/agents" "agents"
  symlink "$SOURCE_DIR/skills" "$GLOBAL_DIR/skills" "skills"

  echo ""
  echo "Done. Agents and skills are now available in all projects."
  echo ""
  echo "Note: Hooks and settings are project-level only."
  echo "Run '$0 /path/to/project' to install them into a specific project."
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
  echo "Replacing existing symlink at $TARGET_CLAUDE"
  rm "$TARGET_CLAUDE"
elif [[ -d "$TARGET_CLAUDE" ]]; then
  if [[ "$FORCE" == true ]]; then
    backup="${TARGET_CLAUDE}.bak"
    echo "Backing up $TARGET_CLAUDE -> $backup"
    mv "$TARGET_CLAUDE" "$backup"
  else
    echo "Error: $TARGET_CLAUDE already exists as a directory."
    echo "  Use --force to auto-backup, or remove it manually."
    exit 1
  fi
fi

ln -s "$SOURCE_DIR" "$TARGET_CLAUDE"
echo "Installed: $TARGET_CLAUDE -> $SOURCE_DIR"
echo ""
echo "Run 'claude' in $TARGET_DIR to get started."
