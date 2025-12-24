# .dotfiles for zsh

To set up, run:

```bash
git clone https://github.com/maxvp/.dotfiles.git $HOME/.dotfiles && bash $HOME/.dotfiles/scripts/bootstrap.sh
```

## Directory structure

```txt
~/.dotfiles/
├── zsh/                # zsh configuration packages
│   ├── .zshrc          # main config (sources files)
│   ├── .zprofile       # login logic
│   └── aliases.zsh     # aliases
├── scripts/
│   ├── bootstrap.sh    # setup script
│   └── maintenance.sh  # sync and update plugins
├── plugins/
│   └── plugin_list.txt # list of plugins to install
└── .gitignore
```
