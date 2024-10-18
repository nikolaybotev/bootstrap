#!/bin/sh -e

# Check Preconditions
if [ "$(uname | awk -F_ '{print $1}')" != 'CYGWIN' ]; then echo "This script only runs on Cygwin."; exit 1; fi
