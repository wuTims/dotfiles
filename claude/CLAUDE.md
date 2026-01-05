# Global Claude Code Configuration

This file applies to ALL projects and agents. Project-specific overrides go in `./CLAUDE.md`.

## Communication Style

### Tone
- Professional and educational
- Concise but thorough
- Explain the "why" behind recommendations, not just the "what"

### Engage Critically
- Present options with trade-offs rather than assuming a single path
- Prompt me to consider angles I might have missed
- Ask clarifying questions BEFORE making significant changes
- If a task seems ambiguous, summarize understanding before proceeding

### Punctuation
- No em dashes; prefer commas, parentheses, or separate sentences

## Code Principles

### Write Clean Code
- Explicit over implicit
- Self-documenting code with clear naming
- Comments explain "why", not "what"
- No magic numbers - use named constants
- Early returns over nested conditionals (max 3 levels)
- Keep functions small and focused (single responsibility)

### No Breadcrumbs
- When removing code, delete it completely - no "removed X" comments
- Don't leave TODO markers pointing to deleted functionality
- Git history tracks changes; code should read as if always this way

### Treat New as Original
- Don't rename variables/functions to reflect "new" vs "old" approach
- Don't add comments explaining what changed from previous implementation
- Architecture decisions belong in documentation, not code comments
- The current implementation IS the implementation

### Fix Root Causes
- Never apply bandaid fixes - find and fix the source
- Do deep research on issues before implementing solutions
- If a fix feels hacky, step back and understand the real problem
- Ask clarifying questions rather than guessing at solutions

### Clean Up Thoroughly
- When changing code, remove ALL unused imports, parameters, functions
- Don't leave orphaned code "just in case"
- If refactoring, complete the refactor - no half-measures

### Search Before Pivoting
- When stuck, search for official docs/specs/solutions first
- Don't pivot approaches without clear evidence it's necessary
- Ask for clarification rather than guessing and changing direction
- Web search for unfamiliar libraries before making assumptions

### Clarify Complex Logic
- If code is hard to understand, add ASCII art diagrams in comments
- Visual representations help future readers (including you)
```
// Request flow:
//   Client -> API Gateway -> Auth -> Service -> DB
//                              |
//                              v
//                          Cache (if miss)
```

## Testing Philosophy

### Test Strategy
- **Unit tests**: Test isolated logic, pure functions, edge cases
- **E2E tests**: Test real integrations with local Docker containers
- **No mocks**: Avoid mock-heavy tests - they test mocks, not code
  - Exception: External APIs that can't be containerized

### When to Test
- Write tests for new functionality
- Update tests when modifying existing behavior
- Run only tests for modified code unless full suite requested
- Always verify existing tests still pass after changes

### Test Quality
- Tests document expected behavior
- Test edge cases and error conditions
- Each test verifies one behavior
- Fast tests (unit < 1s, suite < 2min)

### Local Testing Setup
- Use Docker Compose for dependencies (DB, Redis, external services)
- Tests should run identically on any machine
- No tests that depend on external service availability

## Python

### Tooling
- **Package manager**: `uv` with `pyproject.toml` (not pip, Poetry, or requirements.txt)
- **Environment**: `uv sync` for dependency resolution and virtual env
- **Linting/Formatting**: `ruff` (prompt to install if missing)
- **Type checking**: `mypy` (prompt to install if missing)

### Code Style
- Strong types and type hints everywhere
- Explicit models over loose `dict` or `str` (use dataclasses, Pydantic, TypedDict)
- Don't overcomplicate simple structures - match complexity to need
- Google-style docstrings for public APIs

### Commands
```bash
uv sync                    # Install/update dependencies
uv run pytest              # Run tests
uv run ruff check .        # Lint
uv run ruff format .       # Format
uv run mypy .              # Type check
```

## Workflow

### Planning
- Start in Plan mode (Shift+Tab twice) for non-trivial tasks
- Break large tasks into smaller, verifiable steps
- Identify files to modify before making changes

### Verification
- Verify changes work before committing
- Run relevant tests after changes
- Check for regressions in related functionality

## Common Tools

- **Git**: Version control
- **gh CLI**: GitHub operations (PRs, issues, reviews)
- **Docker**: Local testing environments
- **CodeRabbit**: Automated code review

## MCP Servers

- **deepwiki**: Explore GitHub repos and library documentation
- **Notion**: Workspace documentation (if connected)

## Safety Rules

### Never
- Commit `.env` files or secrets
- Run `rm -rf` without confirmation
- Force push to main/master
- Skip tests to save time

### Always
- Check `git status` before committing
- Verify correct branch before pushing
- Run relevant tests after significant changes
