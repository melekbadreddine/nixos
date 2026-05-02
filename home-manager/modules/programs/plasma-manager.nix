{ pkgs, plasma-manager, host, ... }: let
  inherit (import ../../../hosts/${host}/variables.nix) stylixImage;
in {
  imports = [
    plasma-manager.homeModules.plasma-manager
  ];

  home.packages = [
    plasma-manager.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.plasma = {
    enable = true;
    # Configure wallpaper through plasma-manager to avoid Stylix conflicts
    desktop.wallpaper = {
      fileName = stylixImage;
      plugin = "org.kde.image";
    };
  };
}
