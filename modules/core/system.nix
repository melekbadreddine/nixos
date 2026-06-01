{
  pkgs,
  vars,
  ...
}: {
  # System settings
  system.stateVersion = "25.11";

  # Session Variables
  environment.sessionVariables = {
    TERMINAL = vars.terminal;
    EDITOR = vars.editor;
  };

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Global Behavior & Performance Optimizations
  documentation.nixos.enable = false;

  # Prevents fish from causing long build times
  documentation.man.cache.enable = false;

  # Enable nix-ld for running unpackaged programs
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];
}
