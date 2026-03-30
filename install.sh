#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
OS="$(uname -s)"
SKIP_GHOSTTY=false
SKIP_CHSH=false
NO_SUDO=false

for arg in "$@"; do
  [ "$arg" = "--no-ghostty" ] && SKIP_GHOSTTY=true
  [ "$arg" = "--no-chsh" ]    && SKIP_CHSH=true
  [ "$arg" = "--no-sudo" ]    && NO_SUDO=true
done

echo "==> Detected OS: $OS"

# ── Symlinks ──────────────────────────────────────────────────
ln -sf "$DOTFILES/zshrc"          ~/.zshrc
ln -sf "$DOTFILES/zsh_aliases"    ~/.zsh_aliases
ln -sf "$DOTFILES/shared_aliases" ~/.shared_aliases
ln -sf "$DOTFILES/tmux.conf"      ~/.tmux.conf
ln -sf "$DOTFILES/vimrc"          ~/.vimrc


mkdir -p ~/.config/bat
ln -sf "$DOTFILES/starship.toml"  ~/.config/starship.toml
ln -sf "$DOTFILES/bat/config"     ~/.config/bat/config

# ── Bash starship init (for vibe sessions that use bash) ─────
STARSHIP_INIT='eval "$(/var/figure/bin/starship init bash)"'
if [ -f /.dockerenv ] && [ -f ~/.bashrc ] && ! grep -q 'starship init bash' ~/.bashrc; then
  echo "$STARSHIP_INIT" >> ~/.bashrc
fi

# ── sh starship init (for minimal containers using /bin/sh) ──
STARSHIP_INIT_SH='eval "$(/var/figure/bin/starship init sh)"'
if [ -f /.dockerenv ] && ! grep -q 'starship init sh' ~/.profile 2>/dev/null; then
  echo "$STARSHIP_INIT_SH" >> ~/.profile
fi

# Linux only aliases
[ "$OS" = "Linux" ] && ln -sf "$DOTFILES/linux_aliases" ~/.linux_aliases

# ── Git config ────────────────────────────────────────────────
if [ ! -f ~/.gitconfig ]; then
  if [ -t 0 ]; then
    echo "==> Setting up ~/.gitconfig"
    read -p "Git name: " git_name
    read -p "Git email: " git_email
    cat > ~/.gitconfig << EOF
[user]
    name = $git_name
    email = $git_email

[include]
    path = $DOTFILES/gitconfig
EOF
  else
    echo "==> Skipping git config (non-interactive). Run install.sh manually to set up."
  fi
else
  # Make sure include is present
  if ! grep -q "path = $DOTFILES/gitconfig" ~/.gitconfig; then
    printf "\n[include]\n    path = %s/gitconfig\n" "$DOTFILES" >> ~/.gitconfig
  fi
fi

# ── zsh plugins ───────────────────────────────────────────────
mkdir -p ~/.zsh
if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
  git clone --quiet https://github.com/zsh-users/zsh-autosuggestions \
    ~/.zsh/zsh-autosuggestions
fi
if [ ! -f ~/.zsh/git-completion.bash ]; then
  curl -so ~/.zsh/git-completion.bash \
    https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
fi

# ── macOS ─────────────────────────────────────────────────────
if [ "$OS" = "Darwin" ]; then
  brew install starship zoxide fzf walk tmux eza git-delta
  brew install --cask font-jetbrains-mono-nerd-font

  # Cursor editor settings
  cursor_target="$HOME/Library/Application Support/Cursor/User"
  if [ -d "$cursor_target" ]; then
    ln -sf "$DOTFILES/cursor/settings.json"    "$cursor_target/settings.json"
    ln -sf "$DOTFILES/cursor/keybindings.json" "$cursor_target/keybindings.json"
  fi

  if [ "$SKIP_GHOSTTY" = false ]; then
    brew install --cask ghostty
    mkdir -p ~/.config/ghostty
    ln -sf "$DOTFILES/ghostty/config" ~/.config/ghostty/config
  fi
fi

