{pkgs, ...}: {
  home.packages = with pkgs; [
    btop
    dua
    duf
  ];
}
