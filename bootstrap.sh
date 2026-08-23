#!/usr/bin/env bash

set -euo pipefail

# Only allow execution of bootstrap from repo root
BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
CURRENT_DIR="$(pwd -P)"

if [[ "$CURRENT_DIR" != "$BOOTSTRAP_DIR" ]]; then
  echo "Error: Run this script from the dotfiles root" >&2
  exit 1
fi

# Import lib scripts
source "./lib/options.sh"
source "./lib/env.sh"
source "./lib/gum.sh"
source "./lib/stow.sh"

source "./lib/nix.sh"
source "./lib/brew.sh"
source "./lib/ui.sh"

_setup_pkg_manager() {
  install_nix
  setup_nix

  if [[ "$OS" == "Linux" ]]; then
    if [[ -n "${UNINSTALL:-}" ]]; then
      uninstall_nix_home_manager
    else
      setup_nix_home_manager
    fi
  elif [[ "$OS" == "Darwin" ]]; then
    install_brew
    setup_brew

    if [[ -n "${UNINSTALL:-}" ]]; then
      uninstall_nix_darwin
    else
      setup_nix_darwin
    fi
  fi
}

_stow_selections() {
  local selections="$1"
  shift

  while IFS= read -r selection; do
    stow_pkg "$selection" "$@"
  done <<<"$selections"
}

_setup_dotfiles() {
  # Verifies that the user has stow installed.
  check_stow

  echo "Stowing to $TARGET_DIR"
  _stow_selections "$PACKAGES" -v ${UNINSTALL:+-D}
  echo "Stow succeeded"
}

bootstrap_parse_args "$@"

if [[ -n "$YES" ]]; then
  JOBS=$'pkg_manager\ndotfiles'
  if [[ -n "${UNINSTALL:-}" ]]; then
    NIX_CHOICE="no"
    BREW_CHOICE="no"
  else
    NIX_CHOICE="yes"
    BREW_CHOICE="yes"
  fi
  NIX_DARWIN_CHOICE="yes"
  PACKAGES=$'Shared\n'"$OS"
else
  # Downloads binaries for gum (Terminal User Interface) for nicer UI with the bootstrap.
  install_gum

  clear

  show_welcome

  # Phase 1: Collect all choices
  select_jobs
  JOBS="$SELECTIONS"

  if [[ "$JOBS" == *"pkg_manager"* ]]; then
    select_nix
    if [[ "$OS" == "Linux" ]]; then
      select_nix_home_manager
    elif [[ "$OS" == "Darwin" ]]; then
      select_brew
      select_nix_darwin
    fi
  fi

  if [[ "$JOBS" == *"dotfiles"* ]]; then
    select_packages "$OS"
    PACKAGES="$SELECTIONS"
  fi

  # Phase 2: Show summary and confirm
  show_summary

  if ! confirm_summary; then
    echo "Aborted."
    exit 0
  fi
fi

# Phase 3: Execute silently
clear

if [[ -n "${UNINSTALL:-}" ]]; then
  JOB_ORDER=$'dotfiles\npkg_manager'
else
  JOB_ORDER=$'pkg_manager\ndotfiles'
fi

while IFS= read -r job; do
  if echo "$JOBS" | grep -q "^${job}$"; then
    case "$job" in
    pkg_manager) _setup_pkg_manager ;;
    dotfiles) _setup_dotfiles ;;
    esac
  fi
done <<<"$JOB_ORDER"
