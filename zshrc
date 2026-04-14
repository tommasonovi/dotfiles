# ── Terminal ──────────────────────────────────────────────────
export COLORTERM=truecolor
export EDITOR=nvim
export VISUAL=nvim

# ── PATH ──────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
command -v brew &>/dev/null && export PATH="/opt/homebrew/bin:$PATH"

# ── Completion ────────────────────────────────────────────────
[ -f ~/.zsh/git-completion.bash ] && \
  zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

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

# ── Zoxide ────────────────────────────────────────────────────
command -v zoxide &>/dev/null && eval "$(zoxide init --cmd cd zsh)"

# ── Starship ──────────────────────────────────────────────────
command -v starship &>/dev/null && eval "$(starship init zsh)"

# ── fzf ───────────────────────────────────────────────────────
[ -d ~/.fzf/bin ] && export PATH="$HOME/.fzf/bin:$PATH"
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
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
[ -f ~/.linux_aliases ]  && source ~/.linux_aliases

# ── Secrets ───────────────────────────────────────────────────
[ -f ~/.secrets ] && source ~/.secrets

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

# ── Private overlay (company/personal config) ────────────────
[ -f ~/.zshrc.private ] && source ~/.zshrc.private
