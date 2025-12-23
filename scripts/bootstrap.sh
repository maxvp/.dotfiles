#!/bin/bash
set -e

# --- Configuration ---
DOTFILES_DIR="$HOME/.dotfiles"
REPO_URL="https://github.com/maxvp/.dotfiles.git"
FILES_TO_LINK=(
    "zsh/.zshrc"
    "zsh/.zimrc"
    "zsh/.zprofile"
    "zsh/abbrs.zsh"
    "zsh/aliases.zsh"
)

echo "🚀 Starting .dotfiles Bootstrap..."

# 1. Clone or Pull Repo
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "📦 Cloning repo..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    echo "🔄 Pulling latest changes..."
    git -C "$DOTFILES_DIR" pull --rebase
fi

# 2. Set Permissions for all scripts
chmod +x "$DOTFILES_DIR/scripts/"*.sh

# 3. macOS Specific Setup
if [[ "$(uname)" == "Darwin" ]]; then
    echo "🍎 macOS detected. Running system setup..."
    bash "$DOTFILES_DIR/scripts/setup_mac.sh"
else
    echo "🐧 Linux detected. Skipping macOS-specific setup."
    # If you ever create a setup_linux.sh, you would call it here.
fi

# 4. Symlink Files
echo "🔗 Creating symbolic links..."
link_file() {
    local src="$DOTFILES_DIR/$1"
    local dest="$HOME/$(basename "$1")"

    # Handle existing files/links
    if [[ -L "$dest" ]]; then
        rm "$dest"
    elif [[ -f "$dest" ]]; then
        mv "$dest" "$dest.backup"
        echo "   [BACKUP] $dest saved as $dest.backup"
    fi

    ln -s "$src" "$dest"
    echo "   [LINK] $dest -> $src"
}

for file in "${FILES_TO_LINK[@]}"; do
    link_file "$file"
done

# 5. Zimfw Check & Install
if [[ ! -d "$HOME/.zim" ]]; then
    echo "📦 Installing Zimfw..."
    curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
fi

# 6. Run initial Maintenance
# This will generate your aliases.zsh and run the Doctor checks
echo "🛠️ Running initial maintenance..."
bash "$DOTFILES_DIR/scripts/maintenance.sh"

echo "✅ Bootstrap complete! Run 'exec zsh' to start your new shell."