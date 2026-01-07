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
  ];

  programs.bash.shellAliases = {
    "?" = "cht.sh";
  };
}
