{
  pkgs,
  host,
  lib,
  ...
}: let
  inherit (import ../../hosts/${host}/variables.nix) stylixImage stylixEnable;
in
  lib.mkIf stylixEnable {
    stylix = {
      enable = true;
      image = stylixImage;
      base16Scheme = pkgs.base16-schemes + "/share/themes/catppuccin-mocha.yaml";
      polarity = "dark";

      # Disable automatic styling to prevent conflicts with manually configured apps.
      # Home Manager modules handle their own theming (e.g., Starship, Zen disabled).
      autoEnable = false;

      targets = {
        console.enable = true;
        plymouth.enable = true;
      };

      cursor = {
        package = pkgs.apple-cursor;
        name = "Macintosh";
        size = 24;
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.departure-mono;
          name = "DepartureMono Nerd Font Mono";
        };
        sansSerif = {
          package = pkgs.nerd-fonts.departure-mono;
          name = "DepartureMono Nerd Font";
        };
        serif = {
          package = pkgs.nerd-fonts.departure-mono;
          name = "DepartureMono Nerd Font";
        };
      };
    };
  }
