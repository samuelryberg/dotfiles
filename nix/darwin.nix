{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  programs = {
    bash.enable = true;
    zsh.enable = true;
    fish.enable = true;
  };

  environment.shells = [ pkgs.fish ];

  nix.settings.experimental-features = "nix-command flakes";

  environment.systemPackages = import ./packages.nix { inherit pkgs; } ++ [
    pkgs.utm
  ];

  homebrew = {
    enable = true;

    brews = [
      # Empty for now
    ];

    casks = [
      "ghostty"
      "zen"
      "brave-browser"
      "obsidian"
      "spotify"
    ];

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
  };

  system = {
    primaryUser = "samuel";

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    defaults = {
      dock = {
        autohide = true;
        show-recents = false;
        minimize-to-application = true;
        persistent-apps = [ ];
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXPreferredViewStyle = "Nlsv";
        ShowPathbar = true;
      };

      controlcenter = {
        BatteryShowPercentage = true;
      };

      NSGlobalDomain.AppleIconAppearanceTheme = "ClearDark";
    };

    configurationRevision = null;
    stateVersion = 6;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
