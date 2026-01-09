{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Search & Filter
    ripgrep
    fd
    jq
    
    # Help & Cheats
    navi
    cht-sh

    # Monitoring
    btop

    # Disk Management
    dua
    duf
    
    # AI
    gemini-cli

    # Build & Extraction
    gcc
    gnumake
    unzip
    wget
    curl
    tree-sitter
  ];

  programs.bash.shellAliases = {
    "?" = "cht.sh";
  };
}
