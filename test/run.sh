#!/bin/sh
# Build the install-test image and run every script in test/cases/.
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)

docker build -t bootstrap-install-test "$root/test"
docker run --rm -v "$root:/src:ro" bootstrap-install-test sh /src/test/cases.sh
