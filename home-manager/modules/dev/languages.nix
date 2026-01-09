{ pkgs, ... }: {
  home.packages = with pkgs; [
    go
    cargo
    bun
    nodejs_22
  ];

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.bun/bin"
    "$HOME/.npm-global/bin"
  ];
}

