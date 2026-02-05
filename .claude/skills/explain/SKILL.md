---
name: explain
description: Explain code with ASCII diagrams, analogies, and step-by-step walkthroughs
user-invocable: true
---

# /explain — Code Explainer

Explain code clearly using diagrams, analogies, and layered detail.

## Instructions

When the user invokes `/explain`, they may provide a file path, function name, or code snippet. If nothing is specified, ask what they'd like explained.

### Explanation Format

Structure every explanation in three layers:

1. **One-line summary** — What does this code do in plain English?

2. **Analogy** — Relate it to a real-world concept:
   - "This works like a post office sorting room..."
   - "Think of this as a bouncer at a club who checks IDs..."

3. **Step-by-step walkthrough** — Walk through the code linearly:
   - Number each step
   - Reference specific line numbers
   - Explain *why* each step exists, not just *what* it does

4. **ASCII diagram** (when helpful) — Visualize:
   - Data flow between components
   - State machines and transitions
   - Request/response cycles
   - Tree structures (ASTs, DOM, file systems)
   - Pipeline/transformation chains

   Example:
   ```
   Request → [Auth Middleware] → [Rate Limiter] → [Handler] → Response
                   │                    │
                   ↓                    ↓
              401 Reject           429 Too Many
   ```

5. **Key concepts** — List any patterns, algorithms, or concepts the reader should know:
   - Name the pattern (e.g., "Observer Pattern", "Debouncing")
   - Link to the concept, don't over-explain it

### Guidelines

- Adjust depth to the complexity of the code — don't over-explain simple things
- Use the user's language level — if they ask "what does this do?", keep it simple; if they ask about internals, go deep
- Highlight potential gotchas, edge cases, or non-obvious behavior
- If the code has bugs or anti-patterns, mention them tactfully

## Dynamic Context

!`git ls-files --others --cached --exclude-standard 2>/dev/null | head -20 || echo "Not a git repo"`
