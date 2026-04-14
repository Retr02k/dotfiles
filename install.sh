#!/bin/bash

set -e  # stop script on error

echo "Setting up dotfiles..."

DOTFILES_DIR="$HOME/dotfiles"

# =========================================================
# SYMLINK FILES
# =========================================================

echo "Creating symlinks..."

ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/.nanorc" "$HOME/.nanorc"

# =========================================================
# CREATE REQUIRED DIRECTORIES
# =========================================================

echo "Creating required directories..."

mkdir -p "$HOME/.nano/backups"
mkdir -p "$HOME/.tmux/plugins"

# =========================================================
# INSTALL TPM (Tmux Plugin Manager) IF MISSING
# =========================================================

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# =========================================================
# DONE
# =========================================================

echo "Dotfiles setup complete!"
