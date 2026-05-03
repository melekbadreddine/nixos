{...}: {
  programs.fish = {
    enable = true;
    shellAbbrs = {
      k = "kubectl";
      d = "docker";
      dc = "docker-compose";
      tf = "terraform";
    };
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
    };
    interactiveShellInit = ''
      set -g fish_greeting ""
      fastfetch
    '';
  };

  home.sessionVariables = {
    EDITOR = "fresh";
  };
}
