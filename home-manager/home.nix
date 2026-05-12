{...}: {
  imports = [
    ./modules
  ];

  home.username = "melek";
  home.homeDirectory = "/home/melek";

  home.packages = [
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
