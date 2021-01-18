#!/bin/sh -e

# Check Preconditions
if [ "$(uname)" != 'Darwin' ]; then echo "This script only runs on macOS."; exit 1; fi
if [ -d ~/.bootstrap ]; then echo "~/.bootstrap directory already exists."; exit 1; fi


# Clone Repository
echo "Getting code ..."
git clone https://github.com/nikolaybotevb/bootstrap.git ~/.bootstrap


# Configure Terminal App
#defaults write com.apple.Terminal "Default Window Settings" Novel
#defaults write com.apple.Terminal "Startup Window Settings" Novel
plutil -replace "Default Window Settings" -string Novel ~/Library/Preferences/com.apple.Terminal.plist
plutil -replace "Startup Window Settings" -string Novel ~/Library/Preferences/com.apple.Terminal.plist
plutil -replace "Window Settings.Novel.shellExitAction" -integer 1 ~/Library/Preferences/com.apple.Terminal.plist
plutil -replace "Window Settings.Novel.useOptionAsMetaKey" -bool true ~/Library/Preferences/com.apple.Terminal.plist


# Configure macOS UI Preferences
# Dock etc system preferences
# https://github.com/zenangst/OSX-Configuration/blob/master/osx_bootstrap.sh
#
# dock auto-hide
defaults write com.apple.dock autohide -bool true
# tap to cliek
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
# app expose
defaults write com.apple.dock showAppExposeGestureEnabled -int 1
# keyboard repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# cursor size (cannot change here, do manually)
#defaults write com.apple.universalaccess mouseDriverCursorSize -float 1.5
# finder
defaults write com.apple.finder ShowPathbar -bool true


# Write .gitconfig and .gitignore
echo "Configuring git ..."
user_fullname="$(dscacheutil -q user -a name "$(whoami)" |awk '$1 == "gecos:" { print $2 " " $3 }')"
user_email="$(dscl . readpl "$HOME" dsAttrTypeNative:LinkedIdentity appleid.apple.com:linked\ identities:0:full\ name | awk '{print $4}')"
echo "Git Name: $user_fullname"
echo "Git E-mail: $user_email"
echo "Press return to continue . . ." && read
sed -e "s/_name_/${user_fullname}/g; s/_email_/${user_email}/g" ~/.bootstrap/.gitconfig > ~/.gitconfig
cp ~/.bootstrap/.gitignore ~


# Write .vimrc
echo "Configuring vim ..."
cp ~/.bootstrap/.vimrc ~


# Install Pure Prompt
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"


# Configure zsh
echo "Configuring zsh ..."
cp ~/.bootstrap/.aliases ~
echo "\nsource ~/.aliases" >> ~/.zshrc


# Open Websites for Tools to install manually
# - git graphical diff tools
open https://www.perforce.com/downloads/visual-merge-tool
open https://www.scootersoftware.com/download.php
# - standard tools: homebrew, jenv, fnm
open https://brew.sh
open http://www.jenv.be
open https://github.com/Schniz/fnm#installation

