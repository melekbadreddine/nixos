{ ... }: {
  programs.bash = {
    enable = true;
    shellAliases = {
      # Quick navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # System info
      ports = "ss -tulanp";
      myip = "curl -s ifconfig.me";
    };

    initExtra = ''
      fastfetch
    '';
  };
}
