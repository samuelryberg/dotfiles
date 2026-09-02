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
  pkgs.stow
  pkgs.proton-pass-cli
  pkgs.opencode
  pkgs.claude-code
  pkgs.ansible
  pkgs.opentofu
  #pkgs.podman #using docker for use with sandboxes
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
