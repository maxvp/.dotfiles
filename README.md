# .dotfiles for zsh

To set up, run:

```bash
git clone https://github.com/maxvp/.dotfiles.git $HOME/.dotfiles && bash $HOME/.dotfiles/scripts/bootstrap.sh
```

## Directory structure

```txt
.
└── .dotfiles/
    ├── README.md
    ├── zsh/
    │   ├── .zimrc         # change zimfw settings
    │   ├── .zprofile      # change profile settings
    │   ├── .zshrc         # change zsh settings
    │   ├── abbrs.zsh      # add abbrs
    │   └── aliases.zsh    # add aliases
    └── scripts/
        ├── bootstrap.sh   # initial setup
        └── maintenance.sh # maintain zsh health
```
