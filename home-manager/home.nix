{ config, pkgs, mango, inputs, ... }:
{
  imports = [
    ./modules
    ./modules/mango-hm.nix
    inputs.mango.hmModules.mango
  ];

  home.username = "melek";
  home.homeDirectory = "/home/melek";

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
