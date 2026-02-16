---
name: security-audit
description: Scan the codebase for security vulnerabilities and misconfigurations
user-invocable: true
---

# /security-audit — Security Audit

Scan the project for security vulnerabilities, misconfigurations, and risky patterns.

## Instructions

The user may provide a scope (e.g., a file path, directory, or area like "auth" or "API routes"). If no scope is given, audit the full project.

1. **Identify the tech stack** by checking manifest files (`package.json`, `Cargo.toml`, `pyproject.toml`, `go.mod`, `Gemfile`, etc.) and scanning file extensions. This determines which vulnerability classes to prioritize.

2. **Check for secrets and credentials** — scan for:
   - Hardcoded API keys, tokens, passwords, or connection strings
   - `.env` files or secrets committed to git (`git ls-files` matching `*.env*`, `*secret*`, `*credential*`, `*.pem`, `*.key`)
   - Private keys, certificates, or keystores in the repo
   - Sensitive values in config files or environment variable defaults

3. **Scan for OWASP Top 10 vulnerabilities** relevant to the stack:
   - **Injection** — SQL injection, command injection, LDAP injection, template injection
   - **Broken Auth** — weak session handling, missing token validation, hardcoded credentials
   - **Sensitive Data Exposure** — unencrypted secrets, missing HTTPS enforcement, verbose error messages leaking internals
   - **XXE / Insecure Deserialization** — unsafe XML parsing, pickle/yaml.load/eval usage
   - **Broken Access Control** — missing auth checks on routes, IDOR patterns, path traversal
   - **Security Misconfiguration** — debug mode in production, default credentials, permissive CORS, missing security headers
   - **XSS** — unsanitized user input rendered in HTML, missing CSP headers, innerHTML/dangerouslySetInnerHTML usage
   - **SSRF** — user-controlled URLs passed to fetch/request without validation
   - **Insecure Dependencies** — known vulnerable packages (check lockfiles if present)

4. **Check infrastructure and config files** for:
   - Overly permissive file permissions (`chmod 777`, world-readable secrets)
   - Docker misconfigurations (running as root, exposing unnecessary ports, `latest` tags)
   - CI/CD pipeline risks (secrets in logs, missing pinned action versions)
   - Permissive `.gitignore` (missing entries for `.env`, `*.key`, `node_modules/`, build artifacts)

5. **Review authentication and authorization patterns** (if present):
   - Token storage (localStorage vs httpOnly cookies)
   - Password hashing (bcrypt/argon2 vs MD5/SHA1/plain)
   - Session expiry and refresh logic
   - Rate limiting on auth endpoints

6. **Present findings** organized by severity:

   ```markdown
   ## Critical
   - [file:line] Description and impact
     **Fix:** specific remediation

   ## High
   - ...

   ## Medium
   - ...

   ## Low
   - ...

   ## Passed Checks
   - Brief list of areas that look good
   ```

   Rules:
   - Always include the file path and line number
   - Explain the **impact** — what could an attacker do?
   - Provide a concrete **fix** — not just "sanitize input" but show the specific function or pattern to use
   - Don't report false positives — if you're unsure, say so
   - Include a "Passed Checks" section so the user knows what was covered

7. **Suggest next steps** if applicable:
   - Dependency audit commands (`npm audit`, `pip-audit`, `cargo audit`)
   - Security headers to add
   - Environment-specific hardening (production vs development)

## Dynamic Context

!`git ls-files --cached --exclude-standard 2>/dev/null | head -40 || echo "Not a git repo"`
!`cat package.json 2>/dev/null | head -5 || cat Cargo.toml 2>/dev/null | head -5 || cat pyproject.toml 2>/dev/null | head -5 || echo "No manifest found"`
