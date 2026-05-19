# Bootstrap

Setup a new macOS, Linux, FreeBSD, or Cygwin user account for development in seconds.

```
sh -c "$(curl -fsSL https://raw.github.com/nikolaybotev/bootstrap/main/install.sh)"
```

## Update an existing install

After the first `git pull` that adds it, run from anywhere:

```
~/.bootstrap/update
```

This fast-forwards `~/.bootstrap` from GitHub, copies safe dotfiles into `$HOME` only when they still matched the repo before the pull (`.zshrc_common`, `.vimrc`, `.gitignore`, and `.zshrc_local` on platforms that have a template), and prints upstream changes to `.zshrc` / `.gitconfig` for manual merge. It does not re-run OS install scripts (`install.Darwin.sh`, etc.).

Use `~/.bootstrap/update --override` to replace safe files even when you edited them locally. `~/.bootstrap/update --dry-run` previews actions without changing anything.
