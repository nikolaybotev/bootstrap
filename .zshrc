# Options

setopt alwaystoend
setopt autopushd
setopt completeinword
setopt extendedhistory
setopt histexpiredupsfirst
setopt histignoredups
setopt histignorespace
setopt histverify
setopt interactivecomments
setopt longlistjobs
setopt promptsubst
setopt pushdignoredups
setopt pushdminus
setopt sharehistory


# History File and Size
HISTSIZE=500000
SAVEHIST=100000
HISTFILE=~/.zsh_history


# Up/Down Arrow History Search
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search              # macOS
bindkey "$terminfo[kcuu1]" up-line-or-beginning-search  # Linux
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search              # macOS
bindkey "$terminfo[kcud1]" down-line-or-beginning-search  # Linux


# Word Boundary
autoload -U select-word-style
select-word-style bash


# Autocomplete
autoload -U compinit && compinit


# Prompt
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure


# Colors for ls
[ -x /usr/bin/dircolors ] && eval $(/usr/bin/dircolors -b)


# Aliases and Functions

alias ls='ls --color -hF'
alias ll='ls -l'
alias la='ls -lA'
alias l='ls -la'

alias s='ssh -X'

# - Development (git, gradle etc)
export GPG_TTY=$(tty) # so that gpg can prompt for a password when invoked from git

alias gw='./gradlew'
alias g='git'

function gpo {
  git push 2>&1 | awk '{ print } $1 == "remote:" && $2 ~ /^https:\/\/.+\/new[?\/].*/ { system("open " $2) }'
}

function gpc {
  local mainBranch=ma$(git show-branch main > /dev/null 2>&1 && echo -n in || echo -n ster)
  git checkout $mainBranch
  git pull 2>&1 | awk '{ print } $2 == "[deleted]" { sub(/origin\//, "", $5); system("git branch -D " $5) }'
}

function gitlinesx {
  local ex="$1"
  shift
  git log --pretty=format:"%h,%an,%cd,%f" --date=iso-strict --numstat "$@" | grep -Ev "$ex" | awk '
    /^$/ { print ll "," ac "," rc; ll=""; next }
    ll == "" { ll = $0; ac = 0; rc = 0; next }
    ll != "" { ac = ac + $1; rc = rc + $2; }
    END { print ll "," ac "," rc }'
}

function gitlines {
  git log --pretty=format:"%h,%an,%cd,%f" --date=iso-strict --numstat "$@" | awk '
    /^$/ { print ll "," ac "," rc; ll=""; next }
    ll == "" { ll = $0; ac = 0; rc = 0; next }
    ll != "" { ac = ac + $1; rc = rc + $2; }
    END { print ll "," ac "," rc }'
}


# External Scripts
export PATH="$PATH:$HOME/.bootstrap/bin"


# Local commands
[ -f ~/.zshrc_local ] && . ~/.zshrc_local

