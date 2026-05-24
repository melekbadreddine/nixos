{lib, ...}: {
  imports = [
    ./modules
  ];

  home.username = "melek";
  home.homeDirectory = lib.mkForce "/home/melek";

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
