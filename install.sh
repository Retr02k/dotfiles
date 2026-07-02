#!/bin/bash

set -e

DOTFILES_DIR="$HOME/dotfiles"

echo "Setting up dotfiles..."

# =========================================================
# DIRECTORIES
# =========================================================

mkdir -p "$HOME/.nano/backups"
mkdir -p "$HOME/.tmux/plugins"

# =========================================================
# SYMLINKS
# =========================================================

ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/.nanorc" "$HOME/.nanorc"

mkdir -p "$HOME/.var/app/io.neovim.nvim/config"
ln -sfn "$DOTFILES_DIR/nvim" \
  "$HOME/.var/app/io.neovim.nvim/config/nvim"

# =========================================================
# TPM
# =========================================================

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# =========================================================
# FLATPAK NEOVIM CONFIG
# =========================================================

if command -v flatpak >/dev/null 2>&1; then
  echo "Configuring Flatpak Neovim..."

  flatpak override --user io.neovim.nvim \
    --env=PATH="/home/psilva-p/.nvm/versions/node/v24.18.0/bin:/home/psilva-p/.npm-global/bin:/app/bin:/usr/bin"
fi

echo "Dotfiles setup complete."
