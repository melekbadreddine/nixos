{ ... }: {
  programs.bash = {
    enable = true;
    shellAliases = {
      # Quick navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Show all relevant files with names (excludes .json, .lock, .git, etc)
      showfiles = ''fd --type f --exclude "*.json" --exclude "*.lock" | while read -r file; do echo ""; echo "=== $file ==="; bat --color=always --style=plain "$file"; done'';
      
      # Nix management
      nix-switch = "home-manager switch --flake $HOME/.config/nix#melek";
      nix-update = "nix flake update --flake $HOME/.config/nix && home-manager switch --flake $HOME/.config/nix#melek";
      nix-edit = "fresh $HOME/.config/nix/";
      nix-gc = "nix-collect-garbage -d";

      # System info
      ports = "ss -tulanp";
      myip = "curl -s ifconfig.me";
    };
  };
}
