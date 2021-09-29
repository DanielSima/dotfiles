# Dotfiles

Dotfile management using [Dotbot](https://github.com/anishathalye/dotbot).
Structure of this repository is strongly inspired by [vbrandl](https://github.com/vbrandl/dotfiles).

## Dependencies & Prerequisites

See README [here](meta/configs/) for a config's dependencies and prerequisites.


## Installation

Download the repository:
```bash
~$ git clone --recursive https://github.com/DanielSima/dotfiles .dotfiles
```
Now you can either install a profile, which is a predefined set of configurations, or install configurations on their own.
- For installing a predefined profile:

    ```bash
    ~/.dotfiles$ ./install-profile <profile>
    ```
    See [/meta/profiles/](meta/profiles/) for available profiles.


- For installing single configurations:

    ```bash
    ~/.dotfiles$ ./install-standalone <configs...>
    ```
    See [/meta/configs/](meta/configs/) for available configurations.
