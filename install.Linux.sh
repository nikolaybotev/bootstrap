#!/bin/sh -e

# Check Preconditions
if [ "$(uname)" != 'Linux' ]; then echo "This script only runs on Linux."; exit 1; fi


# Install and Select zsh
sudo apt install zsh
chsh -s /bin/zsh
