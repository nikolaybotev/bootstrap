#!/bin/sh -e

# Check Preconditions
if [ "$(uname)" != 'Linux' ]; then echo "This script only runs on Linux."; exit 1; fi
if [ -d ~/.bootstrap ]; then echo "~/.bootstrap directory already exists."; exit 1; fi


# Clone Repository
echo "Getting code ..."
git clone https://github.com/nikolaybotevb/bootstrap.git ~/.bootstrap


# Write .vimrc
echo "Configuring vim ..."
cp ~/.bootstrap/.vimrc ~


# Install Pure Prompt
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"


# Configure zsh
echo "Configuring zsh ..."
cp ~/.bootstrap/.zshrc ~
[ -f "~/.bootstrap/$(uname).zshrc_local" ] && cp "~/.bootstrap/$(uname).zshrc_local" ~/.zshrc_local


# Install and Select zsh
sudo apt install zsh
chsh -s /bin/zsh]
