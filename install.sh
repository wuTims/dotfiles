#!/bin/bash

# Claude Code Dotfiles Installer
# This script symlinks your Claude Code configuration to ~/.claude

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "🤖 Claude Code Dotfiles Installer"
echo "=================================="
echo ""

# Check if ~/.claude already exists
if [ -d "$CLAUDE_DIR" ] && [ ! -L "$CLAUDE_DIR" ]; then
    echo "⚠️  ~/.claude already exists and is not a symlink."
    echo "   Backing up to ~/.claude.backup"
    mv "$CLAUDE_DIR" "$CLAUDE_DIR.backup.$(date +%Y%m%d%H%M%S)"
elif [ -L "$CLAUDE_DIR" ]; then
    echo "🔗 Removing existing symlink at ~/.claude"
    rm "$CLAUDE_DIR"
fi

# Create symlink
echo "📁 Creating symlink: ~/.claude -> $SCRIPT_DIR/claude"
ln -s "$SCRIPT_DIR/claude" "$CLAUDE_DIR"

# Verify installation
echo ""
echo "✅ Installation complete!"
echo ""
echo "Installed configuration:"
echo "  📄 ~/.claude/CLAUDE.md (global instructions)"
echo "  ⚙️  ~/.claude/settings.json (global settings)"
echo "  📂 ~/.claude/commands/ (global slash commands)"
echo "  🤖 ~/.claude/agents/ (global subagents)"
echo ""

# List installed commands
echo "Available global commands:"
for cmd in "$CLAUDE_DIR/commands"/*.md; do
    if [ -f "$cmd" ]; then
        name=$(basename "$cmd" .md)
        echo "  /$name"
    fi
done

echo ""

# List installed agents
echo "Available global subagents:"
for agent in "$CLAUDE_DIR/agents"/*.md; do
    if [ -f "$agent" ]; then
        name=$(basename "$agent" .md)
        echo "  @$name"
    fi
done

echo ""
echo "📝 To set up a new project, copy the starter template:"
echo "   cp $SCRIPT_DIR/project-templates/starter/CLAUDE.md /path/to/your/project/"
echo "   cp -r $SCRIPT_DIR/project-templates/starter/.claude /path/to/your/project/"
echo ""
echo "🚀 You're all set! Run 'claude' in any project to get started."
