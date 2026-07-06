# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =========================================================
# OS DETECTION
# =========================================================

OS="$(uname)"

if [[ "$OS" == "Darwin" ]]; then
  export PLATFORM="macos"
elif [[ "$OS" == "Linux" ]]; then
  export PLATFORM="linux"
fi

# =========================================================
# NODE (NVM - CLEAN AND SINGLE SOURCE OF TRUTH)
# =========================================================

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

nvm use default >/dev/null 2>&1

# =========================================================
# PATH
# =========================================================

export PATH="$HOME/.local/bin:$PATH"

if [[ "$PLATFORM" == "macos" ]]; then
  export PATH="/usr/local/bin:$PATH"
fi

# =========================================================
# OH MY ZSH
# =========================================================

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# =========================================================
# ENVIRONMENT
# =========================================================

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export EDITOR="nvim"
export VISUAL="nvim"

# =========================================================
# ALIASES
# =========================================================

alias setup="cd ~/dotfiles && git pull && ./install.sh && source ~/.zshrc"

# =========================================================
# POWERLEVEL10K
# =========================================================

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# =========================================================
# ESP-IDF
# =========================================================

idf() {
  if [ -z "$IDF_PATH" ]; then
    . "$HOME/esp/esp-idf/export.sh"
  fi

  if [[ "$VIRTUAL_ENV" != "$HOME/esp/venv" ]]; then
    source "$HOME/esp/venv/bin/activate"
  fi

  idf.py "$@"
}

# =========================================================
# OPTIONAL PLATFORM FILES
# =========================================================

if [[ "$PLATFORM" == "macos" && -f ~/.zshrc.macos ]]; then
  source ~/.zshrc.macos
fi

if [[ "$PLATFORM" == "linux" && -f ~/.zshrc.linux ]]; then
  source ~/.zshrc.linux
fi

# =========================================================
# 42 ENVIRONMENT
# =========================================================

export UV_CACHE_DIR=/goinfre/$USER/.cache/uv
export XDG_CACHE_HOME=/goinfre/$USER/.cache
export TMPDIR=/goinfre/$USER/tmp
export UV_PROJECT_ENVIRONMENT=/goinfre/$USER/venv-callme
export LS_COLORS='di=1;36:fi=0:ln=1;35:ex=1;32:or=1;31:mi=0;31:pi=1;33:so=1;33:bd=1;33:cd=1;33'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
