# ── PATH ──────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
command -v brew &>/dev/null && export PATH="/opt/homebrew/bin:$PATH"
[ -d /var/figure/bin ] && export PATH="/var/figure/bin:$PATH"

# ── Devcontainer profile ──────────────────────────────────────
# Source project profile directly for aliases/env (not load-profile.sh
# which re-runs custom.profile.sh apt installs on every shell).
# ── Completion ────────────────────────────────────────────────
[ -f ~/.zsh/git-completion.bash ] && \
  zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

# ── Devcontainer profile ──────────────────────────────────────
# Source after compinit/bashcompinit so bash completions register
_px_root="${PROJECT_X_ROOT:-/workspaces/project-x}"
if [ -f "$_px_root/.devcontainer/profile.sh" ]; then
  source "$_px_root/.devcontainer/profile.sh"
fi
unset _px_root

# ── History ───────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# ── Plugins ───────────────────────────────────────────────────
[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ── Bazel ──────────────────────────────────────────────────────
if command -v bazel &>/dev/null; then
  [ -f ~/.zsh/_bazel ] || { mkdir -p ~/.zsh && curl -sfo ~/.zsh/_bazel \
    https://raw.githubusercontent.com/bazelbuild/bazel/master/scripts/zsh_completion/_bazel; }
fi

# ── Zoxide ────────────────────────────────────────────────────
command -v zoxide &>/dev/null && eval "$(zoxide init --cmd cd zsh)"

# ── Starship ──────────────────────────────────────────────────
command -v starship &>/dev/null && eval "$(starship init zsh)"

# ── fzf ───────────────────────────────────────────────────────
[ -d ~/.fzf/bin ] && export PATH="$HOME/.fzf/bin:$PATH"
if [ -d ~/.fzf/shell ]; then
  source ~/.fzf/shell/key-bindings.zsh
  source ~/.fzf/shell/completion.zsh
elif [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ── Walk ──────────────────────────────────────────────────────
command -v walk &>/dev/null && function lk { cd "$(walk --icons "$@")" }

# ── Conda ────────────────────────────────────────────────────
[ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ] && \
  source "$HOME/miniconda3/etc/profile.d/conda.sh"

# ── Aliases ───────────────────────────────────────────────────
[ -f ~/.shared_aliases ] && source ~/.shared_aliases
[ -f ~/.zsh_aliases ]    && source ~/.zsh_aliases
[ -f ~/.linux_aliases ] && source ~/.linux_aliases

# ── Secrets ───────────────────────────────────────────────────
[ -f /var/figure/secrets.sh ] && source /var/figure/secrets.sh
[ -f ~/.secrets ]             && source ~/.secrets

# ── Git config ────────────────────────────────────────────────
# Ensure dotfiles gitconfig is included (devcontainer may have its own ~/.gitconfig)
if [ -f /var/figure/dotfiles/gitconfig ] && ! git config --global --get-all include.path 2>/dev/null | grep -q "/var/figure/dotfiles/gitconfig"; then
  git config --global --add include.path /var/figure/dotfiles/gitconfig
fi

# ── Local aliases (machine-specific, not in repo) ─────────────
[ -f ~/.local_aliases ] && source ~/.local_aliases

# ── Home / End (Cmd+Arrow via Ghostty keybinds) ─────────────
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# ── History search (must be last) ────────────────────────────
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search
