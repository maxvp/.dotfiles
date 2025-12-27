# ~/.dotfiles/fish/.config/fish/conf.d/environment.fish
# PATH environment variables

# Homebrew (Silicon)
# Only evaluate if the binary exists to avoid errors on non-Macs
if test -f /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

# Local Binaries
fish_add_path -m ~/.local/bin
fish_add_path -m ~/bin

# Editors
set -gx EDITOR micro
set -gx VISUAL micro

# Homebrew
set -gx HOMEBREW_NO_ANALYTICS 1

# Pure prompt
# Pure Prompt Configuration
set -gx pure_show_system_time false
set -gx pure_color_system_time pure_color_mute
set -gx pure_symbol_prompt "λ"
set -gx pure_shorten_prompt_current_directory_length 2
set -gx pure_symbol_git_unpulled_commits "↓"
set -gx pure_symbol_git_unpushed_commits "↑"
