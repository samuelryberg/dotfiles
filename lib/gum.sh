BIN_DIR="$LIB_PATH/bin"
GUM="$BIN_DIR/gum"

mkdir -p "$BIN_DIR"

install_gum() {
  if [[ -x "$GUM" ]]; then
    echo "gum already installed"
    return
  fi

  echo "Installing gum..."

  local os arch version archive tmp_dir

  os="$OS" || exit 1
  arch="$ARCH" || exit 1

  case "$arch" in
  aarch64) arch="arm64" ;;
  amd64) arch="x86_64" ;;
  esac

  version="0.16.0"

  archive="gum_${version}_${os}_${arch}.tar.gz"

  tmp_dir="$(mktemp -d)"

  echo "Downloading gum ${version}..."

  curl -fsSL \
    "https://github.com/charmbracelet/gum/releases/download/v${version}/${archive}" \
    -o "$tmp_dir/gum.tar.gz"

  echo "Extracting..."

  tar -xzf "$tmp_dir/gum.tar.gz" -C "$tmp_dir"

  gum_binary="$(find "$tmp_dir" -type f -name gum | head -n 1)"

  if [[ -z "$gum_binary" ]]; then
    echo "Could not find gum binary after extraction"
    rm -rf "$tmp_dir"
    exit 1
  fi

  mv "$gum_binary" "$GUM"

  chmod +x "$GUM"

  rm -rf "$tmp_dir"

  if ! "$GUM" --version >/dev/null; then
    echo "gum installation failed"
    exit 1
  fi

  echo "Installed gum:"
  "$GUM" --version
}

# Run gum with interactive input from the terminal.
# When stdin is not a TTY (e.g. inside a while loop with a here-string),
# force gum to read from /dev/tty so prompts don't consume stale stdin data.
run_gum() {
  if [[ ! -t 0 ]]; then
    "$GUM" "$@" </dev/tty
  else
    "$GUM" "$@"
  fi
}
