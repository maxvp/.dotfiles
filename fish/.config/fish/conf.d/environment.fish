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

# git prompt
set -gx __fish_git_prompt_show_informative_status 1

## symbols
set -gx __fish_git_prompt_char_stateseparator ' '
set -gx __fish_git_prompt_char_dirtystate '*'
set -gx __fish_git_prompt_char_stagedstate '+'
set -gx __fish_git_prompt_char_untrackedfiles '?'
set -gx __fish_git_prompt_char_cleanstate ''
