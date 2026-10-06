#!/bin/sh
set -eu
. "$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)/lib.sh"

echo "== refuse a bootstrap commit that is not on GitHub =="
git -C "$snapshot" \
  -c user.email=tester@example.com \
  -c user.name='Bootstrap Test' \
  commit -q --allow-empty -m 'commit that is not on GitHub'
home=$(mktemp -d)
run_install "$home"
[ "$code" -eq 1 ] || fail "unknown commit: expected exit 1, got $code"
grep -q 'could not verify' "$log" || fail "unknown commit: missing message"
[ ! -d "$home/.bootstrap" ] || fail "unknown commit: left ~/.bootstrap"
[ ! -e "$home/.vimrc" ] || fail "unknown commit: wrote ~/.vimrc"
[ ! -e "$home/.zshrc" ] || fail "unknown commit: wrote ~/.zshrc"
[ ! -e "$home/.zshrc_common" ] || fail "unknown commit: wrote ~/.zshrc_common"
[ ! -e "$home/.zsh" ] || fail "unknown commit: created ~/.zsh"
shell=$(getent passwd tester | awk -F: '{print $NF}')
[ "$shell" = /bin/bash ] || fail "unknown commit: login shell is $shell"
echo "PASS refuse a bootstrap commit that is not on GitHub"
