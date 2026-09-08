TPM_DIR="$HOME/.tmux/plugins/tpm"

install_tpm() {
  if [[ -n "${UNINSTALL:-}" ]]; then
    return
  fi

  if ! command -v git &>/dev/null; then
    echo "git is not installed, skipping TPM installation"
    return
  fi

  if [[ -d "$TPM_DIR" ]]; then
    echo "TPM already installed"
    return
  fi

  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
}
