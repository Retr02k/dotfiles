# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# =========================================================
# CACHE ENVIRONMENT
# =========================================================

if [[ -d "/goinfre/$USER" ]]; then
  export XDG_CACHE_HOME="/goinfre/$USER/.cache"
  export TMPDIR="/goinfre/$USER/tmp"
  export UV_PROJECT_ENVIRONMENT="/goinfre/$USER/venv-callme"
else
  export XDG_CACHE_HOME="$HOME/.cache"
  export TMPDIR="/tmp"
fi

export UV_CACHE_DIR="$XDG_CACHE_HOME/uv"

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =========================================================
# PATH
# =========================================================

export PATH="$HOME/.local/bin:$PATH"

# =========================================================
# OH MY ZSH
# =========================================================

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)

source "$ZSH/oh-my-zsh.sh"

# =========================================================
# ENVIRONMENT
# =========================================================

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export EDITOR="nvim"
export VISUAL="nvim"

# =========================================================
# ALIASES
# =========================================================

alias setup="cd ~/dotfiles && git pull && ./install.sh && exec zsh"

# =========================================================
# POWERLEVEL10K
# =========================================================

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# =========================================================
# TERMINAL COLORS / COMPLETION
# =========================================================

export LS_COLORS='di=1;36:fi=0:ln=1;35:ex=1;32:or=1;31:mi=0;31:pi=1;33:so=1;33:bd=1;33:cd=1;33'

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
