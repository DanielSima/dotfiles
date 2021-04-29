# Dotfiles

Dotfile management using [Dotbot](https://github.com/anishathalye/dotbot).
Structure of this repository is strongly inspired by [vbrandl](https://github.com/vbrandl/dotfiles).

## Dependencies

See [required_packages](./required_packages).


## Installation

```bash
~$ git clone --recursive https://github.com/DanielSima/dotfiles .dotfiles
```

For installing a predefined profile:

```bash
~/.dotfiles$ ./install-profile <profile>
# see meta/profiles/ for available profiles
```

For installing single configurations:

```bash
~/.dotfiles$ ./install-standalone <configs...>
# see meta/configs/ for available configurations
```

You can run these installation commands safely multiple times, if you think that helps with better installation.

Most configs don't overwrite any existing files (except symlinks). Some however do, and some do even more, so I recommend reading the .yaml files before installing them.
