# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias nrd="npm run dev"
alias git-recent="git branch --sort=-committerdate"
alias gaa="git add --all"
unalias gp
alias gp="git push"
alias gcp="git checkout production"

### zsh-abbr
ABBR_SET_EXPANSION_CURSOR=1

# abbrs
abbr -a gc "git commit"
abbr -a gco "git checkout"
abbr -a gcm "git commit -m \"%\""
abbr -a gac "git add * && git commit -m \"%\""
