{lib, ...}: {
  imports = [
    ./modules
  ];

  home.username = "melek";
  home.homeDirectory = lib.mkForce "/home/melek";

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;
}
