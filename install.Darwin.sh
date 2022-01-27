#!/bin/sh -e

# Check Preconditions
if [ "$(uname)" != 'Darwin' ]; then echo "This script only runs on macOS."; exit 1; fi


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
user_fullname="$(id -F)"
user_email="$(defaults read MobileMeAccounts | plutil -convert json -o - - | python -c 'import json, sys; print(json.load(sys.stdin)["Accounts"][0]["AccountID"])')"
echo "Git Name: $user_fullname"
echo "Git E-mail: $user_email"
echo "Press return to continue . . ." && read
sed -e "s/_name_/${user_fullname}/g; s/_email_/${user_email}/g" ~/.bootstrap/.gitconfig > ~/.gitconfig
cp ~/.bootstrap/.gitignore ~


# Open Websites for Tools to install manually
# - git graphical diff tools
open https://www.perforce.com/downloads/visual-merge-tool
open https://www.scootersoftware.com/download.php
# - standard tools: homebrew, jenv, fnm
open https://brew.sh
open http://www.jenv.be
open https://github.com/Schniz/fnm#installation

