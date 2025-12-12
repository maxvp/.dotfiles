#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# --- Configuration ---
DOTFILES_DIR="$HOME/dotfiles"
REPO_URL="git@github.com:maxvp/dotfiles.git" # <<< CRITICAL: REPLACE THIS URL
# Files to link from the repo to the home directory
FILES_TO_LINK=(
    "zsh/.zshrc"
    "zsh/.zimrc"
)

echo "🪶 Starting Zimfw Dotfiles Bootstrap..."
echo "---"

# 1. Clone the repository if it doesn't exist
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "📦 Cloning dotfiles from $REPO_URL..."
    # Use HTTPS if you haven't set up SSH keys yet
    # git clone "https://github.com/YOUR_USERNAME/dotfiles.git" "$DOTFILES_DIR"
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    echo "✅ Dotfiles repository already present at $DOTFILES_DIR."
    echo "Pulling latest changes..."
    (cd "$DOTFILES_DIR" && git pull)
fi

# 2. Define Symlink Function
# Handles backing up existing files before creating a new symlink.
link_file() {
    local src="$DOTFILES_DIR/$1"
    local dest="$HOME/$(basename "$1")"
    
    # Check if the source file exists in the repo
    if [ ! -f "$src" ]; then
        echo "   [SKIP] Source file not found in repo: $src"
        return
    fi

    # Check for existing destination file
    if [ -e "$dest" ]; then
        if [ -L "$dest" ] && [ "$(readlink "$dest")" == "$src" ]; then
            echo "   [OK] $dest is already correctly linked."
            return
        else
            echo "   [BACKUP] Backing up existing $dest to $dest.backup"
            mv "$dest" "$dest.backup"
        fi
    fi
    
    echo "   [LINK] Creating symlink $dest -> $src"
    ln -s "$src" "$dest"
}

# 3. Create Symlinks for Zsh config files
echo "---"
echo "🔗 Creating Symbolic Links:"
for file in "${FILES_TO_LINK[@]}"; do
    link_file "$file"
done

# 4. Change default shell to Zsh (Check if Zsh is available first)
if command -v zsh > /dev/null 2>&1; then
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "---"
        echo "🐚 Changing default shell to Zsh..."
        chsh -s "$(which zsh)"
    else
        echo "---"
        echo "✅ Default shell is already Zsh."
    fi
else
    echo "---"
    echo "⚠️  Zsh command not found. Skipping default shell change. Please install Zsh."
fi

echo "---"
echo "✨ Bootstrap Complete! The next time you open a new terminal, Zimfw will self-install and load your config."
echo "If this is the first run, please restart your terminal now."
