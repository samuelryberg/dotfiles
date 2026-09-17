# Dotfiles

Personal dotfiles managed with **[chezmoi](https://chezmoi.io)** and **[mise](https://mise.jdx.dev)**, supporting macOS (Apple Silicon) and Linux.

## Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/samuelryberg/dotfiles/main/install.sh | sh
```

That installs chezmoi, clones this repo, and applies everything — packages, dotfiles, and system settings.

## Day-to-day

```bash
chezmoi edit ~/.config/fish/config.fish   # edit a managed file
chezmoi diff                              # preview pending changes
chezmoi apply                             # apply them
chezmoi update                            # git pull + apply
chezmoi cd                                # drop into the source repo
```

Adding a new dotfile: `chezmoi add ~/.config/foo/bar`.

## What's Included

- **Shell** — Fish, set as the login shell
- **Editor** — Neovim (LazyVim)
- **Terminal** — Ghostty with a custom theme
- **Multiplexer** — tmux with TPM
- **Tools** — git, kubernetes, OpenTofu, podman, and the usual CLI kit
- **System** — macOS defaults: Caps Lock→Escape, Dock, Finder, appearance

## Structure

```
dotfiles/
  install.sh                  # one-liner bootstrap
  .chezmoiroot                # -> home/, keeps repo root out of $HOME
  home/                       # everything that maps into $HOME
    .chezmoidata/
      packages.yaml           # OS packages, per platform
    .chezmoiscripts/
      run_onchange_before_10-packages.sh.tmpl
      run_onchange_after_20-mise.sh.tmpl
      run_onchange_after_30-macos-defaults.sh.tmpl
      run_onchange_after_40-tpm.sh.tmpl
      run_onchange_after_50-default-shell.sh.tmpl
    dot_config/mise/config.toml
    dot_config/fish/config.fish.tmpl
    dot_gitconfig, dot_tmux.conf, ...
```

`dot_` becomes `.`, and `.tmpl` files are rendered with `.chezmoi.os` available for per-platform branching.

## Where packages live

Two lists, split by what they are — not by platform:

| | File | Contents |
|---|---|---|
| **OS packages** | `home/.chezmoidata/packages.yaml` | Shells, GUI apps, anything needing system integration. Installed via Homebrew on macOS, apt/dnf/pacman on Linux. |
| **Dev CLIs** | `home/dot_config/mise/config.toml` | Version-managed tools that should be *identical* on every machine: node, kubectl, helm, OpenTofu, ripgrep, fd, fzf, lazygit, and npm-based tooling. |

Editing either file re-triggers its install script on the next `chezmoi apply`.

## Notes

- **`proton-pass-cli`** has no first-party cross-platform distribution. On macOS the `proton-pass` cask provides the SSH agent that `config.fish` points `SSH_AUTH_SOCK` at. On Linux, install it from Proton directly.
- **Linux package installs are per-package tolerant** — names that don't exist in your distro's repos are reported at the end rather than aborting the run.
- **Uninstalling** is no longer scripted. `chezmoi purge` removes chezmoi's own state; remove packages with `brew uninstall` / your package manager, and `mise uninstall` for dev CLIs.
