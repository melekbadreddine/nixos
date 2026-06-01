{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Core
    home-manager

    # Windows compatibility
    wineWow64Packages.stable
    winetricks

    # Tools
    just
    alejandra
    sops
    age

    # Utils
    nautilus
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

    # Cloud & DevOps
    ansible
    azure-cli
    terraform
    terraform-ls
    tflint

    # Languages & Runtimes
    go
    cargo
    nodejs
    bun
    python3
    python3Packages.requests
    jdk
  ];
}
