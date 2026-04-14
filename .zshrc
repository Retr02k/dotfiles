# =========================================================
# OS DETECTION (macOS vs Linux)
# =========================================================
# We detect the OS so we can apply different configs when needed

OS="$(uname)"

if [[ "$OS" == "Darwin" ]]; then
  export PLATFORM="macos"
elif [[ "$OS" == "Linux" ]]; then
  export PLATFORM="linux"
fi


# =========================================================
# ⚡ POWERLEVEL10K INSTANT PROMPT (must stay near top)
# =========================================================
# Speeds up shell startup by preloading part of the prompt

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# =========================================================
# PATH CONFIGURATION (CROSS-PLATFORM SAFE)
# =========================================================

# Local user binaries (pipx, npm, etc.)
export PATH="$HOME/.local/bin:$PATH"

# macOS-specific paths
if [[ "$PLATFORM" == "macos" ]]; then
  export PATH="/usr/local/bin:$PATH"
fi

# (Optional) Linux-specific paths
if [[ "$PLATFORM" == "linux" ]]; then
  # Add anything specific to 42 machines here if needed
  :
fi


# =========================================================
# OH MY ZSH CONFIG
# =========================================================

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins (keep minimal for performance)
plugins=(git)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh


# =========================================================
# ENVIRONMENT VARIABLES
# =========================================================

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Default editor
export EDITOR=nano


# =========================================================
# ALIASES
# =========================================================

# Update dotfiles and reload shell
alias setup="cd ~/dotfiles && git pull && ./install.sh && source ~/.zshrc"


# =========================================================
# POWERLEVEL10K CONFIG
# =========================================================
# Load prompt config if it exists

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


# =========================================================
# ESP-IDF HELPER FUNCTION
# =========================================================
# Makes ESP-IDF easier to use

idf() {
  # Load ESP-IDF environment if not already loaded
  if [ -z "$IDF_PATH" ]; then
    . "$HOME/esp/esp-idf/export.sh"
  fi

  # Activate Python virtual environment if needed
  if [[ "$VIRTUAL_ENV" != "$HOME/esp/venv" ]]; then
    source "$HOME/esp/venv/bin/activate"
  fi

  # Run idf.py with all passed arguments
  idf.py "$@"
}


# =========================================================
# NODE / NVM SETUP (SAFE VERSION)
# =========================================================
# Only loads if NVM is installed

load_nvm() {
  export NVM_DIR="$HOME/.nvm"

  # Load nvm only if it exists
  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    . "$NVM_DIR/nvm.sh"
  fi
}


# =========================================================
# LAZY LOADING (SAFE VERSION)
# =========================================================
# Loads Node tools only when needed
# Prevents startup slowdown AND avoids crashes if not installed

lazy_load() {
  local cmd="$1"

  # Remove the function wrapper so next call is direct
  unset -f "$cmd"

  # Load Node environment
  load_nvm

  # Check if command exists before running it
  if command -v "$cmd" >/dev/null 2>&1; then
    "$cmd" "${@:2}"
  else
    echo "$cmd is not installed"
    return 127
  fi
}


# =========================================================
# LAZY-LOADED COMMANDS
# =========================================================
# Only define these if NVM exists

if [[ -d "$HOME/.nvm" ]]; then
  copilot() { lazy_load copilot "$@"; }
  node()    { lazy_load node "$@"; }
  npm()     { lazy_load npm "$@"; }
  npx()     { lazy_load npx "$@"; }
fi


# =========================================================
# OPTIONAL: PLATFORM-SPECIFIC FILES
# =========================================================
# Keeps your config clean and modular

if [[ "$PLATFORM" == "macos" && -f ~/.zshrc.macos ]]; then
  source ~/.zshrc.macos
fi

if [[ "$PLATFORM" == "linux" && -f ~/.zshrc.linux ]]; then
  source ~/.zshrc.linux
fi
