---
name: release
description: Bump version, update changelog, create git tag, and prepare for publish
user-invocable: true
---

# /release — Release Workflow

Automate the release process: version bump, changelog update, git tag, and optional publish.

## Instructions

1. **Determine the current version** by checking (in order):
   - `package.json` → `version` field
   - `Cargo.toml` → `version` field
   - `pyproject.toml` → `version` field
   - Latest git tag: `git describe --tags --abbrev=0`
   - If no version found, ask the user

2. **Analyze changes since last release** by running:
   - `git log --oneline $(git describe --tags --abbrev=0 2>/dev/null)..HEAD` (commits since last tag)
   - Categorize into: features, fixes, breaking changes, other

3. **Determine version bump** based on changes:
   - **major** — Breaking changes present (or user requests)
   - **minor** — New features, no breaking changes
   - **patch** — Bug fixes only
   - Present recommendation and ask user to confirm

4. **Update version** in the appropriate manifest file(s)

5. **Update CHANGELOG.md** (create if it doesn't exist):
   - Add a new section with the version number and date
   - Group entries under: Added, Changed, Fixed, Removed, Breaking
   - Include commit summaries with attribution

6. **Create the release commit and tag**:
   ```bash
   git add -A
   git commit -m "chore(release): v<version>"
   git tag -a v<version> -m "Release v<version>"
   ```

7. **Report next steps** — Remind the user to:
   - Push the commit and tag: `git push && git push --tags`
   - Publish if applicable (`npm publish`, `cargo publish`, etc.)

## Dynamic Context

!`git describe --tags --abbrev=0 2>/dev/null || echo "No tags found"`
!`git log --oneline -10 2>/dev/null || echo "No commit history"`
