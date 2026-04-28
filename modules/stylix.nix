{
  pkgs,
  host,
  lib,
  ...
}: let
  inherit (import ../hosts/${host}/variables.nix) stylixImage stylixEnable;
in
lib.mkIf stylixEnable {
  stylix = {
    enable = true;
    image = stylixImage;
    polarity = "dark";

    # Disable all automatic styling to prevent it from touching Plasma/GTK/etc.
    autoEnable = false;

    targets = {
      console.enable = true;
      plymouth.enable = true;
    };

    # Basic font config for console/plymouth if needed
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
    };
  };
}
