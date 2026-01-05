---
description: Address CodeRabbit review comments on the current PR
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Fix CodeRabbit Review Comments

Fetch and address CodeRabbit's automated review comments.

## Pre-compute Context

```bash
echo "=== Current Branch ==="
git rev-parse --abbrev-ref HEAD

echo ""
echo "=== PR Number ==="
gh pr view --json number -q '.number' 2>/dev/null || echo "No PR found for this branch"

echo ""
echo "=== PR Review Comments ==="
gh pr view --json reviews,comments -q '.reviews[].body, .comments[].body' 2>/dev/null | head -100
```

## Workflow

### 1. Fetch Review Comments
Use `gh` CLI to get all review comments:
```bash
gh pr view --comments
```

Look specifically for comments from CodeRabbit (usually prefixed with actionable items).

### 2. Categorize Issues
Group the feedback by type:
- **Critical**: Security issues, bugs, breaking changes
- **Important**: Performance, best practices, code quality
- **Suggestions**: Style, naming, minor improvements

### 3. Address Each Issue
For each CodeRabbit comment:
1. Read the specific file and line mentioned
2. Understand the suggestion
3. Implement the fix if it's valid
4. If you disagree with a suggestion, note why (we can respond to the comment)

### 4. Verify Fixes
- Run tests if available
- Run linting if configured
- Ensure no regressions

### 5. Commit the Fixes
Create a commit specifically for the review fixes:
```
fix: address coderabbit review feedback

- [list specific fixes made]
```

## Important Notes

- Don't blindly apply all suggestions - some may not apply to our context
- If a suggestion conflicts with project conventions, skip it and note why
- Group related fixes into logical commits if there are many changes
