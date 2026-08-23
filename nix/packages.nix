{ pkgs }:
[
  # Core packages
  pkgs.git
  pkgs.neovim
  pkgs.ripgrep
  pkgs.fd
  pkgs.lazygit
  pkgs.fzf
  pkgs.nixfmt
  pkgs.statix

  # Tools
  pkgs.fish
  pkgs.fastfetch
  pkgs.python3
  pkgs.nodejs_22
  pkgs.pnpm
  pkgs.uv
  pkgs.stow
  pkgs.proton-pass-cli
  pkgs.opencode
  pkgs.claude-code
  pkgs.ansible
  pkgs.opentofu
  pkgs.podman
  pkgs.podman-compose
  pkgs.kubectl
  pkgs.kubernetes-helm
  (pkgs.lib.lowPrio pkgs.minikube)

  # Less important packages
  pkgs.ast-grep
  pkgs.luarocks
  pkgs.imagemagick
  pkgs.ghostscript
  pkgs.mermaid-cli
  pkgs.tectonic
]
