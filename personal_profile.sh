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
      ZOXIDE_INSTALL_DIR=/var/figure/bin sh
  fi

  if [ ! -f /var/figure/bin/eza ]; then
    curl -sS --location \
      https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-musl.tar.gz \
      | tar xz -C /var/figure/bin
  fi

  if [ ! -f /var/figure/bin/bat ]; then
    curl -sS --location \
      https://github.com/sharkdp/bat/releases/latest/download/bat-v0.24.0-x86_64-unknown-linux-musl.tar.gz \
      | tar xz --strip-components=1 -C /var/figure/bin --wildcards '*/bat'
  fi

  # Run dotfiles install (creates symlinks, zsh plugins, etc.)
  if [ ! -f ~/.zshrc ] || [ ! -L ~/.zshrc ]; then
    /var/figure/dotfiles/install.sh --no-sudo --no-chsh --no-ghostty
  fi
fi

# Add /var/figure/bin to PATH
export PATH="/var/figure/bin:$PATH"

# Always switch to zsh if not already in it
[ "$0" != "zsh" ] && [ -x /usr/bin/zsh ] && PERSONAL_PROFILE_LOADED=1 exec /usr/bin/zsh
