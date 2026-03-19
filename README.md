# dotfiles

Personal terminal setup for macOS, Ubuntu, and devcontainers.

## Tools

- **Shell**: zsh with autosuggestions and git completion
- **Prompt**: Starship
- **Terminal**: Ghostty (macOS)
- **Multiplexer**: tmux
- **Navigation**: zoxide (`cd` → smart jump)
- **Fuzzy search**: fzf
- **File browser**: walk (`lk`)
- **ls**: eza
- **cat**: bat

## Structure
```
dotfiles/
├── install.sh          # run once per machine
├── zshrc               # single zshrc, works on all platforms
├── zsh_aliases         # zsh aliases
├── shared_aliases      # aliases that work in bash and zsh
├── starship.toml       # prompt config
├── tmux.conf           # tmux config
├── gitconfig           # git config (no personal info)
├── vimrc               # vim config
├── bat/config          # bat config
├── ghostty/config      # ghostty config (macOS only)
├── custom.profile.sh   # reference copy for devcontainer
└── README.md
```

## Install
```bash
git clone https://github.com/you/dotfiles.git ~/dotfiles
bash ~/dotfiles/install.sh
```

### Flags

| Flag | Effect |
|---|---|
| `--no-ghostty` | Skip Ghostty install (Linux/devcontainer) |
| `--no-chsh` | Skip changing default shell |
| `--no-sudo` | Skip apt installs (cluster) |

## Per-machine setup

### macOS
```bash
bash ~/dotfiles/install.sh
```

### Ubuntu SSH
```bash
bash ~/dotfiles/install.sh
```

Create `~/.gitconfig` with your personal info:
```ini
[user]
    name = Your Name
    email = your@email.com

[include]
    path = ~/dotfiles/gitconfig
```

### Devcontainer
Copy `custom.profile.sh` to `.devcontainer/custom.profile.sh` in your project.

Create `/var/figure/.personal_profile.sh`:
```bash
if [ ! -d /var/figure/dotfiles ]; then
  git clone https://github.com/you/dotfiles.git /var/figure/dotfiles
fi
if [ ! -f ~/.zshrc ]; then
  bash /var/figure/dotfiles/install.sh --no-ghostty --no-chsh
fi
exec zsh
```

Create `/var/figure/secrets.sh` (never committed):
```bash
export WANDB_API_KEY=your_key_here
```

### Cluster (no sudo)
```bash
bash ~/dotfiles/install.sh --no-sudo --no-ghostty
```

Create `~/.secrets`:
```bash
export WANDB_API_KEY=your_key_here
```

## Updating
```bash
cd ~/dotfiles  # or /var/figure/dotfiles in devcontainer
git pull
```

Changes to existing files are live immediately since everything is symlinked.
