#!/bin/sh -e

# Check Preconditions
os="$(uname | awk -F_ '{print $1}')"
if [ "$os" != 'Darwin' -a "$os" != 'Linux' -a "$os" != "FreeBSD" -a "$os" != "CYGWIN" ]; then
  echo "This script only runs on macOS, Linux, Cygwin and FreeBSD."
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
[ -f ~/.vimrc ] && cp ~/.vimrc ~/.vimrc.backup
cp ~/.bootstrap/.vimrc ~


# Install Pure Prompt (does not work on Cygwin)
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"


# Configure zsh
echo "Configuring zsh ..."
[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.backup
cp ~/.bootstrap/.zshrc ~
[ -f ~/.zshrc_local ] && cp ~/.zshrc_local ~/.zshrc_local.backup
[ -f "${HOME}/.bootstrap/${os}.zshrc_local" ] && cp "${HOME}/.bootstrap/${os}.zshrc_local" ~/.zshrc_local


# Run OS-specific install
. "${HOME}/.bootstrap/install.${os}.sh"
