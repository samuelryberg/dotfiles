# Dotfiles

Personal dotfiles managed with **GNU Stow** and **Nix**, with support for macOS (Apple Silicon) and Linux.

## Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/samuelryberg/dotfiles/main/scripts/install.sh | bash
```

For CI/automation, use the `--yes` flag to skip confirmations:

```bash
curl -fsSL https://raw.githubusercontent.com/samuelryberg/dotfiles/main/scripts/install.sh | bash -s -- --yes
```

To install to a custom directory, set `DOTFILES_DIR`:

```bash
DOTFILES_DIR=~/mydotfiles
```

## What's Included

- **Shell** - Fish as default shell
- **Editor** - Neovim
- **Terminal** - Ghostty with custom theme
- **Tools** - Git, tmux, Python, and more
- **System** - Custom key remaps, Dock behavior, and shell preferences

See `nix/flake.nix` for the full system setup.

## Structure

```
dotfiles/
  bootstrap.sh          # Interactive setup wizard
  scripts/install.sh      # One-liner remote installer
  lib/                  # Shell library modules
  stow/                 # Symlinked dotfile packages
  nix/                  # nix system files
```

## How It Works

1. `install.sh` downloads and extracts the repo to `~/dotfiles` (or `$DOTFILES_DIR`)
2. `bootstrap.sh` installs `gum` locally, then presents an interactive menu to set up your package manager and symlink dotfiles
