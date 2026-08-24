#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
REPO_URL="https://github.com/samuelryberg/dotfiles/tarball/main"

# Colors and symbols
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Check dependencies
echo -e "${BLUE}Checking dependencies...${NC}"
missing_deps=()
for cmd in curl tar; do
  if ! command -v "$cmd" &>/dev/null; then
    missing_deps+=("$cmd")
  fi
done

if [[ ${#missing_deps[@]} -gt 0 ]]; then
  echo -e "${RED}✗ Missing required tools: ${missing_deps[*]}${NC}" >&2
  echo -e "${YELLOW}  Please install them and try again.${NC}" >&2
  exit 1
else
  echo -e "${GREEN}✓ All dependencies satisfied${NC}"
fi

# Check if directory already exists
echo ""
echo -e "${BLUE}Checking installation directory...${NC}"
if [[ -d "$DOTFILES_DIR" ]]; then
  echo -e "${RED}✗ Directory already exists: ${BOLD}$DOTFILES_DIR${NC}"
  echo ""
  echo -e "Please remove or rename it, then rerun this script:"
  echo -e "  ${CYAN}rm -rf $DOTFILES_DIR${NC}          ${YELLOW}# delete it${NC}"
  echo -e "  ${CYAN}mv $DOTFILES_DIR ${DOTFILES_DIR}.bak${NC}  ${YELLOW}# backup it${NC}"
  echo ""
  exit 1
else
  echo -e "${GREEN}✓ Installation directory ready${NC}"
fi

# Download and extract
echo ""
echo -e "${BLUE}Downloading dotfiles...${NC}"
TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

if ! curl -fsSL -o "$TMPFILE" "$REPO_URL"; then
  echo -e "${RED}✗ Failed to download dotfiles from repository${NC}" >&2
  exit 1
fi
echo -e "${GREEN}✓ Download complete${NC}"

echo ""
echo -e "${BLUE}Installing to ${BOLD}$DOTFILES_DIR${NC}..."
mkdir -p "$DOTFILES_DIR"
tar -xzf "$TMPFILE" --strip-components 1 -C "$DOTFILES_DIR"
echo -e "${GREEN}✓ Installation complete${NC}"

# Run bootstrap
echo ""
echo -e "${BOLD}${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${GREEN}  Dotfiles installed successfully!${NC}"
echo -e "${BOLD}${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""

cd "$DOTFILES_DIR"
exec ./bootstrap.sh "$@"
