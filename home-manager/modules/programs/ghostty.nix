{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      theme = "dark"; # Stylix will likely override this, but good as a fallback
      font-size = 15;
    };
  };
}
