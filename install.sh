#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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

# Linux only aliases
[ "$OS" = "Linux" ] && ln -sf "$DOTFILES/linux_aliases" ~/.linux_aliases

# ── Git config ────────────────────────────────────────────────
if [ ! -f ~/.gitconfig ]; then
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
  brew install starship zoxide fzf walk tmux eza
  brew install --cask font-jetbrains-mono-nerd-font

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

  if [ "$NO_SUDO" = false ]; then
    sudo apt-get update -q
    sudo apt-get install -y zsh tmux bat ripgrep fzf
  fi

  command -v starship &>/dev/null || \
    curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir ~/.local/bin

  command -v zoxide &>/dev/null || \
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

  if ! command -v fzf &>/dev/null; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --no-update-rc --key-bindings --completion
  fi

  # eza
  if ! command -v eza &>/dev/null; then
    curl -sS --location \
      https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-musl.tar.gz \
      | tar xz -C ~/.local/bin
  fi

  # ── Personal profile for devcontainer ────────────────────────
  if [ -d /var/figure ]; then
    cat > /var/figure/.personal_profile.sh << 'PROFILE'
# Only run once per session
[ -n "$PERSONAL_PROFILE_LOADED" ] && return
export PERSONAL_PROFILE_LOADED=1

# Clone dotfiles if not present
if [ ! -d /var/figure/dotfiles ]; then
  git clone --quiet https://github.com/tommasonovi/dotfiles.git /var/figure/dotfiles
fi

# Run install only if zoxide is missing
if ! command -v zoxide &>/dev/null; then
  bash /var/figure/dotfiles/install.sh --no-ghostty --no-chsh
fi
PROFILE
  fi
fi

# ── Set zsh as default ────────────────────────────────────────
if [ "$SKIP_CHSH" = false ] && [ "$SHELL" != "$(which zsh)" ] && command -v zsh &>/dev/null; then
  chsh -s "$(which zsh)"
fi

echo "==> Done. Restart your shell."
