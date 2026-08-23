_require_nix() {
  if ! command -v nix &>/dev/null; then
    echo "Nix is not installed"
    return 1
  fi
}

_backup_etc_files() {
  local files=("/etc/bashrc" "/etc/zshrc" "/etc/zprofile" "/etc/zshenv" "/etc/bash.bashrc" "/etc/nix/nix.conf")
  for file in "${files[@]}"; do
    if [[ -f "$file" && ! -L "$file" ]]; then
      sudo mv "$file" "$file.before-nix-darwin"
      echo "Backed up $file -> $file.before-nix-darwin"
    fi
  done
}

install_nix() {
  if [[ "$NIX_CHOICE" != "yes" ]]; then
    echo "Skipping nix installation"
    return
  fi

  if command -v nix &>/dev/null || [[ -d "/nix/store" ]]; then
    echo "Nix already installed"
    return
  fi

  echo "Installing Nix Package Manager..."
  sudo -v
  if [[ "$OS" == "Darwin" ]]; then
    curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh
  else
    curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon
  fi

  local NIX_DAEMON_SH="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
  if [[ ! -f "$NIX_DAEMON_SH" ]]; then
    echo "Error: Nix daemon profile not found at $NIX_DAEMON_SH"
    exit 1
  fi
  source "$NIX_DAEMON_SH"
}

setup_nix() {
  _require_nix || return

  local experimental_features
  experimental_features=$(nix show-config 2>/dev/null | grep "^experimental-features" | awk -F' = ' '{print $2}' || true)

  if [[ "$experimental_features" == *"flakes"* && "$experimental_features" == *"nix-command"* ]]; then
    return
  fi

  local nix_conf="$HOME/.config/nix/nix.conf"
  mkdir -p "$(dirname "$nix_conf")"
  echo "experimental-features = nix-command flakes" >>"$nix_conf"
  echo "Enabled nix-command and flakes in $nix_conf"
}

setup_nix_home_manager() {
  if [[ "$NIX_HM_CHOICE" != "yes" ]]; then
    return
  fi

  _require_nix || return

  local NIX_COMMAND
  local FLAKE_DIR="$DOTFILES_PATH/nix/"

  if command -v home-manager &>/dev/null; then
    NIX_COMMAND=(home-manager)
  else
    NIX_COMMAND=(nix run home-manager/master --)
  fi

  if [[ -f "$FLAKE_DIR/flake.nix" ]]; then
    "${NIX_COMMAND[@]}" switch --flake "$FLAKE_DIR#Linux"
    export PATH="/run/current-system/sw/bin:$PATH"
  fi
}

uninstall_nix_home_manager() {
  _require_nix || return

  if ! command -v home-manager &>/dev/null; then
    echo "home-manager not installed, skipping"
    return
  fi

  echo "Uninstalling home-manager..."

  echo "Home Manager cannot be uninstalled in non-interactive mode please run the following command to uninstall:"
  if command -v home-manager &>/dev/null; then
    echo "home-manager uninstall"
  else
    echo "nix run home-manager/master -- uninstall"
  fi
}

setup_nix_darwin() {
  if [[ "$NIX_DARWIN_CHOICE" != "yes" ]]; then
    return
  fi

  _require_nix || return
  _require_brew || return

  local NIX_COMMAND
  local FLAKE_DIR="$DOTFILES_PATH/nix/"

  if command -v darwin-rebuild &>/dev/null; then
    NIX_COMMAND=(darwin-rebuild)
  else
    NIX_COMMAND=(nix run nix-darwin/master#darwin-rebuild --)
  fi

  if [[ -f "$FLAKE_DIR/flake.nix" ]]; then
    _backup_etc_files
    sudo "${NIX_COMMAND[@]}" switch --flake "$FLAKE_DIR#MBP"
    export PATH="/run/current-system/sw/bin:$PATH"
  fi
}

uninstall_nix_darwin() {
  _require_nix || return

  if ! command -v darwin-rebuild &>/dev/null; then
    echo "nix-darwin not installed, skipping"
    return
  fi

  echo "Uninstalling nix-darwin..."

  if command -v darwin-uninstaller &>/dev/null; then
    sudo darwin-uninstaller
  else
    sudo nix run nix-darwin#darwin-uninstaller
  fi
}
