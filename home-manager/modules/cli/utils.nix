{ pkgs, ... }: {
  home.packages = with pkgs; [
      
    nautilus
    
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
    github-copilot-cli
  ];

  programs.bash.shellAliases = {
    "?" = "cht.sh";
  };
}
