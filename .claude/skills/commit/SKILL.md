---
name: commit
description: Analyze staged changes and create a conventional commit
user-invocable: true
---

# /commit — Smart Commit

Analyze staged changes and create a well-crafted conventional commit message.

## Instructions

1. **Check for staged changes** by running `git diff --cached --stat`. If nothing is staged, check `git status` and suggest what to stage, then stop.

2. **Analyze the diff** by running `git diff --cached` to understand:
   - What files were changed
   - The nature of the changes (new feature, bug fix, refactor, docs, tests, chore)
   - The scope of the changes (which module/component)

3. **Review recent commit history** by running `git log --oneline -10` to match the project's commit message style and conventions.

4. **Generate a commit message** following the Conventional Commits format:
   ```
   <type>(<scope>): <description>

   <optional body>
   ```

   Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `style`, `perf`, `ci`, `build`

   Rules:
   - Subject line under 72 characters
   - Use imperative mood ("add feature" not "added feature")
   - Body explains **why**, not **what** (the diff shows the what)
   - Reference issue numbers if visible in branch name or diff

5. **Present the message** to the user and ask for confirmation before committing.

6. **Create the commit** using `git commit -m "<message>"`. Use a HEREDOC for multi-line messages.

7. **Show the result** with `git log --oneline -1` to confirm.

## Dynamic Context

!`git diff --cached --stat 2>/dev/null || echo "No staged changes"`
!`git log --oneline -5 2>/dev/null || echo "No commit history"`
