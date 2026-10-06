#!/bin/sh
set -eu
. "$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)/lib.sh"

echo "== fresh install with no ~/.zshrc =="
home=$(mktemp -d)
run_install "$home"
[ "$code" -eq 0 ] || fail "fresh: expected exit 0, got $code"
if grep -q 'Added sourcing of ~/.zshrc_common' "$log"; then
  fail "fresh: reported a prepend"
fi
assert_same "$src/.zshrc" "$home/.zshrc" "fresh: ~/.zshrc is not the template"
assert_same "$src/.zshrc_common" "$home/.zshrc_common" "fresh: ~/.zshrc_common mismatch"
assert_same "$src/.vimrc" "$home/.vimrc" "fresh: ~/.vimrc mismatch"
[ ! -e "$home/.zshrc.backup" ] || fail "fresh: unexpected ~/.zshrc.backup"
[ -d "$home/.zsh/pure/.git" ] || fail "fresh: pure prompt was not cloned"
shell=$(getent passwd tester | awk -F: '{print $NF}')
[ "$shell" = /bin/zsh ] || fail "fresh: login shell is $shell"
echo "PASS fresh install with no ~/.zshrc"
