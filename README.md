# Dotfiles

Personal development environment managed with [chezmoi](https://www.chezmoi.io/). The configuration supports macOS and Debian/Ubuntu Linux, with shared command-line tools installed through Nix.

## What is included

- Fish shell configuration, prompt, aliases, and completions
- Neovim configuration based on LazyVim
- Ghostty, tmux, Git settings
- Shared CLI packages managed with Nix
- macOS applications managed with Homebrew
- macOS defaults for the Dock, Finder, appearance, and mouse
- Automatic Fish login-shell setup

Package lists are defined in [`home/.chezmoidata/packages.yaml`](home/.chezmoidata/packages.yaml).

## Install

Install [chezmoi](https://www.chezmoi.io/install/), then initialize this repository:

```sh
chezmoi init https://github.com:samuelryberg/dotfiles.git
chezmoi diff
chezmoi apply
```

The first apply may ask for confirmation before installing Nix or Homebrew and may request administrator privileges. On macOS, it also changes system defaults and restarts the affected interface processes.

> [!NOTE]
> These are personal settings. Review `chezmoi diff` and the scripts in [`home/.chezmoiscripts`](home/.chezmoiscripts) before applying them to another machine.

## Usage

Edit a managed file through chezmoi:

```sh
chezmoi edit ~/.config/fish/config.fish
chezmoi diff
chezmoi apply
```

Add a new file:

```sh
chezmoi add ~/.config/example/config
```

Open the source directory:

```sh
chezmoi cd
```

Scripts prefixed with `run_onchange_` run again when their rendered contents change. Updating the package data or macOS defaults and running `chezmoi apply` therefore applies the corresponding changes.

## Repository layout

```text
.
├── .chezmoiroot          # Uses home/ as the chezmoi source root
├── home/
│   ├── .chezmoidata/     # Package definitions
│   ├── .chezmoiscripts/  # Bootstrap and system setup scripts
│   ├── dot_config/       # Files installed under ~/.config
│   └── dot_gitconfig     # Git configuration
└── LICENSE
```

## License

This repository is available under the [MIT License](LICENSE).
