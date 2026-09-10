{ pkgs }:
[
  # Core packages
  pkgs.git
  pkgs.git-filter-repo
  pkgs.tmux
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
  pkgs.stow
  pkgs.proton-pass-cli
  pkgs.nodejs_24
  pkgs.opencode
  pkgs.claude-code
  pkgs.ansible
  pkgs.opentofu
  pkgs.podman
  pkgs.kubectl
  pkgs.kubernetes-helm
  (pkgs.lib.lowPrio pkgs.minikube)

  # Neovim less important packages
  pkgs.ast-grep
  pkgs.luarocks
  pkgs.imagemagick
  pkgs.ghostscript
  pkgs.mermaid-cli
  pkgs.tectonic
]
