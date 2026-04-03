#!/bin/bash
# Claude Code status line — cwd, branch, model, context %

input=$(cat)

cwd=$(echo "$input" | jq -r '.cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Git branch
branch=""
if [ -n "$cwd" ] && command -v git >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
fi

parts=()

[ -n "$cwd" ]    && parts+=("$(printf '\033[34m%s\033[0m' "$cwd")")
[ -n "$branch" ] && parts+=("$(printf '\033[33m\ue0a0 %s\033[0m' "$branch")")
[ -n "$model" ]  && parts+=("$(printf '\033[90m%s\033[0m' "$model")")

if [ -n "$used_pct" ]; then
  used_int=$(printf '%.0f' "$used_pct")
  if   [ "$used_int" -ge 80 ]; then color='\033[31m'
  elif [ "$used_int" -ge 50 ]; then color='\033[33m'
  else                               color='\033[32m'
  fi
  parts+=("$(printf "${color}ctx:%s%%\033[0m" "$used_int")")
fi

printf '%s' "${parts[0]}"
for part in "${parts[@]:1}"; do
  printf ' \033[90m|\033[0m %s' "$part"
done
printf '\n'
