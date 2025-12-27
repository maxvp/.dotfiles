#!/bin/bash
set -e

# 0. Define variables
DOTFILES_DIR="$HOME/.dotfiles"
TIMESTAMP=$(date +%Y%m%d)
# Use Homebrew paths for Apple Silicon
BREW_FISH="/opt/homebrew/bin/fish"
BREW_ZSH="/bin/zsh" # Use system Zsh as the fallback anchor

# 1. Install Dependencies
if [[ "$(uname)" == "Darwin" ]]; then
    command -v brew >/dev/null 2>&1 || { echo "❌ Homebrew not found. Install it first."; exit 1; }
    
    echo "📦 Checking core dependencies..."
    for pkg in stow fish; do
        command -v $pkg >/dev/null 2>&1 || brew install $pkg
    done
fi

echo "🔗 Preparing symlinks..."

# 2. PRE-FLIGHT CLEANUP & BACKUP
XDG_CONFIG_HOME="$HOME/.config"
mkdir -p "$XDG_CONFIG_HOME"

targets=("$HOME/.zshenv" "$XDG_CONFIG_HOME/fish" "$XDG_CONFIG_HOME/zsh")

for target in "${targets[@]}"; do
    if [[ -e "$target" && ! -L "$target" ]]; then
        BACKUP_NAME="${target}.backup-${TIMESTAMP}"
        echo "   [BACKUP] Moving existing $target to $(basename "$BACKUP_NAME")"
        mv "$target" "$BACKUP_NAME"
    fi
done

# 3. RUN STOW
cd "$DOTFILES_DIR"
echo "📦 Stowing packages..."
stow -v -R zsh
stow -v -R fish
stow -v -R scripts

# 4. INITIAL MAINTENANCE
bash "$DOTFILES_DIR/scripts/maintenance.sh"

# 5. SET FISH AS DEFAULT SHELL
CURRENT_SHELL=$(dscl . -read "$HOME" UserShell | awk '{print $2}')

if [[ "$CURRENT_SHELL" != "$BREW_FISH" ]]; then
    echo "🐟 Setting Fish as default shell..."
    
    # Check if fish is in /etc/shells (required for chsh)
    if ! grep -q "$BREW_FISH" /etc/shells; then
        echo "   [SUDO] Adding $BREW_FISH to /etc/shells..."
        echo "$BREW_FISH" | sudo tee -a /etc/shells
    fi
    
    # Change the shell
    chsh -s "$BREW_FISH"
    echo "✅ Default shell changed to Fish."
else
    echo "✅ Fish is already the default shell."
fi

# 6. ENSURE ZSH FALLBACK IS READY
if [[ ! -f "$HOME/.zshenv" ]]; then
    echo "⚠️ Warning: Zsh fallback might be misconfigured (no .zshenv)."
else
    echo "🛡️ Zsh fallback is linked and ready at $BREW_ZSH"
fi

echo "---"
echo "🎉 Setup complete! Please restart your terminal."
