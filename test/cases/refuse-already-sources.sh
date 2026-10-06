#!/bin/sh
set -eu
. "$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)/lib.sh"

echo "== refuse when ~/.zshrc already sources ~/.zshrc_common =="
home=$(mktemp -d)
cat > "$home/.zshrc" <<'EOF'
export BOOTSTRAP_TEST_MARKER=original
[ -f ~/.zshrc_common ] && . ~/.zshrc_common
EOF
saved=$(mktemp)
cp "$home/.zshrc" "$saved"
run_install "$home"
[ "$code" -eq 1 ] || fail "already sources: expected exit 1, got $code"
grep -q '~/.zshrc already sources ~/.zshrc_common.' "$log" || fail "already sources: missing message"
assert_same "$saved" "$home/.zshrc" "already sources: ~/.zshrc changed"
[ ! -f "$home/.zshrc_common" ] || fail "already sources: created ~/.zshrc_common"
[ ! -d "$home/.bootstrap" ] || fail "already sources: created ~/.bootstrap"
echo "PASS refuse when ~/.zshrc already sources ~/.zshrc_common"
