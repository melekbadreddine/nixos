{
  pkgs,
  host,
  lib,
  ...
}: let
  variables = import ../hosts/${host}/variables.nix;
  stylixEnable = variables.stylixEnable or false;
  stylixImage = variables.stylixImage or null;
in {
  # Compatibility shim for Stylix + NixOS Unstable displayManager refactor
  options.services.displayManager.generic = lib.mkOption {
    type = lib.types.deferredModule;
    default = {};
    description = "Dummy option to fix Stylix compatibility with recent nixpkgs";
  };

  config = lib.mkIf stylixEnable {
    # Styling Options
    stylix = {
      enable = true;
      image = stylixImage;
      polarity = "dark";
      opacity.terminal = 1.0;

      # Enable console target
      targets.console.enable = true;
      targets.generic.enable = lib.mkForce false;

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrains Mono";
        };
        sansSerif = {
          package = pkgs.montserrat;
          name = "Montserrat";
        };
        serif = {
          package = pkgs.montserrat;
          name = "Montserrat";
        };
        sizes = {
          applications = 12;
          terminal = 15;
          desktop = 11;
          popups = 12;
        };
      };
    };
  };
}
