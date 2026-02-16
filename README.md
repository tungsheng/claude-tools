# Claude Tools

Agents, skills, hooks, and settings for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — ready to install.

## Prerequisites

- [`jq`](https://jqlang.github.io/jq/) — required by hooks
- [`gh`](https://cli.github.com/) — required by `/pr`

## Install

```bash
# Global — agents + skills available in every project
./install.sh --global

# Project — full .claude/ directory (includes hooks + settings)
./install.sh /path/to/your/project
```

Existing non-symlink paths are automatically backed up to `*.bak.*`.

## Uninstall

```bash
./install.sh --uninstall --global
./install.sh --uninstall /path/to/your/project
```

## What's Included

| Type | Items |
|------|-------|
| **Agents** | team-lead, senior-coder, ux-designer, quality-engineer |
| **Skills** | `/commit`, `/release`, `/explain`, `/pr`, `/security-audit` |
| **Hooks** | post-edit-format, bash-safety-check, notify |

## Usage

```bash
cd /path/to/your/project
claude                    # agents, skills, and hooks are auto-detected
```

## Docs

- [Agents](docs/agents.md) — specialized sub-agents and how to add your own
- [Skills](docs/skills.md) — slash commands and how to create new ones
- [Hooks](docs/hooks.md) — lifecycle scripts and how to register them

## License

MIT
