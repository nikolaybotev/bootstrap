#!/bin/sh
# Sanity check for bin/disk_free on macOS.
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
tool="$root/bin/disk_free"

"$tool" | grep -Eq '^available [0-9]+\.[0-9]{2} GB, free [0-9]+\.[0-9]{2} GB, purgeable [0-9]+\.[0-9]{2} GB, total [0-9]+\.[0-9]{2} GB$'
"$tool" --raw | grep -Eq '^[0-9]+ [0-9]+ [0-9]+ [0-9]+$'
"$tool" --json | python3 -c '
import json, sys
d = json.load(sys.stdin)
assert d["total"] > 0 and d["available"] >= d["free"] > 0, d
assert d["purgeable"] == max(0, d["available"] - d["free"]), d
'
"$tool" --json "$HOME" | python3 -c 'import json, sys; json.load(sys.stdin)'
if "$tool" --bogus >/dev/null 2>&1; then echo "FAIL: --bogus accepted" >&2; exit 1; fi

echo "disk_free sanity check passed."
