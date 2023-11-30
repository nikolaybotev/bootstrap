#!/bin/sh -e

# Check Preconditions
os="$(uname)"
if [ "$os" != 'Darwin' -a "$os" != 'Linux' -a "$os" != "FreeBSD" ]; then
  echo "This script only runs on macOS, Linux and FreeBSD."
  echo "$os detected."
  exit 1
fi
if [ -d ~/.bootstrap ]; then
  echo "This script appears to be already installed."
  echo "~/.bootstrap directory already exists."
  exit 1
fi


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
[ -f "${HOME}/.bootstrap/${os}.zshrc_local" ] && cp "${HOME}/.bootstrap/${os}.zshrc_local" ~/.zshrc_local


# Run OS-specific install
. "${HOME}/.bootstrap/install.${os}.sh"
