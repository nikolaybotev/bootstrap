#!/usr/bin/env bash
set -euo pipefail

# Dotfiles and shell scripts only. No toolchain install.
# Install tests need Docker (sh test/run.sh); bin/disk_free needs macOS.

curl -fsSL https://raw.githubusercontent.com/nikolaybotev/local-skills/main/install.sh | sh -s -- ~/.cursor/skills-cursor
