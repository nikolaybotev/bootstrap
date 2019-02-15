#!/bin/sh -e


# Preconditions
if [ "$(uname)" != 'Darwin' ]; then echo "This script only runs on macOS."; exit 1; fi
if [ -d ~/.bootstrap ]; then echo "~/.bootstrap directory already exists."; exit 1; fi


# get repo
git clone https://github.com/nikolaybotevb/bootstrap.git ~/.bootstrap


# git config
user_fullname="$(dscacheutil -q user -a name "$(whoami)" |awk '$1 == "gecos:" { print $2 " " $3 }')"
user_email="$(dscl . readpl "$HOME" dsAttrTypeNative:LinkedIdentity appleid.apple.com:linked\ identities:0:full\ name | awk '{print $4}')"
echo "Git Name: $user_fullname"
echo "Git E-mail: $user_email"
print -n "Press return to continue . . ." && read
sed -e "s/_name_/${user_fullname}/g; s/_email_/${user_email}/g" ~/.bootstrap/.gitconfig > ~/.gitconfig
cp ~/.bootstrap/.gitignore ~


# .vimrc
cp ~/.bootstrap/.vimrc ~


# zsh (https://ohmyz.sh)
cp ~/.bootstrap/.aliases ~
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sed -i "" -e "s/^# CASE_SENSITIVE=/CASE_SENSITIVE=/" ~/.zshrc
sed -i "" -e "s/^# DISABLE_UNTRACKED_FILES_DIRTY=/DISABLE_UNTRACKED_FILES_DIRTY=/" ~/.zshrc
echo "\nsource ~/.aliases" >> ~/.zshrc


# git graphical diff tools
open https://sourceforge.net/projects/kdiff3/files/
open https://www.perforce.com/downloads/visual-merge-tool
open https://www.scootersoftware.com/download.php


# other standard tools to install manually: macports, homebrew, jenv, nvm
open https://www.macports.org/install.php
open https://brew.sh
open http://www.jenv.be
oepn https://github.com/creationix/nvm#installation


# cloud tools: gcloud, aws
open https://cloud.google.com/sdk/docs/quickstart-macos
open https://aws.amazon.com/cli/

