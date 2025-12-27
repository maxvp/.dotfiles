#!/bin/bash
set -e

# 0. Define variables
DOTFILES_DIR="$HOME/.dotfiles"
TIMESTAMP=$(date +%Y%m%d)

# 1. Install Dependencies
if [[ "$(uname)" == "Darwin" ]]; then
    command -v brew >/dev/null 2>&1 || { echo "❌ Homebrew not found. Install it first."; exit 1; }
    command -v stow >/dev/null 2>&1 || brew install stow
fi

echo "🔗 Preparing symlinks..."

# 2. PRE-FLIGHT CLEANUP & BACKUP
# Files/Dirs that Stow will manage. 
# We must remove the real ~/.config/fish and ~/.config/zsh if they exist 
# or Stow will fail to link the folders.
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

# --restow ensures existing links are updated
# --adopt is a "Technical Strategist" choice: it will incorporate 
# local changes into your repo if they exist (use with caution)
stow -v --restow zsh
stow -v --restow fish
stow -v --restow scripts

# 4. INITIAL MAINTENANCE
# We use the absolute path to ensure it runs regardless of current shell
bash "$DOTFILES_DIR/scripts/maintenance.sh"

echo "---"
echo "✅ System ready."
echo "   - For Zsh: Run 'exec zsh'"
echo "   - For Fish: Run 'fish'"
