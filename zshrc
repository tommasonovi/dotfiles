# ── PATH ──────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
command -v brew &>/dev/null && export PATH="/opt/homebrew/bin:$PATH"
[ -d /var/figure/bin ] && export PATH="/var/figure/bin:$PATH"

# ── Devcontainer profile ──────────────────────────────────────
# Source project profile directly for aliases/env (not load-profile.sh
# which re-runs custom.profile.sh apt installs on every shell).
_px_root="${PROJECT_X_ROOT:-/workspaces/project-x}"
if [ -f "$_px_root/.devcontainer/profile.sh" ]; then
  autoload -Uz bashcompinit && bashcompinit
  source "$_px_root/.devcontainer/profile.sh"
fi
unset _px_root

# ── Completion ────────────────────────────────────────────────
[ -f ~/.zsh/git-completion.bash ] && \
  zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)
autoload -Uz compinit && compinit

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

# ── Zoxide ────────────────────────────────────────────────────
command -v zoxide &>/dev/null && eval "$(zoxide init --cmd cd zsh)"

# ── Starship ──────────────────────────────────────────────────
command -v starship &>/dev/null && eval "$(starship init zsh)"

# ── fzf ───────────────────────────────────────────────────────
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && \
  source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f ~/.fzf/shell/key-bindings.zsh ] && source ~/.fzf/shell/key-bindings.zsh
[ -f ~/.fzf/shell/completion.zsh ] && source ~/.fzf/shell/completion.zsh
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
# Only use /var/figure/.gitconfig in devcontainer
[ -f /.dockerenv ] && [ -f /var/figure/.gitconfig ] && export GIT_CONFIG_GLOBAL=/var/figure/.gitconfig

# ── Local aliases (machine-specific, not in repo) ─────────────
[ -f ~/.local_aliases ] && source ~/.local_aliases

# ── History search (must be last) ────────────────────────────
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
