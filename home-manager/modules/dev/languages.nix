{ pkgs, ... }: {
  home.packages = with pkgs; [
    go
    cargo
    nodejs
    bun
  ];
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.bun/bin"
  ];
}
