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
# Helper function to check if file is writable
# Returns 0 if writable, 1 if read-only (e.g., sandbox mount)
# ============================================
is_source_writable() {
    local src="$1"
    if [ -d "$src" ]; then
        # For directories, try to create a temp file
        local testfile="$src/.write_test_$$"
        if touch "$testfile" 2>/dev/null; then
            rm "$testfile"
            return 0
        fi
        return 1
    else
        # For files, check if we can write
        if [ -w "$src" ] && echo "" >> "$src" 2>/dev/null; then
            return 0
        fi
        return 1
    fi
}

# ============================================
# Helper function to link a dotfile
# Creates backup if target exists
# Falls back to copy if source is read-only (sandboxed environments)
# ============================================
link_dotfile() {
    local src="$1"
    local dest="$2"
    local name="$3"

    if [ ! -e "$src" ]; then
        echo "  [SKIP] $name - source not found"
        return
    fi

    # Determine if we should copy or symlink
    local use_copy=false
    if ! is_source_writable "$src"; then
        use_copy=true
    fi

    # Handle existing file/directory
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ -L "$dest" ]; then
            # It's a symlink - check if it points to our file
            local current_target=$(readlink "$dest")
            if [ "$current_target" = "$src" ] && [ "$use_copy" = false ]; then
                echo "  [OK] $name - already linked"
                return
            fi
            echo "  [BACKUP] Removing existing symlink: $dest"
            rm "$dest"
        else
            # It's a regular file/directory
            if [ "$use_copy" = true ]; then
                # In copy mode, check if content matches
                if [ -f "$src" ] && [ -f "$dest" ] && cmp -s "$src" "$dest"; then
                    echo "  [OK] $name - already copied (source read-only)"
                    return
                fi
            fi
            # Backup existing
            echo "  [BACKUP] $dest -> $dest$BACKUP_SUFFIX"
            mv "$dest" "$dest$BACKUP_SUFFIX"
        fi
    fi

    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"

    # Create symlink or copy based on source writability
    if [ "$use_copy" = true ]; then
        if [ -d "$src" ]; then
            cp -r "$src" "$dest"
        else
            cp "$src" "$dest"
        fi
        echo "  [COPY] $name -> $dest (source read-only, likely sandboxed)"
    else
        ln -s "$src" "$dest"
        echo "  [LINK] $name -> $dest"
    fi
}

# ============================================
# Claude Code Configuration
# ============================================
echo "Claude Code:"
link_dotfile "$SCRIPT_DIR/.claude" "$HOME/.claude" ".claude/"

# Set up MCP servers (claude mcp add is idempotent)
if command -v claude &> /dev/null; then
    echo "  [MCP] Setting up deepwiki server..."
    claude mcp add deepwiki --transport http --url https://mcp.deepwiki.com/mcp 2>/dev/null || true
else
    echo "  [SKIP] MCP setup - claude not installed yet"
    echo "         Run: claude mcp add deepwiki --transport http --url https://mcp.deepwiki.com/mcp"
fi

# ============================================
# Shell Configuration
# ============================================
echo ""
echo "Shell:"
link_dotfile "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc" ".zshrc"

# ============================================
# Git Configuration
# ============================================
echo ""
echo "Git:"
link_dotfile "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig" ".gitconfig"

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
