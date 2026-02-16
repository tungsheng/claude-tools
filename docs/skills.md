# Skills

Skills are slash commands that users invoke directly in Claude Code (e.g., `/commit`). Each skill provides structured instructions and optional dynamic context that runs at invocation time.

## Included Skills

### /commit

Analyzes staged changes and creates a conventional commit message. Checks `git diff --cached`, reviews recent commit style, generates a message following the `<type>(<scope>): <description>` format, and asks for confirmation before committing.

### /release

Automates the release workflow: detects the current version from manifest files or git tags, categorizes commits since the last release, recommends a semver bump, updates the changelog, and creates an annotated git tag. Asks for confirmation before committing.

### /explain

Explains code using a layered format: one-line summary, real-world analogy, step-by-step walkthrough with line references, optional ASCII diagram, and key concept callouts. Adapts depth to complexity.

### /pr

Creates a pull request from the current branch. Detects the base branch, gathers commit history and diffs, generates a title and body (summary, test plan, related issues), and creates the PR via `gh pr create` after user review.

### /security-audit

Scans the project for security vulnerabilities and misconfigurations. Identifies the tech stack, checks for hardcoded secrets, scans for OWASP Top 10 issues, reviews infrastructure configs, and presents findings by severity with concrete fixes. Can be scoped to a file, directory, or area (e.g., `/security-audit auth`).

## Adding a Skill

Create a `SKILL.md` file in `.claude/skills/<name>/`:

```markdown
---
name: my-skill
description: One-line description shown in skill list
user-invocable: true
---

# /my-skill — Display Name

Instructions for Claude go here.

## Dynamic Context

!`shell command that runs at invocation time`
```

### Frontmatter Reference

| Field | Required | Description |
|-------|----------|-------------|
| `name` | yes | Skill identifier (used in `/name`) |
| `description` | yes | One-line summary |
| `user-invocable` | yes | Must be `true` for slash command access |

### Dynamic Context

Lines prefixed with `!` followed by a backtick-wrapped command are executed when the skill is invoked. The output is injected into the prompt as context.

```markdown
!`git diff --cached --stat 2>/dev/null || echo "No staged changes"`
```

Use this for git state, file listings, or other ephemeral context that informs the skill's behavior. Keep commands fast — they run synchronously at invocation.
