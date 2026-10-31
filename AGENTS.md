# Agent notes

This repository holds dotfiles and small shell setup scripts for macOS, Linux, FreeBSD, and Cygwin. After a normal install, utilities in `bin/` are on `PATH` via `~/.bootstrap/bin`.

## Tests and CI

Linux install behavior is covered by Docker tests: run `sh test/run.sh` from a checkout (Docker required). GitHub Actions runs the same command in the `install-linux` job (see `.github/workflows/test.yml`). macOS-only tools in `bin/` are not exercised by that job.

See [CONTRIBUTING.md](CONTRIBUTING.md) for how the install tests work.

## Common mistakes

- Do not run `install.sh`, `install.<OS>.sh`, or `update` against a real user `$HOME`; they rewrite dotfiles and system preferences.
- Keep each `bin/` tool as a single self-contained script.
- Keep changes minimal: no new frameworks, CI jobs, or process files unless asked.
- Keep public-facing text generic and author-agnostic.
