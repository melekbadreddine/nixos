{ config, pkgs, fresh, helium, ... }:
{
  imports = [
    ./modules
  ];

  home.username = "melek";
  home.homeDirectory = "/home/melek";

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  gtk.gtk4.theme = config.gtk.theme;
}
