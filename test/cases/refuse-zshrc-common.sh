#!/bin/sh
set -eu
. "$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)/lib.sh"

echo "== refuse when ~/.zshrc_common already exists =="
home=$(mktemp -d)
printf '%s\n' 'export BOOTSTRAP_TEST_MARKER=original' > "$home/.zshrc"
printf '%s\n' 'original common' > "$home/.zshrc_common"
saved_rc=$(mktemp)
saved_common=$(mktemp)
cp "$home/.zshrc" "$saved_rc"
cp "$home/.zshrc_common" "$saved_common"
run_install "$home"
[ "$code" -eq 1 ] || fail "common file: expected exit 1, got $code"
grep -q '~/.zshrc_common already exists.' "$log" || fail "common file: missing message"
assert_same "$saved_rc" "$home/.zshrc" "common file: ~/.zshrc changed"
assert_same "$saved_common" "$home/.zshrc_common" "common file: ~/.zshrc_common changed"
[ ! -d "$home/.bootstrap" ] || fail "common file: created ~/.bootstrap"
echo "PASS refuse when ~/.zshrc_common already exists"
