{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Core
    home-manager
    just
    alejandra
    sops
    age

    # Windows compatibility
    wineWow64Packages.stable
    winetricks

    # Helpers
    navi
    cht-sh

    # AI
    codex
    gemini-cli
    github-copilot-cli

    # Search & CLI
    ripgrep
    fd
    jq
    bat
    fzf
    zip
    unzip

    # Monitoring
    btop
    dua
    duf

    # Cloud & DevOps
    ansible
    azure-cli
    terraform
    terraform-ls
    tflint

    # Languages & Runtimes
    gcc
    go
    cargo
    nodejs
    bun
    python3
    jdk
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  programs.fish.enable = true;
  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
