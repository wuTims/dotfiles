# Claude Code Dotfiles

Personal Claude Code configuration following Boris Cherny's workflow philosophy.

## Philosophy

> "My setup might be surprisingly vanilla! Claude Code works great out of the box, so I personally don't customize it much." — Boris Cherny

This configuration focuses on:
- **Simple, repeatable workflows** via slash commands
- **Automated verification** via subagents
- **Layered configuration** (global defaults + project overrides)
- **Safety first** (permissions, denied patterns)

## Quick Start

```bash
# Clone this repo
git clone <your-repo-url> ~/claude-dotfiles
cd ~/claude-dotfiles

# Run the installer
chmod +x install.sh
./install.sh
```

## What's Included

### Global Configuration (`~/.claude/`)

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Global instructions for all projects |
| `settings.json` | Permissions, hooks, model preferences |
| `commands/` | Slash commands available everywhere |
| `agents/` | Subagents available everywhere |

### Slash Commands

| Command | Description |
|---------|-------------|
| `/commit` | Commit with conventional format |
| `/commit --push` | Commit and push to remote |
| `/commit --pr` | Commit, push, and create PR |
| `/plan` | Create implementation plan before coding |
| `/fix-coderabbit` | Address CodeRabbit review comments |

### Subagents

| Agent | Description |
|-------|-------------|
| `@code-simplifier` | Simplifies code after implementation |
| `@doc-reviewer` | Reviews documentation and naming |
| `@test-reviewer` | Debugs failing tests, reviews test quality |
| `@verify-app` | Verifies changes in isolated git worktree |
| `@research-explorer` | Deep research using DeepWiki and web search |

## Project Setup

For new projects, copy the starter template:

```bash
cp -r ~/claude-dotfiles/project-templates/starter/{CLAUDE.md,.claude} /path/to/project/
```

Then customize the project's `CLAUDE.md` with:
- Tech stack details
- Directory structure
- Common commands
- Project-specific patterns

## Configuration Hierarchy

Claude Code merges configuration from multiple levels:

```
~/.claude/CLAUDE.md          # Your personal preferences (always loaded)
    ↓
./CLAUDE.md                   # Project-specific context (adds to global)
    ↓
./.claude/settings.json       # Project settings (override global)
    ↓
./.claude/settings.local.json # Local overrides (gitignored)
```

## Key Workflows

### Boris' Workflow Pattern

1. **Start in Plan Mode** (`Shift+Tab` twice) for non-trivial tasks
2. **Iterate on the plan** until satisfied
3. **Switch to auto-accept** (`Shift+Tab`) and execute
4. **Use `/commit --pr`** to ship the changes
5. **Let `@verify-app`** catch issues early

### Daily Commands

```bash
# Start Claude in any project
cd my-project && claude

# Plan before coding
/plan

# After making changes
/commit --pr

# Address review feedback
/fix-coderabbit
```

## Customization

### Adding New Commands

Create a markdown file in `~/.claude/commands/`:

```markdown
---
description: What this command does
allowed-tools: Bash, Read, Write
---

Instructions for Claude...
```

### Adding New Subagents

Create a markdown file in `~/.claude/agents/`:

```markdown
---
name: agent-name
description: When to use this agent. Use PROACTIVELY when...
tools: Read, Write, Bash
model: sonnet
---

System prompt for the agent...
```

## Docker / Container Usage

Mount your config into containers:

```yaml
# docker-compose.yml
services:
  dev:
    volumes:
      - ~/.claude:/root/.claude:ro
```

## Teleport Handoffs

Transfer sessions between terminal and web:

```bash
# In Claude Code terminal session
# Type: &
# This backgrounds the session and gives you a teleport URL

# Or start with teleport enabled
claude --teleport
```

## License

MIT - Use and customize freely.
