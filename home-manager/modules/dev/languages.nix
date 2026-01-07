{ pkgs, ... }: {
  home.packages = with pkgs; [
    go
    cargo
    bun
  ];
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.bun/bin"
  ];
}
