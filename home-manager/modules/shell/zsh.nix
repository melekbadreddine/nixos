{ ... }: {
  programs.zsh = {
    enable = true;
    shellAliases = {
      # Quick navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Show all relevant files with names (excludes .json, .lock, .git, etc)
      showfiles = ''fd --type f --exclude "*.json" --exclude "*.lock" | while read -r file; do echo ""; echo "=== $file ==="; bat --color=always --style=plain "$file"; done'';

      # System info
      ports = "ss -tulanp";
      myip = "curl -s ifconfig.me";
    };
  };
}
