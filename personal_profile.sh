#!/bin/bash
# Personal profile for devcontainer — sourced by custom.profile.sh
# This file is tracked in the dotfiles repo and copied to /var/figure/.personal_profile.sh

# Run install only once (not on every shell start)
if [ -z "$PERSONAL_PROFILE_LOADED" ]; then
  export PERSONAL_PROFILE_LOADED=1

  # Clone dotfiles if not present
  if [ ! -d /var/figure/dotfiles ]; then
    git clone --quiet https://github.com/tommasonovi/dotfiles.git /var/figure/dotfiles
  fi

  # Install tools to /var/figure/bin (persists across rebuilds)
  mkdir -p /var/figure/bin

  if [ ! -f /var/figure/bin/zoxide ]; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | \
      sh -s -- --bin-dir /var/figure/bin 2>&1 | tail -1
  fi

  if [ ! -f /var/figure/bin/eza ]; then
    curl -sSfL \
      https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-musl.tar.gz \
      | tar xz -C /var/figure/bin || echo "Warning: failed to install eza"
  fi

  if [ ! -f /var/figure/bin/bat ]; then
    curl -sSfL \
      https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-musl.tar.gz \
      | tar xz --strip-components=1 -C /var/figure/bin --wildcards '*/bat' || echo "Warning: failed to install bat"
  fi

  if [ ! -d ~/.fzf ]; then
    git clone --depth 1 --quiet https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --no-update-rc --key-bindings --completion --no-bash --no-fish >/dev/null
  fi

  if [ ! -f /var/figure/bin/starship ]; then
    curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir /var/figure/bin 2>&1 | tail -1
  fi

  # Run dotfiles install (creates symlinks, zsh plugins, etc.)
  if [ ! -f ~/.zshrc ] || [ ! -L ~/.zshrc ]; then
    /var/figure/dotfiles/install.sh --no-sudo --no-chsh --no-ghostty
  fi
fi

# Add /var/figure/bin to PATH
export PATH="/var/figure/bin:$PATH"

# Switch to zsh if not already in it
[ -z "$ZSH_VERSION" ] && [ -x /usr/bin/zsh ] && exec /usr/bin/zsh
