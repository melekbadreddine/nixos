{ pkgs, plasma-manager, ... }: {
  imports = [
    plasma-manager.homeManagerModules.plasma-manager
  ];

  home.packages = [
    plasma-manager.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.plasma.enable = true;
}
