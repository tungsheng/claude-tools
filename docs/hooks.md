# Hooks

Hooks are shell scripts that run automatically during Claude Code lifecycle events. They receive JSON input on stdin describing the tool call that triggered them.

## Prerequisites

- [`jq`](https://jqlang.github.io/jq/) — required by hooks that parse stdin JSON. If missing, `bash-safety-check.sh` will block all Bash commands as a fail-safe.

## Included Hooks

### post-edit-format.sh

- **Trigger:** `PostToolUse` for `Edit` and `Write`
- **Purpose:** Auto-formats the edited file using the project's formatter.
- **Formatters:** Prettier (JS/TS/CSS/HTML/JSON/YAML/MD), black or ruff (Python), rustfmt (Rust), gofmt (Go)
- **Behavior:** Only runs if the formatter is locally installed. Fails silently if no formatter is found — never blocks edits.

### bash-safety-check.sh

- **Trigger:** `PreToolUse` for `Bash`
- **Purpose:** Blocks dangerous shell commands before execution.
- **Blocked patterns:** `rm -rf /`, `rm -rf ~`, `rm -rf $HOME`, `git push --force`, `git push -f`, `git reset --hard`, `git clean -fd` (any flag order), `chmod [-R] 777`, `> /dev/sd*`, `mkfs.*`, `dd if=`, `curl|bash`, `curl|sh`, `wget|bash`, `wget|sh`, fork bombs
- **Behavior:** Exits with code 2 to block the command. This is a defense-in-depth measure — it catches common destructive patterns but is not a security boundary against intentional circumvention.

### notify.sh

- **Trigger:** `Notification`
- **Purpose:** Sends a desktop notification when Claude needs attention.
- **Platforms:** macOS (`osascript`), Linux (`notify-send`)

## Adding a Hook

1. Create an executable script in `.claude/hooks/`:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Read JSON input from stdin
input=$(cat)
value=$(printf '%s' "$input" | jq -r '.tool_input.some_field // empty')

# Your logic here
```

2. Register it in `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/your-hook.sh",
            "statusMessage": "Running your hook"
          }
        ]
      }
    ]
  }
}
```

### Hook Events

| Event | When | Use Case |
|-------|------|----------|
| `PreToolUse` | Before a tool runs | Validation, blocking dangerous actions |
| `PostToolUse` | After a tool runs | Formatting, side effects |
| `Notification` | Claude needs attention | Desktop alerts |

### Stdin JSON Schema

Hooks receive a JSON object on stdin. The structure depends on the event:

```json
{
  "tool_name": "Edit",
  "tool_input": {
    "file_path": "/path/to/file.ts",
    "old_string": "...",
    "new_string": "..."
  }
}
```

### Conventions

- Use `#!/usr/bin/env bash` and `set -euo pipefail`
- Parse stdin with `printf '%s' "$input" | jq` (not `echo` — handles special characters)
- Exit 0 to allow, exit 2 to block (PreToolUse only)
- Suppress formatter errors with `|| true` — hooks should not break the workflow
- Make scripts executable: `chmod +x .claude/hooks/your-hook.sh`
