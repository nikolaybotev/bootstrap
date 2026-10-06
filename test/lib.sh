# Shared setup for test/cases/*.sh. Source this file; do not execute it.
set -eu

src=/src
if [ ! -f "$src/install.sh" ]; then
  echo "Mount the bootstrap repo at /src." >&2
  exit 1
fi

snapshot=$(mktemp -d)
cp -R "$src"/. "$snapshot"/
rm -rf "$snapshot/.git"
git -C "$snapshot" init -q -b main
git -C "$snapshot" add -A
git -C "$snapshot" \
  -c user.email=tester@example.com \
  -c user.name='Bootstrap Test' \
  commit -q -m 'test snapshot'

# Redirect only the bootstrap clone. install.sh has no repo override to set.
# The commit check calls curl. Answer it for the snapshot SHA; a different
# bootstrap SHA is a 404. Pure still uses the real GitHub API.
real_git=$(command -v git)
real_curl=$(command -v curl) || {
  echo "curl is required in the test image." >&2
  exit 1
}
snapshot_sha=$(git -C "$snapshot" rev-parse HEAD)
shim_dir=$(mktemp -d)
cat > "$shim_dir/git" <<'EOF'
#!/bin/sh
if [ "$1" = clone ] && [ "$2" = https://github.com/nikolaybotev/bootstrap.git ]; then
  shift 2
  exec "$BOOTSTRAP_TEST_GIT" clone "$BOOTSTRAP_TEST_SNAPSHOT" "$@"
fi
exec "$BOOTSTRAP_TEST_GIT" "$@"
EOF
cat > "$shim_dir/curl" <<'EOF'
#!/bin/sh
for arg do
  case $arg in
    https://api.github.com/repos/nikolaybotev/bootstrap/commits/*)
      commit=${arg##*/}
      if [ "$commit" = "$BOOTSTRAP_TEST_SNAPSHOT_SHA" ]; then
        printf '%s\n' "$BOOTSTRAP_TEST_SNAPSHOT_SHA"
        exit 0
      fi
      echo "curl: (22) The requested URL returned error: 404" >&2
      exit 22
      ;;
  esac
done
exec "$BOOTSTRAP_TEST_CURL" "$@"
EOF
chmod +x "$shim_dir/git" "$shim_dir/curl"
export BOOTSTRAP_TEST_GIT=$real_git
export BOOTSTRAP_TEST_CURL=$real_curl
export BOOTSTRAP_TEST_SNAPSHOT=$snapshot
export BOOTSTRAP_TEST_SNAPSHOT_SHA=$snapshot_sha
export PATH="$shim_dir:$PATH"
export DEBIAN_FRONTEND=noninteractive
export GIT_TERMINAL_PROMPT=0

log=$(mktemp)
code=0

fail() {
  echo "FAIL: $*" >&2
  if [ -s "$log" ]; then
    echo "--- install.sh output ---" >&2
    cat "$log" >&2
  fi
  exit 1
}

run_install() {
  home=$1
  set +e
  # install.sh must not read BOOTSTRAP_REPO. Git config still applies to clones.
  HOME=$home \
    BOOTSTRAP_REPO=/no/such/bootstrap-repo \
    sh "$src/install.sh" >"$log" 2>&1 </dev/null
  code=$?
  set -e
}

assert_same() {
  if ! cmp -s "$1" "$2"; then
    fail "$3"
  fi
}
