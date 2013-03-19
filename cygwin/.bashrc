# base-files version 3.9-3

# To pick up the latest recommended .bashrc content,
# look in /etc/defaults/etc/skel/.bashrc

# Environment Variables
# #####################

export DISPLAY=:0.0

export PATH="$HOME/bin:$PATH"

export JAVA_HOME=/programs/jdk1.7.0
export PATH=${JAVA_HOME}/bin:$PATH

export GRADLE_HOME=/programs/gradle-1.3
export PATH=${GRADLE_HOME}/bin:$PATH


# TMP and TEMP are defined in the Windows environment.  Leaving
# them set to the default Windows temporary directory can have
# unexpected consequences.
unset TMP
unset TEMP


# Shell Options
# #############

# Make bash append rather than overwrite the history on disk
shopt -s histappend


# Completion options
# ##################

# If this shell is interactive, turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
case $- in
  *i*) [[ -f /etc/bash_completion ]] && . /etc/bash_completion ;;
esac


# History Options
# ###############

# Don't put duplicate lines in the history.
export HISTCONTROL="ignoredups"


# Aliases
# #######

# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias l='ls -CFhl'                              #

alias s='ssh -X'

alias mklink='cmd.exe /c mklink'

