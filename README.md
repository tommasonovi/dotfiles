# dotfiles

Personal terminal setup for macOS, Ubuntu, and devcontainers.

## Tools

- **Shell**: zsh with autosuggestions and git completion
- **Prompt**: [Starship](https://starship.rs/) with custom palette
- **Terminal**: Ghostty (macOS)
- **Multiplexer**: tmux (Ctrl+A prefix, vim navigation)
- **Navigation**: zoxide (`cd` → smart jump)
- **Fuzzy search**: fzf (Ctrl+R history, Ctrl+T files, uses rg to respect .gitignore)
- **File browser**: walk (`lk`)
- **ls**: eza
- **cat/pager**: bat (gruvbox-dark theme)
- **Git diff**: [delta](https://github.com/dandavison/delta) (side-by-side, syntax highlighting, gruvbox theme)
- **Editor**: vim with [vim-plug](https://github.com/junegunn/vim-plug), [gitgutter](https://github.com/airblade/vim-gitgutter), [fugitive](https://github.com/tpope/vim-fugitive), [fzf.vim](https://github.com/junegunn/fzf.vim)

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
├── gitconfig             # git config (aliases, delta)
├── vimrc                 # vim config (vim-plug, gitgutter, fugitive, fzf.vim)
├── bat/config            # bat config
├── .claude/              # Claude Code settings and statusline
├── ghostty/config        # ghostty config (macOS only)
├── cursor/settings.json  # cursor editor settings (macOS only)
├── cursor/keybindings.json
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
| `git delta` | pretty diff with delta pager (side-by-side) |
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
| `git cob <name>` | create `user/tommasonovi/<name>` branch |

`git diff` outputs plain text (easy to copy-paste into Slack). `git delta` uses the delta pager for a pretty side-by-side view.

## Vim

Plugins auto-install on first launch via vim-plug. Leader key is **Space**.

### Fuzzy finder (fzf.vim)

| Key | Action |
|---|---|
| `Space ff` | Find files (respects .gitignore) |
| `Space fg` | Live grep (ripgrep) |
| `Space fb` | Switch buffers |
| `Space fh` | Recently opened files |
| `Space fl` | Search lines in current buffer |

### Git hunks (gitgutter)

Signs (`+`/`-`/`~`) appear in the gutter for changed lines.

| Key | Action |
|---|---|
| `]h` / `[h` | Jump to next / previous hunk |
| `Space hp` | Preview hunk diff |
| `Space hs` | Stage hunk |
| `Space hu` | Undo hunk (revert to HEAD) |

### Git workflow (fugitive)

| Key | Action |
|---|---|
| `Space gs` | Git status (`s` to stage, `u` to unstage, `=` to inline diff) |
| `Space gd` | Side-by-side diff (use `:diffget`/`:diffput` to move chunks) |
| `Space gb` | Git blame |
| `Space gl` | Git log (last 30 commits) |

### General

| Key | Action |
|---|---|
| `Space w` | Save |
| `Space q` | Quit |
| `Space e` | Toggle file explorer (netrw) |
| `Space bn/bp/bd` | Next / previous / delete buffer |
| `Ctrl+h/j/k/l` | Navigate splits |
| `Ctrl+d/u` | Scroll down/up (centered) |

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
