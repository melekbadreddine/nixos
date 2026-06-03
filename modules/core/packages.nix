{pkgs, ...}: {
  # System Programs, Shells & Daemons
  programs.fish.enable = true;
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
    codex
    gemini-cli
    github-copilot-cli

    # Structured Search & CLI Navigation Tools
    ripgrep
    fd
    jq
    bat
    fzf

    # Compression & Archiving Utilities
    zip
    unzip

    # Observation, Disk Auditing & System Monitoring
    btop
    dua
    duf

    # Cloud Engineering & IaC
    ansible
    azure-cli
    terraform
    terraform-ls
    tflint

    # Systems Programming, Languages & Runtimes
    gcc
    go
    cargo
    rustc
    nodejs
    bun
    python3
    jdk
  ];
}
