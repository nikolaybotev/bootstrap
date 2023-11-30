#!/bin/sh -e

# Check Preconditions
if [ "$(uname)" != 'FreeBSD' ]; then echo "This script only runs on FreeBSD."; exit 1; fi


# Install and Select zsh
sudo pkg install zsh
sudo chsh -s /usr/local/bin/zsh "$USER"
