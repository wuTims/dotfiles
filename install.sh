#!/bin/bash

# Dotfiles Installer
# Symlinks configuration files to their expected locations
# Creates .bkup of existing files before overwriting

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_SUFFIX=".bkup.$(date +%Y%m%d%H%M%S)"

echo "Dotfiles Installer"
echo "=================="
echo ""

# ============================================
# Helper function to link a dotfile
# Creates backup if target exists
# ============================================
link_dotfile() {
    local src="$1"
    local dest="$2"
    local name="$3"

    if [ ! -e "$src" ]; then
        echo "  [SKIP] $name - source not found"
        return
    fi

    # Handle existing file/directory
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ -L "$dest" ]; then
            # It's a symlink - check if it points to our file
            local current_target=$(readlink "$dest")
            if [ "$current_target" = "$src" ]; then
                echo "  [OK] $name - already linked"
                return
            fi
            echo "  [BACKUP] Removing existing symlink: $dest"
            rm "$dest"
        else
            # It's a regular file/directory - backup
            echo "  [BACKUP] $dest -> $dest$BACKUP_SUFFIX"
            mv "$dest" "$dest$BACKUP_SUFFIX"
        fi
    fi

    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"

    # Create symlink
    ln -s "$src" "$dest"
    echo "  [LINK] $name -> $dest"
}

# ============================================
# Claude Code Configuration
# ============================================
echo "Claude Code:"
link_dotfile "$SCRIPT_DIR/.claude" "$HOME/.claude" ".claude/"

# ============================================
# Shell Configuration
# ============================================
echo ""
echo "Shell:"
link_dotfile "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc" ".zshrc"

# ============================================
# Git Configuration (optional)
# ============================================
# Uncomment to enable:
# echo ""
# echo "Git:"
# link_dotfile "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig" ".gitconfig"

# ============================================
# Summary
# ============================================
echo ""
echo "Installation complete!"
echo ""

# List installed Claude commands
if [ -d "$HOME/.claude/commands" ]; then
    echo "Claude commands:"
    for cmd in "$HOME/.claude/commands"/*.md; do
        if [ -f "$cmd" ]; then
            name=$(basename "$cmd" .md)
            echo "  /$name"
        fi
    done
    echo ""
fi

# List installed Claude agents
if [ -d "$HOME/.claude/agents" ]; then
    echo "Claude agents:"
    for agent in "$HOME/.claude/agents"/*.md; do
        if [ -f "$agent" ]; then
            name=$(basename "$agent" .md)
            echo "  @$name"
        fi
    done
    echo ""
fi

echo "Run 'source ~/.zshrc' or restart your shell to apply changes."
