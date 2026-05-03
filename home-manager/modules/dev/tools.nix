{ pkgs, ... }: {
  home.packages = with pkgs; [
    just
    alejandra
    sops
    age
  ];
}
