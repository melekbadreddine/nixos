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
    go
    cargo
    nodejs
    bun
    python3
    python3Packages.requests
    jdk
  ];
}
