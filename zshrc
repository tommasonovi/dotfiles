# Up arrow to search history with partial match
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# Add Homebrew to PATH
export PATH="/opt/homebrew/bin:$PATH"

# Load Git completion
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)
autoload -Uz compinit && compinit

# Load Autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Zoxide setup
command -v zoxide &>/dev/null && eval "$(zoxide init --cmd cd zsh)"

# Starship setup
eval "$(starship init zsh)"

# fzf keybindings
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/zsh-completion/completions/fzf ] && source /usr/share/zsh-completion/completions/fzf

# Walk
function lk {
  cd "$(walk --icons "$@")"
}

# Aliases
[ -f ~/.shared_aliases ] && source ~/.shared_aliases
[ -f ~/.zsh_aliases ]    && source ~/.zsh_aliases

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/tommaso/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/tommaso/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/tommaso/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/tommaso/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/.local/bin:$PATH"
