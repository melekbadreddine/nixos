{pkgs, ...}: {
  home.packages = with pkgs; [
    btop
    dua
    duf
    k9s
    lazydocker
  ];
}
