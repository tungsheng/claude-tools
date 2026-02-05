# Claude Tools

A ready-to-use collection of agents, skills, hooks, and settings for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## What's Inside

```
.claude/
├── agents/        # Specialized sub-agents
├── skills/        # Slash commands
├── hooks/         # Lifecycle scripts
└── settings.json  # Permissions & hook config
```

### Agents

| Agent | Description |
|-------|-------------|
| **Team Lead** | Orchestrates tasks, breaks down work, delegates to other agents |
| **Senior Coder** | Implements features, refactors code, writes production-quality software |
| **UX Designer** | Reviews UI/UX, accessibility, error messages, developer experience |
| **Quality Engineer** | Writes tests, validates behavior, checks CI, reviews edge cases |

### Skills (Slash Commands)

| Command | Description |
|---------|-------------|
| `/commit` | Analyze staged changes and create a conventional commit |
| `/release` | Bump version, update changelog, create git tag |
| `/explain` | Explain code with ASCII diagrams and analogies |
| `/pr` | Create a pull request with summary and test plan |

### Hooks

| Hook | Trigger | Description |
|------|---------|-------------|
| `post-edit-format.sh` | After Edit/Write | Auto-formats files using the appropriate formatter |
| `pre-commit-lint.sh` | Before Bash | Guards against dangerous shell commands |

## Quick Start

### Option 1: Symlink into your project

```bash
./install.sh /path/to/your/project
```

This creates a symlink from your project's `.claude/` to this repo, so everything stays in sync.

### Option 2: Copy directly

```bash
cp -r .claude/ /path/to/your/project/.claude/
```

### Then use it

```bash
cd /path/to/your/project
claude
```

The agents, skills, and hooks are automatically available.

## Customizing

- **Add an agent** — create a markdown file in `.claude/agents/` with YAML frontmatter (`name`, `model`, `description`, `tools`)
- **Add a skill** — create a `SKILL.md` in `.claude/skills/<name>/` with `user-invocable: true` in the frontmatter
- **Add a hook** — add a script to `.claude/hooks/`, make it executable, and register it in `settings.json`

## License

MIT
