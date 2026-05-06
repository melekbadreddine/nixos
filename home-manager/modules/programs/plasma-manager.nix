{
  pkgs,
  plasma-manager,
  host,
  ...
}: let
  inherit (import ../../../hosts/${host}/variables.nix) stylixImage;

  # Declaratively fetch the Rem splash screen theme
  # Theme ID: Rem
  rem-theme = pkgs.stdenv.mkDerivation {
    name = "rem-plasma-theme";
    src = pkgs.fetchzip {
      url = "https://github.com/vinceliuice/Rem-kde/archive/refs/heads/main.zip";
      sha256 = "sha256-oWfGfL+nU9GZ8j8m7y8wG5L1V2G3S4H5I6J7K8L9M0="; # Placeholder
    };
    installPhase = ''
      mkdir -p $out/share/plasma/look-and-feel/
      cp -r sddm/Rem $out/share/plasma/look-and-feel/
    '';
  };
in {
  imports = [
    plasma-manager.homeModules.plasma-manager
  ];

  home.packages = [
    plasma-manager.packages.${pkgs.stdenv.hostPlatform.system}.default
    rem-theme
  ];

  programs.plasma = {
    enable = true;
    # Configure wallpaper through plasma-manager to avoid Stylix conflicts
    workspace.wallpaper = stylixImage;

    # Set splash screen to Rem
    splashScreen.theme = "Rem";
  };
}
