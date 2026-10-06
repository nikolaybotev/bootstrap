# Contributing

This file is for people changing the repo. The install people run on a new account is in the README.

## Install tests

The tests cover the Linux path of `install.sh` in Docker. The image already has `zsh`, `git`, `curl`, `sudo`, `gnupg`, and `passwd`, so `install.Linux.sh` does not have to download those packages. `apt-get update` in that script still contacts the network, and the install still clones the Pure prompt from GitHub and checks that commit with the GitHub API.

Run from a checkout:

```
sh test/run.sh
```

Docker is required. The script builds `test/Dockerfile`, mounts this repo into the container, and runs `test/cases.sh`. That runner executes one script per case under `test/cases/`. Each case sources `test/lib.sh`, which snapshots the working tree, including uncommitted changes, and places `git` and `curl` shims first on `PATH`. The git shim redirects only the bootstrap clone to that snapshot. The curl shim answers the commit check for that snapshot and passes every other URL through, including Pure. `install.sh` always clones the GitHub URLs. It does not read an environment variable to choose a repo. After each clone it asks the GitHub API whether that commit exists in the named repository. `curl` does not read git config, so an `insteadOf` rewrite to some other commit fails the check. A mirror of the same commits still passes, and the user's git config still applies to the clone.

Cases:

- `~/.bootstrap` already exists: exit before changing `~/.zshrc`
- `~/.zshrc_common` already exists: exit before changing either file
- `~/.zshrc` already sources `~/.zshrc_common`: exit before creating `~/.bootstrap`
- bootstrap checkout is a commit GitHub does not have: exit and leave the home directory unchanged
- no `~/.zshrc`: install the template
- existing `~/.zshrc`: prepend the template, keep the old lines, write `~/.zshrc.backup`, then load the file in `zsh` and confirm an alias from the old file is still there
- running the prepend case again: exit because `~/.bootstrap` now exists, and leave `~/.zshrc` as it was

GitHub Actions runs `sh test/run.sh` on every push and pull request (`.github/workflows/test.yml`).

macOS, FreeBSD, and Cygwin install steps are not part of this run.
