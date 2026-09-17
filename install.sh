#!/usr/bin/env sh
# Bootstrap these dotfiles on a fresh machine:
#
#   curl -fsSL https://raw.githubusercontent.com/samuelryberg/dotfiles/main/install.sh | sh
#
# Everything past this point is chezmoi's job.
set -eu

REPO="${DOTFILES_REPO:-samuelryberg}"

if command -v chezmoi >/dev/null 2>&1; then
  chezmoi="$(command -v chezmoi)"
else
  bin_dir="${HOME}/.local/bin"
  chezmoi="${bin_dir}/chezmoi"
  echo "Installing chezmoi to ${chezmoi}"
  if command -v curl >/dev/null 2>&1; then
    sh -c "$(curl -fsSL https://get.chezmoi.io)" -- -b "${bin_dir}"
  elif command -v wget >/dev/null 2>&1; then
    sh -c "$(wget -qO- https://get.chezmoi.io)" -- -b "${bin_dir}"
  else
    echo "curl or wget is required to install chezmoi." >&2
    exit 1
  fi
fi

exec "$chezmoi" init --apply --verbose "$REPO"
