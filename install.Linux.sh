#!/bin/sh -e

# Check Preconditions
if [ "$(uname)" != 'Linux' ]; then echo "This script only runs on Linux."; exit 1; fi


# Install and Select zsh
[ -f /usr/bin/yum ] && sudo yum install util-linux-user zsh
[ -f /usr/bin/apt ] && sudo apt install zsh
sudo chsh -s /bin/zsh "$USER"
