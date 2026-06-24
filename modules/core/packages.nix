{pkgs, ...}: {
  # System Programs, Shells & Daemons
  programs.fish.enable = true;
  environment.shells = with pkgs; [fish];

  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Global Typography Infrastructure
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  # System Packages Ecosystem
  environment.systemPackages = with pkgs; [
    # NixOS Configuration Core
    home-manager
    just
    alejandra
    sops
    age

    # Nix Development Tools
    nil
    nix-output-monitor

    # Terminals & Workspace Environments
    antigravity
    warp-terminal

    # Cross-Platform Application Translation Layers
    wineWow64Packages.stable
    winetricks

    # Command-Line Cheat Sheets & Interactive Assistants
    navi
    cht-sh

    # AI Assistants
    fabric-ai
    claude-code
    antigravity-cli
    github-copilot-cli

    # Structured Search & CLI Navigation Tools
    ripgrep
    fd
    jq
    bat
    fzf
    tuxedo

    # Compression & Archiving Utilities
    zip
    unzip

    # Observation, Disk Auditing & System Monitoring
    btop
    dua
    duf

    # Cloud Engineering & IaC
    ansible
    terraform
    terraform-ls
    tflint

    # Systems Programming, Languages & Runtimes
    gcc
    go
    rustc
    cargo
    nodejs
    bun
    python3
    jdk

    # Build & Protocol Tools
    gnumake
    protobuf
  ];
}
