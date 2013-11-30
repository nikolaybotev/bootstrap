[ -r ~/.profile ] && . ~/.profile

export JAVA_HOME=~/Library/Java/jdk6/Contents/Home
export PATH=${JAVA_HOME}/bin:$PATH

export ANT_HOME=/usr/share/ant

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return


# Shell Options
# #############

# Make bash append rather than overwrite the history on disk
shopt -s histappend


# Completion options
# ##################

[ -d "$ANT_HOME" ] && complete -C $ANT_HOME/bin/complete-ant-cmd.pl ant
[ -f ~/bin/git-completion.bash ] || (mkdir -p ~/bin && /usr/bin/curl -s https://raw.github.com/git/git/master/contrib/completion/git-completion.bash > ~/bin/git-completion.bash)
. ~/bin/git-completion.bash


# History Options
# ###############

# Don't put duplicate lines in the history.
export HISTCONTROL="ignoredups"


# Aliases
# #######

# Some shortcuts for different directory listings
alias ls='ls -hF'                 # classify files in colour
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias l='ls -CFhl'                              #

alias s='ssh -X'

