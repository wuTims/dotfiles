#!/bin/bash

# Dotfiles Installer
# Symlinks configuration files to their expected locations

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Dotfiles Installer"
echo "=================="
echo ""

# --- Claude Code ---
CLAUDE_DIR="$HOME/.claude"

if [ -d "$CLAUDE_DIR" ] && [ ! -L "$CLAUDE_DIR" ]; then
    echo "~/.claude exists and is not a symlink. Backing up..."
    mv "$CLAUDE_DIR" "$CLAUDE_DIR.backup.$(date +%Y%m%d%H%M%S)"
elif [ -L "$CLAUDE_DIR" ]; then
    echo "Removing existing symlink at ~/.claude"
    rm "$CLAUDE_DIR"
fi

echo "Linking: ~/.claude -> $SCRIPT_DIR/.claude"
ln -s "$SCRIPT_DIR/.claude" "$CLAUDE_DIR"

# --- Add other dotfiles here ---
# Example:
# ln -sf "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
# ln -sf "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"

echo ""
echo "Installation complete!"
echo ""
echo "Claude Code config:"
echo "  ~/.claude/CLAUDE.md"
echo "  ~/.claude/settings.json"
echo "  ~/.claude/commands/"
echo "  ~/.claude/agents/"
echo ""

# List installed commands
echo "Available commands:"
for cmd in "$CLAUDE_DIR/commands"/*.md; do
    if [ -f "$cmd" ]; then
        name=$(basename "$cmd" .md)
        echo "  /$name"
    fi
done

echo ""

# List installed agents
echo "Available agents:"
for agent in "$CLAUDE_DIR/agents"/*.md; do
    if [ -f "$agent" ]; then
        name=$(basename "$agent" .md)
        echo "  @$name"
    fi
done

echo ""
echo "Run 'claude' in any project to get started."
