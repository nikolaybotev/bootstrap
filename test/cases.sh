#!/bin/sh
# Run every install case. Each script sources test/lib.sh.
set -eu

dir=$(CDPATH= cd -- "$(dirname "$0")" && pwd)

for case in \
  "$dir/cases/refuse-bootstrap-dir.sh" \
  "$dir/cases/refuse-zshrc-common.sh" \
  "$dir/cases/refuse-already-sources.sh" \
  "$dir/cases/refuse-unknown-commit.sh" \
  "$dir/cases/fresh-install.sh" \
  "$dir/cases/prepend-zshrc.sh"
do
  sh "$case"
done

echo "All install cases passed."
