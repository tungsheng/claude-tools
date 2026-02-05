---
name: pr
description: Create a pull request with summary, test plan, and linked issues
user-invocable: true
---

# /pr — Pull Request Creator

Create a well-structured pull request from the current branch.

## Instructions

1. **Gather context** by running these commands:
   - `git branch --show-current` — Current branch name
   - `git log --oneline main..HEAD` or `git log --oneline master..HEAD` — Commits on this branch
   - `git diff main..HEAD --stat` or `git diff master..HEAD --stat` — Files changed
   - `git diff main..HEAD` or `git diff master..HEAD` — Full diff
   - `git status` — Any uncommitted changes

2. **Detect the base branch** — Use `main` if it exists, otherwise `master`. If neither exists, ask the user.

3. **Check for uncommitted changes** — If there are unstaged or staged changes, ask the user if they want to commit first (suggest using `/commit`).

4. **Generate the PR**:
   - **Title**: Short (under 70 chars), descriptive, imperative mood
   - **Body** using this template:

   ```markdown
   ## Summary
   - <bullet points describing what changed and why>

   ## Test plan
   - [ ] <verification steps>

   ## Related issues
   - <#issue numbers extracted from branch name or commits, if any>
   ```

5. **Extract issue references** from:
   - Branch name (e.g., `fix/123-login-bug` → `#123`)
   - Commit messages (e.g., `fixes #456`)

6. **Present the PR** to the user for review before creating it.

7. **Create the PR** using the `gh` CLI:
   ```bash
   gh pr create --title "<title>" --body "<body>"
   ```

8. **Show the result** — Display the PR URL.

## Dynamic Context

!`git branch --show-current 2>/dev/null || echo "Not on a branch"`
!`git log --oneline main..HEAD 2>/dev/null || git log --oneline master..HEAD 2>/dev/null || echo "No commits ahead of base"`
!`git diff --stat main..HEAD 2>/dev/null || git diff --stat master..HEAD 2>/dev/null || echo "No diff from base"`
