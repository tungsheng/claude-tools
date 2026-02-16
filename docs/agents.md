# Agents

Agents are specialized sub-agents that Claude Code can delegate to via the `Task` tool. Each agent has a focused role, a model assignment, and a restricted (or unrestricted) tool set.

## Included Agents

### Team Lead

- **Model:** opus
- **Tools:** all (unrestricted)
- **Role:** Receives high-level objectives, breaks them into subtasks, delegates to the right agent, and reviews the output.

### Senior Coder

- **Model:** sonnet
- **Tools:** Read, Edit, Write, Bash, Grep, Glob
- **Role:** Implements features, fixes bugs, and refactors code. Follows existing project patterns and writes minimal, correct code.

### UX Designer

- **Model:** sonnet
- **Tools:** Read, Grep, Glob, WebFetch (read-only — cannot edit files)
- **Role:** Reviews interfaces through the user's lens — UI clarity, accessibility (WCAG), error messages, and developer experience. Returns actionable suggestions.

### Quality Engineer

- **Model:** sonnet
- **Tools:** Read, Edit, Write, Bash, Grep, Glob
- **Role:** Writes tests, identifies edge cases, runs test suites, and validates CI. The last line of defense before code ships.

## Adding an Agent

Create a markdown file in `.claude/agents/`:

```markdown
---
name: My Agent
model: sonnet
description: One-line description shown in agent selection
tools:
  - Read
  - Edit
  - Grep
---

System prompt body goes here. Describe the agent's role,
responsibilities, and working style.
```

### Frontmatter Reference

| Field | Required | Description |
|-------|----------|-------------|
| `name` | yes | Display name |
| `model` | yes | `opus`, `sonnet`, or `haiku` |
| `description` | yes | One-line summary |
| `tools` | no | List of allowed tools. **Omit entirely** to grant all tools. |

Available tools: `Read`, `Edit`, `Write`, `Bash`, `Grep`, `Glob`, `WebFetch`, `WebSearch`, `Task`, `NotebookEdit`
