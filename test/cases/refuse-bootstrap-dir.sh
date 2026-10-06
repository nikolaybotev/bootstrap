#!/bin/sh
set -eu
. "$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)/lib.sh"

echo "== refuse when ~/.bootstrap already exists =="
home=$(mktemp -d)
printf '%s\n' 'export BOOTSTRAP_TEST_MARKER=original' > "$home/.zshrc"
saved=$(mktemp)
cp "$home/.zshrc" "$saved"
mkdir "$home/.bootstrap"
run_install "$home"
[ "$code" -eq 1 ] || fail "bootstrap dir: expected exit 1, got $code"
grep -q '~/.bootstrap directory already exists.' "$log" || fail "bootstrap dir: missing message"
assert_same "$saved" "$home/.zshrc" "bootstrap dir: ~/.zshrc changed"
[ ! -f "$home/.zshrc_common" ] || fail "bootstrap dir: created ~/.zshrc_common"
echo "PASS refuse when ~/.bootstrap already exists"
