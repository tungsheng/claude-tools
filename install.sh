#!/usr/bin/env bash
set -euo pipefail

# Symlink claude-tools into a target project or globally into ~/.claude.
#
# Usage:
#   ./install.sh --global                 # agents + skills, all projects
#   ./install.sh /path/to/project         # full .claude/ into one project
#   ./install.sh --uninstall --global     # remove global symlinks
#   ./install.sh --uninstall /path/to/project  # remove project symlink

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/.claude"

UNINSTALL=false

if [[ -t 1 ]]; then
  GREEN='\033[32m' RED='\033[31m' YELLOW='\033[33m' CYAN='\033[36m' DIM='\033[2m' RESET='\033[0m'
else
  GREEN='' RED='' YELLOW='' CYAN='' DIM='' RESET=''
fi

# Logging helpers.
ok()    { echo -e "${GREEN}✓${RESET} $*"; }
err()   { echo -e "${RED}✗${RESET} $*"; }
warn()  { echo -e "  ${YELLOW}↻${RESET} $*"; }
item()  { echo -e "  ${CYAN}‣${RESET} $*"; }
muted() { echo -e "${DIM}$1${RESET} ${*:2}"; }

pretty() {
  local p="$1" h="$HOME"
  echo "${p/$h/\~}"
}

usage() {
  echo "Usage: $0 [options] [--global | <project-directory>]"
  echo ""
  echo "Options:"
  echo "  --uninstall   Remove previously installed symlinks"
  echo "  --help, -h    Show this help"
  echo ""
  echo "Modes:"
  echo "  --global              Agents + skills into ~/.claude/"
  echo "  <project-directory>   Full .claude/ into the project"
  echo ""
  echo "Global install: agents and skills only (hooks are project-level)."
}

# Create a symlink, handling existing targets.
# Sets SYMLINK_ACTION ("created", "replaced", "forced") for caller output.
symlink() {
  local src="$1" dst="$2"
  SYMLINK_ACTION="created"

  if [[ -L "$dst" ]]; then
    rm "$dst"
    SYMLINK_ACTION="replaced"
  elif [[ -e "$dst" ]]; then
    local backup="${dst}.bak.$(date +%s)"
    mv "$dst" "$backup"
    SYMLINK_ACTION="forced"
    SYMLINK_BACKUP="$(basename "$backup")"
  fi

  ln -s "$src" "$dst"
}

# Remove a symlink only if it points back to our source directory.
remove_symlink() {
  local dst="$1"

  if [[ ! -L "$dst" ]]; then
    return 1
  fi

  local target
  target="$(readlink "$dst")"
  if [[ "$target" == "$SOURCE_DIR"* ]]; then
    rm "$dst"
    return 0
  else
    muted "⊘" "Skipped $(pretty "$dst") (points elsewhere)"
    return 1
  fi
}

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --uninstall) UNINSTALL=true; shift ;;
    --global)    POSITIONAL+=("$1"); shift ;;
    --help|-h)   usage; exit 0 ;;
    --*)         err "Unknown option: $1"; usage; exit 1 ;;
    *)           POSITIONAL+=("$1"); shift ;;
  esac
done
set -- "${POSITIONAL[@]+"${POSITIONAL[@]}"}"

if [[ ! -d "$SOURCE_DIR" ]]; then
  err "Source not found: $(pretty "$SOURCE_DIR")"
  exit 1
fi

# Global: symlink agents/ and skills/ into ~/.claude/
if [[ "${1:-}" == "--global" ]]; then
  GLOBAL_DIR="$HOME/.claude"

  if [[ "$UNINSTALL" == true ]]; then
    removed=false
    remove_symlink "$GLOBAL_DIR/agents" && removed=true
    remove_symlink "$GLOBAL_DIR/skills" && removed=true
    if [[ "$removed" == true ]]; then
      ok "Uninstalled from $(pretty "$GLOBAL_DIR")"
      item "Removed agents/ and skills/ symlinks"
    else
      muted "⊘" "Nothing to uninstall in $(pretty "$GLOBAL_DIR")"
    fi
    exit 0
  fi

  mkdir -p "$GLOBAL_DIR"
  symlink "$SOURCE_DIR/agents" "$GLOBAL_DIR/agents"
  was_replaced=$SYMLINK_ACTION
  symlink "$SOURCE_DIR/skills" "$GLOBAL_DIR/skills"

  ok "Installed into $(pretty "$GLOBAL_DIR")"
  [[ "$was_replaced" == "replaced" ]] && warn "Replaced existing symlinks"
  item "agents   team-lead, senior-coder, ux-designer, quality-engineer"
  item "skills   /commit, /release, /explain, /pr, /security-audit"
  echo ""
  echo "  To add hooks and settings, install into a project:"
  echo -e "  ${DIM}→${RESET} $0 /path/to/project"
  exit 0
fi

# Project: symlink full .claude/ directory
if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

TARGET_DIR="$1"

if [[ ! -d "$TARGET_DIR" ]]; then
  err "Directory not found: $TARGET_DIR"
  exit 1
fi

TARGET_CLAUDE="$TARGET_DIR/.claude"

if [[ "$UNINSTALL" == true ]]; then
  if remove_symlink "$TARGET_CLAUDE"; then
    ok "Uninstalled from $TARGET_DIR"
    item "Removed .claude/ symlink"
  else
    muted "⊘" "Nothing to uninstall in $TARGET_DIR"
  fi
  exit 0
fi

chmod +x "$SOURCE_DIR"/hooks/*.sh 2>/dev/null || true
symlink "$SOURCE_DIR" "$TARGET_CLAUDE"

ok "Installed into $TARGET_DIR"
[[ "$SYMLINK_ACTION" == "forced" ]] && warn "Backed up existing .claude/ → ${SYMLINK_BACKUP}"
[[ "$SYMLINK_ACTION" == "replaced" ]] && warn "Replaced existing symlink"
item "agents   team-lead, senior-coder, ux-designer, quality-engineer"
item "skills   /commit, /release, /explain, /pr, /security-audit"
item "hooks    post-edit-format, bash-safety-check, notify"
echo ""
echo "  Run 'claude' in $TARGET_DIR to get started."
