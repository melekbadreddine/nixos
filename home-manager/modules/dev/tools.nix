{ pkgs, ... }: {
  home.packages = with pkgs; [
    just
    alejandra
  ];
}
