#!/bin/bash
# Copyright 2024 Figure AI, Inc

# ── Display ───────────────────────────────────────────────────
export DISPLAY=:1

# ── Git config ────────────────────────────────────────────────
export GIT_CONFIG_GLOBAL=/var/figure/.gitconfig

# ── Package installs ──────────────────────────────────────────
for PACKAGE in "bat" "ripgrep"; do
  dpkg -l | grep -qw "$PACKAGE" || sudo apt install -y "$PACKAGE"
done

# ── Personal setup ────────────────────────────────────────────
[ -f /var/figure/.personal_profile.sh ] && source /var/figure/.personal_profile.sh
