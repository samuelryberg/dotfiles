show_welcome() {
  local lines=("Welcome to Samuel's dotfiles!")
  if [[ -n "${UNINSTALL:-}" ]]; then
    lines+=("" "!! UNINSTALL MODE !!" "This will remove dotfiles and configuration.")
  fi
  run_gum style --foreground 212 --border-foreground 212 --border double --align center --width 50 --margin "1 2" --padding "2 4" \
    "${lines[@]}"
}

select_jobs() {
  if [[ -n "${UNINSTALL:-}" ]]; then
    echo "Which uninstall tasks would you like to run?"
  else
    echo "Which setup tasks would you like to run?"
  fi
  SELECTIONS=$(run_gum choose \
    --no-limit \
    --label-delimiter "#" \
    --selected "*" \
    "Package Manager#pkg_manager" \
    "Dotfiles#dotfiles")
}

select_packages() {
  local os="$1"
  if [[ -n "${UNINSTALL:-}" ]]; then
    echo "Which package sets would you like to uninstall?"
  else
    echo "Which package sets would you like to install?"
  fi
  SELECTIONS=$(run_gum choose \
    --no-limit \
    --selected "*" \
    "Shared" \
    "$os")
}

select_nix() {
  if command -v nix &>/dev/null; then
    echo "Nix already installed"
    NIX_CHOICE="no"
    return
  fi

  if [[ -n "${UNINSTALL:-}" ]]; then
    NIX_CHOICE="no"
    return
  fi

  NIX_CHOICE=$(run_gum confirm "Nix is required. Install it?" && echo "yes" || echo "no")
}

select_brew() {
  if command -v brew &>/dev/null; then
    echo "Homebrew already installed"
    BREW_CHOICE="no"
    return
  fi

  if [[ -n "${UNINSTALL:-}" ]]; then
    BREW_CHOICE="no"
    return
  fi

  BREW_CHOICE=$(run_gum confirm "Homebrew is required. Install it?" && echo "yes" || echo "no")
}

select_nix_home_manager() {
  if ! command -v nix &>/dev/null && [[ "$NIX_CHOICE" != "yes" ]]; then
    echo "Skipping nix home manager (nix not installed)"
    NIX_HM_CHOICE="no"
    return
  fi

  if [[ -n "${UNINSTALL:-}" ]]; then
    NIX_HM_CHOICE="yes"
    return
  fi

  NIX_HM_CHOICE=$(run_gum confirm "Do you want to run nix home manager?" && echo "yes" || echo "no")
}

select_nix_darwin() {
  if ! command -v nix &>/dev/null && [[ "$NIX_CHOICE" != "yes" ]]; then
    echo "Skipping nix-darwin (nix not installed)"
    NIX_DARWIN_CHOICE="no"
    return
  fi

  if [[ -n "${UNINSTALL:-}" ]]; then
    NIX_DARWIN_CHOICE="yes"
    return
  fi

  NIX_DARWIN_CHOICE=$(run_gum confirm "Do you want to run nix-darwin?" && echo "yes" || echo "no")
}

show_summary() {
  local nix_label brew_label darwin_label

  if [[ -n "${UNINSTALL:-}" ]]; then
    nix_label="Uninstall Nix"
    brew_label="Uninstall Homebrew"
    darwin_label="Uninstall nix-darwin"
    home_manager_label="Uninstall nix home manager"
  else
    nix_label="Install Nix"
    brew_label="Install Homebrew"
    darwin_label="Setup nix-darwin"
    home_manager_label="Setup nix home manager"
  fi

  run_gum style --foreground 212 --border-foreground 212 --border double --align left --width 50 --margin "1 2" --padding "2 4" \
    "Summary of your choices:" \
    "" \
    "Jobs: $JOBS" \
    "$nix_label: ${NIX_CHOICE:-no}" \
    "$brew_label: ${BREW_CHOICE:-no}" \
    "$home_manager_label: ${NIX_HM_CHOICE:-no}" \
    "$darwin_label: ${NIX_DARWIN_CHOICE:-no}" \
    "Packages: ${PACKAGES:-none}" \
    "" \
    "Note: Nix and Homebrew must be uninstalled manually."
}

confirm_summary() {
  run_gum confirm "Do you want to proceed with these choices?"
}
