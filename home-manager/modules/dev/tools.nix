{pkgs, ...}: {
  home.packages = with pkgs; [
    home-manager
    just
    alejandra
    sops
    age
  ];
}
