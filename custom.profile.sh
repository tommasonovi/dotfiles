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

# ── Project aliases ───────────────────────────────────────────
alias helm_cli='unset ROBOT_UID && export TERM=xterm-256color && bazel run //apps/helm_app/helm_cli'
alias log_server='bazel run //apps/log_server -- --log_dir=/workspaces/project-x/sim_logs --noenable_auto_upload'

# ── Personal setup (no-op if file doesn't exist) ──────────────
[ -f /var/figure/.personal_profile.sh ] && source /var/figure/.personal_profile.sh
