{ config, pkgs, fresh, helium, ... }:
{
  imports = [
    ./modules
  ];

  home.username = "melek";
  home.homeDirectory = "/home/melek";

  home.stateVersion = "26.05";
  home.backupFileExtension = "backup";
  programs.home-manager.enable = true;
}
