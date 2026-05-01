{ pkgs, ... }: {
  home.packages = with pkgs; [
    free-download-manager
  ];
}
