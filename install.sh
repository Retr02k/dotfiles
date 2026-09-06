#!/bin/bash

set -e

DOTFILES_DIR="$HOME/dotfiles"
BIN_DIR="$HOME/.local/bin"
OPT_DIR="$HOME/.local/opt"

echo "Setting up dotfiles..."

# =========================================================
# DIRECTORIES
# =========================================================

mkdir -p "$HOME/.nano/backups"
mkdir -p "$HOME/.tmux/plugins"
mkdir -p "$HOME/.config"
mkdir -p "$BIN_DIR"
mkdir -p "$OPT_DIR"

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
# NEOVIM (prebuilt binary, no sudo required)
# =========================================================

install_neovim() {
  local install_dir="$OPT_DIR/nvim"

  if [ -L "$BIN_DIR/nvim" ] && [ -e "$install_dir/bin/nvim" ]; then
    echo "Neovim already installed by this script, skipping."
    return
  fi

  local arch asset
  arch="$(uname -m)"
  case "$arch" in
    x86_64) asset="nvim-linux-x86_64.tar.gz" ;;
    aarch64|arm64) asset="nvim-linux-arm64.tar.gz" ;;
    *)
      echo "Unsupported architecture ($arch) for prebuilt Neovim, skipping."
      return
      ;;
  esac

  echo "Installing Neovim (latest stable, $arch)..."
  local tmp_tar
  tmp_tar="$(mktemp)"
  curl -fL "https://github.com/neovim/neovim/releases/latest/download/$asset" -o "$tmp_tar"

  rm -rf "$install_dir"
  mkdir -p "$install_dir"
  tar -xzf "$tmp_tar" -C "$install_dir" --strip-components=1
  rm -f "$tmp_tar"

  ln -sf "$install_dir/bin/nvim" "$BIN_DIR/nvim"
  echo "Neovim installed to $install_dir (symlinked at $BIN_DIR/nvim)"
}

# =========================================================
# OH-MY-ZSH (installed without sudo, keeps existing .zshrc)
# =========================================================

install_oh_my_zsh() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh already installed, skipping."
    return
  fi

  if ! command -v zsh >/dev/null 2>&1; then
    echo "zsh is not installed and this script cannot install it without sudo."
    echo "Ask an admin to install zsh, or install it yourself where you have privileges."
    return
  fi

  echo "Installing oh-my-zsh..."
  # RUNZSH=no  -> don't launch zsh at the end of the installer
  # CHSH=no    -> don't try to change the default shell (needs privileges we may not have)
  # KEEP_ZSHRC=yes -> never let the installer touch/overwrite an existing .zshrc
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# =========================================================
# POWERLEVEL10K
# =========================================================

install_powerlevel10k() {
  local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  local p10k_dir="$zsh_custom/themes/powerlevel10k"

  if [ -d "$p10k_dir" ]; then
    echo "Powerlevel10k already installed, skipping."
    return
  fi

  echo "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
}

# =========================================================
# NERD FONT (MesloLGS NF, recommended by Powerlevel10k)
# Installed to a user-local font dir, no sudo required.
# You still need to manually select this font in your
# terminal emulator's preferences on each machine.
# =========================================================

install_nerd_font() {
  local font_dir="$HOME/.local/share/fonts"

  if command -v fc-list >/dev/null 2>&1 && fc-list 2>/dev/null | grep -qi "MesloLGS NF"; then
    echo "MesloLGS Nerd Font already installed, skipping."
    return
  fi

  echo "Installing MesloLGS Nerd Font..."
  mkdir -p "$font_dir"
  local base_url="https://github.com/romkatv/powerlevel10k-media/raw/master"
  curl -fLo "$font_dir/MesloLGS NF Regular.ttf" "$base_url/MesloLGS%20NF%20Regular.ttf"
  curl -fLo "$font_dir/MesloLGS NF Bold.ttf" "$base_url/MesloLGS%20NF%20Bold.ttf"
  curl -fLo "$font_dir/MesloLGS NF Italic.ttf" "$base_url/MesloLGS%20NF%20Italic.ttf"
  curl -fLo "$font_dir/MesloLGS NF Bold Italic.ttf" "$base_url/MesloLGS%20NF%20Bold%20Italic.ttf"

  if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "$font_dir" >/dev/null 2>&1 || true
  fi
}

# =========================================================
# RUN INSTALLERS
# =========================================================

install_neovim
install_oh_my_zsh
install_powerlevel10k
install_nerd_font

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
echo
echo "Reminders:"
echo "  - Make sure your .zshrc (in $DOTFILES_DIR) has:"
echo "      export PATH=\"$BIN_DIR:\$PATH\""
echo "    so the Neovim installed by this script is the one that runs."
echo "  - Your .zshrc also needs: ZSH_THEME=\"powerlevel10k/powerlevel10k\""
echo "  - Set your terminal emulator's font to 'MesloLGS NF' to see Powerlevel10k icons correctly."
echo "  - If zsh isn't your default shell yet and you have no sudo, run 'zsh' manually or ask an admin to run chsh for you."
