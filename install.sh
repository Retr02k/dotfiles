#!/bin/bash

echo "Setting up dotfiles..."

ln -sf ~/dotfiles/.nanorc ~/.nanorc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.zshrc ~/.zshrc

echo "Done!"
