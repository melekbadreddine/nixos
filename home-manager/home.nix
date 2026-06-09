{lib, ...}: {
  imports = [
    ./modules
  ];

  home.username = "melek";
  home.homeDirectory = lib.mkForce "/home/melek";
  home.stateVersion = "25.11";
  home.enableNixpkgsReleaseCheck = false;

  programs.home-manager.enable = true;
}
