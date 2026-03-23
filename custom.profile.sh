#!/bin/bash
# Copyright 2024 Figure AI, Inc

# ── Display ───────────────────────────────────────────────────
export DISPLAY=:1

# ── Git config ────────────────────────────────────────────────
export GIT_CONFIG_GLOBAL=/var/figure/.gitconfig

# Wait for apt lock to be released
while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
  sleep 1
done

sudo apt-get update -q
for PACKAGE in "bat" "ripgrep"; do
  dpkg -l | grep -qw "$PACKAGE" || sudo apt install -y "$PACKAGE" 2>/dev/null || true
done

# ── Personal setup ────────────────────────────────────────────
[ -f /var/figure/.personal_profile.sh ] && source /var/figure/.personal_profile.sh
