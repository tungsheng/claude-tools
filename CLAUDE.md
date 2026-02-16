# Claude Tools

A curated collection of Claude Code agents, skills, hooks, and settings — ready to copy or symlink into any project.

## Repository Structure

- `.claude/agents/` — Agent prompt files
- `.claude/skills/` — Skill definitions (slash commands)
- `.claude/hooks/` — Shell scripts triggered by Claude Code lifecycle events
- `.claude/settings.json` — Hooks configuration and permission allowlists
- `install.sh` — Symlink installer with `--global` and `--uninstall`
- `docs/` — Detailed docs for agents, skills, and hooks

## Prerequisites

- `jq` — required by bash-safety-check hook (blocks all Bash commands if missing)
- `gh` CLI — required by the `/pr` skill

## Conventions

- Agent files use YAML frontmatter for metadata followed by a system prompt body
- Omit the `tools` field in agent frontmatter to grant all tools; list specific tools to restrict
- Skill files use YAML frontmatter with `user-invocable: true` and instruction body
- Hook scripts must be executable (`chmod +x`) and live in `.claude/hooks/`
- All shell scripts use `#!/usr/bin/env bash` and `set -euo pipefail`
- Hooks read JSON input via stdin — use `printf '%s' "$input" | jq` (not `echo`)
- Hook exit codes: 0 = allow, 2 = block (PreToolUse only)

## Testing changes

- `./install.sh --global` — install globally (agents + skills)
- `mkdir -p /tmp/test-project && ./install.sh /tmp/test-project` — install into project
- `./install.sh --uninstall --global` — remove global symlinks
- `./install.sh --uninstall /tmp/test-project` — remove project symlink
