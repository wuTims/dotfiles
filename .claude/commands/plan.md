---
description: Create a detailed implementation plan before coding
allowed-tools: Read, Glob, Grep, Bash
---

# Implementation Planning

Before writing any code, create a comprehensive plan.

## Planning Steps

### 1. Understand the Request
- Summarize what is being asked
- Identify any ambiguities or missing information
- Ask clarifying questions if needed (do this BEFORE proceeding)

### 2. Explore the Codebase
- Identify relevant files and directories
- Understand existing patterns and conventions
- Note any related functionality that might be affected

### 3. List Files to Modify
Create a clear list:
```
Files to CREATE:
- path/to/new/file.ts - purpose

Files to MODIFY:
- path/to/existing/file.ts - what changes

Files to DELETE (if any):
- path/to/obsolete/file.ts - why
```

### 4. Implementation Steps
Break down into small, verifiable steps:
1. Step description (which files, what changes)
2. Next step...
3. ...

### 5. Identify Risks
- Potential breaking changes
- Edge cases to handle
- Dependencies that might be affected
- Testing requirements

### 6. Verification Strategy
How will we verify this works?
- Unit tests needed?
- Integration tests?
- Manual verification steps?

## Output Format

Present the plan clearly and wait for approval before proceeding to implementation.

If the plan is approved, switch to auto-accept mode (Shift+Tab) and execute the plan step by step.
