# Set the ZDOTDIR variable to the standard XDG config location
# This must be done in .zshenv to affect all subsequent Zsh startup files.
export ZDOTDIR="$HOME/.config/zsh"

# Suppress the new-user-install wizard
# We do this by defining the function as a no-op (a colon)
zsh-newuser-install() { :; }
