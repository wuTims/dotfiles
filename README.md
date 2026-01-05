# Dotfiles

Personal configuration files.

## Quick Start

```bash
git clone https://github.com/wuTims/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

## What's Included

### Shell (`.zshrc`)

ZSH configuration with:
- Oh-My-Zsh plugins (git, docker, fzf, autosuggestions, syntax-highlighting)
- Common aliases (`ll`, `la`, docker, git shortcuts)
- Modern CLI replacements (eza, bat, fd, rg) when available
- Claude Code shortcuts (`c`, `cc`, `cr`)
- FZF configuration
- Helper functions (`mkcd`, `ff`, `dsh`)

### Claude Code (`.claude/`)

Global configuration for Claude Code CLI.

**Commands:**

| Command | Description |
|---------|-------------|
| `/commit` | Commit with conventional format |
| `/commit --push` | Commit and push |
| `/commit --pr` | Commit, push, and create PR |
| `/plan` | Create implementation plan |
| `/fix-coderabbit` | Address CodeRabbit review comments |

**Agents:**

| Agent | Description |
|-------|-------------|
| `@code-simplifier` | Simplifies code after implementation |
| `@doc-reviewer` | Reviews documentation and naming |
| `@test-reviewer` | Debugs failing tests |
| `@verify-app` | Verifies changes in isolated worktree |
| `@research-explorer` | Research using DeepWiki and web search |

### Adding More Dotfiles

Edit `install.sh` to add symlinks:

```bash
# Example additions
ln -sf "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"
```

## Claude Code Configuration

### Hierarchy

```
~/.claude/CLAUDE.md           # Global (always loaded)
    +
./CLAUDE.md                    # Project-specific (adds to global)
    +
./.claude/settings.json        # Project overrides
```

### Project-Specific Config

For projects needing custom config, create at project root:

**`CLAUDE.md`** (project context):
```markdown
# Project Name

## Tech Stack
Python 3.12, FastAPI, PostgreSQL

## Commands
- `uv run dev` - Start server
- `uv run pytest` - Run tests
```

**`.claude/settings.json`** (permission overrides):
```json
{
  "permissions": {
    "allow": ["Bash(npm run:*)"]
  }
}
```

## License

MIT
