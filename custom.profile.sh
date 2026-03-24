#!/bin/bash
# Copyright 2024 Figure AI, Inc

# ── Display ───────────────────────────────────────────────────
export DISPLAY=:1

# ── Git config ────────────────────────────────────────────────
export GIT_CONFIG_GLOBAL=/var/figure/.gitconfig

# Wait for apt lock to be released
for lock in /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock /var/cache/apt/archives/lock; do
  while sudo fuser "$lock" >/dev/null 2>&1; do sleep 1; done
done

sudo apt-get update -q
for PACKAGE in "bat" "ripgrep"; do
  dpkg -l | grep -qw "$PACKAGE" || sudo apt install -y "$PACKAGE" 2>/dev/null || true
done

# ── Personal setup ────────────────────────────────────────────
[ -f /var/figure/.personal_profile.sh ] && source /var/figure/.personal_profile.sh
