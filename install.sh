#!/bin/bash

set -e

DOTFILES_DIR="$HOME/dotfiles"

echo "Setting up dotfiles..."

# =========================================================
# DIRECTORIES
# =========================================================

mkdir -p "$HOME/.nano/backups"
mkdir -p "$HOME/.tmux/plugins"
mkdir -p "$HOME/.config"

# =========================================================
# HELPER FUNCTION (safe symlink)
# =========================================================

link() {
  SRC="$1"
  DEST="$2"

  if [ -e "$DEST" ] || [ -L "$DEST" ]; then
    rm -rf "$DEST"
  fi

  ln -s "$SRC" "$DEST"
}

# =========================================================
# CORE SYMLINKS
# =========================================================

echo "Linking zsh..."
link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

echo "Linking tmux..."
link "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

echo "Linking nanorc..."
link "$DOTFILES_DIR/.nanorc" "$HOME/.nanorc"

echo "Linking neovim..."
link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# =========================================================
# TPM (Tmux Plugin Manager)
# =========================================================

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm \
    "$HOME/.tmux/plugins/tpm"
else
  echo "TPM already installed"
fi

echo "Dotfiles setup complete."
