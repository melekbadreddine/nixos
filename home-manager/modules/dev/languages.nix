{pkgs, ...}: {
  home.packages = with pkgs; [
    go
    cargo
    nodejs
    bun
    python3
    jdk
  ];

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.bun/bin"
  ];
}