# ── Linux ─────────────────────────────────────────────────────
if [ "$OS" = "Linux" ]; then
  # If /var/figure exists, move dotfiles there and symlink
  if [ -d /var/figure ] && [ ! -d /var/figure/dotfiles ]; then
    mv "$DOTFILES" /var/figure/dotfiles
    ln -sf /var/figure/dotfiles "$HOME/dotfiles"
    DOTFILES=/var/figure/dotfiles
  fi

  # Re-create symlinks with the (possibly updated) DOTFILES path
  ln -sf "$DOTFILES/zshrc"          ~/.zshrc
  ln -sf "$DOTFILES/zsh_aliases"    ~/.zsh_aliases
  ln -sf "$DOTFILES/shared_aliases" ~/.shared_aliases
  ln -sf "$DOTFILES/tmux.conf"      ~/.tmux.conf
  ln -sf "$DOTFILES/vimrc"          ~/.vimrc
  ln -sf "$DOTFILES/starship.toml"  ~/.config/starship.toml
  ln -sf "$DOTFILES/bat/config"     ~/.config/bat/config

  # Skip apt in devcontainer — custom.profile.sh handles it
  if [ "$NO_SUDO" = false ] && [ ! -f /.dockerenv ]; then
    sudo apt-get update -q
    sudo apt-get install -y zsh tmux bat ripgrep fzf xclip
  fi

  command -v starship &>/dev/null || \
    curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir ~/.local/bin

  command -v zoxide &>/dev/null || \
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

  if ! command -v fzf &>/dev/null; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --no-update-rc --key-bindings --completion
  fi

  # delta
  if ! command -v delta &>/dev/null; then
    curl -sSfL \
      "$(curl -sSf https://api.github.com/repos/dandavison/delta/releases/latest | grep -o 'https://[^"]*x86_64-unknown-linux-musl.tar.gz')" \
      | tar xz --strip-components=1 -C ~/.local/bin --wildcards '*/delta'
  fi

  # eza
  if ! command -v eza &>/dev/null; then
    curl -sS --location \
      https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-musl.tar.gz \
      | tar xz -C ~/.local/bin
  fi

  # ── Claude persistent data ──────────────────────────────────
  if [ -d /var/figure ]; then
    # Home-level ~/.claude (sessions, credentials, history)
    mkdir -p /var/figure/.claude
    if [ -d "$HOME/.claude" ] && [ ! -L "$HOME/.claude" ]; then
      # Merge existing contents then replace with symlink
      cp -a "$HOME/.claude/." /var/figure/.claude/ 2>/dev/null || true
      rm -rf "$HOME/.claude"
    fi
    ln -sfn /var/figure/.claude "$HOME/.claude"

    # Project-level .claude config — symlink all files from dotfiles/.claude/
    # into the project .claude/ dir (skills/ stays git-tracked, everything else from dotfiles)
    for PROJECT_CLAUDE in "$HOME/src/project-x/.claude" "/workspaces/project-x/.claude"; do
      if [ -d "$PROJECT_CLAUDE" ]; then
        for f in "$DOTFILES/.claude/"*; do
          name="$(basename "$f")"
          [ "$name" = "skills" ] && continue  # skills is git-tracked in project-x
          ln -sf "$f" "$PROJECT_CLAUDE/$name"
        done
      fi
    done

    # Persistent memory — Claude uses different project keys on host vs devcontainer
    # Both should point to the same persistent storage
    PERSISTENT_MEMORY="/var/figure/project-x/.claude/projects/-workspaces-project-x/memory"
    mkdir -p "$PERSISTENT_MEMORY"
    for PROJECT_KEY in "-workspaces-project-x" "-home-${USER}-src-project-x"; do
      PROJECT_MEMORY="$HOME/.claude/projects/${PROJECT_KEY}/memory"
      mkdir -p "$(dirname "$PROJECT_MEMORY")"
      if [ -d "$PROJECT_MEMORY" ] && [ ! -L "$PROJECT_MEMORY" ]; then
        cp -a "$PROJECT_MEMORY/." "$PERSISTENT_MEMORY/" 2>/dev/null || true
        rm -rf "$PROJECT_MEMORY"
      fi
      ln -sfn "$PERSISTENT_MEMORY" "$PROJECT_MEMORY"
    done
  fi

  # ── Devcontainer profiles ────────────────────────────────────
  if [ -d /var/figure ]; then
    cp "$DOTFILES/personal_profile.sh" /var/figure/.personal_profile.sh

    # Symlink custom.profile.sh to project-x devcontainer (gitignored, personal)
    local_devcontainer="$HOME/src/project-x/.devcontainer"
    if [ -d "$local_devcontainer" ]; then
      cp "$DOTFILES/custom.profile.sh" "$local_devcontainer/custom.profile.sh"
    fi
  fi
fi

# ── Set zsh as default ────────────────────────────────────────
if [ "$SKIP_CHSH" = false ] && [ "$SHELL" != "$(which zsh)" ] && command -v zsh &>/dev/null; then
  chsh -s "$(which zsh)"
fi

echo "==> Done. Restart your shell."
