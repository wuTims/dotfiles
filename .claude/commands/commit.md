---
description: "Commit changes with optional push and PR creation. Usage: /commit [--push] [--pr]"
allowed-tools: Bash, Read, Glob
---

# Git Commit Workflow

Arguments: $ARGUMENTS

```bash
echo "=== Current Branch ==="
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")
echo "Branch: $CURRENT_BRANCH (default: $DEFAULT_BRANCH)"

echo ""
echo "=== Git Status ==="
git status --short

echo ""
echo "=== Staged Changes ==="
git diff --cached --stat 2>/dev/null || echo "(no staged changes)"

echo ""
echo "=== Unstaged Changes ==="
git diff --stat 2>/dev/null || echo "(no unstaged changes)"

echo ""
echo "=== Recent Commits (style reference) ==="
git log --oneline -5 2>/dev/null || echo "(no commits yet)"
```

## Workflow

### 1. Review & Stage
- Review changes above
- Stage relevant files (skip `.env*`, `*.pem`, `*.key`, `credentials*`, `secrets*`)
- Do NOT stage unrelated changes

### 2. Commit
- Draft message: `type(scope): description`
- Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `style`, `perf`
- Match style of recent commits
- Show message for approval, then commit

### 3. Push (if `--push` or `--pr`)
- If on default branch, create feature branch: `type/short-description`
- Push with `--set-upstream` for new branches

### 4. Create PR (if `--pr`)
- Verify `gh auth status` first
- Use `gh pr create`:
  ```bash
  gh pr create --title "type(scope): description" --body "## Summary
  - [changes]

  ## Test Plan
  - [verification steps]"
  ```
- If PR exists, show URL instead

## Mode Detection

Based on `$ARGUMENTS`:
- No args → commit only
- `--push` → commit + push
- `--pr` → commit + push + create PR

## Important

- Never commit secrets or credentials
- Always show commit message for approval
- If `gh` not authenticated, stop and inform user
- If merge conflicts exist, stop and inform user
