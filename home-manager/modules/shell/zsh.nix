{ ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      share = true;
    };

    autocd = true;

    shellAliases = {
      # Quick navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # System info
      ports = "ss -tulanp";
      myip = "curl -s ifconfig.me";

      # k3s
      k3s-start = "sudo systemctl start k3s";
      k3s-stop = "sudo systemctl stop k3s";
      k3s-status = "sudo systemctl status k3s";
      k3s-restart = "sudo systemctl restart k3s";
      k3s-logs = "sudo journalctl -u k3s -f";

      # Shortcuts
      k = "kubectl";
      d = "docker";
      dc = "docker-compose";
      tf = "terraform";
    };

    initContent = ''
      fastfetch
    '';
  };
}
