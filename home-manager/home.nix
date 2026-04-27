{ config, pkgs, fresh, helium, ... }:
{
  imports = [
    ./modules
    ./stylix.nix
  ];

  home.username = "melek";
  home.homeDirectory = "/home/melek";

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
