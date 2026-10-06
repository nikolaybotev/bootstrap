#!/bin/sh
set -eu
. "$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)/lib.sh"

echo "== prepend to an existing ~/.zshrc =="
home=$(mktemp -d)
cat > "$home/.zshrc" <<'EOF'
# existing laptop config
export BOOTSTRAP_TEST_MARKER=kept
alias bootstrap_test_alias='echo kept'
EOF
original=$(mktemp)
cp "$home/.zshrc" "$original"
run_install "$home"
[ "$code" -eq 0 ] || fail "prepend: expected exit 0, got $code"
grep -q 'Added sourcing of ~/.zshrc_common at the top of ~/.zshrc.' "$log" || fail "prepend: missing message"
expected=$(mktemp)
cat "$src/.zshrc" "$original" > "$expected"
assert_same "$expected" "$home/.zshrc" "prepend: ~/.zshrc is not template plus original"
assert_same "$original" "$home/.zshrc.backup" "prepend: backup is not the original file"
assert_same "$src/.zshrc_common" "$home/.zshrc_common" "prepend: ~/.zshrc_common mismatch"
assert_same "$src/.vimrc" "$home/.vimrc" "prepend: ~/.vimrc mismatch"
[ -d "$home/.zsh/pure/.git" ] || fail "prepend: pure prompt was not cloned"

zsh_out=$(mktemp)
zsh_err=$(mktemp)
if ! HOME="$home" TERM=xterm-256color timeout 30 zsh -ic 'print -r -- "$BOOTSTRAP_TEST_MARKER" > "$HOME/marker.out"; alias bootstrap_test_alias > "$HOME/alias.out"' </dev/null >"$zsh_out" 2>"$zsh_err"; then
  echo "--- zsh stdout ---" >&2
  cat "$zsh_out" >&2
  echo "--- zsh stderr ---" >&2
  cat "$zsh_err" >&2
  fail "prepend: zsh could not load ~/.zshrc"
fi
grep -qx 'kept' "$home/marker.out" || fail "prepend: marker was not kept"
grep -q "bootstrap_test_alias='echo kept'" "$home/alias.out" || fail "prepend: alias was not kept"

installed=$(mktemp)
cp "$home/.zshrc" "$installed"
run_install "$home"
[ "$code" -eq 1 ] || fail "prepend rerun: expected exit 1, got $code"
grep -q '~/.bootstrap directory already exists.' "$log" || fail "prepend rerun: missing message"
assert_same "$installed" "$home/.zshrc" "prepend rerun: ~/.zshrc changed"
echo "PASS prepend to an existing ~/.zshrc"
