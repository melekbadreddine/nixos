{
  pkgs,
  host,
  lib,
  ...
}: let
  inherit (import ../hosts/${host}/variables.nix) stylixImage stylixEnable;
in
lib.mkIf stylixEnable {
  # Styling Options
  stylix = {
    enable = true;
    image = stylixImage;
    polarity = "dark";
    opacity.terminal = 1.0;

    # Fix for 'services.displayManager.generic' error in recent nixpkgs
    # This usually happens when Stylix tries to style a display manager
    # that has been refactored in NixOS unstable or is not yet fully 
    # supported (like cosmic-greeter).
    targets.console.enable = false;
    targets.gnome.enable = false;
    targets.gtk.enable = false;
    targets.kde.enable = false;
    targets.lightdm.enable = false;
    targets.regreet.enable = false;

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
}
