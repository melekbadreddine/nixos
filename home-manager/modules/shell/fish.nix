{ ... }: {
  programs.fish = {
    enable = true;
    shellAliases = {
      # Quick navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Show all relevant files with names (excludes .json, .lock, .git, etc)
      showfiles = "fd --type f --exclude '*.json' --exclude '*.lock' | while read -r file; echo ''; echo '=== '$file' ==='; bat --color=always --style=plain '$file'; end";

      # System info
      ports = "ss -tulanp";
      myip = "curl -s ifconfig.me";
    };
  };
}
