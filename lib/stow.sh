STOW_DIR="$DOTFILES_PATH/stow"
TARGET_DIR="$HOME"

check_stow() {
  if ! command -v stow >/dev/null 2>&1; then
    echo "Error: GNU Stow is not installed." >&2
    exit 1
  fi
}

stow_pkg() {
  local pkg="$1"
  [ -z "$pkg" ] && return
  shift
  local flags=("$@")

  if [ -d "$STOW_DIR/$pkg" ]; then
    stow "${flags[@]}" --no-folding -d "$STOW_DIR" -t "$TARGET_DIR" "$pkg"
  else
    echo "Skipping missing package: $pkg"
  fi
}
