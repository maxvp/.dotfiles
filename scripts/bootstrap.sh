#!/bin/bash
set -e

# 0. Define Variables & Architecture Detection
DOTFILES_DIR="$HOME/.dotfiles"
TIMESTAMP=$(date +%Y%m%d)

if [[ "$(uname -m)" == "arm64" ]]; then
    BREW_PREFIX="/opt/homebrew"
else
    BREW_PREFIX="/usr/local"
fi

BREW_FISH="$BREW_PREFIX/bin/fish"

# 1. Install Dependencies
if [[ "$(uname)" == "Darwin" ]]; then
    # --- AUTO-INSTALL HOMEBREW ---
    if ! command -v brew >/dev/null 2>&1 && [[ ! -f "$BREW_PREFIX/bin/brew" ]]; then
        echo "🍺 Homebrew not found. Installing now..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Hydrate the current session with brew immediately
        eval "$($BREW_PREFIX/bin/brew shellenv)"
    else
        echo "✅ Homebrew is already installed."
        eval "$($BREW_PREFIX/bin/brew shellenv)"
    fi
    
    echo "📦 Checking core dependencies..."
    # Ensure Stow and Fish are present
    for pkg in stow fish; do
        if ! command -v $pkg >/dev/null 2>&1; then
            echo "   Installing $pkg..."
            brew install $pkg
        fi
    done
fi

echo "🔗 Preparing symlinks..."

# 2. PRE-FLIGHT CLEANUP & BACKUP
XDG_CONFIG_HOME="$HOME/.config"
mkdir -p "$XDG_CONFIG_HOME"

# Define the targets that Stow will manage
targets=("${HOME}/.zshenv" "${XDG_CONFIG_HOME}/fish" "${XDG_CONFIG_HOME}/zsh")

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
# Refresh plugins and sync with GitHub
bash "$DOTFILES_DIR/scripts/maintenance.sh"

# 5. SET FISH AS DEFAULT SHELL
CURRENT_SHELL=$(dscl . -read "$HOME" UserShell | awk '{print $2}')

if [[ "$CURRENT_SHELL" != "$BREW_FISH" ]]; then
    echo "🐟 Setting Fish as default shell..."
    
    # Add to /etc/shells if missing (requires sudo)
    if ! grep -q "$BREW_FISH" /etc/shells; then
        echo "   [SUDO] Adding $BREW_FISH to /etc/shells..."
        echo "$BREW_FISH" | sudo tee -a /etc/shells
    fi
    
    # Change the shell
    chsh -s "$BREW_FISH"
    echo "✅ Default shell changed to Fish ($BREW_FISH)."
else
    echo "✅ Fish is already the default shell."
fi

echo "---"
echo "🎉 Setup complete! Restart terminal."
