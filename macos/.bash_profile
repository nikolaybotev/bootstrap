#!/bin/bash

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return


# Shell Options
# #############

# Make bash append rather than overwrite the history on disk
shopt -s histappend


# Completion options
# ##################

if [ -x /usr/local/bin/brew ] && [ -f $(/usr/local/bin/brew --prefix)/etc/bash_completion ]; then
    . $(/usr/local/bin/brew --prefix)/etc/bash_completion
fi


# Git
# ###

if [ "$(type -t __git_ps1)" = "function" ]; then
  GIT_PS1_SHOWDIRTYSTATE=true
  export PS1=$'\\[\e[93m\\]\xe2\x9a\xa1\\[\e[0m\\] \w\\[\e[32m\\]$(__git_ps1)\\[\e[0m\\]\$ '
fi


# History Options
# ###############

# Don't put duplicate lines in the history.
export HISTCONTROL="ignoredups"


# Aliases
# #######

# Some shortcuts for different directory listings
alias ls='ls -hFG'                # classify files in colour
alias ll='ls -l'                  # long list
alias la='ls -A'                  # all but . and ..
alias l='ls -CFhl'                #

alias s='ssh -X'

