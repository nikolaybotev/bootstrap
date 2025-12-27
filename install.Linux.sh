#!/bin/sh -e

# Check Preconditions
if [ "$(uname)" != 'Linux' ]; then echo "This script only runs on Linux."; exit 1; fi


# Install and Select zsh (and prerequisites)
[ -f /usr/bin/yum ] && [ "$(whoami)" = "root" ] && yum install -y sudo
[ -f /usr/bin/yum ] && sudo yum install -y util-linux-user zsh git gnupg shadow
[ -f /usr/bin/apt-get ] && [ "$(whoami)" = "root" ] && apt-get update && apt-get install -y sudo
[ -f /usr/bin/apt-get ] && sudo apt-get update && sudo apt-get install -y zsh git gnupg shadow
[ -f /sbin/apk ] && [ "$(whoami)" = "root" ] && apk add --no-cache sudo
[ -f /sbin/apk ] && sudo apk add --no-cache zsh git gnupg shadow
sudo chsh -s /bin/zsh "${USER:-$(whoami)}"
