#!/bin/sh
set -e

# Check Preconditions
os="$(uname | awk -F_ '{print $1}')"
if [ "$os" != 'Darwin' -a "$os" != 'Linux' -a "$os" != "FreeBSD" -a "$os" != "CYGWIN" ]; then
  echo "This script only runs on macOS, Linux, Cygwin and FreeBSD."
  echo "$os detected."
  exit 1
fi
if [ -d ~/.bootstrap ]; then
  echo "This script appears to be already installed."
  echo "~/.bootstrap directory already exists."
  exit 1
fi
if [ -f ~/.zshrc_common ]; then
  echo "This script appears to be already installed."
  echo "~/.zshrc_common already exists."
  exit 1
fi
# Active line that dot-sources or `source`s .zshrc_common. Full-line comments do not count.
common_source_re='(^|[[:space:];&|])(\.|source)[[:space:]]+[^#[:space:]]*\.zshrc_common["'\'']?(\r?$|[[:space:];&|)])'
if [ -f ~/.zshrc ] && grep -E -v '^[[:space:]]*#' ~/.zshrc | grep -E -q "$common_source_re"; then
  echo "This script appears to be already installed."
  echo "~/.zshrc already sources ~/.zshrc_common."
  exit 1
fi

if [ "$os" = Darwin ] && ! xcode-select -p >/dev/null 2>&1; then
  echo "Xcode Command Line Tools are required for git."
  echo "Requesting Xcode Command Line Tools installation..."
  xcode-select --install
  printf "Press return once Xcode Command Line Tools installation has completed."
  read -r _
fi

if ! git --version >/dev/null 2>&1; then
  echo "error: git is not available." >&2
  exit 1
fi
if ! curl --version >/dev/null 2>&1; then
  echo "error: curl is not available." >&2
  exit 1
fi


# Clone, then confirm the checked-out commit exists in that GitHub repository.
# Git config (insteadOf, proxy, CA) still applies to the clone. curl does not
# read it, so a rewrite that checks out some other commit fails here.
# Called as `clone_verified || ...` so set -e is off; every step is checked.
remove_failed_clone() {
  case $1 in
    "$HOME"/.bootstrap|"$HOME"/.zsh/pure) rm -rf "$1" ;;
    *)
      echo "error: refusing to remove ${1}." >&2
      ;;
  esac
}

clone_verified() {
  url=$1
  dest=$2
  case $url in
    https://github.com/*/*.git) ;;
    *)
      echo "error: refusing to clone unexpected URL: $url" >&2
      return 1
      ;;
  esac
  repo=${url#https://github.com/}
  repo=${repo%.git}

  if ! git clone "$url" "$dest"; then
    return 1
  fi
  if ! sha=$(git -C "$dest" rev-parse HEAD); then
    remove_failed_clone "$dest"
    return 1
  fi
  if ! got=$(curl -fsSL -H "Accept: application/vnd.github.sha" \
      "https://api.github.com/repos/${repo}/commits/${sha}"); then
    echo "error: could not verify ${sha} against https://github.com/${repo}." >&2
    remove_failed_clone "$dest"
    return 1
  fi
  got=$(printf '%s' "$got" | tr -d '[:space:]')
  if [ "$got" != "$sha" ]; then
    echo "error: GitHub reported ${got} for https://github.com/${repo}, which checked out ${sha}." >&2
    remove_failed_clone "$dest"
    return 1
  fi
}

echo "Getting code ..."
clone_verified https://github.com/nikolaybotev/bootstrap.git "$HOME/.bootstrap" || exit 1

mkdir -p "$HOME/.zsh"
if ! clone_verified https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"; then
  remove_failed_clone "$HOME/.bootstrap"
  rmdir "$HOME/.zsh" 2>/dev/null || true
  exit 1
fi


# Write .vimrc
echo "Configuring vim ..."
[ -f ~/.vimrc ] && cp ~/.vimrc ~/.vimrc.backup
cp ~/.bootstrap/.vimrc ~


# Configure zsh
echo "Configuring zsh ..."
cp ~/.bootstrap/.zshrc_common ~
if [ -f ~/.zshrc ]; then
  zshrc_tmp="$(mktemp "${TMPDIR:-/tmp}/zshrc.XXXXXX")"
  cat ~/.bootstrap/.zshrc ~/.zshrc > "$zshrc_tmp"
  cp ~/.zshrc ~/.zshrc.backup
  mv "$zshrc_tmp" ~/.zshrc
  echo "Added sourcing of ~/.zshrc_common at the top of ~/.zshrc."
  echo "Previous ~/.zshrc saved as ~/.zshrc.backup."
else
  cp ~/.bootstrap/.zshrc ~
fi
[ -f ~/.zshrc_local ] && cp ~/.zshrc_local ~/.zshrc_local.backup
[ -f "${HOME}/.bootstrap/${os}.zshrc_local" ] && cp "${HOME}/.bootstrap/${os}.zshrc_local" ~/.zshrc_local


# Run OS-specific install
. "${HOME}/.bootstrap/install.${os}.sh"
