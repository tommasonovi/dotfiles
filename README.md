# dotfiles

Personal terminal setup for macOS, Ubuntu, and devcontainers.

## Tools

- **Shell**: zsh with autosuggestions and git completion
- **Prompt**: [Starship](https://starship.rs/) with custom palette
- **Terminal**: Ghostty (macOS)
- **Multiplexer**: tmux (Ctrl+A prefix, vim navigation)
- **Navigation**: zoxide (`cd` → smart jump)
- **Fuzzy search**: fzf (Ctrl+R history, Ctrl+T files)
- **File browser**: walk (`lk`)
- **ls**: eza
- **cat/pager**: bat (gruvbox-dark theme)
- **Git diff**: [delta](https://github.com/dandavison/delta) (side-by-side, syntax highlighting, gruvbox theme)

## Structure
```
dotfiles/
├── install.sh            # run once per machine
├── zshrc                 # single zshrc, works on all platforms
├── zsh_aliases           # zsh aliases
├── shared_aliases        # aliases that work in bash and zsh
├── linux_aliases         # linux-specific aliases and functions
├── starship.toml         # prompt config
├── tmux.conf             # tmux config (Ctrl+A, vim-style)
├── gitconfig             # git config (aliases, delta, colors)
├── vimrc                 # vim config
├── bat/config            # bat config
├── ghostty/config        # ghostty config (macOS only)
├── personal_profile.sh   # devcontainer bootstrap (tracked)
├── custom.profile.sh     # devcontainer custom profile (tracked)
└── README.md
```

## Install

### macOS or Ubuntu
```bash
git clone https://github.com/tommasonovi/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

The installer handles everything: symlinks, tool installs, zsh plugins, git config, and setting zsh as default shell.

### Devcontainer

No manual setup needed. The devcontainer loads automatically via `custom.profile.sh` → `personal_profile.sh`:

1. `install.sh` symlinks `custom.profile.sh` into `~/src/project-x/.devcontainer/` (gitignored)
2. `install.sh` symlinks `personal_profile.sh` to `/var/figure/.personal_profile.sh`
3. On container start, `personal_profile.sh` installs tools to `/var/figure/bin` (persists across rebuilds), runs `install.sh` for symlinks, and switches to zsh

`/var/figure` is mounted from the host, so dotfiles and tools persist across container rebuilds.

### Flags

| Flag | Effect |
|---|---|
| `--no-ghostty` | Skip Ghostty install |
| `--no-chsh` | Skip changing default shell |
| `--no-sudo` | Skip apt installs |

## Git aliases

| Alias | Command |
|---|---|
| `git st` | `status -sb` |
| `git d` | fzf file picker with delta diff preview |
| `git sw` | fzf branch picker → switch |
| `git br` | list branches (sorted by recent) |
| `git brd` | fzf branch picker → delete (Tab for multi-select) |
| `git lg` | pretty log graph |
| `git lga` | pretty log graph (all branches) |
| `git co` | checkout |
| `git nb` | checkout -b (new branch) |
| `git aa` | add --all |
| `git ci` | commit |
| `git cim` | commit -m |
| `git oups` | amend last commit (no edit) |
| `git unstage` | reset HEAD |
| `git uncommit` | reset --soft HEAD^ |
| `git pushfl` | push --force-with-lease |
| `git yeet` | push and set upstream |

## tmux

Prefix is **Ctrl+A**.

| Key | Action |
|---|---|
| `Ctrl+A \|` | Split horizontal |
| `Ctrl+A -` | Split vertical |
| `Ctrl+A c` | New window |
| `Ctrl+A h/j/k/l` | Navigate panes (vim-style) |
| `Alt+Arrow` | Navigate panes (no prefix) |
| `Ctrl+A H/J/K/L` | Resize panes |
| `Ctrl+A Enter` | Copy mode (vi keys) |
| `Ctrl+A r` | Reload config |
| `Ctrl+A d` | Detach |

## Updating
```bash
cd ~/dotfiles  # or /var/figure/dotfiles in devcontainer
git pull
```

Changes to existing files are live immediately since everything is symlinked.
