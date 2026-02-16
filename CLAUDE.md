# Claude Tools

A curated collection of Claude Code agents, skills, hooks, and settings — ready to copy or symlink into any project.

## Repository Structure

- `.claude/agents/` — Agent prompt files (team-lead, senior-coder, ux-designer, quality-engineer)
- `.claude/skills/` — Skill definitions invoked via slash commands (/commit, /release, /explain, /pr)
- `.claude/hooks/` — Shell scripts triggered by Claude Code lifecycle events
- `.claude/settings.json` — Hooks configuration and permission allowlists
- `install.sh` — Symlink helper to install into a target project

## Conventions

- Agent files use YAML frontmatter for metadata followed by a system prompt body
- Skill files use YAML frontmatter with `user-invocable: true` and instruction body
- Hook scripts must be executable (`chmod +x`)
- All shell scripts use `#!/usr/bin/env bash` and `set -euo pipefail`

## Usage

### Install globally

```bash
./install.sh --global
```

This symlinks agents and skills into `~/.claude/` so they're available in every project. Hooks and settings are project-level only and not included.

### Install into a project

```bash
./install.sh /path/to/your/project
```

This symlinks the full `.claude/` directory into the target project so agents, skills, hooks, and settings are available when running `claude` there.

### Available slash commands

- `/commit` — Analyze staged changes and create a conventional commit
- `/release` — Bump version, update changelog, create git tag
- `/explain` — Explain code with diagrams and analogies
- `/pr` — Create a pull request with summary and test plan
